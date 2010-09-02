within Buildings.BoundaryConditions.SkyTemperature.BaseClasses;
block BlackBodySkyTemperature "Calculate black body sky temperature"
  extends Modelica.Blocks.Interfaces.BlockIcon;
public
  Modelica.Blocks.Interfaces.RealInput TDry(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Dry bulb temperature at ground level"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput infCloAmo "Infrared cloud amount"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput cleSkyEmi "Clear sky emissivity"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealOutput TBlaSky(
    final quantity="ThermodynamicTemperature",
    displayUnit="degC",
    final unit="K") "Black-body sky temperature"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  TBlaSky = (cleSkyEmi + (1 - cleSkyEmi)*infCloAmo)^0.25*TDry;
  annotation (
    defaultComponentName="TBlaSky",
    Documentation(info="<HTML>
<p>
This component computes the black-body sky temperature.
</p>
</HTML>
", revisions="<html>
<ul>
<li>
June 1, 2010, by Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,
            100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{-50,44},{56,-40}},
          lineColor={0,0,255},
          textString="T"),
        Text(
          extent={{-96,64},{-72,56}},
          lineColor={0,0,127},
          textString="TDry"),
        Text(
          extent={{-94,8},{-54,-8}},
          lineColor={0,0,127},
          textString="infCloAmo"),
        Text(
          extent={{-96,-52},{-56,-68}},
          lineColor={0,0,127},
          textString="cleSkyEmi"),
        Text(
          extent={{16,-6},{54,-28}},
          lineColor={0,0,255},
          textString="bs")}));
end BlackBodySkyTemperature;
