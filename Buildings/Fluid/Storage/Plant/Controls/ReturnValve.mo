within Buildings.Fluid.Storage.Plant.Controls;
block ReturnValve "Block that controls the interlocked return valves"
  extends Modelica.Blocks.Icons.Block;

  Modelica.Blocks.Interfaces.RealOutput yVal[2]
    "Valve control signals after processing"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,0}),  iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,0})));
  Modelica.Blocks.Interfaces.RealInput uVal[2]
    "Valve control signals before processing" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-110,0}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,0})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=Modelica.Constants.eps) "Input is greater than zero"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(
    final realTrue=1,
    final realFalse=0) "True = 1, false = 0" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,30})));
equation
  connect(uVal[2], greThr.u) annotation (Line(points={{-107.5,0},{-60,0},{-60,30},
          {-42,30}}, color={0,0,127}));
  connect(greThr.y, booToRea.u)
    annotation (Line(points={{-18,30},{18,30}}, color={255,0,255}));
  connect(booToRea.y, yVal[1]) annotation (Line(points={{42,30},{60,30},{60,-2.5},
          {110,-2.5}}, color={0,0,127}));
  connect(uVal[1], yVal[2]) annotation (Line(points={{-112.5,0},{-2,0},{-2,2.5},
          {110,2.5}}, color={0,0,127}));
  annotation (defaultComponentName="conRetVal",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Line(points={{-80,40},{-40,40},{20,-40},{80,-40}}, color={28,108,200}),
        Polygon(
          points={{0,15},{10,-15},{-10,-15},{0,15}},
          lineColor={28,108,200},
          lineThickness=1,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          origin={64,-40},
          rotation=-90),
        Line(points={{-80,-40},{-40,-40},{20,40},{80,40}}, color={238,46,47}),
        Polygon(
          points={{0,15},{10,-15},{-10,-15},{0,15}},
          lineColor={238,46,47},
          lineThickness=1,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          origin={64,40},
          rotation=-90)}),                                       Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This block controls the pair of interlocked valves on the return line.
It uses the control signals for the valves on the supply line and processes them
as such:
</p>
<ul>
<li>
It swaps the two control signals.
The signal from <code>u[1]</code> is connected to <code>y[2]</code>,
and <code>u[2]</code> to <code>y[1]</code>.
</li>
<li>
It converts the analogue signal from <code>u[2]</code> to an on-off (0-1) signal
when it is passed to <code>y[1]</code>.
</li>
</ul>
</html>"));
end ReturnValve;
