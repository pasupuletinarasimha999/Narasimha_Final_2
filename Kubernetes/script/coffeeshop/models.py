from django.db import models
from datetime import datetime
# Create your models here.

class Drink(models.Model):
    name = models.CharField(max_length=100)
    type = models.CharField(max_length=100)
    price_tall = models.DecimalField(max_digits=10, decimal_places=2, null=True)
    price_grande = models.DecimalField(max_digits=10, decimal_places=2, null=True)
    price_venti = models.DecimalField(max_digits=10, decimal_places=2, null=True)

    def __str__(self):
        return self.name

class Order(models.Model):
    orderId = models.IntegerField(default=0)
    type = models.CharField(max_length=100)
    name = models.CharField(max_length=100)
    value = models.IntegerField(default=0)
    size = models.CharField(max_length=100)
    price = models.DecimalField(max_digits=10, decimal_places=2, null=True)
    date = models.DateTimeField(default=datetime.now())
