import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:builder_bridge/features/booking/presentation/providers/booking_provider.dart';
import 'package:builder_bridge/features/documents/data/models/document_model.dart';
import 'package:builder_bridge/features/documents/data/repositories/document_repository.dart';
import 'package:builder_bridge/features/inventory/presentation/providers/inventory_provider.dart';

part 'documents_provider.g.dart';

@riverpod
DocumentRepository documentRepository(Ref ref) => DocumentRepository();

@riverpod
Future<List<DocumentModel>> currentBookingDocuments(Ref ref) async {
  final booking = await ref.watch(currentUserBookingProvider.future);
  if (booking == null) return [];

  final repo = ref.watch(documentRepositoryProvider);
  var docs = await repo.getForBooking(booking.id);

  // Self-heal: legacy bookings without any documents.
  if (docs.isEmpty) {
    final unit =
        await ref.read(unitRepositoryProvider).getById(booking.unitId);
    if (unit != null) {
      final created = await repo.ensureBookingDocsFor(
        bookingId: booking.id,
        unitNo: unit.unitNo,
      );
      if (created) {
        docs = await repo.getForBooking(booking.id);
      }
    }
  }

  return docs;
}

@riverpod
class DocumentCategoryFilter extends _$DocumentCategoryFilter {
  @override
  String build() => DocumentCategory.all;

  void select(String category) => state = category;
}
