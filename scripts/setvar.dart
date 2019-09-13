import 'package:args/args.dart';

import 'package:blueframe/blueframe.dart';

void main(List<String> args){
	ArgResults results;
	try {
		var parser = ArgParser();
		parser.addOption("mode", abbr: 'm');
		parser.addOption("val", abbr: 'v');
		parser.addOption("key", abbr: 'k');
		results = parser.parse(args);
	}  catch (e) {
		print('error: invalid args');
		exit(-1);
	}
	print(results['key']);
	print(results['val']);

	//todo: finish this lol

}