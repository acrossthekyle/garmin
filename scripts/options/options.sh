while [[ "$#" -gt 0 ]]
do
	case $1 in
    -d|--device)
			DEVICE="$2"
			shift;;
		-p|--project)
			PROGRAM="$2"
			shift;;
    -t|--type)
			TYPE="$2"
	esac
	shift
done
