(
s = Server.internal;
Server.default = s;
s.quit;
s.options.numOutputBusChannels = 8;
s.options.numInputBusChannels = 8;
s.boot;
)

// Pan2 - equal power stereo pan a mono source
{ Pan2.ar(BrownNoise.ar, MouseX.kr(-1,1), 0.3) }.scope(2);
{ Pan2.ar(BrownNoise.ar, SinOsc.kr(0.2), 0.3) }.scope(2);

// LinPan2 - linear pan a mono source (not equal power)
{ LinPan2.ar(BrownNoise.ar, MouseX.kr(-1,1), 0.3) }.scope(2);
{ LinPan2.ar(BrownNoise.ar, SinOsc.kr(0.2), 0.3) }.scope(2);

// Balance2 - balance a stereo source
{ Balance2.ar(BrownNoise.ar, BrownNoise.ar, MouseX.kr(-1,1), 0.3) }.scope(2);

// Pan4 - equal power quad panner

// PanAz - azimuth panner to any number of channels

{ PanAz.ar(5, BrownNoise.ar, MouseX.kr(-1,1), 0.3, 2) }.scope(5);
// change width to 3
{ PanAz.ar(5, BrownNoise.ar, MouseX.kr(-1,1), 0.3, 3) }.scope(5);

// XFade2 - equal power cross fade between two inputs
{ XFade2.ar(BrownNoise.ar, SinOsc.ar(500), MouseX.kr(-1,1), 0.3) }.scope(1);

// Rotate2 - rotate a sound field of ambisonic or even stereo sound.
(
{
    // rotation of stereo sound via mouse
    var x, y;
    x = Mix.fill(4, { LFSaw.ar(200 + 2.0.rand2, 0, 0.1) }); // left in
    y = WhiteNoise.ar * LFPulse.kr(3,0,0.7,0.2); // right in
    #x, y = Rotate2.ar(x, y, MouseX.kr(0,2));
    [x,y]
}.scope(2);
)