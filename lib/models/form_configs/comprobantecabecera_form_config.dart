// comprobantecabecera_form_config.dart
import 'package:waos_store_app/models/form_field_config.dart';


class ComprobanteCabeceraFormConfig {
  static List<FormFieldConfig> getConfig() {
    return [
      FormFieldConfig(
        field: 'tipo_comprobante',
        label: 'Tipo de Comprobante',
        type: 'text',
        required: true,
        hint: 'Ingrese el tipo de comprobante',
      ),
      FormFieldConfig(
        field: 'serie_correlativo',
        label: 'Serie Correlativo',
        type: 'text',
        required: true,
        hint: 'Ingrese la serie correlativo',
      ),
      FormFieldConfig(
        field: 'fecha',
        label: 'Fecha',
        type: 'datetime',
        required: true,
        hint: 'Seleccione la fecha',
      ),
      FormFieldConfig(
        field: 'igv',
        label: 'IGV',
        type: 'number',
        required: true,
        hint: 'Ingrese el valor del IGV',
      ),
      FormFieldConfig(
        field: 'pago_total',
        label: 'Pago Total',
        type: 'number',
        required: true,
        hint: 'Ingrese el pago total',
      ),
      FormFieldConfig(
        field: 'fk_sucursal',
        label: 'Sucursal',
        type: 'dropdown',
        required: true,
        hint: 'Seleccione una sucursal',
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
