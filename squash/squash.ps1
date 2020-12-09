if( ${env:GIT_SQUASH} -Ge 0 ) {
  $MERGE = ${env:GIT_SQUASH}
}


else {
  $MERGE = 0
  $MAX = git rev-list --count HEAD


  while( $MERGE -Lt $MAX ) {
    if(( git log -1 --skip=$MERGE --pretty=format:'%an' ) -Match ${env:APPVEYOR_REPO_COMMIT_AUTHOR} -Eq $False ) {
      break
    }


    $MERGE = $MERGE + 1
  }
}



###################################################



if( $MERGE -Ge $MAX ) {
  $MERGE = $MAX - 1
}



if( $MERGE -Ge 1 ) {
  $TITLE = git log -5 --skip=$MERGE --pretty=format:'%s%n%b'


  git reset --soft HEAD~$MERGE
  # git push -f -m "$TITLE" --author="${env:GIT_AUTHOR} <${env:GIT_EMAIL}>"
}
