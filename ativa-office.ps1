# ATIVA OFFICE v1.2 - MENU SIMPLES
param([ValidateSet("ativa","desativa","status","instalar")][string]$Acao)

$Url = "https://get.activated.win"
$ProfilePath = "$PROFILE"

Clear-Host
Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan
Write-Host "         🎯 ATIVA OFFICE v1.2          " -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan

function Show-Menu {
    Write-Host "`n[1] 🚀 ATIVAR Office (massgrave.dev)" -ForegroundColor Green
    Write-Host "[2] ❌ DESATIVAR alias" -ForegroundColor Red
    Write-Host "[3] ℹ️  STATUS" -ForegroundColor Yellow
    Write-Host "[4] 💾 INSTALAR permanente" -ForegroundColor Blue
    Write-Host "`nDigite 1-4 ou ESC para sair: " -ForegroundColor Gray -NoNewline
}

function Install-Permanente {
    if(!(Test-Path $ProfilePath)){ New-Item -Path $ProfilePath -ItemType File -Force | Out-Null }
    
    $aliasCode = @"
function ATIVA-OFFICE-MENU {
    & `"$($MyInvocation.MyCommand.Path)`" 
}
Set-Alias ativa-office ATIVA-OFFICE-MENU
Set-Alias ao ATIVA-OFFICE-MENU
"@
    
    if((Get-Content $ProfilePath -ErrorAction SilentlyContinue) -notmatch "ATIVA-OFFICE-MENU") {
        $aliasCode | Out-File $ProfilePath -Append -Encoding UTF8
        . $ProfilePath
        Write-Host "`n✅ INSTALADO PERMANENTE!" -ForegroundColor Green
        Write-Host "👉 Reabra PowerShell → ativa-office" -ForegroundColor Cyan
    }
}

function Ativar-Office {
    Write-Host "`n🚀 Executando ativação..." -ForegroundColor Green
    irm $Url | iex
    Write-Host "`n✅ ATIVAÇÃO CONCLUÍDA!" -ForegroundColor Green
    Read-Host "`nEnter para voltar ao menu"
}

function Status {
    if(Test-Path $ProfilePath) {
        $hasAlias = Select-String "ativa-office|ATIVA-OFFICE" $ProfilePath
        Write-Host "`nAlias profile: $(if($hasAlias){'✅ SIM'}else{'❌ NÃO'})" -ForegroundColor $(if($hasAlias){"Green"}else{"Red"})
    }
    if(Get-Alias ativa-office -ErrorAction SilentlyContinue) {
        Write-Host "Alias carregado: ✅ SIM" -ForegroundColor Green
    } else {
        Write-Host "Alias carregado: ❌ NÃO" -ForegroundColor Red
    }
}

function Desinstalar {
    if(Test-Path $ProfilePath) {
        $content = Get-Content $ProfilePath | Where-Object { $_ -notmatch "ATIVA-OFFICE|ativa-office|ao" }
        $content | Out-File $ProfilePath -Encoding UTF8
        Write-Host "`n✅ ALIAS REMOVIDO do profile!" -ForegroundColor Red
    }
    Remove-ItemAlias ativa-office -ErrorAction SilentlyContinue
    Remove-ItemAlias ao -ErrorAction SilentlyContinue
}

# EXECUÇÃO
switch($Acao) {
    "ativa" { Ativar-Office }
    "instalar" { Install-Permanente }
    "desativa" { Desinstalar }
    "status" { Status }
    default { 
        Show-Menu
        $op = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").VirtualKeyCode
        switch($op) {
            49 { Ativar-Office }
            50 { Desinstalar }
            51 { Status }
            52 { Install-Permanente }
            27 { exit }  # ESC
        }
    }
}
