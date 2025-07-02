// proveedor_form_config.dart
import 'package:waos_store_app/models/form_field_config.dart';

class ProveedorFormConfig {
  static List<FormFieldConfig> getConfig() {
    return [
      FormFieldConfig(
        field: 'nombre',
        label: 'Nombre del Proveedor',
        type: 'text',
        required: true,
        hint: 'Ingrese el nombre del proveedor',
      ),
      FormFieldConfig(
        field: 'ruc',
        label: 'RUC',
        type: 'text',
        required: true,
        hint: 'Ingrese el RUC del proveedor',
      ),
      FormFieldConfig(
        field: 'direccion',
        label: 'Dirección',
        type: 'text',
        required: true,
        hint: 'Ingrese la dirección del proveedor',
      ),
      FormFieldConfig(
        field: 'telefono',
        label: 'Teléfono',
        type: 'phone',
        required: false,
        hint: 'Ingrese el teléfono del proveedor',
      ),
      FormFieldConfig(
        field: 'correo',
        label: 'Correo',
        type: 'email',
        required: false,
        hint: 'Ingrese el correo del proveedor',
      ),
      FormFieldConfig(
        field: 'contacto_principal',
        label: 'Contacto Principal',
        type: 'text',
        required: false,
        hint: 'Ingrese el contacto principal del proveedor',
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
