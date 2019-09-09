import 'package:blueframe/Routes/RouteDelegator.dart';
import 'package:blueframe/blueframe.dart';

class Ping implements Route {
	@override

	Ping(this.request);

	Future<Response> getResponse() async {
		return Response.ok("ping");
	}

	Request request;


	static Route getRoute(Request request) {
		return Ping(request);
	}
}