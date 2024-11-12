import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/utils/app_styles.dart';
import '../../controller/admin_userlist_controller.dart';
import '../../data/models/admin_userlist_model.dart';

class AdminUsers extends ConsumerWidget {
  const AdminUsers({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userControllerProvider);

    // Fetch users when the widget is first built
    ref.read(userControllerProvider.notifier).getUsers();

    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: userState.when(
        data: (users) {
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final UserModel user = users[index];
              return Card(
                color: darkBlueColor.withOpacity(0.6), // Adjust the background color here
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(user.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(user.address),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: blueColor),
                          onPressed: () {
                            _showEditUserDialog(context, user, ref);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deleteUser(context, user, ref);
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      _showUserDetails(context, user);
                    },
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          print('Error Displaying Users: $error'); // Add logging to check the error
          return Center(child: Text('Error: $error'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddUserDialog(context, ref);
        },
        backgroundColor: purpleColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Show User Details Dialog
  void _showUserDetails(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(user.fullName),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Phone Number: ${user.phoneNumber}'),
              Text('Email: ${user.email}'),
              Text('Address: ${user.address}'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // Show dialog to add a new user
  void _showAddUserDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Full Name')),
              TextField(controller: addressController, decoration: const InputDecoration(labelText: 'Address')),
              TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone Number')),
              TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
              TextField(controller: passwordController, decoration: const InputDecoration(labelText: 'Password')),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final newUser = UserModel(
                        fullName: nameController.text,
                        address: addressController.text,
                        phoneNumber: phoneController.text,
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      try {
                        final message = await ref.read(userControllerProvider.notifier).addUser(newUser);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                        Navigator.of(context).pop();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error adding user: $e')));
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show dialog to edit an existing user
  void _showEditUserDialog(BuildContext context, UserModel user, WidgetRef ref) {
    final nameController = TextEditingController(text: user.fullName);
    final addressController = TextEditingController(text: user.address);
    final phoneController = TextEditingController(text: user.phoneNumber);
    final emailController = TextEditingController(text: user.email);
    final passwordController = TextEditingController(text: user.password);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Full Name')),
              TextField(controller: addressController, decoration: const InputDecoration(labelText: 'Address')),
              TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone Number')),
              TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
              TextField(controller: passwordController, decoration: const InputDecoration(labelText: 'Password')),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final updatedUser = UserModel(
                        id: user.id,
                        fullName: nameController.text,
                        address: addressController.text,
                        phoneNumber: phoneController.text,
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      try {
                        final message = await ref.read(userControllerProvider.notifier).updateUser(user.id!, updatedUser);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                        Navigator.of(context).pop();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating user: $e')));
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Delete a user
  void _deleteUser(BuildContext context, UserModel user, WidgetRef ref) async {
    try {
      final message = await ref.read(userControllerProvider.notifier).deleteUser(user.id!);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting user: $e')));
    }
  }
}