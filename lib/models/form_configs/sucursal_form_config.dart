// sucursal_form_config.dart
import 'package:waos_store_app/models/form_field_config.dart';


class SucursalFormConfig {
  static List<FormFieldConfig> getConfig() {
    return [
      FormFieldConfig(
        field: 'nombre',
        label: 'Nombre de la Sucursal',
        type: 'text',
        required: true,
        hint: 'Ingrese el nombre de la sucursal',
      ),
      FormFieldConfig(
        field: 'direccion',
        label: 'Dirección',
        type: 'text',
        required: true,
        hint: 'Ingrese la dirección de la sucursal',
      ),
      FormFieldConfig(
        field: 'telefono',
        label: 'Teléfono',
        type: 'phone',
        required: false,
        hint: 'Ingrese el teléfono de la sucursal',
      ),
      FormFieldConfig(
        field: 'fk_empresa',
        label: 'Empresa',
        type: 'dropdown',
        required: true,
        hint: 'Seleccione una empresa',
      ),
    ];
  }
}
