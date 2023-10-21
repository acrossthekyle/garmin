#!/bin/zsh
#
# Set devices for projects

DEVICES=('approachs7042mm' 'approachs7047mm' 'd2airx10' 'd2mach1' 'descentmk2' 'descentmk2s' 'enduro' 'epix2' 'epix2pro42mm' 'epix2pro47mm' 'epix2pro51mm' 'fenix5' 'fenix5plus' 'fenix5s' 'fenix5splus' 'fenix5x' 'fenix5xplus' 'fenix6' 'fenix6pro' 'fenix6s' 'fenix6spro' 'fenix6xpro' 'fenix7' 'fenix7pro' 'fenix7s' 'fenix7spro' 'fenix7x' 'fenix7xpro' 'fr245' 'fr245m' 'fr255' 'fr255m' 'fr255s' 'fr265' 'fr265s' 'fr255sm' 'fr745' 'fr945' 'fr945lte' 'fr955' 'fr965' 'legacyherocaptainmarvel' 'legacyherofirstavenger' 'legacysagadarthvader' 'legacysagarey' 'marqadventurer' 'marqathlete' 'marqaviator' 'marqcaptain' 'marqcommander' 'marqdriver' 'marqexpedition' 'marqgolfer' 'marq2aviator' 'venu' 'venu2' 'venu2s' 'venu2plus' 'venu3' 'venu3s' 'vivoactive4' 'vivoactive4s' 'vivoactive5')

devices::set () {
  progress::bar

  local exclusions=($(jq -r '.deviceExclusions?' $1 | tr -d '[]," '))

  for device in "${exclusions[@]}"
  do
    DEVICES=("${DEVICES[@]/$device}" )
  done
}
