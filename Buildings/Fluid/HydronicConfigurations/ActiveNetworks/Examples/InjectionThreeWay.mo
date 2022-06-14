within Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples;
model InjectionThreeWay
  "Model illustrating the operation of an inversion circuit with three-way valve"
  extends BaseClasses.PartialActivePrimary(
    m1_flow_nominal=
      m2_flow_nominal * (TLiqEnt_nominal - TLiqLvg_nominal) / (TLiqSup_nominal - TLiqLvg_nominal),
    kSizPum=5.0,
    TLiqEnt_nominal=40+273.15,
    TLiqLvg_nominal=TLiqEnt_nominal-5,
    TLiqSup_nominal=60+273.15,
    dpPum_nominal=(dpPip_nominal + dpValve_nominal) * kSizPum,
    del1(nPorts=2));

  parameter Boolean is_bal=false
    "Set to true for balanced primary branch"
    annotation(Dialog(group="Configuration"), Evaluate=true);
  parameter Modelica.Units.SI.PressureDifference dpValve_nominal(
    displayUnit="Pa")=0.3E4
    "Control valve pressure drop at design conditions";

  Buildings.Fluid.HydronicConfigurations.ActiveNetworks.InjectionThreeWay con(
    have_ctl=true,
    typFun=Buildings.Fluid.HydronicConfigurations.Types.ControlFunction.Heating,
    typPum=Buildings.Fluid.HydronicConfigurations.Types.Pump.SingleConstant,
    redeclare final package Medium = MediumLiq,
    use_lumFloRes=false,
    final energyDynamics=energyDynamics,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final dp2_nominal=dpTer_nominal + loa.con.dpValve_nominal + dpPip_nominal,
    final dpBal1_nominal= if is_bal then dpPum_nominal - dpPip_nominal - dpValve_nominal
      else 0)
    "Hydronic connection"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));

  Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.BaseClasses.LoadThreeWayValveControl
    loa(
    redeclare final package MediumLiq = MediumLiq,
    final typ=typ,
    k=0.1,
    final energyDynamics=energyDynamics,
    final mLiq_flow_nominal=mTer_flow_nominal,
    final TLiqEnt_nominal=TLiqEnt_nominal,
    final TLiqLvg_nominal=TLiqLvg_nominal)
    "Load"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable fraLoa(table=[0,0,0;
        6,0,0; 6.1,1,1; 8,1,1; 9,1,0; 14,0.5,0; 14.5,0,0; 16,0,0; 17,0,1; 21,0,
        1; 22,0,0; 24,0,0],
    timeScale=3600)
    "Load modulating signal"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.BaseClasses.LoadThreeWayValveControl
    loa1(
    redeclare final package MediumLiq = MediumLiq,
    final typ=typ,
    k=0.1,
    final energyDynamics=energyDynamics,
    final mLiq_flow_nominal=mTer_flow_nominal,
    final TLiqEnt_nominal=TLiqEnt_nominal,
    final TLiqLvg_nominal=TLiqLvg_nominal)
    "Load"
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
  Sensors.RelativePressure dp(
    redeclare final package Medium = MediumLiq)
    "Differential pressure"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  FixedResistances.PressureDrop res2(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=con.pum.m_flow_nominal - loa.mLiq_flow_nominal,
    final dp_nominal=dpPip_nominal)
    "Pipe pressure drop"
    annotation (Placement(transformation(extent={{50,30},{70,50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable mode(
    table=[0,0; 6,0; 6,1; 22,1; 22,0; 24,0],
    timeScale=3600,
    period=86400) "Operating mode (time schedule)"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable setOff(table=[0,0; 12,
        0; 13,-5; 14,-7; 17,0; 24,0],  timeScale=3600)
    "Offset applied to design supply temperature to compute set point"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter T2Set(final p=
        TLiqEnt_nominal, y(final unit="K", displayUnit="degC"))
    "Consumer circuit temperature set point" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,60})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal rea
    "Convert signal into real"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-38,-20})));
  Buildings.Controls.OBC.CDL.Integers.Min min
    "Min with 1"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-20})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant one(
    final k=1)
    "One"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
