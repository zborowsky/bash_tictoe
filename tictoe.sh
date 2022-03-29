#!/bin/bash

start_message(){
    echo "===================================================================="    
    echo "                     Welcome to Tic Toe Game"
    echo "===================================================================="
    sleep 1
}

player_message()
{
	echo "===================================================================="
	echo "$1 move now ------- SIGN $2"
	echo "===================================================================="
}

which_player_move()
{
    clear
    if (( which_player_turn == 0 )); 
    then 
		player_message "Player1" "X"
		which_player_turn=1
        player_move "X" "O"

    else
		if [[ $game_with_comp == 1 ]]
		then
			player_message "Computer" "O"
			computer_move
			echo "Computer move in progress...."
			sleep 3
		else
			player_message "Player2" "O"
			player_move "O" "X"
		fi

		which_player_turn=0
    fi
}

computer_move()
{
	get_empty_fileds empty_fields

	number_of_empty_fields=${#empty_fields[@]}
	computer_move_index=${empty_fields[$((RANDOM%number_of_empty_fields))]}
	arr[${computer_move_index:0:1},${computer_move_index:1:1}]="O"
}


get_empty_fileds()
{
	empty_fields=()
    for row_index in 1 2 3
    do
        for column_index in 1 2 3
        do
			candidate=${arr[$row_index,$column_index]}
            if [[ ($candidate != "O") && ($candidate != "X") ]];
            then
                empty_fields+=($((("$row_index$column_index"))))

            fi
        done
    done
}

winner_display()
{
	while true
	do
		clear
		echo "$1"
		echo "Press q to quit..."
		read -r exit_key
		if [[ $exit_key == "q" ]]
		then
			exit 0;
		fi
	done
}


check_match()
{
	field_1=${arr[${1:0:1},${1:1:1}]}
	field_2=${arr[${2:0:1},${2:1:1}]}
	field_3=${arr[${3:0:1},${3:1:1}]}
	
	if [[ ($field_1 == "$field_2") && ($field_2 == "$field_3") && ($field_1 != ".") ]]
	then
		game_on=false
	fi
	
	if [[ ($game_on == false) && ($field_1 == "X") ]];
	then
		winner_display "Player1 wins!"
	elif [[ ($game_on == false) && ($field_1 == "O") ]];
	then
		if [[ $game_with_comp == 1 ]]
		then
			winner_display "Computer wins!"
		else
			winner_display "Player2 wins!"
		fi
	fi
}

save_game()
{
	read -rp "Provide name of this save (for ex some_save.txt): " save_name
	current_state=""

	for row_index in 1 2 3
    do
        for column_index in 1 2 3
        do
			current_state+="${arr[$row_index,$column_index]}"
        done
    done 
	
	echo $current_state > "$save_name"
	clear
	echo "Game successfully saved, exiting in 5 seconds"
	sleep 5
	exit 0
}


check_winner()
{
	get_empty_fileds empty_fields 
	number_of_empty_fields=${#empty_fields[@]}

	check_match "11" "12" "13"
	check_match "21" "22" "23"
	check_match "31" "32" "33"
	
	check_match "11" "21" "31"
	check_match "12" "22" "32"
	check_match "13" "23" "33"
	
	check_match "11" "22" "33"
	check_match "13" "22" "31"
	
	if [[ $number_of_empty_fields == 0 ]]
	then
		winner_display "It's a draw!"
	fi
}


is_table_input_valid()
{
	if [[ ($row_index < 1) || ($row_index > 3) || ($col_index < 1) || ($col_index > 3) ]]
	then
		is_input_valid=1	
	else
		is_input_valid=0
		board_value_at_field=${arr[${row_index},${col_index}]}
	fi
}

player_move()
{
	print_board
	echo "Provide filed (1,1 filed should be represented as 11)"
	echo "If you want to save game provide 's' letter"
	read -r candidate_field_index
	declare -i row_index=${candidate_field_index:0:1}
	declare -i col_index=${candidate_field_index:1:1}
	
	is_table_input_valid
	
	if [[ $candidate_field_index == "s" ]]
	then
		save_game
	fi
	
	while [[ $board_value_at_field == "$1" ]] || [[ $is_input_valid == 1 ]] || [[ $board_value_at_field == "$2" ]]
	do
		echo "You provide invalid/non empty value"
		echo "Provide filed (1,1 filed should be represented as 11)"
		read -r candidate_field_index
		
		row_index=${candidate_field_index:0:1}
		col_index=${candidate_field_index:1:1}
		is_table_input_valid
	done
	
	arr[${candidate_field_index:0:1},${candidate_field_index:1:1}]=$1
}


print_board()
{
    echo ""
    echo "      1   2   3 "
    echo "    -------------"
    echo "  1 | ${arr[1,1]} | ${arr[1,2]} | ${arr[1,3]} |"
    echo "    -------------"
    echo "  2 | ${arr[2,1]} | ${arr[2,2]} | ${arr[2,3]} |"
    echo "    -------------"
    echo "  3 | ${arr[3,1]} | ${arr[3,2]} | ${arr[3,3]} |"
    echo "    -------------"
    sleep 1
}


load_game()
{
	declare -i board_field_cnt=0
	declare -i o_cnt=0
	declare -i x_cnt=0
	read -rp "If you wish to load game provide 'l': " load
	if [[ $load == "l" ]]
	then
		read -rp "Provide save game filename: " load_filename
		read -r save < "$load_filename" 
				
		if [[ ${#save} == 9 ]]
		then
			echo "Save file is valid"
			for row_index in 1 2 3
			do
				for column_index in 1 2 3
				do
					value=${save:board_field_cnt:1}
					if [[ $value == "O" ]]
					then
						o_cnt+=1
					elif [[ $value == "X" ]]
					then
						x_cnt+=1
					fi
					
					arr[${row_index},${column_index}]=$value
					board_field_cnt+=1
				done
			done
		else
			echo "!!!! INVALID SAVE FILE !!!!"
			echo "Valid file should contains 9 records, contains only 'X','O' or '.' for empty fileds"
			echo "Exiting in 10 seconds"
			sleep 10
			exit 0
		fi
	fi
	
	if [[ $o_cnt > $x_cnt ]]
	then
		which_player_turn=0
	elif [[ $o_cnt < $x_cnt ]]
	then
		which_player_turn=1
	fi
}

is_game_with_computer()
{
	read -rp "Do you wish to play with computer, if yes provide y: " keyword
	
	if [[ $keyword == "y" ]]
	then
		game_with_comp=1
	fi
}

tictoe()
{
	declare -A arr
	declare -i which_player_turn=$((RANDOM%2))
	declare -i game_with_comp
	
	arr[1,1]="."
	arr[1,2]="."
	arr[1,3]="." 
	arr[2,1]="."
	arr[2,2]="."
	arr[2,3]="."
	arr[3,1]="."
	arr[3,2]="."
	arr[3,3]="."
	
	start_message
	is_game_with_computer
	
	load_game
	game_on=true
	while $game_on
	do
		check_winner
		which_player_move
	done
}

tictoe