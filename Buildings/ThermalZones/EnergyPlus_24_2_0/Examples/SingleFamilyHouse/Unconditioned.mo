within Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SingleFamilyHouse;
model Unconditioned
  "Example model with one unconditoned zone simulated in Modelica, and the other two unconditioned zones simulated in EnergyPlus"
  extends Modelica.Icons.Example;
  package Medium=Buildings.Media.Air
    "Medium model";
  inner Buildings.ThermalZones.EnergyPlus_24_2_0.Building building(
    idfName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/Data/ThermalZones/EnergyPlus_24_2_0/Examples/SingleFamilyHouse_TwoSpeed_ZoneAirBalance/SingleFamilyHouse_TwoSpeed_ZoneAirBalance.idf"),
    epwName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw"),
    weaName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
    usePrecompiledFMU=false,
    computeWetBulbTemperature=false)
    "Building model"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  parameter Modelica.Units.SI.Volume VRoo=453.1 "Room volume";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=VRoo*1.2*0.3/3600
    "Nominal mass flow rate";
  Buildings.ThermalZones.EnergyPlus_24_2_0.ThermalZone zon(
    redeclare package Medium=Medium,
    zoneName="LIVING ZONE",
    nPorts=2)
    "Thermal zone"
    annotation (Placement(transformation(extent={{0,-20},{40,20}})));
  Buildings.Fluid.FixedResistances.PressureDrop duc(
    redeclare package Medium=Medium,
    allowFlowReversal=false,
    linearized=true,
    from_dp=true,
    dp_nominal=100,
    m_flow_nominal=m_flow_nominal)
    "Duct resistance (to decouple room and outside pressure)"
    annotation (Placement(transformation(extent={{10,-50},{-10,-30}})));
  Buildings.Fluid.Sources.MassFlowSource_WeatherData bou(
    redeclare package Medium=Medium,
    nPorts=1,
    m_flow=m_flow_nominal)
    "Boundary condition"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Buildings.Fluid.Sources.Boundary_pT freshAir(
    redeclare package Medium=Medium,
    nPorts=1)
    "Boundary condition"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Modelica.Blocks.Sources.Constant qIntGai[3](
    each k=0)
    "Internal heat gains, set to zero because these are modeled in EnergyPlus"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));

equation
  connect(freshAir.ports[1],duc.port_b)
    annotation (Line(points={{-20,-40},{-10,-40}},color={0,127,255}));
  connect(duc.port_a,zon.ports[1])
    annotation (Line(points={{10,-40},{18,-40},{18,-19.1}},color={0,127,255}));
  connect(bou.ports[1],zon.ports[2])
    annotation (Line(points={{-20,-80},{22,-80},{22,-19.1}},color={0,127,255}));
  connect(zon.qGai_flow,qIntGai.y)
    annotation (Line(points={{-2,10},{-19,10}},color={0,0,127}));
  connect(building.weaBus,bou.weaBus)
    annotation (Line(points={{-60,-80},{-50,-80},{-50,-79.8},{-40,-79.8}},color={255,204,51},thickness=0.5));
  annotation (
    Documentation(
      info="<html>
<p>
This example models the living room as an unconditioned zone in Modelica.
The living room is connected to a fresh air supply and exhaust.
The heat balance of the air of the other two thermal zones, i.e.,
the attic and the garage, are modeled in EnergyPlus.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 1, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus_24_2_0/Examples/SingleFamilyHouse/Unconditioned.mos" "Simulate and plot"),
    experiment(
      StopTime=432000,
      Tolerance=1e-06));
end Unconditioned;
