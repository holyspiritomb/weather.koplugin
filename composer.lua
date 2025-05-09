local logger = require('logger')
local _ = require('gettext')

local Composer = {
   temp_scale = "C",
   clock_style = "12",
   speed_units = "kph",
   pressure_units = "mb",
   precip_units = "mm",
   distance_units = "km"
}

function Composer:new(o)
   o = o or {}
   self.__index = self
   setmetatable(o, self)
   return o
end

function Composer:setTempScale(temp_scale)
   self.temp_scale = temp_scale
end

function Composer:setSpeedUnits(speed_units)
   self.speed_units = speed_units
end

function Composer:setPressureUnits(pressure_units)
   self.pressure_units = pressure_units
end

function Composer:setPrecipUnits(precip_units)
   self.precip_units = precip_units
end

function Composer:setDistanceUnits(distance_units)
   self.distance_units = distance_units
end

function Composer:setClockStyle(clock_style)
   self.clock_style = clock_style
end
--
-- Takes data.current
--
-- @returns array
--
function Composer:createCurrentForecast(data)
   local view_content = {}

   local condition = data.condition.text
   local humidity = data.humidity .. "%"
   local feelslike
   local current_temp
   local dewpoint

   if(string.find(self.temp_scale, "C")) then
      feelslike = data.feelslike_c .. " °C"
      current_temp = data.temp_c .. " °C"
      dewpoint = data.dewpoint_c .. " °C"
   else
      feelslike = data.feelslike_f .. " °F"
      current_temp = data.temp_f .. " °F"
      dewpoint = data.dewpoint_f .. " °F"
   end

   view_content = {
      {
         "Current temperature ", current_temp
      },
      {
         "Current humidity ", humidity
      },
      {
         "Current dew point ", dewpoint
      },
      {
         "Currently feels like ", feelslike
      },
      {
         "Current condition", condition
      },
      "---"
   }

   return view_content
end
--
-- Takes data.forecast.forecastday
--
function Composer:createForecastFromDay(data)
   local view_content = {}
   -- The values I'm interested in seeing
   local date = data.date
   local condition = data.day.condition.text
   local avg_temp
   local max_temp
   local min_temp
   local uv = data.day.uv
   local moon_phase = data.astro.moon_phase .. ", " .. data.astro.moon_illumination .. "%"
   local moon_rise = data.astro.moonrise
   local moon_set = data.astro.moonset
   local sunrise = data.astro.sunrise
   local sunset = data.astro.sunset

   if(string.find(self.temp_scale, "C")) then
      avg_temp = data.day.avgtemp_c .. " °C"
      max_temp = data.day.maxtemp_c .. " °C"
      min_temp = data.day.mintemp_c .. " °C"
   else
      avg_temp = data.day.avgtemp_f .. " °F"
      max_temp = data.day.maxtemp_f .. " °F"
      min_temp = data.day.mintemp_f .. " °F"
   end

   -- Set and order the data
   view_content =
      {
         {
            "High of", max_temp
         },
         {
            "Low of", min_temp
         },
         {
            "Average temp.", avg_temp
         },
         {
            "Condition", condition
         },
         "---",
         {
            "Moonrise", moon_rise
         },
         {
            "Moonset", moon_set
         },
         {
            "Moon phase", moon_phase
         },
         "---",
         {
            "Sunrise", sunrise
         },
         {
            "Sunset", sunset
         },
         "---"
      }

   return view_content

end
---
---
---
function Composer:hourlyView(data, callback)
   local view_content = {}
   local hourly_forecast = data

   -- I'm starting the view at 7AM, because no reasonable person should be
   -- up before this time... Kidding! I'm starting at 7AM because *most*
   -- reasonable people are not up before this time :P
   for i = 7, 20,1 do
      local cell
      local time

      if(string.find(self.temp_scale, "C")) then
         cell = hourly_forecast[i+1].temp_c .. "°C, "
      else
         cell = hourly_forecast[i+1].temp_f .. "°F, "
      end

      if(string.find(self.clock_style, "12")) then
         local meridiem
         local hour = i
         if(hour <= 12) then
            meridiem = "AM"
         else
            meridiem = "PM"
            hour = hour - 12
         end
         time = hour .. ":00 " .. meridiem
      else
         time = i .. ":00"
      end

      table.insert(
         view_content,
         {
            _(time),
            cell .. hourly_forecast[i+1].condition.text,
            callback = function()
               callback(hourly_forecast[i+1])
            end
         }
      )

      table.insert(
         view_content,
         "---"
      )
   end

   return view_content
