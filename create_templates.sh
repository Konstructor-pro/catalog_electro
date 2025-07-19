#!/bin/bash

# Определяем последний существующий номер
last_num=$(ls components | grep -E '^[0-9]+\.txt$' | sort -n | tail -n 1 | cut -d '.' -f 1)
start_num=$((last_num + 1))
end_num=$((start_num + 0))

# Создаем шаблоны
for ((i=start_num; i<=end_num; i++)); do
    num=$(printf "%03d" "$i")
    filename="components/$num.txt"
    
    # Создаем файл с шаблоном
    cat << EOF > "$filename"
поз: $i
тип компонента:
наименование компонента:
маркировка:
количество:
дата покупки:
что делает:
для чего использовать:
примечание:
EOF
    
    echo "Создан шаблон: $filename"
done

echo "Готово! Создано $((end_num - start_num + 1)) новых шаблонов."