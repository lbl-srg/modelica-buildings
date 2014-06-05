within Buildings.Electrical.Transmission.Functions;
function lineCapacitance "This function computes the capacitance of the cable"
  input Modelica.SIunits.Length Length "Length of the cable";
  input Buildings.Electrical.Types.VoltageLevel level "Voltage level";
  input Buildings.Electrical.Transmission.LowVoltageCables.Cable cable_low
    "Type of cable (if low voltage)";
  input Buildings.Electrical.Transmission.MediumVoltageCables.Cable cable_med
    "Type of cable (if medium voltage)";
  output Modelica.SIunits.Capacitance C "Capacity of the cable";
protected
  parameter Modelica.SIunits.Frequency f = 50
    "Frequency considered in the definition of cables properties";
  parameter Modelica.SIunits.AngularVelocity omega = 2*Modelica.Constants.pi*f;
  Modelica.SIunits.Length GMD,r;
algorithm

  GMD := cable_med.GMD;
  r   := cable_med.d/2.0;

  if level == Buildings.Electrical.Types.VoltageLevel.Low then
    C := 0.0;//(1/omega)*Length;
  elseif level == Buildings.Electrical.Types.VoltageLevel.Medium then
    C := Length*2*Modelica.Constants.pi*Modelica.Constants.epsilon_0/log(GMD/r);
  elseif level == Buildings.Electrical.Types.VoltageLevel.High then
    C := Length*2*Modelica.Constants.pi*Modelica.Constants.epsilon_0/log(GMD/r);
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
This function computes the overall capacity of a cable.
There are two different ways to compute the overall inductance of the cable
 depending on the voltage level.
</p>

<h4>Low voltage level</h4>
<p>
When the voltage level is low the cables do not consider the capacitive effect thus
</p>
<p align=\"center\" style=\"font-style:italic;\">
C = 0
</p>

<h4>Medium and High voltage level</h4>
<p>
When the voltage level is medium or high the cables have geometric parameters that can 
be used to compute the capacity
</p>
<p align=\"center\" style=\"font-style:italic;\">
C = L<sub>CABLE</sub> 2 &pi; &epsilon;<sub>0</sub>/log(GMD/r)
</p>
<p>
where <i>L<sub>CABLE</sub></i> is the length of the cable,
<i>&epsilon;<sub>0</sub></i> is the dielectric constant of the air, <i>GMD</i> 
is the geometric mean distance, and <i>r = d/2</i> where <i>d</i> is the inner
diameter of the cable.
</p>
</html>"));
end lineCapacitance;
