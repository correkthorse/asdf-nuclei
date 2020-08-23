#!/usr/bin/env bash

set -euo pipefail

# TODO: Ensure this is the correct GitHub homepage where releases can be downloaded for nuclei.
GH_REPO="https://github.com/projectdiscovery/nuclei"

fail() {
  echo -e "asdf-nuclei: $*"
  exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if nuclei is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' | cut -d/ -f3- |
    sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
  # TODO: Adapt this. By default we simply list the tag names from GitHub releases.
  # Change this function if nuclei has other means of determining installable versions.
  list_github_tags
}

get_os () {
  local os=""
  case $(uname) in
      Linux)    os="linux" ;;
      Windows)  os="windows" ;;
      mac)      os="macOS" ;;
  esac
  echo ${os}
}

get_arch () {
  local architecture=""
  case $(uname -m) in
    i386)   architecture="386" ;;
    i686)   architecture="386" ;;
    x86_64) architecture="amd64" ;;
    arm)    dpkg --print-architecture | grep -q "arm64" && architecture="arm64" || architecture="arm" ;;
  esac
  echo ${architecture}
}

download_release() {
  local version filename url
  local suffix="$(get_os)_$(get_arch).tar.gz"
  version="$1"
  filename="$2"

  url="${GH_REPO}/releases/download/v${version}/nuclei_${version}_${suffix}"

  echo "* Downloading nuclei release $version..."
  curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="$3"

  if [ "$install_type" != "version" ]; then
    fail "asdf-nuclei supports release installs only"
  fi

  if [ "$(get_os)" == "window" ]; then
    fail "asdf-nuclei does not support windows installs"
  fi

  local release_file="$install_path/nuclei-$version.$(get_file_ext)"
  (
    mkdir -p "$install_path"
    download_release "$version" "$release_file"
    tar -xzf "$release_file" -C "$install_path" --strip-components=1 || fail "Could not extract $release_file"
    rm "$release_file"

    # TODO: Asert nuclei executable exists.
    local tool_cmd
    tool_cmd="$(echo "nuclei --version" | cut -d' ' -f2-)"
    test -x "$install_path/bin/$tool_cmd" || fail "Expected $install_path/bin/$tool_cmd to be executable."

    echo "nuclei $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error ocurred while installing nuclei $version."
  )
}
