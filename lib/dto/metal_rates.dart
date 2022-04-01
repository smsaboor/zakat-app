class MetalRates {
  final double silverRate;
  final double goldRate;

  MetalRates({
    this.silverRate=0.0,
    this.goldRate=0.0,
  });

  factory MetalRates.fromJson(Map<dynamic, dynamic> json) {
    return MetalRates(
      silverRate:
          json['items'][0]['xagPrice'] / 31.1034768, //convert ounce to gm
      goldRate: json['items'][0]['xauPrice'] / 31.1034768, //convert ounce to gm
    );
  }
}
