//SynthDefs
SynthDef.new(\monoAudioIn, {

	|inBus = 0, amp = 1, outBus|

	var sig = SoundIn.ar(bus: inBus, mul: amp);
	sig = Mix.ar(sig);

	OffsetOut.ar(outBus, sig);
}).add;

SynthDef.new(\onsets, {

	|inBus, outBus, threshold = 0.1, odtype = \rcomplex, reltime = 0.5, floor = 0.01, mingap = 10, id = 0|

	var sigIn, fft, onset;
	sigIn = In.ar(inBus);
	fft = FFT(LocalBuf(512), sigIn, wintype: 1);
	onset = Onsets.kr(fft, threshold, odtype, reltime, floor, mingap);
	SendReply.kr(onset, '/onsets', 1, id);
}).add;

SynthDef(\grainFreeze, {

	|inBus = 0, outBus = 0, amp = 0.4,
	trigRate = 60, grainDur = 0.5, grainPos = 0, rate = 1,
	delayTime = 0.2, attackTime = 0.5, decayTime = 0, sustainLevel = 1, releaseTime = 2, gate = 1, doneAction = 2|

	var input, record, localBuf;
	var grainTrig, env, sig, distortTime;

	// Record (into a 0.5 second, mono buffer)
	input = In.ar(inBus, 1);
	localBuf = LocalBuf.new(SampleRate.ir * 0.5, 1).clear;
	record = RecordBuf.ar(input, localBuf, loop: 0);

	//// Granulate:
	grainTrig = Dust.ar(trigRate);
	sig = GrainBuf.ar(1, grainTrig, grainDur, localBuf, rate, grainPos);
	env = EnvGen.kr(Env.dadsr(delayTime, attackTime, decayTime, sustainLevel, releaseTime), gate, doneAction: doneAction);
	sig = sig * env;
	sig = Out.ar(outBus, sig * amp);
}).add;

SynthDef(\crossoverDistortion, {

	|outBus = 0, inBus = 0, ampIn = 1, amp = 0.7, pos = 0,
	distort = 0.03, smooth = 0.7, mix = 0.9, mixTime = 4
	attackTime = 4, decayTime = 0, sustainLevel = 1, releaseTime = 4, gate = 1,
	tremoloFreq = 1, tremoloMix = 0.5, tremoloAtk = 1, cutoff = 0, doneAction = 2|

	var inSig, sig, env, mixEnv, tremolo, pitchFreq, hasFreq;

	inSig = In.ar(inBus, inBus.numChannels) * ampIn;
	//sig = CrossoverDistortion.ar(inSig, distort, smooth);
//	# pitchFreq, hasFreq = Pitch.kr(inSig, ampThreshold: 0.1, median: 7, execFreq: 2);
	sig = DFM1.ar(inSig, 900, 0.25, 2);
	//sig = inSig;

//	mixEnv = Line.kr(0, mix, mixTime);
//	sig = (1 - mixEnv) * inSig + (sig * mixEnv);
	env = EnvGen.kr(Env.adsr(attackTime, decayTime, sustainLevel, releaseTime), gate, doneAction: doneAction);
	//if (cutoff!= 0, { sig = LPF.ar(sig, cutoff * XLine.kr(1/100,1,attackTime))});
	tremolo = SinOsc.kr(EnvGen.kr(Env.adsr(tremoloAtk, decayTime, tremoloFreq, releaseTime), gate, doneAction: doneAction), 0, 1) * sig;
	sig = ((1 - tremoloMix) * sig) + (tremoloMix * tremolo);
	sig = sig * env;
	Out.ar(outBus, sig * amp);
}).add;


//Ambisonics

SynthDef.new(\foaEncode, {arg inBus, outBus, angleFreq = 1, azimFreq = 1;
	var src, foa, encoder, angle, azim;

	// angle ---> top         = push to plane wave
    //          bottom    = omni-directional

	//angle = SinOsc.kr(angleFreq, 0, pi/4, pi/2);
	angle = LFNoise2.kr(Lag.kr(angleFreq, 0.2), pi/4, pi/2);
	angle = Lag.kr(angle, 0.5);
    // azimuth -> hard left     = back
    //          centre     = centre
    //          hard right     = back
    //azim = SinOsc.kr(azimFreq, 0, pi);
	azim = LFNoise2.kr(azimFreq, pi);
	azim = Lag.kr(azim, 0.2);

	encoder = FoaEncoderMatrix.newOmni;
	src = In.ar(inBus, 1);
	// Encode into our foa signal
	foa = FoaEncode.ar(src, encoder);
	foa = FoaTransform.ar(foa, 'push', angle, azim);
	// send out
	Out.ar(outBus, foa);
}).add;

//~decoder = FoaDecoderKernel.newUHJ; // UHJ, a kernel decoder

s.sync;

SynthDef.new(\foaDecode, {arg inBus;
	var foa, out, decoder;
	//decoder = FoaDecoderMatrix.newStereo;
	//decoder = FoaDecoderMatrix.newQuad;
	decoder = FoaDecoderMatrix.newPanto(4, 'flat', 'controlled');

	foa = In.ar(inBus, 4);
	out = FoaDecode.ar(foa, decoder);

	// send out
	Out.ar(0, out);
}).add;