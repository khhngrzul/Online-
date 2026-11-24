from io import BytesIO
from tempfile import TemporaryDirectory

from django.test import override_settings
from django.core.files.uploadedfile import SimpleUploadedFile
from PIL import Image
from rest_framework import status
from rest_framework.test import APITestCase

from .models import Category, Item


class ItemApiTests(APITestCase):
    def setUp(self):
        self.category = Category.objects.get(name='Ном')

    def test_seeded_items_and_categories_are_available(self):
        categories_response = self.client.get('/api/categories/')
        items_response = self.client.get('/api/items/')

        self.assertEqual(categories_response.status_code, status.HTTP_200_OK)
        self.assertEqual(items_response.status_code, status.HTTP_200_OK)
        self.assertGreaterEqual(len(categories_response.data), 6)
        self.assertGreaterEqual(len(items_response.data), 4)

    def test_flutter_listing_fields_can_create_an_item(self):
        response = self.client.post(
            '/api/items/',
            {
                'title': 'Тест ном',
                'description': 'Сайн хадгалсан',
                'price': '15000',
                'kind': Item.Kind.SELL,
                'owner_name': 'Тест Оюутан',
                'category': self.category.id,
            },
            format='json',
        )

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        item = Item.objects.get(pk=response.data['id'])
        self.assertEqual(item.title, 'Тест ном')
        self.assertEqual(item.location, '')
        self.assertEqual(item.phone, '')
        self.assertEqual(item.owner_name, 'Тест Оюутан')

    def test_flutter_can_upload_listing_image(self):
        image_buffer = BytesIO()
        Image.new('RGB', (1, 1), color='white').save(image_buffer, format='PNG')
        image_bytes = image_buffer.getvalue()
        with TemporaryDirectory() as media_root:
            with override_settings(MEDIA_ROOT=media_root):
                response = self.client.post(
                    '/api/items/',
                    {
                        'title': 'Зурагтай зар',
                        'price': '1000',
                        'kind': Item.Kind.SELL,
                        'owner_name': 'Тест Оюутан',
                        'category': self.category.id,
                        'image': SimpleUploadedFile(
                            'listing.png', image_bytes, content_type='image/png'
                        ),
                    },
                    format='multipart',
                )

        self.assertEqual(response.status_code, status.HTTP_201_CREATED, response.data)
        item = Item.objects.get(pk=response.data['id'])
        self.assertTrue(item.image)

    @override_settings(DEBUG=True)
    def test_local_admin_login_page_loads(self):
        response = self.client.get('/admin/login/', HTTP_HOST='127.0.0.1')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
