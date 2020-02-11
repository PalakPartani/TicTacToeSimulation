#!/bin/bash -x
echo "Welcome to TicTacToe game.Good Luck!"
#declare constants
readonly POSITION=9
readonly RESET_LETTER="_"

#declare variables
stop=false
count=1
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
function assignSignToPlayerAndToss(){
	assignedLetter=$((RANDOM%2))
	if [ $assignedLetter -eq 0 ]
	then
		userSign="X"
		computerSign="O"
		playerMove
	else
		computerSign="X"
		userSign="O"
		playerMove
	fi
}
#function to input player move and check if it is not filled.
function playerMove(){
	read -p "Enter where you want to mark :" playerMarkPosition
	if [[ ${gameBoard[$playerMarkPosition]} == $RESET_LETTER ]]
	then
		gameBoard[$playerMarkPosition]=$userSign
	else
		echo "already filled"
	fi
	checkRowWinningCondition $userSign
	checkColumnWinningCondition $userSign
  	checkDiagonalWinningCondition $userSign
	displayBoard
	checkTie
}
#function to check winning condition for row 
function checkRowWinningCondition(){
   for (( i=1; i<=9; i=i+3 ))
   do
      if [[ ${gameBoard[$i]} == $1 && ${gameBoard[$(($i+1))]} == $1 && ${gameBoard[$(($i+2))]} == $1 ]]
      then
         displayBoard
         stop=true
         break
      fi
   done
}
#function to check winning condition for column
function checkColumnWinningCondition(){
	for (( i=1; i<=3; i++ ))
	do
		if [[ ${gameBoard[$i]} == $1 && ${gameBoard[$(($i+3))]} == $1 && ${gameBoard[$(($i+6))]} == $1 ]]
		then
			displayBoard
			stop=true
			break
		fi
	done
}
#function to check winning condition for diagonal
function checkDiagonalWinningCondition(){
	for (( i=1; i<2; i++ ))
	do
		if [[ ${gameBoard[$i]} == $1 && ${gameBoard[$(($i+4))]} == $1 && ${gameBoard[$(($i+8))]} == $1 ]]
		then
			displayBoard
			stop=true
			break
		elif [[ ${gameBoard[$(($i+2))]} == $1 && ${gameBoard[$(($i+4))]} == $1 && ${gameBoard[$(($i+6))]} == $1 ]]
		then
			displayBoard
			stop=true
			break
		fi
	done
}

#function to check if there is a tie when no one wins and board is filled.
function checkTie(){
	while [ ${gameBoard[$count]} != '_' ]
	do
		if [ $count -eq 9 ]
		then
			displayBoard
			echo "Game is a tie"
			stop=true
			exit
		else
			count=$(($count+1))
		fi
	done
}
#function from where main execution will start
function main() {		
	while [ $stop == false ]
	do
		displayBoard
		assignSignToPlayerAndToss
	done
}
main
