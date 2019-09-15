import 'dart:async';
import 'package:blueframe/database/databaseHandler.dart';
import 'Migration.dart';

class Create implements Migrateable {
	Create(this.connection, this.table);

	DatabaseManager connection;

	String table;
	List<Column> columns = <Column>[];

	Create column(Column column) {
		columns.add(column);
		return this;
	}

	@override
	Future<bool> execute() async {
		try {
			await connection.rawQuery("CREATE TABLE `$table` (${columns.join(', ')});");
			return true;
		} catch (e) {
			print(e);
			return false;
		}
	}

	@override
	Returnable<String> exportQuery() {
		try {
			if (columns.isEmpty)
				throw Exception('No columns specified');

			return Returnable(
				"CREATE TABLE `$table` (${columns.join(',')});",
				true
			);
		} catch (e) {
			return Returnable(e.toString(), false);
		}
	}
}
