function strsplit(input_string, separator)
    if not separator then
        separator = "%s"
    end

    local t = {}
    for str in string.gmatch(input_string, "([^" .. separator .. "]+)") do
        table.insert(t, str)
    end
    return t
end
