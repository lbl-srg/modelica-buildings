within Buildings.HeatTransfer.Windows.BaseClasses;
partial record RadiationBaseData
  "Basic parameters for window radiation calculation"

  parameter Integer N(min=1) "Number of glass layers"
    annotation (Dialog(group="Glass"));
  parameter Modelica.SIunits.Length xGla[N] "Thickness of glass"
  annotation (Dialog(group="Glass"));
  parameter Modelica.SIunits.TransmissionCoefficient tauGlaSol[N]
    "Solar transmissivity of glass" annotation (Dialog(group="Glass"));
  parameter Modelica.SIunits.ReflectionCoefficient rhoGlaSol_a[N]
    "Solar reflectivity of glass at surface a (facing outside)"
    annotation (Dialog(group="Glass"));
  parameter Modelica.SIunits.ReflectionCoefficient rhoGlaSol_b[N]
    "Solar reflectivity of glass at surface b (facing room-side)"
    annotation (Dialog(group="Glass"));

  parameter Modelica.SIunits.TransmissionCoefficient tauShaSol_a
    "Solar transmissivity of shade for irradiation from air-side"
    annotation (Dialog(group="Shade"));
  parameter Modelica.SIunits.TransmissionCoefficient tauShaSol_b
    "Solar transmissivity of shade for irradiation from glass-side"
    annotation (Dialog(group="Shade"));
  parameter Modelica.SIunits.ReflectionCoefficient rhoShaSol_a
    "Solar reflectivity of shade for irradiation from air-side"
    annotation (Dialog(group="Shade"));
  parameter Modelica.SIunits.ReflectionCoefficient rhoShaSol_b
    "Solar reflectivity of shade for irradiation from glass-side"
    annotation (Dialog(group="Shade"));

  annotation (Documentation(info="<html>
Record that defines basic parameters for the window radiation calculation.
</html>", revisions="<html>
<ul>
<li>
December 12, 2011, by Wangda Zuo:<br/>
Add glass thickness as a parameter. It is needed by the calculation of property
for uncoated glass.
</li>
<li>
December 16, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end RadiationBaseData;
