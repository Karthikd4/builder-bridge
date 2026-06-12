import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:builder_bridge/core/database/database_helper.dart';
import 'package:builder_bridge/features/admin/data/models/admin_user_model.dart';
import 'package:builder_bridge/features/admin/data/repositories/admin_user_repository.dart';
import 'package:builder_bridge/features/interests/data/repositories/interest_repository.dart';
import 'package:builder_bridge/features/interests/presentation/providers/interest_provider.dart';
import 'package:builder_bridge/features/inventory/data/models/unit_model.dart';
import 'package:builder_bridge/features/inventory/presentation/providers/inventory_provider.dart';
import 'package:builder_bridge/features/support/data/models/ticket_model.dart';
import 'package:builder_bridge/features/support/data/repositories/support_repository.dart';

part 'admin_providers.g.dart';

// ── Dashboard summary ────────────────────────────────────────────────────────

class AdminDashboardStats {
  final int totalUnits;
  final int availableUnits;
  final int reservedUnits;
  final int bookedUnits;
  final int totalInterests;
  final int newInterests;

  const AdminDashboardStats({
    required this.totalUnits,
    required this.availableUnits,
    required this.reservedUnits,
    required this.bookedUnits,
    required this.totalInterests,
    required this.newInterests,
  });
}

@riverpod
Future<AdminDashboardStats> adminDashboardStats(Ref ref) async {
  // Fetch units and interests in parallel — independent DB queries.
  final (units, interests) = await (
    ref.watch(allUnitsProvider.future),
    ref.watch(allInterestsProvider.future),
  ).wait;

  return AdminDashboardStats(
    totalUnits:     units.length,
    availableUnits: units.where((u) => u.status == 'available').length,
    reservedUnits:  units.where((u) => u.status == 'reserved').length,
    bookedUnits:    units.where((u) => u.status == 'booked').length,
    totalInterests: interests.length,
    newInterests:   interests.where((i) => i.status == InterestStatus.newInterest).length,
  );
}

// ── All units (flat list across all towers) ──────────────────────────────────

@riverpod
Future<List<UnitModel>> allUnits(Ref ref) {
  return ref.watch(unitRepositoryProvider).getAllWithTowerName();
}

// ── Unit status update ───────────────────────────────────────────────────────

@riverpod
class UnitStatusNotifier extends _$UnitStatusNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> updateStatus(int unitId, String status) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(unitRepositoryProvider).updateStatus(unitId, status);
      ref.invalidate(allUnitsProvider);
      ref.invalidate(adminDashboardStatsProvider);
    });
  }
}

// ── Interest status update ───────────────────────────────────────────────────

@riverpod
class AdminInterestNotifier extends _$AdminInterestNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> markContacted(int interestId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(interestRepositoryProvider)
          .updateStatus(interestId, InterestStatus.contacted);
      ref.invalidate(allInterestsProvider);
      ref.invalidate(adminDashboardStatsProvider);
    });
  }
}

// ── Onboarded customers ─────────────────────────────────────────────────────

class OnboardedCustomer {
  final int bookingId;
  final String customerName;
  final String phone;
  final String? email;
  final String unitNo;
  final String towerName;
  final String unitType;
  final String status;
  final int tokenAmount;
  final String bookedAt;

  const OnboardedCustomer({
    required this.bookingId,
    required this.customerName,
    required this.phone,
    required this.email,
    required this.unitNo,
    required this.towerName,
    required this.unitType,
    required this.status,
    required this.tokenAmount,
    required this.bookedAt,
  });
}

@riverpod
Future<List<OnboardedCustomer>> onboardedCustomers(Ref ref) async {
  final db = DatabaseHelper();
  final rows = await db.rawQuery('''
    SELECT b.id AS booking_id, u.name AS customer_name, u.phone, u.email,
           un.unit_no, t.name AS tower_name, un.type AS unit_type,
           b.status, b.token_amount, b.booked_at
    FROM bookings b
    JOIN users u ON b.user_id = u.id
    JOIN units un ON b.unit_id = un.id
    JOIN towers t ON un.tower_id = t.id
    ORDER BY b.booked_at DESC
  ''');
  return rows
      .map((r) => OnboardedCustomer(
            bookingId: r['booking_id'] as int,
            customerName: (r['customer_name'] as String?) ?? 'Unknown',
            phone: (r['phone'] as String?) ?? '',
            email: r['email'] as String?,
            unitNo: r['unit_no'] as String,
            towerName: r['tower_name'] as String,
            unitType: r['unit_type'] as String,
            status: r['status'] as String,
            tokenAmount: r['token_amount'] as int,
            bookedAt: r['booked_at'] as String,
          ))
      .toList();
}

// ── Admin tickets ───────────────────────────────────────────────────────────

class AdminTicket {
  final TicketModel ticket;
  final String customerName;
  final String customerPhone;

  const AdminTicket({
    required this.ticket,
    required this.customerName,
    required this.customerPhone,
  });
}

@riverpod
Future<List<AdminTicket>> adminTickets(Ref ref) async {
  final rows = await SupportRepository().getAllWithCustomerName();
  return rows.map((r) {
    final ticket = TicketModel.fromJson(r);
    return AdminTicket(
      ticket: ticket,
      customerName: (r['customer_name'] as String?) ?? 'Unknown',
      customerPhone: (r['customer_phone'] as String?) ?? '',
    );
  }).toList();
}

@riverpod
class AdminTicketNotifier extends _$AdminTicketNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> updateStatus(int ticketId, String status) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await SupportRepository().updateStatus(ticketId, status);
      ref.invalidate(adminTicketsProvider);
    });
  }

  Future<void> addReply(int ticketId, String body) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await SupportRepository().addComment(
        ticketId: ticketId,
        author: 'Admin',
        body: body,
      );
      ref.invalidate(adminTicketsProvider);
    });
  }
}

// ── Admin users (team) ──────────────────────────────────────────────────────

@riverpod
Future<List<AdminUserModel>> adminUsers(Ref ref) async {
  return AdminUserRepository().getAll();
}

@riverpod
class AdminUserNotifier extends _$AdminUserNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> createUser({
    required String name,
    required String email,
    String phone = '',
    String role = 'viewer',
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await AdminUserRepository().create(
        name: name,
        email: email,
        phone: phone,
        role: role,
      );
      ref.invalidate(adminUsersProvider);
    });
  }

  Future<void> updateUser(int id, {
    String? name,
    String? email,
    String? phone,
    String? role,
    bool? isActive,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await AdminUserRepository().update(id,
        name: name,
        email: email,
        phone: phone,
        role: role,
        isActive: isActive,
      );
      ref.invalidate(adminUsersProvider);
    });
  }
}
