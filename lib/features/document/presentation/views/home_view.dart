import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ipad/features/document/presentation/viewmodels/document_viewmodel.dart';
import 'package:ipad/features/settings/presentation/views/settings_view.dart';
import 'package:ipad/features/viewer/presentation/views/pdf_viewer_view.dart';

class HomeView extends GetView<DocumentViewModel> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Study'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Get.to(() => const SettingsView()),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.documents.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.documents.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.picture_as_pdf,
                  size: 80,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: 16),
                Text(
                  'No documents yet',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Import a PDF to get started',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _importDocument,
                  icon: const Icon(Icons.add),
                  label: const Text('Import PDF'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadRecentDocuments,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.documents.length,
            itemBuilder: (context, index) {
              final doc = controller.documents[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(Icons.picture_as_pdf),
                  title: Text(doc.name),
                  subtitle: Text(
                    'Last opened: ${_formatDate(doc.lastOpenedAt)}',
                  ),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete),
                            SizedBox(width: 8),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'delete') {
                        _confirmDelete(doc.id, doc.name);
                      }
                    },
                  ),
                  onTap: () => _openDocument(doc.id, doc.localPath),
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: _importDocument,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _importDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      final doc = await controller.importDocument(result.files.single.path!);
      if (doc != null) {
        Get.to(() => PdfViewerView(document: doc));
      }
    }
  }

  void _openDocument(String id, String path) {
    final doc = controller.documents.firstWhere((d) => d.id == id);
    controller.updateLastOpened(doc);
    Get.to(() => PdfViewerView(document: doc));
  }

  void _confirmDelete(String id, String name) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Document'),
        content: Text('Are you sure you want to remove "$name" from recent documents?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              controller.deleteDocument(id);
              Get.back();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
