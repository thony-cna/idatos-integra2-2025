from rest_framework import serializers
from .models import Book, Review

class BookSerializer(serializers.ModelSerializer):
    class Meta:
        model = Book
        fields = '__all__'

class ReviewSerializer(serializers.ModelSerializer):
    userid = serializers.IntegerField(source='userid.userid')

    class Meta:
        model = Review
        fields = ['id', 'userid', 'rating']


class BookWithReviewsSerializer(serializers.ModelSerializer):
    reviews = ReviewSerializer(many=True, read_only=True)

    class Meta:
        model = Book
        fields = [
            'isbn', 'title', 'author', 'description', 'imageurl', 'preview',
            'publisher', 'year', 'infourl', 'genres', 'reviews'
        ]
