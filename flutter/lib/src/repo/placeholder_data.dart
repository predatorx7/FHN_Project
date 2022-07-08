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

  Future<List<SamplePhoto>> getPhotos(int? page, int? limit) {
    assert(
      (page != null) == (limit != null),
      'page and limit must be both null or both not null',
    );

    logs('getPhotos').info('Requesting data with page: $page, limit: $limit');

    return service.getPhotos(
      page,
      limit,
    );
  }
}
