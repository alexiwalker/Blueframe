import 'migrations/Migration.dart';


void main(List<String> args) async {
	//offload this to a .env file later and read it in
	ConnectionParams conn = ConnectionParams(
		dbname: "blueframe",
		host: "localhost",
		pass: "",
		port: 3306,
		user: "root"
	);

	DatabaseManager connection =  DatabaseManager(conn);
	await connection.connect();

	Migrateable migration = Migration(connection).create("test")
		.column(
		Column(
			columnLength: 12,
			columnName: "testa",
			columnType: "text",
			notNull: true,
			primaryKey: false,autoIncrement: false
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
		.value
	);

	await migration.execute();

//	migration = Migration(conn)
//		.alter("test")
//		.dropColumn('testa');
//	print(migration
//		.exportQuery()
//		.value
//	);
//
//	migration = Migration(conn)
//		.alter("test")
//		.addColumn(
//		Column(
//			columnLength: 12,
//			columnName: "abc",
//			notNull: true,
//			columnType: 'text',
//			autoIncrement: false,
//			primaryKey: false
//		)
//	);
//
//
//	print(migration.exportQuery().value);
}