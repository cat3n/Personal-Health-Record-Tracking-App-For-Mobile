import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Main widget for calculating heart rate zones based on age and exercise intensity.
class HeartRateCalculator extends StatefulWidget {
  const HeartRateCalculator({super.key});

  @override
  State<HeartRateCalculator> createState() => _HeartRateCalculatorState();
}

class _HeartRateCalculatorState extends State<HeartRateCalculator>
    with SingleTickerProviderStateMixin {
  int _age = 25; // User's age
  String _intensity = 'Moderate'; // Exercise intensity level

  late AnimationController _controller; // Controls heartbeat animation timing

  @override
  void initState() {
    super.initState();

    // Initialize animation controller with duration based on heart rate and repeat it
    _controller = AnimationController(
      vsync: this,
      duration: getHeartBeatDuration(),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose animation controller to free resources
    super.dispose();
  }

  /// Calculates the animation duration based on target heart beats per minute (BPM)
  Duration getHeartBeatDuration() {
    int maxHR = 220 - _age; // Formula to get max heart rate
    int bpm;

    // Adjust BPM based on intensity level
    switch (_intensity) {
      case 'Mild':
        bpm = (maxHR * 0.10).round();
        break;
      case 'Moderate':
        bpm = (maxHR * 0.15).round();
        break;
      case 'Intense':
        bpm = (maxHR * 0.20).round();
        break;
      default:
        bpm = 60; // Fallback BPM
    }

    // Convert BPM to duration in milliseconds per beat
    return Duration(milliseconds: (60000 / bpm).round());
  }

  /// Determines the scale factor for the heartbeat animation based on intensity
  double getScaleFromBPM() {
    int maxHR = 220 - _age;
    double bpm;

    switch (_intensity) {
      case 'Mild':
        bpm = maxHR * 0.55;
        break;
      case 'Moderate':
        bpm = maxHR * 0.65;
        break;
      case 'Intense':
        bpm = maxHR * 0.80;
        break;
      default:
        bpm = 60;
    }

    // Scale factor: normalized range between 1.0 and 1.5
    return 1.0 + ((bpm - 60) / 100).clamp(0.0, 0.5);
  }

  /// Returns the heart rate target range as a string based on intensity
  String getTargetHeartRateRange() {
    int maxHR = 220 - _age;
    double lower, upper;

    switch (_intensity) {
      case 'Mild':
        lower = maxHR * 0.50;
        upper = maxHR * 0.60;
        break;
      case 'Moderate':
        lower = maxHR * 0.60;
        upper = maxHR * 0.70;
        break;
      case 'Intense':
        lower = maxHR * 0.70;
        upper = maxHR * 0.85;
        break;
      default:
        return '';
    }

    return '${lower.round()} – ${upper.round()} bpm';
  }

  @override
  Widget build(BuildContext context) {
    // Define heartbeat scale animation
    final scaleAnimation = Tween(begin: 1.0, end: getScaleFromBPM()).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title
              const Text(
                'Heart Rate Zone',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 6),

              // Subtitle
              const Text(
                'Calculate your optimal exercise pulse',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 30),

              // Card container
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 15,
                      offset: Offset(0, 6),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Age label
                    const Text('👤 Age:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),

                    // Age slider
                    Slider(
                      value: _age.toDouble(),
                      min: 10,
                      max: 100,
                      divisions: 90,
                      label: '$_age',
                      onChanged: (value) {
                        setState(() {
                          _age = value.round();

                          // Update animation speed on age change
                          _controller.duration = getHeartBeatDuration();
                          _controller.reset();
                          _controller.repeat(reverse: true);
                        });
                      },
                    ),

                    // Display selected age
                    Center(
                      child: Text('$_age years old',
                          style: const TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(height: 24),

                    // Intensity label
                    const Text('⚡ Exercise Intensity',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 6),

                    // Dropdown to select intensity level
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      dropdownColor: const Color(0xFFF7ECFF),
                      borderRadius: BorderRadius.circular(20),
                      value: _intensity,
                      items: ['Mild', 'Moderate', 'Intense']
                          .map((level) => DropdownMenuItem(
                        value: level,
                        child: Row(
                          children: [
                            Icon(
                              level == 'Mild'
                                  ? Icons.accessibility_new
                                  : level == 'Moderate'
                                  ? Icons.directions_run
                                  : Icons.whatshot,
                              color: Colors.deepPurple,
                            ),
                            const SizedBox(width: 8),
                            Text(level),
                          ],
                        ),
                      ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _intensity = value;

                            // Update heartbeat animation when intensity changes
                            _controller.duration = getHeartBeatDuration();
                            _controller.reset();
                            _controller.repeat(reverse: true);
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 30),

                    // Target heart rate label
                    const Text('📈 Target Heart Beat:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),

                    // Display target heart rate range
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          // Display heart rate range
                          Expanded(
                            child: Text(
                              getTargetHeartRateRange(),
                              style: const TextStyle(
                                fontSize: 25,
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Animated heartbeat graphic using Lottie
                          ScaleTransition(
                            scale: scaleAnimation,
                            child: SizedBox(
                              height: 60,
                              width: 60,
                              child: Lottie.asset(
                                'assets/heartbeat.json',
                                controller: _controller,
                                onLoaded: (composition) {
                                  // Ensure animation updates to match current BPM
                                  _controller.duration = getHeartBeatDuration();
                                  _controller.repeat(reverse: true);
                                },
                                repeat: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
