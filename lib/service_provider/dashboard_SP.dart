import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_33/universal_components/project_logo.dart';

class Dashboard_SP extends StatefulWidget {
  const Dashboard_SP({super.key});

  @override
  State<Dashboard_SP> createState() => _Dashboard_SPState();
}

class _Dashboard_SPState extends State<Dashboard_SP> {
  final TextEditingController providerNameController =
      TextEditingController(text: "Tariq Al-Rashid");
  final int providerRating = 5;
  final TextEditingController reviewController = TextEditingController();

  @override
  void dispose() {
    providerNameController.dispose();
    reviewController.dispose();
    super.dispose();
  }

  Future<void> acceptServiceRequest(String docId, Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance.collection('acceptedProviders').add({
        'providerName': providerNameController.text,
        'services': data['services'] ?? [],
        'times': data['times'] ?? [],
        'rating': providerRating,
        'isAccepted': true,
        'timestamp': FieldValue.serverTimestamp(),
      });

      await FirebaseFirestore.instance
          .collection('serviceRequests')
          .doc(docId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request Accepted')),
      );
    } catch (e) {
      print("Error accepting service request: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error accepting request')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 20),
              SizedBox(height: 60, width: 60, child: logo()),
              const SizedBox(height: 20),
              const Text("Profile",
                  style: TextStyle(
                      fontSize: 25,
                      color: Color.fromARGB(255, 192, 228, 194),
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              buildProfileCard(),
              const SizedBox(height: 30),
              buildInfoCards(),
              const SizedBox(height: 30),
              buildRequestsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileCard() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/profile.jpg'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: providerNameController,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        providerRating,
                        (index) =>
                            const Icon(Icons.star, color: Colors.yellow),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _infoCard(
              title: 'Money made',
              value: '0\$',
              color: const Color.fromARGB(255, 192, 228, 194)),
          _infoCard(
              title: 'No. services today',
              value: '0',
              color: const Color(0xFF083B6F)),
        ],
      ),
    );
  }

  Widget buildRequestsSection() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(50),
        topRight: Radius.circular(50),
      ),
      child: Container(
        width: double.infinity,
        color: const Color.fromRGBO(22, 121, 171, 1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 30),
              child: Text(
                "Requests",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('serviceRequests')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("No requests at the moment.",
                        style: TextStyle(color: Colors.white)),
                  );
                }

                return Column(
                  children: snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final services =
                        (data['services'] as List?)?.join(", ") ?? '';
                    final times = (data['times'] as List?)?.join(", ") ?? '';

                    return Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(services,
                              style: const TextStyle(
                                  color: Color(0xFF083B6F),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                          const SizedBox(height: 8),
                          Text("ETA: $times",
                              style: const TextStyle(color: Colors.grey)),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.red[100],
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('serviceRequests')
                                      .doc(doc.id)
                                      .delete();
                                },
                                child: Text('Decline',
                                    style:
                                        TextStyle(color: Colors.red[800])),
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: const Color(0xFF083B6F),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () {
                                  acceptServiceRequest(doc.id, data);
                                },
                                child: const Text('Accept',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 400),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(
      {required String title, required String value, required Color color}) {
    return Container(
      height: 128,
      width: 180,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title,
              style:
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
