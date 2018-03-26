#############################################
#  Password Reset Script by Jesse Carleton  #
#############################################
# Resets password if not changed in n days  #
#   Intended for use in a password audit    #
#   Users are notified to change their AD   #
#  passwords and are given n days to do so  #
#############################################

#Var to define how many days threshold

$NumberDays = 31

#Loop through the list

Get-Content C:\Temp\reset-users.txt | ForEach-Object {	
	Get-ADUser -identity $user -properties passwordlastset | select samAccountname,passwordlastset
	If ($(((Get-Date) - $User.PasswordLastSet).Days) -gt $NumberDays) {
		Set-aduser $User.samAccountname -changepasswordatlogon $true
		echo "$User password marked for change!"}
	Else {
	echo "$User has already changed the password at notification!"    
	}
}
