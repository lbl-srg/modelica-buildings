within Buildings.Experimental.DHC.EnergyTransferStations.Combined.Controls;
block SwitchBox "Controller for flow switch box"
  extends Modelica.Blocks.Icons.Block;
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
  Modelica.Blocks.Logical.GreaterEqual posDom
    "Output true in case of dominating positive flow"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Logical.Switch swi "Switch to select the mode"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Sources.Constant posModOn(final k=1)
    "Output signal in case of dominating positive flow"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(
    final trueHoldDuration=trueHoldDuration,
    final falseHoldDuration=falseHoldDuration)
    "True/false hold to remove the risk of chattering"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Sources.Constant revModOn(final k=0)
    "Output signal in case of dominating reverse flow"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
equation
  connect(posModOn.y, swi.u1)
    annotation (Line(points={{21,80},{40,80},{40,8},{58,8}}, color={0,0,127}));
  connect(swi.y, y) annotation (Line(points={{81,0},{120,0}}, color={0,0,127}));
  connect(mRev_flow, posDom.u2) annotation (Line(points={{-120,-80},{-80,-80},{-80,
          -8},{-42,-8}}, color={0,0,127}));
  connect(posDom.y, truFalHol.u)
    annotation (Line(points={{-19,0},{-2,0}},
                                            color={255,0,255}));
  connect(truFalHol.y, swi.u2)
    annotation (Line(points={{22,0},{58,0}}, color={255,0,255}));
  connect(mPos_flow, posDom.u1) annotation (Line(points={{-120,80},{-80,80},{-80,
          0},{-42,0}}, color={0,0,127}));
  connect(revModOn.y, swi.u3) annotation (Line(points={{21,-80},{40,-80},{40,-8},
          {58,-8}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This block implements a control logic preventing flow reversal in the 
service line, for instance with the hydronic configuration of 
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.HeatPumpHeatExchanger\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.HeatPumpHeatExchanger</a>.
The block requires two input signals representing the mass flow rate contributing
to a positive flow direction <code>mPos_flow</code> and the mass flow contributing
to a reverse flow direction <code>mRev_flow</code>.
The output signal <code>y</code> switches to maintain <code>mPos_flow ≥ mRev_flow</code>  
with a temporization avoiding short cycling. 
Due to the temporization, the mass flow rate may transiently change direction as
illustrated in
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems.Validation.SwitchBox\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems.Validation.SwitchBox</a>.
</p>
</html>", revisions="<html>
<ul>
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
