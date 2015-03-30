within Buildings.Electrical.Transmission.MediumVoltageCables;
record Annealed_Al_30 "Annealed Al cable - AWG 3/0"
  extends Buildings.Electrical.Transmission.MediumVoltageCables.Generic(
    material=Types.Material.Al,
    M = 228.1 + 273.15,
    size="3/0",
    Rdc=0.344488e-3,
    T_ref=298.15,
    d=11.582e-3,
    D=28.956e-3,
    GMR=Buildings.Electrical.Transmission.Functions.computeGMR(d),
    GMD=Buildings.Electrical.Transmission.Functions.computeGMD(0.1905),
    Amp=250);
  annotation (Documentation(info="<html>
<p>
Annealed aluminium cable with a cross-sectional AWG 2/0
(American Wire Gauge).
This type of cable has the following properties
</p>
<pre>
Rdc  = 0.344488e-3 // Characteristic DC resistance at T = T_ref[Ohm/m]
T_ref= 298.15      // Reference temperature of the material [K]
d    = 11.582e-3   // Inner diameter [m]
D    = 28.956e-3   // Outer diameter [m]
Amp  = 250         // Ampacity [A]
</pre>
</html>", revisions="<html>
<ul>
<li>
September 24, 2014, by Marco Bonvini:<br/>
Revised structure of the record, now the temperature constant <code>M</code>
is directly specified in the record.
</li>
<li>
Sept 19, 2014, by Marco Bonvini:<br/>
Added User's guide.
</li>
</ul>
</html>"));
end Annealed_Al_30;
