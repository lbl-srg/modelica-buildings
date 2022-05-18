within Buildings.Fluid.HydronicConfigurations.Examples.ControlValves;
model DiversionCircuitOpenLoop
  "Model illustrating the operation of three-way valves with constant speed pump"
  extends Modelica.Icons.Example;

  package MediumLiq = Buildings.Media.Water
    "Medium model for hot water";
  parameter Modelica.Units.SI.MassFlowRate mLiq_flow_nominal = 1
    "Circuit mass flow rate at design conditions";
  parameter Modelica.Units.SI.Pressure p_min = 2E5
    "Circuit minimum pressure";
  parameter Modelica.Units.SI.Pressure dp_nominal = 1E5
    "Circuit total pressure drop at design conditions";

  parameter Modelica.Units.SI.PressureDifference dpSec_nominal(
    final min=0,
    displayUnit="Pa") = 0.1 * dp_nominal
    "Secondary pressure differential at design conditions"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.PressureDifference dpValve_nominal(
    final min=Modelica.Constants.eps,
    displayUnit="Pa") = 0.1 * dp_nominal
    "Control valve pressure drop at design conditions"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.PressureDifference dpBal1_nominal(
    final min=0,
    displayUnit="Pa") = dp_nominal - (dpSec_nominal + dpValve_nominal)
    "Primary balancing valve pressure drop at design conditions "
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.PressureDifference dpBal2_nominal(
    final min=0,
    displayUnit="Pa") = 0
    "Secondary balancing valve pressure drop at design conditions "
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.Temperature TAirEnt_nominal = 20 + 273.15
    "Air entering temperature at design conditions";
  parameter Modelica.Units.SI.Temperature TLiqEnt_nominal = 60 + 273.15
    "Hot water entering temperature at design conditions";
  parameter Modelica.Units.SI.Temperature TLiqLvg_nominal = 50 + 273.15
    "Hot water leaving temperature at design conditions";

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  Sources.Boundary_pT ref(
    redeclare final package Medium = MediumLiq,
    final p=p_min,
    final T=TLiqEnt_nominal,
    nPorts=3)
    "Pressure and temperature boundary condition"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={0,-70})));
  Movers.SpeedControlled_y pum(
    redeclare final package Medium=MediumLiq,
    final energyDynamics=energyDynamics,
    use_inputFilter=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState,
    per(pressure(
      V_flow=2 * {0,1,2} * mLiq_flow_nominal / 996,
      dp(displayUnit="Pa") = {1.5, 1, 0} * dp_nominal)),
    inputType=Buildings.Fluid.Types.InputType.Constant)
    "Circulation pump"
    annotation (Placement(transformation(extent={{-70,-50},{-50,-30}})));
  ActiveNetworks.Diversion con(
    val(fraK=1),
    redeclare final package Medium=MediumLiq,
    use_lumFloRes=false,
    final energyDynamics=energyDynamics,
    final m_flow_nominal=mLiq_flow_nominal,
    final dpSec_nominal=dpSec_nominal,
    final dpValve_nominal=dpValve_nominal,
    final dpBal1_nominal=dpBal1_nominal,
    final dpBal2_nominal=dpBal2_nominal)
    "Hydronic connection"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));

  BaseClasses.Load loa(
    redeclare final package MediumLiq = MediumLiq,
    dpLiq_nominal=dpSec_nominal,
    final energyDynamics=energyDynamics,
    final mLiq_flow_nominal=mLiq_flow_nominal,
    final TAirEnt_nominal=TAirEnt_nominal,
    final TLiqEnt_nominal=TLiqEnt_nominal,
    final TLiqLvg_nominal=TLiqLvg_nominal,
    k=10) "Load"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Controls.OBC.CDL.Continuous.Sources.Constant fraLoa(k=1)
    "Load modulating signal"
    annotation (Placement(transformation(extent={{-70,70},{-50,90}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp ope(duration=100)
    "Valve opening signal"
    annotation (Placement(transformation(extent={{-70,30},{-50,50}})));
  ActiveNetworks.Diversion con1(
    use_lumFloRes=false,
    val(fraK=1),
    redeclare final package Medium = MediumLiq,
    final energyDynamics=energyDynamics,
    final m_flow_nominal=mLiq_flow_nominal,
    final dpSec_nominal=dpSec_nominal,
    final dpValve_nominal=dpValve_nominal,
    final dpBal1_nominal=dpBal1_nominal,
    final dpBal2_nominal=dpBal2_nominal)
    "Hydronic connection"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
  BaseClasses.Load loa1(
    redeclare final package MediumLiq = MediumLiq,
    dpLiq_nominal=dpSec_nominal,
    final energyDynamics=energyDynamics,
    final mLiq_flow_nominal=mLiq_flow_nominal,
    final TAirEnt_nominal=TAirEnt_nominal,
    final TLiqEnt_nominal=TLiqEnt_nominal,
    final TLiqLvg_nominal=TLiqLvg_nominal,
    k=10) "Load"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Modelica.Blocks.Sources.RealExpression ope1(y=1 - ope.y)
    "Valve opening for second circuit"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));

equation
  connect(ref.ports[1], pum.port_a) annotation (Line(points={{-1.33333,-60},{-80,
          -60},{-80,-40},{-70,-40}},
                            color={0,127,255}));
  connect(pum.port_b, con.port_a1)
    annotation (Line(points={{-50,-40},{24,-40},{24,10}},
                                                      color={0,127,255}));
  connect(con.port_b1, ref.ports[2])
    annotation (Line(points={{36,10},{36,-60},{1.9984e-15,-60}},
                                                          color={0,127,255}));
  connect(con.port_b2, loa.port_a) annotation (Line(points={{24,30},{24,40},{20,
          40},{20,60}}, color={0,127,255}));
  connect(loa.port_b, con.port_a2) annotation (Line(points={{40,60},{40,40},{36,
          40},{36,29.8}}, color={0,127,255}));
  connect(fraLoa.y, loa.u) annotation (Line(points={{-48,80},{0,80},{0,66},{18,66}},
        color={0,0,127}));
  connect(pum.port_b, con1.port_a1)
    annotation (Line(points={{-50,-40},{64,-40},{64,10}},
                                                      color={0,127,255}));
  connect(con1.port_b1, ref.ports[3]) annotation (Line(points={{76,10},{76,-60},
          {1.33333,-60}},                 color={0,127,255}));
  connect(con1.port_b2, loa1.port_a) annotation (Line(points={{64,30},{64,40},{
          60,40},{60,60}},
                        color={0,127,255}));
  connect(con1.port_a2, loa1.port_b) annotation (Line(points={{76,29.8},{76,40},
          {80,40},{80,60}}, color={0,127,255}));
  connect(fraLoa.y, loa1.u) annotation (Line(points={{-48,80},{50,80},{50,66},{58,
          66}}, color={0,0,127}));
  connect(ope.y, con.y) annotation (Line(points={{-48,40},{-40,40},{-40,20},{18,
          20}}, color={0,0,127}));
  connect(ope1.y, con1.y) annotation (Line(points={{-49,0},{50,0},{50,20},{58,20}},
        color={0,0,127}));
   annotation (experiment(
    StopTime=100,
    Tolerance=1e-6),
    __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HydronicConfigurations/Examples/ControlValves/DiversionCircuitOpenLoop.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
Secondary and valve flow resistances are not lumped in order 
to compute valve authority
</p> 
</html>"));
end DiversionCircuitOpenLoop;
