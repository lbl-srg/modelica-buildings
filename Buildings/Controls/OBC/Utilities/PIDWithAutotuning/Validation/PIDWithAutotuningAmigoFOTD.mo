within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Validation;
model PIDWithAutotuningAmigoFOTD "Test model for PIDWithAutotuning"
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant Setpoint(k=0.8)
    "Setpoint value"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  .Buildings.Controls.OBC.Utilities.PIDWithAutotuning.PIDWithAutotuningAmigoFOTD
    PIDWitAutotuning(controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI)
    "PID controller with an autotuning feature"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset PID(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=1,
    Ti=0.5,
    Td=0.1)
    "PID controller with constant gains"
     annotation (Placement(transformation(extent={{0,20},{20,40}})));
  CDL.Logical.Sources.Constant                     resSig(k=false)
    "Reset signal"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

  Modelica.Blocks.Continuous.FirstOrder ControlProcess2(T=10, initType=Modelica.Blocks.Types.Init.InitialOutput)
    "Control Process 2"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  Modelica.Blocks.Continuous.FirstOrder ControlProcess1(
    k=1,
    T=10,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=0) "Control process 1"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Modelica.Blocks.Discrete.UnitDelay unitDelay(samplePeriod=240)
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Modelica.Blocks.Discrete.UnitDelay unitDelay1(samplePeriod=240)
    annotation (Placement(transformation(extent={{32,20},{52,40}})));
equation
  connect(resSig.y, PID.trigger) annotation (Line(points={{-58,50},{-20,50},{
          -20,12},{4,12},{4,18}},
                            color={255,0,255}));
  connect(PIDWitAutotuning.trigger, PID.trigger) annotation (Line(points={{-16,-32},
          {-16,-38},{-40,-38},{-40,6},{4,6},{4,18}},color={255,0,255}));
  connect(PIDWitAutotuning.u_s, PID.u_s) annotation (Line(points={{-22,-20},{-32,
          -20},{-32,10},{-14,10},{-14,30},{-2,30}},
                            color={0,0,127}));
  connect(Setpoint.y, PID.u_s) annotation (Line(points={{-58,10},{-14,10},{-14,30},
          {-2,30}},                color={0,0,127}));
  connect(ControlProcess2.y, PIDWitAutotuning.u_m) annotation (Line(points={{81,-20},
          {86,-20},{86,-38},{-10,-38},{-10,-32}},    color={0,0,127}));
  connect(PID.u_m, ControlProcess1.y) annotation (Line(points={{10,18},{10,0},{86,
          0},{86,30},{81,30}}, color={0,0,127}));
  connect(PIDWitAutotuning.y, unitDelay.u)
    annotation (Line(points={{2,-20},{18,-20}}, color={0,0,127}));
  connect(unitDelay.y, ControlProcess2.u)
    annotation (Line(points={{41,-20},{58,-20}}, color={0,0,127}));
  connect(ControlProcess1.u, unitDelay1.y)
    annotation (Line(points={{58,30},{53,30}}, color={0,0,127}));
  connect(unitDelay1.u, PID.y)
    annotation (Line(points={{30,30},{22,30}}, color={0,0,127}));
  annotation (
    experiment(
      StopTime=10000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/Validation/PIDWithInputGains.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithInputGains\">
Buildings.Controls.OBC.Utilities.PIDWithInputGains</a>.
</p>
<p>
For <i>t &isin; [0, 0.6]</i> both PID controllers have the same gains.
During this time, they generate the same output.
Afterwards, the gains, and hence also their outputs, differ.
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.PIDWithReset\">
Buildings.Controls.OBC.CDL.Continuous.PIDWithReset</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
May 17, 2022, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-80},{100,100}}),
      graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(extent={{-100,-80},{100,100}})));
end PIDWithAutotuningAmigoFOTD;
