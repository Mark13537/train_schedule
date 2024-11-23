import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vbd.g.dart';

@JsonSerializable()
class Vbd extends Equatable {
  String? coachName;
  String? berthCode;
  String? cabinCoupe;
  String? cabinCoupeNo;
  int? berthNumber;
  String? from;
  String? to;
  int? splitNo;

  Vbd(
      {this.coachName,
      this.berthCode,
      this.cabinCoupe,
      this.cabinCoupeNo,
      this.berthNumber,
      this.from,
      this.to,
      this.splitNo});

  factory Vbd.fromJson(Map<String, dynamic> json) => _$VbdFromJson(json);

  Map<String, dynamic> toJson() => _$VbdToJson(this);

  @override
  List<Object?> get props => [
        coachName,
        berthCode,
        cabinCoupe,
        cabinCoupeNo,
        berthNumber,
        from,
        to,
        splitNo
      ];
}
