# weather.koplugin

weather.koplugin is a weather forecast plugin for [KOReader](https://koreader.rocks) on eInk devices.

## About
Weather information is provided by [WeatherAPI](https://www.weatherapi.com).

### Features
- Forecast for current day
- Forecast for next 2 days
- Hourly forecast for current day
- Temperatures in Celsius or Fahrenheit (working)
- 24- or 12-hour clock

Unit customization available:
- Atmospheric pressure in millibars or inches
- Wind speed in kph or mph
- Visibility in km or miles
- Precipitation amount in mm or inches

### Customization

A settings file naned `weather.lua` is created on first run under `.adds/koreader/settings`. Settings can be altered manually in this file if desired.

### Screenshots

<img src="https://user-images.githubusercontent.com/82218266/134824984-687ffe38-e9aa-491f-8c2c-7c055fc5d10e.png" width="300"/>
<img src="https://user-images.githubusercontent.com/82218266/134824983-390021e9-30de-4f0a-a4ea-d95bcc68f6fa.png" width="300"/>
<img src="https://user-images.githubusercontent.com/82218266/134824982-3e16e8da-fbf2-4d35-b6d5-33ece7d47d67.png" width="300"/>
<img src="https://user-images.githubusercontent.com/82218266/134824980-32d1892b-7b24-45b5-86ba-ef9892fcacb5.png" width="300"/>

### Compatibility

Devices confirmed working:
- Kobo Libra H20 (original dev roygbyte's device)
- Kobo Clara Colour (holyspiritomb's device)

## Installation

### Drag and Drop

Download the latest release and unzip it to your computer and then transfer the folder to your KOReader-powered device, placing it under `.adds/koreader/plugins/weather.koplugin`.

### SSH/SCP

TODO

## Development

I know what you're thinking: "how the heck do I get in on this?" Honestly, it's easier than you think. Lua is a fun and foregiving language with [good learning resources](https://www.lua.org/pil/). Seriously, load up your e-reader with a [Lua language ePub](https://store.feistyduck.com/products/programming-in-lua-fourth-edition-ebook) and soak in the brilliance of this humble language. Then follow the steps below to hack away and help out this aspiring bit of coding history...

Here's how my project directory looks:

```
$ ls /home/me/Development/KOReader/
koreader
weather.koplugin
```

### Download KOReader, install dependencies 

TODO

### Clone repository, create soft link between this plugin folder and KOReader's plugins folder 

```sh
cd koreader/plugins
ln -s ../../weather.koplugin weather.koplugin
```

### Write code, check code, run emulator

Check the code with Luacheck
```sh
cd weather.koplugin
luacheck *
```

Run the emulator
```sh
cd koreader
./kodev run
```

If the emulator doesn't build (and puts up a fuss like "[*] create symlink instead of copying files in development mode"), then clean it out.

```sh
./kodev clean
```

### Deploy to Kobo using SSH/SCP 

Enable the wifi connection on KOReader. Then, launch KOReader's SSH daemon (Settings > Network > SSH server). Set the port to 22 and "login without password". Use SCP to transfer the plugin folder to your device.

Note: Replace the local address below (e.g.: 192.168.2.16) with the one indicated by your device's SSH server.
```sh
scp -r weather.koplugin/ root@192.168.2.16:/mnt/onboard/.adds/koreader/plugins/weather.koplugin/
```

TODO: Create a script that doesn't transfer the git repo.


## TODOs

TODO
