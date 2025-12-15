"""
Views for management_admin app - API layer for App 2
"""
import random
import string
from rest_framework import viewsets, status, filters
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, AllowAny
from django_filters.rest_framework import DjangoFilterBackend
from .models import Department, Teacher, Student, DashboardStats, NewAdmission, Examination_management, Fee, PaymentHistory
from .serializers import (
    DepartmentSerializer,
    TeacherSerializer,
    StudentSerializer,
    DashboardStatsSerializer,
    NewAdmissionSerializer,
    ExaminationManagementSerializer,
    FeeSerializer
)
from main_login.permissions import IsManagementAdmin


class DepartmentViewSet(viewsets.ModelViewSet):
    """ViewSet for Department management"""
    queryset = Department.objects.all()
    serializer_class = DepartmentSerializer
    permission_classes = [IsAuthenticated, IsManagementAdmin]
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['school', 'head']
    search_fields = ['name', 'description']
    ordering_fields = ['name', 'created_at']
    ordering = ['-created_at']


class TeacherViewSet(viewsets.ModelViewSet):
    """ViewSet for Teacher management"""
    queryset = Teacher.objects.all()
    serializer_class = TeacherSerializer
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['department', 'designation', 'is_active']
    search_fields = ['user__first_name', 'user__last_name', 'employee_no', 'designation', 'email', 'first_name', 'last_name']
    ordering_fields = ['joining_date', 'created_at']
    ordering = ['-created_at']

    def get_permissions(self):
        """Allow read/create/delete without auth to match frontend behavior"""
        if self.action in ['list', 'retrieve', 'create', 'destroy']:
            return [AllowAny()]
        return [IsAuthenticated(), IsManagementAdmin()]


class StudentViewSet(viewsets.ModelViewSet):
    """ViewSet for Student management"""
    queryset = Student.objects.all()
    serializer_class = StudentSerializer
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['school', 'applying_class', 'category', 'gender']
    search_fields = ['student_name', 'parent_name', 'admission_number', 'email']
    ordering_fields = ['created_at', 'student_name']
    ordering = ['-created_at']

    def get_permissions(self):
        """Allow read/create/delete without auth to match frontend behavior"""
        if self.action in ['list', 'retrieve', 'create', 'destroy']:
            return [AllowAny()]
        return [IsAuthenticated(), IsManagementAdmin()]


