Get-Process $args[0] |
Select-Object Name, ID, @{Name='ThreadCount';Expression ={$_.Threads.Count}} |
Sort-Object -Property ThreadCount -Descending