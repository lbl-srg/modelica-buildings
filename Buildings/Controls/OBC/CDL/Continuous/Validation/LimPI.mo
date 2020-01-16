within Buildings.Controls.OBC.CDL.Continuous.Validation;
model LimPI "Test model for LimPI controller"
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pulse(period=0.25)
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant const(k=0.5)
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));

  Buildings.Controls.OBC.CDL.Continuous.LimPI  limPI(
    Ti=1,
    yMax=1,
    yMin=-1,
    initType=Buildings.Controls.OBC.CDL.Types.Init.InitialState,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI)
    "PI controller with limiter"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));

  Buildings.Controls.OBC.CDL.Continuous.LimPI  limP(
    Ti=1,
    yMax=1,
    yMin=-1,
    initType=Buildings.Controls.OBC.CDL.Types.Init.InitialState,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P)
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.LimPI noLimPI(
    Ti=1,
    yMax=1e15,
    yMin=-1,
    initType=Buildings.Controls.OBC.CDL.Types.Init.InitialState,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI)
    "PI controller without limit"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPI resPI(
    Ti=1,
    yMax=1,
    yMin=-1,
    initType=Buildings.Controls.OBC.CDL.Types.Init.InitialState,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    reset=Buildings.Controls.OBC.CDL.Types.Reset.Input)
    "PI controller with reset"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Sources.Constant                                       const1(k=0.1)
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Logical.Sources.Pulse booPul(period=1)
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Logical.Not not1
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
equation
  connect(pulse.y, limPI.u_s) annotation (Line(points={{-18,60},{-4,60},{-4,70},
          {18,70}},  color={0,0,127}));
  connect(pulse.y, limP.u_s) annotation (Line(points={{-18,60},{-4,60},{-4,-70},
          {18,-70}},  color={0,0,127}));
  connect(const.y, limPI.u_m) annotation (Line(points={{-18,20},{-10,20},{-10,52},
          {30,52},{30,58}}, color={0,0,127}));
  connect(const.y, limP.u_m) annotation (Line(points={{-18,20},{-10,20},{-10,-90},
          {30,-90},{30,-82}}, color={0,0,127}));
  connect(const.y, resPI.u_m) annotation (Line(points={{-18,20},{-10,20},{-10,-30},
          {30,-30},{30,-22}}, color={0,0,127}));
  connect(pulse.y, resPI.u_s) annotation (Line(points={{-18,60},{-4,60},{-4,-10},
          {18,-10}}, color={0,0,127}));
  connect(const1.y, resPI.y_reset_in) annotation (Line(points={{-18,-20},{8,-20},
          {8,-18},{18,-18}}, color={0,0,127}));
  connect(pulse.y, noLimPI.u_s) annotation (Line(points={{-18,60},{-4,60},{-4,30},
          {18,30}}, color={0,0,127}));
  connect(const.y, noLimPI.u_m) annotation (Line(points={{-18,20},{-10,20},{-10,
          10},{30,10},{30,18}}, color={0,0,127}));
  connect(booPul.y, not1.u)
    annotation (Line(points={{-58,-50},{-42,-50}}, color={255,0,255}));
  connect(not1.y, resPI.trigger)
    annotation (Line(points={{-18,-50},{22,-50},{22,-22}}, color={255,0,255}));
 annotation (
 experiment(StopTime=1.0, Tolerance=1e-06),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Continuous/Validation/LimPI.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.LimPI\">
Buildings.Controls.OBC.CDL.Continuous.LimPI</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 14, 2020, by Jianjun Hu:<br/>
Reimplemented the controller to remove derivative controller and use as many CDL
elementary block as possible. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1700\">
issue 1700</a>.
</li>
<li>
March 24, 2017, by Jianjun Hu:<br/>
Added into CDL, simplified the validation model.
</li>
<li>
April 26, 2016, by Michael Wetter:<br/>
Relaxed tolerance of assertions from <i>1E-10</i>
to <i>1E-3</i> as the default relative tolerance in JModelica
is <i>1E-4</i>.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/510\">
Buildings, issue 510</a>.
</li>
<li>
November 21, 2011, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}));
end LimPI;
