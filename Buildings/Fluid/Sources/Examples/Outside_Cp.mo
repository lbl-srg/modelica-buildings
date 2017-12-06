within Buildings.Fluid.Sources.Examples;
model Outside_Cp
  "Test model for source and sink with outside weather data and wind pressure"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air "Medium model for air";
  Buildings.Fluid.Sources.Outside_Cp bou1(
    redeclare package Medium = Medium,
    nPorts=1,
    Cp=0.6) "Model with outside conditions"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Fluid.Sources.Outside bouFix(redeclare package Medium = Medium,
      nPorts=2) "Model with outside conditions"
    annotation (Placement(transformation(extent={{70,20},{50,40}})));
  Modelica.Blocks.Sources.Constant Cp(k=0.6)
    "Constant value for Cp (used to demonstrate input connector)"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Airflow.Multizone.Orifice ori1(A=0.1, redeclare package Medium =
        Medium) "Orifice"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Fluid.Sources.Outside_Cp bou2(
    redeclare package Medium = Medium,
    nPorts=1,
    use_Cp_in=true) "Model with outside conditions"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Airflow.Multizone.Orifice ori2(A=0.1, redeclare package Medium =
        Medium) "Orifice"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
equation
  connect(weaDat.weaBus, bou1.weaBus)     annotation (Line(
      points={{-60,30},{-40,30},{-40,30.2}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(bou1.ports[1], ori1.port_a) annotation (Line(
      points={{-20,30},{-5.55112e-16,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ori1.port_b, bouFix.ports[1]) annotation (Line(
      points={{20,30},{35,30},{35,32},{50,32}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(weaDat.weaBus, bouFix.weaBus) annotation (Line(
      points={{-60,30},{-50,30},{-50,50},{74,50},{74,30.2},{70,30.2}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(bou2.Cp_in, Cp.y) annotation (Line(
      points={{-42,-6},{-54,-6},{-54,-10},{-59,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bou2.ports[1], ori2.port_a) annotation (Line(
      points={{-20,-10},{-5.55112e-16,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ori2.port_b, bouFix.ports[2]) annotation (Line(
      points={{20,-10},{38,-10},{38,28},{50,28}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(weaDat.weaBus, bou2.weaBus) annotation (Line(
      points={{-60,30},{-50,30},{-50,-9.8},{-40,-9.8}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (
experiment(Tolerance=1e-6, StopTime=86400),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Sources/Examples/Outside_Cp.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model demonstrates the use of a source for ambient temperature, pressure and
species concentration.
The models <code>bou1</code> and <code>bou2</code> compute the ambient pressure
based on the weather file and the wind pressure.
The model <code>bou1</code> uses a parameter for the wind pressure coefficient,
whereas <code>bou2</code> uses the wind pressure coefficient from its input port.
The model <code>bouFix</code> does not compute any wind pressure.
Adding the wind pressure to the models on the left-hand side induces a mass flow
rate through the orifice models <code>ori1</code> and <code>ori2</code>.
Since both source models use the same constant wind pressure coefficient, the
mass flow rate through the orifice model is the same.
In more realistic applications, the constant source <code>Cp</code> would be
replaced by a model that computes a wind pressure coefficient that takes into
account the wind direction relative to the building.
</p>
</html>", revisions="<html>
<ul>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
October 26, 2011 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Outside_Cp;
