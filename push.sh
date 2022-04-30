###
## Automate building latest demo and supporter packages and packing for repos
###

#dpkg-scanpackages debs /dev/null >Packages
#cd ./debs
#../gen.sh > ../Release
#cd ../

#rm -rf Packages.bz2

#bzip2 -fks Packages

#./gen.sh


if [[ "$(uname)" == Darwin ]] && [[ "$(uname -p)" != i386 ]]; then # iOS/iPadOS usage of repo.me
    cd "$(dirname "$0")" || exit
    echo "Checking for apt-ftparchive..."
    if test ! "$(apt-ftparchive)"; then
        apt update && apt install apt-utils -y
    fi

    rm {Packages{,.xz,.gz,.bz2,.zst},Release{,.gpg}} 2> /dev/null

    apt-ftparchive packages ./debs > Packages
    gzip -c9 Packages > Packages.gz
    xz -c9 Packages > Packages.xz
    zstd -c19 Packages > Packages.zst
    bzip2 -c9 Packages > Packages.bz2

    apt-ftparchive release -c ./assets/repo/repo.conf . > Release

    echo "Repository Updated, thanks for using repo.me!"
else
    echo "Running an unsupported operating system...? Contact me via Twitter @truesyns" # incase I've missed support for something, they should be contacting me.
fi


#######################################

git add .

echo "Enter your commit message: "
while read tmsg #[ "$tmsg" != "\n" ]
do
	if [[ $tmsg == "" ]]; then
		break
	fi
	if [[ "$msg" == "" ]]; then
		msg="$tmsg"
	else
		msg="$msg
		$tmsg"
	fi
done
git commit -m "$msg"
git push