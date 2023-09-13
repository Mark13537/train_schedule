import 'package:equatable/equatable.dart';

class SearchResultModel {
  List<Vbd>? vbd = List.empty(growable: true);
  var error;

  SearchResultModel({this.vbd, this.error});

  SearchResultModel.fromJson(Map<String, dynamic> json) {
    if (json['vbd'] != null) {
      json['vbd'].forEach((v) {
        vbd!.add(new Vbd.fromJson(v));
      });
    }
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.vbd != null) {
      data['vbd'] = this.vbd!.map((v) => v.toJson()).toList();
    }
    data['error'] = this.error;
    return data;
  }
}

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

  Vbd.fromJson(Map<String, dynamic> json) {
    coachName = json['coachName'];
    berthCode = json['berthCode'];
    cabinCoupe = json['cabinCoupe'];
    cabinCoupeNo = json['cabinCoupeNo'];
    berthNumber = json['berthNumber'];
    from = json['from'];
    to = json['to'];
    splitNo = json['splitNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coachName'] = this.coachName;
    data['berthCode'] = this.berthCode;
    data['cabinCoupe'] = this.cabinCoupe;
    data['cabinCoupeNo'] = this.cabinCoupeNo;
    data['berthNumber'] = this.berthNumber;
    data['from'] = this.from;
    data['to'] = this.to;
    data['splitNo'] = this.splitNo;
    return data;
  }

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
