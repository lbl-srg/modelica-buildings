within Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery;
model WheelWithVariableSpeed
  "Sensible and latent air-to-air heat recovery wheel with a variable speed drive"
  replaceable package Medium1 =
    Modelica.Media.Interfaces.PartialCondensingGases
    "Supply air";
  replaceable package Medium2 =
    Modelica.Media.Interfaces.PartialCondensingGases
    "Exhaust air";
  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal
    "Nominal supply air mass flow rate";
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal
    "Nominal exhaust air mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dp1_nominal = 125
    "Nominal supply air pressure drop";
  parameter Modelica.Units.SI.PressureDifference dp2_nominal = 125
    "Nominal exhaust air pressure drop";
  parameter Real P_nominal(final unit="W")
    "Power consumption at design condition";
  parameter Modelica.Units.SI.Efficiency epsSenCoo_nominal(
    final max=1) = 0.8
    "Nominal sensible heat exchanger effectiveness at the cooling mode";
  parameter Modelica.Units.SI.Efficiency epsLatCoo_nominal(
    final max=1) = 0.8
    "Nominal latent heat exchanger effectiveness at the cooling mode";
  parameter Modelica.Units.SI.Efficiency epsSenCooPL(
    final max=1) = 0.75
    "Part load (75%) sensible heat exchanger effectiveness at the cooling mode";
  parameter Modelica.Units.SI.Efficiency epsLatCooPL(
    final max=1) = 0.75
    "Part load (75%) latent heat exchanger effectiveness at the cooling mode";
  parameter Modelica.Units.SI.Efficiency epsSenHea_nominal(
    final max=1) = 0.8
    "Nominal sensible heat exchanger effectiveness at the heating mode";
  parameter Modelica.Units.SI.Efficiency epsLatHea_nominal(
    final max=1) = 0.8
    "Nominal latent heat exchanger effectiveness at the heating mode";
  parameter Modelica.Units.SI.Efficiency epsSenHeaPL(
    final max=1) = 0.75
    "Part load (75%) sensible heat exchanger effectiveness at the heating mode";
  parameter Modelica.Units.SI.Efficiency epsLatHeaPL(
    final max=1) = 0.75
    "Part load (75%) latent heat exchanger effectiveness at the heating mode";
  parameter Real a[:] = {1}
    "Coefficients for power efficiency curve (need p(a=a, uSpe=1)=1)"
    annotation (Dialog(group="Efficiency"));

  Modelica.Blocks.Interfaces.RealInput uSpe(
    final unit="1",
    final max=1)
    "Wheel speed ratio"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput P
    "Electric power consumed by the wheel"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.BaseClasses.HeatExchangerWithInputEffectiveness
    hex(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final show_T=true,
    final dp1_nominal=dp1_nominal,
    final dp2_nominal=dp2_nominal)
    "Heat exchanger"
    annotation (Placement(transformation(extent={{6,-10},{26,10}})));
  Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.BaseClasses.Effectiveness
    effCal(
    final epsSenCoo_nominal=epsSenCoo_nominal,
    final epsLatCoo_nominal=epsLatCoo_nominal,
    final epsSenCooPL=epsSenCooPL,
    final epsLatCooPL=epsLatCooPL,
    final epsSenHea_nominal=epsSenHea_nominal,
    final epsLatHea_nominal=epsLatHea_nominal,
    final epsSenHeaPL=epsSenHeaPL,
    final epsLatHeaPL=epsLatHeaPL,
    final VSup_flow_nominal=m1_flow_nominal/1.293)
    "Calculate the effectiveness of heat exchange"
    annotation (Placement(transformation(extent={{-42,-10},{-22,10}})));
  Modelica.Blocks.Sources.RealExpression TSup(
    final y=Medium1.temperature(
      Medium1.setState_phX(
        p=port_a1.p,
        h=inStream(port_a1.h_outflow),
        X=inStream(port_a1.Xi_outflow))))
    "Supply air temperature"
    annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));
  Modelica.Blocks.Sources.RealExpression TExh(
    final y=Medium2.temperature(
      Medium2.setState_phX(
        p=port_a2.p,
        h=inStream(port_a2.h_outflow),
        X=inStream(port_a2.Xi_outflow))))
    "Exhaust air temperature"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Modelica.Blocks.Sources.RealExpression PEle(
    final y=P_nominal*Buildings.Utilities.Math.Functions.polynomial(a=a, x=uSpe))
    "Electric power consumption"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a1(
    redeclare final package Medium = Medium1)
    "Fluid connector a1 of the supply air (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-112,50},{-92,70}}),
        iconTransformation(extent={{-110,50},{-90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(
    redeclare final package Medium = Medium2)
    "Fluid connector b2 of the exhaust air (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{-90,-70},{-110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(
    redeclare final package Medium = Medium1)
    "Fluid connector b1 of the supply air (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{110,50},{90,70}}),
        iconTransformation(extent={{110,50},{90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a2(
    redeclare final package Medium = Medium2)
    "Fluid connector a2 of the exhaust air (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Modelica.Blocks.Sources.RealExpression VSup_flow(
    final y=port_a1.m_flow/
        Medium1.density(state=Medium1.setState_phX(
        p=port_a1.p,
        h=port_a1.h_outflow,
        X=port_a1.Xi_outflow)))
    "Supply air volume flow rate"
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));
  Modelica.Blocks.Sources.RealExpression VExh_flow(
    final y=port_a2.m_flow/
        Medium2.density(state=Medium2.setState_phX(
        p=port_a2.p,
        h=port_a2.h_outflow,
        X=port_a2.Xi_outflow)))
    "Exhaust air volume flow rate"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));

