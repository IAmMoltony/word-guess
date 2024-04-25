require ".gradient"
require ".wordlist"
require ".tableprint"
require ".tableshuffle"

function love.load()
    print("main: Loading")

    -- set window mode
    local set_mode_ok = love.window.setMode(640, 480)
    if not set_mode_ok then
        error("Failed to set window mode")
    end

    -- create background gradient
    background_gradient = gradient_mesh("vertical", {135 / 255.0, 206 / 255.0, 235 / 255.0}, {35 / 255.0, 106 / 255.0, 135 / 255.0})

    -- seed random
    math.randomseed(os.time())

    load_word_list()

    choose_random_combination()

    -- get screen height
    local screen_height = love.graphics.getHeight()

    -- square Y position
    local square_y = screen_height - 138

    -- set up square positions
    square_positions = {
        {x = 10, y = square_y},
        {x = 148, y = square_y},
        {x = 286, y = square_y},
        {x = 424, y = square_y}
    }

    clicked_squares = {
        false, false, false, false
    }

    -- create font
    game_font = love.graphics.newFont("robotomono.ttf", 64);
    love.graphics.setFont(game_font)

    current_word = ""

    mouse_x, mouse_y = 0, 0

    print("main: Loading done")
end

function love.update()
end

function love.mousepressed(x, y, button)
    if button == 1 then
        for i, pos in ipairs(square_positions) do
            if is_square_hovered(pos, x, y) and not clicked_squares[i] then
                current_word = current_word .. current_combination[i]
                clicked_squares[i] = true
            end
        end
    end

    if string.len(current_word) == 4 then
        if is_valid_word(current_word) then
            choose_random_combination()
            current_word = ""
            clicked_squares = {false, false, false, false}
        else
            current_word = ""
            clicked_squares = {false, false, false, false}
        end
    end
end

function love.mousemoved(x, y)
    mouse_x = x
    mouse_y = y
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(background_gradient, 0, 0, 0, love.graphics.getDimensions())

    draw_squares()
    draw_word()
end

function draw_squares()
    for i, pos in ipairs(square_positions) do
        local is_hovered = is_square_hovered(pos, mouse_x, mouse_y)

        if not clicked_squares[i] then
            love.graphics.setColor(0, is_hovered and 0.9 or 0.7, 0)
            love.graphics.rectangle("fill", pos.x, pos.y, 128, 128)
            love.graphics.setColor(0, is_hovered and 0.7 or 0.9, 0)
            love.graphics.rectangle("line", pos.x, pos.y, 128, 128)
        end

        -- draw the letter
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(current_combination[i], pos.x + 10, pos.y + 10)
    end
end

function draw_word()
    love.graphics.setColor(0, 0, 0, 0.4)
    love.graphics.print(current_word, 24, 34)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(current_word, 20, 30)
end

function choose_random_combination()
    current_combination = letter_combinations[math.random(1, #letter_combinations)]
    current_combination = shuffle_table(current_combination)
    print("main: Chose combination: " .. table.concat(current_combination, ","))
end

function is_square_hovered(pos, mx, my)
    return mx >= pos.x and my >= pos.y and mx <= (pos.x + 128) and my <= (pos.y + 128)
end
