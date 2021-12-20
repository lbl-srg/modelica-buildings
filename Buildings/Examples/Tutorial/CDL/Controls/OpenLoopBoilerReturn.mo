within Buildings.Examples.Tutorial.CDL.Controls;
block OpenLoopBoilerReturn "Open loop controller for boiler return"
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRet(
    final unit="K",
    displayUnit="degC")
    "Return water temperature to boiler"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yVal(
    final unit="1")
    "Valve control signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(k=1)
    "Constant valve control signal"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(con.y, yVal)
    annotation (Line(points={{12,0},{120,0}}, color={0,0,127}));
  annotation (
  defaultComponentName="conBoiRet",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-32,-30},{34,-86}},
          lineColor={255,255,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-88,22},{-40,-18}},
          textColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          textString="TRet"),
        Text(
          extent={{40,24},{88,-16}},
          textColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          textString="yVal"),
        Polygon(
          points={{0,-62},{-12,-80},{14,-80},{0,-62}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Text(
          textColor={0,0,255},
          extent={{-154,104},{146,144}},
          textString="%name")}),                     Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Open loop controller that outputs a constant control signal for the valve
of the boiler return.
</p>
</html>", revisions="<html>
<ul>
<li>
February 18, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end OpenLoopBoilerReturn;
