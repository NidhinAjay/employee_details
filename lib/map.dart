import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapApp extends StatefulWidget {
  @override
  _MapAppState createState() => _MapAppState();
}

class _MapAppState extends State<MapApp> {

  late GoogleMapController myController;
  static LatLng _center = const LatLng(11.0510,76.0711);
  MapType _mapView = MapType.normal;
  Set<Marker>_marker={};
  LatLng _newposition = _center;

  void _onMapCreated(GoogleMapController controller) {
    myController = controller;
  }

  void _view(){
    setState(() {
      _mapView=_mapView==MapType.normal?MapType.satellite:MapType.normal;
    });
  }

  void _marking(){
    setState(() {
      _marker.add(Marker(markerId:MarkerId(_newposition.toString()),position: _newposition));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter Maps '),
          backgroundColor: Colors.green,
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 10.0,

              ),
              markers: _marker,
              onCameraMove: (position) {
                _marking();
              },
              mapType: _mapView,
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Align(
                alignment: Alignment.topRight,
                child: FloatingActionButton(
                  onPressed: () {
                    _view();
                  },
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.map, size: 30.0),
                ),
              ),
            ),
          ],
        ),

    );
  }
}