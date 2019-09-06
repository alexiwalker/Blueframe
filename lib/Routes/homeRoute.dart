import 'package:blueframe/blueframe.dart';
import 'package:blueframe/template/template.dart';


import 'RouteDelegator.dart';

class homeRoute extends Route{
	Request request;
	homeRoute(this.request);

  @override
  Future<Response> getResponse() async {
	final Map<String,String> map = {
		"BODY":"<p>Hello there</p>"
	};
  	final Template template = Template(template: "temp1.dtp",replacers: map, basePath: "views");
	template.runDirectives();
	template.runReplacers();
  	return Response.ok(template.getContents())..contentType=ContentType.html;

  }
}
