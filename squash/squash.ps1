$merge = 0
$max = git rev-list --count HEAD



if( ${env:GIT_SQUASH} -Lt 0 ) {
  exit
}



###################################################



if( ${env:GIT_SQUASH} -Ge 1 ) {
  $merge = ${env:GIT_SQUASH}
}

else {
  while ($merge -Lt $max) {
    if ((git log -1 --skip=$merge --pretty=format:'%an') -Match ${env:APPVEYOR_REPO_COMMIT_AUTHOR} -Eq $False) {
      break
    }


    $merge = $merge + 1
  }
}


$merge = $merge - 1



###################################################



if ($merge -Ge $max) {
  $merge = $merge - 1
}



if ($merge -Ge 1) {
  $title = git log -1 --skip=$merge --pretty=format:'%s%n%b'


  git reset --soft HEAD~$merge
  git commit --amend -m "$title" --date "$(date)" --author="${env:AUTHOR} <${env:EMAIL}>"
}
