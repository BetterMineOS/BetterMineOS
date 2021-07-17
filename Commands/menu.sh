#!/bin/bash

BG_BLACK="$(tput setab 0)"
BG_RED="$(tput setab 1)"
BG_GREEN="$(tput setab 2)"
BG_YELLOW="$(tput setab 3)"
BG_BLUE="$(tput setab 4)"
BG_MAGENTA="$(tput setab 5)"
BG_CYAN="$(tput setab 6)"
BG_WHITE="$(tput setab 7)"
BG_RESET="$(tput setab 9)"


FG_BLACK="$(tput setaf 0)"
FG_RED="$(tput setaf 1)"
FG_GREEN="$(tput setaf 2)"
FG_YELLOW="$(tput setaf 3)"
FG_BLUE="$(tput setaf 4)"
FG_MAGENTA="$(tput setaf 5)"
FG_CYAN="$(tput setaf 6)"
FG_WHITE="$(tput setaf 7)"
FG_RESET="$(tput setaf 9)"

tput smcup

${FG_WHITE}

while [[ $REPLY != 0 ]]; do
    clear
    cat <<- _EOF_
Please Select:
        
        1) Create server
        2) Start server
        3) Stop server
        4) Connect to server
        5) List running servers
        0) Quit

_EOF_

    read -p "Enter selection [0-5] > " main_selection

    # Clear area beneath menu
    tput ed

    # Act on selection
    case $main_selection in
            
        1)  # Create server
            printf "\n"
            read -p "Name for the server > " server_name
            mkdir $BetterMineOS/Servers/$server_name
            cp $BetterMineOS/Commands/AutoUpdateAndStartPaper.sh $BetterMineOS/Servers/$server_name/
            echo "eula=true" > $BetterMineOS/Servers/$server_name/eula.txt
            ;; 

        # Read from a text file that contains
        # the names of the servers

            
        2)  # Start server
            printf "\n"
            server=0

            i=1
            for dir in $BetterMineOS/Servers/*
            do
                printDir=$(echo $dir | rev | cut -d'/' -f 1 | rev)
                printf "\t$i) $printDir\n"
                i=$((i+1))
            done

            printf "\n"
            read -p "Enter the number of the server > " server_number
            server=$(ls $BetterMineOS/Servers | sed -n ${server_number}p)

            if [[ $(ls $BetterMineOS/Servers | wc -l) -ge $server_number ]]
            then
                printf "\nStarting server ${FG_GREEN}$server${FG_WHITE}"
                $BetterMineOS/Commands/server-start.sh $server
            else
                printf "\nInvalid server number"
            fi


            ;;

        3) # Stop server
            printf "\n"
            server=0

            number_of_servers=$(screen -ls | grep "(" | wc -l)

            for (( i=1; i <=$number_of_servers; i++ ))
                do
                    screenlist=$(screen -ls | grep "(" | cut -d'.' -f 2 | cut -d$'\t' -f 1 | sed -n ${i}p)
                    printf "\t$i) $screenlist\n"
                done
            printf "\n"

            read -p "Enter the server number > " selection

            server=$(screen -ls | grep "(" | cut -d'.' -f 2 | cut -d$'\t' -f 1 | sed -n ${selection}p)
            $BetterMineOS/Commands/server-stop.sh $server

            ;;
        4)  # Connect to server
            printf "\n"
            server=0

            number_of_servers=$(screen -ls | grep "(" | wc -l)

            for (( i=1; i <=$number_of_servers; i++ ))
                do
                    screenlist=$(screen -ls | grep "(" | cut -d'.' -f 2 | cut -d$'\t' -f 1 | sed -n ${i}p)
                    printf "\t$i) $screenlist\n"
                done
            printf "\n"

            read -p "Enter the server number > " selection

            server=$(screen -ls | grep "(" | sed -n ${selection}p | grep -o "[0-9]*\.")
            screen -r $server
            ;;

        5)  # List running servers
            printf "\n"
            screen -ls | grep "(" | cut -d'.' -f 2 | cut -d$'\t' -f 1
            ;;

        0)  break
            ;;
        *)  echo "Invalid entry."
            ;;
    esac
    printf "\n\nPress any key to continue."
    read -n 1

done

tput rmcup
clear
echo "Program terminated."
