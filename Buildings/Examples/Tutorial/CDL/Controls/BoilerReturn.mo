within Buildings.Examples.Tutorial.CDL.Controls;
block BoilerReturn "Control for boiler return"
  parameter Real TSet(
    final unit="K",
    displayUnit="degC") = 333.15
    "Set point for boiler temperature";
  parameter Real k=0.1 "Gain of controller";
  parameter Modelica.SIunits.Time Ti=120 "Time constant of integrator block";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRet(
    final unit="K",
    displayUnit="degC")
    "Return water temperature to boiler"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yVal(
    final unit="1")
    "Valve control signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant T(
    final k=TSet)
    "Set point temperature"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.PID conPID(
    final k=k,
    final Ti=Ti,
    reverseActing=false) "Controller for valve in boiler loop"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(conPID.y, yVal)
    annotation (Line(points={{12,0},{120,0}}, color={0,0,127}));
  connect(conPID.u_s, T.y)
    annotation (Line(points={{-12,0},{-38,0}}, color={0,0,127}));
  connect(TRet, conPID.u_m) annotation (Line(points={{-120,0},{-80,0},{-80,-50},
          {0,-50},{0,-12}}, color={0,0,127}));
  annotation (
  defaultComponentName="conBoiRet",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-32,-30},{34,-86}},
          lineColor={255,255,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-88,22},{-40,-18}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          textString="TRet"),
        Text(
          extent={{40,24},{88,-16}},
          lineColor={0,0,0},
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
          lineColor={0,0,255},
          extent={{-154,104},{146,144}},
          textString="%name")}),                     Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Controller that takes as an input the boiler return water temperature <code>TRet</code>
and outputs the valve control signal <code>yVal</code>.
The valve control signal is computed using a PI-controller that tracks a constant
set point of <code>TSet</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 18, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end BoilerReturn;
