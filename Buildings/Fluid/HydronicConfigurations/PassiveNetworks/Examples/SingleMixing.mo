within Buildings.Fluid.HydronicConfigurations.PassiveNetworks.Examples;
model SingleMixing
  extends BaseClasses.PartialPassivePrimary(del1(nPorts=3));

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
    use_lumFloRes=false,
    final energyDynamics=energyDynamics,
    final m2_flow_nominal=m2_flow_nominal,
    final dpValve_nominal=dpValve_nominal,
    final dp2_nominal=dpValve_nominal + loa1.dpTer_nominal + loa1.dpValve_nominal + dpPip_nominal,
    final dpBal1_nominal=if is_bal then dpPum_nominal-dpPip_nominal else 0)
    "Hydronic connection"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  ActiveNetworks.Examples.BaseClasses.LoadThreeWayValveControl loa(
      redeclare final package MediumLiq = MediumLiq,
      final energyDynamics=energyDynamics,
      final mLiq_flow_nominal=mTer_flow_nominal,
      final TAirEnt_nominal=TAirEnt_nominal,
      final phiAirEnt_nominal=phiAirEnt_nominal,
      final TLiqEnt_nominal=TLiqEnt_nominal,
      final TLiqLvg_nominal=TLiqLvg_nominal,
      dpBal1_nominal=dp2_nominal-loa.dpTer_nominal-loa.dpValve_nominal)
    "Load"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Fluid.HydronicConfigurations.PassiveNetworks.SingleMixing con1(
    have_ctl=true,
    typPumMod=Buildings.Fluid.HydronicConfigurations.Types.PumpModel.Head,
    typFun=Buildings.Fluid.HydronicConfigurations.Types.ControlFunction.ChangeOver,
    typPum=Buildings.Fluid.HydronicConfigurations.Types.Pump.SingleVariable,
    redeclare final package Medium = MediumLiq,
    use_lumFloRes=false,
    final energyDynamics=energyDynamics,
    final m2_flow_nominal=m2_flow_nominal,
    final dpValve_nominal=dpValve_nominal,
    final dp2_nominal=dpValve_nominal + loa1.dpTer_nominal + loa1.dpValve_nominal
         + dpPip_nominal,
    final dpBal1_nominal=if is_bal then dpPum_nominal - dpPip_nominal else 0)
    "Hydronic connection"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  ActiveNetworks.Examples.BaseClasses.LoadTwoWayValveControl loa1(
      redeclare final package MediumLiq = MediumLiq,
      final energyDynamics=energyDynamics,
      final mLiq_flow_nominal=mTer_flow_nominal,
      final TAirEnt_nominal=TAirEnt_nominal,
      final phiAirEnt_nominal=phiAirEnt_nominal,
      final TLiqEnt_nominal=TLiqEnt_nominal,
      final TLiqLvg_nominal=TLiqLvg_nominal,
      dpBal1_nominal=dp2_nominal-loa.dpTer_nominal-loa.dpValve_nominal)
    "Load"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dp2SetVal(final k=
        dp2Set)
    "Pressure differential set point"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Controls.PIDWithOperatingMode ctlPum2(
    k=1,
    Ti=60,
    r=MediumLiq.p_default,
    y_reset=1) "Pump controller"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Sensors.RelativePressure dp2(redeclare final package Medium = MediumLiq)
    "Differential pressure"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  FixedResistances.PressureDrop resEnd2(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=0.1*m2_flow_nominal,
    final dp_nominal=dp2Set)
    "Pipe pressure drop"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,60})));
equation
  connect(TSup.port_b, con.port_a1)
    annotation (Line(points={{-50,-60},{0,-60},{0,-40},{4,-40}},
                                                         color={0,127,255}));
  connect(con.port_b2, loa.port_a)
    annotation (Line(points={{4,-20},{0,-20},{0,30}}, color={0,127,255}));
  connect(loa.port_b, con.port_a2) annotation (Line(points={{20,30},{20,-20},{16,
          -20},{16,-20.2}}, color={0,127,255}));
  connect(con.port_b1, del1.ports[2])
    annotation (Line(points={{16,-40},{20,-40},{20,-80}}, color={0,127,255}));
  connect(TSup.port_b, con1.port_a1) annotation (Line(points={{-50,-60},{60,-60},
          {60,-40},{64,-40}}, color={0,127,255}));
  connect(con1.port_b1, del1.ports[3]) annotation (Line(points={{76,-40},{80,-40},
          {80,-80},{20,-80}}, color={0,127,255}));
  connect(dp2SetVal.y, ctlPum2.u_s)
    annotation (Line(points={{-98,0},{-72,0}}, color={0,0,127}));
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
  connect(dp2.p_rel, ctlPum2.u_m) annotation (Line(points={{70,-9},{70,-16},{-60,
          -16},{-60,-12}}, color={0,0,127}));
  connect(ctlPum2.y, con1.yPum) annotation (Line(points={{-48,0},{40,0},{40,-26},
          {58,-26}}, color={0,0,127}));
end SingleMixing;
