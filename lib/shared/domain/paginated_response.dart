import 'package:flutter/foundation.dart';

class PaginatedResponse<T> {
  final List<T> data;
  final bool hasMoreData;
  PaginatedResponse({
    required this.data,
    required this.hasMoreData,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PaginatedResponse<T> && listEquals(other.data, data) && other.hasMoreData == hasMoreData;
  }

  @override
  int get hashCode => data.hashCode ^ hasMoreData.hashCode;
}
