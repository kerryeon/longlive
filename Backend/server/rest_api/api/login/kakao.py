import requests

from .base import AbstractLogin


class KakaoTalkLogin(AbstractLogin):
    @classmethod
    def login(cls, access_token):
        response = requests.get(
            'https://kapi.kakao.com/v1/user/access_token_info',
            headers={
                'Authorization': f'Bearer {access_token}'
            }
        )
        if response.status_code != 200:
            return None
        return response.json()['id']
