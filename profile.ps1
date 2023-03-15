oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/illusi0n.omp.json" | Invoke-Expression
Import-Module -Name Terminal-Icons

# Import-Module PSFzf
# Set-PsFzfOption -PSReadLineChordProvider 'Ctrl+f' -PSReadLineChordReverseHistory 'Ctrl+r'

$NVIM = "$HOME/AppData/Local/nvim"

# Alias 
Set-Alias vim nvim
Set-Alias grep findstr
Set-Alias python3 python

# Ultilities 

function wrm {
    param (
        [string] $path,
        [switch] $r,
        [switch] $f
    )

    # Check if the path exists
    if (!(Test-Path $path)) {
        Write-Output "The path $path does not exist."
        return
    }

    # If -f option is present, delete the file(s) or directory(ies) without confirmation
    if ($f.IsPresent) {
        if ($r.IsPresent) {
					if (Get-ChildItem -Path $path -Force | Where-Object { $_.PSIsContainer }) {
                Remove-Item -Path $path -Recurse -Force
            } else {
                Remove-Item -Path $path -Force
            }
        } else {
            Remove-Item -Path $path -Force
        }
    } else {
        # If -r option is present, delete the directory(ies) including the files, but prompt for confirmation
        if ($r.IsPresent) {
            if (Get-ChildItem -Path $path -Force | Where-Object { $_.PSIsContainer }) {
                $confirmation = Read-Host "Are you sure you want to delete the directory and its contents? [Y/N]"
                if ($confirmation -eq "Y") {
                    Remove-Item -Path $path -Recurse
                }
            } else {
                Remove-Item -Path $path
            }
        } else {
            # If -r option is not present, delete the file(s) but prompt for confirmation
            $confirmation = Read-Host "Are you sure you want to delete the file(s)? [Y/N]"
            if ($confirmation -eq "Y") {
                Remove-Item -Path $path
            }
        }
    }
}


function which ($command) {
    Get-Command -Name $command -ErrorAction SilentlyContinue |
        Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

function gclone ($repo) {

	if($repo.split('/')[1]) {
		git clone "https://github.com/$repo"
		cd $repo.split('/')[1]
	} else {
		git clone "https://github.com/nandobfer/$repo"
		cd $repo
	}
}

function powershelladm () {
	powershell -Command "Start-Process PowerShell -Verb RunAs"
}

function ln ($origin, $target) {
	sudo New-Item -Path $target -ItemType SymbolicLink -Value $origin
}

function backup ($domain, $table) {
	echo "Dumping database from $domain"
	echo "mysql user: burgos"
	ssh $domain "mysqldump -u burgos -pmfux6xpj $table > $table.sql"

	echo "Downloading sql to homedir"
	scp $domain`:~/$table.sql $HOME/
}

function refreshenv () {
	$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

function mysqlload ($database, $file) {
	$args = @{
 		"u" = "root"
 		"h" = "localhost"
		"p" = ""
	}
	echo $args
	Get-Content $file | mysql $args
}

function wamp () {
	$wamp = "c:/wamp64/wampmanager.exe"

	sudo taskkill /im mysqld.exe /F
	echo "running $wamp"
	Start-Process -FilePath $wamp
}

function pagespeed {
		param (
		[string]$Domain
		)

		$Url = "https://pagespeed.web.dev/report?url=https%3A%2F%2F$Domain%2F&form_factor=desktop"

		if ([System.Diagnostics.Process]::Start($Url)) {
				echo "opened URL: $Url"
			} else {
					echo "failed to open $Url"
				}
	}
################################################
############### END OF FUNCTIONS ###############
################################################

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
