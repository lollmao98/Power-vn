# Phase 1: Minimal Playable Visual Novel in PowerShell
Set-StrictMode -Version Latest
$Host.UI.RawUI.WindowTitle = "My PowerShell VN - P1"

# 1. Game State
$State = @{
    PlayerName = "Adam"
    Chill      = 0
    Project    = 0
}

# 2. Typewriter Text Helper
function Write-Dialogue {
    param(
        [Parameter(Mandatory)]
        [string]$Speaker,

        [Parameter(Mandatory)]
        [string]$Text,

        [ConsoleColor]$Color = [ConsoleColor]::White,

        [int]$SpeedMs = 20
    )
    Write-Host "`n[$Speaker]" -ForegroundColor $Color
    foreach ($char in $Text.ToCharArray()) {
        Write-Host -NoNewline $char
        Start-Sleep -Milliseconds $SpeedMs
    }
    Write-Host ""
}

# 3. Choice Menu Helper
function Get-Choice {
    param(
        [Parameter(Mandatory)]
        [string[]]$Options
    )
    Write-Host ""
    for ($i = 0; $i -lt $Options.Count; $i++) {
        Write-Host "  $($i + 1). $($Options[$i])" -ForegroundColor Gray
    }
    do {
        $pick = Read-Host "`nChoose (1-$($Options.Count))"
    } until (($pick -as [int]) -and [int]$pick -ge 1 -and [int]$pick -le $Options.Count)
    return [int]$pick
}

# 4. Scene Loop
$Scene = "Start"

while ($Scene -ne "Exit") {
    Clear-Host
    switch ($Scene) {
        "Start" {
            Write-Dialogue -Speaker "Narrator" -Text "Rain taps against the window. The clock hits 3am." -Color White
            $name = Read-Host "`nEnter your name (or press Enter for Adam)"
            if (-not [string]::IsNullOrWhiteSpace($name)) {
                $State.PlayerName = $name.Trim()
            }
            $Scene = "Act coffee beans"
        }

        "Act coffee beans" {
            Write-Dialogue -Speaker "Brain" -Text "Hey $($State.PlayerName), it's been 3 hours since you calmed yourself down. Go make us a cup of coffee?" -Color Cyan
            $choice = Get-Choice -Options @(
                "Sure whatever (Chill +5)",
                "Nah we gotta work (Project +5%)"
            )
            if ($choice -eq 1) {
                $State.Chill += 5
                $Scene = "Sipping"
            } elseif ($choice -eq 2) {
                $State.Project += 5
                $Scene = "Sipping"
            }
        }

        "Sipping" {
            if ($State.Chill -eq 5) {
                Write-Dialogue -Speaker "Brain" -Text "Hell yeah, just check out this smell. Mhmm... (Energy boosted: Project +10%)" -Color Cyan
                $State.Project += 10
                $null = Read-Host "`nPress Enter to continue"
                $Scene = "humm"
            } elseif ($State.Project -eq 5) {
                Write-Dialogue -Speaker "Brain" -Text "Yeah sure, good luck staying awake." -Color Cyan
                $null = Read-Host "`nPress Enter to continue"
                $Scene = "humm"
            }
            
        }

        "humm" {
            Write-Dialogue -Speaker "progress" -Text " Chill: $($State.Chill) | Project: $($State.Project)%" -Color Green
            Write-Dialogue -Speaker "Brain" -Text "Soo Ive been wondering What do you call cheese that isn't yours? " -Color Blue
            $choice = Get-Choice -Options @(
                "Enlighten me (Chill +5)",
                "Can you shut up (Project +5%)"
            )
            if ($choice -eq 1) {
                $State.Chill += 10
                Write-Dialogue -Speaker "Brain" -Text "Nacho cheese(With the power of the dad joke you knocked out even more work weird...)" -Color Blue
                $null = Read-Host "`nPress Enter to continue"
                $Scene = "Pers"
            } elseif ($choice -eq 2) {
                $State.Project += 5
                Write-Dialogue -Speaker "Brain" -Text "Man you're no fun(You felt a headache as if it was punishment)" -Color Blue
                $null = Read-Host "`nPress Enter to continue"
                $Scene = "Pers"
            }
        }
    "Pers" {
            Write-Dialogue -Speaker "progress" -Text " Chill: $($State.Chill) | Project: $($State.Project)%" -Color Green



    }
        }

    }