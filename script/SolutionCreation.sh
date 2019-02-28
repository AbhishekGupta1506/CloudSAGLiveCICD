#! /bin/sh

SessionID=""
CSRFToken=""
loginSuccessCode="302"
ResponseSuccessCode="200"
SolutionCreationSuccessCode="201"
echo -e "##########Login to IC initialized##########"

curl -v -d "username=abg%40softwareag.com" -d "password=Passw0rd%4054321" -d "op=Log%20in" --keepalive-time 600 POST https://siqa2.saglive.com/integration/login -D login.txt

ResCo=`cat login.txt | head -n 1 | cut -d $' ' -f2`
#echo "ResCo: " $ResCo
#echo "loginSuccessCode: " $loginSuccessCode
JSession="JSESSIONID"
if [ "$ResCo" = "$loginSuccessCode" ]; then
	#echo "inside if"
	while read f
	do
		#echo $f
		#echo $JSession
		if [[ "$f" == *"$JSession"* ]]; then
			#responseCode=`$f | cut -d $' ' -f2`
			echo -e "******************************************************"
			echo $f |  cut -d$' ' -f2
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


echo -e "##########Login to IC successful##########"

echo -e "##########Checking ISSessionActive##########"
curl -vi --cookie "UserType=Platform; lang=en; route=lj-01; $SessionID login=" GET "https://siqa2.saglive.com/integration/isSessionActive" > csrfToken.txt

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
echo -e "##########Completed ISSessionActive##########"

echo -e "##########Solution Creation initialized##########"
curl -vi -H "Accept: application/json" -H "Content-Type: application/json" -H "x-csrf-token: $CSRFToken" -H "Cookie: UserType=Platform; route=lj-01; $SessionID login=; lang=en" --data @createsol.json POST https://siqa2.saglive.com/integration/rest/landscapes/Sol1 -D SolutionCreationResponse.txt
ResCo2=`cat SolutionCreationResponse.txt | head -n 1 | cut -d $' ' -f2`
if [ "$ResCo2" = "$SolutionCreationSuccessCode" ]; then
	echo -e "**************************************************"
	echo  "Solution Creation successfully with code $ResCo2"
	echo -e "**************************************************"
else
	echo -e "##########Solution Creation failed with Status Code $ResCo2##########"
	exit 1
fi

echo -e "##########Solution Creation Complated##########"