class NewAdmissionViewSet(viewsets.ModelViewSet):
    """ViewSet for New Admission management"""
    queryset = NewAdmission.objects.all()
    serializer_class = NewAdmissionSerializer
    permission_classes = [IsAuthenticated, IsManagementAdmin]
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['status', 'applying_class', 'category', 'gender', 'student_id']
    search_fields = ['student_name', 'parent_name', 'parent_phone', 'email', 'admission_number', 'student_id']
    ordering_fields = ['created_at', 'status', 'student_name']
    ordering = ['-created_at']
    
    def create(self, request, *args, **kwargs):
        """Override create to provide better error messages"""
        serializer = self.get_serializer(data=request.data)
        
        if not serializer.is_valid():
            return Response(
                {
                    'success': False,
                    'message': 'Validation error',
                    'errors': serializer.errors,
                },
                status=status.HTTP_400_BAD_REQUEST
            )
        
        try:
            self.perform_create(serializer)
            headers = self.get_success_headers(serializer.data)
            
            # Get generated password from context
            generated_password = serializer.context.get('generated_password', None)
            
            # Prepare response data
            response_data = serializer.data.copy()
            if generated_password:
                response_data['generated_password'] = generated_password
                response_data['login_credentials'] = {
                    'email': serializer.data.get('email'),
                    'password': generated_password,
                    'message': 'Please save these credentials. You can use them to login once admission is approved.'
                }
            
            return Response(
                {
                    'success': True,
                    'message': 'Admission created successfully. User account created with generated password.',
                    'data': response_data,
                },
                status=status.HTTP_201_CREATED,
                headers=headers
            )
        except Exception as e:
            return Response(
                {
                    'success': False,
                    'message': str(e),
                    'error': 'Failed to create admission',
                },
                status=status.HTTP_400_BAD_REQUEST
            )
    
    def perform_create(self, serializer):
        """Override to create user account for admission"""
        from main_login.models import User, Role
        
        # Get email and student_name from validated data
        email = serializer.validated_data.get('email')
        student_name = serializer.validated_data.get('student_name', '')
        
        # Split student_name into first_name and last_name
        name_parts = student_name.strip().split(maxsplit=1)
        first_name = name_parts[0] if name_parts else student_name
        last_name = name_parts[1] if len(name_parts) > 1 else ''
        
        # Generate 8-character random password (alphanumeric)
        characters = string.ascii_letters + string.digits
        generated_password = ''.join(random.choice(characters) for _ in range(8))
        
        # Get or create student_parent role
        role, _ = Role.objects.get_or_create(
            name='student_parent',
            defaults={'description': 'Student/Parent role'}
        )
        
        # Create username from email (part before @)
        username = email.split('@')[0] if email else f'student_{random.randint(1000, 9999)}'
        # Ensure username is unique
        base_username = username
        counter = 1
        while User.objects.filter(username=username).exists():
            username = f'{base_username}{counter}'
            counter += 1
        
        # Create User account
        user, user_created = User.objects.get_or_create(
            email=email,
            defaults={
                'username': username,
                'first_name': first_name,
                'last_name': last_name,
                'role': role,
                'is_active': True,
                'has_custom_password': False,  # User needs to create their own password
            }
        )
        
        # Set password_hash to the generated 8-character password
        # Set password field to null/unusable so authentication backend checks password_hash
        user.password_hash = generated_password
        user.set_unusable_password()  # This sets password field to unusable (effectively null)
        user.has_custom_password = False  # Ensure flag is set
        user.save()
        
        # Store generated password in serializer context to return in response
        serializer.context['generated_password'] = generated_password
        
        # Save the admission (without school and user links)
        admission = serializer.save()
        
        return admission
    
    def update(self, request, *args, **kwargs):
        """Override update to provide better error messages and handle partial updates"""
        partial = kwargs.pop('partial', False)
        instance = self.get_object()
        old_status = instance.status
        serializer = self.get_serializer(instance, data=request.data, partial=partial)
        
        if not serializer.is_valid():
            return Response(
                {
                    'success': False,
                    'message': 'Validation error',
                    'errors': serializer.errors,
                },
                status=status.HTTP_400_BAD_REQUEST
            )
        
        try:
            # Get the new status from validated data
            new_status = serializer.validated_data.get('status', old_status)
            
            # Perform the update
            self.perform_update(serializer)
            
            # Refresh instance to get updated data
            instance.refresh_from_db()
            
            # If status changed to 'Approved', create Student record
            created_student = None
            if old_status != 'Approved' and new_status == 'Approved':
                try:
                    created_student = instance.create_student_from_admission()
                except Exception as e:
                    return Response(
                        {
                            'success': False,
                            'message': f'Admission approved but failed to create student record: {str(e)}',
                            'error': 'Failed to create student',
                        },
                        status=status.HTTP_400_BAD_REQUEST
                    )
            
            if getattr(instance, '_prefetched_objects_cache', None):
                instance._prefetched_objects_cache = {}
            
            # Prepare response data
            response_data = serializer.data.copy()
            if created_student:
                # Include student information in response
                student_serializer = StudentSerializer(created_student)
                response_data['created_student'] = student_serializer.data
                message = 'Admission approved and student record created successfully'
            else:
                message = 'Admission updated successfully'
            
            return Response(
                {
                    'success': True,
                    'message': message,
                    'data': response_data,
                },
                status=status.HTTP_200_OK
            )
        except Exception as e:
            return Response(
                {
                    'success': False,
                    'message': str(e),
                    'error': 'Failed to update admission',
                },
                status=status.HTTP_400_BAD_REQUEST
            )
    
    @action(detail=True, methods=['post'], url_path='approve')
    def approve(self, request, pk=None):
        """
        Custom action to approve an admission and create Student record.
        POST /api/management-admin/admissions/{id}/approve/
        """
        admission = self.get_object()
        
        if admission.status == 'Approved':
            return Response(
                {
                    'success': False,
                    'message': 'Admission is already approved',
                },
                status=status.HTTP_400_BAD_REQUEST
            )
        
        # Update status to Approved
        old_status = admission.status
        admission.status = 'Approved'
        
        # Generate admission number if not provided
        if not admission.admission_number:
            import datetime
            timestamp = datetime.datetime.now().strftime('%Y%m%d%H%M%S')
            admission_number = f'ADM-{datetime.datetime.now().year}-{timestamp[-6:]}'
            # Ensure uniqueness
            while Student.objects.filter(admission_number=admission_number).exists() or \
                  NewAdmission.objects.filter(admission_number=admission_number).exists():
                timestamp = datetime.datetime.now().strftime('%Y%m%d%H%M%S%f')
                admission_number = f'ADM-{datetime.datetime.now().year}-{timestamp[-6:]}'
            admission.admission_number = admission_number
        
        admission.save()
        
        # Create Student record
        created_student = None
        try:
            created_student = admission.create_student_from_admission()
        except Exception as e:
            # Rollback status if student creation fails
            admission.status = old_status
            admission.save()
            return Response(
                {
                    'success': False,
                    'message': f'Failed to create student record: {str(e)}',
                    'error': 'Student creation failed',
                },
                status=status.HTTP_400_BAD_REQUEST
            )
        
        # Serialize response
        serializer = self.get_serializer(admission)
        response_data = serializer.data.copy()
        
        if created_student:
            student_serializer = StudentSerializer(created_student)
            response_data['created_student'] = student_serializer.data
        
        return Response(
            {
                'success': True,
                'message': 'Admission approved and student record created successfully',
                'data': response_data,
            },
            status=status.HTTP_200_OK
        )
    


