//Student Name and Surname: Onalenna Shea, Thapelo Magwai, Toka Malachamela, Olebogeng Maruping, Sthembiso Thabethe, Thierry Sithole
//Student Number: 224076426, 223035662, 221000945, 224084905, 221030472, 224061529

// Admin Dashboard
// Main screen for admins to manage all applications.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/application_viewmodel.dart';
import 'manage_applications.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  void initState() {
    super.initState();
    // Load all applications when dashboard opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ApplicationViewModel>().loadAllApplications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              await context.read<ApplicationViewModel>().loadAllApplications();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await context.read<AuthViewModel>().logout();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Admin Header
            const Card(
              elevation: 4,
              color: Color(0xFF1565C0),
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.admin_panel_settings,
                      size: 64,
                      color: Colors.white,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Administrator Panel',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Manage Student Applications',
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Application Statistics
            Consumer<ApplicationViewModel>(
              builder: (context, appVM, child) {
                if (appVM.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _StatsCard(
                            title: 'Pending',
                            count: appVM.pendingApplications.length,
                            color: Colors.orange,
                            icon: Icons.pending,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatsCard(
                            title: 'Approved',
                            count: appVM.approvedApplications.length,
                            color: Colors.green,
                            icon: Icons.check_circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatsCard(
                            title: 'Rejected',
                            count: appVM.rejectedApplications.length,
                            color: Colors.red,
                            icon: Icons.cancel,
                          ),
                        ),
                      ],
                    ),
                    if (appVM.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          appVM.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),

            // Manage Applications Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ManageApplicationsScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.manage_search),
              label: const Text('Manage All Applications'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: const Color(0xFF1565C0),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;
  final IconData icon;

  const _StatsCard({
    required this.title,
    required this.count,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
