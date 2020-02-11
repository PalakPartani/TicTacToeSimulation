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
		computerMove
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
#function to take computer move and check condition.
function computerMove(){
	local winValue=$( possiblePosition $computerSign )
	local randomValue=$(($((RANDOM%9))+1))
	if [[ ${gameBoard[$winValue]} == $RESET_LETTER ]]
	then
		gameBoard[$winValue]=$computerSign
	elif [[ ${gameBoard[$randomValue]} == $RESET_LETTER ]]
	then
		gameBoard[$randomValue]=$computerSign
	fi
	checkRowWinningCondition $computerSign
	checkColumnWinningCondition $computerSign
	checkDiagonalWinningCondition $computerSign
	displayBoard
	checkTie
	playerMove
}
#function to retrieve row position that can lead computer to win
function getSmartRowPosition(){
	for (( i=1; i<=$POSITION; i=$(($i+3)) ))
	do
		if [[ ${gameBoard[$i]} == ${gameBoard[$i+1]} ]] &&  [[ ${gameBoard[$i+1]} == $1 ]]
		then
			if [[ ${gameBoard[$i+2]} == $RESET_LETTER ]]
			then
				echo "$(($i+2))"
				break
			fi
		elif [[ ${gameBoard[$i]} == ${gameBoard[$i+2]} ]] &&  [[ ${gameBoard[$i+2]} == $1  ]]
		then
			if [[ ${gameBoard[$i+1]} == $RESET_LETTER ]]
			then
				echo "$(( $i+1 ))"
				break
			fi
		elif [[ ${gameBoard[$i+1]} == ${gameBoard[$i+2]} ]] &&  [[ ${gameBoard[$i+2]} == $1  ]]
		then
			if [[ ${gameBoard[$i+1]} == $RESET_LETTER ]]
			then
				echo "$(( $i ))"
				break
			fi
		fi
	done
}
#function to retrieve column position that can lead computer to win
function getSmartColumnPosition(){
	for (( i=1; i<=$POSITION; i=$(($i+1)) ))
	do
		if [[ ${gameBoard[$i]} == ${gameBoard[$i+3]} ]] &&  [[ ${gameBoard[$i+3]} == $1 ]]
		then
			if [[ ${gameBoard[$i+6]} == $RESET_LETTER ]]
			then
				echo " $(($i+6))"
				break
			fi
		elif [[ ${gameBoard[$i]} == ${gameBoard[$i+6]} ]] &&  [[ ${gameBoard[$i+6]} == $1  ]]
		then
			if [[ ${gameBoard[$i+3]} == $RESET_LETTER ]]
			then
				echo "$(( $i+3 ))"
				break
			fi
		elif [[ ${gameBoard[$i+3]} == ${gameBoard[$i+6]} ]] &&  [[ ${gameBoard[$i+6]} == $1  ]]
		then
			if [[ ${gameBoard[$i]} == $RESET_LETTER ]]
			then
				echo "$(( $i ))"
				break
			fi
		fi	
	done
}
#function to retrieve diagonal position that can lead computer to win
function getSmartDiagonalPosition(){
	if [ ${gameBoard[1]} == ${gameBoard[5]} ] && [ ${gameBoard[5]} == $1 ]
	then
		if [ ${gameBoard[9]} == $RESET_LETTER ]
		then
			echo "9"
		fi
	elif [ ${gameBoard[1]} == ${gameBoard[9]} ] && [ ${gameBoard[9]} == $1 ]
	then
		if [ ${gameBoard[5]} == $RESET_LETTER ]
		then
			echo "5"
		fi
	elif [ ${gameBoard[5]} == ${gameBoard[9]} ] && [ ${gameBoard[9]} == $1 ]
	then
		if [ ${gameBoard[1]} == $RESET_LETTER ]
		then
			echo "1"
		fi
	elif [ ${gameBoard[3]} == ${gameBoard[5]} ] && [ ${gameBoard[5]} == $1 ]
	then
		if [ ${gameBoard[7]} == $RESET_LETTER ]
		then
			echo "7"
		fi
	elif [ ${gameBoard[7]} == ${gameBoard[5]} ] && [ ${gameBoard[5]} == $1 ]
	then
		if [ ${gameBoard[3]} == $RESET_LETTER ]
		then
			echo "3"
		fi
	elif [ ${gameBoard[3]} == ${gameBoard[7]} ] && [ ${gameBoard[7]} == $1 ]
	then
		if [ ${gameBoard[5]} == $RESET_LETTER ]
		then
			echo "5"	
		fi
	fi
}
#function to check possible position
function possiblePosition(){
	local row=$( getSmartRowPosition $1 )
	if [[ $row -eq ' ' ]]
	then
		local column=$( getSmartColumnPosition $1)
		if [[ $column -eq ' ' ]]
		then
			local diagonal=$( getSmartDiagonalPosition $1)
			if [[ $diagonal -eq ' ' ]]
			then
				echo "0"
			else
				echo "$diagonal"
			fi
		else
			echo "$column"
		fi
   else
      echo "$row"
   fi

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
