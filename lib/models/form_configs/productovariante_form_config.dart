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
        hint: 'Seleccione un producto',
      ),
      FormFieldConfig(
        field: 'activo',
        label: 'Activo',
        type: 'switch',
        required: true,
        defaultValue: true,
      ),
      FormFieldConfig(
        field: 'imagen',
        label: 'Imagen de la Variante',
        type: 'image',
        required: false,
        hint: 'Seleccione una imagen para la variante',
      ),
    ];
  }
}