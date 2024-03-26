within Buildings.Templates.Plants.Controls.Pumps.Generic.Validation;
model ResetLocalDifferentialPressure
  "Validation model for the local differential pressure reset"
  parameter Integer nPum=4
    "Number of primary pumps that operate at design conditions";
  parameter Real VPri_flow_nominal=0.1
    "Design primary flow rate";
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable ratDp(
    table=[
      0, 0.1;
      1, 1;
      1.5, 1;
      2, 0.1],
    timeScale=3600)
    "Differential pressure ratio to design value"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter dpRemSet(
    k=3E4)
    "Differential pressure setpoint"
    annotation (Placement(transformation(extent={{-48,10},{-28,30}})));
  Buildings.Templates.Plants.Controls.Pumps.Generic.ResetLocalDifferentialPressure resDpLoc(
    each dpLocSet_max=1E5,
    Ti=10)
    "Local differential pressure reset"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin(
    amplitude=0.1 * dpRemSet.k,
    freqHz=4 / 8000,
    phase=3.1415926535898)
    "Source signal used to generate measurement values"
    annotation (Placement(transformation(extent={{-88,-50},{-68,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Add dpRem
    "Differential pressure at remote location"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
equation
  connect(sin.y, dpRem.u2)
    annotation (Line(points={{-66,-40},{0,-40},{0,-26},{18,-26}},color={0,0,127}));
  connect(dpRemSet.y, resDpLoc.dpRemSet)
    annotation (Line(points={{-26,20},{60,20},{60,6},{68,6}},color={0,0,127}));
  connect(dpRem.y, resDpLoc.dpRem)
    annotation (Line(points={{42,-20},{60,-20},{60,-6},{68,-6}},
                                                              color={0,0,127}));
  connect(dpRemSet.y, dpRem.u1)
    annotation (Line(points={{-26,20},{0,20},{0,-14},{18,-14}},color={0,0,127}));
  connect(ratDp.y[1], dpRemSet.u)
    annotation (Line(points={{-68,20},{-50,20}},color={0,0,127}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/Pumps/Generic/Validation/ResetLocalDifferentialPressure.mos"
        "Simulate and plot"),
    experiment(
      StopTime=8400.0,
      Tolerance=1e-06),
    Documentation(
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Templates.Plants.Controls.Pumps.Generic.ResetLocalDifferentialPressure\">
Buildings.Templates.Plants.Controls.Pumps.Generic.ResetLocalDifferentialPressure</a>.
</p>
<p>
The simulation of this model shows how the local DP
setpoint is reset by the controller <code>resDpLoc</code>
based on the variation of the remote differential pressure
around its setpoint.
The local DP setpoint remains bounded by
<code>resDpLoc.dpLocSet_min</code> and <code>resDpLoc.dpLocSet_max</code>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(
      graphics={
        Polygon(
          points={{214,66},{214,66}},
          lineColor={28,108,200})}));
end ResetLocalDifferentialPressure;
