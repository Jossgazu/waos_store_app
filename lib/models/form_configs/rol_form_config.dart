// rol_form_config.dart
import 'package:waos_store_app/models/form_field_config.dart';

class RolFormConfig {
  static List<FormFieldConfig> getConfig() {
    return [
      FormFieldConfig(
        field: 'nombre',
        label: 'Nombre del Rol',
        type: 'text',
        required: true,
        hint: 'Ingrese el nombre del rol',
      ),
      FormFieldConfig(
        field: 'descripcion',
        label: 'Descripción',
        type: 'textarea',
        required: false,
        hint: 'Ingrese una descripción del rol',
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
