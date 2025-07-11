class FormFieldConfig {
  final String field;
  final String label;
  final String type;
  final bool required;
  final dynamic defaultValue;
  final String? hint;
  final List<Map<String, dynamic>>? options; 


  const FormFieldConfig({
    required this.field,
    required this.label,
    required this.type,
    this.required = false,
    this.defaultValue,
    this.hint,
    this.options, 
  });
}