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
        type: 'dropdown',
        required: true,
        hint: 'Seleccione el tipo de método de pago',
        options: [
          {'value': 'efectivo', 'label': 'EFECTIVO'},
          {'value': 'tarjeta', 'label': 'TARJETA'},
          {'value': 'digital', 'label': 'DIGITAL'},
          {'value': 'transferencia', 'label': 'TRANSFERENCIA'},
        ],
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