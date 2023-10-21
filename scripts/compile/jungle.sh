#!/bin/zsh
#
# Create project.jungle file in /build directory

#######################################
# Return i18n paths
# Arguments:
#   none
# Returns:
#   string
#######################################

jungle::i18n () {
	echo 'base.lang.bul = ./i18n/bul
base.lang.ces = ./i18n/ces
base.lang.dan = ./i18n/dan
base.lang.deu = ./i18n/deu
base.lang.dut = ./i18n/dut
base.lang.est = ./i18n/est
base.lang.fin = ./i18n/fin
base.lang.fre = ./i18n/fre
base.lang.hrv = ./i18n/hrv
base.lang.hun = ./i18n/hun
base.lang.ind = ./i18n/ind
base.lang.ita = ./i18n/ita
base.lang.jpn = ./i18n/jpn
base.lang.kor = ./i18n/kor
base.lang.lav = ./i18n/lav
base.lang.lit = ./i18n/lit
base.lang.nob = ./i18n/nob
base.lang.pol = ./i18n/pol
base.lang.por = ./i18n/por
base.lang.ron = ./i18n/ron
base.lang.rus = ./i18n/rus
base.lang.slo = ./i18n/slo
base.lang.spa = ./i18n/spa
base.lang.swe = ./i18n/swe
base.lang.tur = ./i18n/tur
base.lang.ukr = ./i18n/ukr
base.lang.vie = ./i18n/vie
base.lang.zhs = ./i18n/zhs
base.lang.zht = ./i18n/zht
base.lang.zsm = ./i18n/zsm'
}

#######################################
# Return memory exclusions
# Arguments:
#   none
# Returns:
#   string
#######################################

jungle::exclusions::memory () {
	echo 'approachs7042mm.excludeAnnotations = excludeFromHighMemoryDevices
approachs7047mm.excludeAnnotations = excludeFromHighMemoryDevices
d2airx10.excludeAnnotations = excludeFromHighMemoryDevices
d2mach1.excludeAnnotations = excludeFromHighMemoryDevices
descentmk2.excludeAnnotations = excludeFromHighMemoryDevices
descentmk2s.excludeAnnotations = excludeFromLowMemoryDevices
enduro.excludeAnnotations = excludeFromLowMemoryDevices
epix2.excludeAnnotations = excludeFromHighMemoryDevices
epix2pro42mm.excludeAnnotations = excludeFromHighMemoryDevices
epix2pro47mm.excludeAnnotations = excludeFromHighMemoryDevices
epix2pro51mm.excludeAnnotations = excludeFromHighMemoryDevices
fenix5.excludeAnnotations = excludeFromLowMemoryDevices
fenix5plus.excludeAnnotations = excludeFromLowMemoryDevices
fenix5s.excludeAnnotations = excludeFromLowMemoryDevices
fenix5splus.excludeAnnotations = excludeFromLowMemoryDevices
fenix5x.excludeAnnotations = excludeFromLowMemoryDevices
fenix5xplus.excludeAnnotations = excludeFromLowMemoryDevices
fenix6.excludeAnnotations = excludeFromLowMemoryDevices
fenix6pro.excludeAnnotations = excludeFromLowMemoryDevices
fenix6s.excludeAnnotations = excludeFromLowMemoryDevices
fenix6spro.excludeAnnotations = excludeFromLowMemoryDevices
fenix6xpro.excludeAnnotations = excludeFromHighMemoryDevices
fenix7.excludeAnnotations = excludeFromHighMemoryDevices
fenix7pro.excludeAnnotations = excludeFromHighMemoryDevices
fenix7s.excludeAnnotations = excludeFromHighMemoryDevices
fenix7spro.excludeAnnotations = excludeFromHighMemoryDevices
fenix7x.excludeAnnotations = excludeFromHighMemoryDevices
fenix7xpro.excludeAnnotations = excludeFromHighMemoryDevices
fenixchronos.excludeAnnotations = excludeFromLowMemoryDevices
fr245.excludeAnnotations = excludeFromLowMemoryDevices
fr245m.excludeAnnotations = excludeFromLowMemoryDevices
fr255.excludeAnnotations = excludeFromHighMemoryDevices
fr255m.excludeAnnotations = excludeFromHighMemoryDevices
fr255s.excludeAnnotations = excludeFromHighMemoryDevices
fr255sm.excludeAnnotations = excludeFromHighMemoryDevices
fr265.excludeAnnotations = excludeFromHighMemoryDevices
fr265s.excludeAnnotations = excludeFromHighMemoryDevices
fr745.excludeAnnotations = excludeFromLowMemoryDevices
fr945.excludeAnnotations = excludeFromLowMemoryDevices
fr945lte.excludeAnnotations = excludeFromLowMemoryDevices
fr955.excludeAnnotations = excludeFromHighMemoryDevices
fr965.excludeAnnotations = excludeFromHighMemoryDevices
legacyherocaptainmarvel.excludeAnnotations = excludeFromHighMemoryDevices
legacyherofirstavenger.excludeAnnotations = excludeFromHighMemoryDevices
legacysagadarthvader.excludeAnnotations = excludeFromHighMemoryDevices
legacysagarey.excludeAnnotations = excludeFromHighMemoryDevices
marqadventurer.excludeAnnotations = excludeFromLowMemoryDevices
marqathlete.excludeAnnotations = excludeFromLowMemoryDevices
marqaviator.excludeAnnotations = excludeFromLowMemoryDevices
marqcaptain.excludeAnnotations = excludeFromLowMemoryDevices
marqcommander.excludeAnnotations = excludeFromLowMemoryDevices
marqdriver.excludeAnnotations = excludeFromLowMemoryDevices
marqexpedition.excludeAnnotations = excludeFromLowMemoryDevices
marqgolfer.excludeAnnotations = excludeFromLowMemoryDevices
marq2aviator.excludeAnnotations = excludeFromLowMemoryDevices
venu.excludeAnnotations = excludeFromHighMemoryDevices
venu2.excludeAnnotations = excludeFromHighMemoryDevices
venu2s.excludeAnnotations = excludeFromHighMemoryDevices
venu2plus.excludeAnnotations = excludeFromHighMemoryDevices
venu3.excludeAnnotations = excludeFromHighMemoryDevices
venu3s.excludeAnnotations = excludeFromHighMemoryDevices
vivoactive4.excludeAnnotations = excludeFromHighMemoryDevices
vivoactive4s.excludeAnnotations = excludeFromHighMemoryDevices
vivoactive5.excludeAnnotations = excludeFromHighMemoryDevices\n'
}

