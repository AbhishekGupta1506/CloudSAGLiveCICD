@echo off

REM ABE install


SET version=103
SET server=aquarius-blr
SET installer.prefix=webM103
SET install.dir=C:\SoftwareAG%version%ABE

SET installer=http://%server%/PDShare/WWW/dataserve%installer.prefix%/data/SoftwareAGInstaller.jar

if exist %install.dir% (
	echo "SoftwareAG%version%ABE installation exist at C:"
	) else (
		 echo "SoftwareAG%version%ABE installation does exist at C: preparing to install"
		 if exist %cd%\SoftwareAGInstaller.jar (
		 echo "Installer exist"
		 ) else (
			   echo "downloading... SoftwareAG installer ...."
			   curl -o %cd%\SoftwareAGInstaller.jar %installer%
			   )
		echo "Installing ... ABE in directory C:\SoftwareAG%version%ABE ..."
		start /B /wait java -jar %cd%\SoftwareAGInstaller.jar -readScript %cd%\ABEInstallationScript.txt -console
    )

REM exit