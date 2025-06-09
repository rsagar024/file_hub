import 'package:file_hub/core/common/widgets/phone_field/countries.dart';
import 'package:file_hub/core/common/widgets/selectable_item_bottom_sheet.dart';
import 'package:file_hub/core/extensions/string_extension.dart';
import 'package:file_hub/core/resources/themes/app_colors.dart';
import 'package:file_hub/core/resources/themes/text_styles.dart';
import 'package:flutter/material.dart';

class PhoneField extends StatefulWidget {
  final String labelText;
  final String? hintText;
  final bool isRequired;
  final TextEditingController? controller;
  final String? selectedDialCode;
  final Function(bool isValid, String? countryCode, String? phoneNumber)? onValidationChanged;
  final bool isEnabled;
  final String? Function(String? phoneNumber, String? countryCode)? validation;
  final EdgeInsetsGeometry padding;

  const PhoneField({
    super.key,
    this.controller,
    required this.labelText,
    this.hintText,
    this.isRequired = false,
    this.selectedDialCode,
    this.onValidationChanged,
    this.isEnabled = true,
    this.validation,
    this.padding = const EdgeInsets.all(10),
  });

  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  late final List<SelectableItem<Country>> _countries;
  SelectableItem<Country>? _selectedCountry;
  final TextEditingController _internalController = TextEditingController();
  String? _lastProcessedValue;

  TextEditingController get _effectiveController => widget.controller ?? _internalController;

  @override
  void initState() {
    super.initState();
    _initializeCountries();
    _setupControllerListener();
    _processInitialValue();
  }

  void _initializeCountries() {
    _countries = countryCodes.map((e) => SelectableItem<Country>(title: "${e.flag} ${e.name}", value: e)).toList();
    _updateSelectedCountry();
  }

  void _updateSelectedCountry() {
    final dialCode = widget.selectedDialCode?.replaceAll("+", '') ?? "91";

    setState(() {
      _selectedCountry = _countries.firstWhere(
        (element) => element.value?.dialCode == dialCode,
        orElse: () => _countries.first,
      );
    });
  }

  void _setupControllerListener() {
    _effectiveController.addListener(() {
      final newValue = _effectiveController.text;
      if (newValue != _lastProcessedValue) {
        _lastProcessedValue = newValue;
        _processPhoneNumber(newValue);
      }
    });
  }

  void _processInitialValue() {
    if (_effectiveController.text.isNotEmpty) {
      _processPhoneNumber(_effectiveController.text);
    }
  }

  void _processPhoneNumber(String value) {
    if (value.isEmpty) {
      _triggerValidationCallback(false, _selectedCountry?.value?.dialCode, null);
      return;
    }
    _triggerValidationCallback(true, _selectedCountry?.value?.dialCode ?? '', value);
  }

  String? _baseValidator(String? value) {
    final digitsOnly = RegExp(r'^\d+$');
    if (value == null || value.isEmpty) {
      if (widget.isRequired) {
        _triggerValidationCallback(false, null, null);
        return "${widget.labelText} is required field";
      } else {
        _triggerValidationCallback(true, _selectedCountry?.value?.dialCode, null);
        return null;
      }
    }

    if (!digitsOnly.hasMatch(value)) {
      _triggerValidationCallback(false, null, null);
      return "Only digits are allowed";
    }

    if (value.length != (_selectedCountry?.value?.maxLength ?? 10) || (int.tryParse(value) ?? 0) <= 0) {
      _triggerValidationCallback(false, _selectedCountry?.value?.dialCode, null);
      return "Invalid contact number";
    }

    _triggerValidationCallback(true, _selectedCountry?.value?.dialCode, value);
    return null;
  }

  void _triggerValidationCallback(bool isValid, String? countryCode, String? phoneNumber) {
    if (widget.onValidationChanged != null) {
      widget.onValidationChanged!(isValid, countryCode, phoneNumber);
    }
  }

