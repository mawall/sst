echo_red(){
    echo -e "\033[31m${*}\033[0m"
}

echo_yellow(){
    echo -e "\033[93m${*}\033[0m"
}

echo_green(){
    echo -e "\033[92m${*}\033[0m"
}

echo_error(){
    echo_red "${*}" 1>&2
}
