//Quarks.install('BatLib') //StageLimiter
(
//Recordar: set CPU scale processor: Performance (Linux)
//Server.supernova;
s.options.numInputBusChannels_(3); //3 live inputs
s.options.numOutputBusChannels_(4); //8 live outputs
s.options.memSize_(2.pow(19)); // //increase the memory available to the server
s.options.numBuffers_(1024 * 16); //increase number of buffers the server has access to for loading samples
//s.recHeaderFormat_("wav");
//boot the server
s.waitForBoot{
	//Numero de canal de la paca de audio
	~inFlNum = 0;
	~inClNum = 1;
	~inPnoNum = 2;
	("GroupsBusesSetup.scd").loadRelative;
	("SynthDefs.scd").loadRelative;
	s.sync;
	("OSCdefs.scd").loadRelative;
	("AuxFuncs.scd").loadRelative;
	("SynthSetup.scd").loadRelative;
	("MIDIdefs.scd").loadRelative;

	~flDirAmbi = {Out.ar(~distFlBus, SoundIn.ar(~inFlNum, 0.5))}.play;
	~clDirAmbi = {Out.ar(~distClBus, SoundIn.ar(~inClNum, 0.5))}.play;
	~pnoDirAmbi = {Out.ar(~distPnoBus, SoundIn.ar(~inPnoNum, 0.5))}.play;

	StageLimiter.activate; //activate StageLimiter - Part of the BatLib quark
}; //waitForBoot
)

//////////////////Mix conf
//monitor In
~fluteIn.set(\amp, 1);
~clarinetIn.set(\amp, 1);
~pianoIn.set(\amp, 1);

~grainFlGroup.set(\amp, 1)
~grainClGroup.set(\amp, 1)
~grainPnoGroup.set(\amp, 1)

~fxFlGroup.set(\distort, 0.01, \smooth, 1, \amp, 0.1)
~fxClGroup.set(\distort, 0.01, \smooth, 1, \amp, 0.1)
~fxPnoGroup.set(\distort, 0.01, \smooth, 1, \amp, 0.1)

//////////////////Analysis config
~fluteAnalysis.set(\floor, 0.8, \threshold, 0.07)
~clarinetAnalysis.set(\floor, 0.8, \threshold, 0.07)
~pianoAnalysis.set(\floor, 0.8, \threshold, 0.07)

~clarinetIn.free
~clarinetAnalysis.free
~pianoIn.free
~pianoAnalysis.free

s.plotTree
TreeSnapshotView().front.autoUpdate //Quarks.install("NodeSnapshot")

////////////////// Triggers
~randomDist.(); //PRECAUCIÓN: Chequear volumen, revienta rápido (igual va con StageLimiter). Acopla sin auriculares
~grainDistTrem.(monophonic: true);
~grainDistTrem.(monophonic: false);

~tremVarPedal.();


(
//Terminar
~inGroup.freeAll;
~analysisGroup.freeAll;
~releaseFX.(2);
)

/*
//Monitor Ins
(
~monitor0 = {Out.ar(0,Pan2.ar(SoundIn.ar(~inFlNum, 0.5)))}.play;
~monitor1 = {Out.ar(0,Pan2.ar(SoundIn.ar(~inClNum, 0.5)))}.play;
~monitor2 = {Out.ar(0,Pan2.ar(SoundIn.ar(~inPnoNum, 0.5)))}.play;
)
(
~monitor0.free;
~monitor1.free;
~monitor2.free;
)
~monitor3.set(\amp, 0.001)
~monitor3 = {Out.ar(0,Pan2.ar(SoundIn.ar(4, 1)))}.play;
~monitor3.free
///////////////
*/
//OSC


~freeFx.();
~releaseFX.(0.01);

OSCdef(\flute).disable
OSCdef(\flute).enable

OSCdef(\clarinet).disable
OSCdef(\clarinet).enable

OSCdef(\piano).disable
OSCdef(\piano).enable
