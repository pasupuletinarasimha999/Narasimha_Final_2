from django.urls import path
from . import views

# router = routers.DefaultRouter()
# router.register('/orders', views.OrderView, base_name="order")

urlpatterns = [
    path('', views.index, name='index'),
    # url(r'^api/order/$', views.OrderView),
    path('api/order/', views.OrderView, name='order'),
    path('sales/', views.SalesView, name='sales')
]