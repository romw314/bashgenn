#!/bin/bash -e

declare askfirst _checkout=true

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
		echo "The development version of Bashgenn cannot be installed alongside the stable version of Bashgenn. Installing the one will replace another."
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
rm -vrf ~/.bashgenn/installation
cat ~/.bashrc | grep -v "#BashgennInstallationAutoMask1" > ~/.maskbashrc
rm -vf ~/.bashrc
mv -vf ~/.maskbashrc ~/.bashrc

mkdir -vp ~/.bashgenn/installation

cd ~/.bashgenn/installation

git clone https://github.com/romw314/bashgenn.git .

git config --local advice.detachedHead false

"$_checkout" && git checkout "v$(git tag --list | grep -E '^v[0-9]+$' | cut -dv -f2 | sort -nr | head -n1)"

echo "#BashgennInstallationAutoMask1" >> ~/.bashrc
echo "export PATH=\"\$PATH:\"'$(pwd | sed -E -e "s/'/'\\\\''/g")' #BashgennInstallationAutoMask1 # This loads Bashgenn" >> ~/.bashrc

echo
echo
echo "Now, you can use Bashgenn. You can always install RBGN alongside Bashgenn or uninstall Bashgenn. :)"
