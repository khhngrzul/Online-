
from django.db import models
from django.conf import settings


class StudentProfile(models.Model):
    user = models.OneToOneField(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="student_profile",
        verbose_name="Хэрэглэгч",
    )
    student_code = models.CharField("Оюутны код", max_length=30, unique=True)
    phone_number = models.CharField("Утасны дугаар", max_length=20)

    class Meta:
        verbose_name = "Оюутны мэдээлэл"
        verbose_name_plural = "Оюутны мэдээлэл"

    def __str__(self):
        return self.student_code


class Category(models.Model):
    name = models.CharField("Нэр", max_length=100, unique=True)
    slug = models.SlugField("Хаягийн товчлол", max_length=120, unique=True)
    parent = models.ForeignKey(
        "self",
        verbose_name="Эцэг ангилал",
        on_delete=models.CASCADE,
        null=True,
        blank=True,
        related_name="subcategories",
    )
    is_active = models.BooleanField("Идэвхтэй", default=True)
    created_at = models.DateTimeField("Үүсгэсэн огноо", auto_now_add=True)

    class Meta:
        ordering = ["name"]
        verbose_name = "Ангилал"
        verbose_name_plural = "Ангиллууд"

    def __str__(self):
        return self.name
