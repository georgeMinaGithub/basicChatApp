class MessageModel
{
  late String receiverId;
  late String senderId;
  late String dateTime;
  late String text;


  MessageModel({
    required this.receiverId,
    required this.senderId,
    required this.dateTime,
    required this.text,

  });

  MessageModel.fromJson(Map<String, dynamic> json)
  {
    receiverId = json['receiverId'];
    senderId = json['senderId'];
    dateTime = json['dateTime'];
    text = json['text'];
  }

  Map<String, dynamic> toMap()
  {
    return {
      'receiverId':receiverId,
      'senderId':senderId,
      'dateTime':dateTime,
      'text':text,
    };
  }
}