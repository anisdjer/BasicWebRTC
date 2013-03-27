[T4Scaffolding.Scaffolder(Description = "Scaffold the debug server code")][CmdletBinding()]
param(        
    [string]$Project,
	[string]$CodeLanguage,
	[string[]]$TemplateFolders,
	[switch]$Force = $false
)

$namespace = (Get-Project $Project).Properties.Item("DefaultNamespace").Value + ".XSockets"

$outputPath = "XSockets\DebugInstance"

Add-ProjectItemViaTemplate $outputPath -Template DevelopmentDebugServerTemplate `
    -Model @{Namespace = $namespace} `
	-SuccessMessage "Added DevelopmentDebugServer output at {0}" `
	-TemplateFolders $TemplateFolders -Project $Project -CodeLanguage $CodeLanguage -Force:$Force

$outputPath = "XSockets\CustomConfigurationLoader"
Add-ProjectItemViaTemplate $outputPath -Template CustomConfigurationLoaderTemplate `
    -Model @{Namespace = $namespace} `
	-SuccessMessage "Added CustomConfigurationLoader output at {0}" `
	-TemplateFolders $TemplateFolders -Project $Project -CodeLanguage $CodeLanguage -Force:$Force