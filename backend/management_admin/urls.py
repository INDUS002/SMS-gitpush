"""
URLs for management_admin app
"""
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import views

app_name = 'management_admin'

router = DefaultRouter()
router.register(r'departments', views.DepartmentViewSet, basename='department')
router.register(r'teachers', views.TeacherViewSet, basename='teacher')
router.register(r'students', views.StudentViewSet, basename='student')
router.register(r'admissions', views.NewAdmissionViewSet, basename='admission')
router.register(r'examinations', views.ExaminationManagementViewSet, basename='examination')
router.register(r'fees', views.FeeViewSet, basename='fee')

urlpatterns = [
    path('', include(router.urls)),
]

