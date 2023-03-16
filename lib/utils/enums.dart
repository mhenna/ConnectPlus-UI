enum BookPostStatus {
  pendingAdminApproval,
  approvedByAdmin,
  rejectedByAdmin,
  requestAccepted,
  handedOver,
  returned
}
final Map<BookPostStatus, String> bookPostStatusValues = {
  BookPostStatus.pendingAdminApproval: 'Pending Admin Approval',
  BookPostStatus.approvedByAdmin: 'Approved by Admin',
  BookPostStatus.rejectedByAdmin: 'Rejected by Admin',
  BookPostStatus.requestAccepted: 'Accepted User Request',
  BookPostStatus.handedOver: 'Handed Over to User',
  BookPostStatus.returned: 'Returned by User',
};
enum BookRequestStatus{
  pendingUserApproval,
  rejectedByUser,
  acceptedByUser,
  received,
  returned
}
final Map<BookRequestStatus, String> bookRequestStatusValues = {
  BookRequestStatus.pendingUserApproval: 'Pending User Approval',
  BookRequestStatus.rejectedByUser: 'Rejected by User',
  BookRequestStatus.acceptedByUser: 'Accepted by User',
  BookRequestStatus.received: 'Received from User',
  BookRequestStatus.returned: 'Returned to User',
};