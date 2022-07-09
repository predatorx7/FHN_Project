import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:shopping/src/data/data.dart';

part 'placeholder_data.g.dart';

@RestApi()
abstract class JsonPlaceholderDataClient {
  factory JsonPlaceholderDataClient(Dio dio, {String baseUrl}) =
      _JsonPlaceholderDataClient;

  @GET("/photos")
  Future<List<SamplePhoto>> getPhotos(
    @Query('_start') int? start,
    @Query('_limit') int? limit,
  );
}
