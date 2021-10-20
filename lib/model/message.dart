class Message {
  String id = '';
  String senderId = '';
  String receiverId = '';
  String text = '';
  DateTime timeStamp = DateTime.now();

  Message();

  static const COLLECTION = "messages";
  static const SENDER_ID = "sender_id";
  static const RECEIVER_ID = "receiver_id";
  static const TEXT = "text";
  static const TIMESTAMP = "timestamp";


  Map<String, dynamic> serialize(String messageId) {
    return <String, dynamic>{
      SENDER_ID: this.senderId,
      RECEIVER_ID: this.receiverId,
      TEXT: this.text,
      TIMESTAMP: this.timeStamp,
    };
  }

  static Message deserialize(Map<String, dynamic>? doc, String docId) {
    Message message = Message();
    message.id =  docId;
    message.senderId = doc?[SENDER_ID] ?? '';
    message.receiverId = doc?[RECEIVER_ID] ?? '';
    message.text = doc?[TEXT] ?? '';
    message.timeStamp = doc?[TIMESTAMP].toDate() ?? DateTime.now();
    return message;
  }
}