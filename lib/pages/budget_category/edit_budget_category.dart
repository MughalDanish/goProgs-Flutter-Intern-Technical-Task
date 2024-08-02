import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

//User interface dialog page for editing budget category.
class EditBudgetCategory extends StatefulWidget {
  final String docId;
  final String currentName;
  final double currentBudget;

  const EditBudgetCategory(
      {super.key,
      required this.docId,
      required this.currentName,
      required this.currentBudget});

  @override
  State<EditBudgetCategory> createState() => _EditBudgetCategoryState();
}

class _EditBudgetCategoryState extends State<EditBudgetCategory> {
  final _formKey = GlobalKey<FormState>();
  bool _isConfirm = false;

  //Text Editing Controllers are used for text field values.
  late TextEditingController _NewCategoryNameController;
  late TextEditingController _NewBudgetAmountController;

  @override
  // This initState function will set the current values (values before updated) in the input fields.
  void initState() {
    super.initState();
    _NewCategoryNameController =
        TextEditingController(text: widget.currentName);
    _NewBudgetAmountController =
        TextEditingController(text: widget.currentBudget.toString());
  }

  @override
  //Method to update values of 2 fields in firebase database.

  Future<void> _editCategory() async {
    if (_formKey.currentState?.validate() ??
        false) // condition to check all field values are in valid format.
    {
      setState(() {
        _isConfirm = true;
      });
      try {
        await FirebaseFirestore.instance
            .collection('budget_category')
            .doc(widget.docId)
            .update({
          'category_name': _NewCategoryNameController.text,
          'budget_amount': double.parse(_NewBudgetAmountController.text),
        });
        Navigator.of(context).pop();
      } catch (e) {
        showToast(message: "Some error happend");
      } finally {
        setState(() {
          _isConfirm = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              width: 1.0,
              color: Colors.orange[400]!,
            )),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Edit Budget Category',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                      fontSize: 18),
                ),
                SizedBox(
                  height: 16,
                ),

                //Text field for new category name input

                TextFormField(
                  controller: _NewCategoryNameController,
                  style: TextStyle(
                      fontWeight: FontWeight.normal, color: Colors.grey),
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                    hintText: 'Enter new category name',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    fillColor: Color.fromARGB(255, 30, 29, 29),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a category name';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),

                //Text field for new budget amount input

                TextFormField(
                  controller: _NewBudgetAmountController,
                  style: TextStyle(
                      fontWeight: FontWeight.normal, color: Colors.grey),
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                    hintText: 'Enter new budget amount',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: Color.fromARGB(255, 30, 29, 29),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter budget amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please a enter valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        )),
                    /*
                    On Confirm button click _editCategory function will call to update data in firebase database.
                    I have implement functionality to show circular progress indicator until data is update in
                    firebase database when user click on Confirm button.
                    */
                    ElevatedButton(
                      onPressed: _isConfirm ? null : _editCategory,
                      child: _isConfirm
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white70,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Confirm',
                              style: TextStyle(color: Colors.black),
                            ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showToast({required String message}){
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0
  );
}