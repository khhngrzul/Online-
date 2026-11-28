from django.test import TestCase
from rest_framework import status
from rest_framework.test import APITestCase


class ApiRootHealthCheckTests(APITestCase):
    def test_api_root_is_public_for_health_checks(self):
        response = self.client.get('/')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
