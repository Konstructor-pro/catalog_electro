#!/bin/bash
# Явно устанавливаем кодировку UTF-8
export LC_ALL=C.UTF-8
export LANG=C.UTF-8

# Создаем CSV с BOM для корректного отображения в Excel
echo -ne "\xEF\xBB\xBF" > components_utf8.csv
echo "поз;тип компонента;наименование компонента;маркировка;количество;дата покупки;что делает;для чего использовать;примечание" >> components_utf8.csv

# Обработка файлов с поддержкой пробелов в именах
find components -name '*.txt' -print0 | sort -zV | while IFS= read -r -d $'\0' file; do
    # Инициализация переменных
    declare -A data=(
        ["поз"]=""
        ["тип компонента"]=""
        ["наименование компонента"]=""
        ["маркировка"]=""
        ["количество"]=""
        ["дата покупки"]=""
        ["что делает"]=""
        ["для чего использовать"]=""
        ["примечание"]=""
    )
    
    # Чтение файла с явным указанием кодировки
    while IFS= read -r line || [[ -n "$line" ]]; do
        # Удаляем DOS-переводы строк
        line="${line%$'\r'}"
        
        # Пропускаем пустые строки
        [[ -z "$line" ]] && continue
        
        # Разделяем строку на ключ и значение
        if [[ "$line" =~ ^([^:]+):\ *(.*)$ ]]; then
            key="${BASH_REMATCH[1]}"
            value="${BASH_REMATCH[2]}"
            
            # Сохраняем значение в ассоциативном массиве
            if [[ -v "data[$key]" ]]; then
                data["$key"]="$value"
            fi
        fi
    done < <(iconv -f UTF-8 -t UTF-8 "$file")

    # Формируем CSV-строку
    printf -v csv_line "%s;%s;%s;%s;%s;%s;%s;%s;%s" \
        "${data[поз]}" \
        "${data[тип компонента]}" \
        "${data[наименование компонента]}" \
        "${data[маркировка]}" \
        "${data[количество]}" \
        "${data[дата покупки]}" \
        "${data[что делает]}" \
        "${data[для чего использовать]}" \
        "${data[примечание]}"
    
    # Добавляем строку в CSV
    echo "$csv_line" >> components_utf8.csv
    echo "Обработан: $(basename "$file") (поз: ${data[поз]:-НЕТ})"
done

# Сортировка по первому столбцу (позиция)
(
    head -n 1 components_utf8.csv
    tail -n +2 components_utf8.csv | sort -n -t ';' -k1,1
) > components_sorted.csv

mv components_sorted.csv components_utf8.csv
echo "Готово! Все данные объединены в components_utf8.csv"