within Buildings.Experimental.DistrictHeatingCooling.Plants;
model HeatingCoolingCarnot_T
  "Ideal heating and cooling plant with leaving temperature as set point and vapor compression engines that are approximated by Carnot cycles"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    final m_flow(start=0),
    final allowFlowReversal = true,
    final dp(start=0));

  parameter Modelica.SIunits.TemperatureDifference dTEva_nominal=-10
    "Temperature difference evaporator outlet-inlet of heat pump";
  parameter Modelica.SIunits.TemperatureDifference dTCon_nominal=10
    "Temperature difference condenser outlet-inlet of chiller";

  parameter Modelica.SIunits.Pressure dp_nominal(displayUnit="Pa")=30000
    "Pressure difference at nominal flow rate"
    annotation(Dialog(group="Design parameter"));

  parameter Boolean linearizeFlowResistance=false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(tab="Advanced"));

  Modelica.Blocks.Interfaces.RealInput TSetHea(unit="K")
    "Temperature set point for heating"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput TSetCoo(unit="K")
    "Temperature set point for cooling"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput TSink(unit="K")
    "Temperature of heat sink"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));

  Modelica.Blocks.Interfaces.RealOutput PComHea(unit="W")
    "Compressor energy for heating"
    annotation (Placement(transformation(extent={{100,80},{120,100}})));
  Modelica.Blocks.Interfaces.RealOutput PComCoo(unit="W")
    "Compressor energy for cooling"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));

  Modelica.Blocks.Interfaces.RealOutput QHea_flow(unit="W")
    "Heat input into fluid"
    annotation (Placement(transformation(extent={{100,40},{120,60}})));

  Modelica.Blocks.Interfaces.RealOutput QCoo_flow(unit="W")
    "Heat extracted from fluid"
    annotation (Placement(transformation(extent={{100,20},{120,40}})));
protected
  replaceable package MediumSin =
      Buildings.Media.Air "Medium model for the heat sink"
      annotation (choicesAllMatching = true);

  parameter Modelica.SIunits.TemperatureDifference dTSin = 2
    "Temperature difference over heat source or sink";

  final parameter Medium.ThermodynamicState staSin_default = Medium.setState_pTX(
    T=MediumSin.T_default,
    p=MediumSin.p_default,
    X=MediumSin.X_default[1:MediumSin.nXi])
    "Medium state at default properties";
  final parameter Modelica.SIunits.SpecificHeatCapacity cpSin_default=
    Medium.specificHeatCapacityCp(staSin_default)
    "Specific heat capacity of the fluid";

  final parameter Medium.ThermodynamicState sta_default = Medium.setState_pTX(
    T=Medium.T_default,
    p=Medium.p_default,
    X=Medium.X_default[1:Medium.nXi]) "Medium state at default properties";
  final parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
    Medium.specificHeatCapacityCp(sta_default)
    "Specific heat capacity of the fluid";

  Fluid.Chillers.Carnot_TEva coo(
    show_T=true,
    redeclare package Medium1 = MediumSin,
    redeclare package Medium2 = Medium,
    m2_flow_nominal=m_flow_nominal,
    QEva_flow_nominal=m_flow_nominal*cp_default*dTEva_nominal,
    use_eta_Carnot_nominal=true,
    etaCarnot_nominal=0.3,
    dp1_nominal=6000,
    dp2_nominal=0,
    dTEva_nominal=-dTSin,
    dTCon_nominal=dTCon_nominal,
    energyDynamics1=Modelica.Fluid.Types.Dynamics.FixedInitial,
    energyDynamics2=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal1=false) "Chiller"
    annotation (Placement(transformation(extent={{38,-10},{58,10}})));

  Fluid.HeatPumps.Carnot_TCon hea(
    show_T=true,
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = MediumSin,
    m1_flow_nominal=m_flow_nominal,
    QCon_flow_nominal=m_flow_nominal*cp_default*dTCon_nominal,
    dp1_nominal=6000,
    dp2_nominal=6000,
    use_eta_Carnot_nominal=true,
    etaCarnot_nominal=0.3,
    dTEva_nominal=dTEva_nominal,
    dTCon_nominal=dTSin,
    energyDynamics1=Modelica.Fluid.Types.Dynamics.FixedInitial,
    energyDynamics2=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal2=false) "Heat pump for heating"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));

  Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    tau=0) "Temperature sensor"
    annotation (Placement(transformation(extent={{-6,-6},{6,6}})));

  Fluid.Sources.FixedBoundary sinHea(nPorts=1, redeclare package Medium =
        MediumSin) "Pressure source" annotation (Placement(transformation(
          extent={{-10,10},{10,-10}}, origin={-70,-20})));
  Fluid.Sources.MassFlowSource_T souHea(
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1,
    redeclare package Medium = MediumSin) "Mass flow source"
    annotation (Placement(transformation(extent={{8,-10},{-12,-30}})));
  Modelica.Blocks.Math.Gain mHeaSin_flow(k=1/(cpSin_default*dTSin))
    "Mass flow rate for heat source"
    annotation (Placement(transformation(extent={{-28,-80},{-8,-60}})));
  Modelica.Blocks.Math.Add addHea(k2=-1) "Adder for energy balance"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Modelica.Blocks.Math.Add addCoo "Adder for energy balance"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Modelica.Blocks.Math.Gain mCooSin_flow(k=-1/(cpSin_default*dTSin))
    "Mass flow rate for heat sink"
    annotation (Placement(transformation(extent={{66,60},{86,80}})));
  Fluid.Sources.MassFlowSource_T sou2(
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = MediumSin,
    nPorts=1) "Mass flow source"
    annotation (Placement(transformation(extent={{-8,10},{12,30}})));

  Fluid.Sources.FixedBoundary sinCoo(          redeclare package Medium =
        MediumSin, nPorts=1) "Pressure source"
                                     annotation (Placement(transformation(
          extent={{10,-10},{-10,10}}, origin={82,20})));

