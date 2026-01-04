# ATIVA OFFICE v1.3 - MENU SIMPLES (sem parâmetros)
Clear-Host
$Url = "https://get.activated.win"
$ProfilePath = "$PROFILE"

Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan
Write-Host "         🎯 ATIVA OFFICE v1.3          " -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan

function Show-Menu {
    Write-Host "`n[1] 🚀 ATIVAR Office/Win (massgrave.dev)" -ForegroundColor Green
    Write-Host "[2] ❌ REMOVER alias permanente" -ForegroundColor Red
    Write-Host "[3] ℹ️  STATUS" -ForegroundColor Yellow
    Write-Host "[4] 💾 INSTALAR no PowerShell" -ForegroundColor Blue
    Write-Host "`nDigite 1-4 ou ESC: " -ForegroundColor Gray -NoNewline
}

function Ativar-Office {
    Write-Host "`n🚀 Executando..." -ForegroundColor Green
    irm $Url | iex
    Write-Host "`n✅ CONCLUÍDO! Pressione ENTER" -ForegroundColor Green
    Read-Host
}

function Status {
    Write-Host "`n📁 Profile: $ProfilePath" -ForegroundColor Gray
    if(Test-Path $ProfilePath) {
        $hasAlias = Select-String "ativa-office" $ProfilePath
        Write-Host "Alias profile: $(if($hasAlias){'✅ SIM'}else{'❌ NÃO'})" -ForegroundColor $(if($hasAlias){"Green"}else{"Red"})
    }
    if(Get-Alias ativa-office -ErrorAction SilentlyContinue) {
        Write-Host "Alias ativo: ✅ SIM" -ForegroundColor Green
    }
}

function Instalar-Permanente {
    if(!(Test-Path $ProfilePath)){ New-Item -Path $ProfilePath -ItemType File -Force | Out-Null }
    
    $scriptPath = $MyInvocation.MyCommand.Path
    $aliasCode = @"
function ATIVA-OFFICE {
    irm `"$scriptPath`"
}
Set-Alias ativa-office ATIVA-OFFICE
Set-Alias ao ATIVA-OFFICE
"@
    
    if((Get-Content $ProfilePath -ErrorAction SilentlyContinue) -notmatch "ATIVA-OFFICE") {
        $aliasCode | Out-File $ProfilePath -Append -Encoding UTF8
        . $ProfilePath
        Write-Host "`n✅ INSTALADO! Reabra PowerShell → ativa-office" -ForegroundColor Green
    } else {
        Write-Host "`n✅ JÁ ESTÁ instalado!" -ForegroundColor Yellow
    }
}

function Remover-Alias {
    if(Test-Path $ProfilePath) {
        $content = Get-Content $ProfilePath | Where-Object { $_ -notmatch "ATIVA-OFFICE|ativa-office|ao" }
        $content | Out-File $ProfilePath -Encoding UTF8
        Write-Host "`n✅ REMOVIDO do profile!" -ForegroundColor Red
    }
    Remove-ItemAlias ativa-office -ErrorAction SilentlyContinue
    Remove-ItemAlias ao -ErrorAction SilentlyContinue
    Write-Host "🔄 Reabra PowerShell para confirmar" -ForegroundColor Yellow
}

# LOOP PRINCIPAL
do {
    Show-Menu
    $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").VirtualKeyCode
    Clear-Host
    
    switch($key) {
        49 { Ativar-Office }      # 1
        50 { Remover-Alias }      # 2
        51 { Status }             # 3
        52 { Instalar-Permanente }# 4
    }
} while($key -ne 27)  # ESC sai
