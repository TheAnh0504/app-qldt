import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pinput/pinput.dart';
import 'package:app_qldt/core/common/formatter.dart';
import 'package:app_qldt/core/common/types.dart';
import 'package:app_qldt/core/theme/palette.dart';
import 'package:app_qldt/core/theme/typestyle.dart';

class TextInput extends StatefulWidget {
  const TextInput(
      {required this.hintText,
      super.key,
      this.forceErrorState = false,
      this.errorText,
      this.isPassword = false,
      this.validator,
      this.controller,
      this.autovalidateMode,
      this.keyboardType});

  final bool isPassword, forceErrorState;
  final String? Function(String?)? validator;
  final String hintText;
  final String? errorText;
  final TextEditingController? controller;
  final AutovalidateMode? autovalidateMode;
  final TextInputType? keyboardType;

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  bool isHidden = true;
  bool isError = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword && isHidden,
      autovalidateMode: widget.autovalidateMode,
      validator: (value) {
        final result = widget.validator?.call(value);
        if (!widget.forceErrorState) {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            setState(() {
              isError = result != null;
            });
          });
        }
        return result;
      },
      keyboardType: widget.keyboardType,
      cursorColor: Theme.of(context).colorScheme.primary,
      cursorErrorColor: Theme.of(context).colorScheme.error,
      decoration: InputDecoration(
          suffixIconColor: widget.forceErrorState || isError
              ? Theme.of(context).colorScheme.error
              : null,
          suffixIcon: widget.isPassword
              ? IconButton(
                  onPressed: () => setState(() {
                        isHidden = !isHidden;
                      }),
                  icon: isHidden
                      ? const FaIcon(FaIcons.eye)
                      : const FaIcon(FaIcons.eyeSlash))
              : null,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          hintText: widget.hintText,
          hintStyle: TypeStyle.body3.copyWith(
              color: widget.forceErrorState || isError
                  ? Theme.of(context).colorScheme.error
                  : Palette.grey55),
          errorStyle: TypeStyle.body5
              .copyWith(color: Theme.of(context).colorScheme.error),
          errorText: widget.errorText,
          filled: true,
          fillColor: Palette.white,
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.error, width: 1.5)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.error, width: 0.75)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary, width: 1.5)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary, width: 0.75)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
    );
  }
}

class DateInput extends StatefulWidget {
  const DateInput(
      {required this.dateFormat,
      super.key,
      this.autovalidateMode,
      this.controller,
      this.validator,
      this.hintText});

  final AutovalidateMode? autovalidateMode;
  final TextEditingController? controller;
  final DateFormat dateFormat;
  final String? Function(String?)? validator;
  final String? hintText;

  @override
  State<DateInput> createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  bool isError = false;
  TextEditingController internalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller ?? internalController,
      autovalidateMode: widget.autovalidateMode,
      validator: (value) {
        final result = widget.validator?.call(value);
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          setState(() {
            isError = result != null;
          });
        });
        return result;
      },
      cursorColor: Theme.of(context).colorScheme.primary,
      cursorErrorColor: Theme.of(context).colorScheme.error,
      keyboardType: TextInputType.datetime,
      inputFormatters: [DateTextFormatter()],
      decoration: InputDecoration(
          suffixIconColor: isError ? Theme.of(context).colorScheme.error : null,
          suffixIcon: Builder(builder: (context) {
            return IconButton(
                onPressed: () {
                  showDatePicker(
                          context: context,
                          firstDate: DateTime.now()
                              .copyWith(year: DateTime.now().year - 18 - 65),
                          lastDate: DateTime.now()
                              .copyWith(year: DateTime.now().year - 18))
                      .then((value) {
                    if (value == null) return;
                    setState(() {
                      (widget.controller ?? internalController).text =
                          widget.dateFormat.format(value);
                    });
                  });
                },
                icon: const FaIcon(FaIcons.calendar));
          }),
          errorStyle: TypeStyle.body5
              .copyWith(color: Theme.of(context).colorScheme.error),
          filled: true,
          fillColor: Palette.white,
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.error, width: 1.5)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.error, width: 0.75)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary, width: 1.5)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary, width: 0.75)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
    );
  }
}

class VerifyCodeInput extends StatelessWidget {
  const VerifyCodeInput(
      {required this.onCompleted,
      required this.isError,
      this.onChanged,
      super.key,
      this.errorText});

  final void Function(String) onCompleted;
  final void Function(String)? onChanged;
  final bool isError;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Pinput(
        length: 6,
        onCompleted: onCompleted,
        forceErrorState: isError,
        onChanged: onChanged,
        errorTextStyle: TypeStyle.body5.copyWith(
            color: Theme.of(context).colorScheme.error,
            fontStyle: FontStyle.italic),
        errorText: errorText,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        defaultPinTheme: PinTheme(
            width: 56,
            height: 56,
            textStyle: TypeStyle.bodySemiBold,
            decoration: BoxDecoration(
                color: Palette.grey40,
                borderRadius: BorderRadius.circular(20))),
        focusedPinTheme: PinTheme(
          width: 56,
          height: 56,
          textStyle: TypeStyle.bodySemiBold,
          decoration: BoxDecoration(
            color: Palette.grey40,
            border: Border.all(color: Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        errorPinTheme: PinTheme(
          width: 56,
          height: 56,
          textStyle: TypeStyle.bodySemiBold,
          decoration: BoxDecoration(
            color: Palette.grey40,
            border: Border.all(color: Theme.of(context).colorScheme.error),
            borderRadius: BorderRadius.circular(20),
          ),
        ));
  }
}

class DropdownInput<T> extends StatefulWidget {
  const DropdownInput(
      {required this.items,
      required this.onChanged,
      super.key,
      this.validator,
      this.autovalidateMode,
      this.value});

  final String? Function(T?)? validator;
  final List<DropdownMenuItem<T>> items;
  final AutovalidateMode? autovalidateMode;
  final void Function(T?)? onChanged;
  final T? value;

  @override
  State<DropdownInput<T>> createState() => _DropdownInputState<T>();
}

class _DropdownInputState<T> extends State<DropdownInput<T>> {
  bool isHidden = true;
  bool isError = false;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      icon: const FaIcon(FaIcons.chevronDown),
      iconSize: 16,
      autovalidateMode: widget.autovalidateMode,
      value: widget.value,
      validator: (value) {
        final result = widget.validator?.call(value);
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          setState(() {
            isError = result != null;
          });
        });
        return result;
      },
      dropdownColor: Palette.white,
      style: TypeStyle.body4.copyWith(
          color: isError ? Theme.of(context).colorScheme.error : Palette.black),
      decoration: InputDecoration(
          errorStyle: TypeStyle.body5
              .copyWith(color: Theme.of(context).colorScheme.error),
          filled: true,
          fillColor: Palette.white,
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.error, width: 1.5)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.error, width: 0.75)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary, width: 1.5)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary, width: 0.75)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
      items: widget.items,
      onChanged: widget.onChanged,
    );
  }
}
