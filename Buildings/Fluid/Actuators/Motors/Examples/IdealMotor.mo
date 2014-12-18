within Buildings.Fluid.Actuators.Motors.Examples;
model IdealMotor "Test model for IdealMotor"
  extends Modelica.Icons.Example;
  Buildings.Fluid.Actuators.Motors.IdealMotor mot(tOpe=60) "Motor model"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Modelica.Blocks.Sources.TimeTable ySet(table=[0,0; 60,0; 60,1; 120,1; 180,0.5;
        240,0.5; 300,0; 360,0; 360,0.25; 420,0.25; 480,1; 540,1.5; 600,-0.25])
    "Set point for actuator" annotation (Placement(transformation(extent={{-80,
            20},{-60,40}})));
equation
  connect(ySet.y, mot.u)
    annotation (Line(points={{-59,30},{-22,30}}, color={0,0,127}));
  annotation (
experiment(StopTime=600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Actuators/Motors/Examples/IdealMotor.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
Test model for the ideal motor with hysteresis model.
The motor receives at its control input a time-varying signal.
It adjusts its position whenever the input signal differs
from the current position by more than the hysteresis.
</p>
</html>", revisions="<html>
<ul>
<li>
September 8, 2008 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end IdealMotor;
