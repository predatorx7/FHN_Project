import 'package:shopping/src/repo/repo.dart';
import 'package:shopping/src/utils/logging/logging.dart';
import 'package:shopping/src/utils/uri.dart';

import '../data/data.dart';
import '../services/placeholder_data.dart';

class JsonPlaceholderDataRepository
    extends SingleServiceRepository<JsonPlaceholderDataClient> {
  final logs = logging('JsonPlaceholderDataRepository');
  @override
  AppApi get api {
    return AppApi(
      Uri.https(
        'jsonplaceholder.typicode.com',
        '',
      ),
    );
  }

  @override
  JsonPlaceholderDataClient createService(Dio dio, {required String baseUrl}) {
    return JsonPlaceholderDataClient(
      dio,
      baseUrl: baseUrl,
    );
  }

  Future<List<SamplePhoto>> getPhotos(int? page, int? limit) async {
    assert(
      (page != null) == (limit != null),
      'page and limit must be both null or both not null',
    );

    final log = logs('getPhotos');

    log.info('Requesting data with page: $page, limit: $limit');

    final data = await service.getPhotos(
      page != null && limit != null ? page * limit : null,
      limit,
    );

    log.info('Received data: ${data.map((e) => e.id).join(", ")}');

    return data;
  }

  Future<Iterable<SampleItem>> getShoppingItems(int? page, int? limit) async {
    final result = await getPhotos(page, limit);

    return result.map((e) => SampleItem.fromPhoto(246.0, e));
  }
}
