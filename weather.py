import json
import urllib

apikey='insertvaluehere' >> get from openweathermap!
city_id='######' >> get from openweathermap!
grab_url='http://api.openweathermap.org/data/2.5/weather?id='+city_id+'&units=metric&appid='+apikey
url=urllib.urlopen(grab_url)
data=json.load(url)
url.close()

conditions = data["weather"][0]["description"]
temp_n = data["main"]["temp"]
humidity = data["main"]["humidity"]
wind = data["wind"]["speed"]
#add more if you want...

print "Current conditions are... " + conditions
print "It's feeling like " + str(temp_n) + "c"
print "Winds are blowing at " + str(wind) + "kmph"
print "With humidity at " + str(humidity) + "%"
