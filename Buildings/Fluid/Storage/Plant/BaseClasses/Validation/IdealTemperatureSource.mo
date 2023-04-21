within Buildings.Fluid.Storage.Plant.BaseClasses.Validation;
model IdealTemperatureSource "Validation model for IdealTemperatureSource"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model for CHW";

  parameter Modelica.Units.SI.Temperature TSet = 12 + 273.15
    "Set point temperature";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal = 1
    "Nominal mass flow rate";

  Buildings.Fluid.Storage.Plant.BaseClasses.IdealTemperatureSource ideTemSou(
    redeclare final package Medium=Medium,
    m_flow_nominal=m_flow_nominal,
    TSet=TSet) "Ideal temperature source"
    annotation (Placement(transformation(extent={{10,0},{30,20}})));
  Buildings.Fluid.Sources.MassFlowSource_T bou1(
    redeclare final package Medium = Medium,
    m_flow=m_flow_nominal,
    final use_T_in=true,
    nPorts=1) "Mass flow source with prescribed temperature"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Modelica.Blocks.Sources.Sine sin(
    amplitude=3,
    f=3,
    offset=TSet) "Temperature of the flow source"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.Fluid.Sources.Boundary_pT bou2(redeclare final package Medium =
        Medium, nPorts=1) "Pressure boundary"
    annotation (Placement(transformation(extent={{100,0},{80,20}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort T_a(
    redeclare final package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    tau=0.01,
    T_start=TSet) "Inlet temperature"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort T_b(
    redeclare final package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    tau=0.01,
    T_start=TSet) "Outlet temperature"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
equation
  connect(sin.y, bou1.T_in) annotation (Line(points={{-79,10},{-70,10},{-70,14},
          {-62,14}}, color={0,0,127}));
  connect(bou1.ports[1], T_a.port_a)
    annotation (Line(points={{-40,10},{-20,10}}, color={0,127,255}));
  connect(T_a.port_b, ideTemSou.port_a)
    annotation (Line(points={{0,10},{10,10}}, color={0,127,255}));
  connect(bou2.ports[1], T_b.port_b)
    annotation (Line(points={{80,10},{60,10}}, color={0,127,255}));
  connect(T_b.port_a, ideTemSou.port_b)
    annotation (Line(points={{40,10},{30,10}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Plant/BaseClasses/Validation/IdealTemperatureSource.mos"
        "Simulate and plot"),
   Documentation(info="<html>
<p>
This model validates
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.BaseClasses.IdealTemperatureSource\">
Buildings.Fluid.Storage.Plant.BaseClasses.IdealTemperatureSource</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 8, 2023 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end IdealTemperatureSource;
