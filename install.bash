#!/bin/bash -e

declare askfirst

ask() {
	if [ -z "$askfirst" ]; then
		echo "WARNING: Bashgenn is deprecated. RBGN is a new, cross-platform and modern alternative to Bashgenn."
		echo
		echo "Please choose the mode:"
		echo
		echo "To abort the installation, type n."
		echo "To install RBGN, type r."
		echo "To install Bashgenn, type y (not recommended)."
		echo "To uninstall Bashgenn, type u."
		echo "To uninstall RBGN, type d."
	fi

	askfirst=1

	read -n1 response

	echo
	echo

	case "$response" in
		n) kill -ABRT "$$";;
		r)
			if ! cargo --version; then
				echo "Rust is not installed."
				read -p"Press ENTER if you want to install Rust. Press Ctrl+C if you want to cancel the installation." NULL || exit 154
				echo "Installing Rust..."
				curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
			fi
			cargo install --git https://github.com/romw314/rust-bashgenn.git
			echo "Installed RBGN"
			exit 0;;
		y) echo "WARNING: Bashgenn is deprecated. Read more at https://github.com/romw314/bashgenn/#readme";;
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

echo >> ~/.bashrc
echo "export PATH=\"\$PATH:\"'$(pwd | sed -E -e "s/'/'\\\\''/g")' #BashgennInstallationAutoMask1 # This loads Bashgenn" >> ~/.bashrc

echo
echo
echo "Now, you can use Bashgenn. You can always install RBGN alongside Bashgenn or uninstall Bashgenn. :)"
