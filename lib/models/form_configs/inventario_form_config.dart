import 'package:waos_store_app/models/form_field_config.dart';

class InventarioFormConfig {
  static List<FormFieldConfig> getConfig() {
    return [
      FormFieldConfig(
        field: 'tipo_movimiento',
        label: 'Tipo de Movimiento',
        type: 'text',
        required: true,
        hint: 'Ingrese el tipo de movimiento',
      ),
      FormFieldConfig(
        field: 'cantidad',
        label: 'Cantidad',
        type: 'number',
        required: true,
        hint: 'Ingrese la cantidad',
      ),
      FormFieldConfig(
        field: 'fk_producto',
        label: 'Producto',
        type: 'dropdown',
        required: false,
        hint: 'Seleccione un producto',
      ),
      FormFieldConfig(
        field: 'fk_producto_variante',
        label: 'Variante de Producto',
        type: 'dropdown',
        required: false,
        hint: 'Seleccione una variante de producto',
      ),
      FormFieldConfig(
        field: 'fk_usuario',
        label: 'Usuario',
        type: 'dropdown',
        required: true,
        hint: 'Seleccione un usuario',
      ),
      FormFieldConfig(
        field: 'fk_proveedor',
        label: 'Proveedor',
        type: 'dropdown',
        required: false,
        hint: 'Seleccione un proveedor',
      ),
    ];
  }
}
