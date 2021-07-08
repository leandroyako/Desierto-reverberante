//Groups
~inGroup = Group.new(addAction: \addToHead);
~analysisGroup = Group.after(~inGroup);
~grainPnoGroup = Group.after(~analysisGroup);
~grainFlGroup = Group.after(~analysisGroup);
~grainClGroup = Group.after(~analysisGroup);
~fxPnoGroup = Group.after(~grainPnoGroup);
~fxFlGroup = Group.after(~grainFlGroup);
~fxClGroup = Group.after(~grainClGroup);

~encoderGroup = Group.new(s, \addToTail);
~encFl = Group.new(~encoderGroup);
~encCl = Group.new(~encoderGroup);
~encPno = Group.new(~encoderGroup);
~decoderGroup = Group.after(~encoderGroup);

//Buses
~inFlBus = Bus.audio(s,1);
~inClBus = Bus.audio(s,1);
~inPnoBus = Bus.audio(s,2);

~grainFlBus = Bus.audio(s,1);
~grainClBus = Bus.audio(s,1);
~grainPnoBus = Bus.audio(s,1);

~distFlBus = Bus.audio(s,1);
~distClBus = Bus.audio(s,1);
~distPnoBus = Bus.audio(s,1);

~ambiBus = Bus.audio(s, 4); // allocate four channels for routing

~flSpat = Bus.control(s, 2);
~clSpat = Bus.control(s, 2);
~pnoSpat = Bus.control(s, 2);