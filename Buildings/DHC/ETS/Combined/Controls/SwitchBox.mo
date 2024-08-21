within Buildings.DHC.ETS.Combined.Controls;
block SwitchBox "Controller for flow switch box"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Nominal mass flow rate, used for scaling to avoid chattering"
    annotation (Dialog(group="Nominal condition"));
  parameter Real trueHoldDuration(
    final quantity="Time",
    final unit="s")
    "true hold duration";
  parameter Real falseHoldDuration(
    final quantity="Time",
    final unit="s") = trueHoldDuration
    "false hold duration";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mPos_flow(final unit="kg/s")
    "Service water mass flow rate in positive direction"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mRev_flow(final unit="kg/s")
    "Service water mass flow rate in reverse direction"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(final unit="1")
    "Control output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold posDom(final t, h=0.001*m_flow_nominal)
    "Output true in case of dominating positive flow"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Logical.Switch swi "Switch to select the mode"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Modelica.Blocks.Sources.Constant posModOn(final k=1)
    "Output signal in case of dominating positive flow"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(
    final trueHoldDuration=trueHoldDuration,
    final falseHoldDuration=falseHoldDuration)
    "True/false hold to remove the risk of chattering"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Modelica.Blocks.Sources.Constant revModOn(final k=0)
    "Output signal in case of dominating reverse flow"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub
    "Flow difference"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Reals.MovingAverage movAve(delta=trueHoldDuration/10)
    "Rolling average of flow difference"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
equation
  connect(posModOn.y, swi.u1)
    annotation (Line(points={{21,80},{60,80},{60,8},{68,8}}, color={0,0,127}));
  connect(swi.y, y) annotation (Line(points={{91,0},{120,0}}, color={0,0,127}));
  connect(posDom.y, truFalHol.u)
    annotation (Line(points={{12,0},{28,0}},color={255,0,255}));
  connect(truFalHol.y, swi.u2)
    annotation (Line(points={{52,0},{68,0}}, color={255,0,255}));
  connect(revModOn.y, swi.u3) annotation (Line(points={{21,-80},{60,-80},{60,-8},
          {68,-8}}, color={0,0,127}));
  connect(mPos_flow, sub.u1) annotation (Line(points={{-120,80},{-90,80},{-90,6},
          {-82,6}}, color={0,0,127}));
  connect(mRev_flow, sub.u2) annotation (Line(points={{-120,-80},{-90,-80},{-90,
          -6},{-82,-6}}, color={0,0,127}));
  connect(posDom.u, movAve.y)
    annotation (Line(points={{-12,0},{-28,0}}, color={0,0,127}));
  connect(movAve.u, sub.y)
    annotation (Line(points={{-52,0},{-58,0}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This block implements a control logic preventing flow reversal in the
service line, for instance with the hydronic configuration of
<a href=\"modelica://Buildings.DHC.ETS.Combined.HeatPumpHeatExchanger\">
Buildings.DHC.ETS.Combined.HeatPumpHeatExchanger</a>.
The block requires two input signals representing the mass flow rate contributing
to a positive flow direction <code>mPos_flow</code> and the mass flow contributing
to a reverse flow direction <code>mRev_flow</code>.
The output signal <code>y</code> switches to maintain <code>mPos_flow ≥ mRev_flow</code>
with a temporization avoiding short cycling.
Due to the temporization, the mass flow rate may transiently change direction as
illustrated in
<a href=\"modelica://Buildings.DHC.ETS.Combined.Subsystems.Validation.SwitchBox\">
Buildings.DHC.ETS.Combined.Subsystems.Validation.SwitchBox</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 21, 2024, by Antoine Gautier:<br/>
Added moving average to break the algebraic loop when using components configured in steady state.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3906\">#3906</a>.
</li>
<li>
February 28, 2024, by Michael Wetter:<br/>
Added hysteresis to avoid chattering if signals are near zero and have numerical noise.
</li>
<li>
February 23, 2021, by Antoine Gautier:<br/>
Refactored with CDL connectors.
</li>
<li>
January 23, 2020, by Michael Wetter:<br/>
Added <a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.TrueFalseHold\">
Buildings.Controls.OBC.CDL.Logical.TrueFalseHold</a>
to avoid the risk of chattering.
</li>
<li>
January 12, 2020, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>"));
end SwitchBox;
