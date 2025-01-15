within Buildings.DHC.Networks.BaseClasses;
partial model PartialConnection2Pipe
  "Partial model for connecting an agent to a two-pipe distribution network"
  extends
    Buildings.DHC.Networks.BaseClasses.PartialConnection2Pipe2Medium(
    redeclare final package MediumSup=Medium,
    redeclare final package MediumRet=Medium);
  replaceable package Medium=Modelica.Media.Interfaces.PartialMedium
    "Medium model";
  replaceable model Model_pipCon=Fluid.Interfaces.PartialTwoPortInterface (
    redeclare final package Medium=Medium,
    final m_flow_nominal=mCon_flow_nominal,
    final allowFlowReversal=allowFlowReversal);
  parameter Boolean show_entFlo=false
    "Set to true to output enthalpy flow rate difference"
    annotation (Evaluate=true);

  // OUTPUTS
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mCon_flow(
    final quantity="MassFlowRate",
    final unit="kg/s")
    "Connection supply mass flow rate"
    annotation (Placement(transformation(extent={{100,20},{140,60}}),
      iconTransformation(extent={{100,50},{140,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dp(
    final quantity="PressureDifference",
    final unit="Pa",
    final displayUnit="Pa")
    "Pressure drop accross the connection (measured)"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dH_flow(
    final unit="W") if show_entFlo
    "Difference in enthalpy flow rate between connection supply and return"
    annotation (Placement(transformation(extent={{100,70},{140,110}}),
        iconTransformation(extent={{100,70},{140,110}})));
  // COMPONENTS
  Model_pipCon pipCon
    "Connection pipe"
    annotation (Placement(
      transformation(extent={{-10,-10},{10,10}},rotation=90,origin={-20,-10})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFloCon(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal)
    "Connection supply mass flow rate (measured)"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},rotation=90,origin={-20,40})));
  Fluid.Sensors.RelativePressure senRelPre(
    redeclare final package Medium=Medium)
    "Relative pressure sensor"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},rotation=-90,origin={-40,-60})));
  DifferenceEnthalpyFlowRate senDifEntFlo(
    redeclare final package Medium1 = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mCon_flow_nominal) if show_entFlo
    "Difference in enthalpy flow rate"
    annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=90,
      origin={0,80})));
equation
  // Connect statements involving conditionally removed components are
  // removed at translation time by Modelica specification.
  // Only obsolete statements corresponding to the default model structure need
  // to be programmatically removed.
  if not show_entFlo then
    connect(port_bCon,senMasFloCon.port_b)
      annotation (Line(points={{-20,120},{-20,50}},color={0,127,255}));
    connect(port_aCon, junConRet.port_3)
      annotation (Line(points={{20,120},{20,-70}}, color={0,127,255}));
  end if;
  connect(senMasFloCon.m_flow,mCon_flow)
    annotation (Line(points={{-9,40},{120,40}},color={0,0,127}));
  connect(senRelPre.port_a,junConSup.port_1)
    annotation (Line(points={{-40,-50},{-40,-40},{-30,-40}},color={0,127,255}));
  connect(senRelPre.port_b,junConRet.port_2)
    annotation (Line(points={{-40,-70},{-40,-80},{10,-80}},color={0,127,255}));
  connect(senRelPre.p_rel,dp)
    annotation (Line(points={{-31,-60},{80,-60},{80,0},{120,0}},color={0,0,127}));
  connect(port_bCon, senDifEntFlo.port_b1)
    annotation (Line(points={{-20,120},{-20,
          100},{-6,100},{-6,90}}, color={0,127,255}));
  connect(senDifEntFlo.port_a2, port_aCon)
    annotation (Line(points={{6,90},{6,100},
          {20,100},{20,120}}, color={0,127,255}));
  connect(senDifEntFlo.dH_flow, dH_flow)
    annotation (Line(points={{-3,92},{-3,
          106},{40,106},{40,90},{120,90}},color={0,0,127}));
  connect(senMasFloCon.port_b, senDifEntFlo.port_a1)
    annotation (Line(points={{-20,
          50},{-20,60},{-6,60},{-6,70}}, color={0,127,255}));
  connect(senDifEntFlo.port_b2, junConRet.port_3) annotation (Line(points={{6,70},
          {6,60},{20,60},{20,-70}}, color={0,127,255}));
  connect(pipCon.port_a, junConSup.port_3)
    annotation (Line(points={{-20,-20},{-20,-30}}, color={0,127,255}));
  connect(senMasFloCon.port_a, pipCon.port_b)
    annotation (Line(points={{-20,30},{-20,0},{-20,0}}, color={0,127,255}));
  connect(pipDisSup.port_b, junConSup.port_1)
    annotation (Line(points={{-60,-40},{-30,-40}}, color={0,127,255}));
  connect(pipDisRet.port_a, junConRet.port_2)
    annotation (Line(points={{-60,-80},{10,-80}}, color={0,127,255}));
  annotation (
    defaultComponentName="con",
    Documentation(
      info="
<html>
<p>
Partial model to be used for connecting an agent (e.g. an energy transfer station)
to a two-pipe distribution network.
</p>
<p>
Three instances of a replaceable partial model are used to represent the pipes:
</p>
<ul>
<li>
One representing the main distribution supply pipe immediately upstream
the connection.
</li>
<li>
Another one representing the main distribution return pipe immediately downstream
the connection.
</li>
<li>
The last one representing both the supply and return lines of the connection.
When replacing that model with a pipe model computing the pressure drop,
one must double the length so that both the supply and return lines are
accounted for.
</li>
</ul>
</html>",
      revisions="<html>
<ul>
<li>
March 28, 2022, by Kathryn Hinkelman:<br/>
Refactored to extend shared two medium base class.
</li>
<li>
March 3, 2022, by Michael Wetter:<br/>
Removed <code>massDynamics</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1542\">issue 1542</a>.
</li>
<li>
February 21, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,2},{100,-2}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-2,-2},{2,100}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Text(
          extent={{-152,-104},{148,-144}},
          textString="%name",
          textColor={0,0,255}),
        Rectangle(
          extent={{-76,12},{-20,-12}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-25,8},{25,-8}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={0,45},
          rotation=90),
        Rectangle(
          extent={{58,6},{62,100}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-100,-58},{100,-62}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-76,-48},{-20,-72}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{58,-62},{62,-6}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-25.5,7.5},{25.5,-7.5}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={59.5,45.5},
          rotation=90)}),
    Diagram(
      coordinateSystem(
        extent={{-100,-120},{100,120}})));
end PartialConnection2Pipe;
