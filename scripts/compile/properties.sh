#!/bin/zsh
#
# Create properties.xml file in /build/resources directory

#######################################
# Fill out template for property
# Arguments:
#   $1 id, string
#   $2 type, string
#   $3 value, string|boolean|number
# Returns:
#   string
#######################################

properties::property () {
	echo "<property id=\"$1\" type=\"$2\">$3</property>"
}

#######################################
# Populate template
# Arguments:
#   $1 properties, string
# Returns:
#   none
#######################################

properties::populate () {
	echo "<properties>
$1
</properties>"
}

#######################################
# Generate properties.xml
# Arguments:
#   $1 config, json
# Returns:
#   none
#######################################

properties::generate () {
	progress::bar

	local properties=""

	jq -c '.properties[]' $1 | while read devDependency
	do
		local idPrefix=$(echo $devDependency | jq -r '.id')

		properties="$properties  $(properties::property $idPrefix 'string' '#########')\n"

		echo $devDependency | jq -c '.items[]' | while read item
	  do
	  	local id=$(echo $item | jq -r '.id')
			local type=$(echo $item | jq -r '.type')
			local value=$(echo $item | jq -r '.default')

			if [[ $type == 'alphaNumeric' ]]
			then
				type='string'
			elif [[ $type == 'color' ]]
			then
				type='number'
			fi

			properties="$properties  $(properties::property "${idPrefix}_${id}" $type $value)\n"
		done
	done

	echo "$(properties::populate $properties)" > 'build/resources/properties.xml'

	files::clean::emptylines 'build/resources/properties.xml'
}
