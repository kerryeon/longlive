from django.http import HttpResponse


def home(request):
    return HttpResponse('''
<html>
    <title>Longlive Server</title>
    <body>empty</body>
</html>''')
