within Buildings.Fluid.Boilers.BaseClasses;
model Evaporation
  "Model for the evaporation process without change in pressure"
  extends Buildings.Fluid.Interfaces.PartialTwoPortTwoMedium;

  replaceable package Medium_a =
      Modelica.Media.Interfaces.PartialMedium
    "Medium model (liquid state) for port_a (inlet)";
  replaceable package Medium_b =
      IBPSA.Media.Interfaces.PartialPureSubstanceWithSat
    "Medium model (vapor state) for port_b (outlet)";

  Modelica.Blocks.Interfaces.RealOutput dh(unit="J/kg") "Change in enthalpy"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));

//protected
  parameter Modelica.SIunits.AbsolutePressure pSte_nominal
    "Nominal steam pressure";
  final parameter Modelica.SIunits.SpecificEnthalpy dhVap=
     Medium_b.enthalpyOfSaturatedVapor_sat(Medium_b.saturationState_p(pSte_nominal)) -
    Medium_b.enthalpyOfSaturatedLiquid_sat(Medium_b.saturationState_p(pSte_nominal))
    "Change in enthalpy";
  final parameter Modelica.SIunits.SpecificHeatCapacity cp=
     Medium_a.specificHeatCapacityCp(state=
    Medium_a.setState_pTX(p=pSte_nominal,T=TSat,X=Medium_a.X_default))
    "Specific Heat";
  final parameter Modelica.SIunits.Temperature TSat=
     Medium_b.saturationTemperature_p(pSte_nominal)
     "Saturation temperature";

  Medium_b.Temperature Tb;
  Medium_a.Temperature Ta;

  Modelica.SIunits.SpecificEnthalpy hWat_instream
    "Instreaming enthalpy at port_a";

equation
  port_b.p = port_a.p;

  hWat_instream = inStream(port_a.h_outflow);

  Ta= Medium_a.temperature(
    state=Medium_a.setState_phX(
      p=port_a.p, h=inStream(port_a.h_outflow), X=inStream(port_a.Xi_outflow)));

  Tb = TSat;
  if (Ta < TSat) then
    dh = dhVap + cp*(TSat - Ta);
  else
    dh = dhVap;
  end if;

  // Steady state conservation of mass
  port_a.m_flow + port_b.m_flow = 0;

  // Enthalpy decreased with boiling process
  port_b.h_outflow = inStream(port_a.h_outflow) + dh;

  // Set condition for reverse flow for model consistency
  port_a.h_outflow =  Medium_a.h_default;

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
end Evaporation;
