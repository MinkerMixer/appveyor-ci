if( ${env:GIT_SQUASH } -Eq "yes") {
  ${env:GIT_SQUASH} = 0
}

else {
  ${env:GIT_SQUASH} = -1
}



#################################################



git remote add origin "https://github.com/${env:APPVEYOR_REPO_NAME}.git"

git fetch origin --no-tags



if( $env:GIT_ERASE -Ne 0 ) {
  git checkout origin/${env:APPVEYOR_REPO_BRANCH}

  git reset --hard HEAD~${env:GIT_ERASE}

  git push -f origin HEAD:${env:APPVEYOR_REPO_BRANCH}
}



#################################################



curl -o "C:\repo.txt" "https://github.com/${env:APPVEYOR_REPO_NAME}"


$GIT_UPSTREAM = ( ((Get-Content "C:\repo.txt" -Raw) -Split "forked from")[1] -Split "`">(.+)</a>" )[1]

$GIT_DEFAULT = ( (Get-Content "C:\repo.txt" -Raw) -Split "<span class=`"css-truncate-target`" data-menu-button>(.+)</span>")[1]



#################################################



git remote add upstream "https://github.com/${GIT_UPSTREAM}.git"

git fetch upstream master:upstream --no-tags
git fetch upstream ${GIT_DEFAULT}:upstream --no-tags



$branches = git branch -r | Select-String -NotMatch "upstream"


foreach( $branch in $branches ) {
  $branch = ( ($branch -Replace '(^\s+|\s+$)','') -Split '/' )[1]

  echo "`n${branch}"



  git checkout origin/${branch}


  iex( (New-Object System.Net.WebClient).DownloadString( "${env:GIT_SCRIPT}/squash/squash.ps1" ) )



  ### ================================================ ###



  if( $branch -Eq "master" ) {
    git rebase upstream/master
  }

  else if( $branch -Eq "main" ) {
    git rebase upstream/main
  }

  else {
    git rebase upstream/${GIT_DEFAULT}
  }




  if( $? -Eq $False ) {
    git diff --diff-filter=U


    if( ${env:GIT_FORCE} -Ne "yes") {
      throw "${branch}: rebase failure"
    }


    git add .
    git rebase --continue
  }



  ### ================================================ ###



  git push -f origin HEAD:${branch}


  if( $? -Eq $False ) {
    throw "${branch}: rebase failure"
  }
}



#################################################



echo "`n"
