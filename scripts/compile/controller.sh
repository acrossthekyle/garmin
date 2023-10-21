#!/bin/zsh
#
# Create Controller.mc file in /build/source directory

controller::widget () {
  local template="$(cat 'modules/Controllers/WidgetController.mc')"

  echo "$template" > 'build/source/Controller.mc'
}

controller::app () {
  local template="$(cat 'modules/Controllers/AppController.mc')"

  echo "$template" > 'build/source/Controller.mc'
}

controller::watchface () {
  local template="$(cat 'modules/Controllers/WatchfaceController.mc')"

  echo "$template" > 'build/source/Controller.mc'
}

controller::generate () {
  progress::bar

  if [[ $TYPE == 'widget' ]]
  then
    controller::widget
  elif [[ $TYPE == 'app' ]]
  then
    controller::app
  elif [[ $TYPE == 'watchface' ]]
  then
    controller::watchface
  fi
}
