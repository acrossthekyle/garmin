#!/bin/zsh

if [[ -z $(which jq) ]]
then
	echo 'Must install jq in order to use these scripts'

	return 0
fi

if [[ -z $(which git) ]]
then
	echo 'Must install git in order to use these scripts'

	return 0
fi

source scripts/options/options.sh
source scripts/paths/paths.sh

if [[ -z "$(git status --porcelain)" ]]
then
	echo 'Versioning'

  VERSION=$(jq -r '.version' $CONFIG)
	VERSION=$(echo $VERSION | awk -F. -v OFS=. 'NF==1{print ++$NF}; NF>1{if(length($NF+1)>length($NF))$(NF-1)++; $NF=sprintf("%0*d", length($NF), ($NF+1)%(10^length($NF))); print}')

	tmp=$(mktemp)
	jq --arg v "$VERSION" '.version = $v' $CONFIG > "$tmp" && mv "$tmp" $CONFIG

	echo 'Branching'

	git checkout 'main' &>/dev/null

	git checkout -b "development/$PROGRAM-$TYPE" &>/dev/null

	git add -A && git commit -m "DEV $PROGRAM" &>/dev/null

	git push -u origin "development/$PROGRAM-$TYPE" &>/dev/null
else
  echo 'Discard changes before proceeding'
fi
