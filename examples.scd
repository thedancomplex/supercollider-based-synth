// Drumm
(
{
  var snare, bdrum, hihat;
  var tempo = 4;

  tempo = Impulse.ar(tempo); // for a drunk drummer replace Impulse with Dust !!!
  snare = WhiteNoise.ar(Decay2.ar(PulseDivider.ar(tempo, 4, 2), 0.005, 0.5));
  bdrum = SinOsc.ar(Line.ar(120,60, 1), 0, Decay2.ar(PulseDivider.ar(tempo, 4, 0), 0.005, 0.5));
  hihat = HPF.ar(WhiteNoise.ar(1), 10000) * Decay2.ar(tempo, 0.005, 0.5);

  Out.ar(0, (snare + bdrum + hihat) * 0.4 ! 2)
}.play
)




//Gabber Rave


// 60Hz Gabber Rave 1995
(
SynthDef(\gabberkick, {
    var snd, freq, high, lfo;
    freq = \freq.kr(440) * (Env.perc(0.001, 0.08, curve: -1).ar * 48 * \bend.kr(1)).midiratio;
    snd = Saw.ar(freq);
    snd = (snd * 100).tanh + ((snd.sign - snd) * -8.dbamp);
    high = HPF.ar(snd, 300);
    lfo = SinOsc.ar(8, [0, 0.5pi]).range(0, 0.01);
    high = high.dup(2) + (DelayC.ar(high, 0.01, lfo) * -2.dbamp);
    snd = LPF.ar(snd, 100).dup(2) + high;
    snd = RLPF.ar(snd, 7000, 2);
    snd = BPeakEQ.ar(snd, \ffreq.kr(3000) * XLine.kr(1, 0.8, 0.3), 0.5, 15);
    snd = snd * Env.asr(0.001, 1, 0.05).ar(2, \gate.kr(1));
    Out.ar(\out.kr(0), snd * \amp.kr(0.1));
}).add;

SynthDef(\hoover, {
    var snd, freq, bw, delay, decay;
    freq = \freq.kr(440);
    freq = freq * Env([-5, 6, 0], [0.1, 1.7], [\lin, -4]).kr.midiratio;
    bw = 1.035;
    snd = { DelayN.ar(Saw.ar(freq * ExpRand(bw, 1 / bw)) + Saw.ar(freq * 0.5 * ExpRand(bw, 1 / bw)), 0.01, Rand(0, 0.01)) }.dup(20);
    snd = (Splay.ar(snd) * 3).atan;
    snd = snd * Env.asr(0.01, 1.0, 1.0).kr(0, \gate.kr(1));
    snd = FreeVerb2.ar(snd[0], snd[1], 0.3, 0.9);
    snd = snd * Env.asr(0, 1.0, 4, 6).kr(2, \gate.kr(1));
    Out.ar(\out.kr(0), snd * \amp.kr(0.1));
}).add;
)

(
var durations;
durations = [1, 1, 1, 1, 3/4, 1/4, 1/2, 3/4, 1/4, 1/2];
Ppar([
    Pbind(*[
        instrument: \gabberkick,
        amp: -23.dbamp,
        freq: 60,
        legato: 0.8,
        ffreq: Pseq((0..(durations.size * 4 - 1)).normalize, inf).linexp(0, 1, 100, 4000),
        dur: Pseq(durations, inf),
        bend: Pfuncn({ |x| if(x < (1/2), 0.4, 1) }, inf) <> Pkey(\dur),
    ]),
    Pbind(*[
        instrument: \hoover,
        amp: -20.dbamp,
        midinote: 74,
        dur: durations.sum * 2,
        sustain: 7,
    ])
]).play(TempoClock(210 / 60));
)


// simple fm

(
{ SinOsc.ar(SinOsc.kr([1, 3]).exprange(100, 2e3), 0, 0.2) }.play
)



