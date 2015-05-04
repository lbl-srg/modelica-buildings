within Buildings.HeatTransfer.Examples;
model ConductorSingleLayer "Test model for heat conductor"
  extends Modelica.Icons.Example;
  Buildings.HeatTransfer.Conduction.SingleLayer con(A=1, material=concrete200)
         annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TB(T=293.15)
    annotation (Placement(transformation(extent={{80,0},{60,20}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TA
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Modelica.Blocks.Sources.Step step(
    height=10,
    offset=293.15,
    startTime=3600)
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.HeatTransfer.Conduction.SingleLayer con1(
    A=1, material=concrete100)
           annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TB1(      T=293.15)
    annotation (Placement(transformation(extent={{100,-40},{80,-20}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TA1
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.HeatTransfer.Conduction.SingleLayer con2(
    A=1, material=concrete100)
           annotation (Placement(transformation(extent={{50,-40},{70,-20}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFlo2
    annotation (Placement(transformation(extent={{2,-36},{14,-24}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFlo1
    annotation (Placement(transformation(extent={{-6,4},{6,16}})));
  parameter Buildings.HeatTransfer.Data.Solids.Concrete concrete200(x=0.2, nSta=4)
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  parameter Buildings.HeatTransfer.Data.Solids.Concrete concrete100(x=0.1, nSta=2)
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Buildings.HeatTransfer.Convection.Interior conv1(      A=1, til=Buildings.Types.Tilt.Wall)
    "Convective heat transfer"
    annotation (Placement(transformation(extent={{-12,0},{-32,20}})));
  Buildings.HeatTransfer.Convection.Interior conv2(      A=1, til=Buildings.Types.Tilt.Wall)
    "Convective heat transfer"
    annotation (Placement(transformation(extent={{-12,-40},{-32,-20}})));
equation
  connect(con.port_b, TB.port) annotation (Line(
      points={{40,10},{60,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(step.y, TA.T) annotation (Line(
      points={{-79,10},{-62,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(step.y, TA1.T) annotation (Line(
      points={{-79,10},{-72,10},{-72,-30},{-62,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(con1.port_b, con2.port_a) annotation (Line(
      points={{40,-30},{50,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(con2.port_b, TB1.port) annotation (Line(
      points={{70,-30},{80,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaFlo2.port_b, con1.port_a) annotation (Line(
      points={{14,-30},{20,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaFlo1.port_b, con.port_a) annotation (Line(
      points={{6,10},{20,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TA.port, conv1.fluid) annotation (Line(
      points={{-40,10},{-32,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TA1.port, conv2.fluid) annotation (Line(
      points={{-40,-30},{-32,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conv2.solid, heaFlo2.port_a) annotation (Line(
      points={{-12,-30},{2,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conv1.solid, heaFlo1.port_a) annotation (Line(
      points={{-12,10},{-6,10}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (            experiment(StopTime=86400,
            Tolerance=1E-8),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/HeatTransfer/Examples/ConductorSingleLayer.mos"
        "Simulate and plot"),
    Documentation(info="<html>
This example tests if two conductors in series computes the same heat transfer
as one conductor with twice the thickness.
The <code>assert</code> block will stop the simulation if the heat exchange with the boundary
condition differs.
</html>", revisions="<html>
<ul>
<li>
October 13, 2014, by Michael Wetter:<br/>
Removed <code>assert</code> as the equality of the results is already tested
in the regression tests, and OpenModelica triggers this assert during the integration.
</li>
<li>
January 23 2013, by Michael Wetter:<br/>
Assigned fixed value to <code>nSta</code> of constructions.
</li>
<li>
March 6 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ConductorSingleLayer;
