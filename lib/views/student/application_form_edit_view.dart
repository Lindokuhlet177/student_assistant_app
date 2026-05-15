/**
 * Student Numbers : 224108179, 222016851, 221030087, 220019475, 223025046, 221008989
 * Student Names: JL Davids, VM Malejane, KP Tshabalala, LJ Thabethe, TG Mofokeng, LM Twala
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/application.dart';

enum EditFormStatus { idle, loading, success, error }

class ApplicationEditViewModel extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  EditFormStatus status = EditFormStatus.idle;
  String errorMessage = '';

  final String applicationId;
  int? yearOfStudy;
  String? module1Level;
  String? module1Name;
  bool addSecondModule;
  String? module2Level;
  String? module2Name;
  bool meetsRequirements;

  ApplicationEditViewModel(Application app)
      : applicationId = app.id,
        yearOfStudy = app.yearOfStudy,
        module1Level = app.module1Level,
        module1Name = app.module1Name,
        addSecondModule = app.module2Name != null,
        module2Level = app.module2Level,
        module2Name = app.module2Name,
        meetsRequirements = app.meetsRequirements;

  void setYearOfStudy(int? v) { yearOfStudy = v; notifyListeners(); }
  void setModule1Level(String? v) { module1Level = v; notifyListeners(); }
  void setModule1Name(String? v) { module1Name = v; notifyListeners(); }
  void setAddSecondModule(bool v) {
    addSecondModule = v;
    if (!v) { module2Level = null; module2Name = null; }
    notifyListeners();
  }
  void setModule2Level(String? v) { module2Level = v; notifyListeners(); }
  void setModule2Name(String? v) { module2Name = v; notifyListeners(); }
  void setMeetsRequirements(bool v) { meetsRequirements = v; notifyListeners(); }

  Future<void> updateApplication() async {
    status = EditFormStatus.loading;
    notifyListeners();

    try {
      await _supabase.from('applications').update({
        'year_of_study': yearOfStudy,
        'module_1_level': module1Level,
        'module_1_name': module1Name,
        'module_2_level': addSecondModule ? module2Level : null,
        'module_2_name': addSecondModule ? module2Name : null,
        'meets_requirements': meetsRequirements,
      }).eq('id', applicationId);
      status = EditFormStatus.success;
    } catch (e) {
      status = EditFormStatus.error;
      errorMessage = e.toString();
    }

    notifyListeners();
  }
}

class ApplicationFormEditView extends StatefulWidget {
  final Application application;
  const ApplicationFormEditView({super.key, required this.application});

  @override
  State<ApplicationFormEditView> createState() => _ApplicationFormEditViewState();
}

class _ApplicationFormEditViewState extends State<ApplicationFormEditView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _module1NameController;
  late TextEditingController _module2NameController;
  final List<String> _levels = ['first year', 'second year', 'third year'];
  final List<int> _years = [1, 2, 3];

  @override
  void initState() {
    super.initState();
    _module1NameController = TextEditingController(text: widget.application.module1Name);
    _module2NameController = TextEditingController(text: widget.application.module2Name ?? '');
  }

  @override
  void dispose() {
    _module1NameController.dispose();
    _module2NameController.dispose();
    super.dispose();
  }

  void _submit(ApplicationEditViewModel vm) async {
    if (!_formKey.currentState!.validate()) return;
    if (!vm.meetsRequirements) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must confirm you meet the minimum requirements.'), backgroundColor: Colors.red),
      );
      return;
    }

    await vm.updateApplication();

    if (!mounted) return;
    if (vm.status == EditFormStatus.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Application updated successfully!'), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ApplicationEditViewModel>();

    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        title: const Text('Edit Application'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionCard(title: 'Personal Information', icon: Icons.person_outline, children: [
                const Text('Current Year of Study', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  value: vm.yearOfStudy,
                  decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Select year'),
                  items: _years.map((y) => DropdownMenuItem(value: y, child: Text('Year $y'))).toList(),
                  onChanged: vm.setYearOfStudy,
                  validator: (v) => v == null ? 'Please select your year of study' : null,
                ),
              ]),
              const SizedBox(height: 16),
              _sectionCard(title: 'Module 1 (Required)', icon: Icons.book_outlined, children: [
                const Text('Academic Level', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: vm.module1Level,
                  decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Select level'),
                  items: _levels.map((l) => DropdownMenuItem(value: l, child: Text(l[0].toUpperCase() + l.substring(1)))).toList(),
                  onChanged: vm.setModule1Level,
                  validator: (v) => v == null ? 'Please select a level' : null,
                ),
                const SizedBox(height: 16),
                const Text('Module Name', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _module1NameController,
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                  onChanged: vm.setModule1Name,
                  validator: (v) => (v == null || v.isEmpty) ? 'Module name is required' : null,
                ),
              ]),
              const SizedBox(height: 16),
              _sectionCard(title: 'Module 2 (Optional)', icon: Icons.book_outlined, children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Apply for a second module'),
                  value: vm.addSecondModule,
                  activeColor: Colors.indigo,
                  onChanged: vm.setAddSecondModule,
                ),
                if (vm.addSecondModule) ...[
                  const SizedBox(height: 8),
                  const Text('Academic Level', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: vm.module2Level,
                    decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Select level'),
                    items: _levels.map((l) => DropdownMenuItem(value: l, child: Text(l[0].toUpperCase() + l.substring(1)))).toList(),
                    onChanged: vm.setModule2Level,
                    validator: (v) => (vm.addSecondModule && v == null) ? 'Please select a level' : null,
                  ),
                  const SizedBox(height: 16),
                  const Text('Module Name', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _module2NameController,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    onChanged: vm.setModule2Name,
                    validator: (v) => (vm.addSecondModule && (v == null || v.isEmpty)) ? 'Module name is required' : null,
                  ),
                ],
              ]),
              const SizedBox(height: 16),
              _sectionCard(title: 'Eligibility Confirmation', icon: Icons.verified_outlined, children: [
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  activeColor: Colors.indigo,
                  value: vm.meetsRequirements,
                  onChanged: (v) => vm.setMeetsRequirements(v ?? false),
                  title: const Text('I confirm that I meet the minimum requirements for the Student Assistant position(s) I am applying for.'),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ]),
              const SizedBox(height: 16),
              if (vm.status == EditFormStatus.error)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
                  child: Row(children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(child: Text(vm.errorMessage, style: const TextStyle(color: Colors.red))),
                  ]),
                ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: vm.status == EditFormStatus.loading ? null : () => _submit(vm),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: vm.status == EditFormStatus.loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Save Changes', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionCard({required String title, required IconData icon, required List<Widget> children}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(icon, color: Colors.indigo, size: 20),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo)),
            ]),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }
}
