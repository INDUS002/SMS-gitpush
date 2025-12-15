"""
Serializers for management_admin app
"""
from rest_framework import serializers
from .models import Department, Teacher, Student, DashboardStats, NewAdmission, Examination_management, Fee, PaymentHistory
from main_login.serializers import UserSerializer
from super_admin.serializers import SchoolSerializer


class DepartmentSerializer(serializers.ModelSerializer):
    """Serializer for Department model"""
    head = UserSerializer(read_only=True)
    school_name = serializers.CharField(source='school.name', read_only=True)
    
    class Meta:
        model = Department
        fields = [
            'id', 'school', 'school_name', 'name', 'description',
            'head', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at']


class TeacherSerializer(serializers.ModelSerializer):
    """Serializer for Teacher model"""
    user = UserSerializer(read_only=True)
    department_name = serializers.CharField(source='department.name', read_only=True)
    
    # Writable fields for creating user
    first_name = serializers.CharField(write_only=True, required=False)
    last_name = serializers.CharField(write_only=True, required=False)
    
    class Meta:
        model = Teacher
        fields = [
            'teacher_id', 'user', 'department', 'department_name',
            'employee_no', 'first_name', 'last_name', 'qualification',
            'joining_date', 'dob', 'gender', 'designation', 'department',
            'blood_group', 'nationality', 'mobile_no', 'email', 'address',
            'primary_room_id', 'class_teacher_section_id', 'subject_specialization',
            'emergency_contact', 'profile_photo_id', 'is_active',
            'created_at', 'updated_at'
        ]
        read_only_fields = ['teacher_id', 'created_at', 'updated_at', 'user']
    
    def create(self, validated_data):
        """Override create to handle user creation from email"""
        import random
        import string
        from main_login.models import User, Role
        
        # Get user data (don't pop, as they're also Teacher model fields)
        first_name = validated_data.get('first_name', '')
        last_name = validated_data.get('last_name', '')
        email = validated_data.get('email', '')
        
        # Create user from email if email is provided
        user = None
        if email:
            # Generate username from email (part before @)
            username = email.split('@')[0] if email else None
            
            # Ensure username is unique
            if username:
                base_username = username
                counter = 1
                while User.objects.filter(username=username).exists():
                    username = f'{base_username}{counter}'
                    counter += 1
            else:
                # Fallback if no email
                username = f'teacher_{validated_data.get("employee_no", "unknown")}'
                counter = 1
                while User.objects.filter(username=username).exists():
                    username = f'teacher_{validated_data.get("employee_no", "unknown")}_{counter}'
                    counter += 1
            
            # Get or create teacher role
            role, _ = Role.objects.get_or_create(
                name='teacher',
                defaults={'description': 'Teacher role'}
            )
            
            # Generate 8-character random password (alphanumeric)
            characters = string.ascii_letters + string.digits
            generated_password = ''.join(random.choice(characters) for _ in range(8))
            
            # Create or get user
            user, created = User.objects.get_or_create(
                email=email,
                defaults={
                    'username': username,
                    'first_name': first_name or '',
                    'last_name': last_name or '',
                    'role': role,
                    'is_active': True,
                    'has_custom_password': False,  # Teacher needs to create their own password
                }
            )
            
            # Set password_hash to the generated 8-character password
            if created:
                user.password_hash = generated_password
                user.set_unusable_password()  # This sets password field to unusable (effectively null)
                user.has_custom_password = False
                user.save()
            else:
                # Update user if it already existed
                if first_name:
                    user.first_name = first_name
                if last_name:
                    user.last_name = last_name
                user.save()
        
        # Create teacher with the user (if created)
        teacher = Teacher.objects.create(user=user, **validated_data)
        return teacher


class StudentSerializer(serializers.ModelSerializer):
    """Serializer for Student model"""
    user = UserSerializer(read_only=True)
    school_name = serializers.CharField(source='school.name', read_only=True)
    total_fee_amount = serializers.SerializerMethodField()
    paid_fee_amount = serializers.SerializerMethodField()
    due_fee_amount = serializers.SerializerMethodField()
    fees_count = serializers.SerializerMethodField()
    
    class Meta:
        model = Student
        fields = [
            'email', 'user', 'school', 'school_name', 'student_id',
            'student_name', 'parent_name', 'date_of_birth', 'gender',
            'applying_class', 'grade', 'address', 'category', 'admission_number',
            'parent_phone', 'emergency_contact', 'medical_information',
            'blood_group', 'previous_school', 'remarks',
            'total_fee_amount', 'paid_fee_amount', 'due_fee_amount', 'fees_count',
            'created_at', 'updated_at'
        ]
        read_only_fields = ['email', 'created_at', 'updated_at', 'user']
    
    def get_total_fee_amount(self, obj):
        """Calculate total fee amount for this student"""
        from django.db.models import Sum
        from django.db import DataError
        try:
            total = obj.management_fees.aggregate(Sum('total_amount'))['total_amount__sum'] or 0
            return float(total)
        except (DataError, ValueError, TypeError):
            # Handle case where database column type doesn't match (e.g., UUID vs email)
            return 0.0
    
    def get_paid_fee_amount(self, obj):
        """Calculate total paid fee amount for this student"""
        from django.db.models import Sum
        from django.db import DataError
        try:
            total = obj.management_fees.aggregate(Sum('paid_amount'))['paid_amount__sum'] or 0
            return float(total)
        except (DataError, ValueError, TypeError):
            return 0.0
    
    def get_due_fee_amount(self, obj):
        """Calculate total due fee amount for this student"""
        from django.db.models import Sum
        from django.db import DataError
        try:
            total = obj.management_fees.aggregate(Sum('due_amount'))['due_amount__sum'] or 0
            return float(total)
        except (DataError, ValueError, TypeError):
            return 0.0
    
    def get_fees_count(self, obj):
        """Get count of fees for this student"""
        from django.db import DataError
        try:
            return obj.management_fees.count()
        except (DataError, ValueError, TypeError):
            return 0


class NewAdmissionSerializer(serializers.ModelSerializer):
    """Serializer for New Admission model"""
    generated_password = serializers.CharField(read_only=True, help_text='8-character password generated for user login')
    created_student = StudentSerializer(read_only=True, help_text='Student record created when admission is approved')
    
    class Meta:
        model = NewAdmission
        fields = [
            'student_id', 'student_name', 'parent_name',
            'date_of_birth', 'gender', 'applying_class', 'grade',
            'address', 'category', 'status',
            'admission_number', 'email', 'parent_phone', 'emergency_contact',
            'medical_information', 'blood_group', 'previous_school', 'remarks',
            'created_at', 'updated_at', 'generated_password', 'created_student'
        ]
        read_only_fields = ['created_at', 'updated_at', 'generated_password', 'created_student']
    
    def __init__(self, *args, **kwargs):
        """Override to make email required only for creation, not updates"""
        super().__init__(*args, **kwargs)
        # For partial updates (PATCH), make email optional
        if self.instance is not None:
            # This is an update, make email optional
            self.fields['email'].required = False
            # Make student_id read-only for updates (can't change primary key)
            self.fields['student_id'].read_only = True
        else:
            # For creation, student_id is optional (will be auto-generated if not provided)
            self.fields['student_id'].required = False
            self.fields['student_id'].allow_blank = True
            self.fields['student_id'].allow_null = True
    
    def validate_email(self, value):
        """Validate email - required for creation, optional for updates"""
        # If this is a create (no instance) and email is not provided
        if self.instance is None and (value is None or value == ''):
            raise serializers.ValidationError("Email is required for new admissions.")
        # For updates, if email is not provided, keep existing email
        if self.instance is not None and (value is None or value == ''):
            return self.instance.email
        return value
    
    def validate_admission_number(self, value):
        """Validate admission_number uniqueness, excluding current instance"""
        # Handle empty strings - convert to None
        if value is not None:
            if isinstance(value, str):
                value = value.strip()
            if not value:
                value = None
        
        # Only validate uniqueness if value is provided and not empty
        if value:
            # Check if admission_number already exists (excluding current instance)
            queryset = NewAdmission.objects.filter(admission_number=value)
            if self.instance:
                queryset = queryset.exclude(pk=self.instance.pk)
            if queryset.exists():
                raise serializers.ValidationError(
                    f"Admission number '{value}' already exists."
                )
        # Return None for empty values (admission_number is optional)
        return value
    
    def validate(self, attrs):
        """Generate student_id if not provided"""
        # Only generate student_id during creation (not updates)
        if self.instance is None:
            student_id = attrs.get('student_id')
            if not student_id or (isinstance(student_id, str) and not student_id.strip()):
                # Generate a unique student_id
                import uuid
                import datetime
                from .models import NewAdmission
                
                # Generate format: STD-YYYYMMDD-HHMMSS-XXXX
                # Keep generating until we get a unique one
                max_attempts = 10
                for attempt in range(max_attempts):
                    timestamp = datetime.datetime.now().strftime('%Y%m%d%H%M%S')
                    unique_suffix = uuid.uuid4().hex[:4].upper()
                    generated_id = f'STD-{timestamp}-{unique_suffix}'
                    
                    # Check if this ID already exists
                    if not NewAdmission.objects.filter(student_id=generated_id).exists():
                        attrs['student_id'] = generated_id
                        break
                    
                    # If all attempts fail, use UUID as fallback
                    if attempt == max_attempts - 1:
                        attrs['student_id'] = f'STD-{uuid.uuid4().hex[:16].upper()}'
            else:
                # If student_id is provided, check if it's unique
                if isinstance(student_id, str) and student_id.strip():
                    from .models import NewAdmission
                    if NewAdmission.objects.filter(student_id=student_id.strip()).exists():
                        raise serializers.ValidationError({
                            'student_id': f"Student ID '{student_id}' already exists."
                        })
                    attrs['student_id'] = student_id.strip()
        return attrs


class DashboardStatsSerializer(serializers.ModelSerializer):
    """Serializer for Dashboard Statistics"""
    school = SchoolSerializer(read_only=True)
    
    class Meta:
        model = DashboardStats
        fields = [
            'school', 'total_teachers', 'total_students',
            'total_departments', 'updated_at'
        ]


class ExaminationManagementSerializer(serializers.ModelSerializer):
    """Serializer for Examination Management model"""
    
    class Meta:
        model = Examination_management
        fields = [
            'id', 'Exam_Title', 'Exam_Type', 'Exam_Date', 'Exam_Time',
            'Exam_Subject', 'Exam_Class', 'Exam_Duration', 'Exam_Marks', 
            'Exam_Description', 'Exam_Location', 'Exam_Status', 
            'Exam_Created_At', 'Exam_Updated_At'
        ]
        read_only_fields = ['id', 'Exam_Created_At', 'Exam_Updated_At']


class PaymentHistorySerializer(serializers.ModelSerializer):
    """Serializer for PaymentHistory model"""
    class Meta:
        model = PaymentHistory
        fields = ['id', 'payment_amount', 'payment_date', 'receipt_number', 'notes', 'created_at']
        read_only_fields = ['id', 'created_at']


class FeeSerializer(serializers.ModelSerializer):
    """Serializer for Fee model"""
    student_id = serializers.SerializerMethodField()
    student_email = serializers.SerializerMethodField()
    payment_history = PaymentHistorySerializer(many=True, read_only=True)
    
    class Meta:
        model = Fee
        fields = [
            'id', 'student', 'student_id', 'student_id_string', 'student_email', 'student_name', 'applying_class', 'fee_type', 'grade',
            'total_amount', 'frequency', 'due_date', 'late_fee', 'description',
            'status', 'paid_amount', 'due_amount', 
            'last_paid_date', 'payment_history', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at', 'student_name', 'applying_class', 'payment_history']
    
    def get_student_id(self, obj):
        """Safely get student ID"""
        try:
            return str(obj.student.student_id) if obj.student else ''
        except Exception:
            return ''
    
    def get_student_email(self, obj):
        """Safely get student email"""
        try:
            return obj.student.email if obj.student else ''
        except Exception:
            return ''
    
    def create(self, validated_data):
        """Override create to auto-populate grade from student if not provided"""
        grade = validated_data.get('grade', '').strip()
        student = validated_data.get('student')
        
        # If grade is not provided or empty, try to get it from student or admission
        if not grade and student:
            # First try to get grade from Student model
            if hasattr(student, 'grade') and student.grade:
                validated_data['grade'] = student.grade
            else:
                # If not in Student, try to get from NewAdmission
                from .models import NewAdmission
                try:
                    # Try to find admission by student_id or email
                    admission = NewAdmission.objects.filter(
                        student_id=student.student_id
                    ).first()
                    
                    if not admission:
                        admission = NewAdmission.objects.filter(
                            email=student.email
                        ).first()
                    
                    if admission and admission.grade:
                        validated_data['grade'] = admission.grade
                except Exception:
                    pass
        
        return super().create(validated_data)

