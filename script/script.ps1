$SCRIPT_HEAD = git ls-remote https://github.com/${env:SCRIPT}/appveyor-git.git HEAD | awk '{ print $1}'

$env:SCRIPT = "https://github.com/${env:SCRIPT}/appveyor-git/raw/${SCRIPT_HEAD}"



$env:PATH = ${env:APPVEYOR_BUILD_FOLDER} + ";" + ${env:PATH}
