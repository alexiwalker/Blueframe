import 'dart:async';
import 'package:blueframe/database/databaseHandler.dart';

export 'package:blueframe/database/databaseHandler.dart';

class Migration {
	Migration(this.connection);

	DatabaseManager connection;

	Alter alter(String target) => Alter(connection, target);

	Update update(String target) => Update(connection, target);

	Insert insert(String target) => Insert(connection, target);

	Delete delete(String target) => Delete(connection, target);

	Create create(String target) => Create(connection, target);

}

class BatchMigrate {
	BatchMigrate(this.migrations,this.dbConnection);
	List<Migrateable> migrations;
	DatabaseManager dbConnection;

	void batchExecute() async {
		await dbConnection.connect();
		await dbConnection.rawQuery("BEGIN TRANSACTION;");
		try {
			for (Migrateable migration in migrations)
				await migration.execute();
		} catch (E) {
			await dbConnection.rawQuery("ROLLBACK;");
		}
		await dbConnection.rawQuery("COMMIT;");
	}
}

class Column {
	Column({this.columnName, this.columnType, this.columnLength, this.notNull, this.primaryKey, this.autoIncrement}){
		autoIncrement = autoIncrement??false;
		primaryKey = primaryKey??false;
		notNull = notNull??false;
	}

	String columnName;
	String columnType;
	int columnLength;
	bool notNull = true;
	bool primaryKey = false;
	bool autoIncrement = false;

	@override
	String toString() => "$columnName $columnType($columnLength)${notNull ? " not null" : ""}${primaryKey ? " primary key" : ""}${autoIncrement ? " AUTO_INCREMENT" : ""}";
}

class Alter {

	Alter(this.connection, this.table);

	DatabaseManager connection;

	String table;
	String columnName;
	Column column;

	DropColumn dropColumn(String column) => DropColumn(table, column,connection);

	AddColumn addColumn(Column column) => AddColumn(table, column,connection);

	AlterColumn alterColumn(Column column) => AlterColumn(table, column,connection);

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
		} catch (e){
			return false;
		}
	}

	@override
	Returnable<String> exportQuery() {
		if (table == '' || column == '')
			return Returnable('invalid column or table name', false);

		return Returnable("ALTER TABLE `$table` DROP COLUMN `$column;",true);
	}
}

class AddColumn implements Migrateable {

	AddColumn(this.table, this.column,this.connection);

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
		} catch (e){
			return false;
		}
	}

	@override
	Returnable<String> exportQuery() {
		if(table == '' || column == null)
			return Returnable('invalid table name or column',false);

		return Returnable("ALTER TABLE `$table` ADD COLUMN `$column;",true);
	}

}

class AlterColumn implements Migrateable {

	AlterColumn(this.table, this.column,this.connection);

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

class Insert implements Migrateable {
	Insert(this.connection, this.table);

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

class Delete implements Migrateable {
	Delete(this.connection, this.table);

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
		} catch (E) {
			print(E);
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

abstract class Migrateable {
	Future<bool> execute();
	Returnable<String> exportQuery();
}

class Returnable<A> {
// ignore: avoid_positional_boolean_parameters
	Returnable(this.value, this.success);

	A value;
	bool success;
}