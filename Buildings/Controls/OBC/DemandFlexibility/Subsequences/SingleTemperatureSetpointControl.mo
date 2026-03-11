within Buildings.Controls.OBC.DemandFlexibility.Subsequences;
block SingleTemperatureSetpointControl

   parameter Real delChaShe=1
    "Change amount for load shed";

   parameter Real delChaReb=-1
    "Change amount for rebound";

    parameter Real delSheTho=0.5
    "Threshold below which ratcheting is triggerd. This is an absolute value, so it is always positive";

       parameter Boolean setMod=true
       "mode of controller. True for heating, false for cooling.";
        parameter Real samPerPre(unit="s")=300
    "Sample period for precool or preheat";
            parameter Real samPerNom(unit="s")=300
    "Sample period for the nominal condition";
        parameter Real samPerShe(unit="s")=300
    "Sample period for ratchet";
        parameter Real samPerReb(unit="s")=300
    "Sample period for rebound";
  Subsequences.SetpointMultipleStepChange setShe(delCha=delChaShe, samPer=
        samPerShe)
    annotation (Placement(transformation(extent={{-26,-20},{-6,0}})));
  Subsequences.SetpointMultipleStepChange setReb(delCha=delChaReb, samPer=
        samPerReb)
    annotation (Placement(transformation(extent={{-22,-80},{-2,-60}})));
  Subsequences.SetpointSingleStepChange setPre(samPer=samPerPre)
    annotation (Placement(transformation(extent={{-20,94},{0,114}})));
  CDL.Interfaces.BooleanInput
                           have_pri "have priority"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  CDL.Interfaces.IntegerInput uMod
    "setpoint mode; 0 = normal; -1 = precool or preheat; 1 = ratchet; 2 = rebound"
    annotation (Placement(transformation(extent={{-140,24},{-100,64}}),
        iconTransformation(extent={{-140,26},{-100,66}})));
  CDL.Interfaces.BooleanOutput reach_TSetTarShe annotation (Placement(
        transformation(extent={{100,10},{140,50}}), iconTransformation(extent={{100,10},
            {140,50}})));
  CDL.Interfaces.BooleanOutput reach_TSetNom annotation (Placement(
        transformation(extent={{100,-102},{140,-62}}), iconTransformation(
          extent={{100,-86},{140,-46}})));
  CDL.Interfaces.RealOutput TSetCom "setpoint command"
    annotation (Placement(transformation(extent={{100,-42},{140,-2}})));
  CDL.Interfaces.RealInput TSetTarPre "setpoint target for precool or preheat"
    annotation (Placement(transformation(extent={{-140,-8},{-100,32}})));
  CDL.Interfaces.RealInput TSetNom "nominal setpoint"
    annotation (Placement(transformation(extent={{-140,-72},{-100,-32}})));
  CDL.Interfaces.RealInput TSetCur "current setpoint"
    annotation (Placement(transformation(extent={{-140,-110},{-100,-70}})));
  CDL.Interfaces.RealInput TSetTarShe "setpoint target for load shed"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}})));
  CDL.Discrete.Sampler setNom(samplePeriod=samPerNom)
    annotation (Placement(transformation(extent={{-20,26},{0,46}})));
  TemperatureModeSelection singleTemperatureSetpointModeSelection
    annotation (Placement(transformation(extent={{32,36},{52,56}})));
  CDL.Interfaces.RealInput TCur "current zone temperature"
    annotation (Placement(transformation(extent={{-140,-156},{-100,-116}})));
  CDL.Reals.Subtract sub
    annotation (Placement(transformation(extent={{-74,-140},{-54,-120}})));
  CDL.Reals.GreaterThreshold greThr(t=-1*delSheTho)
    annotation (Placement(transformation(extent={{-18,-158},{2,-138}})));
  CDL.Reals.LessThreshold lesThr(t=delSheTho)
    annotation (Placement(transformation(extent={{-18,-126},{2,-106}})));
  CDL.Logical.Switch logSwi
    annotation (Placement(transformation(extent={{50,-138},{70,-118}})));
  CDL.Logical.Sources.Constant con(k=setMod)
    annotation (Placement(transformation(extent={{16,-142},{36,-122}})));
  CDL.Logical.And and2
    annotation (Placement(transformation(extent={{-64,6},{-44,26}})));
  CDL.Interfaces.BooleanOutput reach_TSetTarPre annotation (Placement(
        transformation(extent={{100,60},{140,100}}), iconTransformation(extent={
            {100,54},{140,94}})));
