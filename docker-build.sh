#!/bin/bash

set -eu

if [ -n "$(git status --porcelain=v1)" ]; then
	echo "Please commit or stash changes first!"
	exit 2
fi

do_cmd() {
	if [ ! "$dryrun" = "true" ]; then
		echo "$1"
		shift
		"$@"
	else
		shift
		if [ "$#" -eq 1 -a "$(type -t "$1")" = function ]; then
			echo ":: $(type "$1" | sed -E '1,3d;$d;s/ {4}//')"
		else
			echo ":: $*"
		fi
	fi
}

docker_tag() {
	do_cmd "Tagging $1 as $2..." docker tag "$1" "$2"
	images+=("$2")
}

rm_old() {
	docker image ls "$imgname" --format '{{.Tag}}' | awk -v repo="$imgname" '{print repo":"$0}' | xargs -n20 docker rmi
}

[ -n "${DEBUG:-}" ] && set -x

# Change this line when adopting the script to another project
readonly default_owner=romw314 name=bashgenn fullname=Bashgenn

declare -A base
base[debian]=debian:bullseye
base[alpine]=bash:5.2-alpine3.19
readonly base

declare -A variantver
variantver[alpine]=alpine3.19
variantver[debian]=bullseye
readonly variantver

readonly imgname="${owner:-"$default_owner"}/$name"

declare dryrun all push

if grep -q dryrun <<< "$*"; then
	dryrun=true
else
	dryrun=false
fi

if grep -q push <<< "$*"; then
	push=true
else
	push=false
fi

if grep -q all <<< "$*"; then
	do_cmd "Deleting old images..." rm_old
	all=true
else
	all=false
fi

if ! grep -q build <<< "$*"; then
	(
		echo "docker-build.sh - Script for building $fullname's docker image"
		echo
		echo "Usage: $0 build [dryrun] [all] [push]"
		echo
		echo "The \`dryrun' flag makes the script print Docker commands but does not actually run them."
		echo "The \`all' flag makes the script delete all existing images for the repo and rebuild them."
		echo "The \`push' flag makes the script push the images to Docker Hub."
		echo
		echo "Run with DEBUG=1 to print all commands executed."
	) >&2
	exit 1
fi

readonly dryrun all

readonly latestver="v$(git tag --list | grep -E 'v[0-9]+' | cut -dv -f2 | sort -n | head -n1)"

declare -a images

for variant in debian alpine; do
	for version in $(git tag --list | grep -E 'v[0-9]+'); do
		do_cmd "Resetting git changes..." git reset --hard
		do_cmd "Checking out $version..." git checkout "$version"
		do_cmd "Adding master's Dockerfile..." git checkout master Dockerfile docker-build.sh

		tagname="$version-${variantver["$variant"]}"

		if [ ! "$all" = "true" ] && docker image ls "$imgname" --format '{{.Tag}}' | awk -v tag="$tagname" '$0==tag{print "skip"}' | grep -q skip; then
			echo "Skipped $imgname:$tagname."
			continue
		fi

		do_cmd "Building $imgname:$tagname..." docker build -t "$imgname:$tagname" \
			--build-arg VARIANT="$variant" \
			--build-arg BASHGENN_VERSION="$version" \
			--build-arg BASE="${base["$variant"]}" \
			.

		images+=("$imgname:$tagname")
	done
done

# Debian
docker_tag "$imgname:$latestver-${variantver[debian]}" "$imgname:$latestver"
docker_tag "$imgname:$latestver" "$imgname:latest"

# Alpine Linux
docker_tag "$imgname:$latestver-${variantver[alpine]}" "$imgname:${variantver[alpine]}"
docker_tag "$imgname:$latestver-${variantver[alpine]}" "$imgname:$latestver-alpine"
docker_tag "$imgname:${variantver[alpine]}" "$imgname:alpine"

if [ "$push" = "true" ]; then
	for img in "${images[@]}"; do
		do_cmd "Pushing $img to Docker Hub..." docker push "$img"
	done
fi
