within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant;
block DisableLatest "Sequence to latest running device"
  parameter Integer num = 2
    "Total number of devices";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDevSta[num]
    "Current devices operation status"
    annotation (Placement(transformation(extent={{-220,20},{-180,60}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDis "Disable input"
    annotation (Placement(transformation(extent={{-220,-50},{-180,-10}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDevSta[num]
    "Devices status after enabling one more device"
    annotation (Placement(transformation(extent={{180,-40},{200,-20}}),
      iconTransformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim[num](
    each reset=true) "Timer of devices run time"
    annotation (Placement(transformation(extent={{-140,30},{-120,50}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMin multiMin(nin=2)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi[num] "Logical switch"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai(k=-1) "Gain"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep(nout=num) "Replicate real input"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2[num] "Add real inputs"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Buildings.Controls.OBC.CDL.Continuous.LessEqualThreshold lesEquThr[num](
    each threshold=5)
    "Check if input is zero (with 5 seconds as a deadband)"
    annotation (Placement(transformation(extent={{140,-40},{160,-20}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(nout=num)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-140,-40},{-120,-20}})));

equation
  connect(uDevSta, tim.u)
    annotation (Line(points={{-200,40},{-142,40}},   color={255,0,255}));
  connect(tim.y, multiMin.u)
    annotation (Line(points={{-119,40},{-100,40},{-100,0},{-82,0}},
      color={0,0,127}));
  connect(multiMin.yMin, gai.u)
    annotation (Line(points={{-59,0},{-42,0}}, color={0,0,127}));
  connect(gai.y, reaRep.u)
    annotation (Line(points={{-19,0},{-2,0}}, color={0,0,127}));
  connect(reaRep.y, add2.u2)
    annotation (Line(points={{21,0},{30,0},{30,14},{38,14}}, color={0,0,127}));
  connect(tim.y, add2.u1)
    annotation (Line(points={{-119,40},{-100,40},{-100,26},{38,26}},
      color={0,0,127}));
  connect(add2.y, swi.u1)
    annotation (Line(points={{61,20},{80,20},{80,-22},{98,-22}},
      color={0,0,127}));
  connect(tim.y, swi.u3)
    annotation (Line(points={{-119,40},{-100,40},{-100,-38},{98,-38}},
      color={0,0,127}));
  connect(swi.y, lesEquThr.u)
    annotation (Line(points={{121,-30},{138,-30}}, color={0,0,127}));
  connect(lesEquThr.y, yDevSta)
    annotation (Line(points={{161,-30},{190,-30}}, color={255,0,255}));
  connect(uDis, booRep.u)
    annotation (Line(points={{-200,-30},{-142,-30}}, color={255,0,255}));
  connect(booRep.y, swi.u2)
    annotation (Line(points={{-119,-30},{98,-30}}, color={255,0,255}));

annotation (
  defaultComponentName = "disLat",
  Diagram(coordinateSystem(preserveAspectRatio=false,
    extent={{-180,-60},{180,60}})),
    Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-102,8},{-50,-4}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uDevSta"),
        Text(
          extent={{-98,-70},{-68,-84}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uDis"),
        Text(
          extent={{58,6},{98,-6}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yDevSta"),
        Text(
          extent={{-72,78},{58,28}},
          lineColor={192,192,192},
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175},
          textString="Disable Latest")}),
Documentation(info="<html>
<p>
Block that disable most recently turned on device. Input <code>uDevSta</code>
is the operation status of each device. Running time of all device are recorded.
When the input <code>uDis</code> becomes true, the most recently turned on 
device will be disabled.
</p>

</html>",
revisions="<html>
<ul>
<li>
August 17, 2018, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end DisableLatest;
