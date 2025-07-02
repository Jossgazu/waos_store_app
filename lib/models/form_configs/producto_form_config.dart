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
        field: 'precio',
        label: 'Precio',
        type: 'number',
        required: false,
        hint: 'Ingrese el precio del producto',
      ),
      FormFieldConfig(
        field: 'activo',
        label: 'Activo',
        type: 'switch',
        required: false,
        defaultValue: true,
      ),
    ];
  }
}
