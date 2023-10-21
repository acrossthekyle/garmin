#!/bin/zsh
#
# Reset build folder

#######################################
# Prepare build folder
# Arguments:
#   none
# Returns:
#   array
#######################################

build::prepare () {
	progress::bar

  if [[ -d build ]]
	then
		rm -r build
	fi

	mkdir -p build
	mkdir -p build/modules
	mkdir -p build/source
	mkdir -p build/resources
	mkdir -p build/i18n
}

#######################################
# Clean build folder
# Arguments:
#   none
# Returns:
#   array
#######################################

build::clean () {
	progress::bar

	if [[ $TYPE == 'datafield' ]]
	then
	  if [[ -f 'build/source/Menu.mc' ]]
		then
			rm 'build/source/Menu.mc'
			rm 'build/source/SubMenu.mc'
			rm 'build/source/SubMenuSelect.mc'
		fi
	fi
}
