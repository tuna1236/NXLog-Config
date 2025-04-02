# Updated Date: 2020.09.15

# This is the file/folder(s) you want to copy to the servers in the $computer variable
$source = "\\Servername\NagiosLS\nxlog.conf"
 
# The destination location you want the file/folder(s) to be copied to
$destination = "c$\Program Files (x86)\nxlog\conf"

# gets a list of all the AD computers
$list = Get-ADComputer -Filter {OperatingSystem -like "*windows*server*"} -Properties * | Select -Expand Name 

# or a list: $list = get-content c:\list.txt
# or AD:     $list = Get-ADComputer -Filter *
foreach($PC in $list){
	# this Pings all the servers that are in active directory
	if (Test-Connection -computername $PC -count 1 -Quiet){
		# this adds the computers that respond to pings to a list
		$online = @($online + $PC)
		write-output "$PC Is Online"
	} else{
		# this adds all the servers that dont respond to a ping
		$offline = @($offline + $PC)
		write-output "$PC Is Offline"
		}
}

# shows what host are offline but still in active directory
write-host "These computers are offline, $offline"


# Checks if there is a nagios Log server directory
foreach($PC in $online){
    if (Test-Path "\\$PC\c$\Program Files (x86)\nxlog"){
		$computers = @($computers + $PC)
	} else{
		$not_installed = @($not_installed + $PC)
		}
}

foreach ($computer in $computers) {
# moves the nxlog config into these files
{Copy-Item $source -Destination \\$computer\$destination -Verbose}

write-output "$computer"

# starts and stops nagios log server
stop-service -inputobject $(get-service -ComputerName $computer -Name nxlog)
start-service -inputobject $(get-service -ComputerName $computer -Name nxlog)
}

clear-host 

# shows all the host that dont have nagios ls installed but are online
foreach($Yui in $not_installed){
    write-host "$Yui"
}
