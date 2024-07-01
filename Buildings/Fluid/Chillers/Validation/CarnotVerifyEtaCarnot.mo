within Buildings.Fluid.Chillers.Validation;
model CarnotVerifyEtaCarnot
  "Test model to verify the Carnot effectiveness computation for non-zero approach temperatures"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model";

  parameter Real etaCarnot_nominal=0.315046
    "Carnot effectiveness (=COP/COP_Carnot) used if use_eta_Carnot_nominal = true";

  parameter Modelica.Units.SI.TemperatureDifference TAppCon_nominal=2
    "Temperature difference between refrigerant and working fluid outlet in condenser";

  parameter Modelica.Units.SI.TemperatureDifference TAppEva_nominal=2
    "Temperature difference between refrigerant and working fluid outlet in evaporator";

  parameter Real COP_nominal = etaCarnot_nominal * (TEva_nominal-TAppEva_nominal)/
    (TCon_nominal + TAppCon_nominal - (TEva_nominal-TAppEva_nominal))  "Coefficient of performance";

  parameter Modelica.Units.SI.Temperature TCon_nominal=273.15 + 30
    "Nominal condenser temperature";

  parameter Modelica.Units.SI.Temperature TEva_nominal=273.15 + 5
    "Nominal evaporator temperature";

  parameter Modelica.Units.SI.HeatFlowRate QEva_flow_nominal=-10E3
    "Nominal evaporator heat flow rate (QEva_flow_nominal < 0)";

  parameter Modelica.Units.SI.HeatFlowRate QCon_flow_nominal=-QEva_flow_nominal
      *(1 + 1/COP_nominal)
    "Nominal condenser heat flow rate (QCon_flow_nominal > 0)";

  parameter Modelica.Units.SI.TemperatureDifference dTEva_nominal=-10
    "Temperature difference evaporator outlet-inlet";

  parameter Modelica.Units.SI.TemperatureDifference dTCon_nominal=10
    "Temperature difference condenser outlet-inlet";

  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal=QCon_flow_nominal/
      cp_default/dTCon_nominal "Nominal mass flow rate at condenser";

  parameter Modelica.Units.SI.MassFlowRate mEva_flow_nominal=QEva_flow_nominal/
      cp_default/dTEva_nominal "Nominal mass flow rate of evaporator";

  final parameter Modelica.Units.SI.SpecificHeatCapacity cp_default=
      Medium.specificHeatCapacityCp(Medium.setState_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default))
    "Specific heat capacity of medium 1 at default medium state";

  Carnot_TEva chi_TEva(
    dp1_nominal=0,
    dp2_nominal=0,
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    QEva_flow_nominal=QEva_flow_nominal,
    dTEva_nominal=dTEva_nominal,
    dTCon_nominal=dTCon_nominal,
    m1_flow_nominal=mCon_flow_nominal,
    m2_flow_nominal=mEva_flow_nominal,
    show_T=true,
    TCon_nominal=TCon_nominal,
    TEva_nominal=TEva_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    etaCarnot_nominal=etaCarnot_nominal,
    TAppCon_nominal=TAppCon_nominal,
    TAppEva_nominal=TAppEva_nominal)
    "Chiller with evaporator leaving water temperature as set point"
    annotation (Placement(transformation(extent={{-8,40},{12,60}})));

  Sources.MassFlowSource_T bouCon(
    nPorts=1,
    redeclare package Medium = Medium,
    m_flow=mCon_flow_nominal,
    T=TCon_nominal - QCon_flow_nominal/cp_default/mCon_flow_nominal)
    "Boundary condition for condenser"
    annotation (Placement(transformation(extent={{-80,46},{-60,66}})));
  Sources.MassFlowSource_T bouEva(
    redeclare package Medium = Medium,
    nPorts=1,
    m_flow=mEva_flow_nominal,
    T=TEva_nominal - QEva_flow_nominal/cp_default/mEva_flow_nominal)
    "Boundary condition for evaporator"
    annotation (Placement(transformation(extent={{80,20},{60,40}})));

  Modelica.Blocks.Sources.Constant TEvaLvg(k=273.15 + 5)
    "Leaving water temperature"
    annotation (Placement(transformation(extent={{-50,70},{-30,90}})));
  Sources.Boundary_pT bou(
    nPorts=1,
    redeclare package Medium = Medium)
    "Pressure boundary condition"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Sources.Boundary_pT bou1(
    nPorts=1,
    redeclare package Medium = Medium)
    "Pressure boundary condition"
    annotation (Placement(transformation(extent={{80,60},{60,80}})));

  Carnot_y chi_y(
    dp1_nominal=0,
    dp2_nominal=0,
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    dTEva_nominal=dTEva_nominal,
    dTCon_nominal=dTCon_nominal,
    m1_flow_nominal=mCon_flow_nominal,
    m2_flow_nominal=mEva_flow_nominal,
    show_T=true,
    TCon_nominal=TCon_nominal,
    TEva_nominal=TEva_nominal,
    P_nominal=QEva_flow_nominal + QCon_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    etaCarnot_nominal=etaCarnot_nominal,
    TAppCon_nominal=TAppCon_nominal,
    TAppEva_nominal=TAppEva_nominal)
    "Chiller with control signal as set point"
    annotation (Placement(transformation(extent={{-8,-50},{12,-30}})));
  Sources.MassFlowSource_T bouCon1(
    nPorts=1,
    redeclare package Medium = Medium,
    m_flow=mCon_flow_nominal,
    T=TCon_nominal - QCon_flow_nominal/cp_default/mCon_flow_nominal)
    "Boundary condition for condenser"
    annotation (Placement(transformation(extent={{-80,-44},{-60,-24}})));
  Sources.MassFlowSource_T bouEva1(
    redeclare package Medium = Medium,
    nPorts=1,
    m_flow=mEva_flow_nominal,
    T=TEva_nominal - QEva_flow_nominal/cp_default/mEva_flow_nominal)
    "Boundary condition for evaporator"
    annotation (Placement(transformation(extent={{80,-70},{60,-50}})));
  Modelica.Blocks.Sources.Constant y(k=1) "Control signal"
    annotation (Placement(transformation(extent={{-50,-20},{-30,0}})));
  Sources.Boundary_pT bou2(
    nPorts=1,
    redeclare package Medium = Medium)
    "Pressure boundary condition"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Sources.Boundary_pT bou3(
    nPorts=1,
    redeclare package Medium = Medium)
    "Pressure boundary condition"
    annotation (Placement(transformation(extent={{80,-30},{60,-10}})));

