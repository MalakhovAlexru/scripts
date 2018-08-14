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


# проверка ввода
read -p "Please enter something: " userInput

# Check if string is empty using -z. For more 'help test'    
if [[ -z "$userInput" ]]; then
   printf '%s\n' "No input entered"
   exit 1
else
   # If userInput is not empty show what the user typed in and run ls -l
   printf "You entered %s " "$userInput"
   ls -l
fi