within Buildings.Experimental.DHC.Loads.HotWater;
model StorageTankWithExternalHeatExchanger
  "A model of a storage tank with external heat exchanger to produce hot water"
  extends Buildings.Experimental.DHC.Loads.HotWater.BaseClasses.PartialFourPortDHW(
    final allowFlowReversalHea=false);

  parameter Buildings.Experimental.DHC.Loads.HotWater.Data.GenericDomesticHotWaterWithHeatExchanger
    dat "Performance data"
    annotation (Placement(transformation(extent={{-90,-96},{-70,-76}})));

  parameter Real k=0.1 "Proportioanl gain of circulation pump controller";
  parameter Real Ti=60 "Integrator time constant of circulation pump controller";

  Fluid.Movers.Preconfigured.FlowControlled_dp pumHex(
    redeclare package Medium = MediumHea,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    use_inputFilter=false,
    riseTime=10,
    m_flow_nominal=dat.mHex_flow_nominal,
    dp_nominal=dat.dpHexHea_nominal) "Pump with head as input" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-40,0})));

  Fluid.Storage.StratifiedEnhanced tan(
    redeclare package Medium = MediumHea,
    kIns=dat.kIns,
    final T_start=TTan_start,
    hTan=dat.hTan,
    dIns=dat.dIns,
    VTan=dat.VTan,
    nSeg=dat.nSeg,
    m_flow_nominal=dat.mHex_flow_nominal)
    "Tank with steady-state heat exchanger balance"
    annotation (Placement(transformation(extent={{10,-20},{-10,0}})));
  Modelica.Blocks.Interfaces.RealOutput PPum(unit="W")
    "Electric power required for pumping equipment"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
  Fluid.Sensors.TemperatureTwoPort senTemHot(
    redeclare package Medium =  MediumDom,
    final allowFlowReversal=allowFlowReversalDom,
    m_flow_nominal=dat.mDom_flow_nominal)
    "Temperature sensor for hot water supply"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));

  Fluid.HeatExchangers.ConstantEffectiveness hex(
    redeclare package Medium1 = MediumDom,
    redeclare package Medium2 = MediumHea,
    final allowFlowReversal1=allowFlowReversalDom,
    m1_flow_nominal=dat.mDom_flow_nominal,
    m2_flow_nominal=dat.mHex_flow_nominal,
    dp1_nominal=dat.dpHexHea_nominal,
    from_dp2=true,
    dp2_nominal=dat.dpHexDom_nominal)
    annotation (Placement(transformation(extent={{-70,44},{-50,64}})));
  Fluid.FixedResistances.Junction junTop(
    redeclare package Medium = MediumHea,
    m_flow_nominal=dat.mHex_flow_nominal*{1,1,1},
    dp_nominal=zeros(3)) "Flow junction at top of tank"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  Fluid.FixedResistances.Junction junBot(
    redeclare package Medium = MediumHea,
    m_flow_nominal=dat.mHex_flow_nominal*{1,1,1},
    dp_nominal=zeros(3)) "Flow junction at bottom of tank" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={0,-60})));
  Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium = MediumDom)
    "Mass flow rate of domestic hot water"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TTanTop
    "Fluid temperature at the top of the tank"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput charge
    "Output true if tank needs to be charged, false if it is sufficiently charged"
    annotation (Placement(transformation(extent={{100,-100},{140,-60}}),
        iconTransformation(extent={{100,-110},{140,-70}})));
  BaseClasses.HeatExchangerPumpController conPum(final mDom_flow_nominal=dat.mDom_flow_nominal,
      final dpPum_nominal=dat.dpHexHea_nominal)
    "Controller for pump of heat exchanger"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  BaseClasses.TankChargingController conCha "Controller for tank charge signal"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  parameter Modelica.Media.Interfaces.Types.Temperature TTan_start=323.15
    "Start value of tank temperature";