equation
  connect(con.port_b1, dp.port_b) annotation (Line(points={{16,0},{20,0},{20,
          -40}},     color={0,127,255}));
  connect(con.port_a1, dp.port_a) annotation (Line(points={{4,0},{0,0},{0,-40}},
                     color={0,127,255}));
  connect(res2.port_b, loa1.port_a) annotation (Line(points={{70,40},{80,40},{
          80,70}},      color={0,127,255}));
  connect(fraLoa.y[1], loa.u) annotation (Line(points={{-98,100},{-20,100},{-20,
          78},{18,78}},
                    color={0,0,127}));
  connect(fraLoa.y[2], loa1.u) annotation (Line(points={{-98,100},{40,100},{40,78},
          {78,78}}, color={0,0,127}));
  connect(setOff.y[1], T2Set.u)
    annotation (Line(points={{-98,60},{-82,60}}, color={0,0,127}));
  connect(mode.y[1], con.mod) annotation (Line(points={{-98,20},{-20,20},{-20,
          18},{-2,18}}, color={255,127,0}));
  connect(T2Set.y, con.set) annotation (Line(points={{-58,60},{-40,60},{-40,6},{
          -2,6}},   color={0,0,127}));
  connect(min.y, rea.u)
    annotation (Line(points={{-58,-20},{-50,-20}},
                                               color={255,127,0}));
  connect(con.port_b2, loa.port_a) annotation (Line(points={{4,20},{0,20},{0,40},
          {20,40},{20,70}},
                        color={0,127,255}));
  connect(loa.port_b, con.port_a2)
    annotation (Line(points={{40,70},{40,19.8},{16,19.8}},
                                                         color={0,127,255}));
  connect(con.port_b2,res2. port_a)
    annotation (Line(points={{4,20},{0,20},{0,40},{50,40}},
                                                     color={0,127,255}));
  connect(loa1.port_b, con.port_a2)
    annotation (Line(points={{100,70},{100,19.8},{16,19.8}},
                                                           color={0,127,255}));
  connect(res1.port_b, dp.port_a) annotation (Line(points={{-10,-60},{0,-60},{0,
          -40}},    color={0,127,255}));
  connect(dp.port_b, del1.ports[2])
    annotation (Line(points={{20,-40},{20,-80}},  color={0,127,255}));
  connect(rea.y, pum.y) annotation (Line(points={{-26,-20},{-20,-20},{-20,-40},{
          -80,-40},{-80,-48}},
                             color={0,0,127}));
  connect(mode.y[1], min.u1) annotation (Line(points={{-98,20},{-90,20},{-90,-14},
          {-82,-14}}, color={255,127,0}));
  connect(one.y, min.u2)
    annotation (Line(points={{-98,-20},{-90,-20},{-90,-26},{-82,-26}},
                                                   color={255,127,0}));
  connect(mode.y[1], loa.mode) annotation (Line(points={{-98,20},{-20,20},{-20,
          74},{18,74}}, color={255,127,0}));
  connect(mode.y[1], loa1.mode) annotation (Line(points={{-98,20},{-20,20},{-20,
          50},{60,50},{60,74},{78,74}}, color={255,127,0}));
   annotation (experiment(
    StopTime=86400,
    Tolerance=1e-6),
    __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HydronicConfigurations/ActiveNetworks/Examples/InjectionThreeWay.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This model illustrates the use of an injection circuit with a three-way valve
that serves as the interface between a constant flow primary circuit at constant
supply temperature and a constant flow secondary circuit at variable supply
temperature.
Two identical terminal units circuits are served by the secondary circuit.
Each terminal unit has its own hourly load profile.
The main assumptions are enumerated below.
</p>
<ul>
<li>
The design conditions are defined without
considering any load diversity.
</li>
<li>
Each circuit is balanced at design conditions.
</li>
</ul>

</html>"));
end InjectionThreeWay;
