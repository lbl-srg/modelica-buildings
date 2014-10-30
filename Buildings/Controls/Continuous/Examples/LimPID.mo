within Buildings.Controls.Continuous.Examples;
model LimPID "Test model for PID controller with optional reverse action"
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.Pulse pulse(period=0.25)
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.Continuous.LimPID limPID(
    controllerType=Modelica.Blocks.Types.SimpleController.PID,
    Ti=1,
    Td=1,
    yMax=1,
    yMin=-1,
    initType=Modelica.Blocks.Types.InitPID.InitialState)
          annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  Buildings.Controls.Continuous.LimPID limPIDRev(
    controllerType=Modelica.Blocks.Types.SimpleController.PID,
    reverseAction=true,
    Ti=1,
    Td=1,
    yMax=1,
    yMin=-1,
    initType=Modelica.Blocks.Types.InitPID.InitialState)
    "Controller with reverse action"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Modelica.Blocks.Sources.Constant const(k=0.5)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Modelica.Blocks.Math.Gain gain(k=-1)
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.Utilities.Diagnostics.AssertEquality assertEquality(threShold=1e-10)
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Modelica.Blocks.Continuous.LimPID limPIDOri(
    controllerType=Modelica.Blocks.Types.SimpleController.PID,
    Ti=1,
    Td=1,
    yMax=1,
    yMin=-1,
    initType=Modelica.Blocks.Types.InitPID.InitialState)
          annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Buildings.Utilities.Diagnostics.AssertEquality assertEquality1(
                                                                threShold=1e-10)
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
equation
  connect(pulse.y, limPID.u_s) annotation (Line(
      points={{-59,40},{-22,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pulse.y, limPIDRev.u_s) annotation (Line(
      points={{-59,40},{-45.5,40},{-45.5,-10},{-22,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, limPID.u_m) annotation (Line(
      points={{-59,10},{-10,10},{-10,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, limPIDRev.u_m) annotation (Line(
      points={{-59,10},{-52,10},{-52,-30},{-10,-30},{-10,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(limPIDRev.y, gain.u) annotation (Line(
      points={{1,-10},{18,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, assertEquality.u2) annotation (Line(
      points={{41,-10},{50,-10},{50,24},{58,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(limPID.y, assertEquality.u1) annotation (Line(
      points={{1,40},{30,40},{30,36},{58,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pulse.y, limPIDOri.u_s)
                               annotation (Line(
      points={{-59,40},{-45.5,40},{-45.5,80},{-22,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, limPIDOri.u_m)
                               annotation (Line(
      points={{-59,10},{-52,10},{-52,60},{-10,60},{-10,68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(assertEquality1.u1, limPIDOri.y) annotation (Line(
      points={{58,76},{30,76},{30,80},{1,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(assertEquality1.u2, limPID.y) annotation (Line(
      points={{58,64},{30,64},{30,40},{1,40}},
      color={0,0,127},
      smooth=Smooth.None));
 annotation (experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/Continuous/Examples/LimPID.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
November 21, 2011, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>", info="<html>
<p>
This model tests the implementation of the
PID controller with optional reverse action.
The model <code>limPIDOri</code> is the original
implementation of the controller from the Modelica
Standard Library. The models <code>limPID</code>
and <code>limPIDRev</code> are the implementations
from the Buildings library. The model
<code>limPIDRev</code> is parameterized to have
reverse action.
The assertion blocks test whether the results
of all three controllers are identical.
</p>
</html>"));
end LimPID;
