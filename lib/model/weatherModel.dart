// class WeatherModel{
//   final temp;
//   final pressure;
//   final humidity;
//   final temp_max;
//   final temp_min;

//   double get getTemp => temp - 275.5;
//   double get getMaxTemp => temp - 275.5;
//   double get getMinTemp => temp - 275.5;

//   WeatherModel(this.temp, this.humidity, this.pressure, this.temp_max, this.temp_min);

//   factory WeatherModel.fromJson(Map<String, dynamic> json){
//     return WeatherModel(
//       json["temp"],
//       json["pressure"],
//       json["humidity"],
//       json["temp_max"],
//       json["temp_min"],
//     );
//   }

// }

class Request
{
    final String type;
    final String query;
    final String language;
    final String unit;

    Request({
      this.type,
      this.query,
      this.language,
      this.unit
    });

    factory Request.fromJson(Map<String, dynamic> json){
      return Request(
        type: json['type'],
        query: json['query'],
        language: json['language'],
        unit: json['unit'],
      );
    }
}

class Location
{
    final String name;
    final String country;
    final String region;
    final String lat;
    final String lon;
    final String timezone_id;
    final String localtime;
    final int localtime_epoch;
    final String utc_offset;
    
    Location({
      this.name,
      this.country,
      this.region,
      this.lat,
      this.lon,
      this.timezone_id,
      this.localtime,
      this.localtime_epoch,
      this.utc_offset,
    });

    factory Location.fromJson(Map<String, dynamic> json){
      return Location(
        name: json['name'],
        country: json['country'],
        region: json['region'],
        lat: json['lat'],
        lon: json['lon'],
        timezone_id: json['timezone_id'],
        localtime: json['localtime'],
        localtime_epoch: json['localtime_epoch'],
        utc_offset: json['utc_offset'],
      );
    }
}

class Current
{
    final String observation_time ;
    final int temperature ;
    final int weather_code ;
    final List<String> weather_icons ;
    final List<String> weather_descriptions ;
    final int wind_speed ;
    final int wind_degree ;
    final String wind_dir ;
    final int pressure ;
    final int precip ;
    final int humidity ;
    final int cloudcover ;
    final int feelslike ;
    final int uv_index ;
    final int visibility ;
    final String is_day ;

    Current({
      this.observation_time ,
      this.temperature ,
      this.weather_code ,
      this.weather_icons ,
      this.weather_descriptions ,
      this.wind_speed ,
      this.wind_degree ,
      this.wind_dir ,
      this.pressure ,
      this.precip ,
      this.humidity ,
      this.cloudcover ,
      this.feelslike ,
      this.uv_index ,
      this.visibility ,
      this.is_day ,
    });

    factory Current.fromJson(Map<String, dynamic> json){
    return Current(
        // observation_time: json['observation_time'],
        temperature: json['temperature'],
        // weather_code: json['weather_code'],
        // weather_icons: json['weather_icons'],
        // weather_descriptions: json['weather_descriptions'],
        // wind_speed: json['wind_speed'],
        // wind_degree: json['wind_degree'],
        // wind_dir: json['wind_dir'],
        // pressure: json['pressure'],
        // precip: json['precip'],
        // humidity: json['humidity'],
        // cloudcover: json['cloudcover'],
        // feelslike: json['feelslike'],
        // uv_index: json['uv_index'],
        // visibility: json['visibility'],
        // is_day: json['is_day'],
      );
}
}

// class weatherAPI
// {
//     final Request request ;
//     final Location location ;
//     final Current current ;
// }
