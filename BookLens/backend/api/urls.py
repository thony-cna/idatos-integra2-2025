from django.contrib import admin
from django.urls import path
from .views import BookSearchView, BookDetailWithReviewsView

urlpatterns = [
    path('books/search/', BookSearchView.as_view(), name='Book_Search'),
    path('books/<str:identifier>/', BookDetailWithReviewsView.as_view(), name='Book_Detail_With_Reviews'),
]

