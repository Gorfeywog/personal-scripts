#region General options
Set-PSReadlineOption -EditMode Windows
Set-PSReadlineKeyHandler -Key Tab -Function Complete
Set-PSReadLineKeyHandler -Chord "Ctrl+f" -Function ForwardWord
Set-PSReadlineKeyHandler -Key PageUp -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key PageDown -Function HistorySearchForward
#endregion
#region General aliases/functions
Set-Alias -Name:eps -Value:"Enter-PsSession"
function Resolve-Error ($ErrorRecord=$Error[0])
{
   $ErrorRecord | Format-List * -Force
   $ErrorRecord.InvocationInfo | Format-List *
   $Exception = $ErrorRecord.Exception
   for ($i = 0; $Exception; $i++, ($Exception = $Exception.InnerException))
   {   "$i" * 80
       $Exception | Format-List * -Force
   }
}
function modulize {
    Get-ChildItem -Recurse *.psm1 | Import-Module -Force
}
#endregion
#region App options and aliases
if (Get-Command "batcat" -ErrorAction Ignore) {
    Set-Alias -Name:bat -Value:"batcat"
}
if (Get-Command lsd -ErrorAction Ignore) {
    function lla { lsd -lah $args }
}
if (Get-Command less -ErrorAction Ignore) {
    $env:LESS = '--mouse'
}
#endregion
#region Extensibility
$modulesDir = "$PSScriptRoot/modules"
$extensionsDir = "$PSScriptRoot/extensions"
if (Test-Path $modulesDir -Type Container) {
    $modules = Get-ChildItem -Path $modulesDir -File
    foreach ($module in $modules) {
        Import-Module -Force ($module.FullName)
    }
}
if (Test-Path $extensionsDir -Type Container) {
    $extensions = Get-ChildItem -Path $extensionsDir -File
    foreach ($extension in $extensions) {
        . ($extension.FullName)
    }
}
#endregion
#region Late commands
if (Get-Command "zoxide" -ErrorAction Ignore) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) } )
    Set-Alias -Name:cd -Value:"z" -Option AllScope # Could also pass a parameter to zoxide init; I like both being around though.
}
#endregion