Note:   
Powershell scripts are run in Powershell. Type powershell in the search bar beside the Windows start menu.  
In order to run powershell scripts you must enable them to run. Mine isn't signed so you will have to allow unsigned scripts to run.  
The command to do that is:  
Set-ExecutionPolicy Unrestricted

This will likely give you an error so you have to run powershell as administrator by right clicking on it and selecting run as administrator when you see the icon in the search results.
Then you have to change directory to the directory where you saved the script with the cd command.  
Finally run the script:  
./banbadpeers.ps1
