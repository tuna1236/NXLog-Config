# This file contains the list of servers you want to copy files/folders to
$computers = Get-Content "C:\Mass Edit\Servers.txt"
 
# This is the file/folder(s) you want to copy to the servers in the $computer variable
$source = "C:\Mass Edit\nxlog.conf"
 
# The destination location you want the file/folder(s) to be copied to
$destination = "C$\Program Files (x86)\nxlog\conf"
 
foreach ($computer in $computers) {
if ((Test-Path -Path \\$computer\$destination)) {
Copy-Item $source -Destination \\$computer\$destination -Verbose
}
}
