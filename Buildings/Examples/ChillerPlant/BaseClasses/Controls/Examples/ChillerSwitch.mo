within Buildings.Examples.ChillerPlant.BaseClasses.Controls.Examples;
model ChillerSwitch "Test model for ChillerSwitch"
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Sine TSet(
    f=0.0002,
    offset=12,
    amplitude=8)
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Modelica.Blocks.Sources.Sine CHWST(
    f=0.0001,
    amplitude=5,
    offset=15)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Examples.ChillerPlant.BaseClasses.Controls.ChillerSwitch chiSwi(
      deaBan(displayUnit="K") = 3)
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
equation
  connect(TSet.y, chiSwi.TSet) annotation (Line(
      points={{-39,-10},{-20,-10},{-20,5},{-1,5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(CHWST.y, chiSwi.chiCHWST) annotation (Line(
      points={{-39,30},{-20,30},{-20,17},{-1,17}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Examples/ChillerPlant/BaseClasses/Controls/Examples/ChillerSwitch.mos"
        "Simulate and plot"),
   experiment(
      StopTime=86400,
      Tolerance=1e-6),
    Documentation(revisions="<html>
<ul>
<li>
July 20, 2011, by Wangda Zuo:<br/>
Added <code>.mos</code> file and merged to library.
</li>
<li>
January 18, 2011, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end ChillerSwitch;
