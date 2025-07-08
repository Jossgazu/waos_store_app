// producto_form_config.dart
import 'package:waos_store_app/models/form_field_config.dart';

class ProductoFormConfig {
  static List<FormFieldConfig> getConfig() {
    return [
      FormFieldConfig(
        field: 'nombre',
        label: 'Nombre del Producto',
        type: 'text',
        required: true,
        hint: 'Ingrese el nombre del producto',
      ),
      FormFieldConfig(
        field: 'descripcion',
        label: 'Descripción',
        type: 'textarea',
        required: false,
        hint: 'Ingrese una descripción del producto',
      ),
      FormFieldConfig(
        field: 'codigo',
        label: 'Código',
        type: 'text',
        required: true,
        hint: 'Ingrese el código del producto',
      ),
      FormFieldConfig(
        field: 'fk_categoria',
        label: 'Categoría',
        type: 'dropdown',
        required: true,
        hint: 'Seleccione una categoría',
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
