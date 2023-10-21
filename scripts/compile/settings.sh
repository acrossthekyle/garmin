#!/bin/zsh
#
# Create settings.xml file in /build/resources directory

#######################################
# Fill out template for setting
# Arguments:
#   $1 id, string
#   $2 config, string
# Returns:
#   string
#######################################

settings:setting () {
	echo "\n  <setting propertyKey=\"@Properties.$1\" title=\"@Strings.$1\">\n$2\n  </setting>\n"
}

#######################################
# Fill out template for alphaNumeric
# Arguments:
#   $1 id, string
# Returns:
#   string
#######################################

settings::alphanumeric () {
	local template='    <settingConfig type="alphaNumeric" required="true" maxLength="30" />'

	echo "$(settings:setting $1 $template)\n"
}

#######################################
# Fill out template for float numeric
# Arguments:
#   $1 id, string
# Returns:
#   string
#######################################

settings::float () {
	local template='    <settingConfig type="numeric" required="true" min="-180" max="180"/>'

	echo "$(settings:setting $1 $template)\n"
}

#######################################
# Fill out template for boolean
# Arguments:
#   $1 id, string
# Returns:
#   string
#######################################

settings::boolean () {
	local template='    <settingConfig type="boolean" />'

	echo "$(settings:setting $1 $template)\n"
}

#######################################
# Fill out template for colors
# Arguments:
#   $1 id, string
# Returns:
#   string
#######################################

settings::colors () {
	local template='    <settingConfig type="list">\n<listEntry value="0x000055">000055</listEntry>\n<listEntry value="0x0000AA">0000AA</listEntry>\n<listEntry value="0x0000FF">0000FF</listEntry>\n<listEntry value="0x005500">005500</listEntry>\n<listEntry value="0x005555">005555</listEntry>\n<listEntry value="0x0055AA">0055AA</listEntry>\n<listEntry value="0x0055FF">0055FF</listEntry>\n<listEntry value="0x00AA00">00AA00</listEntry>\n<listEntry value="0x00AA55">00AA55</listEntry>\n<listEntry value="0x00AAAA">00AAAA</listEntry>\n<listEntry value="0x00AAFF">00AAFF</listEntry>\n<listEntry value="0x00FF00">00FF00</listEntry>\n<listEntry value="0x00FF55">00FF55</listEntry>\n<listEntry value="0x00FFAA">00FFAA</listEntry>\n<listEntry value="0x00FFFF">00FFFF</listEntry>\n<listEntry value="0x550000">550000</listEntry>\n<listEntry value="0x550055">550055</listEntry>\n<listEntry value="0x5500AA">5500AA</listEntry>\n<listEntry value="0x5500FF">5500FF</listEntry>\n<listEntry value="0x555500">555500</listEntry>\n<listEntry value="0x555555">555555</listEntry>\n<listEntry value="0x5555AA">5555AA</listEntry>\n<listEntry value="0x5555FF">5555FF</listEntry>\n<listEntry value="0x55AA00">55AA00</listEntry>\n<listEntry value="0x55AA55">55AA55</listEntry>\n<listEntry value="0x55AAAA">55AAAA</listEntry>\n<listEntry value="0x55AAFF">55AAFF</listEntry>\n<listEntry value="0x55FF00">55FF00</listEntry>\n<listEntry value="0x55FF55">55FF55</listEntry>\n<listEntry value="0x55FFAA">55FFAA</listEntry>\n<listEntry value="0x55FFFF">55FFFF</listEntry>\n<listEntry value="0xAA0000">AA0000</listEntry>\n<listEntry value="0xAA0055">AA0055</listEntry>\n<listEntry value="0xAA00AA">AA00AA</listEntry>\n<listEntry value="0xAA00FF">AA00FF</listEntry>\n<listEntry value="0xAA5500">AA5500</listEntry>\n<listEntry value="0xAA5555">AA5555</listEntry>\n<listEntry value="0xAA55AA">AA55AA</listEntry>\n<listEntry value="0xAA55FF">AA55FF</listEntry>\n<listEntry value="0xAAAA00">AAAA00</listEntry>\n<listEntry value="0xAAAA55">AAAA55</listEntry>\n<listEntry value="0xAAAAAA">AAAAAA</listEntry>\n<listEntry value="0xAAAAFF">AAAAFF</listEntry>\n<listEntry value="0xAAFF00">AAFF00</listEntry>\n<listEntry value="0xAAFF55">AAFF55</listEntry>\n<listEntry value="0xAAFFAA">AAFFAA</listEntry>\n<listEntry value="0xAAFFFF">AAFFFF</listEntry>\n<listEntry value="0xFF0000">FF0000</listEntry>\n<listEntry value="0xFF0055">FF0055</listEntry>\n<listEntry value="0xFF00AA">FF00AA</listEntry>\n<listEntry value="0xFF00FF">FF00FF</listEntry>\n<listEntry value="0xFF5500">FF5500</listEntry>\n<listEntry value="0xFF5555">FF5555</listEntry>\n<listEntry value="0xFF55AA">FF55AA</listEntry>\n<listEntry value="0xFF55FF">FF55FF</listEntry>\n<listEntry value="0xFFAA00">FFAA00</listEntry>\n<listEntry value="0xFFAA55">FFAA55</listEntry>\n<listEntry value="0xFFAAAA">FFAAAA</listEntry>\n<listEntry value="0xFFAAFF">FFAAFF</listEntry>\n<listEntry value="0xFFFF00">FFFF00</listEntry>\n<listEntry value="0xFFFF55">FFFF55</listEntry>\n<listEntry value="0xFFFFAA">FFFFAA</listEntry>\n<listEntry value="0xFFFFFF">FFFFFF</listEntry>\n</settingConfig>'

	echo "$(settings:setting $1 $template)\n"
}

