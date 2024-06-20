within Buildings.DHC.Loads.HotWater;
model DirectHeatExchangerWithElectricHeat
  "A model for generating hot water using a district heat exchanger and supplemental electric resistance"
  extends
    Buildings.DHC.Loads.HotWater.BaseClasses.PartialFourPortDHW;
  parameter Modelica.Units.SI.Efficiency eps(min=0,max=1) = 0.8 "Heat exchanger effectiveness";
  parameter Boolean have_eleHea = true "True if has auxiliary electric heater";
  parameter Modelica.Units.SI.HeatFlowRate QMax_flow(min=0) = Modelica.Constants.inf "Maximum heat flow rate for electric heater (positive)"
  annotation(Dialog(enable=have_eleHea));
  parameter Modelica.Units.SI.MassFlowRate mDom_flow_nominal "Nominal flow rate of domestic hot water";
  parameter Modelica.Units.SI.MassFlowRate mHea_flow_nominal "Nominal flow rate of heating source water";
  Buildings.Fluid.HeatExchangers.Heater_T heaEle(
    redeclare package Medium = MediumDom,
    m_flow_nominal=mDom_flow_nominal,
    dp_nominal=dpEle_nominal,
    QMax_flow=QMax_flow) if have_eleHea == true
    "Supplemental electric resistance domestic hot water heater"
    annotation (Placement(transformation(extent={{10,-50},{30,-30}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemHot(redeclare package Medium =
        MediumDom,
                m_flow_nominal=mDom_flow_nominal)
    "Temperature sensor for hot water supply"
    annotation (Placement(transformation(extent={{58,50},{78,70}})));
  Buildings.Fluid.HeatExchangers.ConstantEffectiveness hex(
    redeclare package Medium1 = MediumDom,
    redeclare package Medium2 = MediumHea,
    m1_flow_nominal=mDom_flow_nominal,
    m2_flow_nominal=mHea_flow_nominal,
    dp1_nominal=dpDom_nominal,
    dp2_nominal=dpHea_nominal,
    eps=eps) "Domestic hot water heater heat exchanger"
    annotation (Placement(transformation(extent={{-60,-64},{-40,-44}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemHexOut(redeclare package Medium =
        MediumDom,
                m_flow_nominal=mDom_flow_nominal)
    "Temperature sensor for hot water leaving heat exchanger"
    annotation (Placement(transformation(extent={{-30,-50},{-10,-30}})));
  parameter Modelica.Units.SI.PressureDifference dpDom_nominal=0
    "Pressure difference in heat exchanger on domestic water side";
  parameter Modelica.Units.SI.PressureDifference dpHea_nominal=0
    "Pressure difference in heat exchanger on heating water side";
  parameter Modelica.Units.SI.PressureDifference dpEle_nominal=0
    "Pressure difference in electric reheater for domestic water";
  Modelica.Blocks.Interfaces.RealOutput THexOut
    "Temperature of hot water leaving heat exchanger"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
  Modelica.Blocks.Interfaces.RealOutput PEle(unit="W")
    "Electric power required for electric heater"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Sources.Constant zero(k=0) if have_eleHea == false "Zero power if no heater"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
protected
  Buildings.Fluid.FixedResistances.LosslessPipe pip(
    redeclare package Medium = MediumDom,
    final m_flow_nominal=mDom_flow_nominal,
    final show_T=false) if have_eleHea == false
    "Pipe without electric resistance"
    annotation (Placement(transformation(extent={{10,10},{30,-10}})));

equation
  connect(senTemHexOut.port_a, hex.port_b1)
    annotation (Line(points={{-30,-40},{-36,-40},{-36,-48},{-40,-48}},
                                               color={0,127,255}));
  connect(senTemHexOut.port_b, heaEle.port_a)
    annotation (Line(points={{-10,-40},{10,-40}},
                                              color={0,127,255}));
  connect(senTemHexOut.port_b, pip.port_a) annotation (Line(points={{-10,-40},{0,
          -40},{0,0},{10,0}}, color={0,127,255}));
  connect(heaEle.port_b, senTemHot.port_a)
    annotation (Line(points={{30,-40},{40,-40},{40,60},{58,60}},
                                             color={0,127,255}));
  connect(pip.port_b, senTemHot.port_a) annotation (Line(points={{30,0},{40,0},{
          40,60},{58,60}},color={0,127,255}));
  connect(TDomSet, heaEle.TSet) annotation (Line(points={{-110,0},{-12,0},{-12,
          -32},{8,-32}}, color={0,0,127}));
  connect(senTemHexOut.T, THexOut) annotation (Line(points={{-20,-29},{-20,-20},
          {110,-20}},                                     color={0,0,127}));
  connect(heaEle.Q_flow, PEle) annotation (Line(points={{31,-32},{60,-32},{60,0},
          {110,0}}, color={0,0,127}));
  connect(zero.y, PEle) annotation (Line(points={{81,20},{90,20},{90,0},{110,0}},
        color={0,0,127}));
  connect(port_aDom, hex.port_a1) annotation (Line(points={{-100,60},{-64,60},{-64,
          -48},{-60,-48}}, color={0,127,255}));
  connect(hex.port_a2, port_aHea) annotation (Line(points={{-40,-60},{-36,-60},{
          -36,-58},{90,-58},{90,-60},{100,-60}}, color={0,127,255}));
  connect(senTemHot.port_b, port_bDom)
    annotation (Line(points={{78,60},{100,60}}, color={0,127,255}));
  connect(hex.port_b2, port_bHea)
    annotation (Line(points={{-60,-60},{-100,-60}}, color={0,127,255}));
  annotation (preferredView="info",Documentation(info="<html>
<p>
This model implements a basic domestic hot water source for a
district heating network. It includes heating by the
district through a heat-exchanger and optional electric resistance to bring
the temperature of produced hot water to setpoint, if the district supply
water is not hot enough.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/DHC/Loads/HotWater/DirectHeatExchangerWithElectricHeat.png\"/>
</p>
<p>
It is based on Fig. 5 in <i>Evaluations of different domestic hot water
preparing methods with ultra-low-temperature district heating</i> by X. Yang,
H. Li, and S. Svendsen at <a href=\"https://doi.org/10.1016/j.energy.2016.04.109\">
doi.org/10.1016/j.energy.2016.04.109</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 11, 2023 by David Blum:<br/>
Update model for release.
</li>
<li>
June 16, 2022 by Dre Helmns:<br/>
Initial Implementation.
</li>
</ul>
</html>"),Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-102,62},{-72,58}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-72,30},{-68,62}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-72,34},{-20,30}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{28,62},{100,58}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{28,30},{32,62}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-104,-58},{-74,-62}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-74,-62},{-70,-30}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{26,-62},{30,-30}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{26,-58},{98,-62}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,34},{28,30}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,-30},{28,-34}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-72,-30},{-20,-34}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),Rectangle(
          extent={{-60,40},{20,-40}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),Rectangle(
          extent={{40,80},{80,40}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          visible=have_eleHea),           Text(
          extent={{-58,-8},{18,-36}},
          textColor={255,255,255},
          textString="eps=%eps")}),
        Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DirectHeatExchangerWithElectricHeat;
