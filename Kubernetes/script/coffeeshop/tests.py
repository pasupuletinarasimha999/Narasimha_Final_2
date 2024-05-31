from django.test import TestCase, Client
from rest_framework import status
from .models import Order
from rest_framework.response import Response
from .serializers import OrderSerializer
from django.urls import reverse
import json

client = Client()


class GetAllOrderTest(TestCase):

    def setUp(self):
        Order.objects.create(
            type='coffee', name='Espersso', value="1", size="tall", price="1.95"
        )
        Order.objects.create(
            type='coffee', name='Espersso', value="2", size="tall", price="3.95"
        )
        Order.objects.create(
            type='tea', name='Green Tea', value="2", size="tall", price="3.455"
        )

    def test_get_all_order(self):
        response = client.get('/api/order/')
        orders = Order.objects.all()
        serializer = OrderSerializer(orders, many=True)
        self.assertEqual(response.data, serializer.data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)


class CreateNewOrderTest(TestCase):

    def setUp(self):
        self.valid_payload = {
            "orders": [{
                "type": "tea",
                "name": "Green Tea",
                "value": "2",
                "size": "tall",
                "price": "3.45"
            }]
        }

        self.invalid_payload = {
            "orders": [{
                "type": "",
                "name": "Green Tea",
                "value": "2",
                "size": "tall",
                "price": "3.45"
            }]
        }

    def test_create_valid_order(self):
        print('valid test')
        response = client.post('/api/order/', data=json.dumps(self.valid_payload), content_type='application/json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

    def test_create_invalid_order(self):
        print('invalid test')
        response = client.post('/api/order/', data=json.dumps(self.invalid_payload), content_type='application/json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)