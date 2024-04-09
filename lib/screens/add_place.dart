import 'package:favy_place/providers/user_places.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:favy_place/providers/user_places.dart';
import 'package:flutter/material.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceState();
}

class _AddPlaceState extends ConsumerState<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>(); //? Must have
  String _enteredTitle = "";

  void _savePlace() {
    bool validation = _formKey.currentState!.validate(); //* Must have

    if (validation) {
      _formKey.currentState!.save();
      //* basically save all form (do what the onSaved do on each form)

      ref.read(userPlacesNotifierProvider.notifier).addPlace(_enteredTitle);
      //? save the _enteredTitle from above into the provider

      //Todo add http request _isSending stuffs
      Navigator.of(context).pop();
      //*context is avaible in state class/ consumer state class
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a new favorite place!"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground),
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text(
                    "Title",
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "You must fill the text";
                  } else if (value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return "Must between 1 and 50 characters";
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  setState(() {
                    _enteredTitle = value!;
                  });
                },
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  _savePlace(); //? save the whole thing
                },
                icon: const Icon(Icons.add),
                label: const Text("Add Place"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
