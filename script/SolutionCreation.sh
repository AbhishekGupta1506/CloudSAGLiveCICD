#! /bin/sh

###############################################################################
# Variable  Declaration
###############################################################################

URL=""
UserName=""
Password=""
SessionID=""
CSRFToken=""
loginSuccessCode="302"
ResponseSuccessCode="200"
SolutionCreationSuccessCode="201"
Declare -i SolutionExist

###############################################################################
# Function Declaration
###############################################################################

loginToIC () {
	curl -v -d "username=$UserName" -d "password=$Password" -d "op=Log%20in" --keepalive-time 600 POST https://$URL/integration/login -D login.txt

	ResCo=`cat login.txt | head -n 1 | cut -d $' ' -f2`
	JSession="JSESSIONID"
	if [ "$ResCo" = "$loginSuccessCode" ]; then
		while read f
		do
			if [[ "$f" == *"$JSession"* ]]; then
				echo -e "******************************************************"
				SessionID=`echo $f |  cut -d$' ' -f2`
				echo $SessionID
				echo -e "******************************************************"
			fi
		done < login.txt
	else
		echo -e "##########Login to IC failed with STATUS CODE: $ResCo##########"
		exit 1
	fi
	echo $SessionID
}

ISSessionActive () {
	curl -vi --cookie "UserType=Platform; lang=en; route=lj-01; $SessionID login=" GET "https://$URL/integration/isSessionActive" > csrfToken.txt
	ResCo1=`cat csrfToken.txt | head -n 1 | cut -d $' ' -f2`
	echo $ResCo1
	if [ "$ResCo1" = "$ResponseSuccessCode" ]; then
		CSRFToken=`tail -1 csrfToken.txt | cut -d$":" -f7 | cut -d'"' -f2`
		echo -e "*****************************************************"
		echo  "CSRFTOken: " $CSRFToken
		echo -e "*****************************************************"
	else
		echo -e "##########Collecting CSRF Toekn failed with STATUS CODE: $ResCo1##########"
		exit 1
	fi
}

getSolutions () {
	curl -vi -H "Cookie: UserType=Platform; lang=en; route=lj-01; userId=-2; $SessionID login=" -H "x-csrf-token: $CSRFToken" GET https://$URL/integration/rest/landscapes > landscapes.txt
	ResCo3=`cat landscapes.txt | head -n 1 | cut -d ' ' -f2`
	if [ "$ResCo3" = "$ResponseSuccessCode" ]; then		
		SolutionExist=`cat landscapes.txt | grep -i "Sol1" | wc -l` 
		if [ $SolutionExist == 1 ]; then
			echo -e "*************************************************"
			echo "Sol1 exist in the landscape"
			echo -e "*************************************************"
			return 1
		else
			echo -e "*************************************************"
			echo "Sol1 do not exist in the landscape"
			echo -e "*************************************************"
			return 0
		fi
	fi
}

deleteSolution () {
	getSolutions
	getSolutionsReturnStatus=$?
	if [ "$getSolutionsReturnStatus" = "1" ]; then
		curl -vi -H "Cookie: UserType=Platform; lang=en; route=lj-01; userId=-2; $SessionID login=" -H "x-csrf-token: $CSRFToken" -X DELETE https://$URL/integration/rest/landscapes/Sol1 > deleteSolution.txt
		ResCo4=`cat deleteSolution.txt | head -n 1 | cut -d ' ' -f2`
		if [ "$ResCo4" = "$ResponseSuccessCode" ]; then
			echo "***************************************************"
			echo "Solution 1 deleted successfully"
			echo "***************************************************"
		else
			echo "#########Solution Deletion failed##########"
			exit 1
		fi	
	fi
}

createSolution () {
	getSolutions
	getSolutionsReturnStatus=$?
	if [ "$getSolutionsReturnStatus" = "0" ]; then
		curl -vi -H "Accept: application/json" -H "Content-Type: application/json" -H "x-csrf-token: $CSRFToken" -H "Cookie: UserType=Platform; route=lj-01; $SessionID login=; lang=en" --data @createsol.json POST https://$URL/integration/rest/landscapes/Sol1 -D SolutionCreationResponse.txt
		ResCo2=`cat SolutionCreationResponse.txt | head -n 1 | cut -d $' ' -f2`
		if [ "$ResCo2" = "$SolutionCreationSuccessCode" ]; then
			echo -e "**************************************************"
			echo  "Solution Creation successfully with code $ResCo2"
			echo -e "**************************************************"
		else
			echo -e "##########Solution Creation failed with Status Code $ResCo2##########"
			exit 1
		fi
	fi
}

###############################################################################
# Main Declaration
###############################################################################



if [ "$#" -ne "3" ]; then
	echo "Pass all the variable"
	exit 1
fi	

URL=$1
UserName=$2
Password=$3

echo "First URL parameter:  " $1
echo "Second UserName parameter: " $2
echo "Third Password parameter: ********* " 

echo -e "##########Login to IC initialized##########"
loginToIC
echo -e "##########Login to IC successful##########"

echo -e "##########Checking ISSessionActive##########"
ISSessionActive
echo -e "##########Completed ISSessionActive##########"

echo -e "##########Delete Solution##########"
deleteSolution
echo -e "##########Solution Deleted##########"

echo -e "##########Solution Creation initialized##########"
createSolution
echo -e "##########Solution Creation Complated##########"
