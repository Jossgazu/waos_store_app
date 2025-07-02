// empresa_form_config.dart
import 'package:waos_store_app/models/form_field_config.dart';


class EmpresaFormConfig {
  static List<FormFieldConfig> getConfig() {
    return [
      FormFieldConfig(
        field: 'nombre',
        label: 'Nombre de la Empresa',
        type: 'text',
        required: true,
        hint: 'Ingrese el nombre de la empresa',
      ),
      FormFieldConfig(
        field: 'ruc',
        label: 'RUC',
        type: 'text',
        required: true,
        hint: 'Ingrese el RUC de la empresa',
      ),
      FormFieldConfig(
        field: 'web',
        label: 'Página Web',
        type: 'text',
        required: false,
        hint: 'Ingrese la página web de la empresa',
      ),
    ];
  }
}
