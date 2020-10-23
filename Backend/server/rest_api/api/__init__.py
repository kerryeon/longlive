from django.conf.urls import include, url

from rest_framework import routers

from . import habit
from . import login
from . import post
from . import user
from . import video


# ViewSets
router = routers.DefaultRouter()
router.register(r'habits/all', habit.HabitViewSet)
router.register(r'habits/types', habit.HabitTypeViewSet)
router.register(r'posts/all', post.PostViewSet)
router.register(r'user/habits', habit.UserHabitViewSet)
router.register(r'user/posts/all', post.UserPostViewSet)
router.register(r'user/posts/liked/all', post.UserPostLikedViewSet)
router.register(r'user/posts/liked/mut', post.UserPostLikedMutViewSet)
router.register(r'videos', video.VideoViewSet)


urlpatterns = [
    # ViewSets
    url(r'^api/v1/', include(router.urls)),

    # ApiViews
    url(r'^api/v1/user/info', user.UserView.as_view()),
    url(r'^api/v1/user/session/login', login.LoginView.as_view()),
    url(r'^api/v1/user/session/logout', login.LogoutView.as_view()),
    url(r'^api/v1/user/session/register', login.RegisterView.as_view()),
]
