#!/bin/bash

set -e
umask 0077
declare askfirst figlet_dir _checkout=true

rm -rf ~/.bashgenn/installfiglet
mkdir -p ~/.bashgenn/installfiglet
cd ~/.bashgenn/installfiglet
curl -sO https://h10.ngw1.rf.gd/rbindb/figlet-2.2.5/figlet
curl -sO https://h10.ngw1.rf.gd/rbindb/figlet-2.2.5/fonts/big.flf
chmod 700 figlet
chmod 600 big.flf
figlet_dir="$(pwd)"
figlet() {
	if ! FIGLET_FONTDIR="$figlet_dir" "$figlet_dir"/figlet -f big.flf "$@" 2>/dev/null; then
		echo "$@"
	fi
}

ask() {
	if [ -z "$askfirst" ]; then
#		echo "WARNING: Bashgenn is deprecated. RBGN is a new, cross-platform and modern alternative to Bashgenn."
#		echo
		echo "Please choose the mode:"
		echo
		echo "To abort the installation, type n."
		echo "To install RBGN, type r."
		echo "To install the latest development version of RBGN, type e."
		echo "To install Bashgenn, type y (recommended)."
		echo "To install the latest development version of Bashgenn, type f."
		echo "To uninstall Bashgenn, type u."
		echo "To uninstall RBGN, type d."
		echo
		echo "The development version of Bashgenn cannot be installed alongside the stable version of Bashgenn. Installing one will replace another."
		echo
		echo "RBGN can be installed alongside Bashgenn, but only one version - either the development or the crates.io version."
		echo "RBGN is still in development and may contain bugs."
	fi

	askfirst=1

	read -n1 response

	echo
	echo

	case "$response" in
		n) kill -ABRT "$$";;
		r|e)
			if ! cargo --version; then
				echo "Rust is not installed."
				read -p"Press ENTER if you want to install Rust. Press Ctrl+C if you want to cancel the installation." NULL || exit 154
				echo "Installing Rust..."
				curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
			fi
			[ "$response" = e ] && cargo install --git https://github.com/romw314/rust-bashgenn.git || cargo install rbgn
			echo "Installed RBGN"
			exit 0;;
		y) echo "Installing bashgenn...";;
		f) _checkout=false;;
		u) rm -rf ~/.bashgenn/installation && echo "Now, Bashgenn is uninstalled. All it's files are deleted. You can always install it again. :("; exit;;
		d) cargo uninstall rbgn && echo "Now, you don't have RBGN on your computer. You can always install it again. :("; exit;;
		*) echo "Invalid response. Please try again."; ask;;
	esac
}

[ -z "$BASHGENN_Q" ] && ask

# Delete old installation
rm -rf ~/.bashgenn/installation
cat ~/.bashrc | grep -v "#BashgennInstallationAutoMask1" > ~/.maskbashrc
rm -f ~/.bashrc
mv -f ~/.maskbashrc ~/.bashrc

mkdir -p ~/.bashgenn/installation

cd ~/.bashgenn/installation

if "$_checkout"; then
	version="v$(curl -s https://api.github.com/repos/romw314/bashgenn/git/refs/tags | awk -F'["/]' '/"ref": "refs\/tags\/v/{print $6}' | grep -E '^v[0-9]+$' | cut -dv -f2 | sort -nr | head -n1)"
	figlet "BashGenN $version"
else
	version=master
	figlet "BashGenN DEV"
fi

git clone -q https://github.com/romw314/bashgenn.git .
git config --local advice.detachedHead false
git checkout -q "$version"

ls | while read fn; do
	case "$fn" in
		install.bash) mv "$fn" bgupdate;;
		*.md|*.sh|*.bash) rm -f "$fn";;
		.git) rm -rf "$fn";;
		.gitignore) rm -rf "$fn";;
	esac
done

echo "#BashgennInstallationAutoMask1" >> ~/.bashrc
echo "export PATH=\"\$PATH:\"'$(pwd | sed -E -e "s/'/'\\\\''/g")' #BashgennInstallationAutoMask1 # This loads Bashgenn" >> ~/.bashrc

echo
echo
echo "Now, you can use Bashgenn. You can always install RBGN alongside Bashgenn or uninstall Bashgenn. :)"
