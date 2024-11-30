#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
  then
    echo "Please provide an element as an argument."
  else

  if [[ $1 =~ ^[0-9]+$ ]]
      then
        ATOMIC_NUMBER_RESULT=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1;")
        if [[ -z $ATOMIC_NUMBER_RESULT ]]
          then
            echo "I could not find that element in the database."
          else
            IFS="|" read NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT <<< $($PSQL "SELECT name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER_RESULT;")
            echo "The element with atomic number $ATOMIC_NUMBER_RESULT is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
        fi
    elif [[ $1 =~ ^[A-Za-z]{1,2}$ ]]
      then
        SYMBOL_RESULT=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1';")
        if [[ -z $SYMBOL_RESULT ]]
          then
            echo "I could not find that element in the database."
          else
            IFS="|" read ATOMIC_NUMBER NAME TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT <<< $($PSQL "SELECT atomic_number, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE symbol='$SYMBOL_RESULT';")
            echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL_RESULT). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
        fi
    elif [[ $1 =~ ^[A-Za-z]+$ ]]
      then
        NAME_RESULT=$($PSQL "SELECT name FROM elements WHERE name='$1';")
        if [[ -z $NAME_RESULT ]]
          then
            echo "I could not find that element in the database."
          else
            IFS="|" read ATOMIC_NUMBER SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT <<< $($PSQL "SELECT atomic_number, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE name='$NAME_RESULT';")
            echo "The element with atomic number $ATOMIC_NUMBER is $NAME_RESULT ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME_RESULT has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
        fi
    fi
fi
