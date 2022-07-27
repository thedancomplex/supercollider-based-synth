// Start server
s.boot;

// Create analyzer in a window
(
w = Window("My Analyzer", Rect(0, 0, 511, 300)); // width should be 511
f = FreqScopeView(w, w.view.bounds);
f.active_(true); // turn it on the first time;

w.onClose_({ f.kill }); // you must have this
w.front;
//{ SinOsc.ar([500, 1000], 0, 0.25).mean.dup }.play(s); // start two sine waves
)

f.freqMode_(1); // change to log scale so we can see them
f.inBus_(1); // look at bus 1
f.dbRange_(200); // expand amplitude range
f.active_(false); // turn scope off (watch CPU)
f.active_(true); // turn it back on

// Now press command-period. The scope is still running.

{ Mix.ar(SinOsc.ar([500, 1200, 3000, 9000, 12000], 0, [0.2, 0.1, 0.05, 0.03, 0.01])) }.play(s); // restart some sines

// Close window and scope is killed.