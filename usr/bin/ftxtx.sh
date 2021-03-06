#!/bin/sh
# ftxtx.sh  --knn_knstntnn 200922   


DIALOG=Xdialog 

fileDate=$(date +%F_%H-%M-%S)

t=`xsel -o `

echo "$@" > /tmp/ftxtx-$fileDate.txt
echo -e "$t" >> /tmp/ftxtx-$fileDate.txt

tChk=$(sed -n '1,12p' < /tmp/ftxtx-$fileDate.txt | cut -c-100 )

IFS=$'\n'

name=`$DIALOG   --stdout --title "ftxtx: вв. начало имени ..-$fileDate.txt"  --inputbox "часть содержания буфера:\n \n $tChk " 30 100 `

case $? in
      0)
      echo "Выбран ...." ;;
    1)
	echo "Отказ от ввода." ; rm /tmp/ftxtx-$fileDate.txt ; exit 0;; 
    255)
	echo "Нажата клавиша ESC." ;  rm /tmp/ftxtx-$fileDate.txt  ; exit 0;; 
 esac

mv /tmp/ftxtx-$fileDate.txt $HOME/$name-$fileDate.txt

IFS=$' '

txtViewer=$(echo `awk -F 'txtViewer=' ' { print $2 }  ' $HOME/.config/ftxtx.conf`) 

$txtViewer "$(echo $HOME/$name-$fileDate.txt)" 

exit 0

