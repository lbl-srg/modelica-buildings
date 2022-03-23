within Buildings.Controls.OBC.CDL.Continuous.Validation;
model FOTD "Validation model for the AMIGOWithFOTD block"

  Buildings.Controls.OBC.CDL.Continuous.AMIGOWithFOTD FOTD(controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PID)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=1.2,
    f=1/60,
    offset=0.3,
    startTime=0.025)                                      "Sine source"
    annotation (Placement(transformation(extent={{-82,30},{-62,50}})));
  Modelica.Blocks.Sources.Constant const(k=0) annotation (Placement(transformation(extent={{-82,-10},{-62,10}})));
  Buildings.Controls.OBC.CDL.Continuous.NormalizedDelay NormalizedDelay(gamma=3) annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Discrete.Relay                            relay(
    yUpperLimit=4,
    yLowerLimit=-0.5,
    deadBand=0.5)
                annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
equation
  connect(sine.y, relay.u1) annotation (Line(points={{-61,40},{-52,40},{-52,34},{-41,34}}, color={0,0,127}));
  connect(relay.u2, const.y) annotation (Line(points={{-41,25.6},{-52,25.6},{-52,0},{-61,0}}, color={0,0,127}));
  connect(FOTD.tau, NormalizedDelay.y) annotation (Line(points={{18,10},{-8,10},{-8,-50},{-18,-50}}, color={0,0,127}));
  connect(relay.dtON, FOTD.dtON) annotation (Line(points={{-19,32},{10,32},{10,-5.8},{18,-5.8}}, color={0,0,127}));
  connect(NormalizedDelay.dtON, FOTD.dtON)
    annotation (Line(points={{-42,-44},{-48,-44},{-48,18},{-8,18},{-8,34},{10,34},{10,-5.8},{18,-5.8}}, color={0,0,127}));
  connect(relay.dtOFF, FOTD.dtOFF) annotation (Line(points={{-19,24},{-4,24},{-4,-10},{18,-10}}, color={0,0,127}));
  connect(NormalizedDelay.dtOFF, FOTD.dtOFF)
    annotation (Line(points={{-42,-56},{-58,-56},{-58,-16},{-12,-16},{-12,25.6},{-4,25.6},{-4,-10},{18,-10}}, color={0,0,127}));
  connect(relay.uDiff, FOTD.ProcessOutput) annotation (Line(points={{-19,20},{2,20},{2,4.8},{18,4.8}}, color={0,0,127}));
  connect(FOTD.RelayOutput, relay.y) annotation (Line(points={{18,0},{6,0},{6,28},{-19,28}}, color={0,0,127}));
  connect(relay.experimentStart, FOTD.experimentStart) annotation (Line(points={{-19,36},{24.4,36},{24.4,12}}, color={255,0,255}));
  connect(relay.experimentEnd, FOTD.experimentEnd) annotation (Line(points={{-19,40},{35.4,40},{35.4,12}}, color={255,0,255}));
  annotation (
    experiment(
      StopTime=120,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Continuous/Validation/FOTD.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.Tan\">
Buildings.Controls.OBC.CDL.Continuous.Tan</a>.
</p>
<p>
The input <code>u</code> varies from <i>-1.5</i> to <i>+1.5</i>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 22, 2017, by Jianjun Hu:<br/>
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
end FOTD;
