import 'package:json_annotation/json_annotation.dart';

part 'station_info.g.dart';

@JsonSerializable()
class StationInfo {
  final String stationCode;
  final String stationName;
  final String arrivalTime;
  final String departureTime;
  final String? routeNumber;
  final String haltTime;
  final String distance;
  final String dayCount;
  final String stnSerialNumber;
  final String? boardingDisabled;

  StationInfo({
    required this.stationCode,
    required this.stationName,
    required this.arrivalTime,
    required this.departureTime,
    this.routeNumber,
    required this.haltTime,
    required this.distance,
    required this.dayCount,
    required this.stnSerialNumber,
    this.boardingDisabled,
  });

  factory StationInfo.fromJson(Map<String, dynamic> json) =>
      _$StationInfoFromJson(json);

  Map<String, dynamic> toJson() => _$StationInfoToJson(this);
}
