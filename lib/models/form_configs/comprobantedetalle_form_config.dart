import 'package:waos_store_app/models/form_field_config.dart';

class ComprobanteDetalleFormConfig {
  static List<FormFieldConfig> getConfig() {
    return [
      FormFieldConfig(
        field: 'fk_producto',
        label: 'Producto',
        type: 'dropdown',
        required: true,
        hint: 'Seleccione un producto',
      ),
      FormFieldConfig(
        field: 'cantidad',
        label: 'Cantidad',
        type: 'number',
        required: true,
        hint: 'Ingrese la cantidad',
      ),
      FormFieldConfig(
        field: 'precio_producto',
        label: 'Precio del Producto',
        type: 'number',
        required: true,
        hint: 'Ingrese el precio del producto',
      ),
      FormFieldConfig(
        field: 'fk_comprobantecabecera',
        label: 'Comprobante de Cabecera',
        type: 'dropdown',
        required: true,
        hint: 'Seleccione un comprobante de cabecera',
      ),
    ];
  }
}
