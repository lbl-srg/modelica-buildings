within Buildings.Electrical.Transmission.LowVoltageCables;
record Cu20 "Cu cable 20 mm^2"
  extends Buildings.Electrical.Transmission.LowVoltageCables.Generic(
    material=Types.Material.Cu,
    Amp=95,
    RCha=0.905e-003,
    XCha=0.075e-003);
  annotation (Documentation(info="<html>
<p>
Copper cable with a cross-sectional area of 20mm^2.
This type of cable has the following properties
</p>
<pre>
RCha = 0.905e-003 // Characteristic resistance [Ohm/m] 
XCha = 0.075e-003 // Characteristic reactance [Ohm/m] 
</pre>
</html>", revisions="<html>
<ul>
<li>
Sept 19, 2014, by Marco Bonvini:<br/>
Added User's guide.
</li>
</ul>
</html>"));
end Cu20;
