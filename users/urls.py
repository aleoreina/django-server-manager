
from django.urls import path
from .views import LoginView, RegisterView

app_name = 'users'
urlpatterns = [
    path('login', LoginView.as_view(), name="users-login"),
    path('register', RegisterView.as_view(), name="users-register"),
]