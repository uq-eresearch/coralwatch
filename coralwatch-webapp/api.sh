#!/bin/bash

# Test script for CoralWatch Web Service ($BASE_URL/coralwatch/api).
# Either set BASE_URL below or provide site URL as a command-line parameter.
# Note: the provided base URL should not contain a trailing slash.

BASE_URL='http://coralwatch-uat.metadata.net'
if [[ -n "$1" ]]; then BASE_URL="$1"; fi

function heading
{
  echo
  echo "--------------------------------------------------------------------------------"
  echo "$1"
  echo "--------------------------------------------------------------------------------"
  echo
}

function curl_
{
  curl -s --trace-ascii - 2>&1 "$@"
}

function trace
{
  heading "Register new user: automatically logs in as that user"
  userCreateOut=$(tempfile)
  userRandNum=$RANDOM
  userEmail="api-user-${userRandNum}@example.org"
  curl_ -X POST "${BASE_URL}/coralwatch/api/user" \
    --data-urlencode "email=${userEmail}" \
    --data-urlencode "email2=${userEmail}" \
    --data-urlencode "password=correctpassword" \
    --data-urlencode "password2=correctpassword" \
    --data-urlencode "displayName=User ${userRandNum}" \
    --data-urlencode "firstName=User" \
    --data-urlencode "lastName=${userRandNum}" \
    --data-urlencode "addressLine1=Unit 123" \
    --data-urlencode "addressLine2=456 Test St" \
    --data-urlencode "city=Testville" \
    --data-urlencode "state=Qld" \
    --data-urlencode "postcode=4072" \
    --data-urlencode "country=Australia" \
    > $userCreateOut
  userUrl=$(grep -o 'Location: .*' $userCreateOut | sed 's/Location: //' | sed 's/\s//g')
  cookie=$(grep -o 'JSESSIONID=[0-9A-F]*' $userCreateOut)
  cat $userCreateOut
  rm $userCreateOut
  
  heading "View resulting user when logged in as that user: shows all details"
  curl_ -X GET "${BASE_URL}${userUrl}" --cookie "$cookie"
  
  heading "Log out to show change in read user response"
  curl_ -X POST "${BASE_URL}/coralwatch/api/logout" --cookie "$cookie"
  
  heading "View resulting user when logged out: shows limited details"
  curl_ -X GET "${BASE_URL}${userUrl}"
  
  heading "Log in with incorrect password: returns error"
  curl_ -X POST "${BASE_URL}/coralwatch/api/login" \
    --data-urlencode "email=${userEmail}" \
    --data-urlencode "password=incorrectpassword"
  
  heading "Log in with correct password: returns session cookie"
  loginOut=$(tempfile)
  curl_ -X POST "${BASE_URL}/coralwatch/api/login" \
    --data-urlencode "email=${userEmail}" \
    --data-urlencode "password=correctpassword" \
    > $loginOut
  cookie=$(grep -o 'JSESSIONID=[0-9A-F]*' $loginOut)
  cat $loginOut
  rm $loginOut
  
  heading "Create new survey with missing/invalid felds: returns error"
  curl_ -X POST "${BASE_URL}/coralwatch/api/survey" \
    --cookie "$cookie" \
    --data-urlencode "groupName=maenad" \
    --data-urlencode "participatingAs=Scientist" \
    --data-urlencode "country=Australia" \
    --data-urlencode "reefName=Front Reef Edge Slope" \
    --data-urlencode "date=$(date +%F)" \
    --data-urlencode "time=noon" \
    --data-urlencode "lightCondition=Full Sunshine" \
    --data-urlencode "depth=12" \
    --data-urlencode "waterTemperature=25" \
    --data-urlencode "activity=Reef walking" \
    --data-urlencode "comments=testing"
  
  heading "Create new survey with valid form: returns URL for survey in Location header"
  surveyCreateOut=$(tempfile)
  curl_ -X POST "${BASE_URL}/coralwatch/api/survey" \
    --cookie "$cookie" \
    --data-urlencode "groupName=maenad" \
    --data-urlencode "participatingAs=Scientist" \
    --data-urlencode "country=Australia" \
    --data-urlencode "reefName=Front Reef Edge Slope" \
    --data-urlencode "latitude=-24.647017" \
    --data-urlencode "longitude=152.34668" \
    --data-urlencode "date=$(date +%F)" \
    --data-urlencode "time=$(date +%H:%M)" \
    --data-urlencode "lightCondition=Full Sunshine" \
    --data-urlencode "depth=12" \
    --data-urlencode "waterTemperature=25" \
    --data-urlencode "activity=Reef walking" \
    --data-urlencode "comments=testing" \
    > $surveyCreateOut
  surveyUrl=$(grep -o 'Location: .*' $surveyCreateOut | sed 's/Location: //' | sed 's/\s//g')
  cat $surveyCreateOut
  rm $surveyCreateOut
  
  heading "Create first record in survey"
  curl_ -X POST "${BASE_URL}${surveyUrl}/record" \
    --cookie "$cookie" \
    --data-urlencode "coralType=Branching" \
    --data-urlencode "lightest=B1" \
    --data-urlencode "darkest=B6"
  
  heading "Create second record in survey"
  curl_ -X POST "${BASE_URL}${surveyUrl}/record" \
    --cookie "$cookie" \
    --data-urlencode "coralType=Plate" \
    --data-urlencode "lightest=C2" \
    --data-urlencode "darkest=C4"
  
  heading "Logout"
  curl_ -X POST "${BASE_URL}/coralwatch/api/logout" --cookie "$cookie"
  
  heading "Read newly-created survey: includes serialisation of reef and survey records"
  curl_ -X GET "${BASE_URL}${surveyUrl}"
  
  heading "Read list of reefs in CoralWatch"
  curl_ -X GET "${BASE_URL}/coralwatch/api/reef" | head -n 40
  
  echo # ensure line cleared after output of last request
}

# Run trace excluding excessive output generated by curl --trace-ascii
trace | grep -v '== Info\|=> Send\|<= Recv'
