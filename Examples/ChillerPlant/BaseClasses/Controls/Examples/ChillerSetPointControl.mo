within Buildings.Examples.ChillerPlant.BaseClasses.Controls.Examples;
model ChillerSetPointControl
  "Test model for chiller setpoint control using TrimAndResponse and LinearPieceWiseTwo"
  extends Modelica.Icons.Example;
  package Medium1 = Buildings.Media.ConstantPropertyLiquidWater;
  package Medium2 = Buildings.Media.ConstantPropertyLiquidWater;
  package MediumAir = Buildings.Media.GasesPTDecoupled.SimpleAir "Medium model";
  parameter Modelica.SIunits.MassFlowRate mAir_flow_nominal=61.6*2
    "Nominal mass flow rate at fan";
  parameter Real COPc_nominal=3 "Chiller COP";
  parameter Modelica.SIunits.MassFlowRate mCHW_flow_nominal=15.2
    "Nominal mass flow rate at chilled water";
  parameter Modelica.SIunits.MassFlowRate mCW_flow_nominal=mCHW_flow_nominal/
      COPc_nominal*(COPc_nominal + 1)
    "Nominal mass flow rate at condenser water";
  parameter Real QRoo=100;
  Buildings.Examples.ChillerPlant.BaseClasses.Controls.TrimAndRespond triAndRes(
    yEqu0=0.1,
    uTri=0.8,
    yDec=-0.03,
    yInc=0.03,
    samplePeriod=120)
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Buildings.Examples.ChillerPlant.BaseClasses.Controls.LinearPiecewiseTwo
    linPieTwo(
    x0=0,
    x2=1,
    y20=273.15 + 12.78,
    y21=273.15 + 7.22,
    x1=0.5,
    y10=0.1,
    y11=1) annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Fluid.Chillers.ElectricEIR chi(
    dp1_nominal=6000,
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    m1_flow_nominal=mCW_flow_nominal,
    m2_flow_nominal=mCHW_flow_nominal,
    dp2_nominal=3000,
    per=Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YK_1881kW_6_53COP_Vanes(),
    m1_flow(fixed=true, start=mCW_flow_nominal),
    m2_flow(fixed=true, start=mCHW_flow_nominal),
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial)
    annotation (Placement(transformation(extent={{84,18},{104,38}})));

  Buildings.Fluid.HeatExchangers.ConstantEffectiveness coi(
    redeclare package Medium1 = Medium2,
    m1_flow_nominal=mCHW_flow_nominal,
    dp1_nominal=3000,
    dp2_nominal=3000,
    redeclare package Medium2 = MediumAir,
    m2_flow_nominal=mAir_flow_nominal,
    eps=1.0) annotation (Placement(transformation(extent={{86,-64},{106,-44}})));
  Buildings.Fluid.Sources.FixedBoundary sin1(redeclare package Medium = Medium1,
      nPorts=1) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={174,88})));
  Buildings.Fluid.Sources.MassFlowSource_T sou1(
    redeclare package Medium = Medium1,
    nPorts=1,
    use_T_in=false,
    m_flow=mCW_flow_nominal,
    T=283.15) annotation (Placement(transformation(extent={{-16,78},{4,98}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-180,-80},{-160,-60}})));
  Modelica.Blocks.Sources.Constant const(k=273.15 + 20) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-182,30})));
  Buildings.Controls.Continuous.LimPID limPID(
    reverseAction=true,
    y_start=1,
    yMin=0,
    k=10,
    Ti=0.01,
    Td=10) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-150,30})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TRet(redeclare package Medium =
        MediumAir, m_flow_nominal=999)
    annotation (Placement(transformation(extent={{4,-74},{24,-54}})));
  Buildings.Fluid.Movers.FlowMachine_m_flow pum(
    m_flow_nominal=1.2*mCHW_flow_nominal,
    dp(start=40474),
    redeclare package Medium = Medium2,
    init=Modelica.Blocks.Types.Init.NoInit) "Chilled water pump" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={134,-9})));
  Buildings.Fluid.Storage.ExpansionVessel expVesChi(VTot=1, redeclare package
      Medium = Medium2)
    annotation (Placement(transformation(extent={{134,26},{154,46}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant1(k=true)
    annotation (Placement(transformation(extent={{-180,62},{-160,82}})));
  Modelica.Blocks.Math.Gain gain(k=mCHW_flow_nominal)
    annotation (Placement(transformation(extent={{86,-18},{106,2}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou2(
    use_T_in=true,
    redeclare package Medium = MediumAir,
    m_flow=mAir_flow_nominal,
    T=291.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={170,-92})));
  Buildings.Fluid.Sources.FixedBoundary sin2(redeclare package Medium =
        MediumAir, nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-116,-72})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=5,
    offset=273.15 + 25,
    freqHz=1/20000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={114,-92})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(y_start=273.15 + 10, T=chi.tau1
        /2) annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TSup(redeclare package Medium =
        MediumAir, m_flow_nominal=999)
    annotation (Placement(transformation(extent={{136,-70},{156,-50}})));
equation
  connect(sou1.ports[1], chi.port_a1) annotation (Line(
      points={{4,88},{74,88},{74,34},{84,34}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(coi.port_a1, chi.port_b2) annotation (Line(
      points={{86,-48},{36,-48},{36,22},{84,22}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TRet.T, limPID.u_m) annotation (Line(
      points={{14,-53},{14,-28},{-150,-28},{-150,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(chi.port_a2, pum.port_b) annotation (Line(
      points={{104,22},{134,22},{134,1}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pum.port_a, coi.port_b1) annotation (Line(
      points={{134,-19},{134,-48},{106,-48}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(chi.port_a2, expVesChi.port_a) annotation (Line(
      points={{104,22},{144,22},{144,26}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(booleanConstant1.y, chi.on) annotation (Line(
      points={{-159,72},{54,72},{54,31},{82,31}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(gain.y, pum.m_flow_in) annotation (Line(
      points={{107,-8},{116.4,-8},{116.4,-9.2},{122,-9.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou2.T_in, sine.y) annotation (Line(
      points={{158,-96},{140,-96},{140,-92},{125,-92}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(chi.port_b1, sin1.ports[1]) annotation (Line(
      points={{104,34},{122,34},{122,88},{164,88}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(const.y, limPID.u_s) annotation (Line(
      points={{-171,30},{-162,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRet.port_b, coi.port_b2) annotation (Line(
      points={{24,-64},{56,-64},{56,-60},{86,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TRet.port_a, sin2.ports[1]) annotation (Line(
      points={{4,-64},{-48,-64},{-48,-60},{-90,-60},{-90,-72},{-106,-72}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(linPieTwo.y[2], firstOrder1.u) annotation (Line(
      points={{-39,30.3},{-20,30},{-2,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firstOrder1.y, chi.TSet) annotation (Line(
      points={{21,30},{44,30},{44,25},{82,25}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(coi.port_a2, TSup.port_a) annotation (Line(
      points={{106,-60},{136,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TSup.port_b, sou2.ports[1]) annotation (Line(
      points={{156,-60},{190,-60},{190,-92},{180,-92}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(linPieTwo.y[1], gain.u) annotation (Line(
      points={{-39,29.3},{-20,29.3},{-20,-8},{84,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(limPID.y, triAndRes.u) annotation (Line(
      points={{-139,30},{-120,30},{-120,30},{-102,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(triAndRes.y, linPieTwo.u) annotation (Line(
      points={{-79,30},{-62,30}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-200,-200},{200,
            200}})),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Examples/ChillerPlant/BaseClasses/Controls/Examples/ChillerSetPointControl.mos"
        "Simulate and plot"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}})),
    Documentation(revisions="<html>
<ul>
<li>
October 17, 2012, by Wangda Zuo:<br/>
Revised for the new trim and respond control.
</li>
<li>
July 21, 2011, by Wangda Zuo:<br/>
Added mos file and merged to library.
</li>
<li>
January 18, 2011, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end ChillerSetPointControl;
