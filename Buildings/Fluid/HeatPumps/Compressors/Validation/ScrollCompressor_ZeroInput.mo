within Buildings.Fluid.HeatPumps.Compressors.Validation;
model ScrollCompressor_ZeroInput
  extends Modelica.Icons.Example;
  Buildings.HeatTransfer.Sources.FixedTemperature eva(T=253.15)
    "Evaporating temperature"
    annotation (Placement(transformation(extent={{-82,-10},{-62,10}})));
  Buildings.HeatTransfer.Sources.FixedTemperature con(T=323.15)
    "Condensing temperature"
    annotation (Placement(transformation(extent={{84,-10},{64,10}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloEva
    "Evaporator heat flow rate sensor"
    annotation (Placement(transformation(extent={{-46,-10},{-26,10}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloCon
    "Condenser heat flow rate sensor"
    annotation (Placement(transformation(extent={{28,-10},{48,10}})));
  Buildings.Fluid.HeatPumps.Compressors.ScrollCompressor com(
    redeclare package ref = Buildings.Media.Refrigerants.R410A,
    V_flow_nominal=0.003,
    leaCoe=0.005,
    etaEle=0.85,
    PLos=500,
    dTSup=3,
    volRat=2.1) "Scroll compressor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Constant on(k=0) "Compressor control signal"
    annotation (Placement(transformation(extent={{-16,28},{4,48}})));
equation
  connect(eva.port, heaFloEva.port_a)
    annotation (Line(points={{-62,0},{-46,0}}, color={191,0,0}));
  connect(heaFloCon.port_b, con.port)
    annotation (Line(points={{48,0},{56,0},{64,0}}, color={191,0,0}));
  connect(com.port_b, heaFloCon.port_a)
    annotation (Line(points={{10,0},{19,0},{28,0}}, color={191,0,0}));
  connect(heaFloEva.port_b, com.port_a)
    annotation (Line(points={{-26,0},{-10,0}}, color={191,0,0}));
  connect(on.y, com.y)
    annotation (Line(points={{5,38},{6,38},{6,11}}, color={0,0,127}));
  annotation (    __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/Compressors/Validation/ScrollCompressor_ZeroInput.mos"
        "Simulate and plot"),
    experiment(
      Tolerance=1e-6, StopTime=100),
    Documentation(info="<html>
<p>
Model that demonstrates the use of the ScrollCompressor model.
</p>
<p>
The compressor power, condenser heat transfer rate and evaporator heat transfer
rate are calculated for zero control input to compressor.
</p>
</html>", revisions="<html>
<ul>
<li>
December 5, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end ScrollCompressor_ZeroInput;
