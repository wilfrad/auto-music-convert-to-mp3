#!/bin/bash
source ./rename/rename.sh
declare -- crt_action="any"

function read_cfg() {
    declare -- key=""
    declare -- value=""
    assign_value() {
        
    }
    while read -r line ; do
        if [[ $line = \#* ]] ; then
            $key=""
            $value=""
            continue
        fi
        $key=$( echo $line | awk -F "=" '{print $1}' | sed 's/\s//g' )
        $value=$( echo $line | awk -F "=" '{print $2}' | sed 's/\s//g' )
    done < ".config"
}

declare -- success="[ SUCCESsFUL ]"
declare -- warn="[ WARNING ]"
declare -- err="[ ERROR ]"
function state_process() {
    declare -- run="[ RUN $crt_action ]"
    build_message() {
        echo "$1 $2" >> ".logs"
    }
}
init_converter $1 "a.mp3" >> ".logs"
#init_rename $@ >> ".logs"