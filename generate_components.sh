# все команды через консоль

# Обрабатываем данные
tail -n +2 components.csv | while IFS=';' read -r poz tip name marking quantity date dela why comment; do
    num=$(printf "%03d" "$poz")
    filename="components/$num.txt"
    
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
done