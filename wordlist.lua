require ".strsplit"

function load_word_list()
    print("wordlist: Loading word list")

    local word_list_file, word_list_file_error = io.open("./words4.txt", "r")
    if word_list_file_error then
        error(word_list_file_error)
    end

    local word_list_str = word_list_file:read("*a")
    if not word_list_str then
        error("Failed to read word list file")
    end

    word_list = strsplit(word_list_str, "\n")
    print("wordlist: " .. #word_list .. " words")
    generate_combinations()

    word_list_file:close()

    print("wordlist: Loaded word list")
end

function generate_combinations()
    print("wordlist: Generating combinations")
    letter_combinations = {}

    for _, word in ipairs(word_list) do
        local chars = {}

        -- split into chars
        for char in word:gmatch(".") do
            table.insert(chars, char)
        end

        for i = 1, #chars - 3 do
            local combination = {chars[i], chars[i + 1], chars[i + 2], chars[i + 3]}
            table.insert(letter_combinations, combination)
        end
    end

    print("wordlist: Removing duplicate combinations")
    local seen = {}
    local unique_letter_combinations = {}

    for _, sub_table in ipairs(letter_combinations) do
        local key = sort_and_concat(sub_table)
        if not seen[key] then
            seen[key] = true
            table.insert(unique_letter_combinations, sub_table)
        end
    end

    letter_combinations = unique_letter_combinations

    print("wordlist: Generated " .. #letter_combinations .. " combinations")
end

function sort_and_concat(tbl)
    local sorted_table = {unpack(tbl)}
    table.sort(sorted_table)
    return table.concat(sorted_table)
end

function is_valid_word(word)
    if string.len(word) ~= 4 then
        return false
    end

    for _, value in ipairs(word_list) do
        if word == value then
            return true
        end
    end

    return false
end

function get_random_letter_combination()
    return letter_combinations[math.random(1, #letter_combinations)]
end
