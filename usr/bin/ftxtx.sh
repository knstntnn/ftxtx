#!/bin/sh
# ftxtx.sh  --knn_knstntnn 230512  
# --edit 241114: add 'Button xdg-open $ftxtxDir' + some-edit
# -- ... : $fm , 'clipboard-if-primary==0', 'выводы ошибок'.

####>> init-vars :
confDir=$HOME/.config/ftxtx
confFile=$confDir/ftxtx.conf
gtkrcFile=$confDir/ftxtx.Xd.rc
ftxtxDir=$HOME/ftxtx

####>> mk user-cfgs : 
[[ -d $confDir ]] || ` mkdir $confDir ; cp /etc/ftxtx/* $confDir ;  echo "ftxtxDir=$ftxtxDir" >> $confFile ; echo "gtkrcFile=$gtkrcFile" >> $confFile `

####>> conf-vars :
ftxtxDir=$(grep ftxtxDir $confFile | cut -d '=' -f 2)
gtkrcFile=$(grep gtkrcFile $confFile | cut -d '=' -f 2)
fm=$(echo `awk -F 'fm=' '{ print $2 }' $confFile`)

[[ -d $ftxtxDir ]] || mkdir $ftxtxDir

####>> ?? +/- (при случайн. удалении)?
##[[ -f $confFile ]] || ` echo >> $confFile ; echo "ftxtxDir=$ftxtxDir" >> $confFile `
 
fileDate=$(date +%F_%H-%M-%S)

t=`xsel -o `
[ -z "${t}" ] && t=`xsel -ob`

echo "$@" > /tmp/ftxtx-$fileDate.txt
echo -e "$t" >> /tmp/ftxtx-$fileDate.txt

tChk=$(sed -n '1,12p' < /tmp/ftxtx-$fileDate.txt | cut -c-100 )

IFS=$'\n'
 
DIALOG=Xdialog 

name=`$DIALOG  \
  --icon /usr/share/pixmaps/ftxtx.xpm \
  --rc-file $gtkrcFile \
  --cancel-label ">> ftxtxDir"  \
  --stdout  \
  --title "введите начало имени ..-$fileDate.txt"  \
  --inputbox  "часть содержания буфера:\n \n $tChk " 30 100 \
  `
    case $? in
          0)  
          ;;
          1)            
            cmd=$(echo "${fm} ${ftxtxDir}") ;  
            sh -c "${cmd}" 2> /tmp/ftxtx.err || 
            $DIALOG \
            --title "ftxtx:" \
            --msgbox "$(cat /tmp/ftxtx.err)" 30 100 ; 
            rm /tmp/ftxtx.err;  rm /tmp/ftxtx-$fileDate.txt ; 
            exit 0
          ;;      
          255)
    	    echo "закрытие окна." ;  rm /tmp/ftxtx-$fileDate.txt ; 
    	    exit 0
    	  ;; 
    esac

####>> chk-prefix,w :
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

## txtViewer :
txtViewer=$(echo `awk -F 'txtViewer=' '{ print $2 }' $confFile`) 

## err:
[[ -z "$(cat /tmp/ftxtx.err)" ]] || 
  ` $DIALOG \
  --title "ftxtx:" \
  --msgbox "$(cat /tmp/ftxtx.err)" 30 100 ;
  echo !!ОШИБКА-сохранения!_см.-/tmp/ftxtx-$fileDate.txt >> /tmp/ftxtx-$fileDate.txt 
  sh -c `"${txtViewer}" /tmp/ftxtx-$fileDate.txt` ;
  exit 1 \ 
  `
## ok:
[[ -z "$(cat /tmp/ftxtx.err)" ]] && 
  `cmd="${txtViewer}"" ""'"${file}"'" ; 
  sh -c "${cmd}" 
  `    
rm /tmp/ftxtx.err

exit 0
