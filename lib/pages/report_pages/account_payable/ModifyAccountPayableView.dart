import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prodtrack/controllers/account_Payable_controller.dart';
import 'package:prodtrack/models/account_payable.dart';

class ModifyAccountPayableView extends StatefulWidget {
  final AccountPayable account; // Cuenta por pagar a modificar

  const ModifyAccountPayableView({super.key, required this.account});

  @override
  State<ModifyAccountPayableView> createState() => _ModifyAccountPayableViewState();
}

class _ModifyAccountPayableViewState extends State<ModifyAccountPayableView> {
  final AccountPayableController accountController = Get.put(AccountPayableController());
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.account.beneficiary.name;
    _amountController.text = widget.account.amount.toString();
    _dueDateController.text = widget.account.formattedDueDate;
    _statusController.text = widget.account.isPaid ? "Pagado" : "Pendiente";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFdcdcdc),
      appBar: AppBar(
        backgroundColor: const Color(0xFFdcdcdc),
        title: const Text(
          "Detalle de cuenta",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          bottomDelete() 
        ],
      ),
      body: Padding(
  padding: const EdgeInsets.all(16.0),
    child: SingleChildScrollView( 
      child: Column(
        children: [
          const SizedBox(height: 30),
          buildTextInput("Beneficiario :"),
          _buildTextField(_nameController, "Beneficiario", Icons.person),
          buildTextInput("Monto :"),
          _buildTextField(_amountController, "Monto", Icons.monetization_on),
          buildTextInput("Fecha de vencimiento :"),
          _buildTextField(_dueDateController, "Fecha de vencimiento", Icons.calendar_today),
          buildTextInput("Estado (Pagado/Pendiente) :"),
          _buildTextField(_statusController, "Estado (Pagado/Pendiente)", Icons.info),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPayButton(), 
              _buildAbonarButton(), 
            ],
          ),
        ],
      ),
  ),
),

    );
  }

Widget buildTextInput(String  text){
  return Padding(
    padding: const EdgeInsets.only(bottom: 10.0, top: 15.0),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
          text,
          style:const  TextStyle(
            fontSize: 18.0,
            color: Colors.black,
          ),
      ),
    )
  );
}

// Método para crear un TextField personalizado con color de borde personalizado
Widget _buildTextField(TextEditingController controller, String hint, IconData icon) {
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
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.grey), 
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.blue, width: 2.0), 
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
        ),
        filled: true,
        fillColor: const Color(0xFFcbcbcb),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Icon(icon, color: Colors.black), 
        ),
      ),
    ),
  );
}


  // Botón de eliminar cuenta por pagar
  Widget bottomDelete() {
    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.black, size: 50),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirmar eliminación"),
              content: Text("¿Está seguro de que desea eliminar la cuenta por pagar de ${widget.account.beneficiary.name}?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cerrar el diálogo
                  },
                  child: const Text("Cancelar"),
                ),
                TextButton(
                  onPressed: () {
                    accountController.deleteAccountPayable(widget.account.id.toString());
                    Navigator.of(context).pop(); // Cerrar el diálogo
                    Navigator.of(context).pop(); // Volver a la vista anterior
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Cuenta por pagar de ${widget.account.beneficiary.name} eliminada")),
                    );
                  },
                  child: const Text("Eliminar"),
                ),
              ],
            );
          },
        );
      },
    );
  }


// Botón de Pagar (Marcar como pagado)
Widget _buildPayButton() {
  return ElevatedButton.icon(
    onPressed: () async {
      // Cambiar el estado a pagado
      AccountPayable updatedAccount = AccountPayable(
        id: widget.account.id,
        beneficiary: widget.account.beneficiary,
        activity:  widget.account.activity,
        amount: widget.account.amount,
        dueDate: widget.account.dueDate,
        isPaid: true, // Marcar como pagado
      );

      await accountController.updateAccountPayable(updatedAccount);
      setState(() {
        _statusController.text = "Pagado";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Cuenta por pagar de ${updatedAccount.beneficiary.name} marcada como pagada")),
      );
    },
    icon: const Icon(Icons.payment, color: Colors.black,), 
    label: const Text("Pagar", style: TextStyle(color: Colors.black),),
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), 
      ),
      padding:const  EdgeInsets.symmetric(horizontal: 20, vertical: 15), 
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold ), 
    ),
  );
}

// Botón de Abonar (Realizar abono)
Widget _buildAbonarButton() {
  return ElevatedButton.icon(
    onPressed: () {
      _showAbonarDialog(); // Mostrar diálogo para abonar
    },
    icon: const Icon(Icons.attach_money, color: Colors.black,), // Icono de abono
    label: const Text("Abonar", style: TextStyle(color: Colors.black),),
    style: ElevatedButton.styleFrom(
// Color del texto
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Esquinas redondeadas
      ),
      padding:const  EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Espaciado interno
      textStyle:const  TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Estilo del texto
    ),
  );
}


  // Diálogo para realizar un abono
  void _showAbonarDialog() {
    final TextEditingController _abonoController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Abonar a la cuenta"),
          content: TextField(
            controller: _abonoController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Cantidad a abonar",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar diálogo
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                double abono = double.parse(_abonoController.text);
                double nuevoMonto = widget.account.amount - abono;

                AccountPayable updatedAccount = AccountPayable(
                  id: widget.account.id,
                  beneficiary: widget.account.beneficiary,
                  amount: nuevoMonto,
                  activity:  widget.account.activity,
                  dueDate: widget.account.dueDate,
                  isPaid: nuevoMonto <= 0, // Si el monto restante es 0, marcar como pagado
                );

                accountController.updateAccountPayable(updatedAccount);
                setState(() {
                  _amountController.text = nuevoMonto.toString();
                  _statusController.text = nuevoMonto <= 0 ? "Pagado" : "Pendiente";
                });
                Navigator.of(context).pop(); // Cerrar el diálogo
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Abono de $abono realizado a la cuenta de ${widget.account.beneficiary.name}")),
                );
              },
              child: const Text("Abonar"),
            ),
          ],
        );
      },
    );
  }
}
