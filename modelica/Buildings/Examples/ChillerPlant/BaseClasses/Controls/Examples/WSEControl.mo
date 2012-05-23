within Buildings.Examples.ChillerPlant.BaseClasses.Controls.Examples;
model WSEControl "Test model for WSEControl"
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Pulse wseCHWST(
    period=300,
    amplitude=15,
    offset=273.15 + 5) "WSE chilled water supply temperature"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.Constant wseCWST(k=273.15 + 10)
    "WSE condenser water supply temperature"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Buildings.Examples.ChillerPlant.BaseClasses.Controls.WSEControl wseCon
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Modelica.Blocks.Sources.Constant TWetBub(k=273.15 + 5) "Wet bulb temperature"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Modelica.Blocks.Sources.Constant TTowApp(k=5) "Cooling tower approach"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
equation
  connect(TWetBub.y, wseCon.TWetBul) annotation (Line(
      points={{-39,-10},{-26,-10},{-26,6.4},{-0.8,6.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TTowApp.y, wseCon.towTApp) annotation (Line(
      points={{-39,-50},{-16,-50},{-16,2.4},{-0.8,2.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(wseCHWST.y, wseCon.wseCHWST) annotation (Line(
      points={{-39,30},{-26,30},{-26,12},{-0.8,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(wseCWST.y, wseCon.wseCWST) annotation (Line(
      points={{-39,70},{-20,70},{-20,17.6},{-0.8,17.6}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(graphics),
    Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Examples/ChillerPlant/BaseClasses/Controls/Examples/WSEControl.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
July 21, 2011, by Wangda Zuo:<br>
Merge to library.
</li>
<li>
January 6, 2011, by Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"));
end WSEControl;
