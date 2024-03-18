import 'dart:math';

class Location {
  final double latitude;
  final double longitude;

  Location(this.latitude, this.longitude);
}

// Function to calculate distance between two locations using Haversine formula
double calculateDistance(Location location1, Location location2) {
  const double earthRadius = 6371; // Radius of the Earth in kilometers

  // Convert latitude and longitude from degrees to radians
  double lat1Radians = _degreesToRadians(location1.latitude);
  double lon1Radians = _degreesToRadians(location1.longitude);
  double lat2Radians = _degreesToRadians(location2.latitude);
  double lon2Radians = _degreesToRadians(location2.longitude);

  // Calculate differences between latitudes and longitudes
  double latDiff = lat2Radians - lat1Radians;
  double lonDiff = lon2Radians - lon1Radians;

  // Calculate the distance using Haversine formula
  double a = pow(sin(latDiff / 2), 2) +
      cos(lat1Radians) * cos(lat2Radians) * pow(sin(lonDiff / 2), 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  double distance = earthRadius * c;

  return distance;
}

// Function to convert degrees to radians
double _degreesToRadians(double degrees) {
  return degrees * pi / 180;
}

void location() {
  // Example location coordinates
  Location myLocation = Location(19.023626098143456, 73.19122238011761); // New York
  Location dbLocation = Location(19.01351446791695, 73.17060883772886); // San Francisco

  // Calculate the distance between my location and the database location
  double distance = calculateDistance(myLocation, dbLocation);
  print('Distance between my location and database location: $distance km');
}
