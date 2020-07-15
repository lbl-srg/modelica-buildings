within Buildings.Examples.VAVReheat.Controls;
model MixedAirTemperatureSetpoint
  "Mixed air temperature setpoint for economizer"
  extends Modelica.Blocks.Icons.Block;
  Modelica.Blocks.Routing.Extractor TSetMix(
    nin=6,
    index(start=2, fixed=true)) "Mixed air setpoint temperature extractor"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Modelica.Blocks.Sources.Constant off(k=273.15 + 13)
    "Setpoint temperature to close damper"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Utilities.Math.Average ave(nin=2)
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Modelica.Blocks.Interfaces.RealInput TSupHeaSet
    "Supply temperature setpoint for heating"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}), iconTransformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput TSupCooSet
    "Supply temperature setpoint for cooling"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Sources.Constant TPreCoo(k=273.15 + 13)
    "Setpoint during pre-cooling"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  ControlBus controlBus
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Modelica.Blocks.Interfaces.RealOutput TSet "Mixed air temperature setpoint"
    annotation (Placement(transformation(extent={{100,0},{120,20}})));
  Modelica.Blocks.Routing.Multiplex2 multiplex2_1
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
equation
  connect(TSetMix.u[1], ave.y) annotation (Line(
      points={{58,8.33333},{14,8.33333},{14,-60},{1,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ave.y, TSetMix.u[1])     annotation (Line(
      points={{1,-60},{42,-60},{42,8.33333},{58,8.33333}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(off.y, TSetMix.u[2]) annotation (Line(
      points={{-59,30},{40,30},{40,12},{58,12},{58,9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(off.y, TSetMix.u[3]) annotation (Line(
      points={{-59,30},{40,30},{40,9.66667},{58,9.66667}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(off.y, TSetMix.u[4]) annotation (Line(
      points={{-59,30},{9.5,30},{9.5,10.3333},{58,10.3333}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TPreCoo.y, TSetMix.u[5]) annotation (Line(
      points={{-59,-10},{0,-10},{0,11},{58,11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(off.y, TSetMix.u[6]) annotation (Line(
      points={{-59,30},{40,30},{40,11.6667},{58,11.6667}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(controlBus.controlMode, TSetMix.index) annotation (Line(
      points={{-30,70},{-30,-14},{70,-14},{70,-2}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(TSetMix.y, TSet) annotation (Line(
      points={{81,10},{110,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiplex2_1.y, ave.u) annotation (Line(
      points={{-39,-60},{-22,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSupCooSet, multiplex2_1.u2[1]) annotation (Line(
      points={{-120,-60},{-90,-60},{-90,-66},{-62,-66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSupHeaSet, multiplex2_1.u1[1]) annotation (Line(
      points={{-120,60},{-90,60},{-90,-54},{-62,-54}},
      color={0,0,127},
      smooth=Smooth.None));
end MixedAirTemperatureSetpoint;
