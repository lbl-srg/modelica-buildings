within Buildings.Experimental.DHC.Loads.HotWater;
model StorageTankWithExternalHeatExchanger
  "A model of a storage tank with external heat exchanger to produce hot water"
  extends
    Buildings.Experimental.DHC.Loads.HotWater.BaseClasses.PartialFourPortDHW(
    final allowFlowReversalHea=false);

  parameter Buildings.Experimental.DHC.Loads.HotWater.Data.GenericDomesticHotWaterWithHeatExchanger
    dat "Performance data"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));

  parameter Real k=0.1 "Proportional gain of circulation pump controller";
  parameter Real Ti=60 "Integrator time constant of circulation pump controller";

  parameter Modelica.Media.Interfaces.Types.Temperature TTan_start=323.15
    "Start value of tank temperature"
    annotation(Dialog(tab="Initialization"));
  final parameter Real eps =
    dat.QHex_flow_nominal / CMin_flow_nominal / ( dat.TDom_nominal + dat.dTHexApp_nominal - dat.TCol_nominal)
    "Heat exchanger effectiveness"
    annotation(Dialog(tab="Advanced"));
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

  Fluid.Storage.Stratified tan(
    redeclare package Medium = MediumHea,
    kIns=dat.kIns,
    final T_start=TTan_start,
    hTan=dat.hTan,
    dIns=dat.dIns,
    VTan=dat.VTan,
    nSeg=dat.nSeg,
    m_flow_nominal=dat.mHex_flow_nominal)
    "Heating water tank"
    annotation (Placement(transformation(extent={{30,-18},{10,2}})));
  Modelica.Blocks.Interfaces.RealOutput PEle(unit="W")
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
    show_T=true,
    dp1_nominal=dat.dpHexHea_nominal,
    from_dp2=true,
    dp2_nominal=dat.dpHexDom_nominal,
    eps=eps)
    annotation (Placement(transformation(extent={{-60,44},{-40,64}})));
  Fluid.FixedResistances.Junction junTop(
    redeclare package Medium = MediumHea,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=dat.mHex_flow_nominal*{1,1,1},
    dp_nominal=zeros(3)) "Flow junction at top of tank"
    annotation (Placement(transformation(extent={{10,20},{30,40}})));
  Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium = MediumDom)
    "Mass flow rate of domestic hot water"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TTanTop(
    T(displayUnit="degC"))
    "Fluid temperature at the top of the tank"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TTanBot(
    T(displayUnit="degC"))
    "Fluid temperature at the bottom of the tank"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));

  BaseClasses.HeatExchangerPumpController conPum(final mDom_flow_nominal=dat.mDom_flow_nominal,
      final dpPum_nominal=dat.dpHexHea_nominal)
    "Controller for pump of heat exchanger"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  BaseClasses.TankChargingController conCha "Controller for tank charge signal"
    annotation (Placement(transformation(extent={{72,-90},{92,-70}})));

  Fluid.Actuators.Valves.ThreeWayLinear divVal(
    redeclare package Medium = MediumHea,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    use_inputFilter=false,
    m_flow_nominal=dat.mHex_flow_nominal,
    dpValve_nominal=1000) "Diversion valve to reduce mixing in tank"
    annotation (Placement(transformation(extent={{30,-40},{10,-60}})));
  Fluid.Sensors.TemperatureTwoPort senTemRet(
    redeclare package Medium = MediumHea,
    final allowFlowReversal=allowFlowReversalDom,
    m_flow_nominal=dat.mHex_flow_nominal)
    "Temperature sensor for return heating water from heat exchanger"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  BaseClasses.TankValveController conVal "Diversion valve controller"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));

  Controls.OBC.CDL.Reals.AddParameter dTHexApp(p=dat.dTHexApp_nominal)
    "Offset for heat exchanger approach temperature"
    annotation (Placement(transformation(extent={{34,-84},{54,-64}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput charge
    "Output true if tank needs to be charged, false if it is sufficiently charged"
    annotation (Placement(transformation(extent={{100,-100},{140,-60}}),
        iconTransformation(extent={{100,-110},{140,-70}})));
protected
  parameter Modelica.Units.SI.SpecificHeatCapacity cpHea_default =
    MediumHea.specificHeatCapacityCp(MediumHea.setState_pTX(
      MediumHea.p_default,
      MediumHea.T_default,
      MediumHea.X_default))
    "Specific heat capacity of heating medium at default medium state";
  parameter Modelica.Units.SI.SpecificHeatCapacity cpDom_default =
    MediumDom.specificHeatCapacityCp(MediumDom.setState_pTX(
      MediumDom.p_default,
      MediumDom.T_default,
      MediumDom.X_default))
    "Specific heat capacity of domestic hot water medium at default medium state";
  parameter Modelica.Units.SI.ThermalConductance CMin_flow_nominal =
    min(dat.mHex_flow_nominal*cpHea_default, dat.mDom_flow_nominal*cpDom_default)
    "Minimum heat capacity flow rate";
initial equation
  assert(eps < 1, "In " + getInstanceName() + ": Heat exchanger effectivness must be below 1, received eps = " + String(eps) + ". Check sizing.");

equation
  connect(tan.port_a, junTop.port_3)
    annotation (Line(points={{20,2},{20,20}},
                                            color={0,127,255}));
  connect(pumHex.P, PEle) annotation (Line(points={{-49,-11},{-50,-11},{-50,-32},
          {86,-32},{86,0},{110,0}},     color={0,0,127}));
  connect(junTop.port_2, port_aHea) annotation (Line(points={{30,30},{84,30},{84,
          -60},{100,-60}},     color={0,127,255}));
  connect(hex.port_b1, senMasFlo.port_a)
    annotation (Line(points={{-40,60},{-20,60}}, color={0,127,255}));
  connect(senMasFlo.port_b, senTemHot.port_a)
    annotation (Line(points={{0,60},{20,60}},    color={0,127,255}));
  connect(TTanTop.port, tan.heaPorVol[1])
    annotation (Line(points={{40,10},{22,10},{22,-8},{20,-8}},
                                                color={191,0,0}));
  connect(senMasFlo.m_flow, conPum.mDom_flow) annotation (Line(points={{-10,71},
          {-10,74},{-86,74},{-86,6},{-82,6}}, color={0,0,127}));
  connect(senTemHot.T, conPum.TDom) annotation (Line(points={{30,71},{30,80},{-88,
          80},{-88,-6},{-81,-6}}, color={0,0,127}));
  connect(conPum.TDomSet, TDomSet) annotation (Line(points={{-81,0},{-92,0},{-92,
          0},{-110,0}}, color={0,0,127}));
  connect(conCha.TTanTop, TTanTop.T) annotation (Line(points={{70,-80},{66,-80},
          {66,10},{61,10}},   color={0,0,127}));
  connect(conCha.charge, charge) annotation (Line(points={{94,-80},{120,-80}},
                           color={255,0,255}));
  connect(senTemHot.port_b, port_bDom)
    annotation (Line(points={{40,60},{100,60}}, color={0,127,255}));
  connect(conPum.dpPumHex, pumHex.dp_in)
    annotation (Line(points={{-58,0},{-52,0}}, color={0,0,127}));

  connect(port_aDom, hex.port_a1)
    annotation (Line(points={{-100,60},{-60,60}}, color={0,127,255}));
  connect(junTop.port_1, hex.port_a2) annotation (Line(points={{10,30},{-30,30},
          {-30,48},{-40,48}}, color={0,127,255}));
  connect(hex.port_b2, pumHex.port_a) annotation (Line(points={{-60,48},{-72,48},
          {-72,20},{-40,20},{-40,10}}, color={0,127,255}));
  connect(senTemRet.port_b, divVal.port_2)
    annotation (Line(points={{0,-50},{10,-50}}, color={0,127,255}));
  connect(divVal.port_1, tan.fluPorVol[integer(dat.nSeg/2)]) annotation (Line(
        points={{30,-50},{34,-50},{34,-8},{25,-8}}, color={0,127,255}));
  connect(senTemRet.T, conVal.TRet) annotation (Line(points={{-10,-39},{-10,-36},
          {-26,-36},{-26,-80},{-21,-80}}, color={0,0,127}));
  connect(conVal.y, divVal.y)
    annotation (Line(points={{2,-80},{20,-80},{20,-62}}, color={0,0,127}));
  connect(TTanBot.port, tan.heaPorVol[dat.nSeg]) annotation (Line(points={{40,-20},
          {22,-20},{22,-8},{20,-8}}, color={191,0,0}));
  connect(conCha.TTanTopSet, dTHexApp.y)
    annotation (Line(points={{71,-72},{64,-72},{64,-74},{56,-74}},
                                                 color={0,0,127}));
  connect(dTHexApp.u, TDomSet) annotation (Line(points={{32,-74},{26,-74},{26,
          -96},{-90,-96},{-90,0},{-110,0}}, color={0,0,127}));
  connect(divVal.port_3, tan.fluPorVol[dat.nSeg]) annotation (Line(points={{20,-40},
          {20,-36},{32,-36},{32,-8},{25,-8}}, color={0,127,255}));
  connect(tan.port_b, port_bHea) annotation (Line(points={{20,-18},{20,-26},{-80,
          -26},{-80,-60},{-100,-60}}, color={0,127,255}));
  connect(pumHex.port_b, senTemRet.port_a) annotation (Line(points={{-40,-10},{-40,
          -50},{-20,-50}}, color={0,127,255}));
  connect(TTanBot.T, conCha.TTanBot) annotation (Line(points={{61,-20},{62,-20},
          {62,-88},{70,-88}}, color={0,0,127}));
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
          extent={{60,40},{0,-78}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Rectangle(
          extent={{-30,40},{-50,0}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Rectangle(
          extent={{-100,64},{-60,58}},
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-44,64},{100,58}},
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-60,-10},{-44,-16}},
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-40,2},{40,-2}},
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={-60,24},
          rotation=90),
        Rectangle(
          extent={{-6,2},{6,-2}},
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={-46,-6},
          rotation=90),
        Rectangle(
          extent={{76,-58},{98,-62}},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-58,2},{58,-2}},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={22,50},
          rotation=180),
        Rectangle(
          extent={{-56.5,2.5},{56.5,-2.5}},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={77.5,-4.5},
          rotation=270),
        Rectangle(
          extent={{-6,2},{6,-2}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={-6,-60},
          rotation=180),
        Rectangle(
          extent={{-6,2},{6,-2}},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={32,46},
          rotation=270),
        Rectangle(
          extent={{-6,2},{6,-2}},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={-34,46},
          rotation=270),
        Rectangle(
          extent={{-15,2},{15,-2}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={-85,-60},
          rotation=180),
        Rectangle(
          extent={{-6,2},{6,-2}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={-26,-44},
          rotation=360),
        Rectangle(
          extent={{-23,2},{23,-2}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={-34,-23},
          rotation=270),
        Rectangle(
          extent={{-12,2},{12,-2}},
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={-44,52},
          rotation=90),
        Text(
          extent={{-116,36},{-66,0}},
          textColor={0,0,127},
          textString="TDomSet"),
        Text(
          extent={{-100,140},{100,100}},
          textString="%name",
          textColor={0,0,255}),
        Rectangle(
          extent={{-5,2},{5,-2}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={-10,-55},
          rotation=270),
        Rectangle(
          extent={{-6,2},{6,-2}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={-6,-12},
          rotation=180),
        Polygon(
          points={{-13,-3},{-5,3},{-5,-9},{-13,-3}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={-7,-57},
          rotation=270),
        Polygon(
          points={{-15,-3},{-7,3},{-7,-9},{-15,-3}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={-13,-29},
          rotation=90),
        Polygon(
          points={{-15,-3},{-5,3},{-5,-9},{-15,-3}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={-25,-47},
          rotation=180),
        Rectangle(
          extent={{-12,2},{12,-2}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={-10,-24},
          rotation=270),
        Ellipse(
          extent={{-42,-20},{-26,-34}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-15,-3},{-7,5},{-7,-11},{-15,-3}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={-37,-19},
          rotation=90),
        Text(
         extent={{72,42},{-14,12}},
          textColor={0,0,0},
          textString=DynamicSelect("", String(TTanTop.T-273.15, format=".1f"))),
        Text(
         extent={{74,-46},{-12,-76}},
          textColor={0,0,0},
          textString=DynamicSelect("", String(TTanBot.T-273.15, format=".1f"))),
        Ellipse(
          extent={{81,-83},{95,-97}},
          lineColor=DynamicSelect({235,235,235},
            if charge then
              {0,255,0}
            else
              {235,235,235}),
          fillColor=DynamicSelect({235,235,235},
            if charge then
              {0,255,0}
            else
              {235,235,235}),
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-16,2},{16,-2}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={-72,-76},
          rotation=270),
        Rectangle(
          extent={{-54,2},{54,-2}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={-20,-90},
          rotation=180),
        Rectangle(
          extent={{-7,2},{7,-2}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={32,-85},
          rotation=270)}),
        Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end StorageTankWithExternalHeatExchanger;
