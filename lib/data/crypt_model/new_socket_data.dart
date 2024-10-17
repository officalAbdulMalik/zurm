import 'dart:convert';

SocketDataModel socketDataModelFromJson(String str) => SocketDataModel.fromJson(json.decode(str));

String socketDataModelToJson(SocketDataModel data) => json.encode(data.toJson());

class SocketDataModel {
  String? socketDataModelE;
  dynamic e;
  String? s;
  String? socketDataModelP;
  String? p;
  String? w;
  String? x;
  String? socketDataModelC;
  String? q;
  String? socketDataModelB;
  String? b;
  String? socketDataModelA;
  String? a;
  String? socketDataModelO;
  String? h;
  String? socketDataModelL;
  String? v;
  String? socketDataModelQ;
  dynamic o;
  dynamic c;
  dynamic f;
  dynamic l;
  dynamic n;

  SocketDataModel({
    this.socketDataModelE,
    this.e,
    this.s,
    this.socketDataModelP,
    this.p,
    this.w,
    this.x,
    this.socketDataModelC,
    this.q,
    this.socketDataModelB,
    this.b,
    this.socketDataModelA,
    this.a,
    this.socketDataModelO,
    this.h,
    this.socketDataModelL,
    this.v,
    this.socketDataModelQ,
    this.o,
    this.c,
    this.f,
    this.l,
    this.n,
  });

  factory SocketDataModel.fromJson(Map<String, dynamic> json) => SocketDataModel(
    socketDataModelE: json["e"],
    e: json["E"],
    s: json["s"],
    socketDataModelP: json["p"],
    p: json["P"],
    w: json["w"],
    x: json["x"],
    socketDataModelC: json["c"],
    q: json["Q"],
    socketDataModelB: json["b"],
    b: json["B"],
    socketDataModelA: json["a"],
    a: json["A"],
    socketDataModelO: json["o"],
    h: json["h"],
    socketDataModelL: json["l"],
    v: json["v"],
    socketDataModelQ: json["q"],
    o: json["O"],
    c: json["C"],
    f: json["F"],
    l: json["L"],
    n: json["n"],
  );

  Map<String, dynamic> toJson() => {
    "e": socketDataModelE,
    "E": e,
    "s": s,
    "p": socketDataModelP,
    "P": p,
    "w": w,
    "x": x,
    "c": socketDataModelC,
    "Q": q,
    "b": socketDataModelB,
    "B": b,
    "a": socketDataModelA,
    "A": a,
    "o": socketDataModelO,
    "h": h,
    "l": socketDataModelL,
    "v": v,
    "q": socketDataModelQ,
    "O": o,
    "C": c,
    "F": f,
    "L": l,
    "n": n,
  };
}
