from django.contrib import admin
from django.urls import path
from .views import BookListView, BookDetailWithReviewsView, BookSearchView

urlpatterns = [
    path("books/", BookListView.as_view(), name="Book_List"),
    path('books/search/', BookSearchView.as_view(), name='Book_Search'),
    path('books/<str:identifier>/', BookDetailWithReviewsView.as_view(), name='Book_Detail_With_Reviews'),
]

