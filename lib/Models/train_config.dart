import 'package:json_annotation/json_annotation.dart';

part 'train_config.g.dart';

@JsonSerializable()
class TrainConfig {
  final String trainNo;
  final String boardingStation;
  final String remoteStation;
  final String trainSourceStation;
  final String jDate;
  final String cls;
  int chartType;

  TrainConfig({
    required this.trainNo,
    required this.boardingStation,
    required this.remoteStation,
    required this.trainSourceStation,
    required this.jDate,
    required this.cls,
    required this.chartType,
  });

  factory TrainConfig.fromJson(Map<String, dynamic> json) =>
      _$TrainConfigFromJson(json);

  Map<String, dynamic> toJson() => _$TrainConfigToJson(this);
}
