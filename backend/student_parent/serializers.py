"""
Serializers for student_parent app
"""
from rest_framework import serializers
from .models import Parent, Notification, Fee, Communication
from management_admin.serializers import StudentSerializer
from main_login.serializers import UserSerializer


class ParentSerializer(serializers.ModelSerializer):
    """Serializer for Parent model"""
    user = UserSerializer(read_only=True)
    students = StudentSerializer(many=True, read_only=True)
    
    class Meta:
        model = Parent
        fields = [
            'id', 'user', 'students', 'phone', 'address',
            'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at']


class NotificationSerializer(serializers.ModelSerializer):
    """Serializer for Notification model"""
    recipient = UserSerializer(read_only=True)
    
    class Meta:
        model = Notification
        fields = [
            'id', 'recipient', 'title', 'message', 'notification_type',
            'is_read', 'created_at'
        ]
        read_only_fields = ['id', 'created_at']


class FeeSerializer(serializers.ModelSerializer):
    """Serializer for Fee model"""
    student = StudentSerializer(read_only=True)
    
    class Meta:
        model = Fee
        fields = [
            'id', 'student', 'amount', 'due_date', 'status',
            'payment_date', 'description', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at']


class CommunicationSerializer(serializers.ModelSerializer):
    """Serializer for Communication model"""
    sender = UserSerializer(read_only=True)
    recipient = UserSerializer(read_only=True)
    
    class Meta:
        model = Communication
        fields = [
            'id', 'sender', 'recipient', 'subject', 'message',
            'is_read', 'created_at'
        ]
        read_only_fields = ['id', 'created_at']

