within Buildings.Controls.OBC.DemandFlexibility.Generic;
block SetpointMultipleStepChange

   parameter Real delCha=1
    "Change amount";

    parameter Real samPer(unit="s")=300
    "Sample period";
  CDL.Discrete.Sampler                        sam(samplePeriod=samPer)
    annotation (Placement(transformation(extent={{166,-10},{186,10}})));
  CDL.Interfaces.RealInput uSetTar "setpoint target"
    annotation (Placement(transformation(extent={{-140,-46},{-100,-6}})));
  CDL.Interfaces.RealInput uSetOrg "original setpoint"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  CDL.Interfaces.RealOutput ySetCom "setpoint command"
    annotation (Placement(transformation(extent={{200,-20},{240,20}})));
  CDL.Interfaces.BooleanInput
                           have_pri "have priority"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  CDL.Interfaces.RealInput uSetCur "current setpoint"
    annotation (Placement(transformation(extent={{-140,14},{-100,54}})));
  CDL.Reals.Add                        add
    annotation (Placement(transformation(extent={{-48,-62},{-28,-42}})));
  CDL.Reals.Min                        min1
    annotation (Placement(transformation(extent={{86,36},{106,56}})));
  CDL.Reals.Max                        max1
    annotation (Placement(transformation(extent={{46,8},{66,28}})));
  CDL.Reals.Sources.Constant con(k=delCha)
    annotation (Placement(transformation(extent={{-86,-68},{-66,-48}})));
  CDL.Reals.Switch swi
    annotation (Placement(transformation(extent={{38,-70},{58,-50}})));
  CDL.Reals.Min                        min2
    annotation (Placement(transformation(extent={{88,-32},{108,-12}})));
  CDL.Reals.Max                        max2
    annotation (Placement(transformation(extent={{132,-10},{152,10}})));
  CDL.Interfaces.BooleanOutput reach_uSetTar annotation (Placement(
        transformation(extent={{200,60},{240,100}}),iconTransformation(extent={{200,56},
            {240,96}})));
  CDL.Interfaces.BooleanOutput reach_uSetOrg annotation (Placement(
        transformation(extent={{200,-92},{240,-52}}), iconTransformation(extent={{200,-88},
            {240,-48}})));
  ExactEqualReal exactEqualReal
    annotation (Placement(transformation(extent={{48,98},{68,118}})));
  ExactEqualReal exactEqualReal1
    annotation (Placement(transformation(extent={{54,-122},{74,-102}})));
