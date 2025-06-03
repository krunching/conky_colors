# conky-weather-lua

A weather widget for Conky, written in Lua. (old widget in the [Releases](https://github.com/wim66/conky-weather-lua/releases) page)

## Features

- Displays current weather conditions
- Customizable via `settings.lua`

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/wim66/conky-weather-lua.git
   ```

2. Navigate to the project directory:
   ```bash
   cd conky-weather-lua
   ```

3. Edit the `settings.lua` file to match your preferences.

## Usage

-   Start Conky with the provided start.sh:
```bash
sh start.sh
```

## Configuration

Adjust the following settings in `settings.lua`:

- these settings can be changed with the WeatherSettingsUpdater app
- `API_KEY`: Your OpenWeatherMap API key
- `CITY_ID`: [Find it here](https://openweathermap.org/.)
- `UNITS`: Temperature unit for the weather data
- `LANG`: Language for weather descriptions and labels
-
- these settings can be changed with the ConkyColorUpdater app
- `border_COLOR`
- `bg_COLOR`
-
- The corners of the background can be adjusted in background.lua

License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/wim66/conky-weather-lua/blob/main/LICENSE) file for details.

---

<p align="center"> <img src="https://github.com/wim66/conky-weather-lua/blob/main/previews/preview1.png" alt="image"></p>

<p align="center"> <img src="https://github.com/wim66/conky-weather-lua/blob/main/previews/preview2.gif" alt="image"></p>

<p align="center"> <img src="https://github.com/wim66/conky-weather-lua/blob/main/Change-settings.png" alt="image"></p>

