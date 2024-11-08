import 'package:flutter/material.dart';
import 'package:prodtrack/pages/ingredients_page/ingredients_page.dart';



class IngredientIndexPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Número de pestañas
      child: Scaffold(
        appBar:AppBar(
          title:const  Text("Ingredientes"),
          backgroundColor: Colors.white,
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(40.0), 
            child: Padding(
              padding:  EdgeInsets.only(bottom: 10.0), 
              child: TabBar(
                tabs: [
                  Tab(text: 'Insumos'),
                  Tab(text: 'Envases'),
                  Tab(text: 'Cajas'),
                ],
              ),
            ),
          ),
        ),
        body:  TabBarView(
          children: [
            Center(child: IngredientsPage()),
            
            const Center(child: Text("Vista de envases")),
            
            const Center(child: Text("Vista de cajas")),
          ],
        ),
      ),
    );
  }
}
