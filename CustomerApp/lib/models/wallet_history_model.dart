class WalletHistoryModel {
  String? amountAdded;
  String? amountDeducted;
  String? paymentId;
  String? uid;
  String? timeAdded;
  String? itemTitle;
  String? itemType;
  String? itemDetails;
  String? itemImage;
  String? unitPrice;
  String? unitQuantity;

  WalletHistoryModel(
      {this.amountAdded,
      this.amountDeducted,
      this.paymentId,
      this.uid,
      this.timeAdded,
      this.itemTitle,
      this.itemType,
      this.itemDetails,
      this.itemImage,
      this.unitPrice,
      this.unitQuantity});

  WalletHistoryModel.fromJson(Map<dynamic, dynamic> json) {
    amountAdded = json["amountAdded"];
    amountDeducted = json["amountDeducted"];
    paymentId = json["paymentId"];
    uid = json["uid"];
    timeAdded = json["timeAdded"];
    itemTitle = json["itemTitle"];
    itemType = json["itemType"];
    itemDetails = json["itemDetails"];
    itemImage = json["itemImage"];
    unitPrice = json["unitPrice"];
    unitQuantity =( json["unitQuantity"]??0).toString();
  }

  Map<String, dynamic> toJson() => {
        'amountAdded': amountAdded,
        'amountDeducted': amountDeducted,
        'paymentId': paymentId,
        'uid': uid,
        'timeAdded': timeAdded,
        'itemTitle': itemTitle,
        'itemType': itemType,
        'itemDetails': itemDetails,
        'itemImage': itemImage,
        'unitQuantity': unitQuantity,
        'unitPrice': unitPrice
      };
}
