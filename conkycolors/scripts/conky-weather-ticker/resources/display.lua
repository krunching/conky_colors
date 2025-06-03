-- display.lua – Conky Weather with Infinite Scrolling Ticker
-- by @wim66 – April 8, 2025
-- Adjusted to fix fade effect, improve ticker speed control, and center weather description statically above ticker

require 'cairo'
-- Try to require the 'cairo_xlib' module safely
local status, cairo_xlib = pcall(require, 'cairo_xlib')

if not status then
    -- If the module is not found, fall back to a dummy table
    -- This dummy table redirects all unknown keys to the global namespace (_G)
    -- This allows usage of global Cairo functions like cairo_xlib_surface_create
    cairo_xlib = setmetatable({}, {
        __index = function(_, k)
            return _G[k]
        end
    })
end

-- Global variables for scrolling
local scroll_offset = 0          -- Tracks the current scroll position of the ticker
local last_update_time = os.clock() -- Stores the last update time for delta calculation
local ticker_speed = 1           -- Base speed of the ticker (pixels per second)
local speed_scale = 1000         -- Scaling factor for speed (adjusted for finer control)
local use_fade_effect = true     -- Toggle fade effect on/off

-- Function to load weather data from a file
local function read_weather_data()
    local weather_data = {}
    local file = io.open("./resources/weather_data.txt", "r")
    if not file then return weather_data end

    -- Parse key-value pairs from the file
    for line in file:lines() do
        local key, value = line:match("([^=]+)=([^=]+)")
        if key and value then
            weather_data[key] = value
        end
    end
    file:close()
    return weather_data
end

-- Function to calculate the width of text for scrolling calculations and centering
local function get_text_width(cr, text, font, size)
    cairo_select_font_face(cr, font, CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL)
    cairo_set_font_size(cr, size)
    local extents = cairo_text_extents_t:create()
    cairo_text_extents(cr, text, extents)
    return extents.width
end

-- Function to draw text with specified properties
local function draw_text(cr, text, x, y, font, size, color, alpha)
    cairo_select_font_face(cr, font, CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL)
    cairo_set_font_size(cr, size)
    cairo_set_source_rgba(cr, color[1], color[2], color[3], alpha or color[4])
    cairo_move_to(cr, x, y)
    cairo_show_text(cr, text)
end

-- Language-based label translations
local function get_labels(lang)
    if lang == "nl" then
        return {
            temp = "Temp",
            temp_min = "Min",
            temp_max = "Max",
            humidity = "Luchtvochtigheid",
            wind_speed = "Wind snelheid"
        }
    elseif lang == "en" then
        return {
            temp = "Temp",
            temp_min = "Min",
            temp_max = "Max",
            humidity = "Humidity",
            wind_speed = "Wind Speed"
        }
    elseif lang == "fr" then
        return {
            temp = "Temp",
            temp_min = "Min",
            temp_max = "Max",
            humidity = "Humidité",
            wind_speed = "Vitesse du vent"
        }
    elseif lang == "es" then
        return {
            temp = "Temp",
            temp_min = "Min",
            temp_max = "Max",
            humidity = "Humedad",
            wind_speed = "Velocidad del viento"
        }
    elseif lang == "de" then
        return {
            temp = "Temp",
            temp_min = "Min",
            temp_max = "Max",
            humidity = "Luftfeuchtigkeit",
            wind_speed = "Windgeschwindigkeit"
        }
    else
        return {
            temp = "Temp",
            temp_min = "Min",
            temp_max = "Max",
            humidity = "Humidity",
            wind_speed = "Wind Speed"
        }
    end
end

