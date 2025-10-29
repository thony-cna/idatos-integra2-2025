from django.db import models

# Create your models here.
class Book(models.Model):
    isbn = models.TextField(primary_key=True)
    title = models.TextField(null=True, blank=True)
    author = models.TextField(null=True, blank=True)
    description = models.TextField(null=True, blank=True)
    imageurl = models.TextField(null=True, blank=True)
    preview = models.TextField(null=True, blank=True)
    publisher = models.TextField(null=True, blank=True)
    year = models.IntegerField(null=True, blank=True)
    infourl = models.TextField(null=True, blank=True)
    genres = models.TextField(null=True, blank=True)

    class Meta:
        managed = False          
        db_table = 'ln_books'

    def __str__(self):
        return f"{self.title or 'Sin título'} ({self.isbn})"


class User(models.Model):
    userid = models.IntegerField(primary_key=True)

    class Meta:
        managed = False
        db_table = 'ln_users'
    
    def __str__(self):
        return f"User {self.userid}"


class Review(models.Model):
    id = models.AutoField(primary_key=True)
    userid = models.ForeignKey(User, on_delete=models.CASCADE, db_column='userid')
    isbn = models.ForeignKey(Book, on_delete=models.CASCADE, related_name='reviews', db_column='isbn')
    rating = models.IntegerField(null=True, blank=True)

    class Meta:
        managed = False
        db_table = 'ln_reviews'

