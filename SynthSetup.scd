	//Synths
	//In Channels definidos en GroupsBusesSetup.scd: ~inFlNum, ~inClNum, ~inPnoNum
	~fluteIn = Synth(\monoAudioIn, [\inBus, ~inFlNum;, \outBus, ~inFlBus], ~inGroup);
	~fluteAnalysis = Synth(\onsets, [\inBus, ~inFlBus, \id, 1, \threshold, 0.07, \floor, 0.1, \reltime, 4, \mingap, 30], ~analysisGroup);

	~clarinetIn = Synth(\monoAudioIn, [\inBus, ~inClNum, \outBus, ~inClBus], ~inGroup);
	~clarinetAnalysis = Synth(\onsets, [\inBus, ~inClBus, \id, 2, \threshold, 0.07, \floor, 0.2, \reltime, 4, \mingap, 30], ~analysisGroup);

	~pianoIn = Synth(\monoAudioIn, [\inBus, ~inPnoNum, \outBus, ~inPnoBus], ~inGroup);
	~pianoAnalysis = Synth(\onsets, [\inBus, ~inPnoBus, \id, 3, \threshold, 0.07, \floor, 0.2, \reltime, 4, \mingap, 30], ~analysisGroup);


//Ambisonics
~decoderSynth = Synth.new(\foaDecode, [\inBus, ~ambiBus], ~decoderGroup);

~encoderSynthFl = Synth.new(\foaEncode, [\inBus, ~distFlBus, \outBus, ~ambiBus], ~encFl);

~encoderSynthCl = Synth.new(\foaEncode, [\inBus, ~distClBus, \outBus, ~ambiBus], ~encCl);

~encoderSynthPno = Synth.new(\foaEncode, [\inBus, ~distPnoBus, \outBus, ~ambiBus], ~encPno);

