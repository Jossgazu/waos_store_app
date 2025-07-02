// categoria_form_config.dart

import 'package:waos_store_app/models/form_field_config.dart';

class CategoriaFormConfig {
  static List<FormFieldConfig> getConfig() {
    return [
      FormFieldConfig(
        field: 'nombre',
        label: 'Nombre de la Categoría',
        type: 'text',
        required: true,
        hint: 'Ingrese el nombre de la categoría',
      ),
      FormFieldConfig(
        field: 'descripcion',
        label: 'Descripción',
        type: 'textarea',
        required: true,
        hint: 'Ingrese una descripción de la categoría',
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
