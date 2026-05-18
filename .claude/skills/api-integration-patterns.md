# Skill: API Integration Patterns

HTTP client patterns for BuilderBridge Phase 2 (Spring Boot backend). Set up infrastructure now; activate in Phase 2.

## Dio Client Setup

```dart
// lib/core/network/http_client.dart
final httpClientProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: const String.fromEnvironment('API_BASE_URL', defaultValue: 'http://10.0.2.2:8080'),
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 30),
    headers: {'Content-Type': 'application/json'},
  ));

  dio.interceptors.addAll([
    AuthInterceptor(ref),
    LoggingInterceptor(),
    ErrorInterceptor(),
  ]);

  return dio;
});
```

## Auth Interceptor

```dart
class AuthInterceptor extends Interceptor {
  final Ref _ref;
  AuthInterceptor(this._ref);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _ref.read(authTokenProvider);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Attempt token refresh
      try {
        await _ref.read(authNotifierProvider.notifier).refreshToken();
        // Retry original request
        final response = await _ref.read(httpClientProvider).fetch(err.requestOptions);
        handler.resolve(response);
        return;
      } catch (_) {
        _ref.read(authNotifierProvider.notifier).logout();
      }
    }
    handler.next(err);
  }
}
```

## Error Handling

```dart
// lib/core/network/api_exceptions.dart
sealed class ApiException implements Exception {
  const ApiException();
}
class NetworkException extends ApiException { const NetworkException(); }
class UnauthorizedException extends ApiException { const UnauthorizedException(); }
class NotFoundException extends ApiException { const NotFoundException(); }
class ValidationException extends ApiException {
  final Map<String, List<String>> errors;
  const ValidationException(this.errors);
}
class ServerException extends ApiException { const ServerException(); }

// lib/core/network/error_interceptor.dart
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final exception = switch (err.response?.statusCode) {
      401 => const UnauthorizedException(),
      404 => const NotFoundException(),
      422 => ValidationException(_parseErrors(err.response?.data)),
      >= 500 => const ServerException(),
      _ => const NetworkException(),
    };
    handler.next(DioException(
      requestOptions: err.requestOptions,
      error: exception,
    ));
  }
}
```

## Repository HTTP Pattern (Phase 2)

```dart
class RemoteInventoryRepository implements IInventoryRepository {
  final Dio _dio;
  RemoteInventoryRepository(this._dio);

  @override
  Future<List<Unit>> getUnits(int towerId, {UnitStatus? status}) async {
    final response = await _dio.get(
      '/api/v1/towers/$towerId/units',
      queryParameters: status != null ? {'status': status.name} : null,
    );
    final data = response.data['data'] as List;
    return data.map((m) => Unit.fromMap(m as Map<String, dynamic>)).toList();
  }
}
```

## Phase 1 → Phase 2 Swap

```dart
// Phase 1 (current): local SQLite
final inventoryRepositoryProvider = Provider<IInventoryRepository>((ref) {
  return LocalInventoryRepository(ref.read(databaseProvider));
});

// Phase 2: swap single line
final inventoryRepositoryProvider = Provider<IInventoryRepository>((ref) {
  return CachedInventoryRepository(
    local: LocalInventoryRepository(ref.read(databaseProvider)),
    remote: RemoteInventoryRepository(ref.read(httpClientProvider)),
  );
});
```

## Rules
- `10.0.2.2` = localhost from Android emulator; `localhost` on iOS simulator
- All endpoints versioned: `/api/v1/`
- Timeouts always set — never unbounded requests
- Auth token in header only — never in URL params
- Repository interface allows local/remote swap without UI changes
