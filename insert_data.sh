#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

#Cleaning the tables before the data insertions.
echo $($PSQL "TRUNCATE teams, games")

#Reading the .csv file and applying a loop to read each row
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS

do
  #FILLING THE TEAMS TABLE
  #Getting the winner team name
  if [[ $WINNER != "winner" ]]
  then 
    #get the team name
    WINNER_NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
    
    #if not found
    if [[ -z $WINNER_NAME ]]
    then 
      INSERT_WINNER_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")

      #Showing a message to confirm the insertion
      if [[ $INSERT_WINNER_NAME == "INSERT 0 1" ]]
      then
        echo "Inserted into teams, $WINNER"
      fi
    fi  
  fi

  #Getting the opponent team name
  if [[ $OPPONENT != "opponent" ]]
  then 
    #get the team name
    OPPONENT_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
    
    #if not found
    if [[ -z $OPPONENT_NAME ]]
    then 
      INSERT_OPPONENT_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")

      #Showing a message to confirm the insertion
      if [[ $INSERT_OPPONENT_NAME == "INSERT 0 1" ]]
      then
        echo "Inserted into teams, $OPPONENT"
      fi
    fi  
  fi

  #FILLING THE TEAMS TABLE
  if [[ $YEAR != year ]]
  then 
    #getting winner_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    #getting opponent_id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    #inserting data into table games
    INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    
    # Showing a message to confirm the insertion
    if [[ $INSERT_GAME == "INSERT 0 1" ]]
    then
      echo "Inserted into games: Year $YEAR, Round $ROUND, $WINNER vs $OPPONENT"
    fi
  fi
done
