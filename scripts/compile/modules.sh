#!/bin/zsh
#
# Create a bundle of all modules (barrels) used in *.mc files

modules::findmatchesinfiles () {
	local matches=$(sed -n 's:.*using Keg\.\(.*\);.*:\1:p' $(find $1 -name '*.mc') | sort | uniq)

	echo $matches
}

modules::findmatchesinfile () {
	local matches=$(sed -n 's:.*using Keg\.\(.*\);.*:\1:p' $1 | sort | uniq)

	echo $matches
}

modules::import () {
	local moduleMatches=$1

	if [[ ${#moduleMatches[@]} > 0 ]]
	then
		echo $moduleMatches | while read module
		do
			local moduleName=${module##*.}
			local modulePath=${module//./\/}
			local prefix="${moduleName}"

			if [[ -f "modules/${modulePath}/${moduleName}.mc" ]]
			then
				cp "modules/${modulePath}/${moduleName}.mc" "build/modules/${prefix}_${moduleName}.mc"

				local matches=$(modules::findmatchesinfile "modules/${modulePath}/${moduleName}.mc")

				modules::import "$matches"
			fi

			for file in $(find "modules/${modulePath}" -maxdepth 1 -type f)
			do
		  	local fileName=${file##*/}
		  				fileName=${fileName//.mc/}

		  	local usage="$(tr '[:upper:]' '[:lower:]' <<< ${fileName:0:1})${fileName:1}"

				if [[ ! -z $(grep -R "${moduleName}.${fileName}" 'build') || ! -z $(grep -R "${moduleName}.${usage}" 'build') || ! -z $(grep -R "${moduleName}.method(:${usage})" 'build') ]]
			  then
			  	cp "modules/${modulePath}/${fileName}.mc" "build/modules/${prefix}_${fileName}.mc"

			  	local matches=$(modules::findmatchesinfile "modules/${modulePath}/${fileName}.mc")

			  	modules::import "$matches"
			  fi
			done
		done
	fi
}

modules::generate () {
	progress::bar

	cp 'modules/Keg.mc' 'build/modules/'

	local matches=$(modules::findmatchesinfiles 'build')

	modules::import "$matches"

	echo 'project.manifest = manifest.xml' > 'build/modules/modules.jungle'

	local products=""

	for device in "${DEVICES[@]}"
	do
		if [[ ! -z $device ]]
		then
			products="$products      <iq:product id=\"$device\"/>\n"
		fi
	done

	echo "<iq:manifest xmlns:iq=\"http://www.garmin.com/xml/connectiq\" version=\"3\">
  <iq:barrel id=\"f4bbc560befb4981aed4aaa8b491ae1b\" module=\"Keg\" version=\"0.0.1\">
    <iq:products>
${products}
    </iq:products>
  </iq:barrel>
</iq:manifest>" > 'build/modules/manifest.xml'
}
