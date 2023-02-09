oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/illusi0n.omp.json" | Invoke-Expression
Import-Module -Name Terminal-Icons

# Import-Module PSFzf
# Set-PsFzfOption -PSReadLineChordProvider 'Ctrl+f' -PSReadLineChordReverseHistory 'Ctrl+r'

# ip and hosts
$HOSTGATOR = '162.214.166.106'

# Alias (Optional)
Set-Alias vim nvim
Set-Alias grep findstr
Set-Alias hostgator '162.214.166.106'

# Ultilities (Optional)
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
	ssh $domain "mysqldump -u burgos -p $table > $table.sql"

	echo "Downloading sql to homedir"
	scp $domain`:~/$table.sql $HOME/
}

function refreshenv () {
	$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
