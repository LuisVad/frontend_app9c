import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_app9c/main.dart'; // Ajusta el import según la ubicación de tu archivo main.dart
import 'package:frontend_app9c/presentation/cubit/car_cubit.dart';
import 'package:frontend_app9c/presentation/cubit/car_state.dart';
import 'package:frontend_app9c/presentation/screens/car_crud.dart';
import 'package:frontend_app9c/data/models/car_model.dart';
import 'package:mockito/mockito.dart';

// Mock de CarCubit
class MockCarCubit extends Mock implements CarCubit {}

void main() {
  testWidgets('Car List Screen displays cars and navigates to Add Car Screen', (WidgetTester tester) async {
    // Mock data
    final mockCars = [
      CarModel(id: '1', mark: 'Toyota', model: 'Corolla', autonomy: 500, topSpeed: 180),
      CarModel(id: '2', mark: 'Ford', model: 'Focus', autonomy: 450, topSpeed: 200),
    ];

    // Mock Cubit
    final carCubit = MockCarCubit();
    when(carCubit.stream).thenAnswer((_) => Stream.value(CarSuccess(cars: mockCars)));
    when(carCubit.state).thenReturn(CarSuccess(cars: mockCars));

    await tester.pumpWidget(
      BlocProvider<CarCubit>.value(
        value: carCubit,
        child: MaterialApp(
          home: CarListView(),
          routes: {
            '/add': (context) => CarForm(),
          },
        ),
      ),
    );

    // Verify that cars are displayed in the list
    expect(find.text('Toyota'), findsOneWidget);
    expect(find.text('Ford'), findsOneWidget);

    // Tap the '+' icon to navigate to the Add Car Screen
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Verify that we are on the Add Car Screen
    expect(find.text('Create Car'), findsOneWidget); // Verifica el texto correcto según el título en tu pantalla de agregar vehículo
  });

  testWidgets('Add Car Screen allows input and submits car', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CarForm(),
      ),
    );

    // Enter car details
    await tester.enterText(find.byType(TextFormField).at(0), 'Toyota');
    await tester.enterText(find.byType(TextFormField).at(1), 'Camry');
    await tester.enterText(find.byType(TextFormField).at(2), '450');
    await tester.enterText(find.byType(TextFormField).at(3), '190');

    // Tap the submit button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Verify that we return to the Car List Screen
    expect(find.text('Car List'), findsOneWidget); // Verifica el texto correcto según el título en tu pantalla de lista de vehículos
  });
}
