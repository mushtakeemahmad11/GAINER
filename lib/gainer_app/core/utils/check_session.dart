
class CheckSession {
  Future<bool> isSessionExpired(int loginTime) async {

    int currentTime = DateTime.now().millisecondsSinceEpoch;
    const int fourHours = 4 * 60 * 60 * 1000;

    return (currentTime - loginTime) >= fourHours;
  }
}