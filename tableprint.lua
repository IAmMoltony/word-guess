function print_table(tbl)
    for index, value in ipairs(tbl) do
        print(index .. " = " .. value)
    end
end

function print_table_of_tables(tbl)
    for index, value in ipairs(tbl) do
        print("Table " .. index)
        print_table(value)
    end
end
