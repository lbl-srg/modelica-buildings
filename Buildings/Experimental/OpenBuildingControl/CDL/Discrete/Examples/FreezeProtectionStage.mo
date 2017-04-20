within Buildings.Experimental.OpenBuildingControl.CDL.Discrete.Examples;
model FreezeProtectionStage
  "Example model for the source that outputs freeze protection stage based on inputs [fixme: add validation test results]"
  import Buildings;
  extends Modelica.Icons.Example;
  Buildings.Experimental.OpenBuildingControl.CDL.Logical.Constant condition1(k=true)
    "Emulates true value if the conditions that activate the first stage of freeze protection are satisfied"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Logical.Constant condition2(k=true)
    "Emulates true value if the conditions that activate the second stage of freeze protection are satisfied"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Logical.Constant condition3(k=false)
    "Emulates true value if the conditions that activate the third stage of freeze protection are satisfied"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Discrete.FreezeProtectionStage
    freezeProtectionStage
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
equation
  connect(condition1.y, freezeProtectionStage.uStage1OnOff) annotation (Line(
        points={{-39,40},{-22,40},{-22,4},{-2,4}}, color={255,0,255}));
  connect(condition2.y, freezeProtectionStage.uStage2OnOff)
    annotation (Line(points={{-39,0},{-20,0},{-2,0}}, color={255,0,255}));
  connect(condition3.y, freezeProtectionStage.uStage3OnOff) annotation (Line(
        points={{-39,-40},{-22,-40},{-22,-4},{-2,-4}}, color={255,0,255}));
  annotation (
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Discrete/Examples/DayType.mos"
        "Simulate and plot"),
        experiment(StartTime=-1814400, StopTime=1814400, Tolerance=1E-6),
    Documentation(
    info="<html>
<p>
This example generates a Freeze Protection Stage output based on evaluating three
boolean inputs, as defined within the FreezeProtectionStage block.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 19, 2017, by Milica Grahovac:<br/>
First CDL implementation.
</li>
</ul>
</html>"));
end FreezeProtectionStage;
