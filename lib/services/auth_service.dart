// import 'package:firebase_auth/firebase_auth.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   // Iniciar sesión con email y contraseña
//   Future<User?> signInWithEmailAndPassword(String email, String password) async {
//     try {
//       UserCredential result = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       User? user = result.user;
//       return user;
//     } catch (e) {
//       print("Error al iniciar sesión: $e");
//       return null;
//     }
//   }

//   // Cerrar sesión
//   Future<void> signOut() async {
//     return await _auth.signOut();
//   }
// }