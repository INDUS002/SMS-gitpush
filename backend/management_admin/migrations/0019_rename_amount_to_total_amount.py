# Generated manually

from django.db import migrations, models


def migrate_amount_to_total_amount(apps, schema_editor):
    """Copy amount to total_amount for existing records where total_amount is None"""
    Fee = apps.get_model('management_admin', 'Fee')
    for fee in Fee.objects.all():
        # If total_amount is None, set it to amount
        if fee.total_amount is None:
            fee.total_amount = fee.amount
            fee.save()


def reverse_migrate_total_amount_to_amount(apps, schema_editor):
    """Reverse migration - no action needed as RenameField handles it"""
    pass


class Migration(migrations.Migration):

    dependencies = [
        ('management_admin', '0018_fee_amount_to_be_paid_fee_total_amount'),
    ]

    operations = [
        # First, ensure all existing records have total_amount set from amount
        migrations.RunPython(migrate_amount_to_total_amount, reverse_migrate_total_amount_to_amount),
        # Remove the old nullable total_amount field
        migrations.RemoveField(
            model_name='fee',
            name='total_amount',
        ),
        # Rename amount to total_amount
        migrations.RenameField(
            model_name='fee',
            old_name='amount',
            new_name='total_amount',
        ),
    ]

