import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipad/features/audio_notes/domain/entities/audio_pin_entity.dart';
import 'package:ipad/features/audio_notes/presentation/viewmodels/audio_notes_viewmodel.dart';

class AudioPinOverlay extends StatelessWidget {
  final AudioNotesViewModel viewModel;
  final double zoom;
  final Function(AudioPinEntity) onPinTap;
  final Function(AudioPinEntity) onPinDelete;

  const AudioPinOverlay({
    super.key,
    required this.viewModel,
    required this.zoom,
    required this.onPinTap,
    required this.onPinDelete,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Obx(() => Stack(
          children: viewModel.currentPagePins.map((pin) {
            final x = pin.xNorm * constraints.maxWidth;
            final y = pin.yNorm * constraints.maxHeight;
            
            return Positioned(
              left: x - 20,
              top: y - 20,
              child: GestureDetector(
                onTap: () => onPinTap(pin),
                onLongPress: () => _showDeleteDialog(context, pin),
                child: _AudioPinWidget(
                  pin: pin,
                  isPlaying: viewModel.playingPinId?.value == pin.id,
                ),
              ),
            );
          }).toList(),
        ));
      },
    );
  }

  void _showDeleteDialog(BuildContext context, AudioPinEntity pin) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Audio Note'),
        content: const Text('Are you sure you want to delete this audio note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              onPinDelete(pin);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _AudioPinWidget extends StatelessWidget {
  final AudioPinEntity pin;
  final bool isPlaying;

  const _AudioPinWidget({
    required this.pin,
    required this.isPlaying,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isPlaying 
            ? Theme.of(context).colorScheme.primary 
            : Theme.of(context).colorScheme.secondary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        isPlaying ? Icons.stop : Icons.mic,
        color: Colors.white,
        size: 20,
      ),
    );
  }
}
