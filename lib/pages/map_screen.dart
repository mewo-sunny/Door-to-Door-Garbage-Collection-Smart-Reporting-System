import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

// Change the class name to MapScreen to match the filename.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  Position? _currentPosition;

  bool _isAddingLocation = false;
  LatLng? _centerPinLocation;
  final TextEditingController _locationNameController = TextEditingController();

  late AnimationController _pulseController;
  LatLng? _searchedLocation;

  double _sheetPosition = 0.15;

  final List<CollectionPoint> _allCollectionPoints = [
    CollectionPoint(
      id: '1',
      address: 'Rosary College, Navelim',
      position: LatLng(15.286, 73.969),
      collectionDate: DateTime.now(),
    ),
    CollectionPoint(
      id: '2',
      address: 'Apollo Pharmacy, Navelim',
      position: LatLng(15.289, 73.971),
      collectionDate: DateTime.now(),
    ),
  ];

  List<CollectionPoint> _filteredPoints = [];

  @override
  void initState() {
    super.initState();
    _setupInitial();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  Future<void> _setupInitial() async {
    await _determinePosition();
    _filterForTodaysRoute();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _locationNameController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _filterForTodaysRoute() {
    final today = DateTime.now();
    setState(() {
      _filteredPoints = _allCollectionPoints
          .where(
            (point) => point.collectionDate.day == today.day,
          )
          .toList();
    });
  }

  Future<void> _determinePosition() async {
    // ... permission logic
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (!mounted) return;
      setState(() {
        _currentPosition = position;
      });
      _animatedMapMove(
        LatLng(
          position.latitude,
          position.longitude,
        ),
        16.0,
      );
    } catch (e) {
      debugPrint("Error getting location: $e");
    }
  }

  Future<void> _searchAndGoToLocation() async {
    final query = _searchController.text;
    if (query.isEmpty) return;

    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1&countrycodes=in',
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'com.example.waste_management',
        },
      );
      if (!mounted) return;

      if (response.statusCode == 200) {
        final results = json.decode(
          response.body,
        );
        if (results.isNotEmpty) {
          final lat = double.parse(results[0]["lat"]);
          final lon = double.parse(results[0]["lon"]);
          final searchedPosition = LatLng(lat, lon);

          setState(() {
            _searchedLocation = searchedPosition;
          });

          _animatedMapMove(
            searchedPosition,
            17.0,
          );

          Future.delayed(
            const Duration(seconds: 4),
            () {
              if (mounted) {
                setState(() {
                  _searchedLocation = null;
                });
              }
            },
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location not found'),
            ),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error finding location: $e'),
        ),
      );
    }
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    final latTween = Tween<double>(
      begin: _mapController.camera.center.latitude,
      end: destLocation.latitude,
    );
    final lngTween = Tween<double>(
      begin: _mapController.camera.center.longitude,
      end: destLocation.longitude,
    );
    final zoomTween = Tween<double>(
      begin: _mapController.camera.zoom,
      end: destZoom,
    );

    final controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    final Animation<double> animation = CurvedAnimation(
      parent: controller,
      curve: Curves.fastOutSlowIn,
    );

    controller.addListener(() {
      _mapController.move(
        LatLng(
          latTween.evaluate(animation),
          lngTween.evaluate(animation),
        ),
        zoomTween.evaluate(animation),
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  void _toggleAddLocationMode() {
    setState(() {
      _isAddingLocation = !_isAddingLocation;
      _centerPinLocation = _isAddingLocation ? _mapController.camera.center : null;
    });
  }

  void _confirmAddLocation() async {
    if (_centerPinLocation == null) return;

    final String? locationName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Name New Collection Point'),
        content: TextField(
          controller: _locationNameController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'e.g., "Main Street Bin"',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(
              context,
              _locationNameController.text,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (locationName != null && locationName.isNotEmpty) {
      final newPoint = CollectionPoint(
        id: DateTime.now().toString(),
        address: locationName,
        position: _centerPinLocation!,
        collectionDate: DateTime.now(),
      );
      setState(() {
        _allCollectionPoints.add(newPoint);
        _filterForTodaysRoute();
        _isAddingLocation = false;
        _centerPinLocation = null;
      });
      _locationNameController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onSubmitted: (_) => _searchAndGoToLocation(),
          decoration: InputDecoration(
            hintText: 'Search location...',
            filled: true,
            fillColor: Colors.grey[200],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 5,
            ),
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1.0,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentPosition != null
                  ? LatLng(
                      _currentPosition!.latitude,
                      _currentPosition!.longitude,
                    )
                  : const LatLng(15.286, 73.969),
              initialZoom: 16.0,
              onPositionChanged: (position, hasGesture) {
                if (_isAddingLocation) {
                  setState(() {
                    _centerPinLocation = position.center;
                  });
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.waste_management',
              ),
              if (_searchedLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80,
                      height: 80,
                      point: _searchedLocation!,
                      child: PulsingCircleMarker(
                        controller: _pulseController,
                      ),
                    ),
                  ],
                ),
              MarkerLayer(
                markers: _filteredPoints
                    .map(
                      (point) => Marker(
                        width: 120,
                        height: 70,
                        point: point.position,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                point.address,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(
                              FontAwesomeIcons.mapPin,
                              color: point.isCollected ? Colors.green : Colors.red,
                              size: 25,
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
          if (_isAddingLocation)
            const Center(
              child: Icon(
                FontAwesomeIcons.locationCrosshairs,
                color: Colors.blue,
                size: 40,
              ),
            ),
          Positioned(
            bottom: 30,
            right: 15,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'zoomIn',
                  onPressed: () => _animatedMapMove(
                    _mapController.camera.center,
                    _mapController.camera.zoom + 1,
                  ),
                  backgroundColor: Colors.white,
                  mini: true,
                  child: const Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'zoomOut',
                  onPressed: () => _animatedMapMove(
                    _mapController.camera.center,
                    _mapController.camera.zoom - 1,
                  ),
                  backgroundColor: Colors.white,
                  mini: true,
                  child: const Icon(
                    Icons.remove,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                FloatingActionButton(
                  heroTag: 'myLocation',
                  onPressed: _determinePosition,
                  backgroundColor: Colors.white,
                  child: const Icon(
                    Icons.my_location,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: (screenHeight * _sheetPosition) + 20 - safeAreaBottom,
            left: 15,
            right: 15,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              ),
              child: _isAddingLocation
                  ? Row(
                      key: const ValueKey('confirm_buttons'),
                      children: [
                        FloatingActionButton(
                          onPressed: _toggleAddLocationMode,
                          backgroundColor: Colors.white,
                          child: const Icon(
                            Icons.close,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _confirmAddLocation,
                            icon: const Icon(
                              Icons.check,
                            ),
                            label: const Text(
                              'Confirm This Location',
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                              ),
                              shape: const StadiumBorder(),
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    )
                  : FloatingActionButton.extended(
                      key: const ValueKey('add_button'),
                      onPressed: _toggleAddLocationMode,
                      backgroundColor: Colors.blue[800],
                      icon: const Icon(
                        Icons.add_location_alt_outlined,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Add Point',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
            ),
          ),
          NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              setState(() {
                _sheetPosition = notification.extent;
              });
              return true;
            },
            child: DraggableScrollableSheet(
              initialChildSize: 0.15,
              minChildSize: 0.1,
              maxChildSize: 1.0,
              snap: true,
              snapSizes: const [0.15, 0.5, 1.0],
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    controller: scrollController,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 5,
                          margin: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
                        child: Text(
                          "Today's Route",
                          style: GoogleFonts.inter(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ..._filteredPoints.map(
                        (point) => CheckboxListTile(
                          title: Text(
                            point.address,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          value: point.isCollected,
                          onChanged: (bool? value) {
                            setState(() {
                              point.isCollected = value!;
                            });
                          },
                          secondary: FaIcon(
                            FontAwesomeIcons.mapPin,
                            color: point.isCollected ? Colors.green : Colors.red,
                            size: 24,
                          ),
                          activeColor: Colors.green,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PulsingCircleMarker extends StatelessWidget {
  final AnimationController controller;
  const PulsingCircleMarker({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            for (int i = 0; i < 3; i++)
              Transform.scale(
                scale: (controller.value + (i * 0.3)) % 1.0,
                child: Opacity(
                  opacity: 1.0 - ((controller.value + (i * 0.3)) % 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue[800],
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class CollectionPoint {
  final String id;
  final String address;
  final LatLng position;
  final DateTime collectionDate;
  bool isCollected;

  CollectionPoint({
    required this.id,
    required this.address,
    required this.position,
    required this.collectionDate,
    this.isCollected = false,
  });
}