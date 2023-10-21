#!/bin/zsh

if [[ -z $(which git) ]]
then
	echo 'Must install git in order to use these scripts'

	return 0
fi

source scripts/options/options.sh
source scripts/paths/paths.sh
source scripts/compile/manifest.sh

GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

if [[ $GIT_BRANCH != "development/$PROGRAM-$TYPE" ]]
then
	echo "Must be on development/$PROGRAM-$TYPE branch to continue"

	return 0;
fi

source scripts/compile/compile.sh "${TYPE}s/${PROGRAM}"

manifest::generate $CONFIG true false

echo 'Compiling'

monkeyc -f 'build/project.jungle' -o 'build/compiled/beta.iq' -y ~/.ssh/garmin.der -e -r -l '0'
