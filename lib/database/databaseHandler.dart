import 'dart:async';
import "package:sqljocky5/sqljocky.dart";

class DatabaseManager {

	DatabaseManager(ConnectionParams connection) {
		connectionSettings = ConnectionSettings(
			host: connection.host,
			port: connection.port,
			user: connection.user,
			password: connection.pass == '' ? null : connection.pass,
			db: connection.dbname,
		);
	}

	ConnectionSettings connectionSettings;
	MySqlConnection _connection;


	Future<bool> connect() async {
		try {
			_connection = await MySqlConnection.connect(connectionSettings);
		} catch (e) {
			return false;
		}
		return true;
	}

	Future<bool> insertRawDataSuccess(String query) async {
		try {
			await _connection.execute(query);
		} catch (E) {
			return false;
		}
		return true;
	}

	Future<bool> insertPreparedDataBool(String query, List<String> params) async {
		try {
			await _connection.prepared(query, params);
		} catch (E) {
			print(E);
			return false;
		}
		return true;
	}

	Future<StreamedResults> insertPrepared(String query, List<String> params) async {
		final StreamedResults res = await _connection.prepared(query, params);
		return res;
	}

	Future<StreamedResults> queryPrepared(String query, List<String> params) async {
		final StreamedResults res = await _connection.prepared(query, params);
		return res;
	}

	Future<StreamedResults> rawQuery(String query) async {
		final StreamedResults res = await _connection.execute(query);
		return res;
	}
}

class ConnectionParams {

	ConnectionParams({this.host, this.user, this.pass, this.dbname, this.port});

	String host;
	String user;
	String pass;
	String dbname;
	int port;

}
