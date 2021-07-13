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