#######################################
# Return datafield exclusions
# Arguments:
#   none
# Returns:
#   string
#######################################

jungle::exclusions::datafield () {
	echo 'approachs7042mm.excludeAnnotations = $(approachs7042mm.excludeAnnotations);excludeFromDataField
approachs7047mm.excludeAnnotations = $(approachs7047mm.excludeAnnotations);excludeFromDataField
d2airx10.excludeAnnotations = $(d2airx10.excludeAnnotations);excludeFromDataField
d2mach1.excludeAnnotations = $(d2mach1.excludeAnnotations);excludeFromDataField
descentmk2.excludeAnnotations = $(descentmk2.excludeAnnotations);excludeFromDataField
descentmk2s.excludeAnnotations = $(descentmk2s.excludeAnnotations);excludeFromDataField
enduro.excludeAnnotations = $(enduro.excludeAnnotations);excludeFromDataField
epix2.excludeAnnotations = $(epix2.excludeAnnotations);excludeFromDataField
epix2pro42mm.excludeAnnotations = $(epix2pro42mm.excludeAnnotations);excludeFromDataField
epix2pro47mm.excludeAnnotations = $(epix2pro47mm.excludeAnnotations);excludeFromDataField
epix2pro51mm.excludeAnnotations = $(epix2pro51mm.excludeAnnotations);excludeFromDataField
fenix5.excludeAnnotations = $(fenix5.excludeAnnotations);excludeFromDataField
fenix5plus.excludeAnnotations = $(fenix5plus.excludeAnnotations);excludeFromDataField
fenix5s.excludeAnnotations = $(fenix5s.excludeAnnotations);excludeFromDataField
fenix5splus.excludeAnnotations = $(fenix5splus.excludeAnnotations);excludeFromDataField
fenix5x.excludeAnnotations = $(fenix5x.excludeAnnotations);excludeFromDataField
fenix5xplus.excludeAnnotations = $(fenix5xplus.excludeAnnotations);excludeFromDataField
fenix6.excludeAnnotations = $(fenix6.excludeAnnotations);excludeFromDataField
fenix6pro.excludeAnnotations = $(fenix6pro.excludeAnnotations);excludeFromDataField
fenix6s.excludeAnnotations = $(fenix6s.excludeAnnotations);excludeFromDataField
fenix6spro.excludeAnnotations = $(fenix6spro.excludeAnnotations);excludeFromDataField
fenix6xpro.excludeAnnotations = $(fenix6xpro.excludeAnnotations);excludeFromDataField
fenix7.excludeAnnotations = $(fenix7.excludeAnnotations);excludeFromDataField
fenix7pro.excludeAnnotations = $(fenix7pro.excludeAnnotations);excludeFromDataField
fenix7s.excludeAnnotations = $(fenix7s.excludeAnnotations);excludeFromDataField
fenix7spro.excludeAnnotations = $(fenix7spro.excludeAnnotations);excludeFromDataField
fenix7x.excludeAnnotations = $(fenix7x.excludeAnnotations);excludeFromDataField
fenix7xpro.excludeAnnotations = $(fenix7xpro.excludeAnnotations);excludeFromDataField
fr245.excludeAnnotations = $(fr245.excludeAnnotations);excludeFromDataField
fr245m.excludeAnnotations = $(fr245m.excludeAnnotations);excludeFromDataField
fr255.excludeAnnotations = $(fr255.excludeAnnotations);excludeFromDataField
fr255m.excludeAnnotations = $(fr255m.excludeAnnotations);excludeFromDataField
fr255s.excludeAnnotations = $(fr255s.excludeAnnotations);excludeFromDataField
fr255sm.excludeAnnotations = $(fr255sm.excludeAnnotations);excludeFromDataField
fr265.excludeAnnotations = $(fr265.excludeAnnotations);excludeFromDataField
fr265s.excludeAnnotations = $(fr265s.excludeAnnotations);excludeFromDataField
fr745.excludeAnnotations = $(fr745.excludeAnnotations);excludeFromDataField
fr945.excludeAnnotations = $(fr945.excludeAnnotations);excludeFromDataField
fr945lte.excludeAnnotations = $(fr945lte.excludeAnnotations);excludeFromDataField
fr955.excludeAnnotations = $(fr955.excludeAnnotations);excludeFromDataField
fr965.excludeAnnotations = $(fr965.excludeAnnotations);excludeFromDataField
legacyherocaptainmarvel.excludeAnnotations = $(legacyherocaptainmarvel.excludeAnnotations);excludeFromDataField
legacyherofirstavenger.excludeAnnotations = $(legacyherofirstavenger.excludeAnnotations);excludeFromDataField
legacysagadarthvader.excludeAnnotations = $(legacysagadarthvader.excludeAnnotations);excludeFromDataField
legacysagarey.excludeAnnotations = $(legacysagarey.excludeAnnotations);excludeFromDataField
marqadventurer.excludeAnnotations = $(marqadventurer.excludeAnnotations);excludeFromDataField
marqathlete.excludeAnnotations = $(marqathlete.excludeAnnotations);excludeFromDataField
marqaviator.excludeAnnotations = $(marqaviator.excludeAnnotations);excludeFromDataField
marqcaptain.excludeAnnotations = $(marqcaptain.excludeAnnotations);excludeFromDataField
marqcommander.excludeAnnotations = $(marqcommander.excludeAnnotations);excludeFromDataField
marqdriver.excludeAnnotations = $(marqdriver.excludeAnnotations);excludeFromDataField
marqexpedition.excludeAnnotations = $(marqexpedition.excludeAnnotations);excludeFromDataField
marqgolfer.excludeAnnotations = $(marqgolfer.excludeAnnotations);excludeFromDataField
marq2aviator.excludeAnnotations = $(marq2aviator.excludeAnnotations);excludeFromDataField
venu.excludeAnnotations = $(venu.excludeAnnotations);excludeFromDataField
venu2.excludeAnnotations = $(venu2.excludeAnnotations);excludeFromDataField
venu2s.excludeAnnotations = $(venu2s.excludeAnnotations);excludeFromDataField
venu2plus.excludeAnnotations = $(venu2plus.excludeAnnotations);excludeFromDataField
venu3.excludeAnnotations = $(venu2.excludeAnnotations);excludeFromDataField
venu3s.excludeAnnotations = $(venu2s.excludeAnnotations);excludeFromDataField
vivoactive4.excludeAnnotations = $(vivoactive4.excludeAnnotations);excludeFromDataField
vivoactive4s.excludeAnnotations = $(vivoactive4s.excludeAnnotations);excludeFromDataField
vivoactive5.excludeAnnotations = $(vivoactive5.excludeAnnotations);excludeFromDataField\n'
}

#######################################
# Return jungle device path
# Arguments:
#   $1 id, string
# Returns:
#   string
#######################################

jungle::device () {
	echo "$1.resourcePath = \$(base.resourcePath);\$($1.resourcePath);../devices/$1"
}

#######################################
# Generate project.jungle
# Arguments:
#   $1 config, json
# Returns:
#   none
#######################################

jungle::generate () {
	progress::bar

	echo "project.manifest = manifest.xml\n" > 'build/project.jungle'
	echo "base.barrelPath = barrels\n" >> 'build/project.jungle'
	echo "$(jungle::i18n)\n" >> 'build/project.jungle'
	echo "$(jungle::exclusions::memory)\n" >> 'build/project.jungle'

	if [[ $TYPE == 'datafield' ]]
	then
		echo "$(jungle::exclusions::datafield)\n" >> 'build/project.jungle'
	fi

	for device in "${DEVICES[@]}"
	do
		if [[ ! -z $device ]]
		then
			echo "$(jungle::device $device)" >> 'build/project.jungle'
		fi
	done
}
