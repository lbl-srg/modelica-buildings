within Buildings.Electrical.Transmission.MediumVoltageCables;
record Annealed_Al_350 "Annealed Al cable - kcmil 350"
  extends Buildings.Electrical.Transmission.MediumVoltageCables.Generic(
    material=Types.Material.Al,
    M = 228.1 + 273.15,
    size="350",
    Rdc=0.165682e-3,
    T_ref=298.15,
    d=16.789e-3,
    D=34.417e-3,
    GMR=Buildings.Electrical.Transmission.Functions.computeGMR(d),
    GMD=Buildings.Electrical.Transmission.Functions.computeGMD(0.1905),
    Amp=375);
  annotation (Documentation(info="<html>
<p>
Annealed aluminium cable with a cross-sectional kcmil 350
(thousand of Circular Mils).
This type of cable has the following properties
</p>
<pre>
Rdc  = 0.165682e-3 // Characteristic DC resistance at T = T_ref[Ohm/m]
T_ref= 298.15      // Reference temperature of the material [K]
d    = 16.789e-3   // Inner diameter [m]
D    = 34.417e-3   // Outer diameter [m]
Amp  = 375         // Ampacity [A]
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
end Annealed_Al_350;
