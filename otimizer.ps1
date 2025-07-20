# Windows Cleaner & Debloater - Otimizador para Windows 10/11
# Autor: Adriano - ADF Serviços de Informática
# Versão: 0.1.0

function Run-DISM-SFC {
    Write-Host "`n[+] Executando DISM e SFC..." -ForegroundColor Cyan
    DISM /Online /Cleanup-Image /RestoreHealth
    sfc /scannow
    Write-Host "`n[✓] DISM e SFC concluídos." -ForegroundColor Green
}

function Disable-Telemetry {
    Write-Host "`n[+] Desativando Telemetria e Coleta de Dados..." -ForegroundColor Cyan
    $regPaths = @(
        "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection",
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
    )

    foreach ($path in $regPaths) {
        New-Item -Path $path -Force | Out-Null
        Set-ItemProperty -Path $path -Name AllowTelemetry -Value 0 -Force
    }

    Write-Host "[✓] Telemetria desativada." -ForegroundColor Green
}

function Disable-BackgroundApps {
    Write-Host "`n[+] Desativando Apps em Segundo Plano..." -ForegroundColor Cyan
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f
    Write-Host "[✓] Apps em segundo plano desativados." -ForegroundColor Green
}

function Optimize-Performance {
    Write-Host "`n[+] Aplicando otimizações de desempenho..." -ForegroundColor Cyan
    powercfg -setactive SCHEME_MIN
    bcdedit /set useplatformclock true
    Write-Host "[✓] Otimizações aplicadas." -ForegroundColor Green
}

function Run-Windows10Debloater {
    Write-Host "`n[+] Executando Windows10Debloater..." -ForegroundColor Cyan
    irm https://git.io/debloat | iex
    Write-Host "[✓] Debloat concluído." -ForegroundColor Green
}

function Show-Menu {
    Clear-Host
    Write-Host "===============================" -ForegroundColor Yellow
    Write-Host "  Otimizador Windows 10/11     " -ForegroundColor Cyan
    Write-Host "       ADF Serviços TI         " -ForegroundColor Gray
    Write-Host "===============================" -ForegroundColor Yellow
    Write-Host "1. Executar DISM e SFC"
    Write-Host "2. Desativar Telemetria"
    Write-Host "3. Desativar Apps em Segundo Plano"
    Write-Host "4. Aplicar Otimizações de Desempenho"
    Write-Host "5. Executar Windows10Debloater"
    Write-Host "6. Executar Tudo"
    Write-Host "0. Sair"
}

do {
    Show-Menu
    $option = Read-Host "Escolha uma opção"

    switch ($option) {
        '1' { Run-DISM-SFC }
        '2' { Disable-Telemetry }
        '3' { Disable-BackgroundApps }
        '4' { Optimize-Performance }
        '5' { Run-Windows10Debloater }
        '6' {
            Run-DISM-SFC
            Disable-Telemetry
            Disable-BackgroundApps
            Optimize-Performance
            Run-Windows10Debloater
        }
        '0' { break }
        default { Write-Host "Opção inválida." -ForegroundColor Red }
    }

    Write-Host "`nPressione Enter para continuar..." -ForegroundColor Gray
    [void][System.Console]::ReadLine()
} while ($true)

