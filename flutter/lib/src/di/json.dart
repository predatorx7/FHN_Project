import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping/src/modules/pagination.dart';

import '../data/data.dart';
import '../data/widgets.dart';
import '../repo/placeholder_data.dart';

final jsonPlaceholderRepository = Provider((ref) {
  return JsonPlaceholderDataRepository();
});

final itemsPaginationControllerProvider = StateNotifierProvider<
    PaginatedDataController<SampleItem>, PaginationData<SampleItem>>((ref) {
  final repo = ref.watch(jsonPlaceholderRepository);

  return PaginatedDataController<SampleItem>(
    fetch: repo.getShoppingItems,
  );
});
