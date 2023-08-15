within Buildings.Fluid.Storage.Ice.Examples;
model TankLosses "Example that test the tank model"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater (
    property_T=273.15-1,
    X_a=0.30) "Fluid medium";
  parameter Modelica.Units.SI.MassFlowRate m_flow_loss = 0.0001*m_flow_nominal;
  parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
      T=Medium.T_default, p=Medium.p_default, X=Medium.X_default);
  parameter Modelica.Units.SI.Density rho_default=Medium.density(sta_default)
    "Density, used to compute fluid volume";
  parameter Modelica.Units.SI.Length rTan=(m_flow_nominal/rho_default*tauHex/(4*Modelica.Constants.pi))^(1/3) "Height of tank (without insulation)";
  parameter Modelica.Units.SI.Length dIns=0.2 "Thickness of insulation";
  parameter Modelica.Units.SI.ThermalConductivity kIns=1
    "Specific heat conductivity of insulation";
  parameter Modelica.Units.SI.Mass SOC_start=0.99
    "Start value of ice mass in the tank";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=100
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dp_nominal=100000
    "Pressure difference";
  parameter Buildings.Fluid.Storage.Ice.Data.Tank.Generic per(
    mIce_max=1/4*2846.35,
    coeCha={1.76953858E-04,0,0,0,0,0},
    dtCha=10,
    coeDisCha={5.54E-05,-1.45679E-04,9.28E-05,1.126122E-03,-1.1012E-03,3.00544E-04},
    dtDisCha=10)
    "Tank performance data"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    m_flow=0,
    use_T_in=true,
    nPorts=1)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    nPorts=2)
    annotation (Placement(transformation(extent={{86,-10},{66,10}})));

  Modelica.Blocks.Sources.CombiTimeTable TSou(table=[0,273.15 - 5; 3600*10,273.15
         - 5; 3600*10,273.15 - 5; 3600*11,273.15 - 5; 3600*18,273.15 - 5; 3600*18,
        273.15 - 5],
      y(each unit="K",
        each displayUnit="degC"))
      "Source temperature"
    annotation (Placement(transformation(extent={{-92,-6},{-72,14}})));

  Buildings.Fluid.Storage.Ice.Tank iceTanUnc(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal,
    T_start=273.14,
    SOC_start=SOC_start,
    per=per,
    energyDynamicsHex=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tauHex=tauHex)
             "Uncontrolled ice tank"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  FixedResistances.PressureDrop resUnc(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=500) "Flow resistance"
    annotation (Placement(transformation(extent={{26,-12},{46,8}})));
  FixedResistances.PressureDrop resUnc1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=500) "Flow resistance"
    annotation (Placement(transformation(extent={{34,-70},{54,-50}})));
  parameter Modelica.Units.SI.Time tauHex=30
    "Time constant of working fluid through the heat exchanger at nominal flow";
  Buildings.Fluid.Storage.Ice.Tank iceTanUnc1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal,
    T_start=273.14,
    SOC_start=SOC_start,
    per=per,
    energyDynamicsHex=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tauHex=tauHex)
             "Uncontrolled ice tank"
    annotation (Placement(transformation(extent={{-26,-70},{-6,-50}})));
  FixedResistances.Junction jun1(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal*{1,-1,1},
    dp_nominal={0,0,0})
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,-38})));
  FixedResistances.Junction jun(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal*{1,-1,-1},
    dp_nominal={0,0,0})
    annotation (Placement(transformation(extent={{4,-70},{24,-50}})));
  Movers.BaseClasses.IdealSource idealSource(
    redeclare package Medium = Medium,
    m_flow_small=m_flow_loss*1e-4,
    control_m_flow=true,
    control_dp=false) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-58,-64})));
  HeatExchangers.PrescribedOutlet preOut(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_loss,
    dp_nominal=0,
    use_X_wSet=false)
    annotation (Placement(transformation(extent={{-2,-98},{-22,-78}})));
  Modelica.Blocks.Sources.Constant const(k=m_flow_loss)
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  Modelica.Blocks.Sources.Constant const1(k=273.15 + 20)
    annotation (Placement(transformation(extent={{78,-90},{58,-70}})));
  Modelica.Blocks.Sources.CombiTimeTable TSou1(table=[0,273.15 - 5; 3600*10,273.15
         - 5; 3600*10,273.15 - 5; 3600*11,273.15 - 5; 3600*18,273.15 - 5; 3600*18,
        273.15 - 5], y(each unit="K", each displayUnit="degC"))
      "Source temperature"
    annotation (Placement(transformation(extent={{-102,-30},{-82,-10}})));
  Sources.MassFlowSource_T                 sou1(
    redeclare package Medium = Medium,
    m_flow=0,
    use_T_in=true,
    nPorts=1)
    annotation (Placement(transformation(extent={{-70,-34},{-50,-14}})));
equation
  connect(TSou.y[1], sou.T_in) annotation (Line(points={{-71,4},{-62,4}},
                    color={0,0,127}));
  connect(resUnc.port_b, bou.ports[1]) annotation (Line(points={{46,-2},{48,-2},
          {48,-1},{66,-1}},             color={0,127,255}));
  connect(iceTanUnc.port_b, resUnc.port_a)
    annotation (Line(points={{10,0},{18,0},{18,-2},{26,-2}},
                                                 color={0,127,255}));
  connect(iceTanUnc.port_a, sou.ports[1]) annotation (Line(points={{-10,0},{-40,
          0}},                         color={0,127,255}));
  connect(resUnc1.port_b, bou.ports[2]) annotation (Line(points={{54,-60},{60,-60},
          {60,1},{66,1}},color={0,127,255}));
  connect(iceTanUnc1.port_b, jun.port_1)
    annotation (Line(points={{-6,-60},{4,-60}}, color={0,127,255}));
  connect(jun.port_2, resUnc1.port_a)
    annotation (Line(points={{24,-60},{34,-60}}, color={0,127,255}));
  connect(jun1.port_2, iceTanUnc1.port_a) annotation (Line(points={{-40,-48},{-40,
          -60},{-26,-60}}, color={0,127,255}));
  connect(jun.port_3, preOut.port_a)
    annotation (Line(points={{14,-70},{14,-88},{-2,-88}}, color={0,127,255}));
  connect(preOut.port_b, idealSource.port_a) annotation (Line(points={{-22,-88},
          {-58,-88},{-58,-74}}, color={0,127,255}));
  connect(idealSource.port_b, jun1.port_3) annotation (Line(points={{-58,-54},{-58,
          -38},{-50,-38}}, color={0,127,255}));
  connect(idealSource.m_flow_in, const.y)
    annotation (Line(points={{-66,-70},{-79,-70}}, color={0,0,127}));
  connect(const1.y, preOut.TSet)
    annotation (Line(points={{57,-80},{0,-80}}, color={0,0,127}));
  connect(TSou1.y[1], sou1.T_in)
    annotation (Line(points={{-81,-20},{-72,-20}}, color={0,0,127}));
  connect(sou1.ports[1], jun1.port_1) annotation (Line(points={{-50,-24},{-46,-24},
          {-46,-22},{-40,-22},{-40,-28}}, color={0,127,255}));
  annotation (
    experiment(
      StopTime=604800,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Ice/Validation/Tank.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>
This example is to verify the ice tank model <a href=\"Buildings.Fluid.Storage.Ice\">Buildings.Fluid.Storage.Ice</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
December 14, 2021, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end TankLosses;
