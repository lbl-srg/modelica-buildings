within Buildings.Fluid.Storage.Ice.Examples;
model Tank "Example that test the Tank model"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater (
    property_T=293.15,
    X_a=0.30) "Fluid medium";

  parameter Modelica.Units.SI.Mass SOC_start=3/4
    "Start value of ice mass in the tank";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dp_nominal=100000
    "Pressure difference";
  parameter Buildings.Fluid.Storage.Ice.Data.Tank.Experiment per(mIce_max=1/4*2846.35)
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  Buildings.Fluid.Storage.Ice.ControlledTank iceTan(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal,
    SOC_start=SOC_start,
    per=per) annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    m_flow=2*m_flow_nominal,
    use_T_in=true,
    nPorts=2)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    nPorts=2)
    annotation (Placement(transformation(extent={{86,-10},{66,10}})));
  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=500) "Flow resistance"
    annotation (Placement(transformation(extent={{36,-10},{56,10}})));

  Modelica.Blocks.Sources.CombiTimeTable TSou(
    table=[0,273.15 - 5; 3600*10,273.15 - 5;
         3600*10,273.15 + 10; 3600*11,273.15 + 10;
        3600*18,273.15 + 10; 3600*18,
        273.15 - 5], y(each unit="K", each displayUnit="degC"))
                     "Source temperature"
    annotation (Placement(transformation(extent={{-92,-6},{-72,14}})));

  Modelica.Blocks.Sources.TimeTable TSet(table=[
    0,273.15 -10;
    3600*10,273.15 + 8;
    3600*11,273.15 + 6;
    3600*20,273.15 -12;
    3600*24,273.15 +10], y(unit="K", displayUnit="degC"))
    "Table with set points for leaving water temperature which will be tracked subject to thermodynamic constraints"
    annotation (Placement(transformation(extent={{-92,30},{-72,50}})));
  Sensors.TemperatureTwoPort TOut(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=m_flow_nominal,
    tau=0) "Outlet temperature"
    annotation (Placement(transformation(extent={{8,-10},{28,10}})));
  Buildings.Fluid.Storage.Ice.Tank iceTanUnc(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal,
    SOC_start=SOC_start,
    per=per) "Uncontrolled ice tank"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  FixedResistances.PressureDrop resUnc(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=500) "Flow resistance"
    annotation (Placement(transformation(extent={{36,-50},{56,-30}})));
  Sensors.TemperatureTwoPort TOutUnc(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=m_flow_nominal,
    tau=0) "Outlet temperature"
    annotation (Placement(transformation(extent={{8,-50},{28,-30}})));
equation
  connect(sou.ports[1], iceTan.port_a)
    annotation (Line(points={{-40,-1},{-30,-1},{-30,0},{-20,0}},
                                               color={0,127,255}));
  connect(res.port_b, bou.ports[1])
    annotation (Line(points={{56,0},{62,0},{62,-1},{66,-1}},
                                             color={0,127,255}));
  connect(TSou.y[1], sou.T_in) annotation (Line(points={{-71,4},{-62,4}},
                    color={0,0,127}));
  connect(TSet.y, iceTan.TSet) annotation (Line(points={{-71,40},{-28,40},{-28,
          6},{-22,6}}, color={0,0,127}));
  connect(iceTan.port_b, TOut.port_a)
    annotation (Line(points={{0,0},{8,0}}, color={0,127,255}));
  connect(TOut.port_b, res.port_a)
    annotation (Line(points={{28,0},{36,0}}, color={0,127,255}));
  connect(sou.ports[2], iceTanUnc.port_a) annotation (Line(points={{-40,1},{-26,
          1},{-26,-40},{-20,-40}}, color={0,127,255}));
  connect(iceTanUnc.port_b, TOutUnc.port_a)
    annotation (Line(points={{0,-40},{8,-40}}, color={0,127,255}));
  connect(TOutUnc.port_b, resUnc.port_a)
    annotation (Line(points={{28,-40},{36,-40}}, color={0,127,255}));
  connect(resUnc.port_b, bou.ports[2]) annotation (Line(points={{56,-40},{60,
          -40},{60,-2},{66,-2},{66,1}}, color={0,127,255}));
  annotation (
    experiment(
      StartTime=0,
      StopTime=86400,
      Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Ice/Examples/Tank.mos"
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
end Tank;
