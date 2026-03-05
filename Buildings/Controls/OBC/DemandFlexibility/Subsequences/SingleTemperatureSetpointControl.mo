within Buildings.Controls.OBC.DemandFlexibility.Subsequences;
block SingleTemperatureSetpointControl





   parameter Real delChaRat=1
    "Change amount for ratchet";

   parameter Real delChaReb=-1
    "Change amount for rebound";
        parameter Real samPerPre(unit="s")=300
    "Sample period for precool or preheat";
            parameter Real samPerNom(unit="s")=300
    "Sample period for the nominal condition";
        parameter Real samPerRat(unit="s")=300
    "Sample period for ratchet";
        parameter Real samPerReb(unit="s")=300
    "Sample period for rebound";
  SetpointMultipleStepChange setRat(delCha=delChaRat, samPer=samPerRat)
    annotation (Placement(transformation(extent={{-26,-20},{-6,0}})));
  SetpointMultipleStepChange setReb(delCha=delChaReb, samPer=samPerReb)
    annotation (Placement(transformation(extent={{-22,-80},{-2,-60}})));
  SetpointSingleStepChange setPre(samPer=samPerPre)
    annotation (Placement(transformation(extent={{-20,94},{0,114}})));
  CDL.Interfaces.BooleanInput
                           have_pri "have priority"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  CDL.Interfaces.IntegerInput uMod
    "setpoint mode; 0 = normal; -1 = precool or preheat; 1 = ratchet; 2 = rebound"
    annotation (Placement(transformation(extent={{-140,24},{-100,64}}),
        iconTransformation(extent={{-140,26},{-100,66}})));
  CDL.Interfaces.BooleanOutput reach_uSetTarShe annotation (Placement(
        transformation(extent={{100,42},{140,82}}), iconTransformation(extent={{
            100,52},{140,92}})));
  CDL.Interfaces.BooleanOutput reach_uSetNom annotation (Placement(
        transformation(extent={{100,-102},{140,-62}}), iconTransformation(
          extent={{100,-86},{140,-46}})));
  CDL.Interfaces.RealOutput ySetCom "setpoint command"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  CDL.Interfaces.RealInput uSetTarPre "setpoint target for precool or preheat"
    annotation (Placement(transformation(extent={{-140,-8},{-100,32}})));
  CDL.Interfaces.RealInput uSetNom "nominal setpoint"
    annotation (Placement(transformation(extent={{-140,-72},{-100,-32}})));
  CDL.Interfaces.RealInput uSetCur "current setpoint"
    annotation (Placement(transformation(extent={{-140,-110},{-100,-70}})));
  CDL.Interfaces.RealInput uSetTarShe "setpoint target for load shed"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}})));
  CDL.Discrete.Sampler                        sam(samplePeriod=samPerNom)
    annotation (Placement(transformation(extent={{-20,26},{0,46}})));
  SingleTemperatureSetpointModeSelection singleTemperatureSetpointModeSelection
    annotation (Placement(transformation(extent={{32,36},{52,56}})));
equation
  connect(have_pri, setPre.have_pri) annotation (Line(points={{-120,80},{-30,80},
          {-30,112.2},{-22,112.2}},
                                  color={255,0,255}));
  connect(have_pri, setRat.have_pri) annotation (Line(points={{-120,80},{-36,80},
          {-36,-2},{-28,-2}},
                            color={255,0,255}));
  connect(have_pri, setReb.have_pri) annotation (Line(points={{-120,80},{-36,80},
          {-36,-12},{-38,-12},{-38,-62},{-24,-62}},
                              color={255,0,255}));
  connect(setRat.reach_uSetNom, reach_uSetNom) annotation (Line(points={{-4,
          -16.6},{-4,-92},{94,-92},{94,-82},{120,-82}},
                                                 color={255,0,255}));
  connect(setRat.reach_uSetTar, reach_uSetTarShe)
    annotation (Line(points={{-4,-2.8},{-4,22},{96,22},{96,62},{120,62}},
                                                          color={255,0,255}));
  connect(uSetCur, setReb.uSetCur) annotation (Line(points={{-120,-90},{-34,-90},
          {-34,-76.6},{-24,-76.6}},
                                  color={0,0,127}));
  connect(uSetCur, setRat.uSetCur) annotation (Line(points={{-120,-90},{-28,-90},
          {-28,-16.6}},           color={0,0,127}));
  connect(uSetCur, setPre.uSetCur) annotation (Line(points={{-120,-90},{26,-90},
          {26,4},{64,4},{64,90},{-22,90},{-22,97.6}},
                                      color={0,0,127}));
  connect(uSetNom, setRat.uSetNom) annotation (Line(points={{-120,-52},{-30,-52},
          {-30,-26},{-28,-26},{-28,-18},{-36,-18},{-36,-12},{-28,-12}},
                              color={0,0,127}));
  connect(uSetNom, setReb.uSetNom) annotation (Line(points={{-120,-52},{-32,-52},
          {-32,-72},{-24,-72}},
                              color={0,0,127}));
  connect(uSetNom, setPre.uSetNom) annotation (Line(points={{-120,-52},{22,-52},
          {22,82},{-32,82},{-32,102.2},{-22,102.2}},
                                                color={0,0,127}));
  connect(uSetTarShe, setRat.uSetTar) annotation (Line(points={{-120,-20},{-96,
          -20},{-96,-6.8},{-28,-6.8}},
                                color={0,0,127}));
  connect(uSetTarShe, setReb.uSetTar) annotation (Line(points={{-120,-20},{-94,
          -20},{-94,-66.8},{-24,-66.8}},
                                  color={0,0,127}));
  connect(uSetTarPre, setPre.uSetTar) annotation (Line(points={{-120,12},{-96,
          12},{-96,107.4},{-22,107.4}},
                                 color={0,0,127}));
  connect(uSetNom, sam.u) annotation (Line(points={{-120,-52},{22,-52},{22,52},
          {-32,52},{-32,36},{-22,36}}, color={0,0,127}));
  connect(uMod, singleTemperatureSetpointModeSelection.uMod) annotation (Line(
        points={{-120,44},{-34,44},{-34,54.8},{30,54.8}}, color={255,127,0}));
  connect(setPre.ySetCom, singleTemperatureSetpointModeSelection.uPre)
    annotation (Line(points={{2,104},{12,104},{12,50.6},{30,50.6}}, color={0,0,
          127}));
  connect(sam.y, singleTemperatureSetpointModeSelection.uNom) annotation (Line(
        points={{2,36},{20,36},{20,46.8},{30,46.8}}, color={0,0,127}));
  connect(setRat.ySetCom, singleTemperatureSetpointModeSelection.uRat)
    annotation (Line(points={{-4,-10.2},{4,-10.2},{4,28},{16,28},{16,42.8},{30,
          42.8}}, color={0,0,127}));
  connect(setReb.ySetCom, singleTemperatureSetpointModeSelection.uReb)
    annotation (Line(points={{0,-70.2},{10,-70.2},{10,-66},{30,-66},{30,38.2}},
        color={0,0,127}));
  connect(singleTemperatureSetpointModeSelection.y, ySetCom) annotation (Line(
        points={{54,46},{94,46},{94,0},{120,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SingleTemperatureSetpointControl;
