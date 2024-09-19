import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import '../components/my_drawer.dart';

class LocationManagementPage extends StatefulWidget {
  const LocationManagementPage({super.key});

  @override
  _LocationManagementPageState createState() => _LocationManagementPageState();
}

class _LocationManagementPageState extends State<LocationManagementPage> {
  final _formKey = GlobalKey<FormState>();
  final _locationNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _radiusController = TextEditingController();
  
  Position? _currentPosition;
  List<Map<String, dynamic>> _workLocations = [];

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
    _fetchWorkLocations();
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: $e')),
      );
    }
  }

  Future<void> _fetchWorkLocations() async {
    try {
      QuerySnapshot locationsSnapshot = await FirebaseFirestore.instance
          .collection('work_locations')
          .get();
      
      setState(() {
        _workLocations = locationsSnapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
            .toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching locations: $e')),
      );
    }
  }

  Future<void> _addWorkLocation() async {
    if (_formKey.currentState!.validate() && _currentPosition != null) {
      try {
        await FirebaseFirestore.instance.collection('work_locations').add({
          'name': _locationNameController.text,
          'address': _addressController.text,
          'latitude': _currentPosition!.latitude,
          'longitude': _currentPosition!.longitude,
          'radius': double.parse(_radiusController.text),
          'createdBy': FirebaseAuth.instance.currentUser!.uid,
          'createdAt': FieldValue.serverTimestamp(),
          'isActive': true,
        });

        _locationNameController.clear();
        _addressController.clear();
        _radiusController.clear();
        _fetchWorkLocations();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Work location added successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding location: $e')),
        );
      }
    }
  }

  Future<void> _deleteLocation(String locationId) async {
    try {
      await FirebaseFirestore.instance
          .collection('work_locations')
          .doc(locationId)
          .delete();
      
      _fetchWorkLocations();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting location: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Work Locations'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: const MyDrawer(role: 'Admin'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Add new location form
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add New Work Location',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _locationNameController,
                        decoration: const InputDecoration(
                          labelText: 'Location Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a location name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          labelText: 'Address',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _radiusController,
                        decoration: const InputDecoration(
                          labelText: 'Radius (meters)',
                          border: OutlineInputBorder(),
                          suffixText: 'm',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter radius';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      if (_currentPosition != null)
                        Text(
                          'Current Location: ${_currentPosition!.latitude.toStringAsFixed(6)}, ${_currentPosition!.longitude.toStringAsFixed(6)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: _fetchCurrentLocation,
                            icon: const Icon(Icons.my_location),
                            label: const Text('Use Current Location'),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: _currentPosition != null ? _addWorkLocation : null,
                            icon: const Icon(Icons.add_location),
                            label: const Text('Add Location'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Existing locations list
            Expanded(
              child: Card(
                elevation: 4,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Work Locations (${_workLocations.length})',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    Expanded(
                      child: _workLocations.isEmpty
                          ? const Center(
                              child: Text('No work locations added yet'),
                            )
                          : ListView.builder(
                              itemCount: _workLocations.length,
                              itemBuilder: (context, index) {
                                final location = _workLocations[index];
                                return ListTile(
                                  leading: const Icon(Icons.location_on),
                                  title: Text(location['name']),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(location['address']),
                                      Text(
                                        'Radius: ${location['radius']}m | Lat: ${location['latitude'].toStringAsFixed(4)}, Lng: ${location['longitude'].toStringAsFixed(4)}',
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _deleteLocation(location['id']),
                                  ),
                                  isThreeLine: true,
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _locationNameController.dispose();
    _addressController.dispose();
    _radiusController.dispose();
    super.dispose();
  }
}
// Location management update
// Location management
// Location management
