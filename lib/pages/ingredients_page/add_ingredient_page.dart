import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:prodtrack/controllers/ingredients_controller.dart';
import 'package:prodtrack/controllers/supplier_controller.dart';
import 'package:prodtrack/models/Ingredient.dart';
import 'package:prodtrack/models/Supplier.dart';
import 'package:prodtrack/models/Und.dart';
import 'package:prodtrack/widgets/image_profile.dart';
import 'package:prodtrack/widgets/seach.dart'; // Asegúrate de importar estos modelos

class CreateIngredientView extends StatefulWidget {
  const CreateIngredientView({super.key});

  @override
  State<CreateIngredientView> createState() => _CreateIngredientViewState();
}

class _CreateIngredientViewState extends State<CreateIngredientView> {
  final IngredientsController ingredientsController =Get.put(IngredientsController());
  final SupplierController suppliersController =Get.put(SupplierController());

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityUsedController = TextEditingController();
  final TextEditingController _quantityInInventoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  XFile? _image;
  List<Und> undOptions = [
    Und("1", "kg", 1),
    Und("2", "g", 1000),
  ];
  Und? selectedUnit;
  Supplier? supplieSelected ;

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
    });
  }
    @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      suppliersController.filterSuppliers(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFdcdcdc),
      appBar: AppBar(
        backgroundColor: const Color(0xFFdcdcdc),
        title: const Text(
          "Crear Ingredientes",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.save,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              // Crear nuevo ingrediente

              try {
                Ingredient newIngredient = Ingredient(
                  name: _nameController.text,
                  quantityUsed: double.parse(_quantityUsedController.text),
                  quantityInInventory: double.parse(_quantityInInventoryController.text),
                  price: double.parse(_priceController.text),
                  supplier: supplieSelected , 
                  und: Und(
                    'Unidad de Medida',
                    '2', // ID de la unidad
                    1, // Valor de la unidad
                  ),
                );

                ingredientsController.addIngredient(newIngredient);
                Navigator.of(context).pop(); // Volver a la vista anterior
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${newIngredient.name} guardado")),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Error al guardar el ingrediente")),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child:          Column(
          children: [
            // Botón para agregar foto
            image(),
            const SizedBox(
              height: 30,
            ),
            _buildTextField(_nameController, "Nombre", Icons.person),
            _buildTextField(_quantityUsedController, "Cantidad Usada", Icons.numbers),
            _buildTextField(_quantityInInventoryController, "Cantidad en el Inventario", Icons.numbers),
            _buildTextField(_priceController, "Precio", Icons.attach_money),
           _buildDropdownButtonFormField(),
            const SizedBox(height: 10),
            const Text("Provedor seleccionado", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            widgetSupplerSeleted(),
            const SizedBox(height: 10),
            _buildISupplierSection(),
          ],
        ),
       )
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hint, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.black),
          ),
          filled: true,
          fillColor: const Color(0xFFcbcbcb),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0), // Padding around the icon
            child: Icon(icon, color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownButtonFormField() {
    return  DropdownButtonFormField<Und>(
      value: selectedUnit, // La unidad seleccionada actualmente
      hint: const Text("Seleccionar unidad"), // Texto predeterminado
      isExpanded: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: Colors.blue, width: 2.0),
        ),
        filled: true,
        fillColor:const Color(0xFFcbcbcb), // Fondo del dropdown
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 12.0,
        ),
      ),
      dropdownColor:const Color(0xFFcbcbcb), // Fondo del menú desplegable
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.grey, // Color del ícono desplegable
      ),
      items: undOptions.map((Und unit) {
        return DropdownMenuItem<Und>(
          value: unit,
          child: Text(
            unit.name,
            style: const TextStyle(fontSize: 16.0, color: Colors.black),
          ),
        );
      }).toList(),
      onChanged: (Und? newValue) {
        setState(() {
          selectedUnit = newValue;
        });
      },
    );
  }



  Widget widgetSupplerSeleted() {
    if(supplieSelected ==null) { 
      return const Text("Por favor seleciona un provedor", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red));
    }
    return Card(
          color: Colors.white, // Fondo blanco para la tarjet
          elevation: 4, // Elevación para dar un efecto de sombra
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      supplieSelected?.name ?? 'Nombre desconocido',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text("Telefono: ${supplieSelected?.phone}"),
                  ],
                ),
                IconButton(
                  icon: const  Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final confirmDelete = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Confirmar eliminación"),
                          content: Text("¿Estás seguro de que deseas eliminar a  ${supplieSelected?.name}?"),
                          actions: <Widget>[
                            TextButton(
                              child: const Text("Cancelar"),
                              onPressed: () {
                                Navigator.of(context).pop(false); // No confirmar
                              },
                            ),
                            TextButton(
                              child: const Text("Eliminar"),
                              onPressed: () {
                                
                                Navigator.of(context).pop(true); // Confirmar eliminación
                              },
                            ),
                          ],
                        );
                      },
                    );

                    // Si el usuario confirma, elimina el elemento
                    if (confirmDelete == true) {
                      setState(() { 
                        supplieSelected = null;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        );
  }

  Widget _buildISupplierSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      IconButton(
        icon: const Icon(Icons.add_circle, color: Colors.black, size: 60.0),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.9,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Barra superior con "X" para cerrar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Selecciona Provedor",
                          style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.black),
                          onPressed: () {
                            Navigator.of(context).pop(); // Cierra el diálogo
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10), // Espacio entre la barra y el contenido
                    // Campo de búsqueda
                    Container(
                      padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                      child: searchBar(_searchController, "Buscar proveedor"),
                    ),
                    const SizedBox(height: 10),
                    // Lista de ingredientes
                    Expanded(
                      child: Obx(() {
                        return ListView.builder(
                          itemCount: suppliersController.filteredSuppliers.length,
                          itemBuilder: (BuildContext context, int index) {
                            final supplier =
                                suppliersController.filteredSuppliers[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
                              child: ListTile(
                                onTap: () {
                                  setState(() {
                                    supplieSelected = supplier; 
                                  });
                                  Navigator.of(context).pop(); // Cierra el diálogo
                                },
                                title: Text(
                                  supplier.name,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 35, fontFamily: "Regular"),
                                ),
                                subtitle: Text(
                                  supplier.phone,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 20, fontFamily: "Regular"),
                                ),
                                leading: imageProfile(supplier),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.black,
                                  size: 20,
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    ],
  );
}


  Widget image() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap:
              _pickImage, // Permite seleccionar la imagen al tocar el contenedor
          child: Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              color: const Color(0xFFcbcbcb), // Color de fondo
              shape: BoxShape.circle, // Forma circular
              image: _image == null
                  ? null // No hay imagen seleccionada
                  : DecorationImage(
                      image:
                          FileImage(File(_image!.path)), // Imagen seleccionada
                      fit: BoxFit.cover, // Ajustar la imagen al contenedor
                    ),
            ),
            child: _image == null
                ? const Icon(
                    Icons.add_a_photo, // Icono de agregar imagen
                    color: Colors.black, // Color del icono
                    size: 80, // Tamaño del icono
                  )
                : null, // No muestra nada si hay imagen
          ),
        ),
      ],
    );
  }
}
