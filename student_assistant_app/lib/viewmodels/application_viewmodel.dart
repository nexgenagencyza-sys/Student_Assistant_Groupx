//Student Name and Surname: Onalenna Shea, Thapelo Magwai, Toka Malachamela, Olebogeng Maruping, Sthembiso Thabethe, Thierry Sithole
//Student Number: 224076426, 223035662, 221000945, 224084905, 221030472, 224061529

// Manages application state and business logic.
// Communicates with ApplicationService and notifies UI via Provider.

import 'package:flutter/material.dart';
import '../models/application.dart';
import '../models/application_status.dart';
import '../services/application_service.dart';

class ApplicationViewModel extends ChangeNotifier {
  final ApplicationService _applicationService = ApplicationService();

  List<Application> _applications = [];
  List<Application> _allApplications = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isSubmitted = false;

  // Getters
  List<Application> get applications => _applications;
  List<Application> get allApplications => _allApplications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSubmitted => _isSubmitted;

  // Filtered getters for admin
  List<Application> get pendingApplications =>
      _allApplications.where((app) => app.isPending).toList();
  List<Application> get approvedApplications =>
      _allApplications.where((app) => app.isApproved).toList();
  List<Application> get rejectedApplications =>
      _allApplications.where((app) => app.isRejected).toList();

  // Submit a new application.
  Future<bool> submitApplication({
    required String studentId,
    required String studentName,
    required String module1,
    String? module2,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _isSubmitted = false;
    notifyListeners();

    final result = await _applicationService.submitApplication(
      studentId: studentId,
      studentName: studentName,
      module1: module1,
      module2: module2,
    );

    _isLoading = false;

    if (result['success'] == true) {
      _isSubmitted = true;
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['error'] ?? 'Failed to submit application';
      notifyListeners();
      return false;
    }
  }

  // Load applications for a specific student.
  Future<void> loadStudentApplications(String studentId) async {
    _isLoading = true;
    notifyListeners();

    _applications = await _applicationService.getStudentApplications(studentId);

    _isLoading = false;
    notifyListeners();
  }

  // Load all applications (admin only).
  Future<void> loadAllApplications() async {
    _isLoading = true;
    notifyListeners();

    _allApplications = await _applicationService.getAllApplications();

    _isLoading = false;
    notifyListeners();
  }

  // Approve an application.
  Future<bool> approveApplication(String applicationId) async {
    return await _updateStatus(applicationId, ApplicationStatus.approved.value);
  }

  // Reject an application.
  Future<bool> rejectApplication(String applicationId) async {
    return await _updateStatus(applicationId, ApplicationStatus.rejected.value);
  }

  // Update application status.
  Future<bool> _updateStatus(String applicationId, String status) async {
    _isLoading = true;
    notifyListeners();

    final result = await _applicationService.updateApplicationStatus(
      applicationId: applicationId,
      status: status,
    );

    _isLoading = false;

    if (result['success'] == true) {
      // Refresh the applications list
      await loadAllApplications();
      return true;
    } else {
      _errorMessage = result['error'] ?? 'Failed to update status';
      notifyListeners();
      return false;
    }
  }

  // Delete an application.
  Future<bool> deleteApplication(String applicationId) async {
    _isLoading = true;
    notifyListeners();

    final result = await _applicationService.deleteApplication(applicationId);

    _isLoading = false;

    if (result['success'] == true) {
      await loadAllApplications();
      return true;
    } else {
      _errorMessage = result['error'] ?? 'Failed to delete application';
      notifyListeners();
      return false;
    }
  }

  // Reset submission state.
  void resetSubmission() {
    _isSubmitted = false;
    _errorMessage = null;
    notifyListeners();
  }

  // Clear error message.
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
