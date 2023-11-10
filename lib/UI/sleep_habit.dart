// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import './smoke_habit.dart';

class SleepHabitScreen extends StatefulWidget {
  @override
  _SleepHabitScreenState createState() => _SleepHabitScreenState();
}

class _SleepHabitScreenState extends State<SleepHabitScreen> {
  String? _selectedHabit;

  Widget _buildSelectionOption(String habit) {
    bool isSelected = _selectedHabit == habit;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedHabit = habit;
          });
        },
        child: Container(
          margin: EdgeInsets.all(8.0),
          padding: EdgeInsets.symmetric(vertical: 16.0),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.blue),
          ),
          alignment: Alignment.center,
          child: Text(
            habit,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.blue,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> options = [
      'Early bird',
      'Night owl',
      'Intermediate',
      'Does not matter'
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Handle skip action
            },
            child: Text('Skip', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lifestyle preference',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Select your preferences in ideal roommate',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 32.0),
            Text(
              'Their sleeping habits',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24.0),
            // First row of options
            Row(
              children: options
                  .sublist(0, 2)
                  .map((habit) => _buildSelectionOption(habit))
                  .toList(),
            ),
            // Second row of options
            Row(
              children: options
                  .sublist(2)
                  .map((habit) => _buildSelectionOption(habit))
                  .toList(),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SmokingHabits()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 60), // Width and height
                ),
                child: Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
