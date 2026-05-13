//Student Name and Surname: Onalenna Shea, Thapelo Magwai, Toka Malachamela, Olebogeng Maruping, Sthembiso Thabethe, Thierry Sithole
//Student Number: 224076426, 223035662, 221000945, 224084905, 221030472, 224061529

// Submit Application Screen
// Form for students to submit module assistance applications.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/application_viewmodel.dart';

class SubmitApplicationScreen extends StatelessWidget {
  const SubmitApplicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final module1Controller = TextEditingController();
    final module2Controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Application'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Consumer<ApplicationViewModel>(
          builder: (context, appVM, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.assignment,
                  size: 64,
                  color: Color(0xFF1565C0),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Module Assistance Request',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'You can request assistance for up to 2 modules.',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Module 1 (Required)
                TextField(
                  controller: module1Controller,
                  decoration: const InputDecoration(
                    labelText: 'Module 1 *',
                    hintText: 'e.g., Programming 101',
                    prefixIcon: Icon(Icons.book),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Module 2 (Optional)
                TextField(
                  controller: module2Controller,
                  decoration: const InputDecoration(
                    labelText: 'Module 2 (Optional)',
                    hintText: 'e.g., Database Systems',
                    prefixIcon: Icon(Icons.book_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '* Required field',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 16),

                // Error Message
                if (appVM.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      appVM.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Success Message
                if (appVM.isSubmitted)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Card(
                      color: Colors.green,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Icon(Icons.check_circle, color: Colors.white, size: 48),
                            SizedBox(height: 8),
                            Text(
                              'Application Submitted Successfully!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                // Submit Button
                ElevatedButton(
                  onPressed: appVM.isLoading || appVM.isSubmitted
                      ? null
                      : () async {
                          final module1 = module1Controller.text.trim();
                          final module2 = module2Controller.text.trim();

                          if (module1.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Module 1 is required'),
                              ),
                            );
                            return;
                          }

                          final authVM = context.read<AuthViewModel>();
                          final success = await appVM.submitApplication(
                            studentId: authVM.userId ?? '',
                            studentName: authVM.userEmail ?? 'Student',
                            module1: module1,
                            module2: module2.isEmpty ? null : module2,
                          );

                          if (success) {
                            module1Controller.clear();
                            module2Controller.clear();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: const Color(0xFF1565C0),
                    foregroundColor: Colors.white,
                  ),
                  child: appVM.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Submit Application',
                          style: TextStyle(fontSize: 16),
                        ),
                ),

                if (appVM.isSubmitted)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        appVM.resetSubmission();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Submit Another Application'),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
