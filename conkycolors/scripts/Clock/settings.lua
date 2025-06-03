-- settings.lua
-- by @wim66
-- April 7 2025

function conky_vars()
    -- ICON_SET: Defines the weather icon set to use.
    -- Available options:
    --   - Dark theme sets: "Dark-dovora", "Dark-modern", "Dark-monochrome", "Dark-openweathermap", "Dark-SagiSan", "Dark-spils-icons"
    --   - Light theme sets: "Light-dovora", "Light-modern", "Light-monochrome", "Light-openweathermap", "Light-spils-icons", "Light-vclouds"
    -- How to change:
    --   - Simply update the value below to one of the available options (e.g., "Light-vclouds").
    --   - Ensure the set exists in your weather-icons directory to avoid errors.
ICON_SET = "Dark-SagiSan"

    -- API_KEY: Your OpenWeatherMap API key.
    -- How to set it up:
    -- 1. Sign up at https://openweathermap.org/ and get your free API key (e.g., "abc123def456").
    -- 2. Add it to your shell configuration file to make it persistent:
    --    a. Open a terminal and check your shell with: echo $SHELL
    --    b. For Bash (/bin/bash), edit ~/.bashrc with: nano ~/.bashrc
    --    c. For Zsh (/bin/zsh), edit ~/.zshrc with: nano ~/.zshrc
    --    d. Add this line at the end: export OWM_API_KEY="your_api_key_here"
    --       Replace "your_api_key_here" with your actual key (e.g., "abc123def456").
    --    e. Save the file (Ctrl+O, Enter in nano; :w in vim) and exit (Ctrl+X in nano; :q in vim).
    --    f. Reload the config with: source ~/.bashrc (or source ~/.zshrc for Zsh).
    -- 3. Verify it works by running: echo $OWM_API_KEY (should output your key).
    -- If the variable is not set, a default/fallback key can be provided below (optional).
API_KEY = os.getenv("OWM_API_KEY") or "1985aeebd389e21870664f009fc29b11"

    -- CITY_ID: The ID of the city for which you want weather data.
    -- How to find it:
    -- 1. Go to https://openweathermap.org/.
    -- 2. Search for your city, e.g., "Amsterdam".
    -- 3. Check the URL in your browser, e.g., https://openweathermap.org/city/2759794.
    -- 4. The number at the end (2759794 for Amsterdam) is your CITY_ID.
CITY_ID = "2877439"

    -- UNITS: Temperature unit for the weather data.
    -- Options:
    --   "metric"   - Celsius (°C)
    --   "imperial" - Fahrenheit (°F)
UNITS = "metric"

    -- LANG: Language for weather descriptions and labels.
    -- Options: "en" (English), "nl" (Dutch), "fr" (French), "es" (Spanish), "de" (German), etc.
    -- Full list for weather descriptions: https://openweathermap.org/current#multi
    -- Note: This also sets labels in display.lua (e.g., "Humidity", "Wind Speed").
    -- To add or modify translations:
    -- 1. Open display.lua in a text editor (e.g., nano display.lua).
    -- 2. Find the get_labels function.
    -- 3. Add a new elseif block for your language, e.g.:
    --    elseif lang == "de" then
    --        return { humidity = "Luftfeuchtigkeit", wind_speed = "Windgeschwindigkeit" }
    -- 4. Replace "de" with your language code and update the translations.
    -- 5. Save and reload Conky to apply changes.
    -- Current supported languages: "nl", "en", "fr", "es". Fallback is English.
LANG = "nl"

border_COLOR = "0,0x0000ff,1.00,0.5,0xafcaff,1.00,1,0x0000ff,1.00"
bg_COLOR = "0x1d1e28,0.75"

end
