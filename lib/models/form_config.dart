
import 'package:waos_store_app/models/form_configs/categoria_form_config.dart';
import 'package:waos_store_app/models/form_configs/comprobantecabecera_form_config.dart';
import 'package:waos_store_app/models/form_configs/comprobantedetalle_form_config.dart';
import 'package:waos_store_app/models/form_configs/empresa_form_config.dart';
import 'package:waos_store_app/models/form_configs/inventario_form_config.dart';
import 'package:waos_store_app/models/form_configs/metodopago_form_config.dart';
import 'package:waos_store_app/models/form_configs/pago_form_config.dart';
import 'package:waos_store_app/models/form_configs/producto_form_config.dart';
import 'package:waos_store_app/models/form_configs/productovariante_form_config.dart';
import 'package:waos_store_app/models/form_configs/proveedor_form_config.dart';
// import 'package:waos_store_app/models/form_configs/rol_form_config.dart';
import 'package:waos_store_app/models/form_configs/sucursal_form_config.dart';
import 'package:waos_store_app/models/form_configs/usuario_form_config.dart';
import 'package:waos_store_app/models/form_field_config.dart';

class FormConfig {
  static final Map<String, List<FormFieldConfig>> _configs = {
    'categoria': CategoriaFormConfig.getConfig(),
    'producto': ProductoFormConfig.getConfig(),
    'sucursal': SucursalFormConfig.getConfig(),
    'usuario': UsuarioFormConfig.getConfig(),
    // 'rol': RolFormConfig.getConfig(),
    'proveedor': ProveedorFormConfig.getConfig(),
    'metodo-pago': MetodoPagoFormConfig.getConfig(),
    'empresa': EmpresaFormConfig.getConfig(),
    'comprobante-cabecera': ComprobanteCabeceraFormConfig.getConfig(),
    'comprobante-detalle': ComprobanteDetalleFormConfig.getConfig(),
    'inventario': InventarioFormConfig.getConfig(),
    'pago': PagoFormConfig.getConfig(),
    'producto-variante': ProductoVarianteFormConfig.getConfig(),
  };

  static List<FormFieldConfig>? getConfig(String endpoint) {
    // Limpiar el endpoint para obtener solo el nombre base
    String cleanEndpoint = endpoint.replaceAll('/', '').toLowerCase();
    
    // Si el endpoint tiene un número al final (para edición), removerlo
    cleanEndpoint = cleanEndpoint.replaceAll(RegExp(r'\d+$'), '');
    
    return _configs[cleanEndpoint];
  }
}
