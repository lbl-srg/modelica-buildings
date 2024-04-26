within Buildings.Templates.Plants.Controls.StagingRotation;
block StageCompletion
  "Checks successful completion of stage change"
  parameter Integer nin=0
    "Size of input array"
    annotation (Evaluate=true,
    Dialog(connectorSizing=true),HideResult=true);
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1[nin]
    "Equipment enable command"
    annotation (Placement(transformation(extent={{-200,-20},{-160,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1_actual[nin]
    "Equipment status"
    annotation (Placement(transformation(extent={{-200,-80},{-160,-40}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1End
    "Successful completion of stage change"
    annotation (Placement(transformation(extent={{160,80},{200,120}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1
    "Stage change in progress"
    annotation (Placement(transformation(extent={{160,-80},{200,-40}}),
      iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Logical.And enaAndOn[nin]
    "True if equipment enabled and on status returned"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Controls.OBC.CDL.Logical.Nor disAndOff[nin]
    "True if equipment disabled and off status returned"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd allTru(
    nin=nin)
    "True if all inputs true"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Buildings.Controls.OBC.CDL.Logical.Or onOrOff[nin]
    "True if on or off condition met"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge endStaPro
    "True when staging process terminates"
    annotation (Placement(transformation(extent={{120,90},{140,110}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lckChaSta
    "Lock stage change signal until conditions on equipment command and status met"
    annotation (Placement(transformation(extent={{30,90},{50,110}})));
  Buildings.Controls.OBC.CDL.Logical.Change cha[nin]
    "True if enable signal changes"
    annotation (Placement(transformation(extent={{-130,50},{-110,70}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lckAnyCha
    "Lock equipment command change signal until next stage change"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyCha(
    nin=nin)
    "True if any enable signal changes"
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));
  Buildings.Controls.OBC.CDL.Logical.And chaAndMat
    "True if enable command changed and equipment status matches command"
    annotation (Placement(transformation(extent={{30,50},{50,70}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold holAnyCha(
    trueHoldDuration=1,
    falseHoldDuration=0)
    "Hold signal to guard against concomitant stage change and command change"
    annotation (Placement(transformation(extent={{-50,50},{-30,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uSta
    "Stage index"
    annotation (Placement(transformation(extent={{-200,80},{-160,120}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Integers.Change chaSta
    "Return true when stage change is initiated"
    annotation (Placement(transformation(extent={{-130,90},{-110,110}})));
equation
  connect(u1_actual, disAndOff.u2)
    annotation (Line(points={{-180,-60},{-60,-60},{-60,-48},{-52,-48}},color={255,0,255}));
  connect(u1_actual, enaAndOn.u2)
    annotation (Line(points={{-180,-60},{-60,-60},{-60,-8},{-52,-8}},color={255,0,255}));
  connect(endStaPro.y, y1End)
    annotation (Line(points={{142,100},{180,100}},color={255,0,255}));
  connect(lckChaSta.y, y1)
    annotation (Line(points={{52,100},{100,100},{100,-60},{180,-60}},color={255,0,255}));
  connect(cha.y, anyCha.u)
    annotation (Line(points={{-108,60},{-92,60}},color={255,0,255}));
  connect(u1, cha.u)
    annotation (Line(points={{-180,0},{-140,0},{-140,60},{-132,60}},color={255,0,255}));
  connect(u1, enaAndOn.u1)
    annotation (Line(points={{-180,0},{-52,0}},color={255,0,255}));
  connect(lckAnyCha.y, chaAndMat.u1)
    annotation (Line(points={{12,60},{28,60}},color={255,0,255}));
  connect(chaAndMat.y, lckChaSta.clr)
    annotation (Line(points={{52,60},{60,60},{60,80},{20,80},{20,94},{28,94}},
      color={255,0,255}));
  connect(lckChaSta.y, endStaPro.u)
    annotation (Line(points={{52,100},{118,100}},color={255,0,255}));
  connect(u1, disAndOff.u1)
    annotation (Line(points={{-180,0},{-140,0},{-140,-40},{-52,-40}},color={255,0,255}));
  connect(enaAndOn.y, onOrOff.u1)
    annotation (Line(points={{-28,0},{-12,0}},color={255,0,255}));
  connect(disAndOff.y, onOrOff.u2)
    annotation (Line(points={{-28,-40},{-20,-40},{-20,-8},{-12,-8}},color={255,0,255}));
  connect(onOrOff.y, allTru.u)
    annotation (Line(points={{12,0},{28,0}},color={255,0,255}));
  connect(allTru.y, chaAndMat.u2)
    annotation (Line(points={{52,0},{60,0},{60,40},{20,40},{20,52},{28,52}},
      color={255,0,255}));
  connect(anyCha.y, holAnyCha.u)
    annotation (Line(points={{-68,60},{-52,60}},color={255,0,255}));
  connect(holAnyCha.y, lckAnyCha.u)
    annotation (Line(points={{-28,60},{-12,60}},color={255,0,255}));
  connect(chaSta.y, lckChaSta.u)
    annotation (Line(points={{-108,100},{28,100}},color={255,0,255}));
  connect(chaSta.y, lckAnyCha.clr)
    annotation (Line(points={{-108,100},{-20,100},{-20,54},{-12,54}},color={255,0,255}));
  connect(uSta, chaSta.u)
    annotation (Line(points={{-180,100},{-132,100}},color={255,127,0}));
  annotation (
    defaultComponentName="comSta",
    Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,170},{150,130}},
          textString="%name",
          textColor={0,0,255})}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-160,-140},{160,140}})),
    Documentation(
      info="<html>
<p>
Block that detects a stage change and evaluates whether the stage
transition is completed.
</p>
<p>
The completion of a stage change is considered successful when
both of the following conditions have been verified.
</p>
<ul>
<li>
Following a stage transition event, or exactly at the same time,
there is a change in the enable command of at least one equipment.
</li>
<li>
The equipment status matches the enable command for all units,
after any change in the enable command has been detected.
</li>
</ul>
<p>
The output signal <code>y1End</code> is true exactly at the time when
the successful completion of the stage change is confirmed.
The output signal <code>y1</code> is true during the entire time in which
the stage change is in progress.
</p>
</html>"));
end StageCompletion;
