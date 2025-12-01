"""
Admin configuration for management_admin app
"""
from django.contrib import admin
from .models import Department, Teacher, Student, DashboardStats


@admin.register(Department)
class DepartmentAdmin(admin.ModelAdmin):
    list_display = ['name', 'school', 'head', 'created_at']
    list_filter = ['school', 'created_at']
    search_fields = ['name', 'school__name', 'head__username']


@admin.register(Teacher)
class TeacherAdmin(admin.ModelAdmin):
    list_display = ['user', 'school', 'department', 'employee_id', 'designation', 'hire_date']
    list_filter = ['school', 'department', 'designation', 'hire_date']
    search_fields = ['user__username', 'user__email', 'employee_id', 'designation']


@admin.register(Student)
class StudentAdmin(admin.ModelAdmin):
    list_display = ['user', 'school', 'student_id', 'class_name', 'section', 'admission_date']
    list_filter = ['school', 'class_name', 'section', 'admission_date']
    search_fields = ['user__username', 'user__email', 'student_id', 'parent_name']


@admin.register(DashboardStats)
class DashboardStatsAdmin(admin.ModelAdmin):
    list_display = ['school', 'total_teachers', 'total_students', 'total_departments', 'updated_at']
    search_fields = ['school__name']

