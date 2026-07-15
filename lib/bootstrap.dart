import 'package:ptm/core/database/database_helper.dart';

Future<void> bootStrap() async {
  await DatabaseHelper().database;
}