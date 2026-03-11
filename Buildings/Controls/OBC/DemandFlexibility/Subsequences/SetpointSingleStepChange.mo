within Buildings.Controls.OBC.DemandFlexibility.Subsequences;
block SetpointSingleStepChange


     parameter Boolean setChaMod=true
    "setpoint change mode; true to go to the target setpoint value, false to go to the nominal setpoint value";

    parameter Real samPer(unit="s")=300
    "Sample period";
  CDL.Discrete.Sampler                        sam(samplePeriod=samPer)
    annotation (Placement(transformation(extent={{68,36},{88,56}})));
  CDL.Reals.Min                        min1
    annotation (Placement(transformation(extent={{-68,36},{-48,56}})));
  CDL.Reals.Max                        max1
    annotation (Placement(transformation(extent={{-60,-6},{-40,14}})));
  CDL.Logical.Sources.Constant
                             con(k=setChaMod)
    annotation (Placement(transformation(extent={{-76,-50},{-56,-30}})));
  CDL.Reals.Switch swi
    annotation (Placement(transformation(extent={{-12,-86},{8,-66}})));
  CDL.Reals.Min                        min2
    annotation (Placement(transformation(extent={{8,-34},{28,-14}})));
  CDL.Reals.Max                        max2
    annotation (Placement(transformation(extent={{58,-40},{78,-20}})));
  CDL.Interfaces.RealInput uSetTar "setpoint target"
    annotation (Placement(transformation(extent={{-140,14},{-100,54}})));
  CDL.Interfaces.RealInput uSetNom "nominal setpoint"
    annotation (Placement(transformation(extent={{-140,-38},{-100,2}})));
  CDL.Interfaces.RealOutput ySetCom "setpoint command"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  CDL.Interfaces.BooleanInput
                           have_pri "have priority"
    annotation (Placement(transformation(extent={{-140,62},{-100,102}}),
        iconTransformation(extent={{-140,62},{-100,102}})));
  CDL.Interfaces.RealInput uSetCur "current setpoint"
    annotation (Placement(transformation(extent={{-140,-84},{-100,-44}})));
  CDL.Reals.Switch swi1
    annotation (Placement(transformation(extent={{-42,-48},{-22,-28}})));
  CDL.Interfaces.BooleanOutput reach_uSetTar annotation (Placement(
        transformation(extent={{100,60},{140,100}}),iconTransformation(extent={{
            100,52},{140,92}})));
  CDL.Interfaces.BooleanOutput reach_uSetNom annotation (Placement(
        transformation(extent={{100,-92},{140,-52}}), iconTransformation(extent={{100,-92},
            {140,-52}})));
  ExactEqualReal exactEqualReal
    annotation (Placement(transformation(extent={{16,88},{36,108}})));
  ExactEqualReal exactEqualReal1
    annotation (Placement(transformation(extent={{32,-122},{52,-102}})));
equation
  connect(uSetTar,min1. u1) annotation (Line(points={{-120,34},{-80,34},{-80,52},
          {-70,52}}, color={0,0,127}));
  connect(uSetNom,min1. u2) annotation (Line(points={{-120,-18},{-78,-18},{-78,40},
          {-70,40}}, color={0,0,127}));
  connect(uSetTar,max1. u1) annotation (Line(points={{-120,34},{-80,34},{-80,10},
          {-62,10}},color={0,0,127}));
  connect(uSetNom,max1. u2) annotation (Line(points={{-120,-18},{-78,-18},{-78,-2},
          {-62,-2}}, color={0,0,127}));
  connect(have_pri,swi. u2) annotation (Line(points={{-120,82},{-88,82},{-88,
          -62},{-22,-62},{-22,-76},{-14,-76}},
                                          color={255,0,255}));
  connect(uSetCur,swi. u3) annotation (Line(points={{-120,-64},{-24,-64},{-24,
          -84},{-14,-84}},
                      color={0,0,127}));
  connect(max1.y,min2. u1) annotation (Line(points={{-38,4},{-2,4},{-2,-18},{6,-18}},
        color={0,0,127}));
  connect(swi.y,min2. u2)
    annotation (Line(points={{10,-76},{18,-76},{18,-38},{6,-38},{6,-30}},
                                                        color={0,0,127}));
  connect(min2.y,max2. u2) annotation (Line(points={{30,-24},{48,-24},{48,-36},{
          56,-36}}, color={0,0,127}));
  connect(min1.y,max2. u1) annotation (Line(points={{-46,46},{40,46},{40,-14},{56,
          -14},{56,-24}}, color={0,0,127}));
  connect(sam.y,ySetCom)  annotation (Line(points={{90,46},{98,46},{98,24},{96,24},
          {96,0},{120,0}},   color={0,0,127}));
  connect(max2.y,sam. u) annotation (Line(points={{80,-30},{88,-30},{88,32},{56,
          32},{56,46},{66,46}}, color={0,0,127}));
  connect(con.y, swi1.u2) annotation (Line(points={{-54,-40},{-54,-38},{-44,-38}},
        color={255,0,255}));
  connect(uSetTar, swi1.u1) annotation (Line(points={{-120,34},{-80,34},{-80,
          -22},{-44,-22},{-44,-30}}, color={0,0,127}));
  connect(uSetNom, swi1.u3) annotation (Line(points={{-120,-18},{-82,-18},{-82,
          -54},{-44,-54},{-44,-46}}, color={0,0,127}));
  connect(swi1.y, swi.u1) annotation (Line(points={{-20,-38},{-12,-38},{-12,-60},
          {-14,-60},{-14,-68}}, color={0,0,127}));
  connect(uSetCur, exactEqualReal.u1) annotation (Line(points={{-120,-64},{-24,
          -64},{-24,-56},{-10,-56},{-10,104},{14,104}}, color={0,0,127}));
  connect(uSetTar, exactEqualReal.u2) annotation (Line(points={{-120,34},{-80,
          34},{-80,60},{6,60},{6,92},{14,92}}, color={0,0,127}));
  connect(exactEqualReal.yEquFla, reach_uSetTar) annotation (Line(points={{38,
          98},{94,98},{94,80},{120,80}}, color={255,0,255}));
  connect(uSetCur, exactEqualReal1.u1) annotation (Line(points={{-120,-64},{-24,
          -64},{-24,-106},{30,-106}}, color={0,0,127}));
  connect(uSetNom, exactEqualReal1.u2) annotation (Line(points={{-120,-18},{-82,
          -18},{-82,-54},{-14,-54},{-14,-58},{22,-58},{22,-118},{30,-118}},
        color={0,0,127}));
  connect(exactEqualReal1.yEquFla, reach_uSetNom) annotation (Line(points={{54,
          -112},{94,-112},{94,-72},{120,-72}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SetpointSingleStepChange;
