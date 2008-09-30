model RelativePressure "Ideal relative pressure sensor" 
  extends Modelica_Fluid.Sensors.RelativePressure;
annotation (
    Documentation(info="<HTML>
<p>
This component monitors the pressure difference between its ports.
The sensor does not influence the fluid. 
The model is identical to 
<a href=\"Modelica:Modelica_Fluid.Sensors.RelativePressure\">
Modelica_Fluid.Sensors.RelativePressure</a>
but it adds the mass balance for the extra species properties that
is missing in the original sensor of Modelica_Fluid beta 1.
</p>
</HTML>
"),
revisions="<html>
<ul>
<li>
September 23, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>");
equation 
  ///////////////////////////////////////////////////////////////////////////////////
  // Extra species flow. This may be removed when upgrading to the new Modelica.Fluid. 
  port_a.mC_flow = zeros(Medium.nC);
  port_b.mC_flow = zeros(Medium.nC);
  ///////////////////////////////////////////////////////////////////////////////////
end RelativePressure;
