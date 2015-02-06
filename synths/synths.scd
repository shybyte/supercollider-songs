(
SynthDef(\dapMod, { |out=0, amp=1, freq=80|
	var snd,modF,modA,modP, mouseX;

	modF = SinOsc.ar(freq/3,mul:MouseY.kr(0,20));
	modA = SinOsc.ar(freq*4/3,mul:1);
	//modF = 1;
	modA = 1;
	mouseX = MouseX.kr(0,10);
	modP = SinOsc.ar(freq/2,mul: SinOsc.kr(2.2)*mouseX+mouseX);
	snd = [SinOsc.ar((freq-0.5) * modF, modP, mul: modA),SinOsc.ar((freq+0.5) * modF, modP, mul: modA)];
	//snd = Pan2.ar(snd, 0);
	snd = snd * EnvGen.ar(Env.linen(0.01, 1, 0.5), doneAction:2);
	OffsetOut.ar(out, snd*amp);
}).add;
)





(
Pdef(\test,
	Pbind(
		\instrument, \dapMod,
		\dur, 1,
		\midinote, Pseq([45,48,52,48]+12,inf)
)).play;
)



(
SynthDef(\pMod, { |out=0, amp=1, freq=80, cut=1000|
	var snd,modF,modA,modP, mouseX, mouseY;
	mouseX = MouseX.kr(0.5,4);
	mouseY = MouseY.kr(0,1);
	modP = SinOsc.ar(mouseX,mul: mouseY*0.45,add: 0.5);
	snd = [Pulse.ar(freq-0.5, modP, mul: 1),Pulse.ar(freq+0.5, modP, mul: 1)];
	snd = snd+([Pulse.ar(freq/2-0.2, modP, mul: 1),Pulse.ar(freq/2+0.2, modP, mul: 1)]*0.6);
	//snd = Pan2.ar(snd, 0);
	snd = snd * EnvGen.ar(Env.linen(0.01, 0.1, 0.1), doneAction:2);
	snd = RLPF.ar(snd, cut,0.05);
	//snd = FreeVerb.ar(snd,0.5,0.8);
	OffsetOut.ar(out, snd*amp*1);
}).add;
)



(
Pdef(\test,
	Pbind(
		\instrument, \pMod,
		\dur, 0.125,
		\cut, Pseq([Pseq([8,5,3,2]*1000,8)],inf),
		\midinote, Pseq([Pseq([45,48,52,48],4),Pseq([45,49,52,49]+5,4)],inf)
)).play;
)


