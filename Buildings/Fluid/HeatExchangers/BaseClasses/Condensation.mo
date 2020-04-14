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

  Modelica.Blocks.Interfaces.RealOutput dh(unit="J/kg") "Change in enthalpy"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));

//protected
  Modelica.SIunits.SpecificEnthalpy dhCon "Change in enthalpy";
  Modelica.SIunits.SpecificHeatCapacity cp "Specific Heat";
  Modelica.SIunits.Temperature TSat "Saturation temperature";

//  MediumSte.Temperature TSte= MediumSte.temperature(
//    state=MediumSte.setState_phX(
//      p=port_a.p, h=port_a.h_outflow, X=port_a.Xi_outflow));
  MediumSte.Temperature TSte;
//  MediumWat.Temperature TWat= MediumWat.temperature(
//    state=MediumWat.setState_phX(
//      p=port_b.p, h=port_b.h_outflow, X=port_b.Xi_outflow));
  MediumWat.Temperature TWat;

  Modelica.SIunits.SpecificEnthalpy hSte_instream
    "Instreaming enthalpy at port_a";

equation
  port_b.p = port_a.p;
  hSte_instream = inStream(port_a.h_outflow);

  TSte= MediumSte.temperature(
    state=MediumSte.setState_phX(
      p=port_a.p, h=inStream(port_a.h_outflow), X=inStream(port_a.Xi_outflow)));
//  TWat= MediumWat.temperature(
//    state=MediumWat.setState_phX(
//      p=port_b.p, h=port_b.h_outflow, X=port_b.Xi_outflow));
  TSat= MediumSte.saturationTemperature(port_a.p);
  cp = MediumSte.specificHeatCapacityCp(state=
    MediumSte.setState_pTX(p=port_a.p,T=TSat,X=inStream(port_a.Xi_outflow)));

  TWat = TSat;
  if (TSte > TSat) then
//    TWat = TSat;
    dh = -dhCon - cp*(TSte - TSat);
  else
//    TSte = TWat;
    dh = -dhCon;
  end if;

  // Steady state conservation of mass
  port_a.m_flow + port_b.m_flow = 0;

  // Enthalpy decreased with condensation process
  dhCon = MediumSte.enthalpyOfVaporization_sat(MediumSte.saturationState_p(port_a.p))
    "Enthalpy of vaporization";
//  dhCon = MediumSte.bubbleEnthalpy(setSat_p(port_a.p)) - MediumSte.dewEnthalpy(setSat_p(port_a.p))
  port_b.h_outflow = inStream(port_a.h_outflow) + dh;

  // Set condition for reverse flow for model consistency
  port_a.h_outflow =  hSte_instream;

  // Reverse flow
//  inStream(port_b.h_outflow) = port_a.h_outflow + dh;

//  inStream(port_b.h_outflow) = port_a.h_outflow + dh;
//  if port_a.m_flow > 0 then
//    port_b.h_outflow = inStream(port_a.h_outflow) - dh;
//    port_a.m_flow*inStream(port_a.h_outflow) +  port_b.m_flow*port_b.h_outflow +
//      port_h.Q_flow = 0;
//  else
//    port_a.h_outflow = inStream(port_b.h_outflow) + dh;
//    port_b.m_flow*inStream(port_b.h_outflow) +  port_a.m_flow*port_a.h_outflow +
//      port_h.Q_flow = 0;
//  end if;
//  port_b.h_outflow = inStream(port_a.h_outflow) - dh;
//  port_b.h_outflow = port_a.h_outflow - dhCon;
//  port_b.h_outflow - port_a.h_outflow = dh;

  // Steady state conservation of energy
//  port_a.m_flow*inStream(port_a.h_outflow) +  port_b.m_flow*port_b.h_outflow +
//    port_h.Q_flow = 0;
//  port_a.m_flow*port_a.h_outflow + port_b.m_flow*port_b.h_outflow + Q_flow = 0;

  // Reverse flow
//  port_a.h_outflow = inStream(port_b.h_outflow) + dh;
//  port_b.m_flow*inStream(port_b.h_outflow) +  port_a.m_flow*port_a.h_outflow +
//    port_h.Q_flow = 0;


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
          lineColor={28,108,200},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
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
