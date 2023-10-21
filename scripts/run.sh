#!/bin/zsh

if [[ -z $(which jq) ]]
then
	echo 'Must install jq in order to use these scripts'

	return 0
fi

COMPILE=true

if [[ $@ == *'--no-compile'* || $@ == *'-n'* ]]
then
	COMPILE=false
fi

source scripts/options/options.sh
source scripts/paths/paths.sh

if [[ $COMPILE == true ]]
then
	source scripts/compile/compile.sh "${TYPE}s/${PROGRAM}"

	echo "\nCompiling"
else
	echo 'Compiling'
fi

monkeyc -d "$DEVICE" -f 'build/project.jungle' -o 'build/compiled/build.prg' -y ~/.ssh/garmin.der -l '0' >/dev/null

if [[ -f 'build/compiled/build.prg' ]]
then
	echo 'Starting'

	connectiq

	monkeydo 'build/compiled/build.prg' "$DEVICE"
fi
