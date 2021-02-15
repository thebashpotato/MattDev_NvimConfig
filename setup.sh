#! /bin/bash

#------------------=| Dev notes |------------------#


# Required tests:
# Can you install a more stripped Manjaro to test every install?
# Try on vanilla Ubuntu tomorrow


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
tier1=("git" "curl" "ctags" "python3" "pip" "ack")

# tier-1b: programs that don't have a shell command but are installed through shell.
tier1b=("python3-pip" "python3-venv")

# tier-2: program packages, modules, libraries, etc.
tier2=("pynvim" "flake8" "pylint" "isort")


function distro_unrecognized () {
    
    # A custom error message if the distro 
    # remains unrecognized during installations.
    echo "Error: Distro unrecognized."
    echo "Please install $1 manually."

}


function distro_determine () {

    # Detects user distro
    # The ubuntu check has additional lsb_release parameters
    # to shut the "No LSB modules" warning the hell up.
    if( lsb_release -ar 2>/dev/null | grep --silent 'Ubuntu\|Mint' > /dev/null );
    then
        echo 1
    elif ( lsb_release -a | grep --silent  'Manjaro\|Arch' > /dev/null );
    then
        echo 2
    else
        echo 0
    fi


}




function tier2_check () {
    # Checks for program packages, modules, libraries, etc.


    true #no-op

}




function tier1b_check () {
    # Checks programs that don't have a shell command but are installed through shell.

    true #no-op

}


function tier1_install () {
    # Will ask distro_determine after arriving at a case

    # A switch statement. Inside each case there is an if statement
    # to have separate installation commands for ubuntu and manjaro

    # Before anything else, we have to update our package lists.
    # dr stands for distro result.

    dr=$(distro_determine) # dr stands for distro result.

    case $1 in  # $1 for first argument. We're given a dependency name.
    "git")
        echo "Installing git.."


        if [ "${dr}" == 1 ] ;    #If Ubuntu, this would be the command
        then
            sudo apt install git
        elif [ "${dr}" == 2 ] ;
        then
            pacman -S git      #If Manj/Arch, this would be the command
        else
           distro_unrecognized "$1"
        fi
        ;;                      # The same pattern repeats for the other cases.


    "curl")
        echo "Installing curl.."


        if [ "${dr}" == 1 ] ;
        then
            sudo apt install curl       #If Ubuntu
        elif [ "${dr}" == 2 ] ;
        then
            sudo pacman -S curl   #If Manj/Arch
        else
            distro_unrecognized "$1"
        fi
        ;;


    "ctags")
        echo "Installing ctags.."


        if [ "${dr}" == 1 ] ;
        then
            sudo apt-get install ctags  #If Ubuntu
        elif [ "${dr}" == 2 ] ;
        then
            sudo snap install universal-ctags       #If Manj/Arch
        else
            distro_unrecognized "$1"
        fi
        ;;


    "pip")
        echo "Installing pip.."


        if [ "${dr}" == 1 ] ;
        then
            sudo apt install python3-pip
        elif [ "${dr}" == 2 ] ;
        then
            sudo pacman -S python-pip 
        else
            distro_unrecognized "$1"
        fi
        ;;


    "ack")
        echo "Installing ack.."


        if [ "${dr}" == 1 ] ;
        then
            sudo apt install ack-grep
        elif [ "${dr}" == 2 ] ;
        then
            sudo pacman -S ack
        else
            distro_unrecognized "$1"
        fi
        ;;


    esac

}



function tier1_check() {
    # Checks programs that are installed through the shell.
    
    # This array tracks what's determined to be a missing dependency
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



    # A prompt that requires user input
    # Y to install missing dependencies
    # otherwise quit
    if [ "${#missing[@]}" -ne 0 ]; then # Only executes when something's missing

        read -r -p "Install missing dependencies? [Y/n]" response
        response=${response,,} # tolower

        if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]];
        then
            for i in "${missing[@]}" ; do
                tier1_install "$i"
            done
        fi


    fi
}




tier1_check