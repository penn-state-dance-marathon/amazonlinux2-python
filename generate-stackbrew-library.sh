#!/usr/bin/env bash
set -Eeuo pipefail

declare -A aliases=(
	[3.10-rc]='rc'
	[3.9]='3 latest'
)

defaultDebianSuite='bullseye'
declare -A debianSuites=(
	#[3.10-rc]='bullseye'
)
defaultAlpineVersion='3.14'

self="$(basename "$BASH_SOURCE")"
cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

versions=( */ )
versions=( "${versions[@]%/}" )

# sort version numbers with highest first
IFS=$'\n'; versions=( $(echo "${versions[*]}" | sort -rV) ); unset IFS

# get the most recent commit which modified any of "$@"
fileCommit() {
	git log -1 --format='format:%H' HEAD -- "$@"
}

# get the most recent commit which modified "$1/Dockerfile" or any file COPY'd from "$1/Dockerfile"
dirCommit() {
	local dir="$1"; shift
	(
		cd "$dir"
		fileCommit \
			Dockerfile \
			$(git show HEAD:./Dockerfile | awk '
				toupper($1) == "COPY" {
					for (i = 2; i < NF; i++) {
						print $i
					}
				}
			')
	)
}

getArches() {
	local repo="$1"; shift
	local officialImagesUrl='https://github.com/penn-state-dance-marathon/amazonlinux2-python/raw/main/library/'

	eval "declare -g -A parentRepoToArches=( $(
		find -name 'Dockerfile' -exec awk '
				toupper($1) == "FROM" && $2 !~ /^('"$repo"'|scratch|.*\/.*)(:|$)/ {
					print "https://github.com/penn-state-dance-marathon/amazonlinux2-python/raw/main/library/amazonlinux2-python"
				}
			' '{}' + \
			| sort -u \
			| xargs bashbrew cat --format '[{{ .RepoName }}:{{ .TagName }}]="{{ join " " .TagEntry.Architectures }}"'
	) )"
}
getArches 'amazonlinux2-python'

cat <<-EOH
# this file is generated via https://github.com/docker-library/python/blob/$(fileCommit "$self")/$self

Maintainers: Tianon Gravi <admwiggin@gmail.com> (@tianon),
             Joseph Ferguson <yosifkit@gmail.com> (@yosifkit)
GitRepo: https://github.com/docker-library/python.git
EOH

# prints "$2$1$3$1...$N"
join() {
	local sep="$1"; shift
	local out; printf -v out "${sep//%/%%}%s" "$@"
	echo "${out#$sep}"
}

for version in "${versions[@]}"; do
	rcVersion="${version%-rc}"

    dir="$version"

    [ -f "$dir/Dockerfile" ] || continue

    commit="$(dirCommit "$dir")"

    fullVersion="$(git show "$commit":"$dir/Dockerfile" | awk '$1 == "ENV" && $2 == "PYTHON_VERSION" { print $3; exit }')"

    versionAliases=(
        $fullVersion
        $version
        ${aliases[$version]:-}
    )

    variantAliases=( "${versionAliases[@]/%/-$variant}" )
    debianSuite="${debianSuites[$version]:-$defaultDebianSuite}"

    echo
    echo "Tags: $(join ', ' "${variantAliases[@]}")"
    if [ "${#sharedTags[@]}" -gt 0 ]; then
        echo "SharedTags: $(join ', ' "${sharedTags[@]}")"
    fi
    [[ "$v" == windows/* ]] && echo "Constraints: $variant"
done
