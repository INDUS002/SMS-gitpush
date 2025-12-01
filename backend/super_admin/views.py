"""
Views for super_admin app - API layer for App 1
"""
from rest_framework import viewsets, status, filters
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django_filters.rest_framework import DjangoFilterBackend
from .models import School, SchoolStats, Activity
from .serializers import SchoolSerializer, ActivitySerializer
from main_login.permissions import IsSuperAdmin


class SchoolViewSet(viewsets.ModelViewSet):
    """ViewSet for School management"""
    queryset = School.objects.all()
    serializer_class = SchoolSerializer
    permission_classes = [IsAuthenticated, IsSuperAdmin]
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['status', 'location']
    search_fields = ['name', 'location']
    ordering_fields = ['name', 'created_at', 'updated_at']
    ordering = ['-created_at']
    
    @action(detail=True, methods=['get'])
    def stats(self, request, pk=None):
        """Get detailed statistics for a school"""
        school = self.get_object()
        stats, created = SchoolStats.objects.get_or_create(school=school)
        serializer = SchoolSerializer(school)
        return Response(serializer.data)
    
    @action(detail=False, methods=['get'])
    def dashboard(self, request):
        """Get dashboard data"""
        total_schools = School.objects.count()
        active_schools = School.objects.filter(status='active').count()
        total_students = sum(
            stats.total_students for stats in SchoolStats.objects.all()
        )
        total_teachers = sum(
            stats.total_teachers for stats in SchoolStats.objects.all()
        )
        total_revenue = sum(
            float(stats.total_revenue) for stats in SchoolStats.objects.all()
        )
        
        return Response({
            'total_schools': total_schools,
            'active_schools': active_schools,
            'total_students': total_students,
            'total_teachers': total_teachers,
            'total_revenue': total_revenue,
        })


class ActivityViewSet(viewsets.ReadOnlyModelViewSet):
    """ViewSet for Activity logs"""
    queryset = Activity.objects.all()
    serializer_class = ActivitySerializer
    permission_classes = [IsAuthenticated, IsSuperAdmin]
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['activity_type', 'school']
    search_fields = ['description', 'activity_type']
    ordering_fields = ['created_at']
    ordering = ['-created_at']

