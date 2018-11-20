@echo off

REM ABE install


SET version=103
SET server=aquarius-blr
SET installer.prefix=webM103
SET install.dir=C\:\\SoftwareAG%version%ABE

SET installer=http://%server%/PDShare/WWW/dataserve%installer.prefix%/data/SoftwareAGInstaller.jar

if exist %install.dir% (
	echo "SoftwareAG%version%ABE installation exist at C:"
	) else (
		 echo "SoftwareAG%version%ABE installation does exist at C:"
		 if exist C:%homepath%\Downloads\SoftwareAGInstaller.jar (
		 echo "Installer exist"
		 ) else (
			   echo "downloading... SoftwareAG installer ...."
			   curl -o C:\Users\Administrator\Downloads\SoftwareAGInstaller.jar http://aquarius-blr/PDShare/WWW/dataservewebM103/data/SoftwareAGInstaller.jar
			   )
		echo "Installing ... ABE ..."
		start /B /wait java -jar C:%homepath%\Downloads\SoftwareAGInstaller.jar -readScript C:\Users\Administrator\Desktop\ABEInstallationScript.txt
    )

REM exit