within Buildings.Fluid.HeatExchangers;
model SteamHeatExchangerIdeal
  "Model for a shell-and-tube heat exchanger with phase change in one side"
  extends Buildings.Fluid.Interfaces.PartialTwoPortTwoMedium(
    redeclare replaceable package Medium_a =
      IBPSA.Media.Interfaces.PartialPureSubstanceWithSat);

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));

  parameter Modelica.SIunits.AbsolutePressure pSte_nominal
    "Nominal steam pressure";

  BaseClasses.Condensation con(
    redeclare package Medium_a = Medium_a,
    redeclare package Medium_b = Medium_b,
    m_flow_nominal=m_flow_nominal,
    pSte_nominal=pSte_nominal) "Condensation"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Interfaces.RealOutput dh(unit="J/kg") "Change in enthalpy"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
equation
  connect(port_a, con.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(con.port_b, port_b) annotation (Line(points={{10,0},{54,0},{54,0},{
          100,0}}, color={0,127,255}));
  connect(con.dh, dh) annotation (Line(points={{11,6},{50,6},{50,60},{110,60}},
        color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,6},{101,-7}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-149,-114},{151,-154}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-70,60},{70,-60}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={255,170,170},
          fillPattern=FillPattern.Sphere),
        Rectangle(
          extent={{70,60},{100,58}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-56,-14},{54,-74}},
          lineColor={255,255,255},
          textString="Q=%Q_flow_nominal"),
        Text(
          extent={{70,90},{90,70}},
          lineColor={0,0,127},
          textString="dh"),
      Line(
        points={{-42,32},{-62,22},{-42,2},{-62,-8}},
        color={0,0,0},
        smooth=Smooth.Bezier,
          extent={{-60,-22},{-36,2}}),
      Line(
        points={{-22,32},{-42,22},{-22,2},{-42,-8}},
        color={0,0,0},
        smooth=Smooth.Bezier,
          extent={{-60,-22},{-36,2}}),
      Line(
        points={{-2,32},{-22,22},{-2,2},{-22,-8}},
        color={0,0,0},
        smooth=Smooth.Bezier,
          extent={{-60,-22},{-36,2}}),
        Polygon(
          points={{26,20},{50,44},{54,40},{30,16},{26,20}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Sphere,
          fillColor={95,95,95}),
        Polygon(
          points={{26,4},{30,8},{54,-16},{50,-20},{26,4}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Sphere,
          fillColor={95,95,95}),
        Ellipse(
          extent={{42,52},{62,32}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={95,95,95}),
        Ellipse(
          extent={{2,32},{42,-8}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Sphere,
          fillColor={0,0,0}),
        Ellipse(
          extent={{42,-8},{62,-28}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={95,95,95}),
        Rectangle(
          extent={{-70,60},{70,-60}},
          lineColor={0,0,127},
          lineThickness=0.5)}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SteamHeatExchangerIdeal;
