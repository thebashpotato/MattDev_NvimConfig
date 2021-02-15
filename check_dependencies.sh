#! /bin/bash




#------------------=| Dev notes |------------------#


# TO DO: 
# Install each tier-1 depency on both Ubuntu and Manjaro
# and take note.

# What programs are needed? 
# For Debian: git, curl, python3-pip, python3-venv, Rust
# exuberant-ctags, ack-grep
# Pip packages: pynvim flake8 pylint isort 


# For Arch/Manjaro: git, curl, python3, pip, ctags, Rust
# Pip packages: pynvim flake8 isort  


# Where do you get Cargo? Does it come with Rust?

# Warning: Do not use "which" to check for programs
# https://stackoverflow.com/questions/592620/how-can-i-check-if-a-program-exists-from-a-bash-script


# One function to check for each tier of dependencies.

#---------------=| End of Dev notes |=-------------#

 

 




# tier-1: programs that are installed through the shell.    
tier1=("git" "curl" "ctags" "python3" "pip" "ack" "ctags")
# tier-1b: programs that don't have a shell command but are installed through shell.
tier1b=("python3-pip" "python3-venv")


# tier-2: program packages, modules, libraries, etc.
tier2=()



function distr_determine () {

    # Detects whether user has Manjaro or Ubuntu
    # The ubuntu check has additional lsb_release parameters
    # to shut the "No LSB modules" warning the hell up.
    
    if( lsb_release -ar 2>/dev/null | grep --silent 'Ubuntu\|Mint' > /dev/null);
    then
        return 1
    elif (lsb_release -a | grep --silent  'Manjaro\|Arch' > /dev/null);
    then
        return 2
    else 
        return 0
    fi
    

}


function install () {
    # Parameters: (debian or arch)

    # A switch statement. Inside each case there is an if statement
    # to have separate installation commands for ubuntu and manjaro

    true #no-op

}


function tier2_check () {
    # Checks for program packages, modules, libraries, etc.


    true #no-op
}




function tier1b_check () {
    # Checks programs that don't have a shell command but are installed through shell.

    true #no-op
}


function tier1_check() {
    # Checks programs that are installed through the shell.    

    missing=()

    for i in "${tier1[@]}" ; do

        # A check if a program exists
        # Does this by seeing if a command from their program works
        if ! command -v "$i" &> /dev/null   
            then
            echo -e "\e[91mError: $i not found.\e[0m"
            missing+=("$i")
        else 
            echo -e "\e[32m$i found.\e[0m"
        fi

    done



}

tier1_check
distr_determine