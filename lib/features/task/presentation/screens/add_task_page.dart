import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ptm/core/navigation/app_router.dart';
import 'package:ptm/features/profile/presentation/providers/profile_providers.dart';
import 'package:ptm/features/task/domain/entities/task.dart';
import 'package:ptm/features/task/domain/usecases/add_task.dart';
import 'package:ptm/features/task/presentation/providers/task_providers.dart';

class AddTaskPage extends ConsumerStatefulWidget {
  const AddTaskPage({super.key});

  @override
  ConsumerState<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends ConsumerState<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final profile = ref.read(activeProfileProvider).value;
    if (profile == null) return;

    setState(() => _saving = true);
    await ref.read(addTaskProvider).call(
          AddTaskParams(
            Task(
              id: null,
              title: _titleController.text.trim(),
              description: _descriptionController.text.trim(),
              status: TaskStatus.pending,
              profileId: profile.id,
            ),
          ),
        );
    ref.invalidate(tasksProvider);

    if (mounted) ref.read(appRouterDelegateProvider).backToHome();
  }

  Widget _titleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Title',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _titleController,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),

          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
          validator: (value) =>
              value == null || value.trim().isEmpty ? 'Title is required' : null,
          decoration: InputDecoration(
            fillColor: Colors.white,
            
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.black.withAlpha(100),
                width: 1
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.black.withAlpha(100),
                width: 1
              ),
            ),
            filled: true,
            hintText: 'Enter title',
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
            )

          ),
         
 
      ],
    );
  }

  Widget _desscriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _descriptionController,
          textCapitalization: TextCapitalization.sentences,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),

          keyboardType: TextInputType.multiline,
          maxLines: 3,
          validator: (value) =>
              value == null || value.trim().isEmpty ? 'Description is required' : null,
          decoration: InputDecoration(
            fillColor: Colors.white,
            
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.black.withAlpha(100),
                width: 1
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.black.withAlpha(100),
                width: 1
              ),
            ),
            filled: true,
            hintText: 'Enter description',
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
            )

          ),
         
 
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Task')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _titleField(),

              const SizedBox(height: 16),
              _desscriptionField(),
              const SizedBox(height: 24),
              ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _saving
                      ? const SizedBox(
                        width: 14,
                        height: 14,
                        child:  Center(
                          child: CircularProgressIndicator.adaptive(
                            strokeWidth: 1,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                       
                          ),
                        ),
                      )
                      : Text('Save', style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),),
                    ),
            
            ],
          ),
        ),
      ),
    );
  }
}
