$url = "https://github.com/${env:GIT_USER}?tab=repositories"


$wait1 = 150
$wait2 = 100



echo "`n`nGitHub: ${env:GIT_USER}`n"



##################################



while(1) {
  Start-Sleep -m $wait1
  curl -o "C:\list.txt" $url


  if( $? -Eq $False ) {
    break
  }



  # Users
  foreach( $repo in Select-String -Path "C:\list.txt" -Pattern "<a href=`"(.+)`" itemprop=`"name codeRepository`"" ) {
    $repo = ($repo -Split "<a href=`"/${env:GIT_USER}/(.+)`" itemprop=`"name codeRepository`"")[1]


    Start-Sleep -m $wait2
    curl -o "C:\repo.txt" "https://github.com/${env:USER}/$repo"


    if( (Get-Content "C:\repo.txt" -Raw) -Match "(\d+) commit(s)? behind" -Eq $True ) {
      echo "$repo  --  $($matches[0])"
    }
  }



  # Organizations
  foreach( $repo in Select-String -Path "C:\list.txt" -Pattern "/hovercard`" href=`"(.+)`" class=`"d-inline-block`">" ) {
    $repo = ($repo -Split "/hovercard`" href=`"/${env:GIT_USER}/(.+)`" class=`"d-inline-block`">")[1]


    Start-Sleep -m $wait2
    curl -o "C:\repo.txt" "https://github.com/${env:GIT_USER}/$repo"


    if( (Get-Content "C:\repo.txt" -Raw) -Match "(\d+) commit(s)? behind" -Eq $True ) {
      echo "$repo  --  $($matches[0])"
    }
  }




  if( (Get-Content "C:\list.txt" -Raw) -Match "https://github.com/${env:GIT_USER}\?after=(.+)`">Next" -Eq $False ) {
    break
  }

  $url = "https://github.com/${env:GIT_USER}?after=$($matches[1])"
}



##################################



echo "`n"
