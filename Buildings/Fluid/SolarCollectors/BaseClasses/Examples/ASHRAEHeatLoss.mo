within Buildings.Fluid.SolarCollectors.BaseClasses.Examples;
model ASHRAEHeatLoss "Example showing the use of ASHRAEHeatLoss"
  extends Modelica.Icons.Example;
  parameter Buildings.Fluid.SolarCollectors.Data.GenericSolarCollector per=
    Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.FP_SolahartKf()
    "Performance data"
    annotation (choicesAllMatching=true);
  Modelica.Blocks.Sources.Sine TEnv(
    f=0.01,
    offset=273.15 + 10,
    amplitude=7.5) "Temperature of the surrounding environment"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Sine T1(
    f=0.1,
    amplitude=15,
    offset=273.15 + 10) "Temperature in the first segment"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Modelica.Blocks.Sources.Sine T2(
    f=0.1,
    amplitude=15,
    offset=273.15 + 15) "Temperature in the second segment"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Modelica.Blocks.Sources.Sine T3(
    f=0.1,
    amplitude=15,
    offset=273.15 + 20) "Temperature in the third segment"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Fluid.SolarCollectors.BaseClasses.ASHRAEHeatLoss heaLos(
    nSeg=3,
    m_flow_nominal=per.mperA_flow_nominal*per.A,
    redeclare package Medium = Buildings.Media.Water,
    G_nominal=per.G_nominal,
    dT_nominal=per.dT_nominal,
    A_c=per.A,
    y_intercept=per.y_intercept,
    slope=per.slope,
    cp_default=4186) "Heat loss model using ASHRAE93 calculations"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
equation
  connect(TEnv.y, heaLos.TEnv) annotation (Line(
      points={{-59,70},{-20,70},{-20,36},{58,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T3.y, heaLos.TFlu[3]) annotation (Line(
      points={{-59,30},{-20,30},{-20,25.3333},{58,25.3333}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T2.y, heaLos.TFlu[2]) annotation (Line(
      points={{-59,-10},{-20,-10},{-20,24},{58,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T1.y, heaLos.TFlu[1]) annotation (Line(
      points={{-59,-50},{-14,-50},{-14,22.6667},{58,22.6667}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Documentation(info="<html>
      <p>
        This examples demonstrates the implementation of
        <a href=\"modelica://Buildings.Fluid.SolarCollectors.BaseClasses.ASHRAEHeatLoss\">
        Buildings.Fluid.SolarCollectors.BaseClasses.ASHRAEHeatLoss</a>.
      </p>
    </html>",
    revisions="<html>
      <ul>
        <li>
          Mar 27, 2013 by Peter Grant:<br/>
          First implementation.
        </li>
      </ul>
    </html>"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/SolarCollectors/BaseClasses/Examples/ASHRAEHeatLoss.mos"
        "Simulate and plot"),
        experiment(Tolerance=1e-6, StopTime=100));
end ASHRAEHeatLoss;
