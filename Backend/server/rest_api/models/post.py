import pathlib
import uuid

from django.db import models

from .habit import Habit
from .user import User


class Post(models.Model):
    """게시글"""
    title = models.CharField(max_length=255)
    desc = models.TextField()
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    ty = models.ForeignKey(Habit, on_delete=models.CASCADE)

    date_create = models.DateTimeField(auto_now_add=True)
    date_modify = models.DateTimeField(auto_now=True)


class PostImage(models.Model):
    """게시글 이미지"""

    # 파라미터 instance는 Photo 모델을 의미 filename은 업로드 된 파일의 파일 이름
    def _save_image_to(self, filename):
        """사용자가 업로드한 이미지를 저장합니다.

        Args:
            instance (PostImage): 사용자가 업로드한 이미지
            filename (str): 업로드된 파일의 파일명

        Returns:
            str: 저장할 파일경로. MEDIA_ROOT/imgs/<user_id>/<pid>.<extension>
        """
        user_id = self.post.user.id
        pid = uuid.uuid4()
        extension = pathlib.Path(filename).suffix
        return f'imgs/{user_id}/{pid}{extension}'

    post = models.ForeignKey(Post, on_delete=models.CASCADE)
    image = models.ImageField(upload_to=_save_image_to)
