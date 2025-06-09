import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:plantoguard/constants.dart';
import 'package:plantoguard/services/storage_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String fullName = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final storedFullName = await StorageService.getFullName();

    setState(() {
      fullName = storedFullName ?? 'User';
      isLoading = false;
    });
  }

  Future<void> _logout() async {
    await StorageService.clearSession();
    const snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Logout Successful!',
        message: 'You have successfully logged out.',
        contentType: ContentType.success,
      ),
      duration: Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    await Future.delayed(const Duration(milliseconds: 600));

    Navigator.of(context).pushNamedAndRemoveUntil(
      '/login',
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/images/profile.jpg'),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      fullName.isNotEmpty ? fullName : 'Guest',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Constants.blackColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildProfileOption(Icons.logout, "Logout", _logout),
              ],
            ),
          );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon,
                    color: Constants.blackColor.withOpacity(0.5), size: 24),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    color: Constants.blackColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Icon(Icons.arrow_forward_ios,
                color: Constants.blackColor.withOpacity(.4), size: 16),
          ],
        ),
      ),
    );
  }
}