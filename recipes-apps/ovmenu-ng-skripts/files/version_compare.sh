vercomp () {
    # echo "$1 vs. $2"
    # echo "-------------"
    if [[ $1 == $2 ]]
    then
        return 0 # equal
    fi
    local i ver1 ver2
    # replace '-' with '.' and split it an array
    IFS='.' read -ra ver1 <<< "$1"
    IFS='.' read -ra ver2 <<< "$2"
    for ((i=0; i<4; i++))
    do
        # fill empty fields in ver1 with zeros
        if [ -z ${ver1[i]} ]; then ver1[i]=0; fi
        if [ -z ${ver2[i]} ]; then ver2[i]=0; fi
    done
    
    if (( ${#ver1[0]} > 4 ))
    then
       # with fw 17119 make version 0.17119 for a correct compare
            ver1[1]=${ver1[0]}
            ver1[0]=0
    fi
    if (( ${#ver2[0]} > 4 ))
    then
       # with fw 17119 make version 0.17119 for a correct compare
            ver2[1]=${ver2[0]}
            ver2[0]=0
    fi

    for ((i=0; i<${#ver1[@]}; i++))
    do
        if [[ -z ${ver2[i]} ]]
        then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((${ver1[i]} > ${ver2[i]}))
        then
            return 2 # greater 
        fi
        if ((${ver1[i]} < ${ver2[i]}))
        then
            return 1 # lower
        fi
    done
    return 0 # equal
}

function compare_print(){
  case $1 in
    0) echo "Version is identical!";;
    1) echo "Version is lower!";;
    2) echo "Version is greater!";;
    *) echo "Version compare error!";;
  esac
}

