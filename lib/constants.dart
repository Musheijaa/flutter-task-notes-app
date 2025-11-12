/// Application-wide constants for the Task Notes Manager app
class AppConstants {
  // Database constants
  static const String databaseName = 'tasks.db';
  static const int databaseVersion = 1;
  static const String tasksTable = 'tasks';

  // Column names
  static const String idColumn = 'id';
  static const String titleColumn = 'title';
  static const String priorityColumn = 'priority';
  static const String descriptionColumn = 'description';
  static const String isCompletedColumn = 'isCompleted';

  // Priority levels
  static const String priorityLow = 'Low';
  static const String priorityMedium = 'Medium';
  static const String priorityHigh = 'High';
  static const List<String> priorityOptions = [priorityLow, priorityMedium, priorityHigh];

  // SharedPreferences keys
  static const String themePreferenceKey = 'isDarkMode';

  // Validation constants
  static const int minTitleLength = 3;
  static const int maxTitleLength = 100;
  static const int maxDescriptionLength = 500;

  // UI constants
  static const double defaultBorderRadius = 12.0;
  static const double cardBorderRadius = 16.0;
  static const double buttonBorderRadius = 16.0;
  static const double defaultPadding = 16.0;
  static const double defaultMargin = 20.0;
  static const double iconSize = 24.0;
  static const double smallIconSize = 20.0;

  // Animation durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // Snackbar durations
  static const Duration snackbarShortDuration = Duration(seconds: 2);
  static const Duration snackbarLongDuration = Duration(seconds: 3);

  // Sample data
  static const List<Map<String, dynamic>> sampleTasks = [
    {
      titleColumn: 'Plan weekend activities',
      priorityColumn: priorityMedium,
      descriptionColumn: 'Research local events and make reservations for restaurants',
      isCompletedColumn: 0,
    },
    {
      titleColumn: 'Complete Flutter assignment',
      priorityColumn: priorityHigh,
      descriptionColumn: 'Implement task manager app with SQLite and theme switching',
      isCompletedColumn: 0,
    },
    {
      titleColumn: 'Buy groceries',
      priorityColumn: priorityLow,
      descriptionColumn: 'Milk, bread, fruits, vegetables for the week',
      isCompletedColumn: 1,
    },
  ];
}

/// Error messages for user feedback
class ErrorMessages {
  static const String genericError = 'An unexpected error occurred. Please try again.';
  static const String networkError = 'Network connection error. Please check your connection.';
  static const String databaseError = 'Database error. Please restart the app.';
  static const String validationError = 'Please check your input and try again.';
  static const String taskCreationError = 'Failed to create task. Please try again.';
  static const String taskUpdateError = 'Failed to update task. Please try again.';
  static const String taskDeletionError = 'Failed to delete task. Please try again.';
  static const String taskLoadError = 'Failed to load tasks. Please try again.';
}

/// Success messages for user feedback
class SuccessMessages {
  static const String taskCreated = 'Task created successfully!';
  static const String taskUpdated = 'Task updated successfully!';
  static const String taskDeleted = 'Task deleted successfully!';
  static const String taskCompleted = 'Task completed! 🎉';
  static const String taskMarkedPending = 'Task marked as pending';
}

/// UI text constants
class UIText {
  static const String appTitle = 'Task Notes Manager';
  static const String addNewTask = 'Add New Task';
  static const String createTask = 'Create Task';
  static const String creatingTask = 'Creating Task...';
  static const String taskTitleLabel = 'Task Title *';
  static const String taskTitleHint = 'Enter task title...';
  static const String priorityLabel = 'Priority Level';
  static const String descriptionLabel = 'Description (Optional)';
  static const String descriptionHint = 'Add more details about this task...';
  static const String markAsCompleted = 'Mark as Completed';
  static const String markAsCompletedSubtitle = 'Check this if the task is already completed';
  static const String darkTheme = 'Dark Theme';
  static const String darkThemeEnabled = 'Enabled';
  static const String darkThemeDisabled = 'Disabled';
  static const String total = 'Total';
  static const String pending = 'Pending';
  static const String completed = 'Completed';
  static const String noTasksYet = 'No tasks yet!';
  static const String noTasksMessage = 'Tap the + button to create your first task\nand start organizing your life.';
  static const String deleteTask = 'Delete Task';
  static const String deleteTaskConfirmation = 'Are you sure you want to delete this task?';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String retry = 'Retry';
  static const String oops = 'Oops! Something went wrong';
  static const String formInstruction = 'Fill out the details below to create a new task. The title is required, but you can add more details to help organize your work.';
  static const String titleRequired = 'Please enter a task title';
  static const String titleTooShort = 'Title must be at least 3 characters long';
  static const String titleTooLong = 'Title must be less than 100 characters';
  static const String descriptionTooLong = 'Description must be less than 500 characters';
}