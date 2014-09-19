within Buildings.Electrical.Transmission.LowVoltageCables;
record PvcAl25 "Aluminum cable 25 mm^2"
  extends Buildings.Electrical.Transmission.LowVoltageCables.Generic(
    material=Types.Material.Al,
    RCha=1.292e-003,
    XCha=0.075e-003);
  annotation (Documentation(info="<html>
<p>
Aluminium cable with a cross-sectional area of 25mm^2, ECM type.
This type of cable has the following properties
</p>
<pre>
RCha = 1.292e-003 // Characteristic resistance [Ohm/m] 
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
end PvcAl25;
