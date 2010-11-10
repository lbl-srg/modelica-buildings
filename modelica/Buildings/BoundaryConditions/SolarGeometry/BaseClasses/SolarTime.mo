within Buildings.BoundaryConditions.SolarGeometry.BaseClasses;
block SolarTime "Solar time"
  extends Modelica.Blocks.Interfaces.BlockIcon;
public
  Modelica.Blocks.Interfaces.RealInput locTim(quantity="Time", unit="s")
    "Local time" annotation (Placement(transformation(extent={{-140,-74},{-100,
            -34}}), iconTransformation(extent={{-140,-74},{-100,-34}})));
  Modelica.Blocks.Interfaces.RealInput equTim(quantity="Time", unit="s")
    "Equation of time" annotation (Placement(transformation(extent={{-140,40},{
            -100,80}}), iconTransformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealOutput solTim(
    final quantity="Time",
    final unit="s",
    displayUnit="s") "Solar time"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
algorithm
  solTim := locTim + equTim "Our unit is s in stead of h in (A.4.3)";

  if solTim > 86400 then
    solTim := solTim - 86400;
  elseif  solTim < 0 then
    solTim := solTim + 86400;
  end if "Limit 0 <= solTim <= 86400";

  annotation (
    defaultComponentName="solTim",
    Documentation(info="<HTML>
<p>
This component compute the local solar time.
</p>
</HTML>
", revisions="<html>
<ul>
<li>
May 13, 2010, by Wangda Zuo:<br>
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
          extent={{-54,38},{42,-24}},
          lineColor={0,0,255},
          textString="t"),
        Text(
          extent={{-4,4},{52,-24}},
          lineColor={0,0,255},
          textString="sol"),
        Text(
          extent={{-94,66},{-42,50}},
          lineColor={0,0,127},
          textString="equTim"),
        Text(
          extent={{-96,-44},{-44,-60}},
          lineColor={0,0,127},
          textString="locTim")}),
    DymolaStoredErrors);
end SolarTime;
