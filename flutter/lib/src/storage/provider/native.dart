import '../../utils/connection.dart';
import '../account/db.dart';

UserAccountDatabase $userAccount(String databaseName) {
  final _dbConnectionProvider = DatabaseConnectionProvider(databaseName);

  return UserAccountDatabase.connect(_dbConnectionProvider.fromBackground);
}
