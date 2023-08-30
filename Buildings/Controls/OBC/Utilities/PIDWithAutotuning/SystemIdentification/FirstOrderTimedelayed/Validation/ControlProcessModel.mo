within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.Validation;
model ControlProcessModel
  "Test model for identifying the reduced-order model of the control process"
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.ControlProcessModel
    conProMod(yLow=0.1, deaBan=0.05)
    "Calculate the parameters of a first-order model"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse u(
    amplitude=0.5,
    width=0.125,
    period=0.8,
    offset=0.5)
    "The response of a relay controller"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse tOn(
    amplitude=-0.1,
    width=0.1,
    period=1,
    offset=0.1)
    "The length of the On period"
    annotation (Placement(transformation(extent={{-80,42},{-60,62}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse tOff(
    amplitude=-0.7,
    width=0.8,
    period=1,
    offset=0.7)
    "The length of the Off period"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse tunSta(
    width=0.9,
    period=1,
    shift=-0.9)
    "The signal for the tuning period starts"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse tunEnd(
    width=0.1,
    period=1,
    shift=0.9)
    "The signal for the tuning period ends"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse ratioLT(
    amplitude=-0.1,
    width=0.4,
    period=0.8,
    offset=0.4)
    "Ratio between the time constant and the time delay"
    annotation (Placement(transformation(extent={{-48,-40},{-28,-20}})));
equation
  connect(tunSta.y, conProMod.triSta)
    annotation (Line(points={{-58,-50},{-6,-50},{-6,-12}}, color={255,0,255}));
  connect(conProMod.triEnd, tunEnd.y)
    annotation (Line(points={{6,-12},{6,-90},{-58,-90}}, color={255,0,255}));
  connect(u.y, conProMod.u) annotation (Line(points={{-58,90},{-20,90},{-20,8},{
          -12,8}}, color={0,0,127}));
  connect(tOn.y, conProMod.tOn) annotation (Line(points={{-58,52},{-30,52},{-30,
          4},{-12,4}}, color={0,0,127}));
  connect(conProMod.tOff, tOff.y) annotation (Line(points={{-12,-4},{-40,-4},{-40,
          10},{-58,10}}, color={0,0,127}));
  connect(ratioLT.y, conProMod.tau) annotation (Line(points={{-26,-30},{-20,-30},
          {-20,-8},{-12,-8}}, color={0,0,127}));
  annotation (
      experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/PIDWithAutotuning/SystemIdentification/FirstOrderTimedelayed/Validation/ControlProcessModel.mos" "Simulate and plot"),
    Icon( coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}),
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
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
June 1, 2022, by Sen Huang:<br/>
First implementation<br/>
</li>
</ul>
</html>", info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.ControlProcessModel\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.ControlProcessModel</a>.
</p>
This example considers an output from a relay controller, which is described below:
<ul>
<li>
At <i>0.1</i>s, the output switches from On to Off.
</li>
<li>
At <i>0.8</i>s, the output switches to On.
</li>
<li>
At <i>0.9</i>s, the output switches to Off.
</li>
</ul>
This output triggers an autotuning process that lasts from <i>0.1</i>s to <i>0.9</i>s.
</html>"));
end ControlProcessModel;
