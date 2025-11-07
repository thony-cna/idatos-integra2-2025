from rest_framework.generics import ListAPIView, RetrieveAPIView
from .models import Book
from .serializers import BookSerializer, BookWithReviewsSerializer

class BookSearchView(ListAPIView):
    serializer_class = BookSerializer

    def get_queryset(self):
        queryset = Book.objects.all()
        title = self.request.query_params.get('title')
        genre = self.request.query_params.get('genre')
        year = self.request.query_params.get('year')

        if title:
            queryset = queryset.filter(title__icontains=title)
        if genre:
            queryset = queryset.filter(genres__icontains=genre)
        if year:
            try:
                year = int(year)
                queryset = queryset.filter(date__gte=year)
            except ValueError:
                pass

        return queryset
    
class BookDetailWithReviewsView(RetrieveAPIView):
    queryset = Book.objects.all()
    serializer_class = BookWithReviewsSerializer
    lookup_field = 'identifier'