import 'dart:convert';

BankAccountCurrent bankAccountCurrentFromJson(String str) =>
    BankAccountCurrent.fromJson(json.decode(str));

String bankAccountCurrentToJson(BankAccountCurrent data) =>
    json.encode(data.toJson());

class BankAccountCurrent {
  BankAccountCurrent({
    this.money,
  });

  int money;

  factory BankAccountCurrent.fromJson(Map<String, dynamic> json) =>
      BankAccountCurrent(
        money: json["money"],
      );

  Map<String, dynamic> toJson() => {
        "money": money,
      };
}
