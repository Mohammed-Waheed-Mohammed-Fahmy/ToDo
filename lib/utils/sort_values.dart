enum SortValues {
  defaultState("Default", "default"),
  deadline("Deadline", "deadline"),
  status("Status", "status"),
  todo("Todo name", "todo");

  const SortValues(this.label, this.value);

  final String label;
  final String value;
}
