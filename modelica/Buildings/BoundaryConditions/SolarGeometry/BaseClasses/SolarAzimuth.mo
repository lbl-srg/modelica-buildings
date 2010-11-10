within Buildings.BoundaryConditions.SolarGeometry.BaseClasses;
block SolarAzimuth "Solar azimuth"
  extends Modelica.Blocks.Interfaces.BlockIcon;
public
  parameter Modelica.SIunits.Angle lat "Latitude";
  Modelica.Blocks.Interfaces.RealInput zenAng(quantity="Angle", unit="rad")
    "Zenith angle"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput solTim(quantity="Time", unit="s")
    "Solar time" annotation (Placement(transformation(extent={{-140,-80},{-100,
            -40}}), iconTransformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealOutput solAzi(
    final quantity="Angle",
    final unit="rad",
    displayUnit="deg") "Solar Azimuth"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput decAng(quantity="Angle", unit="rad")
    "Decline angle"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

protected
Real arg;
Real tmp;

algorithm
  tmp :=(Modelica.Math.sin(lat)*Modelica.Math.cos(zenAng) - Modelica.Math.sin(
    decAng))/(Modelica.Math.cos(lat)*Modelica.Math.sin(zenAng));

  arg :=min(1.0, max(-1.0, tmp));

  if solTim < 43200 then
    solAzi :=-Modelica.Math.acos(arg);
  else
    solAzi := Modelica.Math.acos(arg);
  end if "(A4.9a and b)";
  annotation (
    defaultComponentName="solAzi",
    Documentation(info="<HTML>
<p>
This component computes the azimuth angle of sun.
</p>
</HTML>
", revisions="<html>
<ul>
<li>
May 18, 2010, by Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),
                    graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{-100,68},{-58,58}},
          lineColor={0,0,127},
          textString="zenAng"),
        Text(
          extent={{-102,-54},{-60,-64}},
          lineColor={0,0,127},
          textString="solTim"),
        Text(
          extent={{-102,6},{-60,-4}},
          lineColor={0,0,127},
          textString="decAng")}),
    Icon(graphics),
    Diagram(graphics));
end SolarAzimuth;
