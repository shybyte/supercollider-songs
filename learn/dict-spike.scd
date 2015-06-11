m = (a: 1,b: 2);
m.b;
m[\b];

(
d = Dictionary[
  \foo -> "bar",
  15 -> true,
  "baz" -> 12.5];
)

d[\foo];

(
d = Dictionary.newFrom(List[\a, 1, \b, 2, \c, 4]);
)

d[\c];

[\a, 1, \b , 2].keysValuesDo({|key,value| key.postln;value.postln});
[\a, 1, \b , 2];