equation
  connect(have_pri, setPre.have_pri) annotation (Line(points={{-120,80},{-30,80},
          {-30,112.2},{-22,112.2}},
                                  color={255,0,255}));
  connect(have_pri, setReb.have_pri) annotation (Line(points={{-120,80},{-36,80},
          {-36,-12},{-38,-12},{-38,-62},{-24,-62}},
                              color={255,0,255}));
  connect(setShe.reach_uSetNom,reach_TSetNom)  annotation (Line(points={{-4,
          -16.6},{-4,-92},{94,-92},{94,-82},{120,-82}},
                                                 color={255,0,255}));
  connect(setShe.reach_uSetTar,reach_TSetTarShe)
    annotation (Line(points={{-4,-2.8},{-4,-2},{96,-2},{96,30},{120,30}},
                                                          color={255,0,255}));
  connect(TSetCur, setReb.uSetCur) annotation (Line(points={{-120,-90},{-34,-90},
          {-34,-76.6},{-24,-76.6}},
                                  color={0,0,127}));
  connect(TSetCur, setShe.uSetCur) annotation (Line(points={{-120,-90},{-28,-90},
          {-28,-16.6}},           color={0,0,127}));
  connect(TSetCur, setPre.uSetCur) annotation (Line(points={{-120,-90},{26,-90},
          {26,4},{64,4},{64,90},{-22,90},{-22,97.6}},
                                      color={0,0,127}));
  connect(TSetNom, setShe.uSetNom) annotation (Line(points={{-120,-52},{-30,-52},
          {-30,-26},{-28,-26},{-28,-18},{-36,-18},{-36,-12},{-28,-12}},
                              color={0,0,127}));
  connect(TSetNom, setReb.uSetNom) annotation (Line(points={{-120,-52},{-32,-52},
          {-32,-72},{-24,-72}},
                              color={0,0,127}));
  connect(TSetNom, setPre.uSetNom) annotation (Line(points={{-120,-52},{22,-52},
          {22,82},{-32,82},{-32,102.2},{-22,102.2}},
                                                color={0,0,127}));
  connect(TSetTarShe, setShe.uSetTar) annotation (Line(points={{-120,-20},{-96,
          -20},{-96,-6.8},{-28,-6.8}},
                                color={0,0,127}));
  connect(TSetTarShe, setReb.uSetTar) annotation (Line(points={{-120,-20},{-94,
          -20},{-94,-66.8},{-24,-66.8}},
                                  color={0,0,127}));
  connect(TSetTarPre, setPre.uSetTar) annotation (Line(points={{-120,12},{-96,
          12},{-96,107.4},{-22,107.4}},
                                 color={0,0,127}));
  connect(TSetNom, setNom.u) annotation (Line(points={{-120,-52},{22,-52},{22,52},
          {-32,52},{-32,36},{-22,36}}, color={0,0,127}));
  connect(uMod, singleTemperatureSetpointModeSelection.uMod) annotation (Line(
        points={{-120,44},{-34,44},{-34,54.8},{30,54.8}}, color={255,127,0}));
  connect(setPre.ySetCom, singleTemperatureSetpointModeSelection.uPre)
    annotation (Line(points={{2,104},{12,104},{12,50.6},{30,50.6}}, color={0,0,
          127}));
  connect(setNom.y, singleTemperatureSetpointModeSelection.uNom) annotation (
      Line(points={{2,36},{20,36},{20,46.8},{30,46.8}}, color={0,0,127}));
  connect(setShe.ySetCom,singleTemperatureSetpointModeSelection.uShe)
    annotation (Line(points={{-4,-10.2},{4,-10.2},{4,28},{16,28},{16,42.8},{30,
          42.8}}, color={0,0,127}));
  connect(setReb.ySetCom, singleTemperatureSetpointModeSelection.uReb)
    annotation (Line(points={{0,-70.2},{10,-70.2},{10,-66},{30,-66},{30,38.2}},
        color={0,0,127}));
  connect(singleTemperatureSetpointModeSelection.y,TSetCom)  annotation (Line(
        points={{54,46},{66,46},{66,-4},{94,-4},{94,-22},{120,-22}},
                                                 color={0,0,127}));
  connect(TCur, sub.u1) annotation (Line(points={{-120,-136},{-86,-136},{-86,
          -124},{-76,-124}}, color={0,0,127}));
  connect(TSetCur, sub.u2) annotation (Line(points={{-120,-90},{-44,-90},{-44,
          -146},{-76,-146},{-76,-136}}, color={0,0,127}));
  connect(sub.y, lesThr.u) annotation (Line(points={{-52,-130},{-28,-130},{-28,
          -116},{-20,-116}}, color={0,0,127}));
  connect(sub.y, greThr.u) annotation (Line(points={{-52,-130},{-30,-130},{-30,
          -148},{-20,-148}}, color={0,0,127}));
  connect(con.y, logSwi.u2) annotation (Line(points={{38,-132},{44,-132},{44,
          -128},{48,-128}}, color={255,0,255}));
  connect(lesThr.y, logSwi.u1) annotation (Line(points={{4,-116},{40,-116},{40,
          -112},{48,-112},{48,-120}}, color={255,0,255}));
  connect(greThr.y, logSwi.u3) annotation (Line(points={{4,-148},{48,-148},{48,
          -136}}, color={255,0,255}));
  connect(have_pri, and2.u1) annotation (Line(points={{-120,80},{-36,80},{-36,0},
          {-74,0},{-74,16},{-66,16}}, color={255,0,255}));
  connect(logSwi.y, and2.u2) annotation (Line(points={{72,-128},{72,-6},{-66,-6},
          {-66,8}}, color={255,0,255}));
  connect(and2.y, setShe.have_pri)
    annotation (Line(points={{-42,16},{-28,16},{-28,-2}}, color={255,0,255}));
  connect(setPre.reach_uSetTar, reach_TSetTarPre) annotation (Line(points={{2,111.2},
          {2,112},{94,112},{94,80},{120,80}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SingleTemperatureSetpointControl;
