within Buildings.Controls.OBC.DemandFlexibility.Subsequences;
block SetpointSingleStepChange


     parameter Boolean setChaMod=true
    "setpoint change mode; true to go to the target setpoint value, false to go to the nominal setpoint value";

    parameter Real samPer(unit="s")=300
    "Sample period";
  CDL.Discrete.Sampler                        sam(samplePeriod=samPer)
    annotation (Placement(transformation(extent={{166,-10},{186,10}})));
  CDL.Reals.Min                        min1
    annotation (Placement(transformation(extent={{50,50},{70,70}})));
  CDL.Reals.Max                        max1
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  CDL.Logical.Sources.Constant
                             con(k=setChaMod)
    annotation (Placement(transformation(extent={{-92,-144},{-72,-124}})));
  CDL.Reals.Switch swi
    annotation (Placement(transformation(extent={{48,-84},{68,-64}})));
  CDL.Reals.Min                        min2
    annotation (Placement(transformation(extent={{92,-16},{112,4}})));
  CDL.Reals.Max                        max2
    annotation (Placement(transformation(extent={{132,-10},{152,10}})));
  CDL.Interfaces.RealInput uSetTar "setpoint target"
    annotation (Placement(transformation(extent={{-140,-38},{-100,2}})));
  CDL.Interfaces.RealInput uSetNom "nominal setpoint"
    annotation (Placement(transformation(extent={{-140,-88},{-100,-48}})));
  CDL.Interfaces.RealOutput ySetCom "setpoint command"
    annotation (Placement(transformation(extent={{200,-20},{240,20}})));
  CDL.Interfaces.BooleanInput
                           have_pri "have priority"
    annotation (Placement(transformation(extent={{-140,62},{-100,102}}),
        iconTransformation(extent={{-140,62},{-100,102}})));
  CDL.Interfaces.RealInput uSetCur "current setpoint"
    annotation (Placement(transformation(extent={{-140,12},{-100,52}})));
  CDL.Reals.Switch swi1
    annotation (Placement(transformation(extent={{10,-46},{30,-26}})));
  CDL.Interfaces.BooleanOutput reach_uSetTar annotation (Placement(
        transformation(extent={{200,60},{240,100}}),iconTransformation(extent={{200,52},
            {240,92}})));
  CDL.Interfaces.BooleanOutput reach_uSetNom annotation (Placement(
        transformation(extent={{200,-94},{240,-54}}), iconTransformation(extent={{200,-94},
            {240,-54}})));
  ExactEqualReal exactEqualReal
    annotation (Placement(transformation(extent={{18,94},{38,114}})));
  ExactEqualReal exactEqualReal1
    annotation (Placement(transformation(extent={{144,-112},{164,-92}})));
equation
  connect(uSetNom,max1. u2) annotation (Line(points={{-120,-68},{-78,-68},{-78,
          -44},{-26,-44},{-26,-6},{48,-6}},
                     color={0,0,127}));
  connect(have_pri,swi. u2) annotation (Line(points={{-120,82},{-58,82},{-58,
          -74},{46,-74}},                 color={255,0,255}));
  connect(uSetCur,swi. u3) annotation (Line(points={{-120,32},{-6,32},{-6,-82},
          {46,-82}},  color={0,0,127}));
  connect(max1.y,min2. u1) annotation (Line(points={{72,0},{90,0}},
        color={0,0,127}));
  connect(swi.y,min2. u2)
    annotation (Line(points={{70,-74},{76,-74},{76,-12},{90,-12}},
                                                        color={0,0,127}));
  connect(min2.y,max2. u2) annotation (Line(points={{114,-6},{130,-6}},
                    color={0,0,127}));
  connect(min1.y,max2. u1) annotation (Line(points={{72,60},{118,60},{118,6},{
          130,6}},        color={0,0,127}));
  connect(sam.y,ySetCom)  annotation (Line(points={{188,0},{220,0}},
                             color={0,0,127}));
  connect(max2.y,sam. u) annotation (Line(points={{154,0},{164,0}},
                                color={0,0,127}));
  connect(con.y, swi1.u2) annotation (Line(points={{-70,-134},{2,-134},{2,-36},
          {8,-36}},
        color={255,0,255}));
  connect(uSetTar, swi1.u1) annotation (Line(points={{-120,-18},{-72,-18},{-72,
          -28},{8,-28}},             color={0,0,127}));
  connect(uSetNom, swi1.u3) annotation (Line(points={{-120,-68},{-78,-68},{-78,
          -44},{8,-44}},             color={0,0,127}));
  connect(uSetCur, exactEqualReal.u1) annotation (Line(points={{-120,32},{-50,
          32},{-50,110},{16,110}},                      color={0,0,127}));
  connect(uSetTar, exactEqualReal.u2) annotation (Line(points={{-120,-18},{-72,
          -18},{-72,98},{16,98}},              color={0,0,127}));
  connect(exactEqualReal.yEquFla, reach_uSetTar) annotation (Line(points={{40,104},
          {194,104},{194,80},{220,80}},  color={255,0,255}));
  connect(uSetCur, exactEqualReal1.u1) annotation (Line(points={{-120,32},{-88,
          32},{-88,-96},{142,-96}},   color={0,0,127}));
  connect(uSetNom, exactEqualReal1.u2) annotation (Line(points={{-120,-68},{-78,
          -68},{-78,-108},{142,-108}},
        color={0,0,127}));
  connect(exactEqualReal1.yEquFla, reach_uSetNom) annotation (Line(points={{166,
          -102},{194,-102},{194,-74},{220,-74}},
                                               color={255,0,255}));
  connect(swi1.y, swi.u1) annotation (Line(points={{32,-36},{38,-36},{38,-66},{
          46,-66}}, color={0,0,127}));
  connect(min1.u2, uSetNom) annotation (Line(points={{48,54},{-26,54},{-26,-44},
          {-78,-44},{-78,-68},{-120,-68}}, color={0,0,127}));
  connect(uSetTar, max1.u1) annotation (Line(points={{-120,-18},{-42,-18},{-42,
          6},{48,6}}, color={0,0,127}));
  connect(uSetTar, min1.u1) annotation (Line(points={{-120,-18},{-42,-18},{-42,
          66},{48,66}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
        extent={{-100,-150},{200,120}},
        grid={2,2})),                                            Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-100,-150},{200,120}},
        grid={2,2})));
end SetpointSingleStepChange;
