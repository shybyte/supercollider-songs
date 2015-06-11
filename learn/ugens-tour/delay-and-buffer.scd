// DelayN, DelayL, DelayC - simple delays
//  N - no interpolation
//  L - linear interpolation
//  C - cubic interpolation

(
// Dust randomly triggers Decay to create an exponential
// decay envelope for the WhiteNoise input source
{
z = Decay.ar(Dust.ar(1,0.5), 0.3, WhiteNoise.ar);
DelayN.ar(z, 0.1, 0.1, 1, z); // input is mixed with delay via the add input
}.scope(1, zoom: 4)
)

(
{
z = Decay.ar(Impulse.ar(2,0,0.4), 0.3, WhiteNoise.ar);
DelayL.ar(z, 0.3, MouseX.kr(0,0.3), 1, z); // input is mixed with delay via the add input
}.scope(1, zoom: 4)
)


// CombN, CombL, CombC - feedback delays

// used as an echo.
{ CombN.ar(Decay.ar(Dust.ar(1,0.5), 0.2, WhiteNoise.ar), 0.2, 0.2, 3) }.scope(1, zoom:4);


// AllpassN, AllpassL, AllpassC - allpass delay
(
{
    var z;
    z = Decay.ar(Dust.ar(1,0.5), 0.1, WhiteNoise.ar);
    8.do { z = AllpassL.ar(z, 0.04, 0.04.rand, 2) };
    z
}.scope(1);
)

// PlayBuf - buffer playback

// read sound
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

{ SinOsc.ar(800 + (700 * PlayBuf.ar(1,b, BufRateScale.kr(b),  loop:1)),0,0.3) }.scope(1);
// trigger one shot on each pulse
(
{
    var trig;
    trig = Impulse.kr(2.0);
    PlayBuf.ar(1,b,BufRateScale.kr(b),trig,0,0);
}.scope(1);
)

// mouse control of trigger rate and startpos
(
{
    var trig;
    trig = Impulse.kr(MouseY.kr(0.5,200,1));
    PlayBuf.ar(1,b,BufRateScale.kr(b),trig,MouseX.kr(0,BufFrames.kr(b)),1)
}.scope(1);
)