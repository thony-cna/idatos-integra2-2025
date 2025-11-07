from django.db import models

# Create your models here.
class Book(models.Model):
    identifier = models.TextField(primary_key=True)
    title = models.TextField(null=True, blank=True)
    creator = models.TextField(null=True, blank=True)
    description = models.TextField(null=True, blank=True)
    imageurl = models.TextField(null=True, blank=True)
    preview = models.TextField(null=True, blank=True)
    publisher = models.TextField(null=True, blank=True)
    date = models.IntegerField(null=True, blank=True)
    source = models.TextField(null=True, blank=True)
    genres = models.TextField(null=True, blank=True)

    class Meta:
        managed = False          
        db_table = 'lnbooks'

    def __str__(self):
        return f"{self.title or 'Sin título'} ({self.identifier})"


class User(models.Model):
    userid = models.IntegerField(primary_key=True, db_column='User-ID')

    class Meta:
        managed = False
        db_table = 'lnusers'
    
    def __str__(self):
        return f"User {self.userid}"


class Review(models.Model):
    id = models.AutoField(primary_key=True)

    user_id = models.IntegerField()
    isbn = models.CharField(max_length=20)
    rating = models.IntegerField(null=True, blank=True)

    class Meta:
        managed = False
        db_table = 'lnreviews'




