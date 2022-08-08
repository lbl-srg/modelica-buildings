within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Validation;
model PIDWithAutotuningAmigoFOTD "Test model for PIDWithAutotuning"
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant SetPoint(k=0.8)
    "Setpoint value"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  .Buildings.Controls.OBC.Utilities.PIDWithAutotuning.PIDWithAutotuningAmigoFOTD
    PIDWitAutotuning(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PID,
    yHig=1,
    yLow=0.1,
    deaBan=0.1,
    setPoint=0.8)
    "PID controller with an autotuning feature"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset PID(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PID,
    k=1,
    Ti=0.5,
    Td=0.1)
    "PID controller with constant gains"
     annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  CDL.Logical.Sources.Constant resSig(k=false)
    "Reset signal"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  CDL.Discrete.UnitDelay uniDel2(samplePeriod=240)
    "A dealy process for control process 2"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  CDL.Discrete.UnitDelay uniDel1(samplePeriod=240)
    "A dealy process for control process 1"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  CDL.Continuous.FirstOrder firstOrder1(y_start=0)
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  CDL.Continuous.Sources.Constant k(k=1) "Gain of the first order process"
    annotation (Placement(transformation(extent={{-20,80},{0,100}})));
  CDL.Continuous.Sources.Constant T(k=10)
    "Time constant of the first order process"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  CDL.Continuous.FirstOrder firstOrder2(y_start=0)
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
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
  connect(PIDWitAutotuning.y, uniDel2.u)
    annotation (Line(points={{2,-20},{18,-20}}, color={0,0,127}));
  connect(uniDel1.u, PID.y)
    annotation (Line(points={{18,30},{2,30}}, color={0,0,127}));
  connect(uniDel1.y, firstOrder1.u)
    annotation (Line(points={{42,30},{58,30}}, color={0,0,127}));
  connect(firstOrder1.y, PID.u_m) annotation (Line(points={{82,30},{90,30},{90,8},
          {-10,8},{-10,18}}, color={0,0,127}));
  connect(firstOrder2.u, uniDel2.y)
    annotation (Line(points={{58,-20},{42,-20}}, color={0,0,127}));
  connect(firstOrder2.y, PIDWitAutotuning.u_m) annotation (Line(points={{82,-20},
          {90,-20},{90,-40},{-10,-40},{-10,-32}}, color={0,0,127}));
  connect(firstOrder1.k, k.y) annotation (Line(points={{58,38},{48,38},{48,90},{
          2,90}}, color={0,0,127}));
  connect(T.y, firstOrder1.T) annotation (Line(points={{22,60},{44,60},{44,34},{
          58,34}}, color={0,0,127}));
  connect(firstOrder2.k, k.y) annotation (Line(points={{58,-12},{52,-12},{52,38},
          {48,38},{48,90},{2,90}}, color={0,0,127}));
  connect(firstOrder2.T, firstOrder1.T) annotation (Line(points={{58,-16},{44,-16},
          {44,34},{58,34}}, color={0,0,127}));
  annotation (
    experiment(
      StopTime=10000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/PIDWithAutotuning/Validation/PIDWithAutotuningAmigoFOTD.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.PIDWithAutotuningAmigoFOTD\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.PIDWithAutotuningAmigoFOTD</a>.
</p>
<p>
This example is to compare the output of a PID controller with an autotuning feature to that of another PID controller with arbitary gains
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
end PIDWithAutotuningAmigoFOTD;
