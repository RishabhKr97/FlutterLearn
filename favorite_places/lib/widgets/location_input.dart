import 'package:favorite_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectedLocation});

  final void Function(PlaceLocation) onSelectedLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _selectedLocation;
  var isGettingLocation = false;

  String get locationImage {
    // final lat = _selectedLocation!.latitude;
    // final long = _selectedLocation!.longitude;
    // return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$long&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$long&key=YOUR_API_KEY';

    return 'https://maps.googleapis.com/maps/api/staticmap?center=Brooklyn+Bridge,New+York,NY&zoom=13&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:S%7C40.702147,-74.015794&markers=color:green%7Clabel:G%7C40.711614,-74.012318&markers=color:red%7Clabel:C%7C40.718217,-73.998284&key=AIzaSyA3kg7YWugGl1lTXmAmaBGPNhDW9pEh5bo&signature=GJnbP6sQrFY1ce8IsvG2WR2P0Jw=';
  }

  void _getUserLocation() async {
    Location location = new Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      isGettingLocation = true;
    });

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final long = locationData.longitude;

    if (lat == null || long == null) {
      return;
    }

    // final url = Uri.parse(
    //   'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=YOUR_API_KEY',
    // );
    // final response = await http.get(url);
    // final resData = json.decode(response.body);
    // final address = resData['results'][0]['formatted_address'];
    const address = '1600 Amphitheatre Parkway in Mountain View, California';

    setState(() {
      _selectedLocation = PlaceLocation(
        latitude: lat,
        longitude: long,
        address: address,
      );
      isGettingLocation = false;
    });

    widget.onSelectedLocation(_selectedLocation!);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewLocation = Text(
      'No Location Chosen',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
    );

    if (isGettingLocation) {
      previewLocation = const CircularProgressIndicator();
    }

    if (_selectedLocation != null) {
      previewLocation = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: previewLocation,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text('Get Current Location'),
              onPressed: _getUserLocation,
            ),
            TextButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text('Select On Map'),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
