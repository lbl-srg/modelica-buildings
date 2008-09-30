model Pressure "Pressure sensor" 
  extends Modelica_Fluid.Sensors.Pressure;
annotation (
    Documentation(info="<HTML>
<p>
This component monitors the pressure at its ports.
The sensor does not influence the fluid. 
The model is identical to 
<a href=\"Modelica:Modelica_Fluid.Sensors.Pressure\">
Modelica_Fluid.Sensors.Pressure</a>
but it adds the mass balance for the extra species properties that
is missing in the original sensor of Modelica_Fluid beta 1.
</p>
</HTML>
"),
revisions="<html>
<ul>
<li>
September 25, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>");
equation 
  ///////////////////////////////////////////////////////////////////////////////////
  // Extra species flow. This may be removed when upgrading to the new Modelica.Fluid. 
  port.mC_flow = zeros(Medium.nC);
  ///////////////////////////////////////////////////////////////////////////////////
  
end Pressure;
