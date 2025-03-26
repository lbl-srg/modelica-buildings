within Buildings.Controls.OBC.CDL.Reals.Validation;
model PID
  "Test model for PID controller"
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pulse(
    period=0.25)
    "Setpoint"
    annotation (Placement(transformation(extent={{-90,14},{-70,34}})));
  Buildings.Controls.OBC.CDL.Reals.PID limPID(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PID,
    Ti=1,
    Td=1,
    yMin=-1)
    "PID controller"
    annotation (Placement(transformation(extent={{-30,40},{-10,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant const(
    k=0.5)
    "Measurement data"
    annotation (Placement(transformation(extent={{-90,-22},{-70,-2}})));
  Buildings.Controls.OBC.CDL.Reals.PID limPI(
    Ti=1,
    Td=1,
    yMin=-1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI)
    "PI controller"
    annotation (Placement(transformation(extent={{-30,2},{-10,22}})));
  Buildings.Controls.OBC.CDL.Reals.PID limPD(
    Ti=1,
    Td=1,
    yMin=-1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PD)
    "PD controller"
    annotation (Placement(transformation(extent={{-30,-30},{-10,-10}})));
  Buildings.Controls.OBC.CDL.Reals.PID limP(
    Ti=1,
    Td=1,
    yMin=-1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P)
    "P controller"
    annotation (Placement(transformation(extent={{-30,-60},{-10,-40}})));
  Buildings.Controls.OBC.CDL.Reals.PID noLimPID(
    Ti=1,
    Td=1,
    yMax=1e15,
    yMin=-1e15,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PID)
    "PID controller with no output limit"
    annotation (Placement(transformation(extent={{-30,-90},{-10,-70}})));

equation
  connect(pulse.y,limPID.u_s)
    annotation (Line(points={{-68,24},{-54,24},{-54,50},{-32,50}},color={0,0,127}));
  connect(const.y,limPID.u_m)
    annotation (Line(points={{-68,-12},{-62,-12},{-62,30},{-20,30},{-20,38}},color={0,0,127}));
  connect(const.y,limPI.u_m)
    annotation (Line(points={{-68,-12},{-62,-12},{-62,-2},{-20,-2},{-20,0}},color={0,0,127}));
  connect(const.y,limPD.u_m)
    annotation (Line(points={{-68,-12},{-62,-12},{-62,-34},{-20,-34},{-20,-32}},color={0,0,127}));
  connect(pulse.y,limPI.u_s)
    annotation (Line(points={{-68,24},{-54,24},{-54,12},{-32,12}},color={0,0,127}));
  connect(pulse.y,limPD.u_s)
    annotation (Line(points={{-68,24},{-54,24},{-54,-20},{-32,-20}},color={0,0,127}));
  connect(pulse.y,limP.u_s)
    annotation (Line(points={{-68,24},{-54,24},{-54,-50},{-32,-50}},color={0,0,127}));
  connect(pulse.y,noLimPID.u_s)
    annotation (Line(points={{-68,24},{-54,24},{-54,-80},{-32,-80}},color={0,0,127}));
  connect(const.y,limP.u_m)
    annotation (Line(points={{-68,-12},{-62,-12},{-62,-64},{-20,-64},{-20,-62}},color={0,0,127}));
  connect(const.y,noLimPID.u_m)
    annotation (Line(points={{-68,-12},{-62,-12},{-62,-96},{-20,-96},{-20,-92}},color={0,0,127}));
  annotation (
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Reals/Validation/PID.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Reals.PID\">
Buildings.Controls.OBC.CDL.Reals.PID</a>.
This tests the different settings for the controller types.
</p>
</html>",
      revisions="<html>
<ul>
<li>
October 15, 2020, by Michael Wetter:<br/>
Removed instance <code>limPIDOri</code> which was identical to <code>limPID</code>.
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
    Icon(
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
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}));
end PID;
