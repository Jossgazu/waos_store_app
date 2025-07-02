// usuario_form_config.dart
import 'package:waos_store_app/models/form_field_config.dart';

class UsuarioFormConfig {
  static List<FormFieldConfig> getConfig() {
    return [
      FormFieldConfig(
        field: 'nombre',
        label: 'Nombre',
        type: 'text',
        required: true,
        hint: 'Ingrese el nombre del usuario',
      ),
      FormFieldConfig(
        field: 'dni',
        label: 'DNI',
        type: 'text',
        required: true,
        hint: 'Ingrese el DNI del usuario',
      ),
      FormFieldConfig(
        field: 'password',
        label: 'Contraseña',
        type: 'password',
        required: true,
        hint: 'Ingrese la contraseña',
      ),
      FormFieldConfig(
        field: 'correo',
        label: 'Correo',
        type: 'email',
        required: true,
        hint: 'Ingrese el correo del usuario',
      ),
      FormFieldConfig(
        field: 'fk_rol',
        label: 'Rol',
        type: 'dropdown',
        required: true,
        hint: 'Seleccione un rol',
      ),
    ];
  }
}
