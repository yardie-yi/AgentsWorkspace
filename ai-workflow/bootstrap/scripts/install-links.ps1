$RepoDir = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$HomeDir = $HOME

$CodexDir = Join-Path $HomeDir ".codex"
$ClaudeDir = Join-Path $HomeDir ".claude"
$SharedDir = Join-Path $HomeDir "shared"

$CodexAgents = Join-Path $RepoDir "global\codex\AGENTS.md"
$ClaudeAgents = Join-Path $RepoDir "global\claude\CLAUDE.md"

$CodexSkillsSrc = Join-Path $RepoDir "global\codex\skills"
$CodexSubagentsSrc = Join-Path $RepoDir "global\codex\subagents"

$ClaudeSkillsSrc = Join-Path $RepoDir "global\claude\skills"
$ClaudeAgentsSrc = Join-Path $RepoDir "global\claude\agents"
$SharedSrc = Join-Path $RepoDir "shared"

$CodexSkillsDst = Join-Path $CodexDir "skills"
$CodexSubagentsDst = Join-Path $CodexDir "subagents"

$ClaudeSkillsDst = Join-Path $ClaudeDir "skills"
$ClaudeAgentsDst = Join-Path $ClaudeDir "agents"
$SharedDst = $SharedDir

function Ensure-Dir {
    param([string]$Path)
    New-Item -ItemType Directory -Force -Path $Path | Out-Null
}

function Copy-FileIfExists {
    param(
        [string]$Source,
        [string]$Destination
    )

    if (-not (Test-Path $Source)) {
        Write-Warning "File not found, skipped: $Source"
        return
    }

    Copy-Item -Path $Source -Destination $Destination -Force
    Write-Host "Copied file: $Source -> $Destination"
}

function Copy-DirContentsIfExists {
    param(
        [string]$SourceDir,
        [string]$TargetDir
    )

    if (-not (Test-Path $SourceDir)) {
        Write-Warning "Directory not found, skipped: $SourceDir"
        return
    }

    Ensure-Dir $TargetDir
    Copy-Item -Path (Join-Path $SourceDir "*") -Destination $TargetDir -Recurse -Force
    Write-Host "Copied directory contents: $SourceDir -> $TargetDir"
}

Ensure-Dir $CodexDir
Ensure-Dir $ClaudeDir
Ensure-Dir $SharedDir

Write-Host "RepoDir           : $RepoDir"
Write-Host "Codex root        : $CodexDir"
Write-Host "Claude root       : $ClaudeDir"
Write-Host "Shared root       : $SharedDir"
Write-Host "Codex AGENTS src  : $CodexAgents"
Write-Host "Claude CLAUDE src : $ClaudeAgents"

# Top-level instruction files
Copy-FileIfExists -Source $CodexAgents -Destination (Join-Path $CodexDir "AGENTS.md")
Copy-FileIfExists -Source $ClaudeAgents -Destination (Join-Path $ClaudeDir "CLAUDE.md")

# Codex assets
Copy-DirContentsIfExists -SourceDir $CodexSkillsSrc -TargetDir $CodexSkillsDst
Copy-DirContentsIfExists -SourceDir $CodexSubagentsSrc -TargetDir $CodexSubagentsDst

# Claude assets
Copy-DirContentsIfExists -SourceDir $ClaudeSkillsSrc -TargetDir $ClaudeSkillsDst
Copy-DirContentsIfExists -SourceDir $ClaudeAgentsSrc -TargetDir $ClaudeAgentsDst

# Shared assets
Copy-DirContentsIfExists -SourceDir $SharedSrc -TargetDir $SharedDst

Write-Host ""
Write-Host "Sync completed."
Write-Host "Codex:"
Write-Host "  $(Join-Path $CodexDir 'AGENTS.md')"
Write-Host "  $(Join-Path $CodexDir 'skills')"
Write-Host "  $(Join-Path $CodexDir 'subagents')"
Write-Host "Claude:"
Write-Host "  $(Join-Path $ClaudeDir 'CLAUDE.md')"
Write-Host "  $(Join-Path $ClaudeDir 'skills')"
Write-Host "  $(Join-Path $ClaudeDir 'agents')"
Write-Host "Shared:"
Write-Host "  $SharedDir"
