$env:GIT_REDIRECT_STDERR = '2>&1'



git config --global --unset credential.helper
git config --global --unset user.name
git config --global --unset user.email



if( ${env:AUTHOR} -Eq $Null ) {
  $env:AUTHOR = ${env:APPVEYOR_REPO_COMMIT_AUTHOR}
}


if( ${env:EMAIL} -Eq $Null ) {
  $env:EMAIL = ${env:APPVEYOR_REPO_COMMIT_AUTHOR_EMAIL}
}



###############################################



git config --global user.name "${env:AUTHOR}"
git config --global user.email "${env:EMAIL}"


git config --global advice.detachedHead false
git config --global core.autocrlf false
git config --global pull.rebase false


git config --global credential.helper store

Set-Content "$HOME/.git-credentials" "https://${env:APPVEYOR_REPO_COMMIT_AUTHOR}:${env:LOGIN}@github.com`n"
