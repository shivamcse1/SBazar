class ReviewHelper{

  static String getReviewCategory(double rating) {
  if (rating >0.0 && rating < 2.0) {
    return "😡 Bad";
  } else if (rating >= 2.0 && rating < 3.5) {
    return "😐 Average";
  } else if (rating >= 3.5 && rating < 4.5) {
    return "😊 Good";
  } else if (rating >= 4.5 && rating <= 5.0) {
    return "🌟 Excellent";
  } else {
    return "No Rating";
  }
}


}