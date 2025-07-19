# Удаляем BOM если присутствует и обрабатываем данные
tail -c +4 components.csv | tail -n +2 | while IFS='' read -r line; do
    # Заменяем последовательные разделители на заполнители
    line=$(echo "$line" | sed 's/;;/;-;/g; s/;;/;-;/g; s/;$/;-/')
    
    # Разбиваем строку на поля
    IFS=';' read -r poz tip name marking quantity date dela why comment <<< "$line"
    
    # Восстанавливаем пустые значения
    for var in dela why comment; do
        declare -n ref=$var
        ref=${ref//-/}
    done

    # Генерируем имя файла
    num=$(printf "%03d" "$poz")
    filename="components/$num.txt"
    
    # Создаем файл
    cat << EOF > "$filename"
поз: $poz
тип компонента: $tip
наименование компонента: $name
маркировка: $marking
количество: $quantity
дата покупки: $date
что делает: $dela
для чего использовать: $why
примечание: $comment
EOF

    echo "Создан файл: $filename"
done