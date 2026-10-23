within Buildings.Templates.Plants.Controls.StagingRotation;
block StageCompletion
  "Checks successful completion of stage change"
  parameter Integer nin = 0
    "Size of input array"
    annotation(Evaluate=true,
      Dialog(connectorSizing=true),
      HideResult=true);
  parameter Integer nPhp(final min=0, final max=div(nin, 2)) = 0
    "Number of polyvalent units"
    annotation(Evaluate=true);
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1[nin]
    "Equipment enable command"
    annotation(Placement(transformation(extent={{-200,-20},{-160,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1_actual[nin]
    "Equipment status"
    annotation(Placement(transformation(extent={{-200,-80},{-160,-40}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1End
    "Successful completion of stage change"
    annotation(Placement(transformation(extent={{160,80},{200,120}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1
    "Stage change in progress"
    annotation(Placement(transformation(extent={{160,-80},{200,-40}}),
      iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Logical.And enaAndOn[nin]
    "True if equipment enabled and on status returned"
    annotation(Placement(transformation(extent={{-70,-10},{-50,10}})));
  Buildings.Controls.OBC.CDL.Logical.Nor disAndOff[nin]
    "True if equipment disabled and off status returned"
    annotation(Placement(transformation(extent={{-70,-50},{-50,-30}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd allTru(nin=nin)
    "True if all inputs true"
    annotation(Placement(transformation(extent={{8,-10},{28,10}})));
  Buildings.Controls.OBC.CDL.Logical.Or onOrOff[nin]
    "True if on or off condition met"
    annotation(Placement(transformation(extent={{-30,-10},{-10,10}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge endStaPro
    "True when staging process terminates"
    annotation(Placement(transformation(extent={{130,90},{150,110}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lckChaSta
    "Lock stage change signal until conditions on equipment command and status met"
    annotation(Placement(transformation(extent={{90,90},{110,110}})));
  Buildings.Controls.OBC.CDL.Logical.Change cha[nin]
    "True if enable signal changes"
    annotation(Placement(transformation(extent={{-70,50},{-50,70}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lckAnyCha
    "Lock equipment command change signal until next stage change"
    annotation(Placement(transformation(extent={{10,50},{30,70}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyCha(nin=nin)
    "True if any enable signal changes"
    annotation(Placement(transformation(extent={{-30,50},{-10,70}})));
  Buildings.Controls.OBC.CDL.Logical.And chaAndMat
    "True if enable command changed and equipment status matches command"
    annotation(Placement(transformation(extent={{50,50},{70,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uSta
    "Stage index"
    annotation(Placement(transformation(extent={{-200,80},{-160,120}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Integers.Change chaSta
    "Return true when stage change is initiated"
    annotation(Placement(transformation(extent={{-130,90},{-110,110}})));
  Buildings.Controls.OBC.CDL.Logical.Pre u1Pre[nin]
    "Left-limit of signal to guard against concomitant stage change and command change"
    annotation(Placement(transformation(extent={{-150,-10},{-130,10}})));
  Buildings.Controls.OBC.CDL.Logical.And onInMod[2 * nPhp]
    if nPhp > 0
    "True if equipment returns on status while in commanded mode"
    annotation(Placement(transformation(extent={{-110,-110},{-90,-90}})));
equation
  connect(endStaPro.y, y1End)
    annotation(Line(points={{152,100},{180,100}},
      color={255,0,255}));
  connect(lckChaSta.y, y1)
    annotation(Line(points={{112,100},{120,100},{120,-60},{180,-60}},
      color={255,0,255}));
  connect(cha.y, anyCha.u)
    annotation(Line(points={{-48,60},{-32,60}},
      color={255,0,255}));
  connect(lckAnyCha.y, chaAndMat.u1)
    annotation(Line(points={{32,60},{48,60}},
      color={255,0,255}));
  connect(chaAndMat.y, lckChaSta.clr)
    annotation(Line(points={{72,60},{80,60},{80,94},{88,94}},
      color={255,0,255}));
  connect(lckChaSta.y, endStaPro.u)
    annotation(Line(points={{112,100},{128,100}},
      color={255,0,255}));
  connect(enaAndOn.y, onOrOff.u1)
    annotation(Line(points={{-48,0},{-32,0}},
      color={255,0,255}));
  connect(disAndOff.y, onOrOff.u2)
    annotation(Line(points={{-48,-40},{-40,-40},{-40,-8},{-32,-8}},
      color={255,0,255}));
  connect(onOrOff.y, allTru.u)
    annotation(Line(points={{-8,0},{6,0}},
      color={255,0,255}));
  connect(allTru.y, chaAndMat.u2)
    annotation(Line(points={{30,0},{40,0},{40,52},{48,52}},
      color={255,0,255}));
  connect(chaSta.y, lckChaSta.u)
    annotation(Line(points={{-108,100},{88,100}},
      color={255,0,255}));
  connect(chaSta.y, lckAnyCha.clr)
    annotation(Line(points={{-108,100},{0,100},{0,54},{8,54}},
      color={255,0,255}));
  connect(uSta, chaSta.u)
    annotation(Line(points={{-180,100},{-132,100}},
      color={255,127,0}));
  connect(anyCha.y, lckAnyCha.u)
    annotation(Line(points={{-8,60},{8,60}},
      color={255,0,255}));
  connect(u1, u1Pre.u)
    annotation(Line(points={{-180,0},{-152,0}},
      color={255,0,255}));
  connect(u1Pre.y, cha.u)
    annotation(Line(points={{-128,0},{-120,0},{-120,60},{-72,60}},
      color={255,0,255}));
  connect(u1_actual[nin - 2 * nPhp + 1:nin], onInMod.u2)
    annotation(Line(points={{-180,-60},{-140,-60},{-140,-108},{-112,-108}},
      color={255,0,255}));
  connect(u1Pre[nin - 2 * nPhp + 1:nin].y, onInMod.u1)
    annotation(Line(points={{-128,0},{-120,0},{-120,-100},{-112,-100}},
      color={255,0,255}));
  connect(u1_actual[1:nin - 2 * nPhp], enaAndOn[1:nin - 2 * nPhp].u2)
    annotation(Line(points={{-180,-60},{-100,-60},{-100,-8},{-72,-8}},
      color={255,0,255}));
  connect(u1_actual[1:nin - 2 * nPhp], disAndOff[1:nin - 2 * nPhp].u2)
    annotation(Line(points={{-180,-60},{-100,-60},{-100,-48},{-72,-48}},
      color={255,0,255}));
  connect(onInMod.y, enaAndOn[nin - 2 * nPhp + 1:nin].u2)
    annotation(Line(points={{-88,-100},{-80,-100},{-80,-8},{-72,-8}},
      color={255,0,255}));
  connect(onInMod.y, disAndOff[nin - 2 * nPhp + 1:nin].u2)
    annotation(Line(points={{-88,-100},{-80,-100},{-80,-48},{-72,-48}},
      color={255,0,255}));
  connect(u1Pre.y, enaAndOn.u1)
    annotation(Line(points={{-128,0},{-72,0}},
      color={255,0,255}));
  connect(u1Pre.y, disAndOff.u1)
    annotation(Line(points={{-128,0},{-120,0},{-120,-40},{-72,-40}},
      color={255,0,255}));
annotation(defaultComponentName="comSta",
  Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-100,-100},{100,100}}),
    graphics={Rectangle(extent={{-100,100},{100,-100}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid),
    Text(extent={{-150,170},{150,130}},
      textString="%name",
      textColor={0,0,255})}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
    extent={{-160,-140},{160,140}})),
  Documentation(
    info="<html>
<p>
  Block that detects a stage change and evaluates whether the stage transition
  is completed.
</p>
<p>
  The completion of a stage change is considered successful when both of the
  following conditions have been verified.
</p>
<ul>
  <li>
    Following a stage transition event, there is a change in the enable
    command of at least one equipment.
  </li>
  <li>
    After that change, every unit that is commanded on is proven on and every
    unit that is commanded off is proven off.
  </li>
</ul>
<p>
  The output signal <code>y1End</code> is true exactly at the time when the
  successful completion of the stage change is confirmed. The output signal
  <code>y1</code> is true during the entire time in which the stage change is
  in progress.
</p>
<h4>Polyvalent units</h4>
<p>
  Polyvalent units can switch mode without transiting through an off state.
  The enable command is specific to a given operating mode, whereas the
  returned status is not, and the active operating mode is not available as an
  input point. Therefore, a unit is considered proven on in a given mode if
  both the enable command for that mode and the returned status are true.
  Conversely, a unit is considered proven off in a given mode if either the
  enable command for that mode or the returned status is false. The latter
  condition implies that the completion of a stage down transition for a
  polyvalent unit resolves to a change in the enable command, and the returned
  status has no actual effect. The same applies to a stage up transition if
  the unit is already running in another mode: the returned status only has an
  actual effect when the unit starts from an off state. This is a limitation
  of the current logic, coming directly from the lack of the actual operating
  mode as an input point.
</p>
</html>",
    revisions="<html>
<ul>
  <li>
    July 10, 2026, by Antoine Gautier:<br />
    Use both enable command and returned status to handle multiple operating
    modes for polyvalent units.<br />
    This is for
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4512\">#4512</a>.
  </li>
  <li>
    June 26, 2024, by Antoine Gautier:<br />
    Replaced <code>hold</code> with <code>pre</code> to guard against
    concomitant stage change and command change.<br />
    This is for
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3787\">#3787</a>.
  </li>
  <li>
    March 29, 2024, by Antoine Gautier:<br />
    First implementation.
  </li>
</ul>
</html>"));
end StageCompletion;
