import 'dart:async';
import 'package:blueframe/database/databaseHandler.dart';
import 'Migration.dart';

class Alter {

	Alter(this.connection, this.table);

	DatabaseManager connection;

	String table;
	String columnName;
	Column column;

	DropColumn dropColumn(String column) => DropColumn(table, column, connection);

	AddColumn addColumn(Column column) => AddColumn(table, column, connection);

	AlterColumn alterColumn(Column column) => AlterColumn(table, column, connection);

}

class DropColumn implements Migrateable {
	DropColumn(this.table, this.column, this.connection);

	String table;
	String column;
	DatabaseManager connection;

	@override
	Future<bool> execute() async {
		try {
			await connection.rawQuery(
				"ALTER TABLE `$table` DROP COLUMN `$column;"
			);
			return true;
		} catch (e) {
			return false;
		}
	}

	@override
	Returnable<String> exportQuery() {
		if (table == '' || column == '')
			return Returnable('invalid column or table name', false);

		return Returnable("ALTER TABLE `$table` DROP COLUMN `$column;", true);
	}
}

class AddColumn implements Migrateable {

	AddColumn(this.table, this.column, this.connection);

	String table;
	Column column;
	DatabaseManager connection;

	@override
	Future<bool> execute() async {
		try {
			await connection.rawQuery(
				"ALTER TABLE `$table` ADD COLUMN `$column;"
			);
			return true;
		} catch (e) {
			return false;
		}
	}

	@override
	Returnable<String> exportQuery() {
		if (table == '' || column == null)
			return Returnable('invalid table name or column', false);

		return Returnable("ALTER TABLE `$table` ADD COLUMN `$column;", true);
	}

}

class AlterColumn implements Migrateable {

	AlterColumn(this.table, this.column, this.connection);

	String table;
	Column column;
	DatabaseManager connection;


	@override
	Future<bool> execute() async {
		// TODO: implement execute
		return null;
	}

	@override
	Returnable<String> exportQuery() {
		// TODO: implement exportQuery
		return null;
	}

}
