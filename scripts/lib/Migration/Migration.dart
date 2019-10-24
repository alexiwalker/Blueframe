import 'dart:async';
import 'package:blueframe/database/databaseHandler.dart';

import 'alter.dart';
import 'create.dart';
import 'drop.dart';
import 'insert.dart';
import 'update.dart';

export 'package:blueframe/database/databaseHandler.dart';
export 'alter.dart';
export 'create.dart';
export 'drop.dart';
export 'insert.dart';
export 'update.dart';

class Migration {
	Migration(this.connection);

	DatabaseManager connection;

	Alter alter(String target) => Alter(connection, target);

	Update update(String target) => Update(connection, target);

	Insert insert(String target) => Insert(connection, target);

	Drop drop(String target) => Drop(connection, target);

	Create create(String target) => Create(connection, target);

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

class BatchMigrate {
	BatchMigrate(this.migrations, this.dbConnection);

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
	Column({this.columnName, this.columnType, this.columnLength, this.notNull, this.primaryKey, this.autoIncrement}) {
		autoIncrement = autoIncrement ?? false;
		primaryKey = primaryKey ?? false;
		notNull = notNull ?? false;
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