// babbling brook
(
{
({RHPF.ar(OnePole.ar(BrownNoise.ar, 0.99), LPF.ar(BrownNoise.ar, 14)
* 400 + 500, 0.03, 0.003)}!2)
+ ({RHPF.ar(OnePole.ar(BrownNoise.ar, 0.99), LPF.ar(BrownNoise.ar, 20)
* 800 + 1000, 0.03, 0.005)}!2)
* 4
}.play
)


// other example
(
play{SinOsc.ar(OnePole.ar(Mix(
LFSaw.ar([1,0.99],[0,0.6],2000,2000).trunc([400,600])*[1,-1]
),0.98)).dup*0.1}
)

// atari 2600
// Simple synth definition using the Atari2600 UGen:
(
SynthDef(\atari2600, {|out= 0, gate= 1, tone0= 5,
tone1= 8, freq0= 10, freq1= 20, amp= 1, pan= 0|
var e, z;
e= EnvGen.kr(Env.asr(0.01, amp, 0.05), gate, doneAction:2);
z= Atari2600.ar(tone0, tone1, freq0, freq1, 15, 15);
Out.ar(out, Pan2.ar(z*e, pan));
}).store
)

     // And a pattern to play it:
(
Pbind(
\instrument, \atari2600,
\dur, Pseq([0.25, 0.25, 0.25, 0.45], inf),
\amp, 0.8,
\tone0, Pseq([Pseq([2, 5], 32), Pseq([3, 5], 32)], inf),
\tone1, 14,
\freq0, Pseq([Pbrown(28, 31, 1, 32),
Pbrown(23, 26, 3, 32)], inf),
\freq1, Pseq([Pn(10, 16), Pn(11, 16)], inf)
).play
)





    // hamburg soft frog loops, by Julian Rohrhuber July 2005
    // Published under the Creative Commons licence
    // creativecommons.org/licenses/by/2.0/
    (
    [\kr, \ar].do { |x|
    SynthDef(”softfrog_”++x, {
    arg out, freq=440, prate=180, pwidth=0.5,
    sustain=0.3, amp=0.1;
    var env, u;
    env = Env.linen(Rand(0.001, 0.003), Rand(0.1, 0.3), 0.01);
    freq = freq + LFNoise2.kr(5, 10);
    u = SinOsc.ar(
    freq,
    LFPulse.perform(x,
    prate,
    0,
    Line.kr(pwidth, 0, sustain)
    ),
    amp
    );
    u = BRF.ar(u, freq, 0.1) * EnvGen.kr(env, doneAction:2);
    Out.ar(out, Pan2.ar(u, Rand(-1,1)))
    }).store;

    };
    )

    (
    var arr, arr2, arr3, arr4, arfill, prob, node1, node2;
    var dt = 1/8;
    var n = 16;
    arfill = { arr = Array.fill(n div: 2, { 180 + 180.5.rand2 }) };
    arr2 = Array.fill(n, { rrand(1, pi) });
    arr3 = Array.fill(n, { 1300 + 100.rand2 });
    arr4 = Array.fill(n, {
    if(0.6.coin, { 0.5.rand } , { 0.1.rand })  });
    prob = [4,1].normalizeSum;

    node1 = NodeProxy.audio(s, 2);
    node2 = NodeProxy.audio(s, 2);
    node2.source = { RLPF.ar(node1.ar, LFNoise2.kr(3).range(300,
    MouseY.kr(300, 10000, 1)), 0.5) };
    node2.play;

    fork {
    inf.do {|i|
    if(i % 64 == 0) { arfill.value };
    Synth(["softfrog_kr", "softfrog_ar"].wchoose(prob),
    [
    \out, node1.index,
    \freq, arr3 @@ i,
    \prate, arr @@ i,
    \pwidth, arr2 @@ i,
    \amp, arr4 @@ i
    ]
    );
    dt.wait;
    }
    };

     CmdPeriod.doOnce { node2.clear; node1.clear };
    )

     