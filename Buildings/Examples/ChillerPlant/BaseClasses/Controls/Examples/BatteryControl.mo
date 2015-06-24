within Buildings.Examples.ChillerPlant.BaseClasses.Controls.Examples;
model BatteryControl "Test model for battery control"
  extends Modelica.Icons.Example;
  Buildings.Examples.ChillerPlant.BaseClasses.Controls.BatteryControl
    con "Battery control"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Modelica.Blocks.Sources.Sine SOC(
    freqHz=1/86400,
    offset=0.5,
    amplitude=0.6) "State of charge"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
equation
  connect(SOC.y, con.SOC) annotation (Line(
      points={{-19,10},{-2,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    experiment(
      StopTime=604800,
      Tolerance=1e-05),
    Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Examples/ChillerPlant/BaseClasses/Controls/Examples/BatteryControl.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
January 31, 2013, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model simulates a battery block controller.
</p>
</html>"));
end BatteryControl;
