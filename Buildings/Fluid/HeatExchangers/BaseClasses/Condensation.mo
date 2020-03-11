within Buildings.Fluid.HeatExchangers.BaseClasses;
model Condensation
  "Base condensation model for converting water from vapor (superheated or 
    saturated) to saturated liquid"
  extends Buildings.Fluid.Interfaces.PartialTwoPortTwoMedium(
    redeclare final package Medium_b = MediumWat,
    redeclare final package Medium_a = MediumSte,
    final show_T = true);

  package MediumSte = IBPSA.Media.Steam "Steam medium";
  package MediumWat = IBPSA.Media.Water(T_max=623.15) "Water medium";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_h
    "Outflow heat port (negative by convention)"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

//protected
  Modelica.SIunits.SpecificEnthalpy dh "Change in enthalpy";

  MediumSte.Temperature TSte= MediumSte.temperature(
    state=MediumSte.setState_phX(
      p=port_a.p, h=inStream(port_a.h_outflow), X=inStream(port_a.Xi_outflow)));
  MediumWat.Temperature TWat= MediumWat.temperature(
    state=MediumWat.setState_phX(
      p=port_b.p, h=inStream(port_b.h_outflow), X=inStream(port_b.Xi_outflow)));

equation
  // State p & T remain unchanged (saturated vapor to saturated liquid)
  TSte = TWat;
  port_b.p = port_a.p;

  // Conservation of mass
  port_a.m_flow + port_b.m_flow = 0;

  // Enthalpy decreased with condensation process
  dh = MediumSte.enthalpyOfVaporization(MediumSte.setSat_p(port_a.p))
    "Enthalpy is changed by a factor of h_fg";
  port_b.h_outflow = port_a.h_outflow - dh;

  // Conservation of energy
  port_h.Q_flow = -port_a.m_flow * dh;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Polygon(
          points={{34,8},{58,32},{62,28},{38,4},{34,8}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Sphere,
          fillColor={95,95,95}),
        Polygon(
          points={{34,-8},{38,-4},{62,-28},{58,-32},{34,-8}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Sphere,
          fillColor={95,95,95}),
      Line(
        points={{-50,20},{-70,10},{-50,-10},{-70,-20}},
        color={0,0,0},
        smooth=Smooth.Bezier,
          extent={{-60,-22},{-36,2}}),
      Line(
        points={{-30,20},{-50,10},{-30,-10},{-50,-20}},
        color={0,0,0},
        smooth=Smooth.Bezier,
          extent={{-60,-22},{-36,2}}),
      Line(
        points={{-10,20},{-30,10},{-10,-10},{-30,-20}},
        color={0,0,0},
        smooth=Smooth.Bezier,
          extent={{-60,-22},{-36,2}}),
        Ellipse(
          extent={{50,40},{70,20}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={95,95,95}),
        Ellipse(
          extent={{10,20},{50,-20}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Sphere,
          fillColor={0,0,0}),
        Ellipse(
          extent={{50,-20},{70,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={95,95,95}),
        Rectangle(
          extent={{-80,-60},{80,60}},
          lineColor={28,108,200},
          lineThickness=0.5),
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
        Line(
          points={{-30,40},{30,40},{10,50}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{-30,-40},{30,-40},{10,-50}},
          color={28,108,200},
          thickness=0.5),        Text(
          extent={{-151,147},{149,107}},
          lineColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Condensation;
