import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../model/user_model.dart';


class UserController extends GetxController {
  // Reactive variable to hold user data (nullable)
  var user = Rxn<UserModel>();

  // Method to update the user data
  void setUser(UserModel newUser) {
    user.value = newUser; // Update the reactive variable
  }

  // Method to clear user data (e.g., during logout)
  void clearUser() {
    user.value = null; // Reset the reactive variable to null
  }
}
