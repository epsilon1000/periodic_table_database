#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

#check if input is a number 
if [[ $1 =~ ^[0-9]+$ ]]
then
  ELEMENT=$(echo $($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements AS e LEFT JOIN properties AS p USING(atomic_number) LEFT JOIN types AS t USING(type_id) WHERE e.atomic_number='$1' OR e.symbol ILIKE '$1' OR e.name ILIKE '$1';") | sed 's/ //g')
 else
  ELEMENT=$(echo $($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements AS e LEFT JOIN properties AS p USING(atomic_number) LEFT JOIN types AS t USING(type_id) WHERE e.symbol ILIKE '$1' OR e.name ILIKE '$1';") | sed 's/ //g')
 fi 

#If input exist
if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
else
  #check if ELEMENT not exist 
  if [[ -z $ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else
     echo $ELEMENT | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
     do
     echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
     done
  fi
fi
