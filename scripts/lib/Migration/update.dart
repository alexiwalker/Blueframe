import 'dart:async';
import 'package:blueframe/database/databaseHandler.dart';
import 'Migration.dart';


class Update implements Migrateable {
	Update(this.connection, this.table);

	DatabaseManager connection;

	String table;

	@override
	Future<bool> execute() async {
		// TODO: implement execute
		return false;
	}

	@override
	Returnable<String> exportQuery() {
		// TODO: implement exportQuery
		return null;
	}
}
