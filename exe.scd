s.boot;

//array de los sammmples que voy a usar sancadolos de la carpeta que pongo!

(
b = Dictionary.new;
(PathName("User/Docs/project/samples")).entries.do{ // entre las comillas va donde esten las carpetas de samples, user/documents/project-folder/samples/ yo tenia dos carpetas diferentes
		arg subfolder;
		b.add(
			subfolder.folderName.asSymbol ->
			Array.fill(
				subfolder.entries.size,
				{
					arg i;
					Buffer.read(s, subfolder.entries[i].fullPath);
				}
			)
		);
	};
)

b[\feel].choose.play;

//synthdef que funciona como buss para hacer cambios de pitch y reverb en tiempo real, pero que me dio vagancia hacer bien -siempre poner antes en el nodetree que la synthdef playbuff! won't work otherwise
(
SynthDef.new(\pedalera, {|out=0, in = 6, ratio = 1.0, dispP = 0.0, dispT = 0.0, mul= 1, amp=0.5, mix = (-0.5), mixF= 0.33, room = 0.5, damp = 0.5, pan = 0|
	var sig, pitchshift;
	sig = In.ar(in, 2);
	pitchshift = PitchShift.ar(sig, 0.2, ratio, dispP, dispT, mul);
	sig = XFade2.ar(sig, pitchshift, mix);
	sig = FreeVerb.ar(Pan2.ar(sig, pan, amp), mixF, room, damp);
	Out.ar(out, sig);
}).add;
)

p = Synth.new(\pedalera)

//synthdef que plays el sample, y usamos en la oscdef texto para tocar los samples randomizados

(
SynthDef.new(\playbuf, {|amp=0.3, out=6, buf, da=2, rate =1, pan=0.7|
	var sig;
	sig = PlayBuf.ar(1, buf, BufRateScale.kr(buf) * rate, doneAction:da);
	Out.ar(out, sig);
}).add;
)


//probando la synthdef anterior, una de las folders de samples se llama cy
Synth.new(\playbuf, [\buf, b[\cy][5]])


/// synthdef como la anterior pero con reverbbb, la usaba sin /pedalera b4

(
SynthDef.new(\playbuf, {|amp=0.3, out=6, buf, da=2, rate =1, pan=0.7|
	var sig;
	sig = PlayBuf.ar(1, buf, BufRateScale.kr(buf) * rate, doneAction:da);
	sig = FreeVerb.ar(Pan2.ar(sig, pan, amp));
	Out.ar(out, sig);
}).add;
)

//esta es la synthdef que mantiene comunicacion con OSC con el poema en python y elije dependiendo de un mensaje que carpeta de samples usar
//also, dice cy y feel por que era el nombre de las carpetas de samples, ajustar a convenienciaaaaa
(
OSCdef.new(\texto,{
	|msg, time, addr, port|
	msg[1].postln;
	switch(msg[1],
		1, {Synth.new(\playbuf, [\buf, b[\cy][0..4].choose, \pan,0]) },
		2, {Synth.new(\playbuf, [\buf, b[\feel][0..5].choose, \pan, 0])},
		3, {Synth.new(\playbuf, [\buf, b[\cy][0..5].choose])}
	);

},
'/supercollider',
)
)


// MIC de yapa

(
SynthDef.new(\mic, {|in=0, out=0, deltime=0.3,
mix=(-0.5), decay = 3, amp=0.3, pan=0.7|
var sig, delay;
sig=SoundIn.ar(in!2);
delay = CombL.ar(sig, 0.3, deltime, decay);
sig = XFade2.ar(sig, delay, mix);
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
)

x=Synth(\mic);

x.set(\mix, (-0.8), \deltime, 0.3, \decay, 15, \amp, 0.08)

x.free
