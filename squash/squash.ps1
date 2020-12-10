$MERGE = 0
$MAX = git rev-list --count HEAD



###################################################



if( [int] ${env:GIT_SQUASH} -Ge 0 ) {
  $MERGE = ${env:GIT_SQUASH}
}


else {
  while( $MERGE -Lt $MAX ) {
    if(( git log -1 --skip=$MERGE --pretty=format:'%an' ) -Match ${env:GIT_AUTHOR} -Eq $False ) {
      break
    }


    $MERGE = $MERGE + 1
  }
}



if( $MERGE -Ge $MAX ) {
  $MERGE = $MAX
}



###################################################



$MESSAGE = git log -1 --skip=$( $MERGE-0 ) --pretty=format:'%s%n%b'

echo $MERGE
echo $MESSAGE
echo $( $MERGE-0 )


if( $MERGE -Eq $MAX) {
  git reset --soft HEAD~$( $MERGE-1 )
  git commit --amend -m "$MESSAGE" --author="${env:GIT_AUTHOR} <${env:GIT_EMAIL}>"
}


elseif( $MERGE -Ge 1 ) {
  git reset --soft HEAD~$( $MERGE )
  git commit -m "$MESSAGE" --author="${env:GIT_AUTHOR} <${env:GIT_EMAIL}>"
}
