within Buildings.Applications.DHC.EnergyTransferStations.BaseClasses;
block Constants "Generate constant signal of type Real"
  extends Modelica.Blocks.Icons.Block;

  parameter Real k[nCon]
    "Constant output value";
  parameter String conNam[nCon]
    "Name of the constant";
  parameter Integer nCon=1
    "Number of constants";

  Modelica.Blocks.Interfaces.RealOutput  y[nCon] = {k[i] for i}
    "Constant function"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  annotation (
    defaultComponentName="cons",
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Line(points={{-80,68},{-80,-80}}, color={192,192,192}),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,-70},{82,-70}}, color={192,192,192}),
        Polygon(
          points={{90,-70},{68,-62},{68,-78},{90,-70}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,0},{80,0}}),
        Text(
          extent={{-150,-150},{150,-110}},
          textString="k=%k"),
        Line(points={{-80,68},{-80,-80}}, color={95,95,95}),
        Line(
          points={{-80,0},{80,0}},
          color={0,0,255}),
        Text(
          extent={{-101,0},{-81,-20}},
          lineColor={0,0,0},
          textString="k"),
        Line(
          points={{-80,20},{80,20}},
          color={0,0,255}),
        Line(
          points={{-80,-20},{80,-20}},
          color={0,0,255}),
        Line(
          points={{-80,-40},{80,-40}},
          color={0,0,255}),
        Text(
          extent={{-19,40},{1,20}},
          lineColor={0,0,0},
          textString="k[1]"),
        Text(
          extent={{-19,20},{1,0}},
          lineColor={0,0,0},
          textString="k[2]"),
        Text(
          extent={{-17,-20},{3,-40}},
          lineColor={0,0,0},
          textString="k[i]")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Polygon(
          points={{-80,90},{-86,68},{-74,68},{-80,90}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,68},{-80,-80}}, color={95,95,95}),
        Line(
          points={{-80,0},{80,0}},
          color={0,0,255},
          thickness=0.5),
        Line(points={{-90,-70},{82,-70}}, color={95,95,95}),
        Polygon(
          points={{90,-70},{68,-64},{68,-76},{90,-70}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-83,92},{-30,74}},
          textString="y"),
        Text(
          extent={{70,-80},{94,-100}},
          textString="time"),
        Text(
          extent={{-101,0},{-81,-20}},
          lineColor={0,0,0},
          textString="k"),
        Line(
          points={{-80,20},{80,20}},
          color={0,0,255},
          thickness=0.5),
        Line(
          points={{-80,-20},{80,-20}},
          color={0,0,255},
          thickness=0.5),
        Line(
          points={{-80,-40},{80,-40}},
          color={0,0,255},
          thickness=0.5),
        Text(
          extent={{-7,40},{13,20}},
          lineColor={0,0,0},
          textString="k[1]"),
        Text(
          extent={{-7,20},{13,0}},
          lineColor={0,0,0},
          textString="k[2]"),
        Text(
          extent={{-9,-20},{11,-40}},
          lineColor={0,0,0},
          textString="k[i]")}),
          Documentation(info=" <html>
<p>
The Real outputs y[nCon] are constant signals, where nCon are number of constants.
</p>
<p align=\"center\">
<img alt=\"Multiple constants functions\"
src=\"modelica://Buildings/Resources/Images/Applications/DHC/EnergyTransferStations/constants.png\"/>
</p>
</html>",revisions="<html>
<ul>
<li>
January 21, 2020 by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end Constants;
