within Buildings.Experimental.DHC.Examples.Combined.Generation5.Unidirectional.EnergyTransferStations;
block SwitchBoxController "Controller for flow switch box"
  extends Modelica.Blocks.Icons.Block;
  Modelica.Blocks.Interfaces.RealInput mHeaAll_flow(final quantity=
        "MassFlowRate", final unit="kg/s")
    "Mass flow rate for all heating applications"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput mFreCoo_flow(final quantity=
        "MassFlowRate", final unit="kg/s") "Mass flow rate for free cooling"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealOutput m_flow(
    final quantity="MassFlowRate", final unit="kg/s") "Mass flow rate"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Modelica.Blocks.Logical.GreaterEqual heaDom
    "Output true if heating mass flow rate dominates"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Logical.Switch switchMode "Switch to select the mode"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Sources.Constant heaModOn(final k=1)
    "Output signal in case of dominating heating mode (direct flow)"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(trueHoldDuration=
        60)
    "True/false hold to remove the risk of chattering"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Sources.Constant cooModOn(final k=0)
    "Output signal in case of dominating cooling mode (reverse flow)"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
equation
  connect(heaModOn.y, switchMode.u1)
    annotation (Line(points={{21,80},{40,80},{40,8},{58,8}}, color={0,0,127}));
  connect(switchMode.y, m_flow)
    annotation (Line(points={{81,0},{120,0}}, color={0,0,127}));
  connect(mFreCoo_flow, heaDom.u2) annotation (Line(points={{-120,-80},{-80,-80},
          {-80,-8},{-42,-8}}, color={0,0,127}));
  connect(heaDom.y, truFalHol.u)
    annotation (Line(points={{-19,0},{-2,0}},
                                            color={255,0,255}));
  connect(truFalHol.y, switchMode.u2)
    annotation (Line(points={{22,0},{58,0}}, color={255,0,255}));
  connect(mHeaAll_flow, heaDom.u1) annotation (Line(points={{-120,80},{-80,80},
          {-80,0},{-42,0}}, color={0,0,127}));
  connect(cooModOn.y, switchMode.u3) annotation (Line(points={{21,-80},{40,-80},
          {40,-8},{58,-8}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
Controller for the mass flow rate for the switching box.
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
January 12, 2020, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>"));
end SwitchBoxController;
