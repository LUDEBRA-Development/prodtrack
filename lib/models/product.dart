
import 'package:prodtrack/models/Box.dart';
import 'package:prodtrack/models/Ingredient.dart';
import 'package:prodtrack/models/Packing.dart';

class Product {
   String? id; 
  final String name;
  final String description;
  final Box box;
  int quantity;
  final Packing packing;
  final List<Ingredient> ingredients; 
  final double priceLabel;  
  final double priceLabeled;  

  // Constructor normal
  Product(this.id, this.name, this.description, this.quantity, this.packing, this.box, this.ingredients, this.priceLabel, this.priceLabeled);

  // Constructor adicional que permite asignar el ID de Firestore
  Product.withId(this.id, this.name, this.description, this.quantity, this.packing, this.box, this.ingredients, this.priceLabel, this.priceLabeled);

  // Método para convertir un objeto Product a un Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'box': box.toMap(), 
      'quantity': quantity,
      'packing': packing.toMap(),
      'ingredient': ingredients.map((input) => input.toMap()).toList(), 
      'priceLabel': priceLabel,
      'priceLabeled': priceLabeled,
    };
  }

  // Factory constructor para crear un Product a partir de un Map<String, dynamic>
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      null, // No asignamos id aquí
      map['name'],
      map['description'],
      map['quantity'],
      Packing.fromMap(map['packing']), 
      Box.fromMap(map['box']), 
      (map['ingredient'] as List).map((input) => Ingredient.fromMap(input)).toList(), 
      map['priceLabel'],
      map['priceLabeled'],
    );
  }


  Product copyWith({
    String? id,
    String? name,
    String? description,
    Box? box,
    int? quantity,
    Packing? packing,
    List<Ingredient>? ingredients,
    double? priceLabel,
    double? priceLabeled,
  }){
    return Product(
      id ?? this.id,
      name ?? this.name,
      description ?? this.description,
      quantity ?? this.quantity,
      packing ?? this.packing,
      box ?? this.box,
      ingredients ?? this.ingredients,
      priceLabel ?? this.priceLabel,
      priceLabeled ?? this.priceLabeled,
    );
  }

 //Precio total del producto fabricado (ejemplo: 140 Litros de esencia de kola valen $500.000)
  get _totalPriceInput{ 
    double totalPriceProduct = 0.0;
    ingredients.forEach((input){
      totalPriceProduct += input.totalPrice;
    });
    return  totalPriceProduct;
  }

 //Total del producto fabricado (ejemplo: 140 Litros de esencia de kola)
  get totalQuantityInput{ 
    double totalQuantityProduct = 0.0;
    ingredients.forEach((input){
      totalQuantityProduct += input.quantityUsed;
    });
    return  totalQuantityProduct;
  }




  // Calcula el precio unitario del producto fabricado.
  get _singlePrice{
    //obtener el valor de un 1ml
    double singlePriceInputLitro =  (1 * _totalPriceInput) / totalQuantityInput;  
    double singlePriceOutputMl = (singlePriceInputLitro /1000);
    //obtener el valor segun el empaque (Ejemplo: 500ml)
    double singlePrice = (singlePriceOutputMl * packing.und.value) + packing.price  + priceLabel + priceLabeled ; 

    return singlePrice;
  }
  

  //Precio total de producto ya empacado en las cajas. 
  get boxPrice{
    double labourPrice = 800; // precio de empacar una caja
    double priceBoxProduct = (_singlePrice * box.ability) + box.price + labourPrice + priceLabel ; //
    return priceBoxProduct;
  }

  get unitPrice {
    return boxPrice / box.ability;
  }

}