within Buildings.Fluid.Boilers.BaseClasses;
model Boiling
  "Model for the boiling process of water from liquid to saturated vapor states"
  extends Buildings.Fluid.Interfaces.PartialTwoPortTwoMedium(
    redeclare final package Medium_b = MediumSte,
    redeclare final package Medium_a = MediumWat,
    final show_T = true);

  package MediumSte = IBPSA.Media.Steam "Steam medium";
  package MediumWat = IBPSA.Media.Water(T_max=623.15) "Water medium";


  Modelica.Blocks.Interfaces.RealOutput dhOut(unit="J/kg") "Change in enthalpy"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));


//protected
  Modelica.SIunits.SpecificEnthalpy dh "Change in enthalpy";
  // State p & T remain unchanged (saturated vapor to saturated liquid)

equation
  sta_a.T = sta_b.T;
  port_b.p = port_a.p;

  // Steady state conservation of mass
  port_a.m_flow + port_b.m_flow = 0;

  // Enthalpy decreased with condensation process
  dh = MediumSte.enthalpyOfVaporization_sat(MediumSte.saturationState_p(port_b.p))
    "Enthalpy is changed by a factor of h_fg";
  port_b.h_outflow = port_a.h_outflow + dh;
  port_b.h_outflow - port_a.h_outflow = dhOut;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-101,6},{-80,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{80,6},{100,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-80,-60},{80,60}},
          lineColor={238,46,47},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-48,8},{-24,32},{-20,28},{-44,4},{-48,8}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Sphere,
          fillColor={95,95,95}),
        Polygon(
          points={{-48,-8},{-44,-4},{-20,-28},{-24,-32},{-48,-8}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Sphere,
          fillColor={95,95,95}),
      Line(
        points={{28,20},{8,10},{28,-10},{8,-20}},
        color={0,0,0},
        smooth=Smooth.Bezier,
          extent={{-60,-22},{-36,2}}),
      Line(
        points={{48,20},{28,10},{48,-10},{28,-20}},
        color={0,0,0},
        smooth=Smooth.Bezier,
          extent={{-60,-22},{-36,2}}),
      Line(
        points={{68,20},{48,10},{68,-10},{48,-20}},
        color={0,0,0},
        smooth=Smooth.Bezier,
          extent={{-60,-22},{-36,2}}),
        Ellipse(
          extent={{-32,40},{-12,20}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={95,95,95}),
        Ellipse(
          extent={{-72,20},{-32,-20}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Sphere,
          fillColor={0,0,0}),
        Ellipse(
          extent={{-32,-20},{-12,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={95,95,95}),
        Line(
          points={{0,40},{60,40},{40,50}},
          color={238,46,47},
          thickness=0.5),
        Line(
          points={{0,-40},{60,-40},{40,-50}},
          color={238,46,47},
          thickness=0.5),
        Text(
          extent={{-147,-114},{153,-154}},
          lineColor={0,0,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Boiling;
