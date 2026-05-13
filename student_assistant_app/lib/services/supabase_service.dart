/// Supabase Service
/// Initializes and provides Supabase client instance.
/// This is the core service that all other services depend on.

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static const String _supabaseUrl = 'https://ablvdevtdyokvhmtmfcv.supabase.co';
  static const String _supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFibHZkZXZ0ZHlva3ZobXRtZmN2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzgwNTM2NzIsImV4cCI6MjA5MzYyOTY3Mn0.It203vYBGivsvNDAuR3gSpb0S4zZFrmcrdvBzJNe1uA';

  static SupabaseService? _instance;
  late final SupabaseClient client;

  SupabaseService._();

  static SupabaseService get instance {
    _instance ??= SupabaseService._();
    return _instance!;
  }

  /// Initialize Supabase with URL and Anon Key.
  /// Call this in main() before runApp().
  static Future<void> initialize() async {
    try {
      // Check if placeholder values are still in place
      if (_supabaseUrl == 'YOUR_SUPABASE_URL' || _supabaseAnonKey == 'YOUR_SUPABASE_ANON_KEY') {
        print('Warning: Supabase credentials not configured. Using mock mode.');
        // Initialize with empty values to prevent crashes
        await Supabase.initialize(
          url: 'https://placeholder.supabase.co',
          anonKey: 'placeholder-key',
        );
      } else {
        await Supabase.initialize(
          url: _supabaseUrl,
          anonKey: _supabaseAnonKey,
        );
      }
      instance.client = Supabase.instance.client;
    } catch (e) {
      print('Supabase initialization failed (app will run in mock mode): $e');
      // Don't rethrow - allow app to run without Supabase for local testing
    }
  }

  /// Get the current authenticated user's ID.
  String? get currentUserId => instance.client.auth.currentUser?.id;

  /// Get the current authenticated user's email.
  String? get currentUserEmail => instance.client.auth.currentUser?.email;
}
