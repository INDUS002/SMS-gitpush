"""
Serializers for super_admin app
"""
from rest_framework import serializers
from .models import School, SchoolStats, Activity
from main_login.serializers import UserSerializer


class SchoolStatsSerializer(serializers.ModelSerializer):
    """Serializer for School Statistics"""
    class Meta:
        model = SchoolStats
        fields = ['total_students', 'total_teachers', 'total_revenue', 'updated_at']


class SchoolSerializer(serializers.ModelSerializer):
    """Serializer for School model"""
    stats = SchoolStatsSerializer(read_only=True)
    
    class Meta:
        model = School
        fields = [
            'id', 'name', 'location', 'status', 'license_expiry',
            'stats', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at']


class ActivitySerializer(serializers.ModelSerializer):
    """Serializer for Activity model"""
    user = UserSerializer(read_only=True)
    school_name = serializers.CharField(source='school.name', read_only=True)
    
    class Meta:
        model = Activity
        fields = [
            'id', 'user', 'school', 'school_name', 'activity_type',
            'description', 'created_at'
        ]
        read_only_fields = ['id', 'created_at']

