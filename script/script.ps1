$GIT_SCRIPT_HEAD = git ls-remote https://github.com/${env:GIT_SCRIPT}/appveyor-git.git HEAD | awk '{ print $1}'


$env:GIT_SCRIPT = "https://github.com/${env:GIT_SCRIPT}/appveyor-git/raw/${GIT_SCRIPT_HEAD}"
$env:PATH = ${env:APPVEYOR_BUILD_FOLDER} + ";" + ${env:PATH}


echo "`n`n`nCI System: ${env:APPVEYOR_BUILD_WORKER_IMAGE}`n`n"
