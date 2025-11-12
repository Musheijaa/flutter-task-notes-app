import 'package:flutter/material.dart';
import 'package:task_notes_manager/models/task_item.dart';
import 'package:task_notes_manager/theme.dart';
import 'package:task_notes_manager/constants.dart';

/// Reusable widget for displaying task information in a card format
///
/// Shows task title, priority badge, truncated description,
/// and completion checkbox with elegant styling and animations.
class TaskCard extends StatelessWidget {
  final TaskItem task;
  final VoidCallback? onTap;
  final Function(bool?)? onCompletionChanged;
  final VoidCallback? onDelete;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onCompletionChanged,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Semantics(
      label: '${task.title}, ${task.priority} priority${task.isCompleted ? ', completed' : ', pending'}',
      hint: task.description.isNotEmpty ? 'Tap to expand description' : null,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: AppConstants.defaultMargin, vertical: 8),
        decoration: BoxDecoration(
          color: task.isCompleted
              ? colorScheme.surfaceContainer.withValues(alpha: 0.5)
              : colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
            child: Padding(
              padding: EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row with checkbox and priority badge
                  Row(
                    children: [
                      // Completion checkbox
                      Semantics(
                        label: task.isCompleted ? 'Mark as incomplete' : 'Mark as complete',
                        child: Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                            value: task.isCompleted,
                            onChanged: onCompletionChanged,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            activeColor: colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Task title
                      Expanded(
                        child: Text(
                          task.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: task.isCompleted
                                ? colorScheme.onSurface.withValues(alpha: 0.6)
                                : colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Priority badge
                      _buildPriorityBadge(context),

                      // Delete button
                      if (onDelete != null) ...[
                        const SizedBox(width: 8),
                        Semantics(
                          label: 'Delete task',
                          button: true,
                          child: IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              size: AppConstants.smallIconSize,
                              color: colorScheme.error.withValues(alpha: 0.7),
                            ),
                            onPressed: onDelete,
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      ],
                    ],
                  ),

                  // Description (if available)
                  if (task.description.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 48),
                      child: Text(
                        task.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build priority badge with appropriate color and style
  Widget _buildPriorityBadge(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Color badgeColor;
    Color textColor;

    switch (task.priority.toLowerCase()) {
      case 'high':
        badgeColor = SemanticColors.priorityHigh(context);
        textColor = Colors.white;
        break;
      case 'medium':
        badgeColor = SemanticColors.priorityMedium(context);
        textColor = Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : const Color(0xFF1A1A1A);
        break;
      case 'low':
      default:
        badgeColor = SemanticColors.priorityLow(context);
        textColor = Colors.white;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: task.isCompleted ? 0.4 : 1.0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getPriorityIcon(task.priority),
            size: 12,
            color: textColor.withValues(alpha: task.isCompleted ? 0.6 : 1.0),
          ),
          const SizedBox(width: 4),
          Text(
            task.priority,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: textColor.withValues(alpha: task.isCompleted ? 0.6 : 1.0),
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPriorityIcon(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Icons.keyboard_arrow_up;
      case 'medium':
        return Icons.remove;
      case 'low':
      default:
        return Icons.keyboard_arrow_down;
    }
  }
}

/// Animated loading placeholder for task cards
class TaskCardSkeleton extends StatelessWidget {
  const TaskCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppConstants.defaultMargin, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: colorScheme.outline.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 16,
                    decoration: BoxDecoration(
                      color: colorScheme.outline.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 60,
                  height: 20,
                  decoration: BoxDecoration(
                    color: colorScheme.outline.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Container(
                height: 12,
                width: double.infinity * 0.8,
                decoration: BoxDecoration(
                  color: colorScheme.outline.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}