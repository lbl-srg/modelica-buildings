within Buildings.Controls.Continuous.Validation;
model LimPIDReset
  "Test model for PID controller with optional intgerator reset"
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.Sine setPoi(f=1) "Set point signal"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Controls.Continuous.LimPID limPIDPar(
    yMax=1,
    yMin=-1,
    reset=Buildings.Types.Reset.Parameter,
    y_reset=0.2,
    Ti=20,
    Td=10,
    k=0.2,
    controllerType=Modelica.Blocks.Types.SimpleController.PID,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=0.3) "PId controller with integrator reset to a parameter value"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Modelica.Blocks.Sources.Constant mea(k=0.5) "Measured signal"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.Continuous.LimPID limPIDDef(
    initType=Modelica.Blocks.Types.Init.InitialState,
    Td=10,
    k=1,
    Ti=1,
    yMax=100,
    yMin=-100,
    controllerType=Modelica.Blocks.Types.SimpleController.PID,
    xi_start=0.2,
    xd_start=0.1) "PID controller without integrator reset"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Modelica.Blocks.Sources.BooleanPulse trigger(
    width=50,
    startTime=0.1,
    period=0.2) "Boolean pulse to reset integrator"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.Continuous.LimPID limPIDInp(
    y_reset=0.2,
    Td=10,
    reset=Buildings.Types.Reset.Input,
    yMax=1,
    yMin=-1,
    k=0.2,
    Ti=20,
    controllerType=Modelica.Blocks.Types.SimpleController.PID,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=0.3) "PId controller with integrator reset to an input value"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  Modelica.Blocks.Sources.Constant conRes(k=0.9)
    "Signal to which integrator will be reset to"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Modelica.Blocks.Continuous.LimPID limPIDOri(
    initType=Modelica.Blocks.Types.Init.InitialState,
    Td=10,
    k=1,
    Ti=1,
    yMax=100,
    yMin=-100,
    controllerType=Modelica.Blocks.Types.SimpleController.PID,
    xi_start=0.2,
    xd_start=0.1) "PID controller from Standard Modelica Library"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Buildings.Utilities.Diagnostics.AssertEquality assEqu
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
equation
  connect(setPoi.y, limPIDPar.u_s)
    annotation (Line(points={{-19,-10},{0,-10},{18,-10}}, color={0,0,127}));
  connect(mea.y, limPIDPar.u_m)
    annotation (Line(points={{-19,-40},{30,-40},{30,-22}}, color={0,0,127}));
  connect(setPoi.y, limPIDDef.u_s) annotation (Line(points={{-19,-10},{-6,-10},
          {-6,30},{18,30}}, color={0,0,127}));
  connect(mea.y, limPIDDef.u_m) annotation (Line(points={{-19,-40},{-12,-40},{
          -12,10},{30,10},{30,18}}, color={0,0,127}));
  connect(trigger.y, limPIDPar.trigger) annotation (Line(points={{-19,20},{-10,
          20},{8,20},{8,-30},{22,-30},{22,-22}}, color={255,0,255}));
  connect(setPoi.y, limPIDInp.u_s) annotation (Line(points={{-19,-10},{-6,-10},
          {-6,-70},{18,-70}}, color={0,0,127}));
  connect(mea.y, limPIDInp.u_m) annotation (Line(points={{-19,-40},{-12,-40},{
          -12,-90},{30,-90},{30,-88},{30,-82}}, color={0,0,127}));
  connect(trigger.y, limPIDInp.trigger) annotation (Line(points={{-19,20},{-19,
          20},{8,20},{8,-88},{22,-88},{22,-82}}, color={255,0,255}));
  connect(conRes.y, limPIDInp.y_reset_in) annotation (Line(points={{-19,-80},{0,
          -80},{0,-78},{18,-78}}, color={0,0,127}));
  connect(setPoi.y, limPIDOri.u_s) annotation (Line(points={{-19,-10},{-6,-10},
          {-6,70},{18,70}}, color={0,0,127}));
  connect(mea.y, limPIDOri.u_m) annotation (Line(points={{-19,-40},{-12,-40},{
          -12,50},{30,50},{30,58}}, color={0,0,127}));
  connect(assEqu.u1, limPIDOri.y) annotation (Line(points={{58,56},{48,56},{48,
          70},{41,70}}, color={0,0,127}));
  connect(limPIDDef.y, assEqu.u2) annotation (Line(points={{41,30},{48,30},{48,
          44},{58,44}}, color={0,0,127}));
 annotation (experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/Continuous/Validation/LimPIDReset.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
September 29, 2016, by Michael Wetter:<br/>
Revised example to increase code coverage.
</li>
<li>
August 25, 2016, by Michael Wetter:<br/>
Revised documentation and added script for regression test.
</li>
<li>
August 02, 2016, by Philipp Mehrfeld:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>This model tests the implementation the
<a href=\"Modelica://Buildings.Controls.Continuous.LimPID\">Buildings.Controls.Continuous.LimPID</a>
with integrator reset.
</p>
<p>
The instance <code>limPIOri</code> is the original implementation of the controller
from the Modelica Standard Library.
The instance <code>limPIWithReset</code> is the implementation from this library
with integrator reset enabled. Whenever the boolean pulse input becomes true,
the integrator is reset to <code>y_reset</code>.
</p>
</html>"));
end LimPIDReset;
