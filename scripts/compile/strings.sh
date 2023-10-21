#!/bin/zsh

strings::generate () {
	progress::bar

	local name=$(jq -r '.name' $1)

	local languages=('bul' 'ces' 'dan' 'deu' 'dut' 'eng' 'est' 'fin' 'fre' 'hrv' 'hun' 'ind' 'ita' 'jpn' 'kor' 'lav' 'lit' 'nob' 'pol' 'por' 'ron' 'rus' 'slo' 'slv' 'spa' 'swe' 'tur' 'ukr' 'vie' 'zhs' 'zht' 'zsm')

	for key in "${languages[@]}"
	do
		if [[ $key == 'eng' ]]
		then
			echo '<strings>' > 'build/resources/strings.xml'
			echo '  <string id="Blank"></string>' >> 'build/resources/strings.xml'

			if [[ $TYPE == 'watchface' ]]
			then
				echo "  <string id=\"${name// /}\">${name// /}</string>" >> 'build/resources/strings.xml'
			fi
		else
			mkdir -p "build/i18n/$key"
		  touch "build/i18n/$key/$key.xml"
		  echo '<strings>' > "build/i18n/$key/$key.xml"
		fi
	done

	local mc=$(sed -n 's:.*I18n\.t(\:\(.*\)).*:\1:p' $(find 'build' -name '*.mc') | sort | uniq)
	local xml=$(sed -n 's:.*@Strings\.\(.*\).*:\1:p' 'build/resources/settings.xml' | sort | uniq)

	local matches=( "${mc[@]}" "\n" "${xml[@]}" )

	local formatted=()

	echo $matches | sort | uniq | while read id
	do
		# cleans I18n matches
		id=${id/\)\.toUpper\(/}

		# cleans .xml matches
		id=${id%%\"*}
		id=${id%%<*}

		formatted+=($id)
	done

	matches=($(echo "${formatted[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))

	for id in "${matches[@]}"
	do
		local i18ns=$(grep -nr "\"$id\"" 'i18n')

		echo $i18ns | while read i18n
		do
			local string=${i18n##*:}

			local language=${i18n%%<*}
						language=${i18n%%:*}
		  			language=${language//.xml/}
		  			language=${language/i18n\//}

		  if [[ $language == 'eng' ]]
		  then
		  	echo "  $string" >> 'build/resources/strings.xml'
		  else
		  	echo "  $string" >> "build/i18n/$language/$language.xml"
		  fi
		done
	done

	for key in "${languages[@]}"
	do
		if [[ $key == 'eng' ]]
		then
			echo '</strings>' >> 'build/resources/strings.xml'
		else
			echo '</strings>' >> "build/i18n/$key/$key.xml"
		fi
	done
}
