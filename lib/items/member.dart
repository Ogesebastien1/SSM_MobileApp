class MemberItem {
  String id;
  String fullName;
  String username;
  String initials;
  bool showFullName;

  MemberItem({required this.id, required this.fullName, required this.username, required this.initials, this.showFullName = false});

  factory MemberItem.fromMap(Map<String, dynamic> map) {
    
    String firstName = map['fullName'].split(' ')[0]; // Extract first name
    String lastName = map['fullName'].split(' ').last; // Extract last name
    String initials = '${firstName[0]}${lastName[0]}'; // Concatenate initials

    return MemberItem(
      id: map['id'], //'id' is the key in the response
      fullName: map['fullName'],
      username: map['username'],
      initials: initials,
    );
  }
}