end

function Composer:forecastForHour(data)
   local view_content = {}

   local feelslike
   local windchill
   local heatindex
   local dewpoint
   local temp
   local precip
   local wind
   local gust
   local pressure
   local vis

   local humidity = data.humidity .. "%"
   local time = data.time
   local condition = data.condition.text
   local uv = data.uv
   local cloud = data.cloud .. "%"

   if(string.find(self.temp_scale,"C")) then
      feelslike = data.feelslike_c .. "°C"
      windchill = data.windchill_c .. "°C"
      heatindex = data.heatindex_c .. "°C"
      dewpoint = data.dewpoint_c .. "°C"
      temp = data.temp_c .. "°C"
   else
      feelslike = data.feelslike_f .. "°F"
      windchill = data.windchill_f .. "°F"
      heatindex = data.heatindex_f .. "°F"
      dewpoint = data.dewpoint_f .. "°F"
      temp = data.temp_f .. "°F"
   end

   if(string.find(self.speed_units,"kph")) then
     wind = data.wind_kph .. " kph " .. data.wind_dir
     gust = data.gust_kph .. " kph"
   else
     wind = data.wind_mph  .. " mph " .. data.wind_dir
     gust = data.gust_mph  .. " mph"
   end

   if(string.find(self.pressure_units,"mb")) then
     pressure = data.pressure_mb .. " mb"
   else
     pressure = data.pressure_in .. " in"
   end

   if(string.find(self.distance_units,"km")) then
     vis = data.vis_km .. " km"
   else
     vis = data.vis_miles .. " mi"
   end

   if(string.find(self.precip_units, "mm")) then
     precip = data.precip_mm .. " mm"
   else
     precip = data.precip_in .. " in"
   end

   view_content =
      {
         {
            "Time", time
         },
         {
            "Temperature", temp
         },
         {
            "Feels like", feelslike
         },
         {
            "Condition", condition
         },
         "---",
         {
            "Precipitation", precip
         },
         {
            "Visibility", vis
         },
         {
            "Wind", wind
         },
         {
            "Gusts", gust
         },
         {
            "Humidity", humidity
         },
         {
            "Dewpoint", dewpoint
         },
         "---",
         {
            "Heat Index", heatindex
         },
         {
            "Wind chill", windchill
         },
         "---",
         {
            "Cloud cover", cloud
         },
         {
            "UV", uv
         }
      }

   return view_content
end
--
--
--
function Composer:createWeeklyForecast(data, callback)
   local view_content = {}

   local index = 0

   for _, r in ipairs(data.forecast.forecastday) do
      local date = r.date
      local condition = r.day.condition.text
      local avg_temp
      local max_temp
      local min_temp

      if(string.find(self.temp_scale,"C")) then
        min_temp = r.day.mintemp_c .. "°C"
        max_temp = r.day.maxtemp_c .. "°C"
        avg_temp = r.day.avgtemp_c .. "°C"
      else
        min_temp = r.day.mintemp_f .. "°F"
        max_temp = r.day.maxtemp_f .. "°F"
        avg_temp = r.day.avgtemp_f .. "°F"
      end

      -- @todo: Figure out why os returns the wrong date!
      -- local day = os.date("%A", r.date_epoch)

      -- Add some extra nibbles to the variable that is
      -- passed back to the callback
      if index == 0 then
         r.current = data.current
      end

      local content = {
         {
            date, condition
         },
         {
            "", "Average: " .. avg_temp
         },
         {
            "", "High: " .. max_temp .. ", Low: " .. min_temp
         },
         {
            "",
            "Click for full forecast",
            callback = function()
               -- Prepare callback for hour view
               r.location = data.location
               callback(r)
            end
         },
         "---"
      }

      view_content = Composer:flattenArray(view_content, content)

      index = index + 1
   end

   return view_content
end
--
-- KeyValuePage doesn't like to get a table with sub tables.
-- This function flattens an array, moving all nested tables
-- up the food chain, so to speak
--
function Composer:flattenArray(base_array, source_array)
   for key, value in pairs(source_array) do
      if value[2] == nil then
         -- If the value is empty, then it's probably supposed to be a line
         table.insert(
            base_array,
            "---"
         )
      else
         if value["callback"] then
            table.insert(
               base_array,
               {
                  value[1], value[2], callback = value["callback"]
               }
            )
         else
            table.insert(
               base_array,
               {
                  value[1], value[2]
               }
            )
         end
      end
   end
   return base_array
end



return Composer
