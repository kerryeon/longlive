from django.conf.urls import include, url

from rest_framework import routers

from . import habit
from . import login
from . import post
from . import user


# ViewSets
router = routers.DefaultRouter()
router.register(r'habits/types', habit.HabitTypeViewSet)
router.register(r'habits', habit.HabitViewSet)
router.register(r'user/habits', habit.UserHabitViewSet)
router.register(r'posts', post.PostViewSet)


urlpatterns = [
    # ViewSets
    url(r'^api/v1/', include(router.urls)),

    # ApiViews
    url(r'^api/v1/user/session/login', login.LoginView.as_view()),
    url(r'^api/v1/user/session/logout', login.LogoutView.as_view()),
    url(r'^api/v1/user/session/register', login.RegisterView.as_view()),
    url(r'^api/v1/user', user.UserView.as_view()),
]
