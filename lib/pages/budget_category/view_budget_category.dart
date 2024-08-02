import 'package:flutter/material.dart';
import 'package:goprogs_flutter_intern_task/pages/budget_category/add_budget_category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_budget_category.dart';

//User interface page for show all budget category list.
class ViewBudgetCategory extends StatefulWidget {
  const ViewBudgetCategory({super.key});

  @override
  State<ViewBudgetCategory> createState() => _ViewBudgetCategoryState();
}

class _ViewBudgetCategoryState extends State<ViewBudgetCategory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Center(
          child: Text(
            'Personal Budget',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.orange[400]),
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: Material(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 30, 29, 29),
                borderRadius: BorderRadius.circular(20)),

            /*
            This code will read all budget list from firebase database and
             show them on front page using ListView.
            */

            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('budget_category')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final categories = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return ListTile(
                        title: Text(
                          category['category_name'],
                          style: TextStyle(
                              color: Colors.white70, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Budgeted: \$${category['budget_amount']} ',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              TextSpan(
                                text: '|',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              TextSpan(
                                text: ' Spent: \$${category['total_spent_amount']}',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),

                        /*
                        When user click on this editing button then EditingBudgetCategory
                        Dialog Page will open on screen for taking input for new values and then
                        update them in firebase database.
                        */

                        trailing: IconButton(
                          onPressed: () => showDialog(
                              context: context,
                              builder: (context) => EditBudgetCategory(
                                  docId: category.id,
                                  currentName: category['category_name'],
                                  currentBudget: category['budget_amount'])),
                          icon: Icon(
                            Icons.edit,
                            color: Colors.orange[400],
                            size: 20,
                          ),
                        ));
                  },
                );
              },
            ),
          ),
        ),
      ),

      /*
      This floating action button is used to add more categories
      in budget category list. When user click on that button then AddCategoryDialog
      dialog will open for taking required input values.
      */

      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AddCategoryDialog(),
        ),
        child: Icon(Icons.add),
        backgroundColor: Colors.orange[400],
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(10), // Adjust the border radius as needed
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
