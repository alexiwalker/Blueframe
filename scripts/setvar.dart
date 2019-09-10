import 'package:args/args.dart';

void main(List<String> args){
	var parser = ArgParser();
	parser.addOption("mode", abbr: 'm');
	parser.addOption("val", abbr: 'v');
	parser.addOption("key", abbr: 'k');
	var results = parser.parse(args);

	//todo: finish this lol

}