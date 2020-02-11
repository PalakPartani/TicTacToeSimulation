#!/bin/bash -x
echo "Welcome to TicTacToe game.Good Luck!"
#declare constants
readonly POSITION=9

#initailize the board
declare -a gameBoard

#function to display the board.
function displayBoard(){
	for (( i=1; i<=$POSITION; i=$(($i+3)) ))
	do
		echo "${gameBoard[i]} |  ${gameBoard[i+1]} | ${gameBoard[i+2]}"
	done
}

#function to assign sign to player
function assignSignToPlayer(){
	assignedLetter=$(($((RANDOM%2))+1))
	if [ $assignedLetter -eq 0 ]
	then
		userSign="X"
	else
		userSign="O"
	fi
}
assignSignToPlayer
