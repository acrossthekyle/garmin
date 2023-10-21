#!/bin/zsh

if [[ -z $(which jq) ]]
then
	echo 'Must install jq in order to use these scripts'

	return 0
fi

if [[ -z $(which git) ]]
then
	echo 'Must install git in order to use these scripts'

	return 0
fi

source scripts/options/options.sh
source scripts/paths/paths.sh

GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

if [[ $GIT_BRANCH != 'main' ]]
then
	echo 'Intermixing'

	git checkout 'main' &>/dev/null

	git merge "development/$PROGRAM-$TYPE" &>/dev/null

	git add -A && git commit -m "DEV -> MAIN $PROGRAM" &>/dev/null

	git push -u origin &>/dev/null
fi

source scripts/compile/compile.sh "${TYPE}s/${PROGRAM}"

echo "\nCompiling"

monkeyc -f 'build/project.jungle' -o 'build/compiled/release.iq' -y ~/.ssh/garmin.der -e -r -l '0'
