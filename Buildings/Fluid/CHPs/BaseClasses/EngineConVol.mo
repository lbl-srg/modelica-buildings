within Buildings.Fluid.CHPs.BaseClasses;
model EngineConVol "Heat exchange within the engine control volume"
  extends Modelica.Blocks.Icons.Block;
  replaceable parameter Buildings.Fluid.CHPs.Data.Generic per
    "Performance data"
    annotation (Placement(transformation(extent={{-98,-98},{-78,-78}})));
  replaceable package Medium = Buildings.Media.Water "Medium model";
  parameter Modelica.SIunits.Temperature TEngIni "Initial engine temperature";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a TRoo
    "Heat port for room temperature" annotation (Placement(transformation(
          extent={{-116,50},{-96,70}}), iconTransformation(extent={{-120,50},{-100,
            70}})));
  Modelica.Blocks.Interfaces.RealInput QGen(unit="W")
    "Heat generation within the engine" annotation (Placement(transformation(
          extent={{-140,-20},{-100,20}}), iconTransformation(extent={{-120,-10},
            {-100,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a QWat
    "Heat transfer to water side" annotation (Placement(transformation(extent={{
            -116,-70},{-96,-50}}), iconTransformation(extent={{-120,-70},{-100,-50}})));
  Modelica.Blocks.Interfaces.RealOutput TEng(unit="K") "Engine temperature"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));

protected
  constant Modelica.SIunits.Density rhoWat=1000 "Water density";
  constant Modelica.SIunits.SpecificHeatCapacity cWat=4180
    "Water specific heat";
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor UAhx(G=per.UAhx)
    "Thermal conductance between engine and cooling water volume"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor MCeng(C=per.MCeng, T(fixed=
          true, start=TEngIni))
    "Thermal capacitance of the engine control volume"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor UAlos(G=per.UAlos)
    "Thermal conductance between the engine and surroundings"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow QGen1
    "Heat generation within the engine"
    annotation (Placement(transformation(extent={{-18,-10},{2,10}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TEng_1
    "Engine temperature" annotation (Placement(visible=true, transformation(
        origin={78,0},
        extent={{-10,-10},{10,10}},
        rotation=0)));

equation
  connect(MCeng.port, UAhx.port_b) annotation (Line(points={{50,0},{20,0},{20,-60},
          {0,-60}}, color={191,0,0}));
  connect(QGen, QGen1.Q_flow)
    annotation (Line(points={{-120,0},{-18,0}}, color={0,0,127}));
  connect(UAlos.port_b, MCeng.port)
    annotation (Line(points={{0,60},{20,60},{20,0},{50,0}}, color={191,0,0}));
  connect(TEng_1.port, MCeng.port)
    annotation (Line(points={{68,0},{50,0}}, color={191,0,0}));
  connect(UAlos.port_a, TRoo)
    annotation (Line(points={{-20,60},{-106,60}}, color={191,0,0}));
  connect(UAhx.port_a, QWat)
    annotation (Line(points={{-20,-60},{-106,-60}}, color={191,0,0}));
  connect(QGen1.port, MCeng.port)
    annotation (Line(points={{2,0},{50,0}}, color={191,0,0}));
  connect(TEng_1.T, TEng)
    annotation (Line(points={{88,0},{110,0}}, color={0,0,127}));
  annotation (
    defaultComponentName="eng",
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
The model defines the dynamic behavior of the CHP thermal mass (engine block, encapsulated working fluid, and internal heat exchange equipment) using a single, engine control volume. 
The thermal energy stored within this volume is quantified using an aggregate thermal capacitance <i>per.MCeng</i> and an equivalent average engine temperature <i>TEng</i>. 
The heat transfer between the engine and the cooling water control volume is quantified using the overall thermal conductance <i>UAhx</i>, 
while the heat loss to the surroundings is quantified using the overall thermal conductance <i>UAlos</i>. 
</p>
</html>", revisions="<html>
<ul>
<li>
June 01, 2019 by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end EngineConVol;
