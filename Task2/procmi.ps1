# procmi.ps1

$date = Get-Date -UFormat '%y%m%d-%H%M%S'
    
if($args.Count -gt 0) {

    for($i=0; $i -lt $args.Count; $i++) {

        $fileName = ""+$args[$i]+"--"+$date+".txt"
        $location = (Get-Location).Path
        $mem = (Get-Process -id $args[$i]).VirtualMemorySize / 1MB
        $ws = (Get-Process -id $args[$i]).WorkingSet 
        New-Item -Path . -Itemtype File -Name $fileName  -Force
        Add-Content -Path $fileName -Value (" 
        *********** Minne info om prosess med PID " + $args[$i] + " ***********`n" +
        "Total bruk av virtuelt minne: " + $mem + "MB`n" +
        "Størrelse på Working Set:" + $ws + "KB"
        )
    }
         
} else {
    Write-Host ("You passed $($args.Count) arguments:")
}