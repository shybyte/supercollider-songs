// Filters for Controls

// Decay - triggered exponential decay

plot({ Decay.ar(Impulse.ar(1), 0.01) });
play({ Decay.ar(Impulse.ar(XLine.kr(1,50,20), 0.25), 0.2, PinkNoise.ar, 0) });
{ WhiteNoise.ar * Decay.ar(Impulse.ar(1), 0.9, 0.2) }.scope(1, zoom:4);
{ WhiteNoise.ar * Decay.ar(Dust.ar(3), 0.9, 0.2) }.scope(1, zoom:4);
{ SinOsc.ar(Decay.ar(Dust.ar(4), 0.5, 1000, 400), 0, 0.2) }.scope(1, zoom:4);

// Decay2- Decay2 rounds off the attack by subtracting one Decay from another

plot({ Decay2.ar(Impulse.ar(1), 0.001, 0.01) })
plot({ Decay2.ar(Impulse.ar(1), 0.01, 0.001) })
// used as an envelope
{ Decay2.ar(Impulse.ar(XLine.kr(1,50,20), 0.25), 0.01, 0.2, FSinOsc.ar(600)) }.play;
// compare the above with Decay used as the envelope
{ Decay.ar(Impulse.ar(XLine.kr(1,50,20), 0.25), 0.2, FSinOsc.ar(600), 0)  }.play;


// Lag

(
// used to lag pitch
{
    SinOsc.ar(                              // sine wave
        Lag.kr(                             // lag the modulator
            LFPulse.kr(4, 0, 0.5, 50, 400), // frequency modulator
            Line.kr(0, 1, 15)               // modulate lag time
        ),
        0,                                  // phase
        0.3                                 // sine amplitude
    )
}.play
)

{ SinOsc.ar(Lag.ar(LFPulse.ar(2,0,0.5,800,400), MouseX.kr(0,0.5)), 0, 0.2) }.scope(1, zoom:4);


// Integrator
{ Integrator.ar(LFPulse.ar(300, 0.2, 0.1), MouseX.kr(0.001, 0.999, 1)) }.play
{ Integrator.ar(LFPulse.ar(3, 0.2, 0.0004), 0.999, FSinOsc.ar(700), 0) }.play
{ Integrator.ar(LFPulse.ar(1500 / 4, 0.2, 0.1), MouseX.kr(0.01, 0.999, 1)) }.scope

// Triggers

{ Trig.ar(Dust.ar(1), 0.2) * FSinOsc.ar(800, 0.5) }.play
{ Trig.ar(Dust.ar(4), 0.1) }.play
(
{
    z = Impulse.ar(2);
    [z * 0.1, ToggleFF.ar(TDelay.ar(z, 0.5)) * SinOsc.ar(mul: 0.1)]
}.scope
)
// Latch - Holds input signal value when triggered.
{ Blip.ar(Latch.ar(WhiteNoise.ar, Impulse.ar(9)) * 400 + 500, 4, 0.2) }.play;

// Gate - Allows input signal value to pass when gate is positive, otherwise holds last value.

{ Blip.ar(Gate.ar(LFNoise2.ar(40), LFPulse.ar(1)) * 400 + 500, 4, 0.2) }.scope(1, zoom:4);

// PulseCount - Each trigger increments a counter which is output as a signal.
(
{
SinOsc.ar(
            PulseCount.ar(Impulse.ar(10), Impulse.ar(0.4)) * 200,
            0, 0.05
        )
}.scope(2, zoom:4);
)

// PulseDivider - Outputs one impulse each time it receives a certain number of triggers at its input.

(
{
    var p, a, b;
    p = Impulse.ar(8);
    a = SinOsc.ar(1200, 0, Decay2.ar(p, 0.005, 0.1));
    b = SinOsc.ar(600,  0, Decay2.ar(PulseDivider.ar(p, MouseX.kr(1,8).round(1)), 0.005, 0.5));

    [a, b] * 0.4
}.scope(2, zoom:4);
)

// EnvGen
{ PinkNoise.ar(EnvGen.kr(Env.perc, doneAction: 2)) }.play
// for sustain envelopes a gate is required
z = { arg gate=1; EnvGen.kr(Env.adsr, gate, doneAction:2) * SinOsc.ar(880,0,0.2) }.play;
z.release;



