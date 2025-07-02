// metodopago_form_config.dart
import 'package:waos_store_app/models/form_field_config.dart';

class MetodoPagoFormConfig {
  static List<FormFieldConfig> getConfig() {
    return [
      FormFieldConfig(
        field: 'nombre',
        label: 'Nombre del Método de Pago',
        type: 'text',
        required: true,
        hint: 'Ingrese el nombre del método de pago',
      ),
      FormFieldConfig(
        field: 'tipo',
        label: 'Tipo',
        type: 'text',
        required: true,
        hint: 'Ingrese el tipo del método de pago',
      ),
      FormFieldConfig(
        field: 'activo',
        label: 'Activo',
        type: 'switch',
        required: true,
        defaultValue: true,
      ),
    ];
  }
}
