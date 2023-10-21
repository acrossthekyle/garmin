#!/bin/zsh
#
# Copy classes from $SRC/src to build/source

#######################################
# Copy all src material
# Arguments:
#   none
# Returns:
#   none
#######################################

src::generate () {
	progress::bar

	cp -R "$SRC/src/." 'build/source'

	if [[ -f 'build/source/AppExtras.mc' ]]
	then
		rm 'build/source/AppExtras.mc'
	fi

	if [[ -f 'build/source/AppGlobals.mc' ]]
	then
		rm 'build/source/AppGlobals.mc'
	fi
}
