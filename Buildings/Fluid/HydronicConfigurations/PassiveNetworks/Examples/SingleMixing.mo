within Buildings.Fluid.HydronicConfigurations.PassiveNetworks.Examples;
model SingleMixing "Model illustrating the operation of single mixing circuits"
  extends BaseClasses.PartialPassivePrimary(del1(nPorts=3), ref(use_T_in=true));

  parameter Modelica.Units.SI.PressureDifference dp2Set(
    final min=0,
    displayUnit="Pa") = loa1.dpTer_nominal + loa1.dpValve_nominal
    "Secondary pressure differential set point"
    annotation (Dialog(group="Controls"));

  Buildings.Fluid.HydronicConfigurations.PassiveNetworks.SingleMixing con(
    have_ctl=true,
    typFun=Buildings.Fluid.HydronicConfigurations.Types.ControlFunction.ChangeOver,
    typPum=Buildings.Fluid.HydronicConfigurations.Types.Pump.SingleConstant,
    redeclare final package Medium=MediumLiq,
    final energyDynamics=energyDynamics,
    final m2_flow_nominal=loa.m_flow_nominal,
    final dp2_nominal=loa.dpTer_nominal + loa.dpValve_nominal)
    "Hydronic connection"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  ActiveNetworks.Examples.BaseClasses.LoadThreeWayValveControl loa(
      redeclare final package MediumLiq = MediumLiq,
    typ=Buildings.Fluid.HydronicConfigurations.Types.ControlFunction.ChangeOver,
      final energyDynamics=energyDynamics,
      final mLiq_flow_nominal=mTer_flow_nominal,
      final TLiqEnt_nominal=TLiqEnt_nominal,
      final TLiqLvg_nominal=TLiqLvg_nominal,
      final TLiqEntChg_nominal=TLiqEntChg_nominal)
    "Load"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Fluid.HydronicConfigurations.PassiveNetworks.SingleMixing con1(
    have_ctl=true,
    typPumMod=Buildings.Fluid.HydronicConfigurations.Types.PumpModel.Head,
    typFun=Buildings.Fluid.HydronicConfigurations.Types.ControlFunction.ChangeOver,
    typPum=Buildings.Fluid.HydronicConfigurations.Types.Pump.SingleVariable,
    redeclare final package Medium = MediumLiq,
    final energyDynamics=energyDynamics,
    final m2_flow_nominal=loa1.m_flow_nominal / 0.9,
    final dp2_nominal=dp2Set)
    "Hydronic connection"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  ActiveNetworks.Examples.BaseClasses.LoadTwoWayValveControl loa1(
      redeclare final package MediumLiq = MediumLiq,
    typ=Buildings.Fluid.HydronicConfigurations.Types.ControlFunction.ChangeOver,
      final energyDynamics=energyDynamics,
      final mLiq_flow_nominal=mTer_flow_nominal,
      final TLiqEnt_nominal=TLiqEnt_nominal,
      final TLiqLvg_nominal=TLiqLvg_nominal,
      final TLiqEntChg_nominal=TLiqEntChg_nominal)
    "Load"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Sensors.RelativePressure dp2(redeclare final package Medium = MediumLiq)
    "Differential pressure"
    annotation (Placement(transformation(extent={{60,10},{80,-10}})));
  FixedResistances.PressureDrop resEnd2(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=0.1*con1.pum.m_flow_nominal,
    final dp_nominal=dp2Set)
    "Pipe pressure drop"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,60})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable mode(
    table=[0,0,0; 6,0,0; 6,2,1; 13,2,1; 13,1,1; 22,1,1; 22,0,0; 24,0,0],
    timeScale=3600,
    period=86400)
    "Operating mode (time schedule): index 1 for change-over switch, index 2 for pump on/off"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable fraLoa(table=[0,0,0; 6,
        0,0; 6.1,1,1; 8,1,1; 9,1,0; 14,0.5,0; 14.5,0,0; 16,0,0; 17,0,1; 21,0,1;
        22,0,0; 24,0,0], timeScale=3600) "Load modulating signal"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable setOff(table=[0,0; 10,
        0; 13,-8; 13,0; 18,0; 22,+5; 22,0; 24,0], timeScale=3600)
    "Offset applied to design supply temperature to compute set point"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Add          T2Set(y(final unit="K",
        displayUnit="degC"))
    "Consumer circuit temperature set point" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-30})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor T2SetMod(
    allowOutOfRange=true,
    nin=2,
    outOfRangeValue=20 + 273.15,
    y(final unit="K", displayUnit="degC"))
    "Select consumer circuit temperature set point based on operating mode"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-80,0})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant T2SetVal[2](final k={
        TLiqEnt_nominal,TLiqEntChg_nominal})
    "Consumer circuit temperature set point values"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant T1SetVal[2](final k={
        TLiqSup_nominal,TLiqSupChg_nominal})
    "Primary circuit temperature set point values"
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor   T2Set2(
    allowOutOfRange=true,                                   nin=2,
    outOfRangeValue=20 + 273.15,                            y(final unit="K",
        displayUnit="degC"))
    "Consumer circuit temperature set point" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-80,-120})));
  Modelica.Blocks.Sources.RealExpression uPum(y=(dp2Set + con1.val.dp3)/con1.pum.dp_nominal)
    "Pump control signal"
    annotation (Placement(transformation(extent={{30,-36},{50,-16}})));
