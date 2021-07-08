~switchState = 0;
//MIDI
MIDIClient.init;
//MIDIIn.connectAll;
MIDIIn.connect(inport: 0, device: MIDIIn.findPort("Midi Through", "Midi Through Port-0"));

MIDIdef.cc(\changePatch, {arg ...args;
	args.postln;

	switch (~switchState,
		        0, {~switchState = ~switchState + 1; ~grainDistTrem.(monophonic: true); "grainDistTrem monophonic".postln; },
		        1, {~switchState = ~switchState + 1; ~grainDistTrem.(monophonic: true); "grainDistTrem monophonic".postln},
		        2, {~switchState = 0; ~grainDistTrem.(monophonic: false); "grainDistTrem polyphonic".postln},
	);
},
16
);
~grainDistTrem.(monophonic: true); "grainDistTrem monophonic".postln;
//MIDIdef.freeAll