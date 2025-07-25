// helper;
List<String> validateRequiredParams<T>({
  required T model,
  required List<String> params,
}) {
  final json = (model as dynamic).toJson() as Map<String, dynamic>;

  List<String> missing = [];

  for (var key in params) {
    final value = json[key];
    if (value == null || (value is String && value.trim().isEmpty)) {
      missing.add(key);
    }
  }

  return missing;
}

List<String> validateRequiredParamsFromMap({
  required Map<String, dynamic> data,
  required List<String> params,
}) {
  List<String> missing = [];

  for (var key in params) {
    final value = data[key];
    if (value == null || (value is String && value.trim().isEmpty)) {
      missing.add(key);
    }
  }

  return missing;
}

