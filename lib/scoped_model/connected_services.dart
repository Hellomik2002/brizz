import 'package:firebase_database/firebase_database.dart';
//import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/Service.dart';

// mixin ProductsModel on Model {
//   List<Service> services = [];
//   bool isloading = false;

//   Future<Null> fetchProducts() async {
//     isloading = true;
//     notifyListeners();
//     services = [];

//     var services1 = await FirebaseDatabase.instance
//         .reference()
//         .child('recent')
//         .child('id')
//         .once();

//     if (services1.value == null) {
//     } else {
//       (services1.value as Map<dynamic, dynamic>)
//           .forEach((key, dynamic serviceData) {
//         // print(serviceData);
//         final Deatil_Service deatilService = Deatil_Service(
//           description: serviceData['details']['description'],
//           urls_images: serviceData['details']['urls_images'] != null
//               ? (serviceData['details']['urls_images'] as List<dynamic>)
//                   .map((dynamic obj) {
//                   return obj.toString();
//                 }).toList()
//               : [],
//         );
//         final Service service = Service(
//             id: serviceData['id'],
//             title: serviceData['title'],
//             rating: serviceData["rating"].toDouble(),
//             description: serviceData['description'],
//             address: serviceData['address'],
//             price: serviceData['price'].toDouble(),
//             urlImage: serviceData['urlImage'],
//             details: deatilService,
//             phoneNumber: serviceData['phoneNumber']);
//         services.add(service);
//       });
//     }
//     isloading = false;
//     notifyListeners(); //setState
//     return;
//   }

//   Future<Null> updateProduct(Service oldService, Service newService) async {
//     isloading = true;
//     notifyListeners();
//     await FirebaseDatabase.instance
//         .reference()
//         .child('recent')
//         .child('id')
//         .child(newService.id)
//         .update(
//       {
//         'id': newService.id,
//         'title': newService.title,
//         'rating': newService.rating,
//         'description': newService.description,
//         'address': newService.address,
//         'price': newService.price,
//         'urlImage': newService.urlImage,
//         'phoneNumber': newService.phoneNumber,
//         'details': {
//           'urls_images': newService.details.urls_images,
//           'description': newService.details.description,
//         }
//       },
//     );
//     isloading = false;
//     notifyListeners();
//   }

//   void check(bool value) {
//     isloading = value;
//     notifyListeners();
//   }
// }

// class MainModel extends Model with ProductsModel {}

class FilterModel extends Model {
  double minRating = 0;
  double maxRating = 10;
  double minPrice = 0;
  double maxPrice = 10000000;

  void setRating(double minRat, double maxRat) {
    minRating = minRat;
    maxRating = maxRat;
    notifyListeners();
  }

  void setPrice(double minPri, double maxPri) {
    minPrice = minPri;
    maxPrice = maxPri;
    notifyListeners();
  }
}
