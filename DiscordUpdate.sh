#!/bin/bash

DEPEND1="aria2c"
GREEN="\033[0;32m"
RED="\033[0;31m"
RESET="\033[0m"

function header () {

    echo "┌──────────────────────────────────┐"
    echo "│DiscordUpdate.sh by Tristeamer >w<│"
    echo "└──────────────────────────────────┘"
    echo -e "==================================== \n"
}

function disc_exists () {

    if [ -e /usr/bin/Discord ]

    then
        TITLE="DiscordUpdate.sh: ${RED}Error: Discord installed, would you like to uninstall it now?${RESET}"
        echo -e "${TITLE}"
        options=("Uninstall Discord" "Quit")
        select menu in "${options[@]}"
        do
            case $menu in
                "Uninstall Discord")
                    if [ -e /usr/bin/dnf ]

                        then
                            sudo dnf remove discord
                            break

                    elif [ -e /usr/bin/apt ]
                        
                        then
                            sudo apt purge discord
                            break
                    else
                        clear
                        echo -e "DiscordUpdate.sh: ${RED}Your package manager is not currently supported by this script. Please uninstall Discord manually :(${RESET}"
                        sleep 5
                        exit
                    fi
                    ;;
                "Quit")
                    clear
                    exit
                    ;;
                *) echo -e "DiscordUpdate.sh: ${RED}Error: invalid option. $REPLY ${RESET}";;
            esac
        done
    else
        echo -e "DiscordUpdate.sh: ${GREEN}Discord not installed, installing :) \n${RESET}"
    fi
}

function depends () {
    
    if [ -e /usr/bin/aria2c ]
    
    then
        echo -e "DiscordUpdate.sh: ${GREEN}Dependencies met :) \n${RESET}"
    else
        TITLE="DiscordUpdate.sh: ${RED}Error: Dependency [$DEPEND1] not installed, would you like to install it now?${RESET}"
        echo -e "${TITLE}"
        options=("Install [$DEPEND1]" "Quit")
        select menu in "${options[@]}"
        do
            case $menu in
                "Install [$DEPEND1]")
                    break
                    ;;
                "Quit")
                    clear
                    exit
                    ;;
                *) echo -e "DiscordUpdate.sh: ${RED}Error: invalid option. $REPLY ${RESET}";;
            esac
        done

        if [ -e /usr/bin/dnf ]

            then
                sudo dnf install aria2
                break

        elif [ -e /usr/bin/apt ]
            
            then
                sudo apt install aria2
                break
        else
            clear
            echo -e "DiscordUpdate.sh: ${RED}Your package manager is not currently supported by this script. Please install [$DEPEND1] manually :(${RESET}"
            sleep 5
            exit
        fi
    fi
}

function discdl () {

    TITLE="DiscordUpdate.sh: Choose a discord build to install:"
    echo -e "${TITLE}"
    options=("Stable (Choose if unsure)" "PTB (Beta)" "Canary")
    select menu in "${options[@]}"
    do
            case $menu in
                "Stable (Choose if unsure)")
                    cd ~/
                    echo -e "DiscordUpdate.sh: Downloading discord.tar.gz from: https://discord.com/api/download/stable?platform=linux&format=tar.gz using [$DEPEND1]$"
                    aria2c -o "discord.tar.gz" "https://discord.com/api/download/stable?platform=linux&format=tar.gz"
                    break
                    ;;
                "PTB (Beta)")
                    cd ~/
                    echo -e "DiscordUpdate.sh: Downloading discord.tar.gz from: https://discord.com/api/download/ptb?platform=linux&format=tar.gz using [$DEPEND1]$"
                    aria2c -o "discord.tar.gz" "https://discord.com/api/download/ptb?platform=linux&format=tar.gz"
                    break
                    ;;
                "Canary (Unstable)")
                    cd ~/
                    echo -e "DiscordUpdate.sh: Downloading discord.tar.gz from: https://discord.com/api/download/canary?platform=linux&format=tar.gz using [$DEPEND1]$"
                    aria2c -o "discord.tar.gz" "https://discord.com/api/download/canary?platform=linux&format=tar.gz"
                    break
                    ;;
                *) echo -e "DiscordUpdate.sh: ${RED}Error: invalid option. $REPLY ${RESET}";;
            esac
        done    

}

function discdesktop () {
                        
    if [ -e /home/$USER/Desktop/Discord.desktop ]
        then
            rm -rf /home/$USER/Desktop/Discord.desktop
    fi
    TITLE="DiscordUpdate.sh: Create a desktop shortcut?"
    echo -e "${TITLE}"
    options=("Create desktop shortcut" "Skip")
    select menu in "${options[@]}"
    do
        case $menu in
            "Create desktop shortcut")
                echo "[Desktop Entry]" > Discord.desktop
                echo "Name=Discord" >> Discord.desktop
                echo "Exec=/usr/bin/Discord" >> Discord.desktop
                echo "Icon=/usr/share/icons/discord.png" >> Discord.desktop
                echo "comment=Internet Messenger >w<" >> Discord.desktop
                echo "Type=Application" >> Discord.desktop
                echo "Terminal=false" >> Discord.desktop
                echo "Encoding=UTF-8" >> Discord.desktop
                echo "Categories=Internet;" >> Discord.desktop
                mv Discord.desktop /home/$USER/Desktop 
                break
                ;;
            "Skip")
                break
                ;;
            *) echo -e "DiscordUpdate.sh: ${RED}Error: invalid option. $REPLY ${RESET}";;
        esac
    done

}

function discextract () {

    mkdir -p ~/.local/bin
    echo -e "DiscordUpdate.sh: Untarring discord.tar.gz... \n"
    sudo tar -xvf discord.tar.gz -C ~/.local/bin

    if [ -e /usr/share/icons/discord.png ]
        then
            rm -rf /usr/share/icons/discord.png
    fi

    sudo ln -s ~/.local/bin/Discord/discord.png /usr/share/icons/discord.png
    sudo ln -s ~/.local/bin/Discord/Discord /usr/bin
    echo -e "DiscordUpdate.sh: Deleting discord.tar.gz... \n"
    rm -rf discord.tar.gz

    if [ -e /usr/bin/Discord ]
        then
            echo -e "DiscordUpdate.sh: ${GREEN}Discord updated sucessfully :) ${RESET} \n"
        else
            echo -e "DiscordUpdate.sh: ${RED}Discord update unsuccessful, try again? :( ${RESET} \n"
            exit
    fi

}

function rundisc () {

    TITLE="DiscordUpdate.sh: Run Discord now?"
    echo -e "${TITLE}"
    options=("Run Discord" "Quit")
    select menu in "${options[@]}"
    do
        case $menu in
            "Run Discord")
                break
                ;;
            "Quit")
                clear
                exit
                ;;
            *) echo -e "DiscordUpdate.sh: ${RED}Error: invalid option. $REPLY ${RESET}";;
        esac
    done

    Discord

} 

header

depends

disc_exists

discdl

discdesktop

discextract

rundisc