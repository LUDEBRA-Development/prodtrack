import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prodtrack/pages/report_pages/account_payable/accounts_payable.dart';
class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:const Color(0xFF00875E),
        title: const Center(child: Text("Informes",
          style: TextStyle(
            fontSize: 50,
            fontFamily: "Regular",
            color: Colors.white
          ),
        )),
      ),
      backgroundColor:const  Color(0xFFDCDCDC),
      body: 
      Center( 
        
        child: Column(
          children: [
            report("Mis Finanzas", "Cuentas Por Pagar", Icons.account_balance_wallet, "Análisis De Gastos", Icons.bar_chart),
            report("Mi  Empresa ", "Precio De Productos", Icons.price_check, "Análisis De Ventas", Icons.insights),
          ],
        )
      ),
    );
  }
}


Widget report (String titleReport, String item1, IconData icon1,  String item2, IconData icon2){
  return Padding(
    padding: const EdgeInsets.only(top: 30.0, bottom: 20.0, left:8.0, right: 8.0),
    child: Center(
      child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFcbcbcb),
            borderRadius: BorderRadius.circular(20.0)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              title(titleReport),
              textInfo(item1, icon1),
              textInfo(item2, icon2),
            ],
          ),
        
      ),
    ),
  );

}

Widget  title(String titleReport) {
  return Container(
    decoration: const  BoxDecoration(
      color:   Color(0xFFA0A0A0),
      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
    ),
    child: Padding( 
      padding: const EdgeInsets.only(right: 150, left:20, bottom:10.0, top:10.0),
      child:  Text(titleReport, style:const TextStyle( 
        color: Colors.black,
        fontSize: 35)
      ), 
    ),
  );
}

Widget textInfo(String itemReport, IconData icon){
  return Container(
    padding:const  EdgeInsets.only(bottom: 25.0, top: 12.0  ),
    child: ElevatedButton.icon(
      onPressed: (){Get.to(()=> AccountsPayableView());}, 
      label:  Text(
        itemReport,
        style:const  TextStyle(
          fontSize: 28,
          color: Colors.black
        ),
      ),
      icon: Icon(icon, size: 40, color: const Color(0xFF00875E),),
      style: ElevatedButton.styleFrom(
        shape:const  RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        minimumSize:const  Size(100, 60),
        backgroundColor: const Color(0xFFcbcbcb),
      )
    
      ),
  );
}