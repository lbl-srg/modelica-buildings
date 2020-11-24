within Buildings.Examples.DualFanDualDuct.Controls;
model MixedAirTemperatureSetpoint
  "Mixed air temperature setpoint for economizer"
  extends Modelica.Blocks.Icons.Block;
  Modelica.Blocks.Routing.Extractor TSetMix(
    nin=6,
    index(start=2, fixed=true)) "Mixed air setpoint temperature extractor"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Sources.Constant off(k=273.15 + 13)
    "Setpoint temperature to close damper"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Utilities.Math.Average ave(nin=2)
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupHeaSet(
    final unit="K",
    displayUnit="degC")
    "Supply temperature setpoint for heating"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupCooSet(
    final unit="K",
    displayUnit="degC")
    "Supply temperature setpoint for cooling"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSet(
    final unit="K",
    displayUnit="degC")
   "Mixed air temperature setpoint"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Modelica.Blocks.Sources.Constant TPreCoo(k=273.15 + 13)
    "Setpoint during pre-cooling"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  VAVReheat.Controls.ControlBus controlBus
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  Modelica.Blocks.Routing.Multiplex2 multiplex2_1
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
equation
  connect(TSetMix.u[1], ave.y) annotation (Line(
      points={{58,-1.66667},{14,-1.66667},{14,-60},{1,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ave.y, TSetMix.u[1])     annotation (Line(
      points={{1,-60},{42,-60},{42,-1.66667},{58,-1.66667}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(off.y, TSetMix.u[2]) annotation (Line(
      points={{-59,30},{40,30},{40,0},{58,0},{58,-1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(off.y, TSetMix.u[3]) annotation (Line(
      points={{-59,30},{40,30},{40,-0.333333},{58,-0.333333}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(off.y, TSetMix.u[4]) annotation (Line(
      points={{-59,30},{9.5,30},{9.5,0.333333},{58,0.333333}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TPreCoo.y, TSetMix.u[5]) annotation (Line(
      points={{-59,-10},{0,-10},{0,1},{58,1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(off.y, TSetMix.u[6]) annotation (Line(
      points={{-59,30},{40,30},{40,1.66667},{58,1.66667}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(controlBus.controlMode, TSetMix.index) annotation (Line(
      points={{0,-80},{70,-80},{70,-12}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(TSetMix.y, TSet) annotation (Line(
      points={{81,0},{100,0},{100,0},{120,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiplex2_1.y, ave.u) annotation (Line(
      points={{-39,-60},{-22,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSupCooSet, multiplex2_1.u2[1]) annotation (Line(
      points={{-120,-40},{-90,-40},{-90,-66},{-62,-66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSupHeaSet, multiplex2_1.u1[1]) annotation (Line(
      points={{-120,40},{-90,40},{-90,-54},{-62,-54}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation(defaultComponentName="TMixSet");
end MixedAirTemperatureSetpoint;
