within Buildings.Experimental.OpenBuildingControl.CDL.Discrete.Examples;
model StatusType
  "fixme Example model for the source that outputs the Status type"
  import Buildings;
  extends Modelica.Icons.Example;
  Buildings.Experimental.OpenBuildingControl.CDL.Discrete.FreezeProtectionStage
    frePro(nout=2)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Interfaces.StatusTypeOutput y
    annotation (Placement(transformation(extent={{100,40},{120,60}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Discrete.FreezeProtectionStage
    frePro1(nout=2)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Discrete.FreezeProtectionStage
    frePro2(nout=2)
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Discrete.FreezeProtectionStage
    frePro3(nout=2)
    annotation (Placement(transformation(extent={{-82,-80},{-62,-60}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Logical.Equal equ
    annotation (Placement(transformation(extent={{0,-14},{20,6}})));
equation
  connect(frePro.y[1], y) annotation (Line(points={{-59,49.5},{-36,49.5},{-36,50},
          {110,50}}, color={0,127,0}));
  annotation (__Dymola_Commands(file="modelica://Buildings/Experimental/OpenBuildingControl/CDL/Discrete/Examples/DayType.mos"
        "Simulate and plot"),
        experiment(StartTime=-1814400, StopTime=1814400),
    Documentation(
    info="<html>
<p>
This example generates signals for three different work weeks.
The instance <code>dayTypMon</code> outputs a signal with five working
days, followed by two non-working days.
The instance <code>dayTypSat</code> does the same, except that the first
days is a non-working day.
The instance <code>dayTypTwoWeeks</code> outputs six working days, followed
by 8 non-working days.
The instance <code>dayTypMonThr</code> is configured the same as
<code>dayTypMon</code>, except that it outputs the type of the day
for three days, starting with the current day, then the next day and
the day after.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 11, 2016, by Milica Grahovac:<br/>
First CDL implementation.
</li>
<li>
March 20, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end StatusType;
