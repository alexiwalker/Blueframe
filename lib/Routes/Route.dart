import "package:blueframe/blueframe.dart";

//this just exists so that I know every route can give me a response
abstract class Route {
	Future<Response> getResponse();
}

class BadRoute implements Route {

	BadRoute(this.request);

	Request request;

	@override
	Future<Response> getResponse() async {
		return Response.notFound();
	}
}

class DeniedRoute implements Route {
	DeniedRoute(this.request);

	Request request;

	@override
	Future<Response> getResponse() async {
		return Response.forbidden();
	}
}


Response htmlResponse(String content) {
	//Shorter & reusable way to set a proper html response
	//any other changes can be made to the Response object returned from here
	final Response resp = Response.ok(content);
	resp.contentType = ContentType.html;
	return resp;
}