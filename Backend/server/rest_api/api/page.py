from rest_framework.pagination import PageNumberPagination


class StandardResultsSetPagination(PageNumberPagination):
    page_size_query_param = 'page_size'
    page_size = 16
    max_page_size = 16
