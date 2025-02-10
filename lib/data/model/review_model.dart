
class ReviewModel {

  final String userName ;
  final String userPhone ;
  final String createdAt ;
  final String userRating ;
  final String userReview ;
  final String userUid ;
  final String userDeviceToken ;


  ReviewModel({
    required this.userName, 
    required this.userPhone, 
    required this.createdAt, 
    required this.userRating, 
    required this.userReview, 
    required this.userUid, 
    required this.userDeviceToken

  });

  Map<String,dynamic> toMap (){
    
    return {
     "userName" : userName,
     "userPhone" : userPhone,
     "createdAt" : createdAt,
     "userRating" : userRating,
     "userReview" : userReview,
     'userUid' : userUid,
     "userDeviceToken" : userDeviceToken
    };
  }

  factory ReviewModel.fromMap (Map<String,dynamic> json) {

     return ReviewModel(

      userName: json['userName'],
      userPhone: json['userPhone'],
      userRating: json['userRating'],
      userReview: json['userReview'],
      createdAt: json['createdAt'],
      userUid : json['userUid'],
      userDeviceToken : json['userDeviceToken']

     );


  }
}