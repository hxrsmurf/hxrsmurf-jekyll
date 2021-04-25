<#
	This creates the YAML, Includes, and main HTML for Jekyll.
	To do: if content already exists, don't overwrite (but do it better)
#>

# Base Directories
$directory = "C:\Users\kvchm\Desktop\hxrsmurf-jekyll\"
$yamlDirectory = $directory + "_data\quotes\"

#html
$includesDirectory = $directory + "_includes\"
$includesTemplateFile = "z-quote-template.html"
$includesTemplate = $includesDirectory + $includesTemplateFile

# Main HTML
$preMainHTML = '<div class="quote"> {% include '
$appendMainHTML = " </div>"

# Set This
$category = "movie"

$categoryFile = $yamlDirectory + $category + "s.csv"
$categoryFolder = $category + "-quotes"

$yamlDirectory = $yamlDirectory + $categoryFolder
$includesDirectory = $includesDirectory + $categoryFolder

 if (!(Test-Path $yamlDirectory)) { New-Item -Path $yamlDirectory } else { Write-Host "Content already exists!"; return }
 if (!(Test-Path $includesDirectory)) { New-Item -Path $includesDirectory } else { Write-Host "Content already exists!"; return }

$categoryImport = (Import-CSV $categoryFile).name

$template = Get-Content $includesTemplate

foreach ($name in $categoryImport) {
	$noSpaces = ($name.tolower()).replace(" ","-")
	$noSpaces = ($noSpaces.tolower()).replace("'","")
	$noSpaces = ($noSpaces.tolower()).replace(".","")
	$noSpaces = ($noSpaces.tolower()).replace(":","")
	$noSpaces = ($noSpaces.tolower()).replace("!","")
	$yamlSave = $noSpaces + ".yaml"
	$htmlSave = $noSpaces + ".html"
	$includesSave = $includesDirectory + "\" + $htmlSave
	
	# Stage YAML Quotes	
	New-Item -Path $yamlDirectory -Name $yamlSave -ItemType "file"
	
	# Use Template to Update / Create
	$template.replace("category",$categoryFolder) | Set-Content -path $includesSave
	(Get-Content -Path $includesSave ).replace("Template",$name) | Set-Content -path $includesSave
	(Get-Content -Path $includesSave ).replace("template",$noSpaces) | Set-Content -path $includesSave
	
	# Append Main HTML
	$htmlStringSave = $preMainHTML + $categoryFolder + "/" + $htmlSave + $appendMainHTML		
	$mainHTMLSavePath = $directory + "quotes_"+ $category + ".html"
	Add-Content -Path $mainHTMLSavePath -Value $htmlStringSave
}

