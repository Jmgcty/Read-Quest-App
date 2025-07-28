// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:read_quest/core/constants/app_colors.dart';
import 'package:read_quest/core/services/files/file_service.dart';

import 'package:read_quest/features/home/officials/provider/modules_provider.dart';

import '../../../../routing/route_names.dart';

class ReadingModulesScreen extends ConsumerStatefulWidget {
  const ReadingModulesScreen({super.key});

  @override
  ConsumerState<ReadingModulesScreen> createState() =>
      _ReadingModulesScreenState();
}

class _ReadingModulesScreenState extends ConsumerState<ReadingModulesScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _goToPage(int index) {
    setState(() => _currentPage = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildNavButton(String title, int index) {
    final bool isActive = _currentPage == index;
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isActive ? AppColors.textLabel : AppColors.white,
          foregroundColor: isActive ? AppColors.white : AppColors.primary,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        onPressed: () => _goToPage(index),
        child: Text(title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uploads = ref.watch(getUserUploadsProvider);

    //
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => context.goNamed(RouteNames.dashboard.name),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined, color: AppColors.white),
            onPressed: () => context.goNamed(RouteNames.addModule.name),
          ),
        ],
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        title: const Text('Modules'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              _buildNavButton("My Uploads", 0),
              _buildNavButton("Games", 1),
            ],
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              children: [
                MyUploadSection(uploads: uploads),
                const Center(child: Text("Games Page")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyUploadSection extends ConsumerStatefulWidget {
  MyUploadSection({super.key, required this.uploads});
  AsyncValue<Map<String, dynamic>> uploads;
  @override
  ConsumerState<MyUploadSection> createState() => _MyUploadSectionState();
}

class _MyUploadSectionState extends ConsumerState<MyUploadSection> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        body: widget.uploads.when(
      data: (data) {
        if (data['data'].isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(child: Text('No modules found!')),
              TextButton.icon(
                  label: const Text('Refresh'),
                  icon: const Icon(
                    Icons.refresh,
                    color: AppColors.primary,
                  ),
                  onPressed: () {
                    ref.refresh(getUserUploadsProvider);
                  }),
            ],
          );
        }
        return ListView.builder(
          itemCount: data['data'].length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: (data['data'][index]['cover'] != null
                        ? Image.network(FileService.getImageUrl(
                            data['data'][index]['cover']))
                        : null),
                    title: Text(data['data'][index]['name'],
                        style: theme.textTheme.titleLarge!.copyWith(
                          color: AppColors.textLabel,
                          fontWeight: FontWeight.bold,
                        )),
                    trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: AppColors.white,
                        ),
                        onPressed: () {}),
                    onTap: () => {
                          context.goNamed(RouteNames.readModule.name,
                              pathParameters: {
                                'title': Uri.encodeComponent(
                                    data['data'][index]['name']),
                                'file': Uri.encodeComponent(
                                    FileService.getFileUrl(
                                        data['data'][index]['file'])),
                              })
                        }),
              ),
            );
          },
        );
      },
      error: (error, stackTrace) => Text('Error: $error'),
      loading: () => const Center(child: CircularProgressIndicator()),
    ));
  }
}
