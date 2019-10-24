import 'package:blueframe/blueframe.dart';
import 'package:blueframe/routes/RouteDelegator.dart';

class Ping implements Route {

	Ping(this.request);

	static Route init(Request request) => Ping(request);

	Request request;

	@override
	Future<Response> getResponse() async => Response.ok("ping");

}