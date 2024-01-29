within Buildings.Templates.Plants.Components.Controls.Pumps.Generic.Validation;
model ControlDifferentialPressure
  "Validation model for the differential pressure control of variable speed pumps"
  parameter Integer nPum=4
    "Number of primary pumps that operate at design conditions";
  parameter Real VPri_flow_nominal=0.1
    "Design primary flow rate";
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable ratDp(
    table=[
      0, 0.1, 0.5;
      1, 1, 0.5;
      1.5, 1, 0.2;
      2, 0.1, 0.1],
    timeScale=3600)
    "Differential pressure ratio to design value"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1Pum(
    table=[
      0, 0, 0;
      2000, 1, 0;
      6000, 0, 1;
      8000, 0, 0],
    period=8400)
    "Pump status"
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter dpRemSet[2](
    k={3E4, 2E4})
    "Differential pressure setpoint"
    annotation (Placement(transformation(extent={{-48,10},{-28,30}})));
  Buildings.Templates.Plants.Components.Controls.Pumps.Generic.ControlDifferentialPressure ctlDpRem(
    have_senDpRemHar=true,
    nPum=2,
    nSenDpRem=2)
    "Differential pressure control with remote sensors hardwired to the plant controller"
    annotation (Placement(transformation(extent={{70,10},{90,30}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMax mulMax(
    nin=2)
    "Maximum value"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter dpLoc(
    final k=5)
    "Differential pressure local to the plant"
    annotation (Placement(transformation(extent={{30,-90},{50,-70}})));
  Buildings.Templates.Plants.Components.Controls.Pumps.Generic.ControlDifferentialPressure ctlDpLoc(
    have_senDpRemHar=false,
    nPum=2,
    nSenDpRem=2)
    "Differential pressure control without remote sensors hardwired to the plant controller"
    annotation (Placement(transformation(extent={{70,-50},{90,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin[2](
    amplitude=0.1 * dpRemSet.k,
    freqHz={2 / 8000, 4 / 8000},
    each phase=3.1415926535898)
    "Source signal used to generate measurement values"
    annotation (Placement(transformation(extent={{-88,-50},{-68,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Add dpRem[2]
    "Differential pressure at remote location"
    annotation (Placement(transformation(extent={{-48,-30},{-28,-10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter dpLocSet[2](
    each final k=5)
    "Local differential pressure setpoint"
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
equation
  connect(y1Pum.y, ctlDpRem.y1_actual)
    annotation (Line(points={{-68,60},{60,60},{60,28},{68,28}},color={255,0,255}));
  connect(mulMax.y, dpLoc.u)
    annotation (Line(points={{12,-80},{28,-80}},color={0,0,127}));
  connect(y1Pum.y, ctlDpLoc.y1_actual)
    annotation (Line(points={{-68,60},{60,60},{60,-32},{68,-32}},color={255,0,255}));
  connect(dpLoc.y, ctlDpLoc.dpLoc)
    annotation (Line(points={{52,-80},{60,-80},{60,-48},{68,-48}},color={0,0,127}));
  connect(ratDp.y, dpRemSet.u)
    annotation (Line(points={{-68,20},{-50,20}},color={0,0,127}));
  connect(sin.y, dpRem.u2)
    annotation (Line(points={{-66,-40},{-60,-40},{-60,-26},{-50,-26}},color={0,0,127}));
  connect(dpRemSet.y, dpRem.u1)
    annotation (Line(points={{-26,20},{-20,20},{-20,0},{-60,0},{-60,-14},{-50,-14}},
      color={0,0,127}));
  connect(dpRemSet.y, ctlDpRem.dpRemSet)
    annotation (Line(points={{-26,20},{40,20},{40,24},{68,24}},color={0,0,127}));
  connect(dpRem.y, ctlDpRem.dpRem)
    annotation (Line(points={{-26,-20},{50,-20},{50,20},{68,20}},color={0,0,127}));
  connect(dpRem.y, mulMax.u)
    annotation (Line(points={{-26,-20},{-20,-20},{-20,-80},{-12,-80}},color={0,0,127}));
  connect(dpRemSet.y, dpLocSet.u)
    annotation (Line(points={{-26,20},{20,20},{20,-40},{28,-40}},color={0,0,127}));
  connect(dpLocSet.y, ctlDpLoc.dpLocSet)
    annotation (Line(points={{52,-40},{60,-40},{60,-44},{68,-44}},color={0,0,127}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Components/Controls/Pumps/Generic/Validation/ControlDifferentialPressure.mos"
        "Simulate and plot"),
    experiment(
      StopTime=8400.0,
      Tolerance=1e-06),
    Documentation(
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Templates.Plants.Components.Controls.Pumps.Generic.ControlDifferentialPressure\">
Buildings.Templates.Plants.Components.Controls.Pumps.Generic.ControlDifferentialPressure</a>
in a configuration with two pumps and two remote DP sensors that either are
hardwired to the controller (component <code>ctlDpRem</code>)
or are not hardwired to the controller, which uses a local DP sensor instead
(component <code>ctlDpLoc</code>).
</p>
<p>
The simulation of this model shows that when any pump is proven on, 
the controller is enabled and its output is 
initially set to the minimum pump speed <code>y_min</code>.
The minimum pump speed sets the lower limit of the controller output 
for the entire time that the controller is enabled.
The output of the controller <code>ctlDpRem</code> is driven by the most 
demanding remote DP control loop, e.g.,
the controller output only drops when both loop input measurements are 
above setpoints.
Without remote sensors hardwired to the controller, the pump speed is
driven by the highest local DP setpoint.
</p>
<p>
When no pump is proven on, the controller is disabled and its output
is set to <i>0&nbsp;%</i>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
FIXME, 2024, by Antoine Gautier:<br/>
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
end ControlDifferentialPressure;
