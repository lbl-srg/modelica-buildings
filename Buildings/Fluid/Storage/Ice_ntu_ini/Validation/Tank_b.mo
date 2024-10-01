within Buildings.Fluid.Storage.Ice_ntu_ini.Validation;
model Tank_b "Example that test the tank model"
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

  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    m_flow=2*m_flow_nominal,
    T=268.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    nPorts=1)
    annotation (Placement(transformation(extent={{86,-10},{66,10}})));

  Buildings.Fluid.Storage.Ice_ntu_ini.Tank iceTanUnc(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal,
    SOC_start=SOC_start,
    redeclare Buildings.Fluid.Storage.Ice_ntu_ini.Data.Tank.Experiment per,
    energyDynamicsHex=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Uncontrolled ice tank"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  FixedResistances.PressureDrop resUnc(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=500) "Flow resistance"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
equation
  connect(resUnc.port_b, bou.ports[1]) annotation (Line(points={{40,0},{66,0}},
                                        color={0,127,255}));
  connect(iceTanUnc.port_b, resUnc.port_a)
    annotation (Line(points={{0,0},{20,0}},      color={0,127,255}));
  connect(iceTanUnc.port_a, sou.ports[1]) annotation (Line(points={{-20,0},{-40,
          0}},                         color={0,127,255}));
  annotation (
    experiment(
      StartTime=0,
      StopTime=86400,
      Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Ice/Validation/Tank.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>
This example is to verify the ice tank model <a href=\"modelica://Buildings.Fluid.Storage.Ice\">Buildings.Fluid.Storage.Ice</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
December 14, 2021, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Tank_b;
