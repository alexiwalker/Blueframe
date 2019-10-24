import "package:blueframe/blueframe.dart";
import 'package:blueframe/template/template.dart';

//this just exists so that I know every route can give me a response
abstract class Route {
	Future<Response> getResponse();
}

class BadRoute implements Route {

	BadRoute(this.request);

	static Route init(Request request) => BadRoute(request);

	Request request;

	@override
	Future<Response> getResponse() async => Response.notFound();
}

class DeniedRoute implements Route {

	DeniedRoute(this.request);

	static Route init(Request request) => DeniedRoute(request);

	Request request;

	@override
	Future<Response> getResponse() async => Response.forbidden();
}

Response htmlResponse(String content) =>
	Response.ok(content)
		..contentType = ContentType.html;