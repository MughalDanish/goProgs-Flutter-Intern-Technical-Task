import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//User interface dialog page for adding budget category.
class AddCategoryDialog extends StatefulWidget {
  @override
  _AddCategoryDialogState createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  //Text Editing Controllers are used for text field values.
  final _categoryNameController = TextEditingController();
  final _budgetAmountController = TextEditingController();


  @override
  //Method to save values of 3 fields in firebase database.
  Future<void> _addCategory() async {
    if (_formKey.currentState?.validate() ?? false) // condition to check all field values are in valid format.
       {
      setState(() {
        _isSaving = true;
      });
      await FirebaseFirestore.instance.collection('budget_category').add({
        'category_name': _categoryNameController.text,
        'budget_amount': double.parse(_budgetAmountController.text),
        'total_spent_amount': 0.0,
      });
      Navigator.of(context).pop();
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(
            color: Colors.orange[400]!,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Add Budget Category',
                  style: TextStyle(color: Colors.white70,fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 16),

                //Text field for category name input

                TextFormField(
                  cursorColor: Colors.grey,
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
                  controller: _categoryNameController,
                  decoration: InputDecoration(
                    hintText: 'Enter category name',
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
                      return 'Please enter a category name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                //Text field for budget amount input

                TextFormField(
                  cursorColor: Colors.grey,
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
                  controller: _budgetAmountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter budget amount',
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
                      return 'Please enter a budget amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Close',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    /*
                    On save button click _addCategory function will call to store data in firebase database.
                    I have implement functionality to show circular progress indicator until data is store in
                    firebase database when user click on save button.
                    */
                    ElevatedButton(
                      onPressed: _isSaving ? null : _addCategory,
                      child: _isSaving
                          ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white70,
                          strokeWidth: 2,
                        ),
                      )
                          : Text('Save', style: TextStyle(color: Colors.black),),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


