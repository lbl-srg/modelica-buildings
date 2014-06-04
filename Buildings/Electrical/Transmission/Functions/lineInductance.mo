within Buildings.Electrical.Transmission.Functions;
function lineInductance
  input Modelica.SIunits.Length Length "Length of the cable";
  input Buildings.Electrical.Types.VoltageLevel level "Voltage level";
  input Buildings.Electrical.Transmission.LowVoltageCables.Cable cable_low
    "Type of cable (if low voltage)";
  input Buildings.Electrical.Transmission.MediumVoltageCables.Cable cable_med
    "Type of cable (if medium voltage)";
  output Modelica.SIunits.Inductance L "Inductance of the cable";
protected
  parameter Modelica.SIunits.Frequency f = 50
    "Frequency considered in the definition of cables properties";
  parameter Modelica.SIunits.AngularVelocity omega = 2*Modelica.Constants.pi*f;
  Modelica.SIunits.Length GMD,GMR;
algorithm

  GMD := cable_med.GMD;
  GMR := cable_med.GMR;

  if level == Buildings.Electrical.Types.VoltageLevel.Low then
    L := (cable_low.XCha/omega)*Length;
  elseif level == Buildings.Electrical.Types.VoltageLevel.Medium then
    L := Length*2e-7*log(GMD/GMR);
  elseif level == Buildings.Electrical.Types.VoltageLevel.High then
    L := Length*2e-7*log(GMD/GMR);
  else
    Modelica.Utilities.Streams.print("Warning: the voltage level does not match one of the three available: Low, Medium or High " +
        String(level) + ". A Low level has been choose as default.");
  end if;

annotation(Inline = true, Documentation(revisions="<html>
<ul>
<li>
June 3, 2014, by Marco Bonvini:<br/>
Added User's guide.
</li>
</ul>
</html>", info="<html>
<p>
This function computes the overall inductance of a cable.
There are two different ways to compute the overall inductance of the cable
 depending on the voltage level.
</p>

<h4>Low voltage level</h4>
<p>
When the voltage level is low the cables have a characteristic reactance per unit 
length (specified @ f = 50 Hz). The overall inductance is computed as
</p>
<p align=\"center\" style=\"font-style:italic;\">
L = (X<sub>CHA</sub>/&omega;) L<sub>CABLE</sub>
</p>
<p>
where <i>X<sub>CHA</sub></i> is the characteristic reactance per unit lenght, 
<i>&omega; = 2 &pi; f</i> is the angular velocity, and <i>L<sub>CABLE</sub></i> is 
the length of the cable.
</p>

<h4>Medium and High voltage level</h4>
<p>
When the voltage level is medium or high the cables have geometric parameters that can 
be used to compute the inductance
</p>
<p align=\"center\" style=\"font-style:italic;\">
R = L<sub>CABLE</sub> 2 10<sup>-7</sup> log(GMD/GMR)
</p>
<p>
where <i>L<sub>CABLE</sub></i> is the length of the cable, while
<i>GMD</i> and <i>GMR</i> are the geometric mean distance and the geometric mean radius
of the cable.
</p>
</html>
"));
end lineInductance;
