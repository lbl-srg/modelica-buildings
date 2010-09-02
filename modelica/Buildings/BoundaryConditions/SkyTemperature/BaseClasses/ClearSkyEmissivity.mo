within Buildings.BoundaryConditions.SkyTemperature.BaseClasses;
block ClearSkyEmissivity "Emissivity of the clear sky"
  extends Modelica.Blocks.Interfaces.BlockIcon;
public
  Modelica.Blocks.Interfaces.RealInput basEmi "Base emissivity"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput diuCor "Diurnal correction"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealInput eleCor "Elevation correction"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput skyEmi "Emissivity of the clear sky"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  skyEmi = basEmi + diuCor + eleCor;
  annotation (
    defaultComponentName="skyEmi",
    Documentation(info="<HTML>
<p>
This component computes the emissivity for the clear sky.
</p>
</HTML>
", revisions="<html>
<ul>
<li>
May 24, 2010, by Wangda Zuo:<br>
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
          extent={{-50,48},{42,-32}},
          lineColor={0,0,255},
          textString="E"),
        Text(
          extent={{20,4},{50,-26}},
          lineColor={0,0,255},
          textString="sky"),
        Text(
          extent={{-98,76},{-64,46}},
          lineColor={0,0,127},
          textString="basEmi"),
        Text(
          extent={{-98,16},{-64,-14}},
          lineColor={0,0,127},
          textString="eleCor"),
        Text(
          extent={{-98,-46},{-64,-76}},
          lineColor={0,0,127},
          textString="diuCor")}));
end ClearSkyEmissivity;
