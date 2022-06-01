within Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples;
model SingleMixing
  "Model illustrating the operation of single mixing circuits"
  extends Modelica.Icons.Example;

  package MediumLiq = Buildings.Media.Water
    "Medium model for hot water";

  parameter Boolean is_bal = false
    "Set to true for a primary balancing valve";

  parameter Modelica.Units.SI.MassFlowRate mTer_flow_nominal = 1
    "Terminal unit mass flow rate at design conditions";
  final parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal(final min=0)=
    m2_flow_nominal * (TLiqEnt_nominal - TLiqLvg_nominal) / (TLiqSup_nominal - TLiqLvg_nominal)
    "Mass flow rate in primary circuit at design conditions"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal(final min=0)=
    2 * mTer_flow_nominal
    "Mass flow rate in consumer circuit at design conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Pressure dpTer_nominal(displayUnit="Pa")=3E4
    "Terminal unit pressure drop at design conditions";
  parameter Modelica.Units.SI.Pressure dpValve_nominal(displayUnit="Pa")=
    dpPum_nominal-dpPip_nominal
    "Control valve pressure drop at design conditions";
  parameter Modelica.Units.SI.Pressure dpPip_nominal(displayUnit="Pa")=0.5E4
    "Pipe section pressure drop at design conditions";
  final parameter Modelica.Units.SI.Pressure dpPum_nominal(
    final min=0,
    displayUnit="Pa")=8e4
    "Pump head at design conditions";
  parameter Modelica.Units.SI.MassFlowRate mPum_flow_nominal=m1_flow_nominal
    "Primary pump mass flow rate at design conditions";

  parameter Modelica.Units.SI.Pressure p_min=200000
    "Circuit minimum pressure";

  parameter Modelica.Units.SI.Temperature TAirEnt_nominal=293.15
    "Air entering temperature at design conditions";
  parameter Modelica.Units.SI.Temperature TLiqEnt_nominal=TLiqSup_nominal
    "Hot water entering temperature at design conditions";
  parameter Modelica.Units.SI.Temperature TLiqLvg_nominal=TLiqEnt_nominal-10
    "Hot water leaving temperature at design conditions";
  parameter Modelica.Units.SI.Temperature TLiqSup_nominal=333.15
    "Hot water primary supply temperature at design conditions";

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  Sources.Boundary_pT ref(
    redeclare final package Medium = MediumLiq,
    final p=p_min,
    final T=TLiqSup_nominal,
    nPorts=2)
    "Pressure and temperature boundary condition"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-80,-90})));
  Movers.SpeedControlled_y pum(
    redeclare final package Medium=MediumLiq,
    final energyDynamics=energyDynamics,
    addPowerToMedium=false,
    use_inputFilter=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState,
    per(pressure(
      V_flow={0, 1, 2} * mPum_flow_nominal / 996,
      dp = {1.2, 1, 0.4} * dpPum_nominal)),
    inputType=Buildings.Fluid.Types.InputType.Continuous)
    "Circulation pump"
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));
  Buildings.Fluid.HydronicConfigurations.ActiveNetworks.SingleMixing con(
    have_ctl=true,
    typFun=Buildings.Fluid.HydronicConfigurations.Types.ControlFunction.Heating,
    typPum=Buildings.Fluid.HydronicConfigurations.Types.Pump.SingleConstant,
    redeclare final package Medium=MediumLiq,
    use_lumFloRes=false,
    final energyDynamics=energyDynamics,
    dat(
      final m1_flow_nominal=m1_flow_nominal,
      final m2_flow_nominal=m2_flow_nominal,
      final dpValve_nominal=dpValve_nominal,
      final dp2_nominal=dpTer_nominal + loa.con.dpValve_nominal + dpPip_nominal,
      final dpBal1_nominal=dpValve_nominal * (if is_bal then 1 else 0),
      ctl(k=0.1, Ti=60)))
    "Hydronic connection"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  Buildings.Fluid.HydronicConfigurations.Examples.BaseClasses.LoadThreeWayValveControl
    loa(
    redeclare final package MediumLiq = MediumLiq,
    k=0.1,
    final energyDynamics=energyDynamics,
    final mLiq_flow_nominal=mTer_flow_nominal,
    final TAirEnt_nominal=TAirEnt_nominal,
    final TLiqEnt_nominal=TLiqEnt_nominal,
    final TLiqLvg_nominal=TLiqLvg_nominal)
          "Load" annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable fraLoa(table=[0,0,0; 6,
        0,0; 6,1,1; 7,1,0.5; 8,0.5,0; 14,0.5,0; 14.5,0,0; 16,0,0; 17,0,1; 22,0,1;
        22,0,0; 24,0,0],
      timeScale=3600)
    "Load modulating signal"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Buildings.Fluid.HydronicConfigurations.Examples.BaseClasses.LoadThreeWayValveControl
    loa1(
    redeclare final package MediumLiq = MediumLiq,
    k=0.1,
    final energyDynamics=energyDynamics,
    final mLiq_flow_nominal=mTer_flow_nominal,
    final TAirEnt_nominal=TAirEnt_nominal,
    final TLiqEnt_nominal=TLiqEnt_nominal,
    final TLiqLvg_nominal=TLiqLvg_nominal)
    "Load"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));
  FixedResistances.PressureDrop res(
    redeclare final package Medium=MediumLiq,
    final m_flow_nominal=mPum_flow_nominal,
    final dp_nominal=dpPip_nominal)
    "Pipe pressure drop"
    annotation (Placement(transformation(extent={{-30,-70},{-10,-50}})));
  Sensors.RelativePressure dp(
    redeclare final package Medium = MediumLiq)
    "Differential pressure"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Sensors.TemperatureTwoPort TRet(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mPum_flow_nominal,
    T_start=TLiqSup_nominal)
    "Return temperature sensor"
    annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={-40,-80})));
  Sensors.TemperatureTwoPort TSup(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mPum_flow_nominal,
    T_start=TLiqSup_nominal)
    "Supply temperature sensor"
    annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-50,-60})));
  .Buildings.Controls.OBC.CDL.Continuous.Subtract delT(y(final unit="K"))
    "Primary delta-T"
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));
  FixedResistances.PressureDrop res1(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mTer_flow_nominal,
    final dp_nominal=dpPip_nominal)
    "Pipe pressure drop"
    annotation (Placement(transformation(extent={{70,30},{90,50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable mod(
    table=[0,0; 6,0; 6,
        1; 22,1; 22,0; 24,0],
    timeScale=3600,
    period=86400)
    "Operating mode (time schedule)"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable setOff(table=[0,0; 12,
        0; 13,-5; 14,-10; 16,-2; 24,0],timeScale=3600)
    "Offset applied to design supply temperature to compute set point"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter set(
    final p=TLiqEnt_nominal,
    y(final unit="K", displayUnit="degC"))
    "Compute supply temperature set point"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-60,60})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal rea
    "Convert signal into real"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-40,-20})));
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
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));
equation
  connect(ref.ports[1], pum.port_a) annotation (Line(points={{-81,-80},{-100,-80},
          {-100,-60},{-90,-60}},
                            color={0,127,255}));
  connect(res.port_b, dp.port_a)
    annotation (Line(points={{-10,-60},{0,-60},{0,-40}},   color={0,127,255}));
  connect(con.port_b1, dp.port_b) annotation (Line(points={{16,-10},{16,-18},{20,
          -18},{20,-40}},
                     color={0,127,255}));
  connect(con.port_a1, dp.port_a) annotation (Line(points={{4,-10},{4,-18},{0,-18},
          {0,-40}},  color={0,127,255}));
  connect(TRet.port_b, ref.ports[2])
    annotation (Line(points={{-50,-80},{-79,-80}}, color={0,127,255}));
  connect(TRet.port_a, dp.port_b)
    annotation (Line(points={{-30,-80},{20,-80},{20,-40}}, color={0,127,255}));
  connect(pum.port_b, TSup.port_a)
    annotation (Line(points={{-70,-60},{-60,-60}}, color={0,127,255}));
  connect(TSup.port_b, res.port_a)
    annotation (Line(points={{-40,-60},{-30,-60}}, color={0,127,255}));
  connect(TRet.T, delT.u1)
    annotation (Line(points={{-40,-91},{-40,-94},{-2,-94}}, color={0,0,127}));
  connect(TSup.T, delT.u2)
    annotation (Line(points={{-50,-71},{-50,-106},{-2,-106}},
                                                            color={0,0,127}));
  connect(res1.port_b, loa1.port_a) annotation (Line(points={{90,40},{100,40},{100,
          80}},         color={0,127,255}));
  connect(fraLoa.y[1], loa.u) annotation (Line(points={{-98,100},{20,100},{20,86},
          {38,86}}, color={0,0,127}));
  connect(fraLoa.y[2], loa1.u) annotation (Line(points={{-98,100},{80,100},{80,86},
          {98,86}}, color={0,0,127}));
  connect(setOff.y[1], set.u)
    annotation (Line(points={{-98,60},{-72,60}}, color={0,0,127}));
  connect(mod.y[1], con.mod) annotation (Line(points={{-98,-20},{-90,-20},{-90,0},
          {-20,0},{-20,8},{-2,8}},   color={255,127,0}));
  connect(set.y, con.set) annotation (Line(points={{-48,60},{-40,60},{-40,-4},{-2,
          -4}}, color={0,0,127}));
  connect(rea.y, pum.y) annotation (Line(points={{-28,-20},{-20,-20},{-20,-40},{
          -80,-40},{-80,-48}},
                           color={0,0,127}));
  connect(mod.y[1], min.u2) annotation (Line(points={{-98,-20},{-90,-20},{-90,-26},
          {-82,-26}},
                color={255,127,0}));
  connect(min.y, rea.u)
    annotation (Line(points={{-58,-20},{-52,-20}},
                                               color={255,127,0}));
  connect(one.y, min.u1) annotation (Line(points={{-98,10},{-88,10},{-88,-14},{-82,
          -14}},
               color={255,127,0}));
  connect(con.port_b2, loa.port_a) annotation (Line(points={{4,10},{4,40},{40,
          40},{40,80}}, color={0,127,255}));
  connect(loa.port_b, con.port_a2)
    annotation (Line(points={{60,80},{60,9.8},{16,9.8}}, color={0,127,255}));
  connect(loa1.port_b, con.port_a2)
    annotation (Line(points={{120,80},{120,9.8},{16,9.8}}, color={0,127,255}));
  connect(con.port_b2, res1.port_a)
    annotation (Line(points={{4,10},{4,40},{70,40}}, color={0,127,255}));
   annotation (experiment(
    StopTime=86400,
    Tolerance=1e-6),
    __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HydronicConfigurations/ActiveNetworks/Examples/SingleMixing.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This model illustrates the use of a single mixing circuit
that serves as the interface between a variable flow primary circuit at constant
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
Each circuit is balanced at design conditions: UPDATE
</ul>

</html>"),
    Diagram(coordinateSystem(extent={{-140,-120},{140,120}})));
end SingleMixing;
