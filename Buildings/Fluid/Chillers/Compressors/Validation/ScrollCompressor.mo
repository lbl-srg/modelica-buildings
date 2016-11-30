within Buildings.Fluid.Chillers.Compressors.Validation;
model ScrollCompressor
  extends Modelica.Icons.Example;
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature eva(T=253.15)
    annotation (Placement(transformation(extent={{-82,-10},{-62,10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature con(T=323.15)
    annotation (Placement(transformation(extent={{84,-10},{64,10}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloEva
    annotation (Placement(transformation(extent={{-46,-10},{-26,10}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloCon
    annotation (Placement(transformation(extent={{28,-10},{48,10}})));
  Buildings.Fluid.Chillers.Compressors.ScrollCompressor com(
    redeclare package ref =
        Buildings.Fluid.Chillers.Compressors.Refrigerants.R410A,
    v_flow=0.003,
    leaCoe=0.005,
    etaEle=0.85,
    PLos=500,
    dTSup=3,
    volRat=2.1,
    enable_variable_speed=false)
             annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Constant          on(k=1)
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
  connect(on.y,com.y)
    annotation (Line(points={{5,38},{6,38},{6,11}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Chillers/Compressors/Validation/ScrollCompressor.mos"
        "Simulate and plot"),
    experiment(
      StopTime=100),
    Documentation(info="<html>
<p>
Model that demonstrates the use of the ScrollCompressor model.
</p>
<p>
The compressor power, condenser heat transfer rate and evaporator heat transfer rate are calculated for given refrigerant temperatures.
</p>
</html>", revisions="<html>
<ul>
<li>
October 17, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end ScrollCompressor;
