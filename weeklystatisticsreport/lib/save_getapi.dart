//////////////////////////Get class 가져온 정보 저장하는 공간
class Getsaftyscore {
  double eco_avg;
  double safe_avg;
  String Date;

  Getsaftyscore({
    this.eco_avg,
    this.safe_avg,
    this.Date,
  });

  factory Getsaftyscore.fromJson(Map<String, dynamic> json) {
    return Getsaftyscore(
      eco_avg: json['eco_avg'] as double,
      safe_avg: json['safe_avg'] as double,
      Date: json['Date'] as String,
    );
  }
}

//연료소모
class Getdaliyfuel {
  double DrvFuelUsement;
  String Date;

  Getdaliyfuel({
    this.DrvFuelUsement,
    this.Date,
  });

  factory Getdaliyfuel.fromJson(Map<String, dynamic> json) {
    return Getdaliyfuel(
      DrvFuelUsement: json['DrvFuelUsement'] as double,
      Date: json['Date'] as String,
    );
  }
}

//주행거리
class Getdrivingdistance {
  double RecDrvDisSum;

  Getdrivingdistance({
    this.RecDrvDisSum,
  });

  factory Getdrivingdistance.fromJson(Map<String, dynamic> json) {
    return Getdrivingdistance(
      RecDrvDisSum:
          json['RecDrvDisSum'].isNaN ? 0.0 : json['RecDrvDisSum'] as double,
    );
  }
}

class GetDrivingwarningscore {
  int countEvent;
  String Date;

  GetDrivingwarningscore({
    this.countEvent,
    this.Date,
  });

  factory GetDrivingwarningscore.fromJson(Map<String, dynamic> json) {
    return GetDrivingwarningscore(
      countEvent: json['countEvent'] as int,
      Date: json['Date'] as String,
    );
  }
}

class CountEventForEvent {
  String name;
  int count;

  CountEventForEvent({
    this.name,
    this.count,
  });
}

class GetSpending {
  String name;
  double cost;

  GetSpending({this.name, this.cost});
}

class GetInspection {
  String name;
  int replacement_cycle_distance;
  int usage_distance;
  int replacement_cycle_due;

  GetInspection(
      {this.name,
      this.replacement_cycle_distance,
      this.usage_distance,
      this.replacement_cycle_due});

  factory GetInspection.fromJson(Map<String, dynamic> json) {
    return GetInspection(
        name: json['name'] as String,
        replacement_cycle_distance: json['replacement_cycle_distance'] as int,
        usage_distance: json['usage_distance'] as int,
        replacement_cycle_due: json['replacement_cycle_due'] as int);
  }
}
