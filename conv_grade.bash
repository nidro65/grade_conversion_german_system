#!/bin/bash

sel=""

rounding_func() {
	# param #1: precision,  param #2: input
	# echo "param 1: $1"
	# echo "param 2: $2"
	
	tmp=$(echo "scale=0; ($2 * 10^$1)+0.5" | bc)  # >.5+0.5 will be one higher everything else one lower when decimals are cut
	output=$(echo "scale=$1; ($tmp / (10^$1))" | bc)
}

convert_to_german_func() {
	printf "\n-- CONVERT FOREIGN GRADE TO GERMAN GRADE --"
	printf "\nInsert highest foreign grade:\n"
	read -p "--> " foreign_highest
	printf "Insert lowest foreign passing grade:\n"
	read -p "--> " foreign_lowest
	printf "Insert your foreign grade:\n"
	read -p "--> " foreign_grade
	
	result=$(echo "scale=4; (1 + 3*($foreign_highest-$foreign_grade) / ($foreign_highest-$foreign_lowest))" | bc)
	
	rounding_func 2 $result
	german_grade=$output
	
	printf "\nYour grade in german grade scale is: \e[1m $german_grade \e[0m (rounded to second digit)\n\n"
	
	return 1
}

convert_from_german_func() {
	printf "\n-- CONVERT GERMAN GRADE TO FOREIGN GRADE --"
	printf "\nInsert highest foreign grade:\n"
	read -p "--> " foreign_highest
	printf "Insert lowest foreign passing grade:\n"
	read -p "--> " foreign_lowest
	printf "Insert your german grade:\n"
	read -p "--> " german_grade
	
	result=$(echo "scale=4; $foreign_highest - (1/3)*($german_grade-1)*($foreign_highest-$foreign_lowest)" | bc)
	
	rounding_func 2 $result
	foreign_grade=$output
	
	printf "\nYour german grade in foreign grade scale is: \e[1m $foreign_grade \e[0m (rounded to second digit)\n\n"
	
	return 1
}

selection_func() {
	printf "\nPlease type '1' for conversion to german grading system.\nPlease type '2' for conversion from german grading system.\n"
	read -p "--> " sel
	
	if [[ sel -eq 1 ]]; then
		convert_to_german_func
		return $?
	elif [[ sel -eq 2 ]]; then
		convert_from_german_func
		return $?
	else
		return 0
	fi
}


# __MAIN__

printf "\nConversion of grade by modified bavarian formula:"
printf "\nSource: https://www.kmk.org/fileadmin/Dateien/pdf/ZAB/Hochschulzugang_Beschluesse_der_KMK/GesNot05.pdf\n"

while selection_func ; do  # while selection_func() returns 0 ("true")
	printf "Wrong input! Please try again...\n"
done

