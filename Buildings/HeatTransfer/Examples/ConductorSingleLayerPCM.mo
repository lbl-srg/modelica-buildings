within Buildings.HeatTransfer.Examples;
model ConductorSingleLayerPCM "Test model for heat conductor"
  extends Modelica.Icons.Example;
  Buildings.HeatTransfer.Sources.PrescribedTemperature TA
    "Temperature boundary condition"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Modelica.Blocks.Sources.Step step(
    height=10,
    offset=293.15,
    startTime=360)
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TA1
    "Temperature boundary condition"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFlo2
    "Heat flow sensor"
    annotation (Placement(transformation(extent={{2,-36},{14,-24}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFlo1
    "Heat flow sensor"
    annotation (Placement(transformation(extent={{-6,4},{6,16}})));
  Modelica.Blocks.Math.Add cheEqu(k2=-1) "Checks for equality of the results"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  parameter Buildings.HeatTransfer.Data.Solids.Concrete concrete100(x=0.1, nStaRef=4)
    "Non-PCM material"
    annotation (Placement(transformation(extent={{62,70},{82,90}})));
  Buildings.HeatTransfer.Convection.Interior conv1(      A=1, til=Buildings.Types.Tilt.Wall)
    "Convective heat transfer"
    annotation (Placement(transformation(extent={{-12,0},{-32,20}})));
  Buildings.HeatTransfer.Convection.Interior conv2(      A=1, til=Buildings.Types.Tilt.Wall)
    "Convective heat transfer"
    annotation (Placement(transformation(extent={{-12,-40},{-32,-20}})));
  Buildings.HeatTransfer.Conduction.SingleLayer conPCM(
    A=1,
    material=matPCM,
    stateAtSurface_b=true)
                     "Construction with phase change around 40 degC"
    annotation (Placement(transformation(extent={{24,0},{44,20}})));
  Buildings.HeatTransfer.Conduction.SingleLayer con1(
    A=1, material=concrete100,
    stateAtSurface_b=false)    "Construction without PCM"
    annotation (Placement(transformation(extent={{22,-40},{42,-20}})));
  Buildings.HeatTransfer.Conduction.SingleLayer con2(
    A=1, material=concrete100,
    stateAtSurface_a=false,
    stateAtSurface_b=true)     "Construction without PCM"
    annotation (Placement(transformation(extent={{50,-40},{70,-20}})));
  parameter Buildings.HeatTransfer.Data.SolidsPCM.Generic matPCM(
    x=0.2,
    k=1.4,
    c=840,
    d=2240,
    nSta=4,
    TSol=273.15 + 40.49,
    TLiq=273.15 + 40.51,
    LHea=100000) "PCM material with phase change near 40 degC"
            annotation (Placement(transformation(extent={{-62,70},{-42,90}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TA2
    "Temperature boundary condition"
    annotation (Placement(transformation(extent={{-60,34},{-40,54}})));
  Buildings.HeatTransfer.Convection.Interior conv3(      A=1, til=Buildings.Types.Tilt.Wall)
    "Convective heat transfer"
    annotation (Placement(transformation(extent={{-12,34},{-32,54}})));
  Buildings.HeatTransfer.Conduction.SingleLayer conPCM2(
    A=1,
    material=matPCM2,
    stateAtSurface_b=false)
                      "Construction with phase change near room temperature"
    annotation (Placement(transformation(extent={{24,34},{44,54}})));
  parameter Buildings.HeatTransfer.Data.SolidsPCM.Generic matPCM2(
    x=0.2,
    k=1.4,
    c=840,
    d=2240,
    nSta=4,
    TSol=273.15 + 20.49,
    TLiq=273.15 + 20.51,
    LHea=100000) "PCM material with phase change near room temperature"
            annotation (Placement(transformation(extent={{-12,70},{8,90}})));
equation
  connect(step.y, TA.T) annotation (Line(
      points={{-79,10},{-62,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(step.y, TA1.T) annotation (Line(
      points={{-79,10},{-72,10},{-72,-30},{-62,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cheEqu.u1, heaFlo2.Q_flow) annotation (Line(
      points={{18,-64},{8,-64},{8,-36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cheEqu.u2, heaFlo1.Q_flow) annotation (Line(
      points={{18,-76},{0,-76},{0,4}},
      color={0,0,127},
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
  connect(heaFlo1.port_b, conPCM.port_a)
                                      annotation (Line(
      points={{6,10},{24,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaFlo2.port_b, con1.port_a) annotation (Line(
      points={{14,-30},{22,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(con1.port_b, con2.port_a) annotation (Line(
      points={{42,-30},{50,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(step.y, TA2.T) annotation (Line(
      points={{-79,10},{-72,10},{-72,44},{-62,44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TA2.port, conv3.fluid) annotation (Line(
      points={{-40,44},{-32,44}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conv3.solid, conPCM2.port_a)
                                      annotation (Line(
      points={{-12,44},{24,44}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/HeatTransfer/Examples/ConductorSingleLayerPCM.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example tests the implementation of the phase-change material (PCM) model.
</p>
<p>
The phase-change material <code>matPCM</code> is exposed to the same boundary
conditions as the non phase-change material.
In the construction <code>conPCM2</code>, the phase change is around <i>20.5</i> &deg;C.
In the construction <code>conPCM</code>, the phase change is around <i>40.5</i> &deg;C, which
is above the temperature range simulated in this model.
Therefore, the same result is expected for the PCM material <code>conPCM</code>
as is for two conductors in series.
Note that in case of using <code>matPCM</code>, the internal energy is
the dependent variable, whereas in case of two conductors in series, the temperature
is the dependent variable. However, both models will
produce the same results.
</p>
<p>
The <code>cheEqu</code> block computes the difference between the heat fluxes,
which should be equal except for the numerical approximation error of the solver.
</p>
</html>", revisions="<html>
<ul>
<li>
January 29, 2019, by Michael Wetter:<br/>
Changed model to use adiabatic boundary condition on the right hand side.
This avoids that <code>der(conPCM.u)</code> is an iteration variable with no
start value, which would trigger a warning in JModelica.
</li>
<li>
November 9, 2016, by Michael Wetter:<br/>
Changed assertion with a computation of the difference.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/576\">issue 576</a>.
</li>
<li>
October 17, 2014, by Michael Wetter:<br/>
Increased tolerance for OpenModelica.
</li>
<li>
March 6 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(StopTime=7200, Tolerance=1e-6));
end ConductorSingleLayerPCM;
