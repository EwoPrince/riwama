enum PickupRequestEnum {
  household('household'),
  recyclables('recyclables'),
  hazardous('hazardous');

  const PickupRequestEnum(this.type);
  final String type;
}
// Using an extension
// Enhanced enums

extension ConvertPickupRequest on String {
  PickupRequestEnum toPickupEnum() {
    switch (this) {
      case 'hazardous':
        return PickupRequestEnum.hazardous;
      case 'recyclables':
        return PickupRequestEnum.recyclables;
      case 'household':
        return PickupRequestEnum.household;
      default:
        return PickupRequestEnum.household;
    }
  }
}
