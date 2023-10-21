#!/bin/zsh
#
# Create drawables.xml file in /build/resources* directories

#######################################
# Fill out template for bitmap
# Arguments:
#   $1 id, string
#   $2 name, string
#   $3 size, string
#   $4 color, string
# Returns:
#   string
#######################################

drawables::bitmap () {
	local template="  <bitmap id=\"$id\" filename=\"../../images/$name@$size.png\">\n    <palette disableTransparency=\"false\">\n      <color>$color</color>\n    </palette>\n  </bitmap>"

	echo "$template"
}

#######################################
# Fill out template for bitmap
# Arguments:
#   $1 id, string
#   $2 name, string
#   $3 size, string
#   $4 color, string
#   $5 x, string
#   $6 y, string
# Returns:
#   string
#######################################

drawables::bitmapxy () {
	local template="    <bitmap id=\"${1}BitmapId\" x=\"$5\" y=\"$6\" filename=\"../../images/$2@$3.png\">\n      <palette disableTransparency=\"false\">\n        <color>$4</color>\n      </palette>\n    </bitmap>"

	echo "$(drawables::drawablelist $1 $template)"
}

#######################################
# Fill out template for circle
# Arguments:
#   $1 radius, string
#   $2 color, string
#   $3 x, string
#   $4 y, string
# Returns:
#   string
#######################################

drawables::circle () {
	local template="    <shape type=\"circle\" x=\"$3\" y=\"$4\" radius=\"$1\" color=\"Graphics.$2\" />"

	echo "$template"
}

#######################################
# Fill out template for rectangle
# Arguments:
#   $1 width, string
#   $2 height, string
#   $3 color, string
#   $4 x, string
#   $5 y, string
# Returns:
#   string
#######################################

drawables::rectangle () {
	local template="    <shape type=\"rectangle\" x=\"$4\" y=\"$5\" width=\"$1\" height=\"$2\" color=\"Graphics.$3\" />"

	echo "$template"
}

#######################################
# Fill out template for drawable-list
# Arguments:
#   $1 id, string
#   $2 content, string
# Returns:
#   string
#######################################

drawables::drawablelist () {
	local template="  <drawable-list id=\"$1\">\n$2\n  </drawable-list>"

	echo "$template"
}

#######################################
# Populate template
# Arguments:
#   $1 drawables, string
# Returns:
#   none
#######################################

drawables::populate () {
	echo "<drawables>\n$1\n</drawables>"
}

#######################################
# Generate drawables.xml
# Arguments:
#   $1 config, json
# Returns:
#   none
#######################################

drawables::generate () {
	progress::bar

	local count=$(jq -r '.drawables | length' $1)
	local json=$1

	if [[ $count = 1 ]]
	then
		json="$SRC/$(jq -r '.drawables[0]' $1)"
	fi

	jq -c '.drawables[]' $json | while read drawable
	do
		local suffix=$(echo $drawable | jq -r '.suffix')
		local folder='build/resources'
		local drawables=""

		if [[ ! -z $suffix ]]
		then
			folder="$folder-$suffix"
		fi

	  mkdir -p $folder

		echo $drawable | jq -c '.items[]' | while read item
	  do
	  	local type=$(echo $item | jq -r '.type')
	  	local id=$(echo $item | jq -r '.id')
	  	local name=$(echo $item | jq -r '.name')
	  	local size=$(echo $item | jq -r '.size')
	  	local color=$(echo $item | jq -r '.color')
	  	local x=$(echo $item | jq -r '.x?')
			local y=$(echo $item | jq -r '.y?')

			if [[ $type == 'bitmap' ]]
			then
				drawables="$drawables$(drawables::bitmap $id $name $size $color)\n"
			elif [[ $type == 'drawable-list' ]]
			then
				drawables="$drawables$(drawables::bitmapxy $id $name $size $color $x $y)\n"
			elif [[ $type == 'shapes' ]]
			then
				local shapes=""

				echo $item | jq -c '.shapes[]' | while read shape
				do
					local shapeType=$(echo $shape | jq -r '.type')
	  			local shapeX=$(echo $shape | jq -r '.x')
	  			local shapeY=$(echo $shape | jq -r '.y')
	  			local shapeColor=$(echo $shape | jq -r '.color')
	  			local shapeRadius=$(echo $shape | jq -r '.radius')
	  			local shapeWidth=$(echo $shape | jq -r '.width')
	  			local shapeHeight=$(echo $shape | jq -r '.height')

	  			if [[ $shapeType == *'circle'* ]]
	  			then
	  				shapes="$shapes$(drawables::circle $shapeRadius $shapeColor $shapeX $shapeY)\n"
	  			elif [[ $shapeType == *'rectangle'* ]]
	  			then
	  				shapes="$shapes$(drawables::rectangle $shapeWidth $shapeHeight $shapeColor $shapeX $shapeY)\n"
	  			fi
				done

				drawables="$drawables$(drawables::drawablelist $id $shapes)\n"
			fi
	  done

	  echo "$(drawables::populate $drawables)" > "$folder/drawables.xml"

	  files::clean::emptylines "$folder/drawables.xml"
	done
}
