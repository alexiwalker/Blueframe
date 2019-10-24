import 'package:blueframe/blueframe.dart';
import 'package:blueframe/template/template.dart';
import 'RouteDelegator.dart';

class HomeRoute implements Route {
	HomeRoute(this.request);

	Request request;

	@override
	Future<Response> getResponse() async {
		final Map<String, dynamic> map = {
			"BODY": "<p>Hello there</p>",
//			"CONDB":"true",
			"CONDA":"true"
		};

		final Template template = Template(
			template: "home.dhml",
			replacers: map,
			basePath: "views"
		)
			..render();

		return htmlResponse(template.content);
	}
}
