from django.contrib import admin
from django.urls import path
from .views import BookListView, BookDetailWithReviewsView

urlpatterns = [
    path("books/", BookListView.as_view(), name="listar_libros"),
    path('books/<str:identifier>/', BookDetailWithReviewsView.as_view(), name='detalle_libro_con_reviews'),
]
