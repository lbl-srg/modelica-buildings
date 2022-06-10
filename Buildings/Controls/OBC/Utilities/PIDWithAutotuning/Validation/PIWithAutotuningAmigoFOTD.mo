within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Validation;
model PIWithAutotuningAmigoFOTD "Test model for PIDWithAutotuning"
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant SetPoint(k=0.8)
    "Setpoint value"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  .Buildings.Controls.OBC.Utilities.PIDWithAutotuning.PIDWithAutotuningAmigoFOTD
    PIDWitAutotuning(controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    yHig=1,
    yLow=0.1,
    deaBan=0.1,
    setPoint=0.8)
    "PID controller with an autotuning feature"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset PID(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=1,
    Ti=0.5,
    Td=0.1)
    "PID controller with constant gains"
     annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  CDL.Logical.Sources.Constant resSig(k=false)
    "Reset signal"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  Modelica.Blocks.Continuous.FirstOrder FirstOrderProcess2(T=10, initType=
        Modelica.Blocks.Types.Init.InitialOutput)
    "A first-order process for control process 2"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  Modelica.Blocks.Continuous.FirstOrder FirstOrderProcess1(
    k=1,
    T=10,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=0) "A first-order process for control process 1"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Modelica.Blocks.Discrete.UnitDelay unitDelay2(samplePeriod=240)
    "A dealy process for control process 2"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Modelica.Blocks.Discrete.UnitDelay unitDelay1(samplePeriod=240)
    "A dealy process for control process 1"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
equation
  connect(resSig.y, PID.trigger) annotation (Line(points={{-58,70},{-48,70},{-48,
          12},{-16,12},{-16,18}},
                            color={255,0,255}));
  connect(PIDWitAutotuning.trigger, PID.trigger) annotation (Line(points={{-16,-32},
          {-16,-38},{-30,-38},{-30,12},{-16,12},{-16,18}},
                                                    color={255,0,255}));
  connect(PIDWitAutotuning.u_s, PID.u_s) annotation (Line(points={{-22,-20},{-50,
          -20},{-50,30},{-22,30}},
                            color={0,0,127}));
  connect(SetPoint.y, PID.u_s) annotation (Line(points={{-58,10},{-50,10},{-50,30},
          {-22,30}},               color={0,0,127}));
  connect(FirstOrderProcess2.y, PIDWitAutotuning.u_m) annotation (Line(points={{
          81,-20},{86,-20},{86,-38},{-10,-38},{-10,-32}}, color={0,0,127}));
  connect(PID.u_m, FirstOrderProcess1.y) annotation (Line(points={{-10,18},{-10,
          12},{86,12},{86,30},{81,30}}, color={0,0,127}));
  connect(PIDWitAutotuning.y, unitDelay2.u)
    annotation (Line(points={{2,-20},{18,-20}}, color={0,0,127}));
  connect(unitDelay2.y, FirstOrderProcess2.u)
    annotation (Line(points={{41,-20},{58,-20}}, color={0,0,127}));
  connect(FirstOrderProcess1.u, unitDelay1.y)
    annotation (Line(points={{58,30},{41,30}}, color={0,0,127}));
  connect(unitDelay1.u, PID.y)
    annotation (Line(points={{18,30},{2,30}},  color={0,0,127}));
  annotation (
    experiment(
      StopTime=10000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/PIDWithAutotuning/Validation/PIWithAutotuningAmigoFOTD.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.PIDWithAutotuningAmigoFOTD\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.PIDWithAutotuningAmigoFOTD</a>.
</p>
<p>
This example is to compare the output of a PI controller with an autotuning feature to that of another PI controller with arbitary gains
</p>
</html>",
      revisions="<html>
<ul>
<li>
June 1, 2022, by Sen Huang:<br/>
First implementation<br/>
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
end PIWithAutotuningAmigoFOTD;
