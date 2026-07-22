abstract class EventsFirestoreConstants {
  const EventsFirestoreConstants._();

  // Collections
  static const String eventsCollection = 'events';
  static const String categoriesCollection = 'categories';
  static const String citiesCollection = 'cities';

  // Common Fields
  static const String nameField = 'name';
  static const String createdAtField = 'createdAt';

  // Event Fields
  static const String eventTitleField = 'title';
  static const String eventDescriptionField = 'description';
  static const String eventCategoryIdField = 'categoryId';
  static const String eventCategoryNameField = 'categoryName';
  static const String eventCityIdField = 'cityId';
  static const String eventCityNameField = 'cityName';
  static const String eventDateField = 'date';
  static const String eventPriceField = 'price';
  static const String eventTotalCapacityField = 'totalCapacity';
  static const String eventAvailableSpotsField = 'availableSpots';
  static const String eventImageUrlField = 'image_url';
  static const String eventStatusField = 'status';

  // City Fields
  static const String cityDepartmentField = 'department';
}