  @override
  void didUpdateWidget(PhoneField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_setupControllerListener);
      _setupControllerListener();
      _processInitialValue();
    }

    if (widget.selectedDialCode != oldWidget.selectedDialCode && (widget.controller?.text.isNullOrEmpty() ?? false)) {
      _updateSelectedCountry();
    }
  }

  @override
  void dispose() {
    _effectiveController.removeListener(_setupControllerListener);
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: widget.controller?.text,
      validator: (value) {
        final baseValidation = _baseValidator(value);
        if (baseValidation != null) {
          return baseValidation;
        }
        if (widget.validation != null) {
          final additionalValidation = widget.validation!(
            value,
            _selectedCountry?.value?.dialCode,
          );
          if (additionalValidation != null) {
            _triggerValidationCallback(false, _selectedCountry?.value?.dialCode, value);
            return additionalValidation;
          }
        }

        return null;
      },
      builder: (FormFieldState<String> state) {
        if (widget.controller != null && widget.controller!.text != state.value) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            state.didChange(widget.controller!.text);
            state.validate();
          });
        }

        return Padding(
          padding: widget.padding,
          child: TextFormField(
            keyboardType: TextInputType.phone,
            controller: _effectiveController,
            autofocus: false,
            decoration: InputDecoration(
              counterText: '',
              hintText: "0" * (_selectedCountry?.value?.maxLength ?? 10),
              hintStyle: CustomTextStyles.custom15Regular.copyWith(color: AppColors.neutral50.withOpacity(0.5)),
              border: _inputBorder(AppColors.neutral50.withOpacity(0.7)),
              enabledBorder: _inputBorder(AppColors.neutral50.withOpacity(0.7)),
              focusedBorder: _inputBorder(AppColors.neutral50),
              focusedErrorBorder: _inputBorder(AppColors.error),
              errorBorder: _inputBorder(AppColors.error),
              prefixIcon: SelectableItemBottomSheet(
                title: "select country",
                selectableItems: _countries,
                selectedItem: _selectedCountry,
                canSearchItems: true,
                isEnabled: widget.isEnabled,
                // disabledSnackBarMessage: canSelectInternationalNumber ? null : "You don't have permission to add international number",
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        " +${_selectedCountry?.value?.dialCode ?? ''} ${_selectedCountry?.value?.flag ?? ''}",
                        style: CustomTextStyles.custom14Medium.copyWith(color: Colors.white),
                      ),
                      Container(
                        width: 1.5,
                        height: 40,
                        color: Colors.grey.withOpacity(0.3),
                        margin: const EdgeInsets.only(left: 10, right: 5),
                      ),
                    ],
                  ),
                ),
                onItemSelected: (selectedValue) {
                  setState(() {
                    _selectedCountry = selectedValue;
                    _effectiveController.text = "";
                  });
                },
              ),
            ),
            style: CustomTextStyles.custom14Medium.copyWith(
              color: Colors.white,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: null,
            maxLength: _selectedCountry?.value?.maxLength ?? 10,
            readOnly: false,
            onTap: () {},
            enabled: widget.isEnabled,
            cursorColor: AppColors.neutral50,
            onChanged: (value) {
              if (value.isEmpty) {
                _triggerValidationCallback(false, _selectedCountry?.value?.dialCode, null);
              }
            },
            validator: _baseValidator,
          ),
        );
      },
    );
  }

  OutlineInputBorder _inputBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color),
    );
  }
}
/*import 'package:collection/collection.dart';
import 'package:file_hub/core/common/widgets/phone_field/countries.dart';
import 'package:file_hub/core/common/widgets/selectable_item_bottom_sheet.dart';
import 'package:file_hub/core/extensions/string_extension.dart';
import 'package:file_hub/core/resources/themes/app_colors.dart';
import 'package:file_hub/core/resources/themes/text_styles.dart';
import 'package:flutter/material.dart';

class PhoneField extends StatefulWidget {
  final String labelText;
  final String? hintText;
  final bool isRequired;
  final TextEditingController? controller;
  final String? selectedDialCode;
  final Function(bool isValid, String fullNumber)? onValidationChanged;
  final bool isEnabled;
  final String? Function(String? fullNumber)? validation;
  final EdgeInsetsGeometry padding;

  const PhoneField({
    super.key,
    this.controller,
    required this.labelText,
    this.hintText,
    this.isRequired = false,
    this.selectedDialCode,
    this.onValidationChanged,
    this.isEnabled = true,
    this.validation,
    this.padding = const EdgeInsets.all(10),
  });

  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  late final List<SelectableItem<Country>> _countries;
  SelectableItem<Country>? _selectedCountry;
  final TextEditingController _internalController = TextEditingController();
  String? _lastProcessedValue;

  TextEditingController get _effectiveController => widget.controller ?? _internalController;

  @override
  void initState() {
    super.initState();
    _initializeCountries();
    _setupControllerListener();
    _processInitialValue();
  }

  void _initializeCountries() {
    _countries = countryCodes.map((e) => SelectableItem<Country>(title: "${e.flag} ${e.name}", value: e)).toList();
    _updateSelectedCountry();
  }

  void _processInitialValue() {
    if (_effectiveController.text.isNotEmpty) {
      _processPhoneNumber(_effectiveController.text);
    }
  }

  void _updateSelectedCountry() {
    final dialCode = widget.selectedDialCode?.replaceAll("+", '') ?? "91";
    setState(() {
      _selectedCountry = _countries.firstWhere(
            (element) => element.value?.dialCode == dialCode,
        orElse: () => _countries.first,
      );
    });
  }

  void _setupControllerListener() {
    _effectiveController.addListener(() {
      final newValue = _effectiveController.text;
      if (newValue != _lastProcessedValue) {
        _lastProcessedValue = newValue;
        _processPhoneNumber(newValue);
      }
    });
  }

  void _processPhoneNumber(String value) {
    if (value.isEmpty) return;
    String fullNumber = "+${_selectedCountry?.value?.dialCode ?? ''}$value";
    _triggerValidationCallback(true, fullNumber);
  }

  String? _baseValidator(String? value) {
    final digitsOnly = RegExp(r'^\d+\$');
    if (value == null || value.isEmpty) {
      if (widget.isRequired) {
        _triggerValidationCallback(false, "");
        return "${widget.labelText} is required field";
      } else {
        _triggerValidationCallback(true, "");
        return null;
      }
    }
    if (!digitsOnly.hasMatch(value)) {
      _triggerValidationCallback(false, "");
      return "Only digits are allowed";
    }
    String fullNumber = "+${_selectedCountry?.value?.dialCode ?? ''}$value";
    _triggerValidationCallback(true, fullNumber);
    return null;
  }

  void _triggerValidationCallback(bool isValid, String fullNumber) {
    if (widget.onValidationChanged != null) {
      widget.onValidationChanged!(isValid, fullNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: TextFormField(
        keyboardType: TextInputType.phone,
        controller: _effectiveController,
        autofocus: false,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: CustomTextStyles.custom15Regular.copyWith(color: AppColors.neutral50.withOpacity(0.5)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          prefixIcon: SelectableItemBottomSheet(
            title: "Select country",
            selectableItems: _countries,
            selectedItem: _selectedCountry,
            canSearchItems: true,
            isEnabled: widget.isEnabled,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    " +${_selectedCountry?.value?.dialCode ?? ''} ${_selectedCountry?.value?.flag ?? ''}",
                    style: CustomTextStyles.custom14Medium.copyWith(color: Colors.black),
                  ),
                  Container(
                    width: 1.5,
                    height: 40,
                    color: Colors.grey.withOpacity(0.3),
                    margin: const EdgeInsets.only(left: 10, right: 5),
                  ),
                ],
              ),
            ),
            onItemSelected: (selectedValue) {
              setState(() {
                _selectedCountry = selectedValue;
                _effectiveController.text = "";
              });
            },
          ),
        ),
        style: CustomTextStyles.custom14Medium.copyWith(
          color: Colors.black,
          overflow: TextOverflow.ellipsis,
        ),
        maxLength: _selectedCountry?.value?.maxLength ?? 10,
        enabled: widget.isEnabled,
        cursorColor: Colors.red,
        validator: (value) => _baseValidator(value),
      ),
    );
  }
}*/
