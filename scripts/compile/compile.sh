#!/bin/zsh
#
# Compile all code for project

#######################################
# Remove single empty new line
# Arguments:
#   $1 path, string
# Returns:
#   string
#######################################

files::clean::emptylines () {
	local output=$(sed '/^[[:space:]]*$/d' $1)

	echo $output > $1
}

#######################################
# Remove multiple empty new lines
# Arguments:
#   $1 path, string
# Returns:
#   string
#######################################

files::clean::multipleemptylines () {
	local output=$(sed -e '/./b' -e :n -e 'N;s/\n$//;tn' $1)

	echo $output > $1
}

#######################################
# Indent methods with two spaces
# Arguments:
#   $1 path, string
# Returns:
#   string
#######################################

files::clean::indentmethods () {
	local output=$(sed -e 's/^/  /' <<< $1)

	echo "$output"
}

#######################################
# Display progress bar
# Arguments:
#   $1 count, string
#   $2 task, string
# Returns:
#   string
#######################################

PROGRESS_BAR_STEP=1

progress::bar () {
	local barSize=40
	local barCharDone="#"
	local barCharTodo="-"
	local barPercentageScale=0

  local current=$PROGRESS_BAR_STEP
  local total=15
  local task=$funcstack[2]

  if [[ ! -z $1 ]]
	then
		task=$1
	elif [[ $task == 'scripts/compile/compile.sh' ]]
  then
  	task=''
  fi

  local percent=$(bc <<< "scale=$barPercentageScale; 100 * $current / $total")

  local done=$(bc <<< "scale=0; $barSize * $percent / 100")
  local todo=$(bc <<< "scale=0; $barSize - $done")

  local doneSubBar=$(printf "%${done}s" | tr " " "${barCharDone}")
  local todoSubBar=$(printf "%${todo}s" | tr " " "${barCharTodo}")

  echo -ne "\r\033[KGenerating [${doneSubBar}${todoSubBar}] ${percent}% ${task}"

  PROGRESS_BAR_STEP=$(($PROGRESS_BAR_STEP+1))
}

for script in scripts/compile/*
do
  if [[ ! $script == *'compile.sh'* ]]
  then
  	source $script
  fi
done

build::prepare $CONFIG
devices::set $CONFIG
jungle::generate $CONFIG
manifest::generate $CONFIG false true
properties::generate $CONFIG
settings::generate $CONFIG
drawables::generate $CONFIG
src::generate $CONFIG
controller::generate $CONFIG
app::generate $CONFIG
modules::generate $CONFIG
strings::generate $CONFIG
build::clean $CONFIG

progress::bar 'barrel::generate'

barrelbuild -f 'build/modules/modules.jungle' -o 'build/barrels/keg.barrel' -l 0 --no-gen-styles -O p -r >/dev/null
rm -R 'build/modules'

progress::bar
