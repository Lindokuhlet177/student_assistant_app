//student member 2 - 224108179

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/application.dart';
import '../../viewmodels/home_viewmodel.dart';
import 'application_form_edit_view.dart';

class ApplicationDetailView extends StatelessWidget {
  final Application application;
  const ApplicationDetailView({super.key, required this.application});

  Color _statusColor(String status) {
    switch (status) {
      case 'approved': return Colors.green;
      case 'rejected': return Colors.red;
      default: return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        title: const Text('Application Detail'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // Status banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _statusColor(application.status).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _statusColor(application.status)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: _statusColor(application.status)),
                  const SizedBox(width: 8),
                  Text(
                    'Status: ${application.status.toUpperCase()}',
                    style: TextStyle(
                      color: _statusColor(application.status),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Personal info
            _detailCard(
              title: 'Personal Information',
              icon: Icons.person_outline,
              rows: [
                _detailRow('Year of Study', 'Year ${application.yearOfStudy}'),
              ],
            ),
            const SizedBox(height: 16),

            // Module 1
            _detailCard(
              title: 'Module 1',
              icon: Icons.book_outlined,
              rows: [
                _detailRow('Academic Level', application.module1Level),
                _detailRow('Module Name', application.module1Name),
              ],
            ),
            const SizedBox(height: 16),

            // Module 2 (if exists)
            if (application.module2Name != null) ...[
              _detailCard(
                title: 'Module 2',
                icon: Icons.book_outlined,
                rows: [
                  _detailRow('Academic Level', application.module2Level ?? '-'),
                  _detailRow('Module Name', application.module2Name ?? '-'),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Eligibility
            _detailCard(
              title: 'Eligibility',
              icon: Icons.verified_outlined,
              rows: [
                _detailRow(
                  'Meets Requirements',
                  application.meetsRequirements ? 'Yes' : 'No',
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Buttons — only show if pending
            if (application.status == 'pending') ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChangeNotifierProvider(
                          create: (_) => ApplicationEditViewModel(application),
                          child: ApplicationFormEditView(application: application),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Application'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _confirmDelete(context),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  label: const Text('Delete Application', style: TextStyle(color: Colors.red)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Application'),
        content: const Text('Are you sure you want to delete this application? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await context.read<HomeViewModel>().deleteApplication(application.id);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _detailCard({required String title, required IconData icon, required List<Widget> rows}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.indigo, size: 20),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo,
                )),
              ],
            ),
            const Divider(height: 24),
            ...rows,
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
