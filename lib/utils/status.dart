import 'package:flutter/material.dart';

enum Status {
  open("Open", Colors.red),
  inProgress("In Progress", Colors.orange),
  done("Done", Colors.green);

  const Status(this.label, this.color);

  final String label;
  final Color color;

  int compareTo(Status other) {
    return this.index.compareTo(other.index);
  }

  static Status parse(String statusString) {
    switch (statusString) {
      case "Open":
        return Status.open;
      case "In Progress":
        return Status.inProgress;
      case "Done":
        return Status.done;
      default:
        return Status.open;
    }
  }
}
