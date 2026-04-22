import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:ipad/features/document/domain/entities/document_entity.dart';
import 'package:ipad/features/drawing/presentation/widgets/drawing_canvas.dart';
import 'package:ipad/features/drawing/presentation/widgets/drawing_toolbar.dart';
import 'package:ipad/features/drawing/presentation/viewmodels/drawing_viewmodel.dart';
import 'package:ipad/features/audio_notes/presentation/widgets/audio_pin_overlay.dart';
import 'package:ipad/features/audio_notes/presentation/viewmodels/audio_notes_viewmodel.dart';

class PdfViewerView extends StatefulWidget {
  final DocumentEntity document;

  const PdfViewerView({super.key, required this.document});

  @override
  State<PdfViewerView> createState() => _PdfViewerViewState();
}

class _PdfViewerViewState extends State<PdfViewerView> {
  final PdfViewerController _pdfController = PdfViewerController();
  
  late final DrawingViewModel _drawingViewModel;
  late final AudioNotesViewModel _audioNotesViewModel;
  
  int _currentPage = 1;
  double _currentZoom = 1.0;
  bool _showToolbar = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _drawingViewModel = Get.put(DrawingViewModel());
    _audioNotesViewModel = Get.put(AudioNotesViewModel());
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _drawingViewModel.setCurrentPage(widget.document.id, _currentPage - 1);
      _audioNotesViewModel.setCurrentPage(widget.document.id, _currentPage - 1);
    });
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
            GestureDetector(
              onLongPressStart: _onLongPressStart,
              child: SfPdfViewer.file(
                File(widget.document.localPath),
                controller: _pdfController,
                onDocumentLoaded: (details) {
                  setState(() => _isLoading = false);
                  _drawingViewModel.setCurrentPage(widget.document.id, 0);
                  _audioNotesViewModel.setCurrentPage(widget.document.id, 0);
                },
                onPageChanged: (details) {
                  setState(() {
                    _currentPage = details.newPageNumber;
                  });
                  _drawingViewModel.setCurrentPage(
                    widget.document.id,
                    details.newPageNumber - 1,
                  );
                  _audioNotesViewModel.setCurrentPage(
                    widget.document.id,
                    details.newPageNumber - 1,
                  );
                },
                onZoomLevelChanged: (details) {
                  setState(() {
                    _currentZoom = details.newZoomLevel;
                  });
                },
              ),
            ),
            Positioned.fill(
              child: GetBuilder<DrawingViewModel>(
                init: _drawingViewModel,
                builder: (vm) => DrawingCanvas(
                  viewModel: vm,
                  onDoubleTap: vm.handleDoubleTap,
                ),
              ),
            ),
            Positioned.fill(
              child: GetBuilder<AudioNotesViewModel>(
                init: _audioNotesViewModel,
                builder: (vm) => AudioPinOverlay(
                  viewModel: vm,
                  zoom: _currentZoom,
                  onPinTap: vm.playAudio,
                  onPinDelete: vm.deletePin,
                ),
              ),
            ),
            if (_showToolbar)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: GetBuilder<DrawingViewModel>(
                  init: _drawingViewModel,
                  builder: (vm) => DrawingToolbar(viewModel: vm),
                ),
              ),
            Positioned(
              top: 8,
              left: 8,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Get.back(),
                  ),
                  IconButton(
                    icon: Icon(_showToolbar ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _showToolbar = !_showToolbar),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Page $_currentPage',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onLongPressStart(LongPressStartDetails details) {
    final renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.globalPosition);
    
    final width = renderBox.size.width;
    final height = renderBox.size.height;
    
    final xNorm = localPosition.dx / width;
    final yNorm = localPosition.dy / height;
    
    _audioNotesViewModel.startCreatingPin(xNorm, yNorm);
    _showAudioRecordingDialog();
  }

  void _showAudioRecordingDialog() {
    Get.dialog(
      GetBuilder<AudioNotesViewModel>(
        init: _audioNotesViewModel,
        builder: (vm) => AlertDialog(
          title: const Text('Record Audio Note'),
          content: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (vm.isRecording.value)
                const Text('Recording...')
              else
                const Text('Tap to start recording'),
            ],
          )),
          actions: [
            TextButton(
              onPressed: () {
                vm.cancelRecording();
                Get.back();
              },
              child: const Text('Cancel'),
            ),
            Obx(() => FilledButton(
              onPressed: () {
                if (vm.isRecording.value) {
                  vm.stopRecording();
                  Get.back();
                } else {
                  vm.startRecording();
                }
              },
              child: Text(vm.isRecording.value ? 'Stop' : 'Record'),
            )),
          ],
        ),
      ),
    );
  }
}
