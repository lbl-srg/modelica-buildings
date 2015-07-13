within Buildings.Electrical.Transmission.MediumVoltageCables;
record Annealed_Al_1500 "Annealed Al cable - AWG 1500"
  extends Buildings.Electrical.Transmission.MediumVoltageCables.Generic(
    material=Types.Material.Al,
    M = 228.1 + 273.15,
    size="1500",
    Rdc=3.87139e-5,
    T_ref=298.15,
    d=34.798e-3,
    D=53.34e-3,
    GMR=Buildings.Electrical.Transmission.Functions.computeGMR(d),
    GMD=Buildings.Electrical.Transmission.Functions.computeGMD(0.1905),
    Amp=800);
  annotation (Documentation(info="<html>
<p>
Annealed aluminium cable with a cross-sectional kcmil 1500
(thousand of Circular Mils).
This type of cable has the following properties
</p>
<pre>
Rdc  = 3.87139e-5 // Characteristic DC resistance at T = T_ref[Ohm/m]
T_ref= 298.15      // Reference temperature of the material [K]
d    = 34.798e-3   // Inner diameter [m]
D    = 53.34e-3   // Outer diameter [m]
Amp  = 800         // Ampacity [A]
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
end Annealed_Al_1500;
