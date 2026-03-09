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
  CDL.Reals.Greater gre1
    annotation (Placement(transformation(extent={{24,140},{44,160}})));
  CDL.Reals.Less les1
    annotation (Placement(transformation(extent={{28,102},{48,122}})));
  CDL.Logical.Nor nor1
    annotation (Placement(transformation(extent={{58,126},{78,146}})));
  CDL.Interfaces.BooleanOutput reach_uSetTar annotation (Placement(
        transformation(extent={{100,60},{140,100}}),iconTransformation(extent={{
            100,52},{140,92}})));
  CDL.Reals.Greater gre
    annotation (Placement(transformation(extent={{20,-138},{40,-118}})));
  CDL.Reals.Less les
    annotation (Placement(transformation(extent={{24,-176},{44,-156}})));
  CDL.Logical.Nor nor
    annotation (Placement(transformation(extent={{54,-152},{74,-132}})));
  CDL.Interfaces.BooleanOutput reach_uSetNom annotation (Placement(
        transformation(extent={{100,-92},{140,-52}}), iconTransformation(extent={{100,-92},
            {140,-52}})));
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
  connect(uSetCur,gre1. u1) annotation (Line(points={{-120,-64},{-24,-64},{-24,
          -56},{-4,-56},{-4,112},{8,112},{8,150},{22,150}},
                                        color={0,0,127}));
  connect(uSetCur,les1. u1) annotation (Line(points={{-120,-64},{-24,-64},{-24,
          -56},{-4,-56},{-4,112},{26,112}},
                                        color={0,0,127}));
  connect(uSetTar,gre1. u2) annotation (Line(points={{-120,34},{-80,34},{-80,
          104},{14,104},{14,142},{22,142}},
                                       color={0,0,127}));
  connect(uSetTar,les1. u2) annotation (Line(points={{-120,34},{-80,34},{-80,
          104},{26,104}},              color={0,0,127}));
  connect(gre1.y,nor1. u1) annotation (Line(points={{46,150},{54,150},{54,166},
          {12,166},{12,134},{48,134},{48,136},{56,136}},                  color
        ={255,0,255}));
  connect(les1.y,nor1. u2) annotation (Line(points={{50,112},{58,112},{58,120},
          {56,120},{56,128}},color={255,0,255}));
  connect(nor1.y,reach_uSetTar)  annotation (Line(points={{80,136},{120,136},{
          120,80}},      color={255,0,255}));
  connect(uSetCur,gre. u1) annotation (Line(points={{-120,-64},{-24,-64},{-24,
          -128},{18,-128}},            color={0,0,127}));
  connect(uSetNom,gre. u2) annotation (Line(points={{-120,-18},{-82,-18},{-82,
          -54},{-30,-54},{-30,-136},{18,-136}},              color={0,0,127}));
  connect(uSetCur,les. u1) annotation (Line(points={{-120,-64},{-24,-64},{-24,
          -128},{10,-128},{10,-166},{22,-166}},
                                         color={0,0,127}));
  connect(uSetNom,les. u2) annotation (Line(points={{-120,-18},{-82,-18},{-82,
          -54},{-30,-54},{-30,-136},{8,-136},{8,-174},{22,-174}},
                                                               color={0,0,127}));
  connect(gre.y,nor. u1) annotation (Line(points={{42,-128},{42,-112},{52,-112},
          {52,-142}},              color={255,0,255}));
  connect(les.y,nor. u2) annotation (Line(points={{46,-166},{54,-166},{54,-158},
          {52,-158},{52,-150}},color={255,0,255}));
  connect(nor.y,reach_uSetNom)  annotation (Line(points={{76,-142},{94,-142},{
          94,-72},{120,-72}},
                      color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SetpointSingleStepChange;
