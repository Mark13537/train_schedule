import 'package:json_annotation/json_annotation.dart';
import 'package:train_schedule/Models/vbd.dart';

part 'search_result.g.dart';

@JsonSerializable()
class SearchResult {
  final List<Vbd>? vbd;
  final dynamic error;

  SearchResult({
    this.vbd,
    this.error,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResultToJson(this);
}
