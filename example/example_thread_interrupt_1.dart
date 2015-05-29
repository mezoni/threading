library threading.example.example_thread_interrupt_1;

import "dart:async";

import "package:threading/threading.dart";

Future main() async {
  await new Example().run();
}

class Example {
  bool _sleepSwitch = false;

  void set sleepSwitch(bool sleepSwitch) {
    _sleepSwitch = sleepSwitch;
  }

  Future run() async {
    var thread = new Thread(work);
    await thread.start();
    // The following line causes an exception to be thrown
    // in "work" if thread is currently blocked
    // or becomes blocked in the future.
    await thread.interrupt();
    print("Main thread calls interrupt on new thread.");
    // Tell newThread to go to sleep.
    sleepSwitch = true;
    // Wait for new thread to end.
    await thread.join();
  }

  Future work() async {
    print("Thread is executing 'work'.");
    while (!_sleepSwitch) {
      await Thread.sleep(0);
    }

    try {
      print("Thread going to sleep.");
      // When thread goes to sleep, it is immediately
      // woken up by a ThreadInterruptException.
      await Thread.sleep(-1);
    } on ThreadInterruptException catch (e) {
      print("Thread cannot go to sleep - interrupted by main thread.");
    }
  }
}