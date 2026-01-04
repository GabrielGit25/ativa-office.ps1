#!/usr/bin/env pwsh
Clear-Host
$Url = "https://get.activated.win"
$ProfilePath = $PROFILE

function Show-MenuPrincipal {
    cls
    Write-Host "╔══════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║            🎯 ATIVA OFFICE v3.2      ║" -ForegroundColor Cyan
    Write-Host "╚══════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host "`n1️⃣  MAS Menu (Office/Win)" -ForegroundColor Green
    Write-Host "2️⃣  Status Profile" -ForegroundColor Yellow
    Write-Host "3️⃣  🔧 Instalar alias" -ForegroundColor Blue
    Write-Host "4️⃣  🗑️  Desativar tudo" -ForegroundColor Red
    Write-Host "0️⃣  Sair`n" -ForegroundColor Gray
}

function Menu-MAS {
    cls
    Write-Host "🎯 MAS Menu - massgrave.dev`n" -ForegroundColor Cyan
    
    try {
        $mas = irm $Url
        $opcoes = $mas | Select-String "^:\w+" -AllMatches | ForEach { 
            if($_ -match "^:(\w+)") { $matches[1] }
        } | Select -Unique
        
        Write-Host "Opções disponíveis:`n" -ForegroundColor Yellow
        $i = 1
        foreach($op in $opcoes[0..9]) {  # Limita 10 primeiras
            Write-Host "  $i️⃣  :$op" -ForegroundColor Green
            $i++
        }
        
        $num = Read-Host "`nDigite número (1-$($i-2)) ou 0 voltar"
        if($num -eq "0") { return }
        
        $idx = [int]$num - 1
        if($idx -ge 0 -and $idx -lt $opcoes.Count) {
            $opcao = $opcoes[$idx]
            Write-Host "`n🚀 :$opcao" -ForegroundColor Blue
            $conf = Read-Host "Executar? (s/N)"
            if($conf -eq "s") {
                irm $Url | iex ":$opcao"
                Write-Host "`n✅ Feito! Enter..." -ForegroundColor Green
                Read-Host
            }
        }
    } catch {
        Write-Host "❌ Erro MAS: $($_.Exception.Message)" -ForegroundColor Red
        Read-Host "Enter"
    }
}

function Status {
    cls
    Write-Host "📊 STATUS" -ForegroundColor Yellow
    Write-Host "Profile: $ProfilePath → $(if(Test-Path $ProfilePath){'✅ Existe'}else{'❌ Não'})"
    if(Test-Path $ProfilePath -and (sls ativa-office $ProfilePath)){
        Write-Host "Alias profile: ✅ SIM" -ForegroundColor Green
    }
    if(Get-Alias ativa-office -ErrorAction SilentlyContinue){
        Write-Host "Alias ativo: ✅ SIM" -ForegroundColor Green
    }
    Read-Host "`nEnter"
}

function Instalar {
    if(!(Test-Path $ProfilePath)){ ni $ProfilePath -ItemType File -Force }
    $code = "function ativa-office { irm https://raw.githubusercontent.com/GabrielGit25/novo/main/ativa-office.ps1 | iex }"
    if(!(sls ativa-office $ProfilePath)){
        $code | Out-File $ProfilePath -Append -Encoding UTF8
        . $ProfilePath
        Write-Host "`n✅ Instalado! Reabra PS → ativa-office" -ForegroundColor Green
    }
    Read-Host "Enter"
}

function Desativar {
    if(Test-Path $ProfilePath){
        gc $ProfilePath | ? {$_ -notmatch "ativa-office"} | Out-File $ProfilePath -Encoding UTF8
        Write-Host "✅ Profile limpo" -ForegroundColor Green
    }
    ri alias:ativa-office -ErrorAction SilentlyContinue
    Write-Host "✅ Desativado!" -ForegroundColor Red
    Read-Host "Enter"
}

# LOOP PRINCIPAL
do {
    Show-MenuPrincipal
    $op = Read-Host "Opção"
    switch($op){
        1 { Menu-MAS }
        2 { Status }
        3 { Instalar }
        4 { Desativar }
    }
} while($op -ne 0)
