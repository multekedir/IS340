TITLE "AWS"
@ECHO ON
set /p IP= Please enter an IP address:


IF EXIST AWS_Key.ppk (
	ECHO Connecting to %IP%
	putty -ssh ubuntu@%IP% -i AWS_Key.ppk
) ELSE ( 

	ECHO Error file not found
)   

 exit