class DashboardViewSet(viewsets.ViewSet):
    """ViewSet for Dashboard data"""
    permission_classes = [IsAuthenticated, IsManagementAdmin]
    
    @action(detail=False, methods=['get'])
    def stats(self, request):
        """Get dashboard statistics"""
        # Get school associated with the user (assuming user has a school)
        # This would need to be implemented based on your user-school relationship
        stats = DashboardStats.objects.first()  # Placeholder
        
        if stats:
            serializer = DashboardStatsSerializer(stats)
            return Response(serializer.data)
        
        return Response({
            'total_teachers': 0,
            'total_students': 0,
            'total_departments': 0,
        })


class ExaminationManagementViewSet(viewsets.ModelViewSet):
    """ViewSet for Examination Management"""
    queryset = Examination_management.objects.all()
    serializer_class = ExaminationManagementSerializer
    permission_classes = [IsAuthenticated, IsManagementAdmin]
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['Exam_Type', 'Exam_Status']
    search_fields = ['Exam_Title', 'Exam_Description', 'Exam_Location']
    ordering_fields = ['Exam_Date', 'Exam_Created_At', 'Exam_Title']
    ordering = ['-Exam_Created_At']
    
    def get_permissions(self):
        """Allow read/create/update/delete without auth for development - can be adjusted"""
        if self.action in ['list', 'retrieve', 'create', 'update', 'partial_update', 'destroy']:
            return [AllowAny()]
        return [IsAuthenticated(), IsManagementAdmin()]


