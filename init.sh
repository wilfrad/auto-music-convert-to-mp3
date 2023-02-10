#!/bin/bash
source ./rename/rename.sh

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

#init_rename $@ >> ".logs"