#######################################
# Fill out template for header
# Arguments:
#   $1 id, string
# Returns:
#   string
#######################################

settings::header () {
	local template='    <settingConfig type="alphaNumeric" readonly="true" />'

	echo "$(settings:setting $1 $template)\n"
}

#######################################
# Fill out template for list entry
# Arguments:
#   $1 name, string
#   $2 index, number
# Returns:
#   string
#######################################

settings::listentry () {
	echo "      <listEntry value=\"$2\">@Strings.$1_$2</listEntry>"
}

#######################################
# Fill out template for list entry
# Arguments:
#   $1 id, string
#   $2 entries, string
# Returns:
#   string
#######################################

settings::list () {
	local template="    <settingConfig type=\"list\">
$2
    </settingConfig>"

	echo "$(settings:setting $1 $template)\n"
}

#######################################
# Populate template
# Arguments:
#   $1 settings, string
# Returns:
#   none
#######################################

settings::populate () {
	echo "<settings>\n$1\n</settings>"
}

#######################################
# Generate settings.xml
# Arguments:
#   $1 config, json
# Returns:
#   none
#######################################

settings::generate () {
	progress::bar

	local settings=""

	jq -c '.properties[]' $1 | while read devDependency
	do
		local idPrefix=$(echo $devDependency | jq -r '.id')

		settings="$settings$(settings::header $idPrefix)"

		echo $devDependency | jq -c '.items[]' | while read item
	  do
	  	local id=$(echo $item | jq -r '.id')
			local type=$(echo $item | jq -r '.type')
			local default=$(echo $item | jq -r '.default')
			local options=$(echo $item | jq -r '.options?')

			id="${idPrefix}_${id}"

			if [[ $type == 'alphaNumeric' ]]
			then
				settings="$settings$(settings::alphanumeric $id)\n"
			elif [[ $type == 'float' ]]
			then
				settings="$settings$(settings::float $id)\n"
			elif [[ $type == 'boolean' ]]
			then
				settings="$settings$(settings::boolean $id)\n"
			elif [[ $type == 'color' ]]
			then
				settings="$settings$(settings::colors $id)\n"
			elif [[ $type == 'number' ]]
			then
				local entries=""

				for (( i=0; i<$options; i++ ))
				do
				   entries="$entries$(settings::listentry $id $i)\n"
				done

				settings="$settings$(settings::list $id $entries)\n"
			fi
		done
	done

	echo "$(settings::populate $settings)" > 'build/resources/settings.xml'

	files::clean::emptylines 'build/resources/settings.xml'
}
