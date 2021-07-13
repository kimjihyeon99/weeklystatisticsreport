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

  factory Getsaftyscore.fromJson(Map<String, dynamic> json){
    return Getsaftyscore(
      eco_avg: json['eco_avg'] as double,
      safe_avg: json['safe_avg'] as double,
      Date: json['Date'] as String,
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

  factory GetDrivingwarningscore.fromJson(Map<String, dynamic> json){
    return GetDrivingwarningscore(
      countEvent: json['countEvent'] as int,
      Date: json['Date'] as String,
    );
  }
}

class GetSpending {
  double PRICE;
  String CBOOK_CODE;

  GetSpending({
    this.PRICE,
    this.CBOOK_CODE,
  });

  factory GetSpending.fromJson(Map<String, dynamic> json){
    return GetSpending(
      PRICE: json['PRICE'] as double,
      CBOOK_CODE: json['CBOOK_CODE'] as String,
    );
  }
}
