//Disparar MIDI CC
MIDIIn.doControlAction(1000.rand, 1, 16, 1); // spoof a cc

~switchState = 0; ~grainDistTrem.(monophonic: true); "grainDistTrem monophonic".postln;//~randomDist.(); "randomDist".postln; monophonic".postln;
~switchState = 1; ~grainDistTrem.(monophonic: true); "grainDistTrem monophonic".postln;
~switchState = 2;  ~grainDistTrem.(monophonic: false); "grainDistTrem polyphonic".postln;

~switchState = 0;
