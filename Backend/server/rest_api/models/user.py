from django.contrib.auth.models import BaseUserManager, AbstractBaseUser, PermissionsMixin
from django.db import models

from .habit import Habit
from .term import Term


class UserGenderType(models.Model):
    """습관 종류"""
    name = models.CharField(max_length=31)

    def __str__(self) -> str:
        return self.name


class UserManager(BaseUserManager):
    def _create_user(self, age, gender, term, id, password, is_staff, is_superuser):
        if not age:
            raise ValueError('Users must have an age')
        if not gender:
            raise ValueError('Users must have a specific gender')

        gender = UserGenderType.objects.filter(id=gender)[0]
        term = Term.objects.filter(id=term)[0]

        user = self.model(
            id=id,
            age=age,
            gender=gender,
            term=term,
            is_active=True,
            is_staff=is_staff or is_superuser,
            is_superuser=is_superuser,
        )
        if password is None:
            password = '12341234'
        user.set_password(password) 
        user.save(using=self._db)
        return user

    def get_by_natural_key(self, id):
        return self.get(**{'{}__iexact'.format(self.model.USERNAME_FIELD): id})

    def create_user(self, age, gender, term, id=None, password=None):
        return self._create_user(age, gender, term, id, password, False, False)

    def create_superuser(self, age, gender, term, id, password):
        return self._create_user(age, gender, term, id, password, True, True)


class User(AbstractBaseUser, PermissionsMixin):
    """사용자 정보"""
    age = models.IntegerField()
    gender = models.ForeignKey(UserGenderType, on_delete=models.CASCADE)
    
    habits = models.ManyToManyField(Habit, blank=True)

    term = models.ForeignKey(Term, on_delete=models.CASCADE)

    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)

    date_joined = models.DateTimeField(auto_now_add=True)
    date_last_login = models.DateTimeField(auto_now_add=True)

    objects = UserManager()

    USERNAME_FIELD = 'id'
    REQUIRED_FIELDS = ['age', 'gender']

    def __str__(self) -> str:
        return f'[{self.id}] {self.age}세 {self.gender}'


class UserLoginType(models.IntegerChoices):
    """사용자 로그인 방식"""
    KAKAOTALK = 1


class UserSession(models.Model):
    """사용자 로그인 세션"""
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    ty = models.IntegerField(choices=UserLoginType.choices)
    remote_id = models.CharField(max_length=255)

    class Meta:
        unique_together = ('ty', 'remote_id',)
