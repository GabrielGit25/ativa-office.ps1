# ATIVA OFFICE v1.1 - INSTALA ALIAS PERMANENTE
param([ValidateSet("ativa","desativa","status","instalar")][string]$Acao = "instalar")

$Url = "https://get.activated.win"
$ProfilePath = "$PROFILE"

function Install-Alias {
    if(!(Test-Path $ProfilePath)){ New-Item -Path $ProfilePath -ItemType File -Force | Out-Null }
    
    $aliasCode = @"
# ATIVA OFFICE - massgrave.dev
function ATIVA-OFFICE {
    irm $Url | iex
    Write-Host "✅ Office ATIVADO!" -ForegroundColor Green
}
Set-Alias -Name "ativa-office" -Value "ATIVA-OFFICE"
Set-Alias -Name "ao" -Value "ATIVA-OFFICE"
"@
    
    $content = Get-Content $ProfilePath -ErrorAction SilentlyContinue
    if($content -notmatch "ATIVA-OFFICE") {
        $aliasCode | Out-File $ProfilePath -Append -Encoding UTF8
        . $ProfilePath
        Write-Host "✅ ALIAS INSTALADO PERMANENTE!" -ForegroundColor Green
        Write-Host "👉 Teste: ativa-office / ao" -ForegroundColor Cyan
    } else {
        Write-Host "✅ Alias JA instalado!" -ForegroundColor Yellow
        . $ProfilePath
    }
}

function Uninstall-Alias {
    if(Test-Path $ProfilePath) {
        $content = Get-Content $ProfilePath | Where-Object { $_ -notmatch "ATIVA-OFFICE|ativa-office|ao" }
        $content | Out-File $ProfilePath -Encoding UTF8
        Remove-ItemAlias "ativa-office" -ErrorAction SilentlyContinue
        Remove-ItemAlias "ao" -ErrorAction SilentlyContinue
        Write-Host "✅ Alias REMOVIDO!" -ForegroundColor Red
    }
}

switch($Acao) {
    "instalar" { Install-Alias }
    "ativa" { ATIVA-OFFICE }
    "desativa" { Uninstall-Alias }
    "status" { 
        if(Get-Alias "ativa-office" -ErrorAction SilentlyContinue) { Write-Host "✅ ativa-office OK" -ForegroundColor Green }
        else { Write-Host "❌ ativa-office NÃO instalado" -ForegroundColor Red }
    }
    default { 
        Write-Host "`n🎯 ATIVA OFFICE v1.1" -ForegroundColor Cyan
        Write-Host "1. INSTALAR alias permanente" -ForegroundColor Green
        Write-Host "2. ATIVAR Office" -ForegroundColor Blue
        Write-Host "3. DESATIVAR alias" -ForegroundColor Red
        $op = Read-Host "`nDigite (1-3)"
        & $MyInvocation.MyCommand.ScriptBlock -Acao $(if($op -eq "1"){"instalar"}elseif($op -eq "2"){"ativa"}else{"desativa"})
    }
}
