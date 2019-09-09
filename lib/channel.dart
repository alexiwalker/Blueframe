import 'package:blueframe/Routes/RouteDelegator.dart';
import 'blueframe.dart';
import 'support/fileHandlers.dart';

/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://aqueduct.io/docs/http/channel/.
class BlueframeChannel extends ApplicationChannel {
	/// Initialize services in this method.
	///
	/// Implement this method to initialize services, read values from [options]
	/// and any other initialization required before constructing [entryPoint].
	///
	/// This method is invoked prior to [entryPoint] being accessed.
	@override
	Future prepare() async {
		logger.onRecord.listen(
				(rec) =>
				print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
	}

	/// Construct the request channel.
	///
	/// Return an instance of some [Controller] that will be the initial receiver
	/// of all [Request]s.
	///
	/// This method is invoked after [prepare].
	bool isDev = true;

	@override
	Controller get entryPoint {
		final router = Router();
		router.route("/assets/*").link(() => FileController("assets/"));

		router.route("/*").linkFunction(
				(request) => RouteDelegator(request).getRoute().getResponse());

		router.route("*(.ico)").linkFunction(FileHandlers.Ico);

		//if dev, use non minified JS for debugging. Use JsMin for prod
		if (isDev)
			router.route("*(.js)").linkFunction(FileHandlers.Js);
		else
			router.route("*(.js)").linkFunction(FileHandlers.JsMin);

		router.route("*(.css)").linkFunction(FileHandlers.Css);

		return router;
	}
}
