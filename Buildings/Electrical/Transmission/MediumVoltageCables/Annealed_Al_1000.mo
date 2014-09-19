within Buildings.Electrical.Transmission.MediumVoltageCables;
record Annealed_Al_1000 "Annealed Al cable - AWG 1000"
  extends Buildings.Electrical.Transmission.MediumVoltageCables.Generic(
    material=Types.Material.Al,
    size="1000",
    Rdc=5.80709e-5,
    Tref=298.15,
    d=28.372e-3,
    D=46.101e-3,
    GMR=Buildings.Electrical.Transmission.Functions.computeGMR(d),
    GMD=Buildings.Electrical.Transmission.Functions.computeGMD(0.1905),
    Amp=640);
  annotation (Documentation(info="<html>
<p>
Annealed aluminium cable with a cross-sectional kcmil 1000
(thousand of Circular Mils).
This type of cable has the following properties
</p>
<pre>
Rdc  = 5.80709e-5  // Characteristic DC resistance at T = Tref[Ohm/m]
Tref = 298.15      // Reference temperature of the material [K]
d    = 28.372e-3   // Inner diameter [m]
D    = 46.101e-3   // Outer diameter [m]
Amp  = 640         // Ampacity [A]
</pre>
</html>", revisions="<html>
<ul>
<li>
Sept 19, 2014, by Marco Bonvini:<br/>
Added User's guide.
</li>
</ul>
</html>"));
end Annealed_Al_1000;
