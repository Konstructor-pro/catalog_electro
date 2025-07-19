Задача: создать в дериктории components txt файлы, в которые нужно занести данные из исходной таблицы CSV, и в строках которых будут отображены заголовки колонок из таблицы. Это нужно сделать через шаблон и используя автоматическое создание болванок txt файлов. Затем из заполненных файлов формируем новую таблицу CSV.
Решение: в директории home\esignachinekonstructor\projects\catalog_electro создаем файл шаблона template.txt
mkdir components
echo "поз: " > template.txt
echo "тип компонента: " >> template.txt
echo "наименование компонента: " >> template.txt
echo "маркировка: " >> template.txt
echo "количество: " >> template.txt
echo "дата покупки: " >> template.txt
echo "функция: " >> template.txt
echo "где применимо: " >> template.txt
echo "для чего использовать: " >> template.txt
echo "примечание: " >> template.txt


автоматическое создание файлов по сркипту – создаем файл create_components.sh:
#!/bin/bash

for i in {001..200}; do
  cp template.txt "components/$i.txt"
done

и запускаем через команду:
chmod +x create_components.sh
./create_components.sh

Возникает проблема с кодировкой: по умолчанию латиница ASCII а не кириллица UTF-8. Создаем скрипт generate_csv.sh

#!/bin/bash

# Устанавливаем UTF-8 как стандартную кодировку
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Заголовок CSV в UTF-8
echo -e "\xEF\xBB\xBFпоз;тип компонента;наименование компонента;маркировка;количество;дата покупки;функция;где применимо;для чего использовать;примечание" > components.csv

for file in components/*.txt; do
  # Используем iconv для конвертации в UTF-8
  iconv -f UTF-8 -t UTF-8 "$file" | awk -F ': ' '{
    gsub(/;/, ",", $2)  # Заменяем точки с запятой в данных
    
    if (NR == 1) poz = $2
    if (NR == 2) typ = $2
    if (NR == 3) nazvanie = $2
    if (NR == 4) markirovka = $2
    if (NR == 5) kolichestvo = $2
    if (NR == 6) data = $2
    if (NR == 7) funkcia = $2
    if (NR == 8) primenenie = $2
    if (NR == 9) ispolzovanie = $2
    if (NR == 10) primechanie = $2
    
  } END {
    print poz ";" typ ";" nazvanie ";" markirovka ";" kolichestvo ";" data ";" funkcia ";" primenenie ";" ispolzovanie ";" primechanie
  }' >> components.csv
done
echo "CSV создан: components.csv"

chmod +x generate_csv.sh сделаем исполняемым 
./generate_csv.sh запускаем
В итоге в корневой директории видим файл