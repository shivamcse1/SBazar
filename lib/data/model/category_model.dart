class CategoryModel{

   final String categoryName;
   final String categoryId;
   final String categoryImg;
   final dynamic categoryCreatedAt;
   final dynamic categoryUpdatedAt;

   CategoryModel({
    
    required this.categoryId,
    required this.categoryName,
    required this.categoryImg,
    required this.categoryCreatedAt,
    this.categoryUpdatedAt,
   });


   Map<String,dynamic> toMap (){

    return {
      "categoryName" : categoryName,
      "categoryId" : categoryId,
      "categoryImg" : categoryImg,
      "updatedAt" : categoryUpdatedAt,
      "createdAt" : categoryCreatedAt
    } ;
   }


   factory CategoryModel.fromMap(Map<String, dynamic> json) {
    return CategoryModel(

     categoryName : json['categoryName'],
     categoryId : json['categoryId'],
     categoryImg : json['categoryImg'],
     categoryCreatedAt : json['createdAt'],
     categoryUpdatedAt:  json['updatedAt']

    );
  }
  
}