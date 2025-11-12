import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_notes_manager/providers/task_provider.dart';
import 'package:task_notes_manager/widgets/task_card.dart';
import 'package:task_notes_manager/screens/add_task_screen.dart';
import 'package:task_notes_manager/models/task_item.dart';
import 'package:task_notes_manager/theme.dart';
import 'package:task_notes_manager/constants.dart';

/// Main screen displaying the task list and app controls
/// 
/// Features include theme toggle, task statistics, and
/// dynamic task list with completion tracking.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize provider when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with title and theme toggle
            _buildHeader(context),
            
            // Statistics section
            _buildStatistics(context),
            
            // Task list section
            Expanded(
              child: _buildTaskList(context),
            ),
          ],
        ),
      ),
      
      // Floating action button to add new tasks
      floatingActionButton: _buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  /// Build header section with app title and theme toggle
  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App title
          Text(
            UIText.appTitle,
            style: theme.textTheme.headlineLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Theme toggle switch
          Consumer<TaskProvider>(
            builder: (context, taskProvider, child) {
              return Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: SwitchListTile(
                  title: Text(
                    UIText.darkTheme,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    taskProvider.isDarkMode ? UIText.darkThemeEnabled : UIText.darkThemeDisabled,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  value: taskProvider.isDarkMode,
                  onChanged: (_) => taskProvider.toggleTheme(),
                  activeThumbColor: colorScheme.primary,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Build statistics section showing task counts
  Widget _buildStatistics(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Selector<TaskProvider, (int, int, int)>(
      selector: (context, provider) => (
        provider.tasks.length,
        provider.completedTasksCount,
        provider.pendingTasksCount,
      ),
      builder: (context, stats, child) {
        final totalTasks = stats.$1;
        final completedTasks = stats.$2;
        final pendingTasks = stats.$3;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: AppConstants.defaultMargin),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primaryContainer,
                colorScheme.primaryContainer.withValues(alpha: 0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              _buildStatCard(
                context,
                UIText.total,
                '$totalTasks',
                Icons.dashboard,
                colorScheme.primary,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                context,
                UIText.pending,
                '$pendingTasks',
                Icons.schedule,
                SemanticColors.warning(context),
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                context,
                UIText.completed,
                '$completedTasks',
                Icons.check_circle,
                SemanticColors.success(context),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build individual statistic card
  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: color.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build task list with loading and error states
  Widget _buildTaskList(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        // Show loading indicator
        if (taskProvider.isLoading) {
          return _buildLoadingState();
        }

        // Show error state
        if (taskProvider.error != null) {
          return _buildErrorState(taskProvider.error!);
        }

        // Show empty state
        if (taskProvider.tasks.isEmpty) {
          return _buildEmptyState();
        }

        // Show task list
        return _buildTaskListView(taskProvider.tasks);
      },
    );
  }

  /// Build loading state with skeleton cards
  Widget _buildLoadingState() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: 3,
            itemBuilder: (context, index) => const TaskCardSkeleton(),
          ),
        ),
      ],
    );
  }

  /// Build error state with retry option
  Widget _buildErrorState(String error) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: colorScheme.error.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 16),
            Text(
              UIText.oops,
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.read<TaskProvider>().loadTasks(),
              icon: const Icon(Icons.refresh),
              label: Text(UIText.retry),
            ),
          ],
        ),
      ),
    );
  }

  /// Build empty state when no tasks exist
  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment,
              size: 80,
              color: colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              UIText.noTasksYet,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              UIText.noTasksMessage,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Build scrollable task list
  Widget _buildTaskListView(List<TaskItem> tasks) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: tasks.length,
            padding: const EdgeInsets.only(bottom: 100),
            itemBuilder: (context, index) {
              final task = tasks[index];
              
              return TaskCard(
                task: task,
                onCompletionChanged: (value) {
                  context.read<TaskProvider>().toggleTaskCompletion(task);
                  
                  // Show snackbar for user feedback
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        task.isCompleted
                            ? SuccessMessages.taskMarkedPending
                            : SuccessMessages.taskCompleted,
                      ),
                      duration: AppConstants.snackbarShortDuration,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                onDelete: () => _showDeleteConfirmation(task),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Show confirmation dialog before deleting a task
  void _showDeleteConfirmation(TaskItem task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(UIText.deleteTask),
          content: Text(UIText.deleteTaskConfirmation.replaceFirst('this task', '"${task.title}"')),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(UIText.cancel),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final success = await context.read<TaskProvider>().deleteTask(task.id!);
                
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? SuccessMessages.taskDeleted
                            : ErrorMessages.taskDeletionError,
                      ),
                      duration: AppConstants.snackbarShortDuration,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: Text(UIText.delete),
            ),
          ],
        );
      },
    );
  }

  /// Build floating action button for adding new tasks
  Widget _buildFloatingActionButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return FloatingActionButton(
      onPressed: () => _navigateToAddTask(),
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      elevation: 8,
      child: const Icon(Icons.add, size: 28),
    );
  }

  /// Navigate to add task screen and refresh list on return
  Future<void> _navigateToAddTask() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTaskScreen(),
      ),
    );
    
    // Refresh task list if a new task was added
    if (result == true && mounted) {
      context.read<TaskProvider>().loadTasks();
    }
  }
}