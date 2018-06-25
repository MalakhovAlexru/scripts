#!/bin/bash

arrayOfFiles=('/etc/hosts''/etc/hostname''/etc/init.d/ntpdate')

for file in ${arrayOfFiles[@]}; do
	if [ -d "$file" ]; then
		echo "$file is a directory"
	elif [ -f "$file" ]; then
		echo "$file is a file"
	fi
done

# # создание директирий, проверка их наличия
# function initialScript {
# for (( i=0; i < 1; i++ ))
# do
# # if [ -d "$dirforBackUP" ]
# # then echo "Директория существует"
# # else
# # echo "Директория создана по адресу: '$dirforBackUP'."
# # mkdir -p "$dirforBackUP"
# # fi
# if [ -d "$dirforLogs" ]
# then echo "Директория существует"
# else
# echo "Директория создана по адресу: '$dirforLogs'."
# mkdir -p "$dirforLogs"
# fi
# done
# }
