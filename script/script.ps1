$GIT_SCRIPT_HEAD = git ls-remote https://github.com/${env:GIT_SCRIPT}/appveyor-ci.git HEAD | awk '{ print $1}'


$env:GIT_SCRIPT = "https://github.com/${env:GIT_SCRIPT}/appveyor-ci/raw/${GIT_SCRIPT_HEAD}"
$env:PATH = ${env:APPVEYOR_BUILD_FOLDER} + ";" + ${env:PATH}


echo "`nCI System: ${env:APPVEYOR_BUILD_WORKER_IMAGE}`n`n"
