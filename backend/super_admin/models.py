"""
Models for super_admin app - API layer for App 1
"""
from django.db import models
from main_login.models import User


class School(models.Model):
    """School model for super admin"""
    name = models.CharField(max_length=255)
    location = models.CharField(max_length=255)
    status = models.CharField(
        max_length=20,
        choices=[
            ('active', 'Active'),
            ('inactive', 'Inactive'),
            ('suspended', 'Suspended'),
        ],
        default='active'
    )
    license_expiry = models.DateField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return self.name
    
    class Meta:
        db_table = 'schools'
        verbose_name = 'School'
        verbose_name_plural = 'Schools'
        ordering = ['-created_at']


class SchoolStats(models.Model):
    """School statistics"""
    school = models.OneToOneField(School, on_delete=models.CASCADE, related_name='stats')
    total_students = models.IntegerField(default=0)
    total_teachers = models.IntegerField(default=0)
    total_revenue = models.DecimalField(max_digits=12, decimal_places=2, default=0.00)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'school_stats'
        verbose_name = 'School Statistics'
        verbose_name_plural = 'School Statistics'


class Activity(models.Model):
    """Activity log for super admin"""
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='activities')
    school = models.ForeignKey(School, on_delete=models.CASCADE, null=True, blank=True)
    activity_type = models.CharField(max_length=100)
    description = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'activities'
        verbose_name = 'Activity'
        verbose_name_plural = 'Activities'
        ordering = ['-created_at']