equation
  connect(hea.TSet, TSetHea) annotation (Line(points={{-52,9},{-60,9},{-60,80},
          {-120,80}}, color={0,0,127}));
  connect(port_a, hea.port_a1) annotation (Line(points={{-100,0},{-90,0},{-90,6},
          {-50,6}},           color={0,127,255}));
  connect(hea.port_b1, senTem.port_a)
    annotation (Line(points={{-30,6},{-30,6},{-20,6},{-20,0},{-6,0}},
                                                          color={0,127,255}));
  connect(hea.QCon_flow, addHea.u1) annotation (Line(points={{-29,9},{-24,9},{
          -24,-50},{-70,-50},{-70,-64},{-62,-64}}, color={0,0,127}));
  connect(hea.P, addHea.u2) annotation (Line(points={{-29,0},{-26,0},{-26,-46},
          {-72,-46},{-72,-76},{-62,-76}},color={0,0,127}));
  connect(mHeaSin_flow.u, addHea.y)
    annotation (Line(points={{-30,-70},{-36,-70},{-39,-70}}, color={0,0,127}));
  connect(coo.P, addCoo.u2) annotation (Line(points={{59,0},{59,0},{64,0},{64,
          54},{28,54},{28,64},{38,64}},
                        color={0,0,127}));
  connect(addCoo.y, mCooSin_flow.u)
    annotation (Line(points={{61,70},{64,70}}, color={0,0,127}));
  connect(sinHea.ports[1], hea.port_b2) annotation (Line(points={{-60,-20},{-60,
          -20},{-54,-20},{-54,-6},{-50,-6}}, color={0,127,255}));
  connect(mHeaSin_flow.y, souHea.m_flow_in) annotation (Line(points={{-7,-70},{
          -7,-70},{20,-70},{20,-28},{8,-28}},
                                         color={0,0,127}));
  connect(TSink, souHea.T_in) annotation (Line(points={{-120,-60},{-84,-60},{
          -84,-90},{22,-90},{22,-54},{22,-24},{10,-24}},  color={0,0,127}));
  connect(souHea.ports[1], hea.port_a2) annotation (Line(points={{-12,-20},{-20,
          -20},{-20,-6},{-30,-6}}, color={0,127,255}));
  connect(mCooSin_flow.y, sou2.m_flow_in) annotation (Line(points={{87,70},{96,
          70},{96,90},{80,90},{-20,90},{-20,28},{-8,28}}, color={0,0,127}));
  connect(sou2.T_in, TSink) annotation (Line(points={{-10,24},{-84,24},{-84,-60},
          {-120,-60}}, color={0,0,127}));
  connect(hea.P, PComHea) annotation (Line(points={{-29,0},{-26,0},{-26,98},{98,
          98},{98,90},{110,90}}, color={0,0,127}));
  connect(coo.P, PComCoo) annotation (Line(points={{59,0},{64,0},{64,54},{98,54},
          {98,70},{110,70}}, color={0,0,127}));
  connect(hea.QCon_flow, QHea_flow) annotation (Line(points={{-29,9},{-24,9},{
          -24,50},{94,50},{94,50},{110,50}}, color={0,0,127}));
  connect(TSetCoo, coo.TSet) annotation (Line(points={{-120,40},{32,40},{32,9},
          {36,9}}, color={0,0,127}));
  connect(sou2.ports[1], coo.port_a1) annotation (Line(points={{12,20},{12,20},
          {20,20},{20,6},{38,6}}, color={0,127,255}));
  connect(coo.port_b1, sinCoo.ports[1]) annotation (Line(points={{58,6},{58,6},
          {62,6},{62,20},{72,20}}, color={0,127,255}));
  connect(port_b, coo.port_a2) annotation (Line(points={{100,0},{86,0},{72,0},{
          72,-6},{58,-6}}, color={0,127,255}));
  connect(coo.port_b2, senTem.port_b) annotation (Line(points={{38,-6},{20,-6},
          {20,0},{6,0}}, color={0,127,255}));
  connect(addCoo.u1, coo.QEva_flow) annotation (Line(points={{38,76},{28,76},{
          28,-14},{70,-14},{70,-9},{59,-9}}, color={0,0,127}));
  connect(coo.QEva_flow, QCoo_flow) annotation (Line(points={{59,-9},{94,-9},{
          94,30},{110,30}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-30,74},{26,20}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,52},{0,42}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{56,-4},{98,6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,42},{58,52}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-99,6},{-58,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-30,-24},{26,-78}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,-46},{0,-56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,-56},{58,-46}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,52},{-52,-54}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{48,-54},{58,52}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{-104,40},{-80,40},{-80,6}}, color={28,108,200}),
        Line(points={{-102,80},{78,80},{78,6}}, color={28,108,200})}),
    Documentation(info="<html>
<p>
Model of an ideal heating and cooling plant that takes as a parameter the set point
for the leaving fluid temperature.
The power consumptions are modeled using a vapor compression engine
for heating and for cooling.
The efficiency of these vapor compression engines varies using the
Carnot cycle analogy.
</p>
</html>", revisions="<html>
<ul>
<li>
January 11, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end HeatingCoolingCarnot_T;
