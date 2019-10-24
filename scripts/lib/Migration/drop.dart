import 'dart:async';
import 'package:blueframe/database/databaseHandler.dart';
import 'Migration.dart';

class Drop implements Migrateable {
	Drop(this.connection, this.table);

	DatabaseManager connection;

	String table;

	@override
	Future<bool> execute() async {
		try {
			if (table == '') {
				throw Exception("no table provided");
			}
			await connection.rawQuery("DROP TABLE `$table`;");
			return true;
		} catch (e) {
			print(e);
			return false;
		}
	}

	@override
	Returnable<String> exportQuery() {
		if (table == '')
			return Returnable("No table provided", false);

		return Returnable("DROP TABLE `$table`;", true);
	}
}