equation
  connect(con.port_b2, loa.port_a)
    annotation (Line(points={{4,-20},{0,-20},{0,30}}, color={0,127,255}));
  connect(loa.port_b, con.port_a2) annotation (Line(points={{20,30},{20,-20.2},
          {16,-20.2}},      color={0,127,255}));
  connect(con.port_b1, del1.ports[2])
    annotation (Line(points={{16,-40},{20,-40},{20,-80}}, color={0,127,255}));
  connect(con1.port_b1, del1.ports[3]) annotation (Line(points={{76,-40},{80,-40},
          {80,-80},{20,-80}}, color={0,127,255}));
  connect(loa1.port_a, dp2.port_a)
    annotation (Line(points={{60,30},{60,0}}, color={0,127,255}));
  connect(loa1.port_b, dp2.port_b)
    annotation (Line(points={{80,30},{80,0}}, color={0,127,255}));
  connect(dp2.port_a, con1.port_b2)
    annotation (Line(points={{60,0},{60,-20},{64,-20}}, color={0,127,255}));
  connect(dp2.port_b, con1.port_a2) annotation (Line(points={{80,0},{80,-20.2},{
          76,-20.2}}, color={0,127,255}));
  connect(resEnd2.port_b, loa1.port_b)
    annotation (Line(points={{80,60},{80,30}}, color={0,127,255}));
  connect(resEnd2.port_a, loa1.port_a)
    annotation (Line(points={{60,60},{60,30}}, color={0,127,255}));
  connect(mode.y[1], loa.mode) annotation (Line(points={{-98,80},{-20,80},{-20,34},
          {-2,34}}, color={255,127,0}));
  connect(mode.y[1], loa1.mode) annotation (Line(points={{-98,80},{40,80},{40,34},
          {58,34}}, color={255,127,0}));
  connect(mode.y[1], con.mod) annotation (Line(points={{-98,80},{-20,80},{-20,
          -22},{-2,-22}},
                     color={255,127,0}));
  connect(fraLoa.y[1], loa.u) annotation (Line(points={{-98,120},{-10,120},{-10,
          38},{-2,38}}, color={0,0,127}));
  connect(fraLoa.y[2], loa1.u) annotation (Line(points={{-98,120},{50,120},{50,38},
          {58,38}}, color={0,0,127}));
  connect(mode.y[1], con1.mod) annotation (Line(points={{-98,80},{40,80},{40,34},
          {54,34},{54,-22},{58,-22}}, color={255,127,0}));
  connect(mode.y[1], T2SetMod.index)
    annotation (Line(points={{-98,80},{-80,80},{-80,12}}, color={255,127,0}));
  connect(T2SetVal.y, T2SetMod.u)
    annotation (Line(points={{-98,0},{-92,0}}, color={0,0,127}));
  connect(T2SetMod.y, T2Set.u1) annotation (Line(points={{-68,0},{-66,0},{-66,-24},
          {-62,-24}}, color={0,0,127}));
  connect(setOff.y[1], T2Set.u2) annotation (Line(points={{-98,-40},{-80,-40},{-80,
          -36},{-62,-36}}, color={0,0,127}));
  connect(T2Set.y, con.set) annotation (Line(points={{-38,-30},{-20,-30},{-20,
          -34},{-2,-34}},
                     color={0,0,127}));
  connect(T2Set.y, con1.set) annotation (Line(points={{-38,-30},{-20,-30},{-20,-50},
          {40,-50},{40,-34},{58,-34}}, color={0,0,127}));
  connect(T1SetVal.y, T2Set2.u) annotation (Line(points={{-98,-120},{-94,-120},{
          -94,-120},{-92,-120}}, color={0,0,127}));
  connect(T2Set2.y, ref.T_in) annotation (Line(points={{-68,-120},{-66,-120},{
          -66,-90},{-120,-90},{-120,-74},{-102,-74}},
                                                    color={0,0,127}));
  connect(mode.y[1], T2Set2.index) annotation (Line(points={{-98,80},{-80,80},{
          -80,60},{-130,60},{-130,-100},{-80,-100},{-80,-108}},
                                                            color={255,127,0}));
  connect(res1.port_b, con.port_a1) annotation (Line(points={{-10,-60},{0,-60},
          {0,-40},{4,-40}}, color={0,127,255}));
  connect(res1.port_b, con1.port_a1) annotation (Line(points={{-10,-60},{60,-60},
          {60,-40},{64,-40}}, color={0,127,255}));
  connect(uPum.y, con1.yPum)
    annotation (Line(points={{51,-26},{58,-26}}, color={0,0,127}));
annotation (
experiment(
    StopTime=86400,
    Tolerance=1e-6),
__Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HydronicConfigurations/PassiveNetworks/Examples/SingleMixing.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
Two consumer circuits operating in change-over: 
first one is constant flow,
second one is variable flow.
The pump model for the second circuit is an ideal 
&Delta;p-controlled model, its input being computed to 
mimic tracking a pressure differential set point at the
boundaries of the terminal unit. 
</p>
</html>"));
end SingleMixing;
