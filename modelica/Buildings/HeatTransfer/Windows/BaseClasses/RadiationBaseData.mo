within Buildings.HeatTransfer.Windows.BaseClasses;
partial record RadiationBaseData
  "Define base parameters for window radiation calculation"

  parameter Integer N(min=1) "Number of glass layers"
    annotation (Dialog(group="Glass"));

  parameter Modelica.SIunits.TransmissionCoefficient tauGlaSW[N]
    "Short wave transmissivity of glass" annotation (Dialog(group="Glass"));
  parameter Modelica.SIunits.ReflectionCoefficient rhoGlaSW_a[N]
    "Short wave reflectivity of glass at surface a (facing outside)"
    annotation (Dialog(group="Glass"));
  parameter Modelica.SIunits.ReflectionCoefficient rhoGlaSW_b[N]
    "Short wave reflectivity of glass at surface b (facing room-side)"
    annotation (Dialog(group="Glass"));

  parameter Modelica.SIunits.TransmissionCoefficient tauShaSW_a
    "Short wave transmissivity of shade for irradiation from air-side"
    annotation (Dialog(group="Shade"));
  parameter Modelica.SIunits.TransmissionCoefficient tauShaSW_b
    "Short wave transmissivity of shade for irradiation from glass-side"
    annotation (Dialog(group="Shade"));
  parameter Modelica.SIunits.ReflectionCoefficient rhoShaSW_a
    "Short wave reflectivity of shade for irradiation from air-side"
    annotation (Dialog(group="Shade"));
  parameter Modelica.SIunits.ReflectionCoefficient rhoShaSW_b
    "Short wave reflectivity of shade for irradiation from glass-side"
    annotation (Dialog(group="Shade"));

  annotation (Documentation(info="<html>
Record that defines base parameter for window radiation calculation.
</html>", revisions="<html>
<ul>
<li>
December 16, 2010, by Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"));
end RadiationBaseData;
