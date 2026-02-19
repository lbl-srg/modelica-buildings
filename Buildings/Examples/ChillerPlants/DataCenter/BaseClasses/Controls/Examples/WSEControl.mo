within Buildings.Examples.ChillerPlants.DataCenter.BaseClasses.Controls.Examples;
model WSEControl "Test model for WSEControl"
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Pulse wseCHWST(
    period=300,
    amplitude=15,
    offset=273.15 + 5) "WSE chilled water supply temperature"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Modelica.Blocks.Sources.Constant wseCWST(k=273.15 + 10)
    "WSE condenser water supply temperature"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Buildings.Examples.ChillerPlants.DataCenter.BaseClasses.Controls.WSEControl wseCon
    "Controller for the water-side economizer"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Modelica.Blocks.Sources.Constant TWetBub(k=273.15 + 5) "Wet bulb temperature"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Modelica.Blocks.Sources.Constant TTowApp(k=5) "Cooling tower approach"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
equation
  connect(TWetBub.y, wseCon.TWetBul) annotation (Line(
      points={{-39,20},{-16,20},{-16,10.5882},{-2,10.5882}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TTowApp.y, wseCon.towTApp) annotation (Line(
      points={{-39,-20},{-16,-20},{-16,7.05882},{-2,7.05882}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(wseCHWST.y, wseCon.wseCHWST) annotation (Line(
      points={{-39,60},{-10,60},{-10,16.4706},{-2,16.4706}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(wseCWST.y, wseCon.wseCWST) annotation (Line(
      points={{-39,-50},{-8,-50},{-8,2.47059},{-2,2.47059}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Examples/ChillerPlants/DataCenter/BaseClasses/Controls/Examples/WSEControl.mos"
        "Simulate and plot"),
    experiment(
      StopTime=3600,
      Tolerance=1e-6),
    Documentation(revisions="<html>
<ul>
<li>
July 21, 2011, by Wangda Zuo:<br/>
Merged to library.
</li>
<li>
January 6, 2011, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end WSEControl;
