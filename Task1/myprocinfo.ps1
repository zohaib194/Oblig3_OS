# myprocinfo.ps1


$script = $MyInvocation.MyCommand.Name

Write-Output "
    1 - Hvem er jeg og hva er navnet p˚a dette scriptet?
    2 - Hvor lenge er det siden siste boot?
    3 - Hvor mange prosesser og tr˚ader finnes?
    4 - Hvor mange context switch'er fant sted siste sekund?
    5 - Hvor stor andel av CPU-tiden ble benyttet i kernelmode og i usermode siste sekund?
    6 - Hvor mange interrupts fant sted siste sekund?
    9 - Avslutt dette scriptet"

Do {
    Write-Output "Velg en funksjon:"
    $ans = Read-Host
    switch ($ans) {
        1 {Write-Output "Jeg er Zohaib. Scriptet heter $script"}
        2 {
            $uptime = (Get-Date) - (Get-CimInstance -ClassName win32_operatingsystem).LastBootUpTime
            Write-Output("Siste boot: " + $uptime.Hours + "h, " + $uptime.Minutes + "m")
        }
        3 {
            $threads = (Get-CimInstance -ClassName win32_Thread | Get-Unique | Measure-Object).Count
            $process = (Get-Process | Sort-Object name| Get-Unique | Measure-Object).count
            Write-Output("Det finnes " + $threads + " tråder og " + $process + " processer.")       
        }
        4 {
            $contextSwitch = (Get-CimInstance -ClassName Win32_PerfFormattedData_PerfOS_System).ContextSwitchesPersec
            Write-Output("Det har vært " + $contextSwitch + " context switch")
        }
        5 {
            $procs = (Get-Process -ComputerName .)
            foreach($proc in $procs){
                $kernelMode = $kernelMode + $proc.PrivilegedProcessorTime.TotalMilliseconds
                $userMode = $userMode + $proc.UserProcessorTime.TotalMilliseconds
            }
    
            Start-Sleep(1);
            
            foreach($proc in $procs){
                $currentKernelMode = $currentKernelMode + $proc.PrivilegedProcessorTime.TotalMilliseconds
                $currentUserMode = $currentUserMode + $proc.UserProcessorTime.TotalMilliseconds
            }
    
            $diffKernelMode = $currentKernelMode - $kernelMode 
            $diffUserMode = $currentUserMode - $userMode 
    
            $sum = $diffKernelMode + $diffUserMode
    
            Write-Output("Det har vært " + $diffUserMode / $sum * 100 + "% av cpu tid benyttet i user mode og " + $diffKernelMode / $sum * 100 + "% av cpu tid benyttet i kernel mode" )
    
        }
        6 {
            $interrupts = (Get-CimInstance -ClassName Win32_PerfFormattedData_Counters_ProcessorInformation).InterruptsPersec
            Write-Output("Det har vært " + $interrupts[0] + " interrupts")
        }
    }
} While($ans -ne 9)