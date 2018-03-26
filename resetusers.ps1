#############################################
#  Password Reset Script by Jesse Carleton  #
#############################################
# Resets password if not changed in n days  #
#############################################

#Var to define how many days threshold

$NumberDays = 7

#Loop through the list

Get-Content C:\Temp\reset-users.txt | ForEach-Object {
	$Target = Get-ADUser -identity $_ -properties passwordlastset | select samAccountname,passwordlastset
	If ($Target.passwordlastset -eq $null) {
	Write-Host $Target.samAccountname "has never set a password?!`n`n"
	}
	Else {
	If ($((Get-Date) - $Target.PasswordLastSet).Days -gt $NumberDays) {
		Set-aduser $Target.samAccountname -changepasswordatlogon $true
		Write-Host $Target.samAccountname "password marked for change!`n`n"
		}
	Else {
	Write-Host $Target.samAccountname "has already changed the password at notification!`n`n"    
	}
	}
	}
