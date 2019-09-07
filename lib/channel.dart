import 'dart:convert';

import 'package:blueframe/Routes/RouteDelegator.dart';
import 'blueframe.dart';
import 'dart:io' as io;
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart' as mime;

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
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
  }

  /// Construct the request channel.
  ///
  /// Return an instance of some [Controller] that will be the initial receiver
  /// of all [Request]s.
  ///
  /// This method is invoked after [prepare].
  @override
  Controller get entryPoint {
    final router = Router();
    router.route("/assets/*").link(() => FileController("assets/"));

    router.route("/*").linkFunction((request) async {
      return RouteDelegator(request).getRoute().getResponse();
    });

    router.route("*(.ico)").linkFunction((request)async{
      try {
      final String filePath = "assets/${request.path.segments.join("/")}";
      final file = File(filePath);
      final fileContents = file.readAsBytesSync();
      final contentType = mime.lookupMimeType(filePath);
      return Response.ok(fileContents)
        ..contentType = io.ContentType.parse(contentType);
      } catch (e){
        return Response.notFound();
      }
    });

    router.route("*(.js)").linkFunction((request) async {
      try{
        final f = File("js/${request.path.segments.join("/")}");
      return Response.ok(
          f.readAsBytesSync())
        ..contentType = io.ContentType.parse(mime.lookupMimeType(f.path));
      } catch (e) {
        return Response.notFound();
      }
    });

    return router;
  }
}
