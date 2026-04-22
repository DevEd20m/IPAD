import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipad/core/constants/app_constants.dart';
import 'package:ipad/features/drawing/domain/entities/drawing_entities.dart';
import 'package:ipad/features/drawing/presentation/viewmodels/drawing_viewmodel.dart';

class DrawingToolbar extends StatelessWidget {
  final DrawingViewModel viewModel;

  const DrawingToolbar({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildToolButtons(context),
            const SizedBox(height: 12),
            _buildColorPicker(context),
            const SizedBox(height: 8),
            _buildWidthSlider(context),
          ],
        ),
      ),
    );
  }

  Widget _buildToolButtons(BuildContext context) {
    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ToolButton(
          icon: Icons.edit,
          label: 'Pen',
          isSelected: viewModel.currentTool.value.type == DrawingToolType.pen,
          onTap: () => viewModel.selectTool(DrawingToolType.pen),
        ),
        _ToolButton(
          icon: Icons.create,
          label: 'Pencil',
          isSelected: viewModel.currentTool.value.type == DrawingToolType.pencil,
          onTap: () => viewModel.selectTool(DrawingToolType.pencil),
        ),
        _ToolButton(
          icon: Icons.brush,
          label: 'Marker',
          isSelected: viewModel.currentTool.value.type == DrawingToolType.marker,
          onTap: () => viewModel.selectTool(DrawingToolType.marker),
        ),
        _ToolButton(
          icon: Icons.auto_fix_high,
          label: 'Eraser',
          isSelected: viewModel.currentTool.value.type == DrawingToolType.eraser,
          onTap: () => viewModel.selectTool(DrawingToolType.eraser),
        ),
      ],
    ));
  }

  Widget _buildColorPicker(BuildContext context) {
    return Obx(() {
      final isEraser = viewModel.currentTool.value.type == DrawingToolType.eraser;
      
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: AppConstants.defaultColors.map((color) {
          final isSelected = viewModel.currentTool.value.color == color;
          return GestureDetector(
            onTap: isEraser ? null : () => viewModel.setColor(color),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Color(color),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected 
                      ? Theme.of(context).colorScheme.primary 
                      : Colors.grey.shade300,
                  width: isSelected ? 3 : 1,
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildWidthSlider(BuildContext context) {
    return Obx(() {
      final tool = viewModel.currentTool.value;
      double minWidth;
      double maxWidth;
      
      switch (tool.type) {
        case DrawingToolType.pen:
          minWidth = AppConstants.minPenWidth;
          maxWidth = AppConstants.maxPenWidth;
          break;
        case DrawingToolType.pencil:
          minWidth = AppConstants.minPencilWidth;
          maxWidth = AppConstants.maxPencilWidth;
          break;
        case DrawingToolType.marker:
          minWidth = AppConstants.minMarkerWidth;
          maxWidth = AppConstants.maxMarkerWidth;
          break;
        case DrawingToolType.eraser:
          minWidth = AppConstants.minEraserWidth;
          maxWidth = AppConstants.maxEraserWidth;
          break;
      }

      return Row(
        children: [
          const Icon(Icons.line_weight, size: 20),
          Expanded(
            child: Slider(
              value: tool.width.clamp(minWidth, maxWidth),
              min: minWidth,
              max: maxWidth,
              onChanged: viewModel.setWidth,
            ),
          ),
          SizedBox(
            width: 30,
            child: Text(
              tool.width.toStringAsFixed(1),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      );
    });
  }
}

class _ToolButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToolButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? Theme.of(context).colorScheme.primaryContainer 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected 
                  ? Theme.of(context).colorScheme.primary 
                  : Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isSelected 
                    ? Theme.of(context).colorScheme.primary 
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
