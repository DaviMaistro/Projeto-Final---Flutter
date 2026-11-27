import 'package:flutter/material.dart';
const String fotoPerfil = 'https://media.licdn.com/dms/image/v2/D4D03AQGSVUUMd7nZJg/profile-displayphoto-crop_800_800/B4DZ9HVj7iK0AQ-/0/1783608266480?e=1797465600&v=beta&t=u7d7nI2Kcvg3ooUz-rtR7wq57MA41Uj-u8kPE508P0Y';
class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(fotoPerfil),
          ),
          const SizedBox(height: 16),
          const Text(
            'João Marcos',
            style: TextStyle(fontSize: 22),
          ),
        ],
      ),
    );
  }
}