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
equation
  if solTim < 43200 then
    solAzi = -Modelica.Math.cosh((Modelica.Math.cos(lat)*Modelica.Math.cos(
      zenAng) - Modelica.Math.sin(lat))/(Modelica.Math.cos(lat)*
      Modelica.Math.sin(zenAng)));
  else
    solAzi = Modelica.Math.cosh((Modelica.Math.cos(lat)*Modelica.Math.cos(
      zenAng) - Modelica.Math.sin(lat))/(Modelica.Math.cos(lat)*
      Modelica.Math.sin(zenAng)));
  end if;
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
    Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,
            100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{-98,68},{-56,58}},
          lineColor={0,0,127},
          textString="zenAng"),
        Text(
          extent={{-102,-54},{-60,-64}},
          lineColor={0,0,127},
          textString="solTim")}),
    Icon(graphics),
    Diagram(graphics));
end SolarAzimuth;
