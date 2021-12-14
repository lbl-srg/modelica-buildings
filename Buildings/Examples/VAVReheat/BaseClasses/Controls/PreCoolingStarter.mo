within Buildings.Examples.VAVReheat.BaseClasses.Controls;
block PreCoolingStarter "Outputs true when precooling should start"
  extends Modelica.Blocks.Interfaces.BooleanSignalSource;
  parameter Modelica.Units.SI.Temperature TOutLim=286.15
    "Limit for activating precooling";
  parameter Modelica.Units.SI.Temperature TRooSetCooOcc
    "Set point for room air temperature during cooling mode";
  BaseClasses.Controls.ControlBus controlBus
    annotation (Placement(transformation(extent={{-72,50},{-52,70}})));
  Modelica.Blocks.Logical.GreaterThreshold greater(threshold=TRooSetCooOcc)
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Modelica.Blocks.Logical.LessThreshold greater2(threshold=1800)
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Modelica.Blocks.Logical.LessThreshold greater1(threshold=TOutLim)
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Modelica.Blocks.MathBoolean.And and3(nu=3)
    annotation (Placement(transformation(extent={{28,-6},{40,6}})));
equation
  connect(controlBus.dTNexOcc, greater2.u) annotation (Line(
      points={{-62,60},{-54,60},{-54,-70},{-42,-70}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(controlBus.TRooAve, greater.u) annotation (Line(
      points={{-62,60},{-54,60},{-54,10},{-42,10}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(controlBus.TOut, greater1.u) annotation (Line(
      points={{-62,60},{-54,60},{-54,-30},{-42,-30}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(and3.y, y) annotation (Line(
      points={{40.9,0},{110,0}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(greater.y, and3.u[1]) annotation (Line(
      points={{-19,10},{6,10},{6,2.8},{28,2.8}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(greater1.y, and3.u[2]) annotation (Line(
      points={{-19,-30},{6,-30},{6,0},{28,0},{28,2.22045e-016}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(greater2.y, and3.u[3]) annotation (Line(
      points={{-19,-70},{12,-70},{12,-2.8},{28,-2.8}},
      color={255,0,255},
      smooth=Smooth.None));
end PreCoolingStarter;
