param($installPath, $toolsPath, $package, $project)

#install.ps1 v: 2.0
$defaultProject = Get-Project

if($defaultProject.Type -ne "C#"){
	Write-Host "Sorry, XSockets is only available for C#"
	return
}

$defaultNamespace = (Get-Project $defaultProject.Name).Properties.Item("DefaultNamespace").Value
$path = $defaultProject.FullName.Replace($defaultProject.Name + '.csproj','').Replace('\\','\')
$pluginPath = $path + "XSocketServerPlugins\"
$sln = [System.IO.Path]::GetFilename($dte.DTE.Solution.FullName)
$newProjPath = $dte.DTE.Solution.FullName.Replace($sln,'').Replace('\\','\')
$sln = Get-Interface $dte.Solution ([EnvDTE80.Solution2])

###################################
#Adding plugin info to config     #
###################################
$webconfig = $path + "Web.config"
Write-Host "Getting content of $webconfig."
$xml = [xml](get-content($webconfig))

Write-Host "Adding appsettings in $webconfig"

if($xml.configuration['appSettings'] -eq $null){
    Write-Host 'Add appsettings'
    $a = $xml.CreateElement('appSettings')
    $xml.configuration.AppendChild($a)
}

$pluginCatalog = $xml.CreateElement('add')
$pluginCatalog.setAttribute('key','XSockets.PluginCatalog')
#XSockets\XSocketServerPlugins\
$pluginCatalog.setAttribute('value','')
$xml.configuration["appSettings"].AppendChild($pluginCatalog)

$pluginFilter = $xml.CreateElement('add')
$pluginFilter.setAttribute('key','XSockets.PluginFilter')
$pluginFilter.setAttribute('value','*.dll')
$xml.configuration["appSettings"].AppendChild($pluginFilter)

Write-Host "Saving $webconfig."
$xml.Save($webconfig)

Scaffold DevelopmentDebugServer

###################################
#Add fallback if MVC
###################################
if(((Get-Project $defaultProject.Name).Object.References | Where-Object {$_.Name -eq "System.Web.Mvc"}) -ne $null){ 

    
    ###################################
    #Start new debugserver on appstart#
    ###################################
    Add-CodeToMethod $defaultProject.Name "\" "Global.asax.cs" "MvcApplication" "Application_Start" "new $($defaultNamespace).XSockets.DebugInstance();"

    Write-Host $defaultProject.Name Installing : XSockets.Fallback -ForegroundColor DarkGreen
    Install-Package XSockets.Fallback -ProjectName $defaultProject.Name

    $mvc4 = Get-ProjectItem "App_Start\RouteConfig.cs"
    if($mvc4 -eq $null){
        ############################################################################
        #Add Fallback controller to MvcApplication class and method RegisterRoutes #
        ############################################################################
        Add-CodeToMethod $defaultProject.Name '\' 'Global.asax.cs' 'MvcApplication' 'RegisterRoutes' 'routes.MapRoute("Fallback","{controller}/{action}",new {controller = "Fallback", action = "Init"},new[] {"XSockets.Longpolling"});'
    }
    else{
        ###################################################################
        #Add Fallback controller to RouteConfig class and method Register #
        ###################################################################
        Add-CodeToMethod $defaultProject.Name '\App_Start\' 'RouteConfig.cs' 'RouteConfig' 'RegisterRoutes' 'routes.MapRoute("Fallback","{controller}/{action}",new {controller = "Fallback", action = "Init"},new[] {"XSockets.Longpolling"});'
    }
}
else{
    Write-Host No fallback installed due to WebForms as project, Use MVC3/MVC4 for fallback -ForegroundColor DarkRed
    #WEBFORMS
    ###################################
    #Start new debugserver on appstart#
    ###################################
    Add-CodeToMethod $defaultProject.Name "\" "Global.asax.cs" "Global" "Application_Start" "new $($defaultNamespace).XSockets.DebugInstance();"
}