class FeeViewSet(viewsets.ModelViewSet):
    """ViewSet for Fee Management"""
    queryset = Fee.objects.select_related('student').prefetch_related('payment_history').all()
    serializer_class = FeeSerializer
    permission_classes = [IsAuthenticated, IsManagementAdmin]
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['fee_type', 'status', 'frequency', 'grade', 'student']
    search_fields = ['student__student_name', 'description', 'fee_type']
    ordering_fields = ['due_date', 'created_at', 'total_amount']
    ordering = ['-due_date']
    
    def get_permissions(self):
        """Allow read/create/update/delete without auth for development - can be adjusted"""
        if self.action in ['list', 'retrieve', 'create', 'update', 'partial_update', 'destroy']:
            return [AllowAny()]
        return [IsAuthenticated(), IsManagementAdmin()]
    
    def list(self, request, *args, **kwargs):
        """Override list to ensure proper response format and handle errors gracefully"""
        try:
            # Get all fees without any filters first
            queryset = self.get_queryset()
            total_count = queryset.count()
            print(f"FeeViewSet.list: Total fees in database: {total_count}")
            
            # Apply filters if any
            queryset = self.filter_queryset(queryset)
            filtered_count = queryset.count()
            print(f"FeeViewSet.list: Fees after filtering: {filtered_count}")
            
            # Serialize the data
            serializer = self.get_serializer(queryset, many=True)
            data = serializer.data
            print(f"FeeViewSet.list: Serialized {len(data)} fees")
            
            # Log first fee for debugging
            if data:
                print(f"FeeViewSet.list: First fee sample: {data[0]}")
            else:
                print("FeeViewSet.list: No fees to return")
            
            return Response(data)
        except Exception as e:
            import traceback
            print(f"Error in FeeViewSet.list: {e}")
            print(traceback.format_exc())
            
            # Try to return at least an empty list instead of error
            try:
                # Fallback: try to get fees without student relationship
                queryset = Fee.objects.all()
                serializer = self.get_serializer(queryset, many=True)
                return Response(serializer.data)
            except Exception as e2:
                print(f"Fallback also failed: {e2}")
                return Response(
                    {'error': str(e), 'detail': 'An error occurred while fetching fees'},
                    status=status.HTTP_500_INTERNAL_SERVER_ERROR
                )
    
    @action(detail=True, methods=['post'], url_path='record-payment')
    def record_payment(self, request, pk=None):
        """Record a payment for a fee and create payment history"""
        try:
            fee = self.get_object()
            payment_amount = request.data.get('payment_amount')
            payment_date = request.data.get('payment_date')
            receipt_number = request.data.get('receipt_number', '')
            notes = request.data.get('notes', '')
            
            if not payment_amount:
                return Response(
                    {'error': 'payment_amount is required'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            
            try:
                payment_amount = float(payment_amount)
            except (ValueError, TypeError):
                return Response(
                    {'error': 'payment_amount must be a valid number'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            
            # Parse payment date or use today
            from datetime import date
            if payment_date:
                try:
                    from datetime import datetime
                    payment_date_obj = datetime.strptime(payment_date, '%Y-%m-%d').date()
                except ValueError:
                    payment_date_obj = date.today()
            else:
                payment_date_obj = date.today()
            
            # Create payment history record
            from django.utils import timezone
            payment_history = PaymentHistory.objects.create(
                fee=fee,
                payment_amount=payment_amount,
                payment_date=payment_date_obj,
                receipt_number=receipt_number,
                notes=notes
            )
            print(f"Created payment history: ID={payment_history.id}, Amount={payment_history.payment_amount}, Date={payment_history.payment_date}, Created={payment_history.created_at}")
            
            # Update fee with new payment (cumulative)
            # Set last_paid_date (will be set even for first payment)
            fee.last_paid_date = payment_date_obj
            
            # Update paid_amount cumulatively
            from decimal import Decimal
            fee.paid_amount = Decimal(str(fee.paid_amount)) + Decimal(str(payment_amount))
            
            # Recalculate due amount (will be recalculated in save() method too)
            fee.due_amount = Decimal(str(fee.total_amount)) - Decimal(str(fee.paid_amount))
            
            # Update status (using Decimal comparison)
            if fee.paid_amount >= fee.total_amount:
                fee.status = 'paid'
            elif fee.paid_amount > Decimal('0'):
                fee.status = 'pending'
            
            # Save the fee (this will trigger the save() method which recalculates due_amount)
            fee.save()
            print(f"Fee saved: ID={fee.id}, paid_amount={fee.paid_amount}, due_amount={fee.due_amount}, last_paid_date={fee.last_paid_date}, status={fee.status}")
            
            # Reload from database to ensure we have the latest data including payment history
            fee = Fee.objects.prefetch_related('payment_history').select_related('student').get(pk=fee.pk)
            
            # Verify the calculations
            print(f"Fee after refresh from database:")
            print(f"  - total_amount: {fee.total_amount}")
            print(f"  - paid_amount: {fee.paid_amount}")
            print(f"  - due_amount: {fee.due_amount}")
            print(f"  - last_paid_date: {fee.last_paid_date}")
            print(f"  - calculated due: {float(fee.total_amount) - float(fee.paid_amount)}")
            print(f"  - payment_history count: {fee.payment_history.count()}")
            
            # Return updated fee with payment history
            serializer = self.get_serializer(fee)
            serialized_data = serializer.data
            print(f"Serialized data:")
            print(f"  - paid_amount: {serialized_data.get('paid_amount')}")
            print(f"  - due_amount: {serialized_data.get('due_amount')}")
            print(f"  - last_paid_date: {serialized_data.get('last_paid_date')}")
            print(f"  - payment_history items: {len(serialized_data.get('payment_history', []))}")
            return Response(serialized_data, status=status.HTTP_200_OK)
            
        except Fee.DoesNotExist:
            return Response(
                {'error': 'Fee not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        except Exception as e:
            import traceback
            print(f"Error recording payment: {e}")
            print(traceback.format_exc())
            return Response(
                {'error': str(e), 'detail': 'An error occurred while recording payment'},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )
    
    @action(detail=True, methods=['put', 'patch'], url_path='payment-history/(?P<payment_id>[^/.]+)')
    def update_payment_history(self, request, pk=None, payment_id=None):
        """Update a payment history record and recalculate fee totals"""
        try:
            fee = self.get_object()
            
            # Get the payment history record
            try:
                payment_history = PaymentHistory.objects.get(id=payment_id, fee=fee)
            except PaymentHistory.DoesNotExist:
                return Response(
                    {'error': 'Payment history record not found'},
                    status=status.HTTP_404_NOT_FOUND
                )
            
            # Get old payment amount before update
            old_amount = float(payment_history.payment_amount)
            
            # Update payment history fields
            if 'payment_amount' in request.data:
                try:
                    new_amount = float(request.data.get('payment_amount'))
                    payment_history.payment_amount = new_amount
                except (ValueError, TypeError):
                    return Response(
                        {'error': 'payment_amount must be a valid number'},
                        status=status.HTTP_400_BAD_REQUEST
                    )
            
            if 'payment_date' in request.data:
                from datetime import date, datetime
                payment_date = request.data.get('payment_date')
                if payment_date:
                    try:
                        payment_date_obj = datetime.strptime(payment_date, '%Y-%m-%d').date()
                        payment_history.payment_date = payment_date_obj
                    except ValueError:
                        pass  # Keep existing date if invalid
            
            if 'receipt_number' in request.data:
                payment_history.receipt_number = request.data.get('receipt_number', '')
            
            if 'notes' in request.data:
                payment_history.notes = request.data.get('notes', '')
            
            payment_history.save()
            print(f"Updated payment history: ID={payment_history.id}, Amount={payment_history.payment_amount}, Date={payment_history.payment_date}")
            
            # Refresh fee from database to get updated payment_history
            fee.refresh_from_db()
            fee = Fee.objects.prefetch_related('payment_history').select_related('student').get(pk=fee.pk)
            
            # Recalculate fee's paid_amount by summing all payment history
            from decimal import Decimal
            total_paid = Decimal('0')
            payment_count = 0
            for payment in fee.payment_history.all():
                total_paid += Decimal(str(payment.payment_amount))
                payment_count += 1
                print(f"Payment {payment_count}: ID={payment.id}, Amount={payment.payment_amount}")
            
            print(f"Total paid calculated: {total_paid}, from {payment_count} payments")
            fee.paid_amount = total_paid
            
            # Recalculate due amount
            fee.due_amount = Decimal(str(fee.total_amount)) - fee.paid_amount
            print(f"Fee amounts - Total: {fee.total_amount}, Paid: {fee.paid_amount}, Due: {fee.due_amount}")
            
            # Update last_paid_date to the most recent payment date
            latest_payment = fee.payment_history.order_by('-payment_date').first()
            if latest_payment:
                fee.last_paid_date = latest_payment.payment_date
                print(f"Last paid date updated to: {fee.last_paid_date}")
            
            # Update status
            if fee.paid_amount >= fee.total_amount:
                fee.status = 'paid'
            elif fee.paid_amount > Decimal('0'):
                fee.status = 'pending'
            else:
                fee.status = 'pending'
            
            fee.save()
            print(f"Fee saved: ID={fee.id}, paid_amount={fee.paid_amount}, due_amount={fee.due_amount}, status={fee.status}")
            
            # Reload from database one more time to ensure we have the latest data
            fee = Fee.objects.prefetch_related('payment_history').select_related('student').get(pk=fee.pk)
            
            # Return updated fee with payment history
            serializer = self.get_serializer(fee)
            return Response(serializer.data, status=status.HTTP_200_OK)
            
        except Fee.DoesNotExist:
            return Response(
                {'error': 'Fee not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        except Exception as e:
            import traceback
            print(f"Error updating payment history: {e}")
            print(traceback.format_exc())
            return Response(
                {'error': str(e), 'detail': 'An error occurred while updating payment history'},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )

