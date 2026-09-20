import 'package:shared_preferences/shared_preferences.dart';
import 'package:pulse/core/di/injections.dart';
import 'package:pulse/core/errors/either.dart';
import 'package:pulse/core/errors/failures.dart';

class CacheHelper {
  static Either<Failure, dynamic> getData({required String key}) {
    try {
      final prefs = sl<SharedPreferences>();
      return Right(prefs.get(key));
    } catch (_) {
      return const Left(CacheFailure());
    }
  }

  static Future<Either<Failure, bool>> saveData({
    required String key,
    required dynamic value,
  }) async {
    try {
      final prefs = sl<SharedPreferences>();
      final saved = value is String
          ? await prefs.setString(key, value)
          : value is int
          ? await prefs.setInt(key, value)
          : value is bool
          ? await prefs.setBool(key, value)
          : value is double
          ? await prefs.setDouble(key, value)
          : value is List<String>
          ? await prefs.setStringList(key, value)
          : false;
      return saved ? const Right(true) : const Left(CacheFailure());
    } catch (_) {
      return const Left(CacheFailure());
    }
  }

  static Future<Either<Failure, bool>> removeData({required String key}) async {
    try {
      final prefs = sl<SharedPreferences>();
      final removed = await prefs.remove(key);
      return removed ? const Right(true) : const Left(CacheFailure());
    } catch (_) {
      return const Left(CacheFailure());
    }
  }
}
