within Buildings.ThermalZones.EnergyPlus.Validation.ThermalZone;
model OneZone "Validation model for one zone"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air "Medium model";

  inner Buildings.ThermalZones.EnergyPlus.Building building(
    idfName = Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/Data/ThermalZones/EnergyPlus/Validation/SingleFamilyHouse_TwoSpeed_ZoneAirBalance/SingleFamilyHouse_TwoSpeed_ZoneAirBalance.idf"),
    weaName = Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
    usePrecompiledFMU=false,
    showWeatherData=false,
    verbosity=Buildings.ThermalZones.EnergyPlus.Types.Verbosity.Verbose)
    "Building model"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  Buildings.ThermalZones.EnergyPlus.ThermalZone zon(
    redeclare package Medium = Medium,
    zoneName="LIVING ZONE",
    nPorts = 2) "Thermal zone"
    annotation (Placement(transformation(extent={{0,-20},{40,20}})));
  Buildings.Fluid.FixedResistances.PressureDrop duc(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    linearized=true,
    from_dp=true,
    dp_nominal=100,
    m_flow_nominal=47*6/3600*1.2)
    "Duct resistance (to decouple room and outside pressure)"
    annotation (Placement(transformation(extent={{10,-50},{-10,-30}})));
  Buildings.Fluid.Sources.MassFlowSource_T bou(
    redeclare package Medium = Medium,
    nPorts=1,
    m_flow=0,
    T=293.15) "Boundary condition"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Buildings.Fluid.Sources.Boundary_pT freshAir(
    redeclare package Medium = Medium,
    nPorts=1)
    "Boundary condition"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Modelica.Blocks.Sources.Constant qIntGai[3](each k=0) "Internal heat gains"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
equation
  connect(freshAir.ports[1], duc.port_b)
    annotation (Line(points={{-20,-40},{-10,-40}}, color={0,127,255}));
  connect(duc.port_a, zon.ports[1]) annotation (Line(points={{10,-40},{18,-40},
          {18,-19.1}}, color={0,127,255}));
  connect(bou.ports[1], zon.ports[2]) annotation (Line(points={{-20,-80},{22,
          -80},{22,-19.1}}, color={0,127,255}));
  connect(zon.qGai_flow, qIntGai.y)
    annotation (Line(points={{-2,10},{-19,10}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
Simple test case for one building with one thermal zone in which the room air temperature
is free floating.
</p>
</html>", revisions="<html>
<ul>
<li>
March 1, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
 __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus/Validation/ThermalZone/OneZone.mos"
        "Simulate and plot"),
experiment(
      StopTime=432000,
      Tolerance=1e-06));
end OneZone;
