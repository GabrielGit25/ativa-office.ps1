#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Ativa Office/Windows + Desativação
#>

Clear-Host
$Url = "https://get.activated.win"
$ProfilePath = $PROFILE

Write-Host "╔══════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                    🎯 ATIVA OFFICE v3.1              ║" -ForegroundColor Cyan
Write-Host "║             massgrave.dev - Completo                 ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

function Show-Menu {
    Write-Host "  📱 MENU PRINCIPAL" -ForegroundColor Yellow
    Write-Host "  1️⃣  Menu MAS nativo" -ForegroundColor Green
    Write-Host "  2️⃣  Status / Profile" -ForegroundColor Cyan
    Write-Host "  3️⃣  🔧 Instalar 'ativa-office'" -ForegroundColor Blue
    Write-Host "  4️⃣  🗑️  DESATIVAR tudo" -ForegroundColor Red
    Write-Host "  0️⃣  Sair`n" -ForegroundColor Gray
}

function Menu-MAS {
    $opcoes = irm $Url -Raw | sls "^:\w+" | % { if($_ -match "^:(\w+)") { $matches[1] } }
    cls; Show-Menu; Write-Host "`nOpções MAS:" -ForegroundColor Yellow
    for($i=0;$i -lt $opcoes.Count;$i++){ Write-Host "  [$($i+1)] :$($opcoes[$i])" -ForegroundColor Green }
    $idx = (Read-Host "`nNúmero") - 1
    if($idx -ge 0 -and $idx -lt $opcoes.Count){
        $confirm = Read-Host "Executar :$($opcoes[$idx])? (s/N)"
        if($confirm -eq 's'){ irm $Url | iex "::$($opcoes[$idx])" }
    }
}

function Status {
    cls
    Write-Host "📊 STATUS" -ForegroundColor Yellow
    Write-Host "Profile: $ProfilePath" -ForegroundColor Gray
    if(Test-Path $ProfilePath){
        $alias = sls "ativa-office" $ProfilePath
        Write-Host "Alias no profile: $(if($alias){'✅ SIM'}else{'❌ NÃO'})" -ForegroundColor $(if($alias){"Green"}else{"Red"})
    }
    if(Get-Alias ativa-office -ea SilentlyContinue){
        Write-Host "Alias ativo: ✅ SIM" -ForegroundColor Green
    }
    Read-Host "`nEnter"
}

function Instalar-Alias {
    if(!(Test-Path $ProfilePath)){ ni $ProfilePath -ItemType File -Force }
    $aliasCode = "function ativa-office { irm https://raw.githubusercontent.com/GabrielGit25/novo/main/ativa-office.ps1 | iex }; Set-Alias ao ativa-office"
    if(!(sls "ativa-office" $ProfilePath)){
        $aliasCode | Out-File $ProfilePath -Append -Encoding UTF8
        . $ProfilePath
        Write-Host "`n✅ INSTALADO! Feche/reabra PS → ativa-office" -ForegroundColor Green
    } else {
        Write-Host "`n✅ JÁ ESTAVA instalado" -ForegroundColor Yellow
    }
    Read-Host "Enter"
}

function Desativar-Tudo {
    cls
    Write-Host "🗑️  DESATIVANDO..." -ForegroundColor Red
    
    # Remove alias do profile
    if(Test-Path $ProfilePath){
        $content = gc $ProfilePath | ? { $_ -notmatch "ativa-office|ao" }
        $content | Out-File $ProfilePath -Encoding UTF8
        Write-Host "✅ Profile limpo" -ForegroundColor Green
    }
    
    # Remove aliases ativos
    Get-Alias ativa-office,ao -ea SilentlyContinue | % { Remove-ItemAlias $_.Name }
    Write-Host "✅ Aliases removidos" -ForegroundColor Green
    
    Write-Host "`n🎉 DESATIVADO TOTAL! Reabra PowerShell." -ForegroundColor Magenta
    Read-Host "Enter"
}

# LOOP PRINCIPAL
do {
    Show-Menu
    $op = Read-Host "Opção (0-4)"
    switch($op){
        "1" { Menu-MAS }
        "2" { Status }
        "3" { Instalar-Alias }
        "4" { Desativar-Tudo }
    }
    cls
} while($op -ne "0")

Write-Host "👋 Até logo!" -ForegroundColor Magenta
