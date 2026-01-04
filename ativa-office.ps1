param([string]$Acao = "ativa")

# ATIVA/DESATIVA Office - massgrave.dev
$Url = "https://get.activated.win"

function Show-Menu {
    Write-Host "`n🎯 ATIVA OFFICE v1.0" -ForegroundColor Cyan
    Write-Host "1. ATIVAR Office (irm $Url | iex)" -ForegroundColor Green
    Write-Host "2. DESATIVAR alias" -ForegroundColor Red
    Write-Host "3. Status" -ForegroundColor Yellow
    $op = Read-Host "`nEscolha (1-3)"
    return $op
}

switch($Acao.ToLower()) {
    "ativa" { irm $Url | iex; Write-Host "`n✅ Office ATIVADO!" -ForegroundColor Green }
    "desativa" { 
        $ProfilePath = "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
        if(Test-Path $ProfilePath) {
            $content = Get-Content $ProfilePath | Where-Object { $_ -notmatch "ativa-office|ATIVA-OFFICE" }
            $content | Out-File $ProfilePath -Encoding UTF8
            Write-Host "`n✅ Alias REMOVIDO!" -ForegroundColor Yellow
        }
    }
    "status" { 
        if(Test-Path $PROFILE) { 
            $hasAlias = Select-String "ativa-office|ATIVA-OFFICE" $PROFILE
            Write-Host "`nAlias $(if($hasAlias){'✅ INSTALADO'}else{'❌ NÃO'} )" -ForegroundColor $(if($hasAlias){"Green"}else{"Red"})
        }
    }
    default { 
        $op = Show-Menu
        & $MyInvocation.MyCommand.ScriptBlock -Acao $op
    }
}

Write-Host "`n💾 Alias PERMANENTE até desativar!" -ForegroundColor Magenta
Write-Host "Uso: ativa-office / ativa-office desativa" -ForegroundColor Cyan
