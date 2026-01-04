# MAS Menu v1.0 - massgrave.dev INTERATIVO
Write-Host "🎯 Microsoft Activation Scripts - MENU" -ForegroundColor Cyan -BackgroundColor Black
Write-Host "https://massgrave.dev" -ForegroundColor Green

# Baixa MAS (SEM executar)
try {
    $mas = irm https://get.activated.win
    Write-Host "✅ MAS baixado! Escolha opção:" -ForegroundColor Green
} catch {
    Write-Host "❌ Falha download. Tente VPN/proxy" -ForegroundColor Red
    exit
}

# Extrai opções do MAS
$opcoes = $mas | Select-String -Pattern "(?m)^:\w+\s+" -AllMatches | ForEach-Object { $_.Matches.Value.Trim() } | Select-Object -Unique

$menu = @{}
$i = 1
foreach($op in $opcoes) {
    $menu[$i] = $op
    Write-Host "$i. $op" -ForegroundColor White
    $i++
}

Write-Host "`n0. Sair" -ForegroundColor Yellow
$escolha = Read-Host "Digite numero"

if($escolha -eq "0") { exit }

if($menu[[int]$escolha]) {
    Write-Host "`n🚀 Executando: $($menu[[int]$escolha])" -ForegroundColor Blue
    
    # Extrai comando específico
    $cmd = $mas | Select-String -Pattern ":$($menu[[int]$escolha].Substring(1))" -Context 0,10
    $cmd.Lines | Out-Host
    
    $confirm = Read-Host "`nCONFIRMA? (s/N)"
    if($confirm -eq "s" -or $confirm -eq "S") {
        irm https://get.activated.win | iex "$($menu[[int]$escolha])"
    }
} else {
    Write-Host "❌ Opção inválida!" -ForegroundColor Red
}
