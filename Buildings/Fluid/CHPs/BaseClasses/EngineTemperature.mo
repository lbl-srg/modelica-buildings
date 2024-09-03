within Buildings.Fluid.CHPs.BaseClasses;
model EngineTemperature "Heat exchange within the engine control volume"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.Units.SI.ThermalConductance UAHex
    "Thermal conductance between the engine and cooling water";
  parameter Modelica.Units.SI.ThermalConductance UALos
    "Thermal conductance between the engine and surroundings";
  parameter Modelica.Units.SI.HeatCapacity capEng
    "Thermal capacitance of the engine control volume";
  parameter Modelica.Units.SI.Temperature TEngIni "Initial engine temperature";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a TRoo
    "Heat port for room temperature"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}}),
      iconTransformation(extent={{-110,48},{-90,68}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput QGen_flow(final unit="W")
    "Heat generation rate within the engine" annotation (Placement(
    transformation(extent={{-140,-20},{-100,20}}), iconTransformation(
      extent={{-140,-20},{-100,20}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a TWat
    "Heat port for water volume temperature"
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}}),
      iconTransformation(extent={{-110,-70},{-90,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TEng(
    final unit="K",
    displayUnit="degC") "Engine temperature"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  constant Modelica.Units.SI.Density rhoWat=1000 "Water density";
  constant Modelica.Units.SI.SpecificHeatCapacity cWat=4180
    "Water specific heat";
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theConHX(
    final G=UAHex)
    "Thermal conductance between engine and cooling water volume"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor capTheEng(
    final C=capEng, T(fixed=true, start=TEngIni))
    "Thermal capacitance of the engine control volume"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conTheLos(
    final G=UALos)
    "Thermal conductance between the engine and surroundings"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow QGen1
    "Heat generation within the engine"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor engTem
    "Engine temperature"
    annotation (Placement(visible=true, transformation(origin={80,0},
      extent={{-10,-10},{10,10}}, rotation=0)));
equation
  connect(capTheEng.port, theConHX.port_b)
    annotation (Line(points={{50,0},{20,0}, {20,-60},{0,-60}}, color={191,0,0}));
  connect(QGen_flow, QGen1.Q_flow)
    annotation (Line(points={{-120,0},{-20,0}}, color={0,0,127}));
  connect(conTheLos.port_b, capTheEng.port)
    annotation (Line(points={{0,60},{20,60},{20,0},{50,0}}, color={191,0,0}));
  connect(engTem.port, capTheEng.port)
    annotation (Line(points={{70,0},{50,0}}, color={191,0,0}));
  connect(conTheLos.port_a, TRoo)
    annotation (Line(points={{-20,60},{-100,60}}, color={191,0,0}));
  connect(theConHX.port_a, TWat)
    annotation (Line(points={{-20,-60},{-100,-60}}, color={191,0,0}));
  connect(QGen1.port, capTheEng.port)
    annotation (Line(points={{0,0},{50,0}}, color={191,0,0}));
  connect(engTem.T, TEng)
    annotation (Line(points={{90,0},{120,0}}, color={0,0,127}));
annotation (
  defaultComponentName="eng",
  Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Polygon(
          points={{0,75},{-20,71},{-40,65},{-52,51},{-58,43},{-68,33},{-72,21},{
              -76,7},{-78,-7},{-76,-23},{-76,-35},{-76,-45},{-70,-57},{-64,-65},
              {-48,-69},{-30,-75},{-18,-75},{-2,-77},{8,-81},{22,-81},{32,-79},{
              42,-73},{54,-67},{56,-65},{66,-53},{68,-45},{70,-43},{72,-27},{76,
              -13},{78,-5},{78,11},{74,23},{66,33},{54,41},{44,49},{36,65},{26,73},
              {0,75}},
          lineColor={160,160,164},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-58,43},{-68,33},{-72,21},{-76,7},{-78,-7},{-76,-23},{-76,-35},
              {-76,-45},{-70,-57},{-64,-65},{-48,-69},{-30,-75},{-18,-75},{-2,-77},
              {8,-81},{22,-81},{32,-79},{42,-73},{54,-67},{42,-69},{40,-69},{30,
              -71},{20,-73},{18,-73},{10,-73},{2,-69},{-12,-65},{-22,-65},{-30,-63},
              {-40,-57},{-50,-47},{-56,-35},{-58,-27},{-58,-17},{-60,-5},{-60,3},
              {-60,15},{-58,25},{-56,27},{-52,35},{-48,43},{-44,53},{-40,65},{-58,
              43}},
          fillColor={160,160,164},
          fillPattern=FillPattern.Solid)}),
Documentation(info="<html>
<p>
The model defines the dynamic behavior of the CHP thermal mass (i.e. engine block,
encapsulated working fluid, and internal heat exchange equipment) using a single,
engine control volume.
The thermal energy stored within this volume is quantified using an aggregate
thermal capacitance <code>capEng</code> and an equivalent average engine temperature
<code>TEng</code>.
The heat transfer between the engine and the cooling water control volume is
quantified using the overall thermal conductance <code>UAHex</code>,
while the heat loss to the surroundings is quantified using the overall thermal
conductance <code>UALos</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 1, 2019, by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end EngineTemperature;
