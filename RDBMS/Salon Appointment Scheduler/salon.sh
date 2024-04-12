#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n"
# main menu
MAIN_MENU() {
    if [[ $1 ]]
    then
    echo -e "\nI could not find that service. What would you like today?"
    else
    echo -e "\nWelcome to my salon. How can I help you?"
    fi
    SERVICES=$($PSQL "SELECT service_id, name FROM services")
    echo "$SERVICES" | while read SERVICE_ID BAR NAME; do
    echo "$SERVICE_ID) $NAME"
    done
    read SERVICE_ID_SELECTED
    OFFER_SERVICE $SERVICE_ID_SELECTED
}

# offer_service
OFFER_SERVICE() {
    SERVICE=$($PSQL "SELECT name FROM services WHERE service_id='$1'")
    if [[ -z $SERVICE ]]
    then
    MAIN_MENU $1
    else
    # enter phone number
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers where phone='$CUSTOMER_PHONE'")
    # if phone number not found
    if [[ -z $CUSTOMER_NAME ]]
    then
    # ask for name
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER_NAME=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
    fi # line 36
    echo -e "\nWhat time would you like your $SERVICE, $CUSTOMER_NAME?"
    read SERVICE_TIME
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    INSERT_TIME=$($PSQL "INSERT INTO appointments(time, customer_id, service_id) VALUES('$SERVICE_TIME', '$CUSTOMER_ID', '$1')")
    echo -e "\nI have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
    fi # line 27
}
MAIN_MENU