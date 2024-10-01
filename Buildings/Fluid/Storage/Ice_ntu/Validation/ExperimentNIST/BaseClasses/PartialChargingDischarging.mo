within Buildings.Fluid.Storage.Ice_ntu.Validation.ExperimentNIST.BaseClasses;
partial model PartialChargingDischarging "Base example"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater (
    property_T=293.15,
    X_a=0.30);
  parameter String fileName "Calibration data file";

  parameter Real SOC_start=0.90996030
    "Start value of state of charge";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dp_nominal=100000
    "Pressure difference";
  parameter Buildings.Fluid.Storage.Ice_ntu.Data.Tank.Generic per(
    mIce_max=2846.35,
    coeCha={1.76953858E-04,0,0,0,0,0},
    dtCha=10,
    coeDisCha={5.54E-05,-1.45679E-04,9.28E-05,1.126122E-03,-1.1012E-03,
        3.00544E-04},
    dtDisCha=10) "Performance curve obtained from onsite experiment"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  Buildings.Fluid.Storage.Ice_ntu.ControlledTank iceTan(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal,
    SOC_start=SOC_start,
    per=per,
    energyDynamicsHex=Modelica.Fluid.Types.Dynamics.FixedInitial) "Ice tank"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) "Mass flow source"
    annotation (Placement(transformation(extent={{-36,-10},{-16,10}})));
  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    nPorts=1)
    "Pressure source"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=270,
        origin={80,-50})));
  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=500)
    "Flow resistance"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={80,-20})));
  Modelica.Blocks.Sources.CombiTimeTable dat(
    tableOnFile=true,
    tableName="tab",
    columns=2:5,
    fileName=fileName)
    "Flowrate measurements"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  Modelica.Thermal.HeatTransfer.Celsius.ToKelvin TIn
    "Conversion from Celsius to Kelvin"
    annotation (Placement(transformation(extent={{-74,24},{-54,44}})));
  Modelica.Thermal.HeatTransfer.Celsius.ToKelvin TOutSet
    "Outlet temperature in Kelvin"
    annotation (Placement(transformation(extent={{-62,-30},{-42,-10}})));

  Modelica.Blocks.Math.Add TSet "Temperature setpoint"
    annotation (Placement(transformation(extent={{-30,-60},{-10,-40}})));
  Modelica.Blocks.Sources.Constant offSet(k=0) "An offset for setpoint control"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

  Sensors.TemperatureTwoPort TOut(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=m_flow_nominal,
    tau=0) "Tank outlet temperature"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
equation
  connect(sou.ports[1], iceTan.port_a)
    annotation (Line(points={{-16,0},{10,0}},  color={0,127,255}));
  connect(res.port_b, bou.ports[1])
    annotation (Line(points={{80,-30},{80,-40}},
                                             color={0,127,255}));
  connect(dat.y[3], sou.m_flow_in) annotation (Line(points={{-59,70},{-46,70},
          {-46,8},{-38,8}},
                       color={0,0,127}));
  connect(dat.y[1], TIn.Celsius) annotation (Line(points={{-59,70},{-52,70},{
          -52,48},{-80,48},{-80,34},{-76,34}},
                                           color={0,0,127}));
  connect(TIn.Kelvin, sou.T_in) annotation (Line(points={{-53,34},{-48,34},{
          -48,4},{-38,4}},
                       color={0,0,127}));
  connect(dat.y[2], TOutSet.Celsius) annotation (Line(points={{-59,70},{-52,70},
          {-52,48},{-80,48},{-80,-20},{-64,-20}}, color={0,0,127}));
  connect(TOutSet.Kelvin, TSet.u1) annotation (Line(points={{-41,-20},{-36,-20},
          {-36,-44},{-32,-44}}, color={0,0,127}));
  connect(offSet.y, TSet.u2) annotation (Line(points={{-59,-50},{-42,-50},{
          -42,-56},{-32,-56}},
                      color={0,0,127}));
  connect(TSet.y, iceTan.TSet) annotation (Line(points={{-9,-50},{-2,-50},{-2,
          6},{8,6}}, color={0,0,127}));
  connect(iceTan.port_b, TOut.port_a)
    annotation (Line(points={{30,0},{40,0}}, color={0,127,255}));
  connect(TOut.port_b, res.port_a)
    annotation (Line(points={{60,0},{80,0},{80,-10}}, color={0,127,255}));
  annotation (
    Documentation(info="<html>
<p>
Basic model that is used to validate the tank model.
The performance data record <code>per</code> contains the data
obtained from experiments of Ojas et al., 2020, and used by Guowen et al., 2021.
</p>
<h4>Reference</h4>
<p>
Pradhan, Ojas, et.al. <i>Development and Validation of a Simulation Testbed for the Intelligent Building Agents Laboratory (IBAL) using TRNSYS.</i>
ASHRAE Transactions 126 (2020): 458-466.
</p>
<p>
Li, Guowen, et al. <i>An Ice Storage Tank Modelica Model: Implementation and Validation.</i> Modelica Conferences. 2021.
<a href=\"https://doi.org/10.3384/ecp21181177\">doi:10.3384/ecp21181177</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
December 14, 2021, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialChargingDischarging;
