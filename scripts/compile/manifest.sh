#!/bin/zsh
#
# Create manifest.xml file in /build directory

#######################################
# Fill out template for manifest
# Arguments:
#   $1 id, string
#   $2 sdk, string
#   $3 name, string
#   $4 type, string
#   $5 version, string
#   $6 products, string
#   $7 permissions, string
# Returns:
#   string
#######################################

manifest::populate () {
	echo "<iq:manifest xmlns:iq=\"http://www.garmin.com/xml/connectiq\" version=\"3\">
  <iq:application entry=\"App\" id=\"$1\" launcherIcon=\"@Drawables.LauncherIcon\" minSdkVersion=\"$2\" name=\"@Strings.$3\" type=\"$4\" version=\"$5\">
    <iq:barrels>
      <iq:depends name=\"Keg\" version=\"0.0.1\"/>
    </iq:barrels>
    <iq:products>
$6
    </iq:products>
    <iq:permissions>
$7
    </iq:permissions>
    <iq:languages>
      <iq:language>bul</iq:language>
      <iq:language>ces</iq:language>
      <iq:language>dan</iq:language>
      <iq:language>deu</iq:language>
      <iq:language>dut</iq:language>
      <iq:language>eng</iq:language>
      <iq:language>est</iq:language>
      <iq:language>fin</iq:language>
      <iq:language>fre</iq:language>
      <iq:language>hun</iq:language>
      <iq:language>hrv</iq:language>
      <iq:language>ind</iq:language>
      <iq:language>ita</iq:language>
      <iq:language>jpn</iq:language>
      <iq:language>kor</iq:language>
      <iq:language>lav</iq:language>
      <iq:language>lit</iq:language>
      <iq:language>nob</iq:language>
      <iq:language>pol</iq:language>
      <iq:language>por</iq:language>
      <iq:language>ron</iq:language>
      <iq:language>rus</iq:language>
      <iq:language>slo</iq:language>
      <iq:language>spa</iq:language>
      <iq:language>swe</iq:language>
      <iq:language>tur</iq:language>
      <iq:language>ukr</iq:language>
      <iq:language>vie</iq:language>
      <iq:language>zsm</iq:language>
      <iq:language>zhs</iq:language>
      <iq:language>zht</iq:language>
    </iq:languages>
  </iq:application>
</iq:manifest>"
}

#######################################
# Generate manifest.xml
# Arguments:
#   $1 config, json
# Returns:
#   none
#######################################

manifest::generate () {
  if [[ $3 != false ]]
  then
    progress::bar
  fi

	local id=$(jq -r '.id' $1)
	local name=$(jq -r '.name' $1)
	local type=$TYPE
	local version=$(jq -r '.version' $1)
	local modules=($(jq -r '.modules' $1 | tr -d '[]," '))

	local products=""

	for device in "${DEVICES[@]}"
	do
    if [[ ! -z $device ]]
    then
      products="$products      <iq:product id=\"$device\"/>\n"
    fi
	done

	local permissions=""

	for module in "${modules[@]}"
	do
		permissions="$permissions      <iq:uses-permission id=\"$module\"/>\n"
	done

  local sdk="3.3.0"

  if [[ $TYPE == 'app' ]]
  then
    type="watch-app"
  fi

  if [[ $TYPE == 'watchface' ]]
  then
    name="${name// /}"
  fi

  if [[ $2 == true ]]
  then
    id=${id:0:$((${#id}-4))}bbbb

    version="$version.$(date +%s)"

    echo "\nVersion: $version"
  fi

	echo "$(manifest::populate $id $sdk $name $type $version $products $permissions)" > 'build/manifest.xml'

  files::clean::emptylines 'build/manifest.xml'
}
