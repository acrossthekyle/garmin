#!/bin/zsh
#
# Create App.mc file in /build/source directory

app::annotation () {
	local annotation=''

	for module in "${1[@]}"
	do
		if [[ $module == 'Background' ]]
		then
			annotation=' :background'
		fi
	done

	if [[ ! -z $annotation ]]
	then
		echo "$annotation"
	else
		echo ''
	fi
}

app::widget () {
	local template="$(cat 'modules/AppBase/WidgetAppBase.mc')"

	local result=$(echo "$template" | sed "s/ {{annotation}}/$1/")

	echo "$result" > 'build/source/App.mc'
}

app::application () {
	local template="$(cat 'modules/AppBase/ApplicationAppBase.mc')"

	echo "$template" > 'build/source/App.mc'
}

app::datafield () {
	local template="$(cat 'modules/AppBase/DataFieldAppBase.mc')"

	echo "$template" > 'build/source/App.mc'
}

app::watchface () {
	local template="$(cat 'modules/AppBase/WatchfaceAppBase.mc')"

	echo "$template" > 'build/source/App.mc'
}

app::generate () {
	progress::bar

	local modules=($(jq -r '.modules' $1 | tr -d '[]," '))

	local annotation=$(app::annotation "$modules")

	if [[ $TYPE == 'widget' ]]
	then
		app::widget "$annotation"
	elif [[ $TYPE == 'app' ]]
	then
		app::application "$annotation"
	elif [[ $TYPE == 'watchface' ]]
	then
		app::watchface "$annotation"
	elif [[ $TYPE == 'datafield' ]]
	then
		app::datafield "$annotation"
	fi
}
