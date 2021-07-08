////////////OSC Funcs

//OSC Func Clear
~oscClear = {
	OSCdef(\flute).free;
	OSCdef(\clarinet).free;
	OSCdef(\piano).free;
};

~grainFlNodes = Array.newClear;
~grainClNodes = Array.newClear;
~grainPnoNodes = Array.newClear;

~tremoloFreq = Pxrand([1/8, 1/6, 1/4, 1/3, 1/2, 1, 1 + 1/8, 1 + 1/6, 1 + 1/4, 1 + 1/3, 1 + 1/2, 2, 2 + 1/8, 2 + 1/6, 2 + 1/4, 2 + 1/3, 2 + 1/2 ], inf).asStream; //aux
~randomRelease = Pwhite(1,3).asStream; //aux

////////Grano y distorsión con trémolo
~grainDistTrem = {|monophonic = true|
	~oscClear.();
	/// Flute
	OSCdef(\flute, {|msg|
		var relTime = ~randomRelease.next;
		if( monophonic,
			{
				~grainClNodes.do{|synth, i| /* synth.release; */ ~grainClNodes.removeAt(i)};
				~grainClGroup.release;
				~fxClGroup.release;
				~grainPnoNodes.do{|synth, i| /* synth.release; */~grainPnoNodes.removeAt(i)};
				~grainPnoGroup.release;
				~fxPnoGroup.release;
			},
			{
				~grainFlNodes.do{|synth, i| synth.release; ~grainFlNodes.removeAt(i)};
				~grainFlGroup.release;
				~fxFlGroup.release;
			}
		);

		if(~grainFlNodes.size == 0,
			{
				var randFreq = ~tremoloFreq.next;

				~encoderSynthFl.set(\angleFreq, randFreq, \azimFreq, randFreq);

				~grainFlNodes.add(
					Synth(\grainFreeze, [\inBus, ~inFlBus, \outBus, ~grainFlBus, \attackTime, 2, \releaseTime, relTime, \rate, 1], ~grainFlGroup)
				);

				~grainFlNodes.add(
					Synth(\crossoverDistortion, [\inBus, ~grainFlBus, \outBus, ~distFlBus, \mix, 0.5, \amp, 0.7, \distort, 0.01, \smooth, 0.7.rand, \attackTime, 4.rand, \decayTime, 0, \sustainLevel, 1, \releaseTime, relTime, \tremoloFreq, randFreq, \tremoloMix, 0.5.rand], ~fxFlGroup));
			}
		);

	}, '/onsets', argTemplate: [nil, 1, nil, nil]);

	/// Clarinet
	OSCdef(\clarinet, {|msg|
		var relTime = ~randomRelease.next;
		if( monophonic,
			{
				~grainFlNodes.do{|synth, i| /* synth.release; */ ~grainFlNodes.removeAt(i)};
				~grainFlGroup.release;
				~fxFlGroup.release;
				~grainPnoNodes.do{|synth, i| /* synth.release; */ ~grainPnoNodes.removeAt(i)};
				~grainPnoGroup.release;
				~fxPnoGroup.release;
			},
			{
				~grainClNodes.do{|synth, i| synth.release; ~grainClNodes.removeAt(i)};
				~grainClGroup.release;
				~fxClGroup.release;
			}
		);

		if(~grainClNodes.size == 0,
			{
				var randFreq = ~tremoloFreq.next;

				~encoderSynthFl.set(\angleFreq, randFreq, \azimFreq, randFreq);

				~grainClNodes.add(
					Synth(\grainFreeze, [\inBus, ~inClBus, \outBus, ~grainClBus, \attackTime, 2, \releaseTime, relTime, \rate, 1], ~grainClGroup));

				~grainClNodes.add(
					Synth(\crossoverDistortion, [\inBus, ~grainClBus, \outBus, ~distClBus, \mix, 0.5, \amp, 0.7, \distort, 0.01, \smooth, 0.7.rand, \attackTime, 4.rand, \decayTime, 0, \sustainLevel, 1, \releaseTime, relTime, \tremoloFreq, randFreq, \tremoloMix, 0.5.rand], ~fxClGroup)
				)
			}
		);

	}, '/onsets', argTemplate: [nil, 2, nil, nil]);

	/// Piano
	OSCdef(\piano, {|msg|

		var relTime = ~randomRelease.next;

		if( monophonic,
			{
				~grainClNodes.do{|synth, i| /* synth.release; */ ~grainClNodes.removeAt(i)};
				~grainClGroup.release;
				~fxClGroup.release;
				~grainFlNodes.do{|synth, i| /* synth.release; */ ~grainFlNodes.removeAt(i)};
				~grainFlGroup.release;
				~fxFlGroup.release;
			},
			{
				~grainPnoNodes.do{|synth, i| synth.release; ~grainPnoNodes.removeAt(i)};
				~grainPnoGroup.release;
				~fxPnoGroup.release;
			}
		);

		if(~grainPnoNodes.size == 0,
			{
				var randFreq = ~tremoloFreq.next;

				~encoderSynthFl.set(\angleFreq, randFreq, \azimFreq, randFreq);

				~grainPnoNodes.add(
					Synth(\grainFreeze, [\inBus, ~inPnoBus, \outBus, ~grainPnoBus, \attackTime, 2, \releaseTime, relTime, \rate, 1], ~grainPnoGroup));

				~grainPnoNodes.add(
					Synth(\crossoverDistortion, [\inBus, ~grainPnoBus, \outBus, ~distPnoBus, \mix, 0.5, \amp, 0.7, \distort, 0.01, \smooth, 0.7.rand, \attackTime, 4.rand, \decayTime, 0, \sustainLevel, 1, \releaseTime, relTime, \tremoloFreq, randFreq, \tremoloMix, 0.5.rand], ~fxPnoGroup))
			}
		);

	}, '/onsets', argTemplate: [nil, 3, nil, nil]);
};