equation
  connect(con.y, add.u2) annotation (Line(points={{-64,-58},{-50,-58}},
                                color={0,0,127}));
  connect(uSetOrg, min1.u2) annotation (Line(points={{-120,-80},{-88,-80},{-88,
          -100},{16,-100},{16,-8},{78,-8},{78,40},{84,40}},
                     color={0,0,127}));
  connect(uSetOrg, max1.u2) annotation (Line(points={{-120,-80},{-88,-80},{-88,
          -100},{16,-100},{16,12},{44,12}},
                     color={0,0,127}));
  connect(have_pri, swi.u2) annotation (Line(points={{-120,80},{-10,80},{-10,
          -60},{36,-60}},                 color={255,0,255}));
  connect(add.y, swi.u1)
    annotation (Line(points={{-26,-52},{36,-52}},            color={0,0,127}));
  connect(swi.y, min2.u2)
    annotation (Line(points={{60,-60},{62,-60},{62,-28},{86,-28}},
                                                        color={0,0,127}));
  connect(min2.y, max2.u2) annotation (Line(points={{110,-22},{122,-22},{122,-6},
          {130,-6}},color={0,0,127}));
  connect(min1.y, max2.u1) annotation (Line(points={{108,46},{122,46},{122,6},{
          130,6}},        color={0,0,127}));
  connect(sam.y, ySetCom) annotation (Line(points={{188,0},{220,0}},
                             color={0,0,127}));
  connect(max2.y, sam.u) annotation (Line(points={{154,0},{164,0}},
                                color={0,0,127}));
  connect(reach_uSetOrg,reach_uSetOrg)
    annotation (Line(points={{220,-72},{220,-72}}, color={255,0,255}));
  connect(exactEqualReal.yEquFla, reach_uSetTar)
    annotation (Line(points={{70,108},{194,108},{194,80},{220,80}},
                                                           color={255,0,255}));
  connect(uSetOrg, exactEqualReal1.u2) annotation (Line(points={{-120,-80},{-88,
          -80},{-88,-118},{52,-118}},                   color={0,0,127}));
  connect(exactEqualReal1.yEquFla,reach_uSetOrg)  annotation (Line(points={{76,-112},
          {194,-112},{194,-72},{220,-72}},   color={255,0,255}));
  connect(max1.y, min2.u1) annotation (Line(points={{68,18},{72,18},{72,-16},{
          86,-16}}, color={0,0,127}));
  connect(uSetTar, max1.u1) annotation (Line(points={{-120,-26},{-72,-26},{-72,
          24},{44,24}}, color={0,0,127}));
  connect(uSetTar, exactEqualReal.u2) annotation (Line(points={{-120,-26},{-72,
          -26},{-72,102},{46,102}}, color={0,0,127}));
  connect(uSetTar, min1.u1) annotation (Line(points={{-120,-26},{6,-26},{6,52},
          {84,52}}, color={0,0,127}));
  connect(exactEqualReal1.u1, uSetCur) annotation (Line(points={{52,-106},{24,
          -106},{24,34},{-120,34}}, color={0,0,127}));
  connect(exactEqualReal.u1, uSetCur) annotation (Line(points={{46,114},{-32,
          114},{-32,34},{-120,34}}, color={0,0,127}));
  connect(uSetCur, swi.u3) annotation (Line(points={{-120,34},{-18,34},{-18,-68},
          {36,-68}}, color={0,0,127}));
  connect(uSetCur, add.u1)
    annotation (Line(points={{-120,34},{-50,34},{-50,-46}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
        extent={{-100,-130},{200,130}},
        grid={2,2})),                                            Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-100,-130},{200,130}},
        grid={2,2})),
    Documentation(info="<html>
<p>This block serves to change the current setpoint <span style=\"font-family: Courier New;\">uSetCur</span>
 between the original setpoint <span style=\"font-family: Courier New;\">uSetOrg</span>
 and the target setpoint <span style=\"font-family: Courier New;\">uSetTar</span> in
 multiple smaller steps. The amount of change in each smaller step is represented
 by the parameter <code>delCha</code>, with positive value indicating setpoint increase while
 negative value indicating setpoint decrease. Each smaller step is taken every
 <span style=\"font-family: Courier New;\">samPer</span> seconds. The resultant
 setpoint will be outputted as the <span style=\"font-family: Courier New;\">ySetCom</span>
 output variable, which represents the new setpoint that a zone or a piece of equipment
 shall have. This in turn changes the value of the current setpoint <code>uSetCur</code> from outside
 this block, completing a full control loop.</p>
<p>This block provides the freedom to account for both <code>uSetOrg &gt;= uSetTar</code> and <code>uSetOrg
 &lt; uSetTar</code> cases. Setpoint increase and decrease is entirely determined by the <code>delCha</code>
 parameter.</p>
<p><br>The <span style=\"font-family: Courier New;\">have_pri</span> boolean input variable
 specifies whether the setpoint change operation will be executed or not. This is useful
 in multiple-zone or multiple-equipment scenarios where there is a need to prioritize
 which zone or equipment will go through the setpoint step change. When the 
<span style=\"font-family: Courier New;\">have_pri</span> input variable is set 
to <span style=\"font-family: Courier New;\">false</span> from a previous 
<span style=\"font-family: Courier New;\">true</span> value, the resultant 
setpoint <code>ySetCom</code> will stay at the current <code>uSetCur</code> value and will not be 
reverted to the previous value before the setpoint step change. Therefore, 
the changes to the current setpoint <span style=\"font-family: Courier New;\">uSetCur</span>
 is unidirectional (either more positive or more negative), and reversing these 
unidirectional changes to the current setpoint <code>uSetCur</code> needs to happen outside 
of this block. </p>
<p>Output variables also include boolean flags that specify whether the 
current setpoint has reached the original setpoint 
<span style=\"font-family: Courier New;\">uSetOrg</span> or the target 
setpoint <span style=\"font-family: Courier New;\">uSetTar</span>. </p>
</html>"));
end SetpointMultipleStepChange;
