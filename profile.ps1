oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/illusi0n.omp.json" | Invoke-Expression
Import-Module -Name Terminal-Icons

# Import-Module PSFzf
# Set-PsFzfOption -PSReadLineChordProvider 'Ctrl+f' -PSReadLineChordReverseHistory 'Ctrl+r'

$NVIM = "$HOME/AppData/Local/nvim"

# Alias 
Set-Alias vim nvim
Set-Alias grep findstr
Set-Alias -Name python3 -Value python -Scope Global

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

function ip {
	param (
		[switch]$p,
		[switch]$l
	)

	if ($p.IsPresent) {
		network public_ip
	} else {
		network private_ip
	}

	if ($l.IsPresent) {
		network interfaces_list
	}

}

function work {
	param (
		[string]$repo,
		[switch]$start,
		[switch]$dev,
		[switch]$pull
	)

	cd $HOME/github/$repo
	code .

	if ($pull.IsPresent) {
		git pull
	}

	if ($start.IsPresent) {
		yarn start
	}

	if ($dev.IsPresent) {
		yarn dev
	}
}

function games {
	ls c:/games
	ls d:/games
	ls "c:/Program Files (x86)/Steam/steamapps/common"
	ls d:/SteamLibrary/steamapps/common
}

function shortcuts {
	explorer C:\ProgramData\Microsoft\Windows\Start Menu\Programs
}

function sed ($sed, $file) {
    $original = $sed.split('/')[1]
    $replace = $sed.split('/')[2]

    (Get-Content $file) -replace $original, $replace | Out-File -encoding ASCII $file
}

function createapi {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]
		[string]$database,
		[Parameter(Mandatory)]
		[string]$port
	)

	$env = "PORT=$port`nDATABASE_URL=`"mysql://python:SucessoZOP2022!@app.agenciaboz.com.br:3306/$database`""

    $prisma = "generator client {
        provider = `"prisma-client-js`"
        previewFeatures = [`"fullTextSearch`", `"fullTextIndex`"]
    }

    datasource db {
        provider = `"mysql`"
        url      = env(`"DATABASE_URL`")
    }"

    $index = "import express, { Express, Request, Response } from 'express'
    import dotenv from 'dotenv'
    import cors from 'cors'
    import { router } from './routes'
    import bodyParser from 'body-parser'
    import cookieParser from 'cookie-parser'
    import https from 'https'
    import fs from 'fs'
    
    dotenv.config()
    
    const app:Express = express()
    const port = process.env.PORT
    
    app.use(cors())
    app.use(bodyParser.json())
    app.use(bodyParser.urlencoded({ extended: false }))
    app.use(cookieParser())
    app.use('/api', router)
    
    try {
        const server = https.createServer({
            key: fs.readFileSync('/etc/letsencrypt/live/app.agenciaboz.com.br/privkey.pem', 'utf8'),
            cert: fs.readFileSync('/etc/letsencrypt/live/app.agenciaboz.com.br/cert.pem', 'utf8'),
            ca: fs.readFileSync('/etc/letsencrypt/live/app.agenciaboz.com.br/chain.pem', 'utf8'),
        }, app);
        
        server.listen(port, () => {
            console.log(``[server]: 'Server is running at https `${port}``)
        })
    } catch {
        app.listen(port, () => {
            console.log(``[server]: Server is running at http `${port}``)
        })
    }"

    $routes = "import express, { Express, Request, Response } from 'express'
    //import login from './src/login'
    
    export const router = express.Router()
    
    //router.use(`"/login`", login)"

    $tsconfigline = "// `"outDir`": `"./`""
    $tsconfigreplace = "`"outDir`": `"./dist`""

    echo "initializing npm package"
	npm init --yes > $null
    echo "installing dependencies"
	yarn add express dotenv @prisma/client body-parser cookie-parser cors https axios > $null
    echo "installing dev dependencies"
	yarn add -D typescript @types/express @types/node prisma concurrently nodemon @types/cors @types/cookie-parser > $null

    echo "generating typescript config"
    npx tsc --init > $null
    echo "configuring out dir for typescript build"
    (Get-Content "tsconfig.json") -replace $tsconfigline, $tsconfigreplace | Out-File -encoding ASCII "tsconfig.json"

    echo "configuring yarn scripts"
    $package = Get-Content "./package.json" -Raw | ConvertFrom-Json
    $package.scripts | Add-Member -Type NoteProperty -Name "build" -Value "npx tsc"
    # $package.scripts.build = "npx tsc"
    $package.scripts | Add-Member -Type NoteProperty -Name "start" -Value "node dist/index.js"
    # $package.scripts.start = "node dist/index.js"
    $package.scripts | Add-Member -Type NoteProperty -Name "dev" -Value "concurrently \`"npx tsc --watch\`" \`"nodemon -q dist/index.js\`""
    # $package.scripts.dev = "concurrently \`"npx tsc --watch\`" \`"nodemon -q dist/index.js\`""
    $package | ConvertTo-Json -Depth 100 | Set-Content "./package.json" -Encoding UTF8 -Force

    echo "initializing prisma"
	npx prisma init > $null

    echo "configuring .env and schemas"
	echo $env > "./.env"
	echo $prisma > "./prisma/schema.prisma"

    echo "adding index and routes files"
    echo $index > "./index.ts"
    echo $routes > "./routes.ts"
    mkdir "src" > $null

    yarn build
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