initial equation
  assert(noEvent(abs(Buildings.Utilities.Math.Functions.polynomial(
         a=a, x=uSpe)-1) < 0.01),
         "*** Warning in " + getInstanceName() + ": Power efficiency curve is wrong. 
         Power consumption should equal to the nominal value when uSpe = 1.",
         level=AssertionLevel.warning);

equation
  connect(hex.port_b1, port_b1)
    annotation (Line(points={{26,6},{40,6},{40,60},{100,60}},
        color={0,127,255}));
  connect(hex.port_b2, port_b2)
    annotation (Line(points={{6,-6},{0,-6},{0,-60},{-100,-60}},
        color={0,127,255}));
  connect(PEle.y, P)
    annotation (Line(points={{91,0},{110,0}}, color={0,0,127}));
  connect(effCal.epsSen, hex.epsSen)
    annotation (Line(points={{-21,4},{4,4}},                 color={0,0,127}));
  connect(effCal.epsLat, hex.epsLat)
    annotation (Line(points={{-21,-4},{4,-4}},
        color={0,0,127}));
  connect(effCal.uSpe, uSpe)
    annotation (Line(points={{-44,0},{-120,0}},
        color={0,0,127}));
  connect(TSup.y, effCal.TSup)
    annotation (Line(points={{-69,-20},{-50,-20},{-50,-4},{-44,-4}},
        color={0,0,127}));
  connect(TExh.y, effCal.TExh)
    annotation (Line(points={{-69,-40},{-44,-40},{-44,-8}},
        color={0,0,127}));
  connect(hex.port_a1, port_a1)
    annotation (Line(points={{6,6},{0,6},{0,60},{-102,60}}, color={0,0,127}));
  connect(hex.port_a2, port_a2)
    annotation (Line(points={{26,-6},{40,-6},{40,-60},
          {100,-60}}, color={0,127,255}));
  connect(VSup_flow.y, effCal.VSup_flow)
    annotation (Line(points={{-69,40},{-50,
          40},{-50,8},{-44,8}}, color={0,0,127}));
  connect(VExh_flow.y, effCal.VExh_flow)
    annotation (Line(points={{-69,20},{-58,
          20},{-58,4},{-44,4}}, color={0,0,127}));
annotation (
        defaultComponentName="whe",
        Icon(coordinateSystem(extent={{-100,-100},{100,
            100}}), graphics={
        Rectangle(
          extent={{32,-56},{94,-64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{32,64},{94,56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-92,-55},{-32,-64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-94,65},{-32,56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{6,88},{38,-90}},   lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,100},{0,100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.None),
        Rectangle(
          extent={{-2,88},{22,-98}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-38,88},{-4,-90}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Line(points={{-22,-90},{22,-90}},   color={28,108,200}),
        Line(points={{-20,88},{22,88}},   color={28,108,200}),
        Text(
          extent={{-149,-108},{151,-148}},
          textColor={0,0,255},
          textString="%name")}),
          Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
Documentation(info="<html>
<p>
Model of a generic, sensible and latent air-to-air heat recovery wheel, which has the 
wheel speed as the input to control the heat recovery.
</p>
<p>
This model does not require geometric data. The performance is defined by specifying the 
part load (75%) and nominal sensible and latent effectiveness in both heating and cooling conditions.
</p>
<p>
The operation of the heat recovery wheel is adjustable by modulating the wheel speed.
</p>
<p>
Accordingly, the power consumption of this wheel is calculated by
</p>
<p align=\"center\" style=\"font-style:italic;\">
  P = P<sub>nominal</sub>(a<sub>1</sub> + a<sub>2</sub> uSpe + a<sub>3</sub> uSpe<sup>2</sup> + ...),
</p>
<p>
where <i>p<sub>nominal</sub></i> is the nominal wheel power consumption,
<i>uSpe</i> is the wheel speed ratio, 
and the coefficients <i>a<sub>i</sub></i>
are declared by the parameter <code>a</code>.
</p>
<p>
The sensible and latent effectiveness is calculated with <a href=\"modelica://Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.BaseClasses.Effectiveness\">
Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.BaseClasses.Effectiveness</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 29, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end WheelWithVariableSpeed;
