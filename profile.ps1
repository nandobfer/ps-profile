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
	git clone "https://github.com/$repo"
	cd $repo.split('/')[1]
}
