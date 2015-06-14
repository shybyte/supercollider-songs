{ LFTri.ar(40, iphase: 0) }.plot(0.1);
{ LFSaw.ar(40, iphase: 0) }.plot(0.1);
{ Saw.ar(40, iphase: 0) }.plot(0.1);
{ VarSaw.ar(40, width:1, iphase: 0) }.plot(0.1);
{ SyncSaw.ar(syncFreq: 40,sawFreq: 80) }.plot(0.1);

(
plot { [
    SyncSaw.ar(800, 900),
    Impulse.ar(800) // to show sync rate
] }
)


~MKSaw = SyncSaw;


{ LFTri.ar(400, iphase: 0) }.play();