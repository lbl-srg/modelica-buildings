within Buildings.Fluid.HeatExchangers.BaseClasses;
model Condensation
  "Model for the condensation process without change in pressure"
  extends Buildings.Fluid.Interfaces.PartialTwoPortTwoMedium(
    final show_T = true);

  replaceable package Medium_a =
      IBPSA.Media.Interfaces.PartialPureSubstanceWithSat
    "Medium model (vapor state) for port_a (inlet)";
  replaceable package Medium_b =
      Modelica.Media.Interfaces.PartialMedium
    "Medium model (liquid state) for port_b (outlet)";

  Modelica.Blocks.Interfaces.RealOutput dh(unit="J/kg") "Change in enthalpy"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));

//protected
  parameter Modelica.SIunits.AbsolutePressure pSte_nominal
    "Nominal steam pressure";
  final parameter Modelica.SIunits.SpecificEnthalpy dhCon=
     Medium_a.enthalpyOfSaturatedVapor_sat(Medium_a.saturationState_p(pSte_nominal)) -
    Medium_a.enthalpyOfSaturatedLiquid_sat(Medium_a.saturationState_p(pSte_nominal))
    "Change in enthalpy";
  final parameter Modelica.SIunits.SpecificHeatCapacity cp=
     Medium_a.specificHeatCapacityCp(state=
    Medium_a.setState_pTX(p=pSte_nominal,T=TSat,X=Medium_a.X_default))
    "Specific Heat";
  final parameter Modelica.SIunits.Temperature TSat=
     Medium_a.saturationTemperature_p(pSte_nominal)
     "Saturation temperature";

  Medium_a.Temperature Ta;
  Medium_b.Temperature Tb;

  Modelica.SIunits.SpecificEnthalpy hSte_instream
    "Instreaming enthalpy at port_a";

equation
  // Temperature
  Ta= Medium_a.temperature(
    state=Medium_a.setState_phX(
      p=port_a.p, h=inStream(port_a.h_outflow), X=inStream(port_a.Xi_outflow)));
  Tb = TSat;

  // Enthalpy
  hSte_instream = inStream(port_a.h_outflow);
//    "Enthalpy change due to vaporization";
  port_b.h_outflow = inStream(port_a.h_outflow) + dh;
  // Set condition for reverse flow for model consistency
  port_a.h_outflow =  hSte_instream;

  // Change in enthalpy depending on incoming fluid (saturated or superheated)
  if (Ta > TSat) then
    dh = -dhCon - cp*(Ta - TSat);
  else
    dh = -dhCon;
  end if;

  // Steady state conservation of mass
  port_a.m_flow + port_b.m_flow = 0;

  // No change in pressure
  port_b.p = port_a.p;

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
