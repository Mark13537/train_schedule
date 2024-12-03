import 'package:json_annotation/json_annotation.dart';

import 'station_info.dart';

part 'train_enquiry.g.dart';

@JsonSerializable()
class TrainEnquiry {
  final String trainNumber;
  final String trainName;
  final String stationFrom;
  final String stationTo;
  final String? trainOwner;
  final String? trainRunsOnMon;
  final String? trainRunsOnTue;
  final String? trainRunsOnWed;
  final String? trainRunsOnThu;
  final String? trainRunsOnFri;
  final String? trainRunsOnSat;
  final String? trainRunsOnSun;
  final String? timeStamp;
  final String? duration;
  final List<StationInfo> stationList;

  TrainEnquiry({
    required this.trainNumber,
    required this.trainName,
    required this.stationFrom,
    required this.stationTo,
    this.trainOwner,
    this.trainRunsOnMon,
    this.trainRunsOnTue,
    this.trainRunsOnWed,
    this.trainRunsOnThu,
    this.trainRunsOnFri,
    this.trainRunsOnSat,
    this.trainRunsOnSun,
    this.duration,
    this.timeStamp,
    required this.stationList,
  });

  factory TrainEnquiry.fromJson(Map<String, dynamic> json) =>
      _$TrainEnquiryFromJson(json);

  Map<String, dynamic> toJson() => _$TrainEnquiryToJson(this);
}
