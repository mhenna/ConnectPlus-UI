import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_plus/models/BookPost.dart';
import 'package:connect_plus/models/BookRequest.dart';
import 'package:connect_plus/utils/enums.dart';

class BookSwapServices {
  FirebaseFirestore _fs = FirebaseFirestore.instance;

  Future<List<BookPost>> getAvailablePosts({currentUserId}) async {
    QuerySnapshot snapshot = await _fs
        .collection('book-posts')
        .where('postStatus',
            isEqualTo: bookPostStatusValues[BookPostStatus.approvedByAdmin])
        .orderBy("postedAt", descending: true)
        .get();
    List<BookRequest> currentUserRequests= await getUserRequests(userId: currentUserId);
    Set<String> requestedBookIds=currentUserRequests.map((request) =>request.postId).toSet();
    List<BookPost> allPosts= snapshot.docs
        .map((doc) => BookPost.fromJson({...doc.data(), 'postId': doc.id}))
        .toList();
    List<BookPost> availablePosts=[];
    for(BookPost post in allPosts)
      {
       if(!requestedBookIds.contains(post.postId) && post.postedById!=currentUserId)
         availablePosts.add(post);
      }
    return availablePosts;
  }

  Future<List<BookPost>> getPendingAdminApprovalPosts() async {
    QuerySnapshot snapshot = await _fs
        .collection('book-posts')
        .where('postStatus',
            isEqualTo:
                bookPostStatusValues[BookPostStatus.pendingAdminApproval])
        .orderBy("postedAt", descending: true)
        .get();
    return snapshot.docs
        .map((doc) => BookPost.fromJson({...doc.data(), 'postId': doc.id}))
        .toList();
  }

  Future<List<BookPost>> getUserPosts({String userId}) async {
    QuerySnapshot snapshot = await _fs
        .collection('book-posts')
        .where('postedById', isEqualTo: userId)
        .orderBy("postedAt", descending: true)
        .get();
    return snapshot.docs
        .map((doc) => BookPost.fromJson({...doc.data(), 'postId': doc.id}))
        .toList();
  }

  Future<List<BookRequest>> getBookRequests({String postId}) async {
    QuerySnapshot snapshot = await _fs
        .collection('book-requests')
        .where('postId', isEqualTo: postId)
        .where('requestStatus',
            isNotEqualTo:
                bookRequestStatusValues[BookRequestStatus.rejectedByUser])
        .orderBy('requestedAt', descending: true)
        .get();
    return snapshot.docs
        .map(
            (doc) => BookRequest.fromJson({...doc.data(), 'requestId': doc.id}))
        .toList();
  }

  Future<List<BookRequest>> getUserRequests({String userId}) async {
    QuerySnapshot snapshot = await _fs
        .collection('book-requests')
        .where('requestedById', isEqualTo: userId)
        .orderBy('requestedAt', descending: true)
        .get();
    return snapshot.docs
        .map(
            (doc) => BookRequest.fromJson({...doc.data(), 'requestId': doc.id}))
        .toList();
  }

  Future<void> addBookPost({BookPost post}) async {
    await _fs.collection('book-posts').add(post.toJson());
  }


  Future<void> deleteBookPost({String postId}) async {
    await _fs.collection('book-posts').doc(postId).delete();
  }

  Future<void> deleteBookRequest({String requestId}) async {
    await _fs.collection('book-posts').doc(requestId).delete();
  }

  Future<void> addBookRequest({BookRequest request}) async {
    await _fs.collection('book-requests').add(request.toJson());
  }

  Future<void> updatePostStatus({String postId, BookPostStatus status}) async {
    DocumentReference ref = _fs.collection('book-posts').doc(postId);

    Map<String, dynamic> data = {
      'postStatus': bookPostStatusValues[status],
    };

    await ref.update(data);
  }

  Future<void> updateRequestStatus(
      {String requestId, BookRequestStatus status}) async {
    DocumentReference ref = _fs.collection('book-requests').doc(requestId);

    Map<String, dynamic> data = {
      'requestStatus': bookRequestStatusValues[status],
    };
    await ref.update(data);
  }

  Future<void> addBookSwapPoints({String userId, int points}) async {
    DocumentReference ref = _fs.collection('users').doc(userId);

    await ref.update({'bookSwapPoints': FieldValue.increment(points)});
  }

  Future<void> removeBookSwapPoints({String userId, int points}) async {
    DocumentReference ref = _fs.collection('users').doc(userId);

    await ref.update({'bookSwapPoints': FieldValue.increment(-points)});
  }
}
