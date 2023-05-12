
#!/bin/sh
# ftxtx.sh  --knn_knstntnn 230512  


####>> vars :
confDir=$HOME/.config/ftxtx
confFile=$confDir/ftxtx.conf
gtkrcFile=$confDir/ftxtx.Xd.rc
ftxtxDir=$HOME/ftxtx


####>> mk user-cfgs : 
[[ -d $confDir ]] || ` mkdir $confDir ;  cp /etc/ftxtx/* $confDir ;  echo "ftxtxDir=$ftxtxDir" >> $confFile ; echo "gtkrcFile=$gtkrcFile" >> $confFile `


####>> ?? +/- ?
[[ -f $confFile ]] || ` echo >> $confFile ; echo "ftxtxDir=$ftxtxDir" >> $confFile `
 



fileDate=$(date +%F_%H-%M-%S)

t=`xsel -o `

echo "$@" > /tmp/ftxtx-$fileDate.txt
echo -e "$t" >> /tmp/ftxtx-$fileDate.txt

tChk=$(sed -n '1,12p' < /tmp/ftxtx-$fileDate.txt | cut -c-100 )

IFS=$'\n'
 


DIALOG=Xdialog 

name=`$DIALOG   --icon /usr/share/pixmaps/ftxtx.xpm --rc-file $gtkrcFile   --no-cancel --stdout  --title "ftxtx: вв. начало имени ..-$fileDate.txt"  --inputbox  "часть содержания буфера:\n \n $tChk " 30 100 `


case $? in
      0)
      echo "Выбран ...." ;;
    1)
	echo "Отказ от ввода." ; rm /tmp/ftxtx-$fileDate.txt ; exit 0;; 
    255)
	echo "Нажата клавиша ESC." ;  rm /tmp/ftxtx-$fileDate.txt  ; exit 0;; 
 esac



ftxtxDir=$(echo `awk -F 'ftxtxDir=' ' { print $2 }  ' $confFile`)

[[ -d $ftxtxDir ]] || mkdir  $ftxtxDir



####>> chk :
[[  -z "$name" ]] && sffx=_$fileDate
[[ -f $ftxtxDir/${name// /_}.txt ]] && sffx=_$fileDate




####>> rplc " " --> "_"
file=$ftxtxDir/${name// /_}$sffx.txt


####>> +  name,path
echo -e "${name}\n"'file://'"${file}\n""=========\n""=========\n""$(cat /tmp/ftxtx-$fileDate.txt)" > /tmp/ftxtx-$fileDate.txt


####>> + 3-empty
echo -e "\n\n\n""=========\n""=========\n" >> /tmp/ftxtx-$fileDate.txt



## ## ## !!!
 mv /tmp/ftxtx-$fileDate.txt "${file}" 2> /tmp/ftxtx.err  

[[ -z "$(cat /tmp/ftxtx.err)" ]] ||  ` Xdialog --title "ftxtx:" --msgbox "$(cat /tmp/ftxtx.err)" 30 100 ; exit 1  `




txtViewer=$(echo `awk -F 'txtViewer=' ' { print $2 }  ' $confFile`) 


[[ -z "$(cat /tmp/ftxtx.err)" ]] &&  "${txtViewer}" "${file}" 

 rm /tmp/ftxtx.err



exit 0

