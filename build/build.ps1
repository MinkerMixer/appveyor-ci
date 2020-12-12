$env:GIT_REDIRECT_STDERR = '2>&1'

$DEPTH = 50



iex ((New-Object System.Net.WebClient).DownloadString("${env:GIT_SCRIPT}/login/login.ps1"))


git submodule update --init --recursive



#####################################



$env:BUILD_PATH = Split-Path ${env:SOLUTION} -Parent

if (${env:BUILD_PATH} -Eq $Null) {
  $env:BUILD_PATH = "."
}



$env:SOLUTION = Split-Path ${env:SOLUTION} -Leaf



#####################################



iex ((New-Object System.Net.WebClient).DownloadString("${env:GIT_SCRIPT}/build/${env:COMPILER}.ps1"))


echo "`n`n`nCompiler: ${env:COMPILER_VERSION}`n"



#####################################



(New-Object System.Net.WebClient).DownloadFile("${env:GIT_SCRIPT}/build/git_edit.cpp", "c:\msys64\mingw64\bin\git_edit.cpp")



cd c:\msys64\mingw64\bin\

gcc.exe -O3 "c:\msys64\mingw64\bin\git_edit.cpp" -o "c:\msys64\mingw64\bin\git_edit.exe"



#####################################



cd ${env:APPVEYOR_BUILD_FOLDER}
cd ${env:BUILD_PATH}


echo "`n`n"



#####################################



function global:git_merge($branch) {
  git pull origin ${branch} --depth=$DEPTH


  if ($LastExitCode -ne 0) {
    git diff --diff-filter=U

    throw "${branch}: merge failed"
  }


  echo "`n"
}



#####################################



function global:git_modify($file, $mode) {
  ren ${file} ${file}___1
  git add . --force
  ren ${file}___1 ${file}


  c:\msys64\mingw64\bin\git_edit.exe ${file} ${mode}
  git add . --force
  git commit -m "resolved"


  if ($LastExitCode -ne 0) {
    git diff --diff-filter=U

    throw "${branch}: merge failed"
  }


  echo "`n"
}



#####################################



function global:git_resolve($branch, $file, $mode) {
  git pull origin ${branch} --depth=$DEPTH
  git diff --diff-filter=U


  git_modify ${file} ${mode}


  echo "`n"
}
