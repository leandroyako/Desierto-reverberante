//////////////////Aux functions
(
~freeFx = {
	~grainFlGroup.freeAll;
	~fxFlGroup.freeAll;
	~grainClGroup.freeAll;
	~fxClGroup.freeAll;
	~grainPnoGroup.freeAll;
	~fxPnoGroup.freeAll;
};

~releaseFX = {|time = 10|
	~grainFlGroup.release(time);
	~fxFlGroup.release(time);
	~grainClGroup.release(time);
	~fxClGroup.release(time);
	~grainPnoGroup.release(time);
	~fxPnoGroup.release(time);
};
)