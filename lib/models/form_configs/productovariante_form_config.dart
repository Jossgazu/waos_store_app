import 'package:waos_store_app/models/form_field_config.dart';

class ProductoVarianteFormConfig {
  static List<FormFieldConfig> getConfig() {
    return [
      FormFieldConfig(
        field: 'nombre',
        label: 'Nombre de la Variante',
        type: 'text',
        required: true,
        hint: 'Ingrese el nombre de la variante',
      ),
      FormFieldConfig(
        field: 'precio_adicional',
        label: 'Precio Adicional',
        type: 'number',
        required: true,
        hint: 'Ingrese el precio adicional de la variante',
      ),
      FormFieldConfig(
        field: 'fk_producto',
        label: 'Producto',
        type: 'dropdown',
        required: true,
        hint: 'Seleccione el producto al que pertenece',
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