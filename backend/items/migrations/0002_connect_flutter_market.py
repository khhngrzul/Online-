from django.db import migrations, models


CATEGORIES = [
    'Ном',
    'Электроник',
    'Бусад',
    'Хувцас',
    'Унаа',
    'Спорт',
]


def seed_categories_and_items(apps, schema_editor):
    Category = apps.get_model('items', 'Category')
    Item = apps.get_model('items', 'Item')
    categories = {
        name: Category.objects.get_or_create(name=name)[0]
        for name in CATEGORIES
    }

    if Item.objects.exists():
        return

    samples = [
        (
            'Алгоритмын сурах бичиг',
            'Сайн хадгалагдсан, тэмдэглэлтэй.',
            25000,
            'sell',
            'Анударь',
            'Ном',
            'https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?auto=format&fit=crop&w=800&q=80',
        ),
        (
            'Ширээний гэрэл',
            'LED, 2 жил ашигласан.',
            0,
            'free',
            'Тэмүүжин',
            'Электроник',
            'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?auto=format&fit=crop&w=800&q=80',
        ),
        (
            'Casio fx-991',
            'Номоор солилцоно.',
            0,
            'swap',
            'Номин',
            'Ном',
            'https://images.unsplash.com/photo-1587145820266-a5951ee6f620?auto=format&fit=crop&w=800&q=80',
        ),
        (
            'Чихэвч',
            'Bluetooth, цэнэг сайн барьдаг.',
            45000,
            'sell',
            'Тэмүүжин',
            'Бусад',
            'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80',
        ),
    ]
    for title, description, price, kind, owner_name, category, image_url in samples:
        Item.objects.create(
            title=title,
            description=description,
            price=price,
            kind=kind,
            owner_name=owner_name,
            category=categories[category],
            image_url=image_url,
        )


class Migration(migrations.Migration):
    dependencies = [
        ('items', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='item',
            name='description',
            field=models.TextField(blank=True),
        ),
        migrations.AlterField(
            model_name='item',
            name='location',
            field=models.CharField(blank=True, max_length=200),
        ),
        migrations.AlterField(
            model_name='item',
            name='phone',
            field=models.CharField(blank=True, max_length=20),
        ),
        migrations.AlterField(
            model_name='item',
            name='price',
            field=models.DecimalField(decimal_places=2, default=0, max_digits=12),
        ),
        migrations.AddField(
            model_name='item',
            name='kind',
            field=models.CharField(
                choices=[
                    ('sell', 'Зарна'),
                    ('swap', 'Солилцоно'),
                    ('free', 'Үнэгүй'),
                ],
                default='sell',
                max_length=10,
            ),
        ),
        migrations.AddField(
            model_name='item',
            name='owner_name',
            field=models.CharField(blank=True, default='Оюутан', max_length=150),
        ),
        migrations.AddField(
            model_name='item',
            name='image_url',
            field=models.URLField(blank=True),
        ),
        migrations.RunPython(seed_categories_and_items, migrations.RunPython.noop),
    ]
