within Buildings.Experimental.DHC.Loads.HotWater;
model DirectHeatExchangerWithAuxHeat
  "A model for generating hot water using a district heat exchanger and supplemental electric resistance"
  extends
    Buildings.Experimental.DHC.Loads.HotWater.BaseClasses.PartialFourPortDHW(
      final have_PEle=have_eleHea);
  parameter Modelica.Units.SI.Efficiency eps(min=0,max=1) = 0.8 "Heat exchanger effectiveness";
  parameter Boolean have_eleHea = true "True if has auxiliary electric heater";
  parameter Modelica.Units.SI.HeatFlowRate QMax_flow(min=0) = Modelica.Constants.inf "Maximum heat flow rate for electric heater (positive)"
  annotation(Dialog(enable=have_eleHea));

  Buildings.Fluid.HeatExchangers.Heater_T heaEle(
    redeclare package Medium = Medium,
    m_flow_nominal=mHotSou_flow_nominal,
    dp_nominal=dpEle_nominal,
    QMax_flow=QMax_flow)
    if have_eleHea == true "Supplemental electric resistance domestic hot water heater"
    annotation (Placement(transformation(extent={{10,16},{30,-4}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemHot(redeclare package Medium =
        Medium, m_flow_nominal=mHotSou_flow_nominal)
    "Temperature sensor for hot water supply"
    annotation (Placement(transformation(extent={{60,-4},{80,16}})));
  Fluid.HeatExchangers.ConstantEffectiveness hex(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    m1_flow_nominal=mHotSou_flow_nominal,
    m2_flow_nominal=mDis_flow_nominal,
    dp1_nominal=dpHotSou_nominal,
    dp2_nominal=dpDis_nominal,
    eps=eps) "Domestic hot water heater heat exchanger"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Fluid.Sensors.TemperatureTwoPort senTemHexOut(redeclare package Medium =
        Medium, m_flow_nominal=mHotSou_flow_nominal)
    "Temperature sensor for hot water leaving heat exchanger"
    annotation (Placement(transformation(extent={{-40,-4},{-20,16}})));
  parameter Modelica.Units.SI.PressureDifference dpHotSou_nominal=0
    "Pressure difference in heat exchanger on hot water side";
  parameter Modelica.Units.SI.PressureDifference dpDis_nominal=0
    "Pressure difference in heat exchanger on district water side";
  parameter Modelica.Units.SI.PressureDifference dpEle_nominal=0
    "Pressure difference in electric reheater for hot water";
  Modelica.Blocks.Interfaces.RealOutput THexOut
    "Temperature of hot water leaving heat exchanger"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
protected
  Fluid.FixedResistances.LosslessPipe pip(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mHotSou_flow_nominal,
    final show_T=false) if have_eleHea == false "Pipe without electric resistance"
    annotation (Placement(transformation(extent={{10,44},{30,24}})));

equation
  connect(senTemHexOut.port_a, hex.port_b1)
    annotation (Line(points={{-40,6},{-60,6}}, color={0,127,255}));
  connect(senTemHexOut.port_b, heaEle.port_a)
    annotation (Line(points={{-20,6},{10,6}}, color={0,127,255}));
  connect(senTemHexOut.port_b, pip.port_a) annotation (Line(points={{-20,6},{0,
          6},{0,34},{10,34}}, color={0,127,255}));
  connect(heaEle.port_b, senTemHot.port_a)
    annotation (Line(points={{30,6},{60,6}}, color={0,127,255}));
  connect(pip.port_b, senTemHot.port_a) annotation (Line(points={{30,34},{40,34},
          {40,6},{60,6}}, color={0,127,255}));
  connect(senTemHot.port_b, port_b1) annotation (Line(points={{80,6},{90,6},{90,
          60},{100,60}}, color={0,127,255}));
  connect(port_a1, hex.port_a1)
    annotation (Line(points={{-100,60},{-80,60},{-80,6}}, color={0,127,255}));
  connect(heaEle.Q_flow,PHea)  annotation (Line(points={{31,-2},{40,-2},{40,-20},
          {90,-20},{90,0},{110,0}}, color={0,0,127}));
  connect(TSetHotSou, heaEle.TSet) annotation (Line(points={{-110,0},{-90,0},{-90,
          -20},{0,-20},{0,-2},{8,-2}}, color={0,0,127}));
  connect(hex.port_b2, port_b2) annotation (Line(points={{-80,-6},{-80,-60},{-100,
          -60}}, color={0,127,255}));
  connect(port_a2, hex.port_a2) annotation (Line(points={{100,-60},{-60,-60},{-60,
          -6}}, color={0,127,255}));
  connect(senTemHexOut.T, THexOut) annotation (Line(points={{-30,17},{-30,18},{
          -12,18},{-12,-22},{96,-22},{96,-20},{110,-20}}, color={0,0,127}));
  annotation (preferredView="info",Documentation(info="<html>
<p>
This model implements a basic domestic hot water (DHW) substation for a  
low-temperature district heating network. It includes preheating by the
district through a heat-exchanger and optional electric resistance to bring 
the temperature of produced hot water to setpoint.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Experimental/DHC/Loads/HotWater/DirectHeatExchangerWithAuxHeat.png\"/>
</p>
<p>
It is based on Fig. 5 in <i>Evaluations of different domestic hot water 
preparing methods with ultra-low-temperature district heating</i> by X. Yang, 
H. Li, and S. Svendsen at <a href=https:/doi.org/10.1016/j.energy.2016.04.109> 
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
        fillPattern=FillPattern.Solid), Line(
          points={{-80,0},{-70,0},{-60,20},{-40,-20},{-20,20},{0,-20},{20,20},{
              40,-20},{60,20},{70,0},{80,0}},
          color={238,46,47},
          thickness=1)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DirectHeatExchangerWithAuxHeat;
