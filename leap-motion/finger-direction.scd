
(
OSCdef.new(\oscHandlerRightFingers,
 	{ |msg|
 		var handPos, y, mod;
 		handPos = msg[1..];
 		y = handPos[1];
		handPos.postln;
		//mod = y.linlin(-1,-0.25,10,0);
		//[y, mod].postln;
		//~theremin.set(\mod, mod);
	}
	, '/leap-motion/hands/right/fingers/direction'
);
)


a = [[1,2],[3,4]]
a[1]