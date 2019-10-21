import 'package:blueframe/blueframe.dart';
import 'package:blueframe/template/template.dart';
import 'RouteDelegator.dart';
import 'package:blueframe/support/cookies.dart';

class HomeRoute implements Route {
	HomeRoute(this.request);

	Request request;

	@override
	Future<Response> getResponse() async {
		final Map<String, String> map = {
			"BODY": "<p>Hello there</p>"
		};

//		print(request.raw);
		final Template template = Template(
			template: "home.dhml",
			replacers: map,
			basePath: "views"
		)
			..render();

		var r = htmlResponse(template.content);

		for (var cookie in request.raw.cookies) {
			print(cookie.name);
			print(cookie.value);
		}

		Map<String, String> cookies = {

		};

		r = Cookies.setCookies(r, cookies);

		return r;
	}
}