-- Main function to draw the weather display
function conky_draw_weather()
    if conky_window == nil then return end

    -- Load weather data
    local weather_data = read_weather_data()
    local city = weather_data.CITY or "N/A"
    local lang = weather_data.LANG or "en"
    local labels = get_labels(lang)

    -- Weather data variables
    local weather_icon_path = "./resources/cache/weathericon.png"
    local weather_desc = weather_data.WEATHER_DESC or "N/A"
    local temp = weather_data.TEMP or "N/A"
    local temp_min = weather_data.TEMP_MIN or "N/A"
    local temp_max = weather_data.TEMP_MAX or "N/A"
    local humidity = weather_data.HUMIDITY or "N/A"
    local wind_speed = weather_data.WIND_SPEED or "N/A"

    -- Create ticker string with weather information (excluding weather_desc)
    local ticker_string = string.format(
        "%s: %s • %s: %s • %s: %s • %s: %s • %s: %s    ",
        labels.temp, temp,
        labels.temp_min, temp_min,
        labels.temp_max, temp_max,
        labels.humidity, humidity .. "%",
        labels.wind_speed, wind_speed .. " m/s"
    )

    -- Repeat the string for seamless infinite scrolling
    ticker_string = ticker_string:rep(4)

    -- Create Cairo surface and context
    local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual,
                                         conky_window.width, conky_window.height)
    local cr = cairo_create(cs)

    -- Draw weather icon
    local image = cairo_image_surface_create_from_png(weather_icon_path)
    local img_w = cairo_image_surface_get_width(image)
    local img_h = cairo_image_surface_get_height(image)
    cairo_save(cr)
    cairo_translate(cr, 0, 0)
    cairo_scale(cr, 120 / img_w, 120 / img_h)
    cairo_set_source_surface(cr, image, 0, 0)
    cairo_paint(cr)
    cairo_restore(cr)
    cairo_surface_destroy(image)

    -- Draw city name
    draw_text(cr, city, 120, 100, "ChopinScript", 72, {1, 0.4, 0, 1})

    -- Draw weather description statically centered above the ticker
    local desc_font = "Dejavu Serif"
    local desc_size = 26
    local desc_color = {1, 0.66, 0, 1}
    local desc_width = get_text_width(cr, weather_desc, desc_font, desc_size)
    local desc_x = (conky_window.width - desc_width) / 2 -- Center horizontally
    draw_text(cr, weather_desc, desc_x, conky_window.height - 55, desc_font, desc_size, desc_color)
        -- Scroll logic
        local now = os.clock()
        local delta = now - last_update_time
        last_update_time = now
    
        local font = "Dejavu Serif"
        local font_size = 22
        local color = {1, 0.66, 0, 1} -- Orange color for ticker text
        local text_width = get_text_width(cr, ticker_string, font, font_size)
    
        -- Update scroll offset based on speed and elapsed time
        scroll_offset = scroll_offset + ticker_speed * delta * speed_scale
        if scroll_offset > text_width then
            scroll_offset = 0 -- Reset offset for infinite loop
        end
    
        local start_x = 220 - scroll_offset
        local y = conky_window.height - 30
    
        -- Clip region to constrain ticker drawing area
        cairo_save(cr)
        cairo_rectangle(cr, 40, conky_window.height - 60, 380, 40)
        cairo_clip(cr)
    
        -- Draw ticker with optional fade effect
        if use_fade_effect then
            -- Create a temporary surface for the ticker with fade
            local fade_surface = cairo_surface_create_similar(
                cairo_get_target(cr),
                CAIRO_CONTENT_COLOR_ALPHA,
                380, 40
            )
            local fade_cr = cairo_create(fade_surface)
    
            -- Draw ticker text on the temporary surface
            cairo_save(fade_cr)
            cairo_rectangle(fade_cr, 0, 0, 380, 40)
            cairo_clip(fade_cr)
            draw_text(fade_cr, ticker_string, -scroll_offset, 30, font, font_size, color)
            draw_text(fade_cr, ticker_string, -scroll_offset + text_width, 30, font, font_size, color)
            cairo_restore(fade_cr)
    
            -- Apply fade effect using a linear gradient
            local gradient = cairo_pattern_create_linear(0, 0, 380, 0)
            cairo_pattern_add_color_stop_rgba(gradient, 0.0, 0, 0, 0, 0) -- Transparent at left
            cairo_pattern_add_color_stop_rgba(gradient, 0.2, 0, 0, 0, 1) -- Fully opaque
            cairo_pattern_add_color_stop_rgba(gradient, 0.8, 0, 0, 0, 1) -- Fully opaque
            cairo_pattern_add_color_stop_rgba(gradient, 1.0, 0, 0, 0, 0) -- Transparent at right
    
            cairo_set_source(fade_cr, gradient)
            cairo_set_operator(fade_cr, CAIRO_OPERATOR_DEST_IN) -- Keep only where gradient is opaque
            cairo_paint(fade_cr)
    
            -- Draw the faded ticker back onto the main surface
            cairo_save(cr)
            cairo_set_source_surface(cr, fade_surface, 40, conky_window.height - 60)
            cairo_paint(cr)
            cairo_restore(cr)
    
            -- Clean up temporary resources
            cairo_destroy(fade_cr)
            cairo_surface_destroy(fade_surface)
            cairo_pattern_destroy(gradient)
        else
            -- Draw ticker without fade effect
            draw_text(cr, ticker_string, start_x, y, font, font_size, color)
            draw_text(cr, ticker_string, start_x + text_width, y, font, font_size, color)
        end
    
        -- Restore clip region
        cairo_restore(cr)
    
        -- Clean up main Cairo resources
        cairo_destroy(cr)
        cairo_surface_destroy(cs)
    end
    
    -- Entry point for Conky
    function conky_main()
        conky_draw_weather()
    end