////////Pedal con variación del trémolo
~tremVarPedal = {|tremMixRand = 0.4, distort = 0.0001|
	~oscClear.();

	~fxFlGroup.set(\tremoloFreq, ~tremoloFreq.next, \tremoloMix, tremMixRand.rrand(1.0), \distort, distort);
	~fxClGroup.set(\tremoloFreq, ~tremoloFreq.next, \tremoloMix, tremMixRand.rrand(1.0), \distort, distort);
	~fxPnoGroup.set(\tremoloFreq, ~tremoloFreq.next, \tremoloMix, tremMixRand.rrand(1.0), \distort, distort);
};

//////// Distorsión aleatoria sobre cada ataque
~randomDist = {
	~releaseFX.();
	~oscClear.();
	~distFlNodes = Array.newClear;
	~distClNodes = Array.newClear;
	~distPnoNodes = Array.newClear;

	//OSC Def Flute
	OSCdef(\flute, {|msg|

		if(0.5.coin, {
			if(~distFlNodes.size == 0, {

				 var randFreq = ~tremoloFreq.next;

				~encoderSynthFl.set(\angleFreq, randFreq, \azimFreq, randFreq);

				~distFlNodes.add(
					Synth(\crossoverDistortion, [\inBus, ~inFlBus, \outBus, ~distFlBus, \mix, 1, \amp, 1, \distort, 0.02, \smooth, 0.5.rand, \attackTime,0.01, \decayTime, 0, \sustainLevel, 1, \releaseTime, 1, \tremoloFreq, randFreq, \tremoloMix, 0.5.rrand(1), \tremoloAtk, 0.5.rrand(1.2)], ~fxFlGroup);
				)
			})
		});
		~distClNodes.do{|synth, i| synth.release; ~distClNodes.removeAt(i)};
		~fxClGroup.freeAll;

		~distPnoNodes.do{|synth, i| synth.release; ~distPnoNodes.removeAt(i)};
		~fxPnoGroup.freeAll;
	}, '/onsets', argTemplate: [nil, 1, nil, nil]);

	//OSC Def Clarinet
	OSCdef(\clarinet, {|msg|

		if(0.5.coin, {
			if(~distClNodes.size == 0, {

				 var randFreq = ~tremoloFreq.next;

				~encoderSynthCl.set(\angleFreq, randFreq, \azimFreq, randFreq);

				~distClNodes.add(
					Synth(\crossoverDistortion, [\inBus, ~inClBus, \outBus, ~distClBus, \mix, 1, \amp, 1, \distort, 0.02, \smooth, 0.5.rand, \attackTime,0.01, \decayTime, 0, \sustainLevel, 1, \releaseTime, 1, \tremoloFreq, randFreq, \tremoloMix, 0.5.rrand(1), \tremoloAtk, 0.5.rrand(1.2)], ~fxClGroup);
				)
			})
		});

		~distFlNodes.do{|synth, i| synth.release; ~distFlNodes.removeAt(i)};
		//~fxFlGroup.freeAll;
		~fxFlGroup.release;

		~distPnoNodes.do{|synth, i| synth.release; ~distPnoNodes.removeAt(i)};
		//~fxPnoGroup.freeAll;
		~fxPnoGroup.release;

	}, '/onsets', argTemplate: [nil, 2, nil, nil]);

	//OSC Def Piano
	OSCdef(\piano, {|msg|

		if(0.5.coin, {
			if(~distPnoNodes.size == 0, {

				 var randFreq = ~tremoloFreq.next;

				~encoderSynthPno.set(\angleFreq, randFreq, \azimFreq, randFreq);

				~distPnoNodes.add(Synth(\crossoverDistortion, [\inBus, ~inPnoBus, \outBus, ~distPnoBus, \mix, 1, \amp, 0.7, \distort, 0.02, \smooth, 0.5.rand, \attackTime,0.01, \decayTime, 0, \sustainLevel, 1, \releaseTime, 1, \tremoloFreq, randFreq, \tremoloMix, 0.5.rrand(1), \tremoloAtk, 0.5.rrand(1.2)], ~fxPnoGroup);
				);
			})
		});

		~distClNodes.do{|synth, i| synth.release; ~distClNodes.removeAt(i)};
		//~fxClGroup.freeAll;
		~fxClGroup.release;

		~distFlNodes.do{|synth, i| synth.release; ~distFlNodes.removeAt(i)};
		//~fxFlGroup.freeAll;
		~fxFlGroup.release;

	}, '/onsets', argTemplate: [nil, 3, nil, nil]);
};