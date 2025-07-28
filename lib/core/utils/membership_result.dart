enum MembershipResult {
  none(message: 'user has no institution'),
  reject(message: 'user is rejected'),
  review(message: 'user is under review');

  final String message;
  const MembershipResult({required this.message});
}
