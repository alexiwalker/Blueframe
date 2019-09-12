import 'migrations/Migration.dart';

void main(List<String> args) async {
	final conn = await MySqlConnection.connect(
		ConnectionSettings(
			host: 'localhost',
			port: 3306,
			user: 'root',
			db: 'testdb',
		)
	);

	Create migration = Migration(conn).create("test")
		.column(
		Column(
			columnLength: 12,
			columnName: "testa",
			columnType: "text",
			notNull: true,
			primaryKey: false
		)
	)
		.column(
		Column(
			primaryKey: true,
			columnType: "int",
			notNull: true,
			columnName: "mainid",
			columnLength: 11
		)
	);

	print(migration
		.exportQuery()
		.value);

	print(migration.execute());
}