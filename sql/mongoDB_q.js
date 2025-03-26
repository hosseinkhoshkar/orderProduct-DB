//Creating ProductReview Document by Json
//{
//     "_id": "string",
//     "productId": "number",
//     "customerName": "string",
//     "reviewText": "string",
//     "reviewDate": "datetime",
//     "rating": "number"
// }

use productReviews

//CRUD
// Create
db.product_reviews.insertOne({
    "productId": 12345,
    "customerName": "John Doe",
    "reviewText": "Great product!",
    "reviewDate": ISODate("2023-03-15T10:15:00Z"),
    "rating": 4.5
})

// Read
db.product_reviews.find({})

//Update
db.product_reviews.updateOne(
    {"_id": ObjectId("your_object_id")},
    {
        $set: {
            "reviewText": "Updated review text",
            "rating": 5.0
        }
    }
)

// Delete
db.product_reviews.deleteOne({"_id": ObjectId("your_object_id")})

// Inserting 10 sample data for test
const reviews = [];
for (let i = 1; i <= 10; i++) {
    reviews.push({
        productId: Math.floor(Math.random() * 100000),
        customerName: "Customer " + i,
        reviewText: "Review for product " + i,
        reviewDate: new ISODate(),
        rating: parseFloat((Math.random() * 5).toFixed(1))
    });
}
db.product_reviews.insertMany(reviews);


