import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptm/core/database/database_helper.dart';

final databaseHelperProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper();
});
