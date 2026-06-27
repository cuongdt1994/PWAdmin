#!/bin/bash

# Function to compare two version strings
check_version() {
    local version1="$1"
    local version2="$2"

    if [[ "$version1" >= "$version2" ]]; then
        echo "true"
    else
        echo "false"
    fi
}

# Function to get a version (simply prints the argument)
get_version() {
    echo "$1"
}


# Function to generate an MD5 hash
md5_hash() {
   echo -n "$1" | md5sum | awk '{print $1}'
}

# Function to check a server status using netcat
check_server_status() {
    local server="$1"
    local port="$2"
    if nc -z -v -w 3 "$server" "$port" >/dev/null 2>&1; then
        echo "true"
    else
        echo "false"
    fi
}

# Function to download an update file
update_from_url() {
    local update_url="$1"
    local destination_dir="$2"

    local update_folder="$destination_dir/update"

    if [[ ! -d "$destination_dir" ]]; then
        echo "false"
        return 1
    fi

    mkdir -p "$update_folder"

    local temp_file=$(mktemp)

    if curl -s -o "$temp_file" "$update_url" ; then
        mv "$temp_file" "$update_folder"
        echo "true"
    else
       echo "false"
       rm "$temp_file"
       return 1
    fi

}

# ------------------- New Functions for JSP --------------------
# get faction list
get_factions() {
    local path="$1"
    "$path"/gamedbd/gamedbd "$path"/gamedbd/gamesys.conf listfaction
}

# get faction members
get_faction_members() {
    local path="$1"
     "$path"/gamedbd/gamedbd "$path"/gamedbd/gamesys.conf listfactionuser
}

# get faction domains
get_faction_domains(){
   local path="$1"
   "$path"/gamedbd/gamedbd "$path"/gamedbd/gamesys.conf listcity
}

# get pvp log data
get_pvp() {
    local logfile="$1"
	awk -F: '/:die:.*type=2/ {
        match($0, /roleid=([0-9]+):type=/, arr);
        victim = arr[1];
		match($0, /attacker=([0-9]+)/, arr2);
		attacker = arr2[1];
        print victim "," attacker
	}' "$logfile"
}

# convert byte array to hex
to_hex() {
    local input="$1"
    xxd -p <<< "$input"
}

# convert hex to byte array
from_hex() {
    local input="$1"
	if [[ ${#input} -eq 0 ]]
	then
	   echo ""
	else
		if [[ $((${#input} % 2)) -eq 0 ]]; then
			echo "$input" | xxd -r -p
		else
			echo "Error: Hex string must have an even length"
		fi
	fi

}


#get occupation name by ID
get_occupation() {
    local mode="$1"
    local c="$2"
    if [[ "$mode" == "pwi" ]]; then
        case "$c" in
            0) echo "Blademaster" ;;
            1) echo "Wizard" ;;
            2) echo "Psychic" ;;
            3) echo "Venomancer" ;;
            4) echo "Barbarian" ;;
            5) echo "Assassin" ;;
            6) echo "Archer" ;;
            7) echo "Cleric" ;;
            8) echo "Seeker" ;;
            9) echo "Mystic" ;;
            10) echo "Dudskblade" ;;
            11) echo "Stormbringer" ;;
           *) echo "unknown" ;;
        esac
    else
       case "$c" in
            0) echo "Blademaster" ;;
            1) echo "Wizard" ;;
            2) echo "Psychic" ;;
            3) echo "Venomancer" ;;
            4) echo "Barbarian" ;;
            5) echo "Assassin" ;;
            6) echo "Archer" ;;
            7) echo "Cleric" ;;
            8) echo "Seeker" ;;
            9) echo "Mystic" ;;
            10) echo "Dudskblade" ;;
            11) echo "Stormbringer" ;;
           *) echo "unknown" ;;
        esac
    fi
}

# Export role XML data
export_role_xml() {
    local path="$1"
    "$path"/gamedbd/gamedbd "$path"/gamedbd/gamesys.conf exportrole
}