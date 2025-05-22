import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String userId;
  final String postText;
  final String? postImage;
  final double latitude;
  final double longitude;


  Post({
    required this.id,
    required this.postText,
    this.postImage,
    required this.latitude,
    required this.longitude,
  required this.userId,
  });

  factory Post.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Post(
      id: data['id'],
      userId:data['userId'] ,
      postText: data['title'],
      postImage: data['image'],
      latitude: data['latitude'] ?? 0.0,
      longitude: data['longitude'] ?? 0.0,

    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'postText': postText,
      'postImage': postImage,
      'latitude': latitude,
      'longitude': longitude,
       'userId': userId ,
    };
  }
}




class Comment {
  final String username;
  final String commentText;
  final DateTime commentDate;

  Comment({
    required this.username,
    required this.commentText,
    required this.commentDate,
  });

  factory Comment.fromMap(Map<String, dynamic> data) {
    return Comment(
      username: data['username'],
      commentText: data['commentText'],
      commentDate: (data['commentDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'commentText': commentText,
      'commentDate': Timestamp.fromDate(commentDate),
    };
  }
}
