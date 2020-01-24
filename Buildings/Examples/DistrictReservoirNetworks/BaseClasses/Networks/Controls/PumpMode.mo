within Buildings.Examples.DistrictReservoirNetworks.BaseClasses.Networks.Controls;
block PumpMode
  "Controller that outputs the setpoint for the pump mass flow rate"
  extends Modelica.Blocks.Icons.Block;
  Modelica.Blocks.Interfaces.RealInput mBorFie_flow
    "Mass flow rate in borefield"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput mPum_flow "Mass flow rate for pump"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Logical.Switch swi "Switch for mass flow rate"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Sources.Constant winterMode(k=0)
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Modelica.Blocks.Logical.GreaterEqualThreshold isWin
    "Output true if winter mode"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Modelica.Blocks.Math.Abs summerMode "Mass flow rate during summer"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(
    trueHoldDuration=5*60)
    "True/false hold to remove the risk of chattering"
    annotation (Placement(transformation(extent={{12,-10},{32,10}})));
equation
  connect(swi.y, mPum_flow)
    annotation (Line(points={{81,0},{110,0}}, color={0,0,127}));
  connect(winterMode.y, swi.u1)
    annotation (Line(points={{21,40},{40,40},{40,8},{58,8}}, color={0,0,127}));
  connect(mBorFie_flow, isWin.u)
    annotation (Line(points={{-120,0},{-22,0}}, color={0,0,127}));
  connect(summerMode.y, swi.u3) annotation (Line(points={{21,-40},{40,-40},{40,
          -8},{58,-8}}, color={0,0,127}));
  connect(mBorFie_flow, summerMode.u) annotation (Line(points={{-120,0},{-40,0},
          {-40,-40},{-2,-40}},        color={0,0,127}));
  connect(isWin.y, truFalHol.u)
    annotation (Line(points={{1,0},{11,0}}, color={255,0,255}));
  connect(truFalHol.y, swi.u2)
    annotation (Line(points={{33,0},{58,0}}, color={255,0,255}));
  annotation (Documentation(info="<html>
<p>
Controller that is used in the bidirectional network to set the mass flow rate
of the pumps in the flow switch box of the borefield.
In winter mode, the control signal is <i>0</i>, and in summer mode it is the absolute
value of the input signal <code>mBorFie_flow</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 23, 2020, by Michael Wetter:<br/>
Added <a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.TrueFalseHold\">
Buildings.Controls.OBC.CDL.Logical.TrueFalseHold</a>
to avoid the risk of chattering.
</li>
<li>
January 16, 2020, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>"));
end PumpMode;
