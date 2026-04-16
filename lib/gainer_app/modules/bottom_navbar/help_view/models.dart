
class IssueModel {
  final int issueId;
  final String issue;

  IssueModel({required this.issueId, required this.issue});

  factory IssueModel.fromJson(Map<String, dynamic> json) {
    return IssueModel(
      issueId: json['IssueID'],
      issue: json['Issue'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'IssueID': issueId,
      'Issue': issue,
    };
  }
}

class SubIssueModel {
  final int subIssueId;
  final String subIssue;

  SubIssueModel({required this.subIssueId, required this.subIssue});

  factory SubIssueModel.fromJson(Map<String, dynamic> json) {
    return SubIssueModel(
      subIssueId: json['subissueid'],
      subIssue: json['subissue'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subissueid': subIssueId,
      'subissue': subIssue,
    };
  }
}
