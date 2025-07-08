import 'package:waos_store_app/models/form_field_config.dart';

class PagoFormConfig {
  static List<FormFieldConfig> getConfig() {
    return [
      FormFieldConfig(
        field: 'monto',
        label: 'Monto',
        type: 'number',
        required: true,
        hint: 'Ingrese el monto',
      ),
      FormFieldConfig(
        field: 'numero_operacion',
        label: 'Número de Operación',
        type: 'text',
        required: false,
        hint: 'Ingrese el número de operación',
      ),
      FormFieldConfig(
        field: 'fk_metodo_pago',
        label: 'Método de Pago',
        type: 'dropdown',
        required: true,
        hint: 'Seleccione un método de pago',
      ),
      FormFieldConfig(
        field: 'fk_comprobantecabecera',
        label: 'Comprobante de Cabecera',
        type: 'dropdown',
        required: true,
        hint: 'Seleccione un comprobante de cabecera',
      ),
      FormFieldConfig(
        field: 'fk_usuario',
        label: 'Usuario',
        type: 'dropdown',
        required: true,
        hint: 'Seleccione un usuario',
      ),
    ];
  }
}
