within Buildings.Controls.OBC.Utilities.Validation;
model PIDWithEnable
  "Test model for PID controller with enable signal"
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pulse(
    period=0.25) "Setpoint"
    annotation (Placement(transformation(extent={{-90,14},{-70,34}})));
  Buildings.Controls.OBC.Utilities.PIDWithEnable limPID(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PID,
    Ti=1,
    Td=1,
    yMin=-1)
    "PID controller"
    annotation (Placement(transformation(extent={{-30,60},{-10,80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant const(
    k=0.5)
    "Measurement data"
    annotation (Placement(transformation(extent={{-90,-22},{-70,-2}})));
  Buildings.Controls.OBC.Utilities.PIDWithEnable limPI(
    Ti=1,
    Td=1,
    yMin=-1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI)
    "PI controller"
    annotation (Placement(transformation(extent={{-30,20},{-10,40}})));
  Buildings.Controls.OBC.Utilities.PIDWithEnable limPD(
    Ti=1,
    Td=1,
    yMin=-1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PD)
    "PD controller"
    annotation (Placement(transformation(extent={{-30,-20},{-10,0}})));
  Buildings.Controls.OBC.Utilities.PIDWithEnable limP(
    Ti=1,
    Td=1,
    yMin=-1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P)
    "P controller"
    annotation (Placement(transformation(extent={{-30,-50},{-10,-30}})));
  Buildings.Controls.OBC.Utilities.PIDWithEnable noLimPID(
    Ti=1,
    Td=1,
    yMax=1e15,
    yMin=-1e15,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PID)
    "PID controller with no output limit"
    annotation (Placement(transformation(extent={{-30,-90},{-10,-70}})));

  CDL.Logical.Sources.Pulse ena(period=0.25/4) "Enable signal"
    annotation (Placement(transformation(extent={{-90,-54},{-70,-34}})));
equation
  connect(pulse.y,limPID.u_s)
    annotation (Line(points={{-68,24},{-54,24},{-54,70},{-32,70}},color={0,0,127}));
  connect(const.y,limPID.u_m)
    annotation (Line(points={{-68,-12},{-62,-12},{-62,48},{-20,48},{-20,58}},color={0,0,127}));
  connect(const.y,limPI.u_m)
    annotation (Line(points={{-68,-12},{-62,-12},{-62,10},{-20,10},{-20,18}},
                                                                            color={0,0,127}));
  connect(const.y,limPD.u_m)
    annotation (Line(points={{-68,-12},{-62,-12},{-62,-26},{-20,-26},{-20,-22}},color={0,0,127}));
  connect(pulse.y,limPI.u_s)
    annotation (Line(points={{-68,24},{-54,24},{-54,30},{-32,30}},color={0,0,127}));
  connect(pulse.y,limPD.u_s)
    annotation (Line(points={{-68,24},{-54,24},{-54,-10},{-32,-10}},color={0,0,127}));
  connect(pulse.y,limP.u_s)
    annotation (Line(points={{-68,24},{-54,24},{-54,-40},{-32,-40}},color={0,0,127}));
  connect(pulse.y,noLimPID.u_s)
    annotation (Line(points={{-68,24},{-54,24},{-54,-80},{-32,-80}},color={0,0,127}));
  connect(const.y,limP.u_m)
    annotation (Line(points={{-68,-12},{-62,-12},{-62,-56},{-20,-56},{-20,-52}},color={0,0,127}));
  connect(const.y,noLimPID.u_m)
    annotation (Line(points={{-68,-12},{-62,-12},{-62,-96},{-20,-96},{-20,-92}},color={0,0,127}));
  connect(ena.y, limPID.uEna) annotation (Line(points={{-68,-44},{-48,-44},{-48,
          52},{-24,52},{-24,58}}, color={255,0,255}));
  connect(ena.y, limPI.uEna) annotation (Line(points={{-68,-44},{-48,-44},{-48,14},
          {-24,14},{-24,18}}, color={255,0,255}));
  connect(ena.y, limPD.uEna) annotation (Line(points={{-68,-44},{-48,-44},{-48,-24},
          {-24,-24},{-24,-22}}, color={255,0,255}));
  connect(ena.y, limP.uEna) annotation (Line(points={{-68,-44},{-48,-44},{-48,-54},
          {-24,-54},{-24,-52}}, color={255,0,255}));
  connect(ena.y, noLimPID.uEna) annotation (Line(points={{-68,-44},{-48,-44},{-48,
          -94},{-24,-94},{-24,-92}}, color={255,0,255}));
  annotation (
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/Validation/PIDWithEnable.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.Utilities.Validation.PIDWithEnable\">
Buildings.Controls.OBC.Utilities.Validation.PIDWithEnable</a>.
This tests the different settings for the controller types.
</p>
</html>",
      revisions="<html>
<ul>
<li>
November 15, 2025, by Michael Wetter:<br/>
First implementation.
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
end PIDWithEnable;
