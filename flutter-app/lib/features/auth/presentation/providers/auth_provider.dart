import 'package:flutter/foundation.dart' show ChangeNotifier, immutable;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:builder_bridge/features/auth/data/models/user_model.dart';
import 'package:builder_bridge/features/auth/data/repositories/auth_repository.dart';

// ── Repository ──────────────────────────────────────────────────────────────

final authRepositoryProvider = Provider<AuthRepository>((_) => AuthRepository());

// ── State ────────────────────────────────────────────────────────────────────

@immutable
class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;
  final bool otpSent;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.otpSent = false,
  });

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    bool? otpSent,
    bool clearUser = false,
    bool clearError = false,
  }) =>
      AuthState(
        user: clearUser ? null : user ?? this.user,
        isLoading: isLoading ?? this.isLoading,
        error: clearError ? null : error ?? this.error,
        otpSent: otpSent ?? this.otpSent,
      );
}

// ── Notifier ─────────────────────────────────────────────────────────────────

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._repo) : super(const AuthState(isLoading: true)) {
    _checkSession();
  }

  final AuthRepository _repo;

  Future<void> _checkSession() async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await _repo.getSessionUser();
      state = state.copyWith(user: user, isLoading: false, clearError: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> sendOtp(String phone) async {
    state = state.copyWith(isLoading: true, clearError: true);
    await Future.delayed(const Duration(milliseconds: 300)); // simulated network
    state = state.copyWith(isLoading: false, otpSent: true);
  }

  Future<void> verifyOtp(String phone, String otp) async {
    // MVP: any 6-digit OTP passes
    if (otp.length != 6) {
      state = state.copyWith(error: 'Enter a 6-digit OTP');
      return;
    }
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _repo.loginWithPhone(phone);
      state = state.copyWith(user: user, isLoading: false, otpSent: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    state = const AuthState();
  }

  void clearError() => state = state.copyWith(clearError: true);
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref.watch(authRepositoryProvider)),
);

// ── Router notifier (ChangeNotifier bridge for go_router) ────────────────────

class RouterNotifier extends ChangeNotifier {
  RouterNotifier(this._ref) {
    _ref.listen<AuthState>(authProvider, (_, __) => notifyListeners());
  }

  final Ref _ref;

  bool get isAuthenticated => _ref.read(authProvider).isAuthenticated;
  bool get isLoading => _ref.read(authProvider).isLoading;
}

final routerNotifierProvider = ChangeNotifierProvider<RouterNotifier>(
  (ref) => RouterNotifier(ref),
);
