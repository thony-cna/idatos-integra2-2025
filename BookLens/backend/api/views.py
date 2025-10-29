from rest_framework.generics import ListAPIView, RetrieveAPIView
from .models import Book
from .serializers import BookSerializer, BookWithReviewsSerializer

class BookListView(ListAPIView):
    queryset = Book.objects.all()
    serializer_class = BookSerializer

class BookDetailView(RetrieveAPIView):
    queryset = Book.objects.all()
    serializer_class = BookSerializer
    lookup_field = 'isbn'

class BookDetailWithReviewsView(RetrieveAPIView):
    queryset = Book.objects.all()
    serializer_class = BookWithReviewsSerializer
    lookup_field = 'isbn'