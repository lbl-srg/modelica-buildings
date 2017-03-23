within Buildings.Fluid.SolarCollectors.BaseClasses.Examples;
model EN12975HeatLoss "Example showing the use of EN12975HeatLoss"
  extends Modelica.Icons.Example;
  parameter Buildings.Fluid.SolarCollectors.Data.GenericSolarCollector per=
    Buildings.Fluid.SolarCollectors.Data.Concentrating.C_VerificationModel()
    "Performance data"
    annotation (choicesAllMatching=true);
  Modelica.Blocks.Sources.Sine TEnv(
    freqHz=0.01,
    offset=273.15 + 10,
    amplitude=15) "Temperature of the surrounding environment"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Sine T1(
    amplitude=15,
    freqHz=0.1,
    offset=273.15 + 10) "Temperature of the first segment"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Modelica.Blocks.Sources.Sine T2(
    freqHz=0.1,
    amplitude=15,
    offset=273.15 + 15) "Temperature of the second segment"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Modelica.Blocks.Sources.Sine T3(
    freqHz=0.1,
    amplitude=15,
    offset=273.15 + 20) "Temperature of the third segment"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Fluid.SolarCollectors.BaseClasses.EN12975HeatLoss heaLos(
    nSeg=3,
    redeclare package Medium = Buildings.Media.ConstantPropertyLiquidWater,
    C1=per.C1,
    C2=per.C2,
    m_flow_nominal=per.mperA_flow_nominal*per.A,
    G_nominal=per.G_nominal,
    dT_nominal=per.dT_nominal,
    A_c=per.A,
    y_intercept=per.y_intercept) "Heat loss model using EN12975 calculations"
    annotation (Placement(transformation(extent={{62,20},{82,40}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
equation
  connect(TEnv.y, heaLos.TEnv) annotation (Line(
      points={{-59,70},{-20,70},{-20,36},{60,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T3.y, heaLos.TFlu[3]) annotation (Line(
      points={{-59,30},{-20,30},{-20,25.3333},{60,25.3333}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T2.y, heaLos.TFlu[2]) annotation (Line(
      points={{-59,-10},{-20,-10},{-20,24},{60,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T1.y, heaLos.TFlu[1]) annotation (Line(
      points={{-59,-50},{-14,-50},{-14,22.6667},{60,22.6667}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics),
    Documentation(info="<html>
      <p>
        This examples demonstrates the implementation of 
        <a href=\"modelica://Buildings.Fluid.SolarCollectors.BaseClasses.EN12975HeatLoss\">
        Buildings.Fluid.SolarCollectors.BaseClasses.EN12975HeatLoss</a>.
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
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/SolarCollectors/BaseClasses/Examples/EN12975HeatLoss.mos"
        "Simulate and Plot"),
    Icon(graphics));
end EN12975HeatLoss;
