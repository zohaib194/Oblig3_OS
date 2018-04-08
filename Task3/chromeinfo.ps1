#process name
$process = "chrome"

Get-Process $process |
Select-Object Name, ID, @{Name='ThreadCount';Expression ={$_.Threads.Count}} |
Sort-Object -Property ThreadCount -Descending