equation
  connect(tan.port_a, junTop.port_3)
    annotation (Line(points={{0,0},{0,10}}, color={0,127,255}));
  connect(junTop.port_1, hex.port_b2) annotation (Line(points={{-10,20},{-76,20},
          {-76,48},{-70,48}}, color={0,127,255}));
  connect(pumHex.port_b, junBot.port_2)
    annotation (Line(points={{-40,-10},{-40,-60},{-10,-60}},
                                                   color={0,127,255}));
  connect(pumHex.port_a, hex.port_a2) annotation (Line(points={{-40,10},{-40,48},
          {-50,48}},                                 color={0,127,255}));
  connect(junBot.port_3, tan.port_b) annotation (Line(points={{1.77636e-15,-50},
          {1.77636e-15,-40},{0,-40},{0,-20}}, color={0,127,255}));
  connect(pumHex.P, PPum) annotation (Line(points={{-49,-11},{-48,-11},{-48,-70},
          {88,-70},{88,0},{110,0}},     color={0,0,127}));
  connect(junTop.port_2, port_aHea) annotation (Line(points={{10,20},{84,20},
          {84,-60},{100,-60}}, color={0,127,255}));
  connect(junBot.port_1, port_bHea) annotation (Line(points={{10,-60},{20,
          -60},{20,-80},{-62,-80},{-62,-60},{-100,-60}},
                                                   color={0,127,255}));
  connect(hex.port_b1, senMasFlo.port_a)
    annotation (Line(points={{-50,60},{-20,60}}, color={0,127,255}));
  connect(senMasFlo.port_b, senTemHot.port_a)
    annotation (Line(points={{0,60},{20,60}},    color={0,127,255}));
  connect(TTanTop.port, tan.heaPorVol[1])
    annotation (Line(points={{20,-10},{0,-10}}, color={191,0,0}));
  connect(senMasFlo.m_flow, conPum.mDom_flow) annotation (Line(points={{-10,71},
          {-10,74},{-86,74},{-86,6},{-82,6}}, color={0,0,127}));
  connect(senTemHot.T, conPum.TDom) annotation (Line(points={{30,71},{30,80},{-88,
          80},{-88,-6},{-81,-6}}, color={0,0,127}));
  connect(conPum.TDomSet, TDomSet) annotation (Line(points={{-81,0},{-92,0},{-92,
          0},{-110,0}}, color={0,0,127}));
  connect(conCha.TTanTopSet, TDomSet) annotation (Line(points={{59,-34},{-92,-34},
          {-92,0},{-110,0}}, color={0,0,127}));
  connect(conCha.TTanTop, TTanTop.T) annotation (Line(points={{58,-46},{46,-46},
          {46,-10},{41,-10}}, color={0,0,127}));
  connect(conCha.charge, charge) annotation (Line(points={{82,-40},{86,-40},{86,
          -80},{120,-80}}, color={255,0,255}));
  connect(senTemHot.port_b, port_bDom)
    annotation (Line(points={{40,60},{100,60}}, color={0,127,255}));
  connect(conPum.dpPumHex, pumHex.dp_in)
    annotation (Line(points={{-58,0},{-52,0}}, color={0,0,127}));

  connect(port_aDom, hex.port_a1)
    annotation (Line(points={{-100,60},{-70,60}}, color={0,127,255}));
  annotation (
  defaultComponentName="domHotWatTan",
  Documentation(info="<html>
<p>
This model implements a heating hot water tank with external heat exchanger that heats domestic hot water.
</p>
<p>
The storage tank model is described in 
<a href=\"modelica://Buildings.Fluid.Storage.StratifiedEnhancedInternalHex\">
Buildings.Fluid.Storage.StratifiedEnhancedInternalHex</a>.
The heat pump and storage tank system should be parameterized altogether using
<a href=\"modelica://Buildings.Experimental.DHC.Loads.HotWater.Data.GenericDomesticHotWaterWithHeatExchanger\">
Buildings.Experimental.DHC.Loads.HotWater.Data.GenericDomesticHotWaterWithHeatExchanger</a>.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Experimental/DHC/Loads/HotWater/StorageTankWithExternalHeatExchanger.png\"/>
</p>
<p>
It is based on Fig. 3 in <i>Evaluations of different domestic hot water 
preparing methods with ultra-low-temperature district heating</i> by X. Yang, 
H. Li, and S. Svendsen at <a href=\"https:/doi.org/10.1016/j.energy.2016.04.109\"> 
doi.org/10.1016/j.energy.2016.04.109</a>, as well as the
<i>Advanced Energy Design Guide for Multifamily Buildings-Achieving Zero Energy</i>
published by ASHRAE in 2022 at <a href=\"https://www.ashrae.org/technical-resources/aedgs/zero-energy-aedg-free-download\">
https://www.ashrae.org/technical-resources/aedgs/zero-energy-aedg-free-download</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 5, 2023, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Polygon(
          points={{-140,86},{-140,86}},
          lineColor={95,95,95},
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.CrossDiag),
        Rectangle(
          extent={{60,40},{0,-60}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Rectangle(
          extent={{-20,20},{-40,-20}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Rectangle(
          extent={{-100,64},{-60,58}},
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-34,64},{100,58}},
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-60,-26},{-36,-32}},
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-48,2},{48,-2}},
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={-60,16},
          rotation=90),
        Rectangle(
          extent={{-6,2},{6,-2}},
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={-36,-26},
          rotation=90),
        Rectangle(
          extent={{76,-58},{98,-62}},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-53,2},{53,-2}},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={27,50},
          rotation=180),
        Rectangle(
          extent={{-56.5,2.5},{56.5,-2.5}},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={77.5,-4.5},
          rotation=270),
        Rectangle(
          extent={{-46,2},{46,-2}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={-14,-72},
          rotation=180),
        Rectangle(
          extent={{-6,2},{6,-2}},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={32,46},
          rotation=270),
        Rectangle(
          extent={{-16,2},{16,-2}},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={-24,36},
          rotation=270),
        Rectangle(
          extent={{-20,2},{20,-2}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={-80,-60},
          rotation=180),
        Rectangle(
          extent={{-7,2},{7,-2}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={32,-67},
          rotation=270),
        Rectangle(
          extent={{-8,2},{8,-2}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={-60,-66},
          rotation=270),
        Rectangle(
          extent={{-25,2},{25,-2}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={-24,-45},
          rotation=270),
        Rectangle(
          extent={{-22,2},{22,-2}},
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={-36,42},
          rotation=90),
        Text(
          extent={{-116,36},{-66,0}},
          textColor={0,0,127},
          textString="TDomSet"),
        Text(
          extent={{-100,140},{100,100}},
          textString="%name",
          textColor={0,0,255})}),                                Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end StorageTankWithExternalHeatExchanger;
