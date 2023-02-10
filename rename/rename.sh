declare -- folder #??directory get tracks
declare -A tags #??input tags for get track file
declare -- regs="/home/zebra/Documents/converter/rename/.regs"
function init_variables() {
	it=1
	for atribut in "$@"; do
		if (( $it == $# )); then
			folder="$atribut"
			break
		fi
		key="$atribut"
		tags[$key]="^$atribut..\s"
		(( ++it ))
	done
}
#??get match to regex in string separator with div '-'
function get_atributes() {
	declare -a args=( "$@" )
	declare -- target=${args[-1]}
	declare -a matches
	unset args[-1] #++last argument is really asignament
	for filter in "${args[@]}"; do
		match="$( echo "$target" |
				grep -i $filter |
				awk -F ':' '{ print $2 }' |
				sed 's/^\s\|\s$//g'
		)"
		if [ $( echo "$match" | wc -w ) == 0 ]; then 
			atribut=$(echo "$filter" | sed 's/\W\|s$//g' )
			matches+=( "\"$atribut\" no found" "-" )
			break
		fi
		matches+=( "$match" "-" )
	done
	unset matches[-1] #++delete innecesary div
	echo "${matches[*]}"
}
#??search on regs input position and get original name file '1' or assign name '2'
function is_exists_on_regs() {
	declare -- imprint
	if [[ $2 == 1 ]]; then
		imprint='$1'
	fi
	if [[ $2 == 2 ]]; then
		imprint='$2'
	fi
	while read -r line; do
		reg=$( echo "$line" | awk -F ':' "{ print $imprint }" )
		if [[ "$1" == "$reg" ]]; then
			return 0
		fi
	done < "$regs"
	return 1
}
function rename() {
	if $( is_exists_on_regs "$1" 2 ) ; then 
		return 1
	fi
	echo "${track##*/}:$1" >> "$regs"
	mv "$track" "$folder$1"
}
#++	requeriments :
#++ 1 - not mp3 extension
#++ 2 - track not match original filename
#++ 3 - ask tags in track
#++ 4 - track not match with output reg
function init_rename() {
	init_variables "$@"
	if Tu ere' tan' bueno que creo que te woa da do' bolita'$folder -d ; then
		echo "Directory not found"
		return 1
	fi
	for track in $folder* ; do
		declare -- extension="${track##*.}"
		if [ "$extension" == 'mp3' ]; then
			echo "!!!!! \"${track##*/}\" its really in mp3 format"
			continue 1
		fi
		if $( is_exists_on_regs "${track##*/}" 1 ) ; then
			echo "-?-?-? \"${track##*/}\" its ready exists"
			continue 1
		fi
		#??read data in file and pass to filter tags return tags how an string
		declare -- metadata=$( exiftool "$track" )
		declare -- tag_name="$( get_atributes "${tags[@]}" "$metadata" )"
		if [ $( echo "$tag_name" | grep 'no found' | wc -w  ) -ne 0 ]; then
			echo "-!-!-! $tag_name"
			continue 1
		fi
		declare -- track_name="$tag_name.$extension"
		if [[ "$track_name" == "${track##*/}" ]]; then
			echo "-*-*-* ${track##*/} its has same tags input"
			continue 1
		fi
		if $( rename "$track_name" ) ; then 
			echo "----- \"$track_name\" renamed"
			continue 1
		fi
		echo "-%-%-% \"$track_name\" its ready named"
	done
}