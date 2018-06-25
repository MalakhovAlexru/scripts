    for number in $clientCount
do
if [ -f "$file" ]; then
   echo "Файл '$file' существует.";
   cp "$file" "$dirforBackUP";
   buff = '[^\/]*.$' file
   echo "$buff"
    cp "$dirforPatterns$buff" "$file";
else
   echo "Файл '$file' не найден."
fi
done
fi