import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:read_quest/core/services/files/file_service.dart';
import 'package:read_quest/features/auth/login/views/login_screen.dart';

import '../../../core/constants/app_colors.dart';
import '../../../routing/route_names.dart';
import '../../home/officials/provider/modules_provider.dart';

class BookScreen extends ConsumerStatefulWidget {
  const BookScreen({super.key});

  @override
  ConsumerState<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends ConsumerState<BookScreen> {
  @override
  Widget build(BuildContext context) {
    final modules = ref.watch(getModulesProvider);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          centerTitle: true,
          title: const Text('Books'),
        ),
        body: modules.when(
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

            return GridView.builder(
              itemCount: data['data'].length,
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
                childAspectRatio: 3 / 4, // Adjust for manga poster shape
              ),
              itemBuilder: (context, index) {
                final item = data['data'][index];
                return BookCard(
                  title: item['name'],
                  description: item['description']!,
                  imageUrl: FileService.getImageUrl(item['cover']!),
                  onTap: () {
                    context.goNamed(RouteNames.readBook.name, pathParameters: {
                      'title': Uri.encodeComponent(item['name']),
                      'file': Uri.encodeComponent(
                          FileService.getFileUrl(item['file'])),
                    });
                  },
                );
              },
            );
          },
          error: (error, stackTrace) => Center(child: Text(error.toString())),
          loading: () => const Center(child: CircularProgressIndicator()),
        ));
  }
}

class BookCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final VoidCallback? onTap;
  const BookCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Dark overlay for readability
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),

            // Text content
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
