within Buildings.BoundaryConditions.WeatherData.BaseClasses;
block SolarTime "Solar time"
  extends Modelica.Blocks.Icons.Block;
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
equation
  solTim = locTim + equTim "Our unit is s in stead of h in (A.4.3)";

  annotation (
    defaultComponentName="solTim",
    Documentation(info="<html>
<p>
This component computes the local solar time.
</p>
<p>
<b>Note:</b> To avoid events, this block does not convert solar time to a scale of 24 hours.
</p>
</html>", revisions="<html>
<ul>
<li>
Feb. 16, 2012, by Michael Wetter:<br/>
Removed section that limits solar time to
<code>0 &le; solTim &le; 86400</code> as this triggers
events, and is not needed because solar time is used in
trigonometric functions only.
</li>
<li>
May 13, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{-54,38},{42,-24}},
          textColor={0,0,255},
          textString="t"),
        Text(
          extent={{-4,4},{52,-24}},
          textColor={0,0,255},
          textString="sol"),
        Text(
          extent={{-94,66},{-42,50}},
          textColor={0,0,127},
          textString="equTim"),
        Text(
          extent={{-96,-44},{-44,-60}},
          textColor={0,0,127},
          textString="locTim")}));
end SolarTime;
