# procmi.ps1

$date = Get-Date -UFormat '%y%m%d-%H%M%S'
    
if($args.Count -gt 0) {

    for($i=0; $i -lt $args.Count; $i++) {

        $fileName = $args[$i]+"--"+$date+".txt"
        $location = (Get-Location).Path
        New-Item -Path . -Itemtype File -Name $fileName  -Force
        Add-Content -Path $fileName -Value (" 
        *********** Minne info om prosess med PID " + $args[$i] + " ***********
        Total bruk av virtuelt minne:
        Størrelse på Working Set:"
        )
    
    }
         
} else {
    Write-Host ("You passed $($args.Count) arguments:")
}