equation
  connect(bouCon.ports[1], chi_TEva.port_a1)
    annotation (Line(points={{-60,56},{-60,56},{-8,56}}, color={0,127,255}));
  connect(TEvaLvg.y, chi_TEva.TSet) annotation (Line(points={{-29,80},{-20,80},{
          -20,59},{-10,59}}, color={0,0,127}));
  connect(bou.ports[1], chi_TEva.port_b2) annotation (Line(points={{-60,30},{-34,
          30},{-34,44},{-8,44}}, color={0,127,255}));
  connect(chi_TEva.port_a2, bouEva.ports[1]) annotation (Line(points={{12,44},{20,
          44},{40,44},{40,30},{60,30}}, color={0,127,255}));
  connect(bou1.ports[1], chi_TEva.port_b1) annotation (Line(points={{60,70},{40,
          70},{40,56},{12,56}}, color={0,127,255}));
  connect(bouCon1.ports[1], chi_y.port_a1) annotation (Line(points={{-60,-34},{-60,
          -34},{-8,-34}}, color={0,127,255}));
  connect(bou2.ports[1], chi_y.port_b2) annotation (Line(points={{-60,-60},{-44,
          -60},{-44,-46},{-8,-46}}, color={0,127,255}));
  connect(chi_y.port_a2, bouEva1.ports[1]) annotation (Line(points={{12,-46},{10,
          -46},{30,-46},{30,-60},{60,-60}}, color={0,127,255}));
  connect(bou3.ports[1], chi_y.port_b1) annotation (Line(points={{60,-20},{30,-20},
          {30,-34},{12,-34}}, color={0,127,255}));
  connect(y.y, chi_y.y) annotation (Line(points={{-29,-10},{-20,-10},{-20,-31},{
          -10,-31}}, color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Chillers/Validation/CarnotVerifyEtaCarnot.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This example verifies that the coefficient of performance is identical
to the one specified for the nominal operating point if the current
operating conditions are the same as the nominal conditions.
It thus verifies the correct deviation of the nominal parameters
for the situation where the Carnot effectiveness is specified as a parameter.
</p>
</html>", revisions="<html>
<ul>
<li>
June 15, 2017, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end CarnotVerifyEtaCarnot;
