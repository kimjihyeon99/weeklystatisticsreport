//////////////////////////Get class 가져온 정보 저장하는 공간
//안전점수, 경제점수
class Getdrivingscore {
  double eco_avg;
  double safe_avg;
  String Date;

  Getdrivingscore({
    this.eco_avg,
    this.safe_avg,
    this.Date,
  });

  factory Getdrivingscore.fromJson(Map<String, dynamic> json) {
    return Getdrivingscore(
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

//운전스타일 경고 횟수
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

//이벤트별 운전스타일 경고 횟수 총합
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

//점검 필요항목
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
