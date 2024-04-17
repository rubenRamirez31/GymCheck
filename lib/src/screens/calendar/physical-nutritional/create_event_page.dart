import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gym_check/src/screens/calendar/widgets/custom_button.dart';
import 'package:gym_check/src/screens/calendar/widgets/date_time_selector.dart';

import '../app_colors.dart';
import '../constants.dart';
import '../extension.dart';

class AddOrEditEventForm extends StatefulWidget {
  final void Function(CalendarEventData)? onEventAdd;
  final CalendarEventData? event;
  final DateTime? defaultStartDate;

  const AddOrEditEventForm({
    Key? key,
    this.onEventAdd,
    this.event,
    this.defaultStartDate,
  }) : super(key: key);

  @override
  _AddOrEditEventFormState createState() => _AddOrEditEventFormState();
}

class _AddOrEditEventFormState extends State<AddOrEditEventForm> {
  late DateTime _startDate;
  late DateTime _endDate = DateTime.now().withoutTime;

  DateTime? _startTime;
  DateTime? _endTime;

  Color _color = Colors.blue;

  final _form = GlobalKey<FormState>();

  late final _descriptionController = TextEditingController();
  late final _titleController = TextEditingController();
  late final _titleNode = FocusNode();
  late final _descriptionNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _startDate = widget.defaultStartDate ?? DateTime.now().withoutTime;
    _setDefaults();
  }

  @override
  void dispose() {
    _titleNode.dispose();
    _descriptionNode.dispose();

    _descriptionController.dispose();
    _titleController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _titleController,
            decoration: AppConstants.inputDecoration.copyWith(
              labelText: "Título del Evento",
            ),
            style: TextStyle(
              color: AppColors.black,
              fontSize: 17.0,
            ),
            validator: (value) {
              final title = value?.trim();

              if (title == null || title == "")
                return "Por favor ingresa el título del evento.";

              return null;
            },
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                child: DateTimeSelectorFormField(
                  decoration: AppConstants.inputDecoration.copyWith(
                    labelText: "Fecha de Inicio",
                  ),
                  initialDateTime: _startDate,
                  onSelect: (date) {
                    if (date.withoutTime.withoutTime
                        .isAfter(_endDate.withoutTime)) {
                      _endDate = date.withoutTime;
                    }

                    _startDate = date.withoutTime;

                    if (mounted) {
                      setState(() {});
                    }
                  },
                  validator: (value) {
                    if (value == null || value == "")
                      return "Por favor selecciona la fecha de inicio.";

                    return null;
                  },
                  textStyle: TextStyle(
                    color: AppColors.black,
                    fontSize: 17.0,
                  ),
                  onSave: (date) => _startDate = date ?? _startDate,
                  type: DateTimeSelectionType.date,
                ),
              ),
              SizedBox(width: 20.0),
              Expanded(
                child: DateTimeSelectorFormField(
                  initialDateTime: _endDate,
                  decoration: AppConstants.inputDecoration.copyWith(
                    labelText: "Fecha de Finalización",
                  ),
                  onSelect: (date) {
                    if (date.withoutTime.withoutTime
                        .isBefore(_startDate.withoutTime)) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'La fecha de finalización ocurre antes de la fecha de inicio.'),
                      ));
                    } else {
                      _endDate = date.withoutTime;
                    }

                    if (mounted) {
                      setState(() {});
                    }
                  },
                  validator: (value) {
                    if (value == null || value == "")
                      return "Por favor selecciona la fecha de finalización.";

                    return null;
                  },
                  textStyle: TextStyle(
                    color: AppColors.black,
                    fontSize: 17.0,
                  ),
                  onSave: (date) => _endDate = date ?? _endDate,
                  type: DateTimeSelectionType.date,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: DateTimeSelectorFormField(
                  decoration: AppConstants.inputDecoration.copyWith(
                    labelText: "Hora de Inicio",
                  ),
                  initialDateTime: _startTime,
                  minimumDateTime: CalendarConstants.epochDate,
                  onSelect: (date) {
                    if (_endTime != null &&
                        date.getTotalMinutes > _endTime!.getTotalMinutes) {
                      _endTime = date.add(Duration(minutes: 1));
                    }
                    _startTime = date;

                    if (mounted) {
                      setState(() {});
                    }
                  },
                  onSave: (date) => _startTime = date,
                  textStyle: TextStyle(
                    color: AppColors.black,
                    fontSize: 17.0,
                  ),
                  type: DateTimeSelectionType.time,
                ),
              ),
              SizedBox(width: 20.0),
              Expanded(
                child: DateTimeSelectorFormField(
                  decoration: AppConstants.inputDecoration.copyWith(
                    labelText: "Hora de Finalización",
                  ),
                  initialDateTime: _endTime,
                  onSelect: (date) {
                    if (_startTime != null &&
                        date.getTotalMinutes < _startTime!.getTotalMinutes) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'La hora de finalización es anterior a la hora de inicio.'),
                      ));
                    } else {
                      _endTime = date;
                    }

                    if (mounted) {
                      setState(() {});
                    }
                  },
                  onSave: (date) => _endTime = date,
                  textStyle: TextStyle(
                    color: AppColors.black,
                    fontSize: 17.0,
                  ),
                  type: DateTimeSelectionType.time,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          TextFormField(
            controller: _descriptionController,
            focusNode: _descriptionNode,
            style: TextStyle(
              color: AppColors.black,
              fontSize: 17.0,
            ),
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            selectionControls: MaterialTextSelectionControls(),
            minLines: 1,
            maxLines: 10,
            maxLength: 1000,
            validator: (value) {
              if (value == null || value.trim() == "")
                return "Por favor ingresa la descripción del evento.";

              return null;
            },
            decoration: AppConstants.inputDecoration.copyWith(
              hintText: "Descripción del Evento",
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Row(
            children: [
              Text(
                "Color del Evento: ",
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 17,
                ),
              ),
              GestureDetector(
                onTap: _displayColorPicker,
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: _color,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          CustomButton(
            onTap: () {
              if (!(_form.currentState?.validate() ?? true)) return;

              _form.currentState?.save();

              final event = CalendarEventData(
                date: _startDate,
                endTime: _endTime,
                startTime: _startTime,
                endDate: _endDate,
                color: _color,
                title: _titleController.text.trim(),
                description: _descriptionController.text.trim(),
              );

              print(event);

              _resetForm();
            },
            title: widget.event == null ? "Agregar Evento" : "Actualizar Evento",
          ),
        ],
      ),
    );
  }

  void _setDefaults() {
  if (widget.event == null) {
    _startDate = widget.defaultStartDate ?? DateTime.now().withoutTime;
    _endDate = widget.defaultStartDate ?? DateTime.now().withoutTime;
    return;
  }

  final event = widget.event!;

  _startDate = event.date;
  _endDate = event.endDate;
  _startTime = event.startTime ?? _startTime;
  _endTime = event.endTime ?? _endTime;
  _titleController.text = event.title;
  _descriptionController.text = event.description ?? '';
}

  void _resetForm() {
    _form.currentState?.reset();
    _startDate = widget.defaultStartDate ?? DateTime.now().withoutTime;
    _endDate =  widget.defaultStartDate ?? DateTime.now().withoutTime;
    _startTime = null;
    _endTime = null;
    _color = Colors.blue;

    if (mounted) {
      setState(() {});
    }
  }

  void _displayColorPicker() {
    var color = _color;
    showDialog(
      context: context,
      useSafeArea: true,
      barrierColor: Colors.black26,
      builder: (_) => SimpleDialog(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        contentPadding: EdgeInsets.all(20.0),
        children: [
          Text(
            "Seleccionar color del evento",
            style: TextStyle(
              color: AppColors.black,
              fontSize: 25.0,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0),
            height: 1.0,
            color: AppColors.bluishGrey,
          ),
          ColorPicker(
            displayThumbColor: true,
            enableAlpha: false,
            pickerColor: _color,
            onColorChanged: (c) {
              color = c;
            },
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 50.0, bottom: 30.0),
              child: CustomButton(
                title: "Seleccionar",
                onTap: () {
                  if (mounted)
                    setState(() {
                      _color = color;
                    });
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CreateEventPage extends StatelessWidget {
  const CreateEventPage({Key? key, this.event, this.defaultStartDate}) : super(key: key);

  final CalendarEventData? event;
  final DateTime? defaultStartDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.black,
          ),
        ),
        title: Text(
          event == null ? "Crear Nuevo Evento" : "Actualizar Evento",
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: AddOrEditEventForm(
            onEventAdd: (newEvent) {
              print(newEvent);
            },
            event: event,
            defaultStartDate: defaultStartDate,
          ),
        ),
      ),
    );
  }
}
