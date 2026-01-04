# ATIVA OFFICE MENU v2.0 - ZERO PARÂMETROS
$Url = "https://get.activated.win"

Clear-Host
Write-Host "╔══════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║           ATIVA OFFICE v2.0         ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════╝" -ForegroundColor Cyan

function Show-Menu {
    Write-Host ""
    Write-Host "  1) Ativar Office/Windows (MAS)" -ForegroundColor Green
    Write-Host "  2) Mostrar status do profile" -ForegroundColor Yellow
    Write-Host "  3) Instalar comando 'ativa-office'" -ForegroundColor Cyan
    Write-Host "  0) Sair" -ForegroundColor Gray
    Write-Host ""
}

function Ativar-MAS {
    Write-Host "`nBaixando MAS e abrindo menu..." -ForegroundColor Green
    irm $Url | iex
}

function Status-Profile {
    Write-Host "`nProfile: $PROFILE" -ForegroundColor Gray
    if (Test-Path $PROFILE) {
        if (Select-String -Path $PROFILE -Pattern "ativa-office" -ErrorAction SilentlyContinue) {
            Write-Host "Alias 'ativa-office' está registrado no profile." -ForegroundColor Green
        } else {
            Write-Host "Alias 'ativa-office' NÃO está registrado no profile." -ForegroundColor Red
        }
    } else {
        Write-Host "Profile ainda não existe." -ForegroundColor Red
    }
    Read-Host "`nPressione ENTER para voltar ao menu" | Out-Null
}

function Instalar-Alias {
    if (!(Test-Path $PROFILE)) {
        New-Item -Path $PROFILE -ItemType File -Force | Out-Null
    }
    $linha = 'function ativa-office { irm https://get.activated.win | iex }'
    if (-not (Select-String -Path $PROFILE -Pattern "ativa-office" -ErrorAction SilentlyContinue)) {
        Add-Content -Path $PROFILE -Value $linha
        Write-Host "`nAlias instalado. Feche e abra o PowerShell e use: ativa-office" -ForegroundColor Green
    } else {
        Write-Host "`nAlias já existia no profile." -ForegroundColor Yellow
    }
    Read-Host "`nPressione ENTER para voltar ao menu" | Out-Null
}

do {
    Show-Menu
    $op = Read-Host "Escolha (0-3)"
    switch ($op) {
        "1" { Ativar-MAS }
        "2" { Status-Profile }
        "3" { Instalar-Alias }
        "0" { break }
        default {
            Write-Host "Opção inválida." -ForegroundColor Red
            Start-Sleep 1
        }
    }
    Clear-Host
} while ($true)
