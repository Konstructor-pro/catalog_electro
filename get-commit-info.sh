#!/bin/bash

# Скрипт: get-commit-info.sh
# Использование: ./get-commit-info.sh <хэш-коммита>

# Проверяем, передан ли аргумент
if [ $# -eq 0 ]; then
    echo "Ошибка: Укажите хэш коммита"
    exit 1
fi

COMMIT_HASH=$1
OUTPUT_DIR="request_commits"
OUTPUT_FILE="$OUTPUT_DIR/commit_$COMMIT_HASH.txt"

# Создаем директорию, если ее нет
mkdir -p "$OUTPUT_DIR"

# Получаем информацию о коммите
git show --pretty=format:"\
Хеш коммита: %H
Автор: %an <%ae>
Дата автора: %ad
Коммитер: %cn <%ce>
Дата коммитера: %cd
Сообщение коммита: 
%s
" \
--date=format:'%H:%M:%S %d.%m.%y' \
--stat \
--name-status \
--diff-filter=ACDMRTUXB \
--ignore-all-space \
--ignore-blank-lines \
--color=never \
"$COMMIT_HASH" > "$OUTPUT_FILE"

# Добавляем информацию о тегах
TAGS=$(git tag --points-at "$COMMIT_HASH")
if [ -n "$TAGS" ]; then
    echo -e "\nСвязанные теги:" >> "$OUTPUT_FILE"
    echo "$TAGS" >> "$OUTPUT_FILE"
fi

# Добавляем информацию о ветках
BRANCHES=$(git branch --contains "$COMMIT_HASH" -a)
if [ -n "$BRANCHES" ]; then
    echo -e "\nПрисутствует в ветках:" >> "$OUTPUT_FILE"
    echo "$BRANCHES" >> "$OUTPUT_FILE"
fi

# Добавляем ссылку на родительские коммиты
PARENTS=$(git log --pretty=format:%H -1 "$COMMIT_HASH"^@)
if [ -n "$PARENTS" ]; then
    echo -e "\nРодительские коммиты:" >> "$OUTPUT_FILE"
    for parent in $PARENTS; do
        echo "  $parent" >> "$OUTPUT_FILE"
    done
fi

echo "Информация о коммите сохранена в: $OUTPUT_FILE"