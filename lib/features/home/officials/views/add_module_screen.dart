import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gap/gap.dart';
import 'package:read_quest/core/services/database/module/module_service.dart';
import 'package:read_quest/shared/widgets/primary_button.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/loader/loading_provider.dart';
import '../../../../core/services/shared_preferences/shared_pref_enum.dart';
import '../../../../core/services/shared_preferences/shared_pref_helper.dart';

class AddModuleScreen extends ConsumerStatefulWidget {
  const AddModuleScreen({super.key});

  @override
  ConsumerState<AddModuleScreen> createState() => _AddModuleScreenState();
}

class _AddModuleScreenState extends ConsumerState<AddModuleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  File? _imageFile;
  File? _documentFile;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  Future<void> _pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() => _documentFile = File(result.files.single.path!));
    }
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Submit failed...')),
      );
      return;
    }

    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image.')),
      );
      return;
    }

    if (_documentFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a document.')),
      );
      return;
    }

    final loading = ref.read(loadingProvider.notifier);
    loading.setLoading(true);
    final userID = await SharedPrefHelper.get(SharedPrefKey.userID) ?? 0;

    final value = await ModuleService.uploadDocument(
      coverImage: _imageFile!,
      docFile: _documentFile!,
      name: _nameController.text,
      description: _descriptionController.text,
      uploadedBy: userID,
    );

    if (value['status'] == 'success') {
      loading.setLoading(false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(value['message'])),
      );
      Navigator.pop(context);
      return;
    }
    log(value.toString());

    loading.setLoading(false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(value['message'])),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    final isLoading = ref.watch(loadingProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        title: const Text('Create Module'),
      ),
      body: Padding(
        padding: EdgeInsets.all(size.width * 0.05),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Picture Upload
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: size.height * 0.25,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _imageFile != null
                      ? Image.file(_imageFile!, fit: BoxFit.cover)
                      : const Center(child: Text('Tap to upload module image')),
                ),
              ),
              const Gap(20),

              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Module Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              const Gap(20),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              const Gap(20),

              // File Upload
              OutlinedButton.icon(
                icon: const Icon(Icons.attach_file),
                label: Text(_documentFile == null
                    ? 'Attach PDF or Word File'
                    : 'Selected: ${_documentFile!.path.split('/').last}'),
                onPressed: _pickDocument,
              ),
              const Gap(30),

              CPrimaryButton(
                isLoading: isLoading,
                backgroundColor: AppColors.primary,
                textStyle: theme.textTheme.titleLarge!
                    .copyWith(color: AppColors.white),
                title: isLoading ? 'Uploading...' : 'Submit',
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
