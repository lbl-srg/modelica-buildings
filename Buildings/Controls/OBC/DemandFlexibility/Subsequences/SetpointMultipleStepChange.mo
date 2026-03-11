within Buildings.Controls.OBC.DemandFlexibility.Subsequences;
block SetpointMultipleStepChange

   parameter Real delCha=1
    "Change amount";

    parameter Real samPer(unit="s")=300
    "Sample period";
  CDL.Discrete.Sampler                        sam(samplePeriod=samPer)
    annotation (Placement(transformation(extent={{68,34},{88,54}})));
  CDL.Interfaces.RealInput uSetTar "setpoint target"
    annotation (Placement(transformation(extent={{-140,12},{-100,52}})));
  CDL.Interfaces.RealInput uSetNom "nominal setpoint"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}})));
  CDL.Interfaces.RealOutput ySetCom "setpoint command"
    annotation (Placement(transformation(extent={{100,-22},{140,18}})));
  CDL.Interfaces.BooleanInput
                           have_pri "have priority"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  CDL.Interfaces.RealInput uSetCur "current setpoint"
    annotation (Placement(transformation(extent={{-140,-86},{-100,-46}})));
  CDL.Reals.Add                        add
    annotation (Placement(transformation(extent={{-60,-48},{-40,-28}})));
  CDL.Reals.Min                        min1
    annotation (Placement(transformation(extent={{-68,34},{-48,54}})));
  CDL.Reals.Max                        max1
    annotation (Placement(transformation(extent={{-60,-8},{-40,12}})));
  CDL.Reals.Sources.Constant con(k=delCha)
    annotation (Placement(transformation(extent={{-84,-96},{-64,-76}})));
  CDL.Reals.Switch swi
    annotation (Placement(transformation(extent={{-24,-74},{-4,-54}})));
  CDL.Reals.Min                        min2
    annotation (Placement(transformation(extent={{8,-36},{28,-16}})));
  CDL.Reals.Max                        max2
    annotation (Placement(transformation(extent={{58,-42},{78,-22}})));
  CDL.Interfaces.BooleanOutput reach_uSetTar annotation (Placement(
        transformation(extent={{100,58},{140,98}}), iconTransformation(extent={{
            100,52},{140,92}})));
  CDL.Interfaces.BooleanOutput reach_uSetNom annotation (Placement(
        transformation(extent={{100,-94},{140,-54}}), iconTransformation(extent
          ={{100,-86},{140,-46}})));
  ExactEqualReal exactEqualReal
    annotation (Placement(transformation(extent={{-4,110},{16,130}})));
  ExactEqualReal exactEqualReal1
    annotation (Placement(transformation(extent={{42,-96},{62,-76}})));
equation
  connect(uSetCur, add.u1) annotation (Line(points={{-120,-66},{-70,-66},{-70,-32},
          {-62,-32}}, color={0,0,127}));
  connect(con.y, add.u2) annotation (Line(points={{-62,-86},{-54,-86},{-54,-52},
          {-62,-52},{-62,-44}}, color={0,0,127}));
  connect(uSetTar, min1.u1) annotation (Line(points={{-120,32},{-80,32},{-80,50},
          {-70,50}}, color={0,0,127}));
  connect(uSetNom, min1.u2) annotation (Line(points={{-120,-20},{-78,-20},{-78,38},
          {-70,38}}, color={0,0,127}));
  connect(uSetTar, max1.u1) annotation (Line(points={{-120,32},{-80,32},{-80,8},
          {-62,8}}, color={0,0,127}));
  connect(uSetNom, max1.u2) annotation (Line(points={{-120,-20},{-78,-20},{-78,-4},
          {-62,-4}}, color={0,0,127}));
  connect(have_pri, swi.u2) annotation (Line(points={{-120,80},{-28,80},{-28,-48},
          {-34,-48},{-34,-64},{-26,-64}}, color={255,0,255}));
  connect(add.y, swi.u1)
    annotation (Line(points={{-38,-38},{-26,-38},{-26,-56}}, color={0,0,127}));
  connect(uSetCur, swi.u3) annotation (Line(points={{-120,-66},{-36,-66},{-36,-72},
          {-26,-72}}, color={0,0,127}));
  connect(max1.y, min2.u1) annotation (Line(points={{-38,2},{-2,2},{-2,-20},{6,-20}},
        color={0,0,127}));
  connect(swi.y, min2.u2)
    annotation (Line(points={{-2,-64},{6,-64},{6,-32}}, color={0,0,127}));
  connect(min2.y, max2.u2) annotation (Line(points={{30,-26},{48,-26},{48,-38},{
          56,-38}}, color={0,0,127}));
  connect(min1.y, max2.u1) annotation (Line(points={{-46,44},{40,44},{40,-16},{56,
          -16},{56,-26}}, color={0,0,127}));
  connect(sam.y, ySetCom) annotation (Line(points={{90,44},{98,44},{98,22},{96,22},
          {96,-2},{120,-2}}, color={0,0,127}));
  connect(max2.y, sam.u) annotation (Line(points={{80,-32},{88,-32},{88,30},{56,
          30},{56,44},{66,44}}, color={0,0,127}));
  connect(reach_uSetNom, reach_uSetNom)
    annotation (Line(points={{120,-74},{120,-74}}, color={255,0,255}));
  connect(uSetCur, exactEqualReal.u1) annotation (Line(points={{-120,-66},{-70,
          -66},{-70,20},{-24,20},{-24,126},{-6,126}}, color={0,0,127}));
  connect(uSetTar, exactEqualReal.u2) annotation (Line(points={{-120,32},{-80,
          32},{-80,114},{-6,114}}, color={0,0,127}));
  connect(exactEqualReal.yEquFla, reach_uSetTar)
    annotation (Line(points={{18,120},{120,120},{120,78}}, color={255,0,255}));
  connect(uSetCur, exactEqualReal1.u1) annotation (Line(points={{-120,-66},{-36,
          -66},{-36,-80},{40,-80}}, color={0,0,127}));
  connect(uSetNom, exactEqualReal1.u2) annotation (Line(points={{-120,-20},{-88,
          -20},{-88,-100},{30,-100},{30,-92},{40,-92}}, color={0,0,127}));
  connect(exactEqualReal1.yEquFla, reach_uSetNom) annotation (Line(points={{64,
          -86},{94,-86},{94,-74},{120,-74}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SetpointMultipleStepChange;
