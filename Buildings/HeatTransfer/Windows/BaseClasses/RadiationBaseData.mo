within Buildings.HeatTransfer.Windows.BaseClasses;
partial record RadiationBaseData
  "Basic parameters for window radiation calculation"
  extends Modelica.Icons.Record;


  parameter Integer N(min=1) "Number of glass layers"
    annotation (Dialog(group="Glass"));

  final parameter Integer NSta(min=1, start=1) = size(tauGlaSol, 2)
    "Number of window states for electrochromic windows (set to 1 for regular windows)"
    annotation (Evaluate=true);

  parameter Modelica.Units.SI.Length xGla[N] "Thickness of glass"
    annotation (Dialog(group="Glass"));
  parameter Modelica.Units.SI.TransmissionCoefficient tauGlaSol[N,:]
    "Solar transmissivity of glass" annotation (Dialog(group="Glass"));
  parameter Modelica.Units.SI.ReflectionCoefficient rhoGlaSol_a[N,NSta]
    "Solar reflectivity of glass at surface a (facing outside)"
    annotation (Dialog(group="Glass"));
  parameter Modelica.Units.SI.ReflectionCoefficient rhoGlaSol_b[N,NSta]
    "Solar reflectivity of glass at surface b (facing room-side)"
    annotation (Dialog(group="Glass"));

  parameter Modelica.Units.SI.TransmissionCoefficient tauShaSol_a
    "Solar transmissivity of shade for irradiation from air-side"
    annotation (Dialog(group="Shade"));
  parameter Modelica.Units.SI.TransmissionCoefficient tauShaSol_b
    "Solar transmissivity of shade for irradiation from glass-side"
    annotation (Dialog(group="Shade"));
  parameter Modelica.Units.SI.ReflectionCoefficient rhoShaSol_a
    "Solar reflectivity of shade for irradiation from air-side"
    annotation (Dialog(group="Shade"));
  parameter Modelica.Units.SI.ReflectionCoefficient rhoShaSol_b
    "Solar reflectivity of shade for irradiation from glass-side"
    annotation (Dialog(group="Shade"));

  annotation (Documentation(info="<html>
<p>
Record that defines basic parameters for the window radiation calculation.
The parameter <code>NSta</code> is the number of states. Regular glass
has <code>NSta=1</code>, whereas electrochromic windows have <code>NSta &gt; 1</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 7, 2015, by Michael Wetter:<br/>
Revised model to allow modeling of electrochromic windows.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/445\">issue 445</a>.
</li>
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
