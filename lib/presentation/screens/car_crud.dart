import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/car_model.dart';
import '../cubit/car_cubit.dart';
import '../cubit/car_state.dart';

class CarListView extends StatelessWidget {
  const CarListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car List'),
      ),
      body: const CarListScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const CarForm(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CarListScreen extends StatefulWidget {
  const CarListScreen({Key? key}) : super(key: key);

  @override
  _CarListScreenState createState() => _CarListScreenState();
}

class _CarListScreenState extends State<CarListScreen> {
  late CarCubit carCubit;

  @override
  void initState() {
    super.initState();
    carCubit = BlocProvider.of<CarCubit>(context);
    carCubit.fetchAllCars(); // Cargar la lista de autos automáticamente
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            carCubit.fetchAllCars();
          },
          child: const Text('Fetch Cars'),
        ),
        Expanded(
          child: BlocBuilder<CarCubit, CarState>(
            builder: (context, state) {
              if (state is CarLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CarSuccess) {
                final cars = state.cars;
                return ListView.builder(
                  itemCount: cars.length,
                  itemBuilder: (context, index) {
                    final car = cars[index];
                    return ListTile(
                      title: Text(car.mark),
                      subtitle: Text('${car.model}, ${car.owner}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => CarForm(car: car),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Car'),
                                  content: const Text('Are you sure you want to delete this car?'),
                                  actions: [
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Delete'),
                                      onPressed: () {
                                        carCubit.deleteCar(car.id!);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else if (state is CarError) {
                return Center(child: Text('Error: ${state.message}'));
              }
              return const Center(child: Text('Press the button to fetch cars'));
            },
          ),
        ),
      ],
    );
  }
}

class CarForm extends StatefulWidget {
  final CarModel? car;

  const CarForm({Key? key, this.car}) : super(key: key);

  @override
  _CarFormState createState() => _CarFormState();
}

class _CarFormState extends State<CarForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _idController;
  late TextEditingController _ownerController;
  late TextEditingController _markController;
  late TextEditingController _modelController;
  late TextEditingController _autonomyController;
  late TextEditingController _topSpeedController;
  late TextEditingController _horsePowerController;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(text: widget.car?.id ?? '');
    _ownerController = TextEditingController(text: widget.car?.owner ?? '');
    _markController = TextEditingController(text: widget.car?.mark ?? '');
    _modelController = TextEditingController(text: widget.car?.model ?? '');
    _autonomyController = TextEditingController(text: widget.car?.autonomy.toString() ?? '');
    _topSpeedController = TextEditingController(text: widget.car?.topSpeed.toString() ?? '');
    _horsePowerController = TextEditingController(text: widget.car?.horsePower.toString() ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final carCubit = BlocProvider.of<CarCubit>(context);

    return AlertDialog(
      title: Text(widget.car == null ? 'Create Car' : 'Update Car'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _idController,
              decoration: const InputDecoration(labelText: 'ID'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an ID';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _ownerController,
              decoration: const InputDecoration(labelText: 'Owner'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an owner';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _markController,
              decoration: const InputDecoration(labelText: 'Mark'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a mark';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _modelController,
              decoration: const InputDecoration(labelText: 'Model'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a model';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _autonomyController,
              decoration: const InputDecoration(labelText: 'Autonomy'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter autonomy';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _topSpeedController,
              decoration: const InputDecoration(labelText: 'Top Speed'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a top speed';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _horsePowerController,
              decoration: const InputDecoration(labelText: 'Horse Power'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter horse power';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Save'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final car = CarModel(
                id: _idController.text, // Usa el valor del ID del formulario
                owner: _ownerController.text,
                mark: _markController.text,
                model: _modelController.text,
                autonomy: double.parse(_autonomyController.text),
                topSpeed: double.parse(_topSpeedController.text),
                horsePower: double.parse(_horsePowerController.text),
              );
              if (widget.car == null) {
                carCubit.createCar(car).then((_) => carCubit.fetchAllCars());
              } else {
                carCubit.updateCar(car).then((_) => carCubit.fetchAllCars());
              }
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
