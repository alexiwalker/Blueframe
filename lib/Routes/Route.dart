import "package:blueframe/blueframe.dart";

//this just exists so that I know every route can give me a response
abstract class Route {
	Future<Response> getResponse();
}

class badRoute implements Route {
	Request request;

	badRoute(this.request);

	@override
	Future<Response> getResponse() async {
		return Response.notFound();
	}
}

class deniedRoute implements Route {
	Request request;

	deniedRoute(this.request);

	@override
	Future<Response> getResponse() async  {
		return Response.forbidden();
	}
}


Response htmlResponse(String content){
	final Response resp = Response.ok(content);
	resp.contentType=ContentType.html;
	return resp;
}