within Buildings.Examples.ChillerPlant.BaseClasses.Controls.Examples;
model KMinusU "Test model for KMinusU"
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Sine pulse(
    f=0.001,
    amplitude=0.5,
    offset=0.5,
    phase=-1.5707963267949)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Examples.ChillerPlant.BaseClasses.Controls.KMinusU kMinU(k=1)
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
equation
  connect(pulse.y, kMinU.u) annotation (Line(
      points={{-59,10},{-21.8,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Examples/ChillerPlant/BaseClasses/Controls/Examples/KMinusU.mos"
        "Simulate and plot"),
    experiment(
      StopTime=3600,
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
end KMinusU;
