within Buildings.Obsolete.Controls.OBC.CDL.Continuous.Validation;
model LimPIDInitialState
  "Test model for LimPID controller with initial state specified"

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant ySet(k=0.75)
    "Set point"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yMea(k=0.5)
    "Measured value"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));

  Buildings.Obsolete.Controls.OBC.CDL.Continuous.LimPID limPID(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PID,
    k=3,
    xi_start=0.25) "PID controller"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Obsolete.Controls.OBC.CDL.Continuous.LimPID limPI(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=3,
    xi_start=0.25) "PI controller"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

equation
  connect(ySet.y, limPID.u_s) annotation (Line(points={{-18,40},{0,40},{0,30},{18,
          30}}, color={0,0,127}));
  connect(ySet.y, limPI.u_s) annotation (Line(points={{-18,40},{0,40},{0,-30},{18,
          -30}}, color={0,0,127}));
  connect(yMea.y, limPID.u_m)
    annotation (Line(points={{-18,10},{30,10},{30,18}}, color={0,0,127}));
  connect(yMea.y, limPI.u_m) annotation (Line(points={{-18,10},{-4,10},{-4,-50},
          {30,-50},{30,-42}}, color={0,0,127}));
 annotation (
 experiment(
      StopTime=1,
      Tolerance=1e-06),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/Controls/OBC/CDL/Continuous/Validation/LimPIDInitialState.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.CDL.Continuous.LimPID\">
Buildings.Obsolete.Controls.OBC.CDL.Continuous.LimPID</a>.
</p>
<p>
This model validates setting the initial state of the controller to a specified value.
</p>
<p>
The model sets the initial values <code>xi_start=0.25</code>
of the integrator for both instances of the controller.
For the instance <code>limPID</code>, it also sets the initial value of the state of the
derivative block <code>xd_start=-0.5</code>.
The derivative block obtains as an input signal the value
<i>u=-0.5</i> because the set point weight for the derivative action is <code>wd=0</code>.
Therefore, an initial state of <i>x(t<sub>0</sub>)=-0.5</i> causes the state of the derivative
block to be at steady-state, because
<i>dx(t)/dt = (u - x)/T</i>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 8, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})));
end LimPIDInitialState;
