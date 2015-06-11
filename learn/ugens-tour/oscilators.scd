
// Table Oscillators
// Osc, COsc, VOsc, VOsc3

(
b = Buffer.alloc(s, 2048, 1, bufnum: 80);
b.sine1(1.0/(1..6), true, true, true);
{ Osc.ar(80, 100, 0, 0.1) }.scope(1, zoom:4);
)




// Klang is a bank of fixed frequency sine oscillators.
{ Klang.ar(`[ [400, 800, 1600],[0.3, 0.3, 0.3],[pi,pi,pi]], 1, 0) * 0.4}.scope(1);


// Band Limited ImPulse generator.
{Blip.ar(220,numharm: MouseY.kr()*200, mul: 0.2)}.play;
{Blip.ar(200,Line.kr(1,100,20),0.2) }.play;
{Blip.ar(220,numharm: 1,mul: 0.2)}.plot;
{Blip.ar(220,numharm: 50,mul: 0.2)}.plot;
{Blip.ar(220,numharm: 100,mul: 0.2)}.plot;

{var syncFreq = MouseX.kr()*440; SyncSaw.ar(syncFreq,MouseY.kr()*440*2+syncFreq, mul: 0.2)}.play; // moscito

{VarSaw.ar(440,mul: 0.2)}.play;  // width controlls tri/saw sound
{VarSaw.ar(440,width:0.8,mul: 0.2)}.play;


{LFPulse.ar(440,width: SinOsc.ar(1)*0.5+0.5, mul: 0.2)}.play;
{LFPulse.ar(440,mul: 0.2)}.play;
{LFPulse.ar(440,mul: 0.2)}.plot;
{Pulse.ar(440,mul: 0.2)}.plot;
{Pulse.ar(440,mul: 0.2)}.play;

{Impulse.ar(440,mul: 0.2)}.play;
{LFSaw.ar(440,mul: 0.2)}.play;
{Saw.ar(440,mul: 0.2)}.play;
{LFTri.ar(440,mul: 0.2)}.play;

{LFPar.ar(440,mul: 0.2)}.play;
{LFCub.ar(440,mul: 0.2)}.play;
{FSinOsc.ar(440,mul:0.2)}.play; // Faster?
{SinOsc.ar(440,mul:0.2)}.play;
