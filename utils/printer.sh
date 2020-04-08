echo_red(){
    /bin/echo -e "\033[31m${*}\033[0m"
}

echo_yellow(){
    /bin/echo -e "\033[93m${*}\033[0m"
}

echo_green(){
    /bin/echo -e "\033[92m${*}\033[0m"
}

echo_error(){
    echo_red "${*}" 1>&2
}
