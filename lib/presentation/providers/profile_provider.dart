import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_profile.dart';
import 'repository_providers.dart';

final userProfileProvider = FutureProvider<UserProfile>((ref) {
  return ref.watch(productRepositoryProvider).getProfile();
});
