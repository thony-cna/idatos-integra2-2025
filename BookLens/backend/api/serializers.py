from rest_framework import serializers
from .models import Book, Review


class BookSerializer(serializers.ModelSerializer):
    class Meta:
        model = Book
        fields = '__all__'


class ReviewSerializer(serializers.ModelSerializer):
    user_id = serializers.IntegerField(source='user_id')

    class Meta:
        model = Review
        fields = ['user_id', 'rating']



class BookWithReviewsSerializer(serializers.ModelSerializer):
    reviews = serializers.SerializerMethodField()

    class Meta:
        model = Book
        fields = [
            'identifier', 'title', 'creator', 'description', 'imageurl',
            'preview', 'publisher', 'date', 'source', 'genres', 'reviews'
        ]

    def get_reviews(self, obj):
        reviews = Review.objects.filter(isbn=obj.identifier).values('user_id', 'rating')
        return list(reviews)


