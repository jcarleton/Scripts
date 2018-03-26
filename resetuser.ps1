#############################################
#  Password Reset Script by Jesse Carleton  #
#############################################
# Resets password if not changed in n days  #
#   Intended for use in a password audit    #
#   Users are notified to change their AD   #
#  passwords and are given n days to do so  #
#############################################

#Var to define how many days threshold

$NumberDays = 28

#Loop through the list

Get-Content C:\Temp\reset-users.txt | ForEach-Object {
	$Target = Get-ADUser -identity $_ -properties passwordlastset | select samAccountname,passwordlastset
	If ($Target.passwordlastset -eq $null) {
	echo $Target.samAccountname "has never set a password?!`n`n"
	}
	Else {
	If ($((Get-Date) - $Target.PasswordLastSet).Days -gt $NumberDays) {
		Set-aduser $Target.samAccountname -changepasswordatlogon $true
		echo $Target.samAccountname "password marked for change!`n`n"
		}
	Else {
	echo $Target.samAccountname "has already changed the password at notification!`n`n"    
	}
	}
	}
