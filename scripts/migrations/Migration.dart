import 'dart:collection';
import 'package:mysql1/mysql1.dart';
export 'package:mysql1/mysql1.dart';

class Migration {
	Migration(this.connection);
	MySqlConnection connection;

	Alter alter(String target) => Alter(connection,target);

	Update update(String target) => Update(connection,target);

	Insert insert(String target) => Insert(connection,target);

	Delete delete(String target) => Delete(connection,target);

	Create create(String target) => Create(connection,target);

}

class Column {
	Column({this.columnName, this.columnType, this.columnLength, this.notNull, this.primaryKey, this.autoIncrement});

	String columnName;
	String columnType;
	int columnLength;
	bool notNull = true;
	bool primaryKey = false;
	bool autoIncrement = false;

	@override
	String toString() => "$columnName $columnType($columnLength) ${notNull ? "not null" : ""} ${primaryKey ? "primary key" : ""} ${autoIncrement ? "AUTO_INCREMENT" : ""}";
}

class Alter implements Migrateable {
	Alter(this.connection,this.table);
	MySqlConnection connection;
	String table;

  @override
  bool execute() {
    // TODO: implement execute
    return false;
  }

  @override
  Returnable<String> exportQuery() {
    // TODO: implement exportQuery
    return null;
  }
}

class Update implements Migrateable {
	Update(this.connection,this.table);
	MySqlConnection connection;

	String table;

  @override
  bool execute() {
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
	Insert(this.connection,this.table);
	MySqlConnection connection;

	String table;

  @override
  bool execute() {
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
	Delete(this.connection,this.table);
	MySqlConnection connection;

	String table;

  @override
  bool execute() {
    // TODO: implement execute
    return false;
  }

  @override
  Returnable<String> exportQuery() {
    // TODO: implement exportQuery
    return null;
  }
}

class Create implements Migrateable{
	Create(this.connection,this.table);
	MySqlConnection connection;

	String table;
	List<Column> columns = <Column>[];

	Create column(Column column) {
	  columns.add(column);
	  return this;
	}

  @override
  bool execute() {
    try {
    	connection.query("CREATE TABLE `$table` (${columns.join(',')});");
//	     if nothing goes wrong, will rtn true
	    return true;
    } catch (E) {
	    return false;
    }
  }

  @override
  Returnable<String> exportQuery() {
  	try {
  		if(columns.isEmpty)
  			throw Exception('No columns specified');

	    return Returnable(
		    "CREATE TABLE `$table` (${columns.join(',')});",
		    true
	    );

    } catch (e) {
		return Returnable(e.toString(),false);
    }
  }
}

abstract class Migrateable {
	bool execute();
	Returnable<String> exportQuery();
}

class Returnable<A> {
// ignore: avoid_positional_boolean_parameters
	Returnable(this.value,this.success);
	A value;
	bool success;
}