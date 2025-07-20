#!/bin/bash

# Настройки
CSV_FILE="tags_history.csv"
CSV_HEADER="Тэг;Дата;Коммит;Сообщение"

# Создаем новый CSV файл с заголовком
echo "$CSV_HEADER" > "$CSV_FILE"

# Получаем все теги в обратном хронологическом порядке
git tag -l --format='%(refname:short);%(taggerdate:short);%(*objectname:short);%(contents:subject)' | sort -r | while IFS= read -r line; do
    # Пропускаем пустые строки
    if [ -z "$line" ]; then continue; fi
    
    # Удаляем все кавычки из строки
    clean_line=$(echo "$line" | tr -d '"')
    
    # Добавляем строку в CSV
    echo "$clean_line" >> "$CSV_FILE"
done

echo "CSV файл полностью пересоздан: $CSV_FILE"
echo "Добавлено тегов: $(git tag | wc -l)"