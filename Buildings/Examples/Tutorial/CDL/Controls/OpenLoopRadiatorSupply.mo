within Buildings.Examples.Tutorial.CDL.Controls;
block OpenLoopRadiatorSupply
  "Open loop controller for mixing valve in radiator loop"
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRoo(
    final unit="K",
    displayUnit="degC")
    "Room air temperature"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    displayUnit="degC")
    "Measured supply water temperature"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yVal(
    final unit="1")
    "Valve control signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(k=1)
    "Constant valve control signal"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(con.y, yVal)
    annotation (Line(points={{12,0},{120,0}}, color={0,0,127}));
  annotation (
  defaultComponentName="conRadSup",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-90,82},{-42,42}},
          textColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          textString="TRoo"),
        Text(
          extent={{40,24},{88,-16}},
          textColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          textString="yVal"),
        Text(
          extent={{-92,-40},{-44,-80}},
          textColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          textString="TOut"),
        Text(
          textColor={0,0,255},
          extent={{-154,104},{146,144}},
          textString="%name"),
    Polygon(
      points={{38,0},{-24,36},{-24,-32},{38,0}},
      lineColor={0,0,0},
      fillColor={0,0,0},
      fillPattern=FillPattern.Solid,
          origin={-30,2},
          rotation=360),
    Polygon(
      points={{38,0},{-24,36},{-24,-32},{38,0}},
      lineColor={0,0,0},
      fillColor={0,0,0},
      fillPattern=FillPattern.Solid,
          origin={8,-36},
          rotation=90),
    Polygon(
      points={{38,0},{-24,36},{-24,-32},{38,0}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid,
          origin={8,40},
          rotation=270)}),                           Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Open loop controller that outputs a constant control signal for the mixing valve of the radiator loop.
</p>
</html>", revisions="<html>
<ul>
<li>
March 5, 2020, by Michael Wetter:<br/>
Corrected typo in comments.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1810\">issue 1810</a>.
</li>
<li>
February 18, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end OpenLoopRadiatorSupply;
