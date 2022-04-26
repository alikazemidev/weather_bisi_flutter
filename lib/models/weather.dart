class Weather {
  var cityName;
  var lat;
  var long;
  var main;
  var description;
  var temp;
  var tempMin;
  var tempMax;
  int? humidity;
  var sunset;
  var sunrise;
  var country;
  var windSpeed;
  var dateTime;
  var pressure;

  Weather({
    this.temp,
    this.cityName,
    this.lat,
    this.long,
    this.main,
    this.description,
    this.tempMin,
    this.tempMax,
    this.humidity,
    this.sunset,
    this.sunrise,
    this.country,
    this.windSpeed,
    this.dateTime,
    this.pressure,
  });
}
