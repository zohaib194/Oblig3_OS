# myprocinfo.ps1


$script = $MyInvocation.MyCommand.Name

Write-Host "
    1 - Hvem er jeg og hva er navnet p˚a dette scriptet?
    2 - Hvor lenge er det siden siste boot?
    3 - Hvor mange prosesser og tr˚ader finnes?
    4 - Hvor mange context switch'er fant sted siste sekund?
    5 - Hvor stor andel av CPU-tiden ble benyttet i kernelmode og i usermode siste sekund?
    6 - Hvor mange interrupts fant sted siste sekund?
    9 - Avslutt dette scriptet"

Do {
    Write-Host "Velg en funksjon:"
    $ans = Read-Host
    switch ($ans) {
        1 {Write-Host "Jeg er Zohaib. Scriptet heter $script"}
        2 {
            $uptime = (Get-Date) - (Get-CimInstance -ClassName win32_operatingsystem).LastBootUpTime
            Write-Host("Siste boot: " + $uptime.Hours + "h, " + $uptime.Minutes + "m")
        }
        3 {
            $threads = (Get-CimInstance -ClassName win32_Thread).count
            $process = (Get-Process | Sort-Object name| Get-Unique | measure).count
            Write-Host("Det finnes " + $threads + " tråder og " + $process + " processer.")       
        }
        4 {
            $contextSwitch = (Get-CimInstance -ClassName Win32_PerfFormattedData_PerfOS_System).ContextSwitchesPersec
            Write-Host("Det har vært " + $contextSwitch + " context switch")
        }
        5 {
            $procs = (Get-Process -ComputerName .)
            foreach($proc in $procs){
                $kernelMode = $kernelMode + $proc.PrivilegedProcessorTime.TotalMilliseconds
                $userMode = $userMode + $proc.UserProcessorTime.TotalMilliseconds
            }
    
            sleep(1);
            
            foreach($proc in $procs){
                $currentKernelMode = $currentKernelMode + $proc.PrivilegedProcessorTime.TotalMilliseconds
                $currentUserMode = $currentUserMode + $proc.UserProcessorTime.TotalMilliseconds
            }
    
            $diffKernelMode = $currentKernelMode - $kernelMode 
            $diffUserMode = $currentUserMode - $userMode 
    
            $sum = $diffKernelMode + $diffUserMode
    
            $prosent = $sum * 100
    
            Write-Host("Det har vært " + $diffUserMode / $sum * 100 + "% av cpu tid benyttet i user mode og " + $diffKernelMode / $sum * 100 + "% av cpu tid benyttet i kernel mode" )
    
        }
        6 {
            $interrupts = (Get-CimInstance -ClassName Win32_PerfFormattedData_Counters_ProcessorInformation).InterruptsPersec
            Write-Host("Det har vært " + $interrupts[0] + " interrupts")
        }
    }
} While($ans -ne 9)