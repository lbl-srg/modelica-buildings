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
    annotation (Placement(transformation(extent={{174,-34},{194,-14}})));
  Subsequences.SetpointMultipleStepChange setReb(delCha=delChaReb, samPer=
        samPerReb)
    annotation (Placement(transformation(extent={{182,-114},{202,-94}})));
  Subsequences.SetpointSingleStepChange setPre(samPer=samPerPre)
    annotation (Placement(transformation(extent={{170,80},{190,100}})));
  CDL.Interfaces.BooleanInput
                           have_pri "have priority"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  CDL.Interfaces.IntegerInput uMod
    "setpoint mode; 0 = normal; -1 = precool or preheat; 1 = ratchet; 2 = rebound"
    annotation (Placement(transformation(extent={{-140,24},{-100,64}}),
        iconTransformation(extent={{-140,26},{-100,66}})));
  CDL.Interfaces.BooleanOutput reach_TSetTarShe annotation (Placement(
        transformation(extent={{250,-20},{290,20}}),iconTransformation(extent={{250,-20},
            {290,20}})));
  CDL.Interfaces.BooleanOutput reach_TSetNom annotation (Placement(
        transformation(extent={{250,-170},{290,-130}}),iconTransformation(
          extent={{100,-158},{140,-118}})));
  CDL.Interfaces.RealOutput TSetCom "setpoint command"
    annotation (Placement(transformation(extent={{250,-90},{290,-50}}),
        iconTransformation(extent={{250,-90},{290,-50}})));
  CDL.Interfaces.RealInput TSetTarPre "setpoint target for precool or preheat"
    annotation (Placement(transformation(extent={{-140,-106},{-100,-66}}),
        iconTransformation(extent={{-140,-106},{-100,-66}})));
  CDL.Interfaces.RealInput TSetNom "nominal setpoint"
    annotation (Placement(transformation(extent={{-140,-204},{-100,-164}})));
  CDL.Interfaces.RealInput TSetCur "current setpoint"
    annotation (Placement(transformation(extent={{-140,-54},{-100,-14}})));
  CDL.Interfaces.RealInput TSetTarShe "setpoint target for load shed"
    annotation (Placement(transformation(extent={{-140,-156},{-100,-116}}),
        iconTransformation(extent={{-140,-156},{-100,-116}})));
  CDL.Discrete.Sampler setNom(samplePeriod=samPerNom)
    annotation (Placement(transformation(extent={{178,28},{198,48}})));
  TemperatureModeSelection singleTemperatureSetpointModeSelection
    annotation (Placement(transformation(extent={{216,-78},{236,-58}})));
  CDL.Interfaces.RealInput TCur "current zone temperature"
    annotation (Placement(transformation(extent={{-140,-12},{-100,28}})));
  CDL.Reals.Subtract sub
    annotation (Placement(transformation(extent={{-70,-8},{-50,12}})));
  CDL.Reals.GreaterThreshold greThr(t=-1*delSheTho)
    annotation (Placement(transformation(extent={{-16,-16},{4,4}})));
  CDL.Reals.LessThreshold lesThr(t=delSheTho)
    annotation (Placement(transformation(extent={{-16,16},{4,36}})));
  CDL.Logical.Switch logSwi
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  CDL.Logical.Sources.Constant con(k=setMod)
    annotation (Placement(transformation(extent={{18,0},{38,20}})));
  CDL.Logical.And and2
    annotation (Placement(transformation(extent={{122,8},{142,28}})));
  CDL.Interfaces.BooleanOutput reach_TSetTarPre annotation (Placement(
        transformation(extent={{250,44},{290,84}}),  iconTransformation(extent={{250,44},
            {290,84}})));
equation
  connect(have_pri, setPre.have_pri) annotation (Line(points={{-120,80},{28,80},
          {28,97.1852},{168.667,97.1852}},
                                  color={255,0,255}));
  connect(have_pri, setReb.have_pri) annotation (Line(points={{-120,80},{-36,80},
          {-36,-98},{78,-98},{78,-97.8462},{180.667,-97.8462}},
                              color={255,0,255}));
  connect(setShe.reach_uSetNom,reach_TSetNom)  annotation (Line(points={{195.333,
          -29.2308},{200,-29.2308},{200,-76},{210,-76},{210,-150},{270,-150}},
                                                 color={255,0,255}));
  connect(setShe.reach_uSetTar,reach_TSetTarShe)
    annotation (Line(points={{195.333,-18.1538},{244,-18.1538},{244,0},{270,0}},
                                                          color={255,0,255}));
  connect(TSetCur, setReb.uSetCur) annotation (Line(points={{-120,-34},{38,-34},
          {38,-101.385},{180.667,-101.385}},
                                  color={0,0,127}));
  connect(TSetCur, setShe.uSetCur) annotation (Line(points={{-120,-34},{140,-34},
          {140,-21.3846},{172.667,-21.3846}},
                                  color={0,0,127}));
  connect(TSetNom, setShe.uSetNom) annotation (Line(points={{-120,-184},{-88,
          -184},{-88,-36},{-90,-36},{-90,46},{26,46},{26,-4},{20,-4},{20,-24},{
          16,-24},{16,-110},{170,-110},{170,-30.1538},{172.667,-30.1538}},
                              color={0,0,127}));
  connect(TSetNom, setReb.uSetNom) annotation (Line(points={{-120,-184},{-88,
          -184},{-88,-36},{-90,-36},{-90,46},{26,46},{26,-4},{20,-4},{20,-24},{
          16,-24},{16,-110.154},{180.667,-110.154}},
                              color={0,0,127}));
  connect(TSetNom, setPre.uSetNom) annotation (Line(points={{-120,-184},{-88,
          -184},{-88,-36},{-90,-36},{-90,46},{-26,46},{-26,86.0741},{168.667,
          86.0741}},                            color={0,0,127}));
  connect(TSetTarShe, setShe.uSetTar) annotation (Line(points={{-120,-136},{-94,
          -136},{-94,-56},{166,-56},{166,-26},{172.667,-26}},
                                color={0,0,127}));
  connect(TSetTarShe, setReb.uSetTar) annotation (Line(points={{-120,-136},{-56,
          -136},{-56,-106},{180.667,-106}},
                                  color={0,0,127}));
  connect(TSetTarPre, setPre.uSetTar) annotation (Line(points={{-120,-86},{32,
          -86},{32,89.7778},{168.667,89.7778}},
                                 color={0,0,127}));
  connect(TSetNom, setNom.u) annotation (Line(points={{-120,-184},{-88,-184},{
          -88,-36},{-90,-36},{-90,46},{26,46},{26,-4},{20,-4},{20,-24},{16,-24},
          {16,-110},{164,-110},{164,38},{176,38}},
                                       color={0,0,127}));
  connect(uMod, singleTemperatureSetpointModeSelection.uMod) annotation (Line(
        points={{-120,44},{-24,44},{-24,50},{86,50},{86,-60.6667},{214.261,
          -60.6667}},                                     color={255,127,0}));
  connect(setPre.ySetCom, singleTemperatureSetpointModeSelection.uPre)
    annotation (Line(points={{191.333,91.1111},{210,91.1111},{210,-64.1667},{
          214.261,-64.1667}},                                       color={0,0,
          127}));
  connect(setNom.y, singleTemperatureSetpointModeSelection.uNom) annotation (
      Line(points={{200,38},{204,38},{204,-67.3333},{214.261,-67.3333}},
                                                        color={0,0,127}));
  connect(setShe.ySetCom,singleTemperatureSetpointModeSelection.uShe)
    annotation (Line(points={{195.333,-24},{202,-24},{202,-40},{170,-40},{170,
          -70.6667},{214.261,-70.6667}},
                  color={0,0,127}));
  connect(setReb.ySetCom, singleTemperatureSetpointModeSelection.uReb)
    annotation (Line(points={{203.333,-104},{203.333,-74.5},{214.261,-74.5}},
        color={0,0,127}));
  connect(singleTemperatureSetpointModeSelection.y,TSetCom)  annotation (Line(
        points={{237.739,-68},{244,-68},{244,-70},{270,-70}},
                                                 color={0,0,127}));
  connect(TCur, sub.u1) annotation (Line(points={{-120,8},{-72,8}},
                             color={0,0,127}));
  connect(TSetCur, sub.u2) annotation (Line(points={{-120,-34},{-84,-34},{-84,
          -4},{-72,-4}},                color={0,0,127}));
  connect(sub.y, lesThr.u) annotation (Line(points={{-48,2},{-28,2},{-28,26},{
          -18,26}},          color={0,0,127}));
  connect(sub.y, greThr.u) annotation (Line(points={{-48,2},{-28,2},{-28,-6},{
          -18,-6}},          color={0,0,127}));
  connect(con.y, logSwi.u2) annotation (Line(points={{40,10},{58,10}},
                            color={255,0,255}));
  connect(lesThr.y, logSwi.u1) annotation (Line(points={{6,26},{58,26},{58,18}},
                                      color={255,0,255}));
  connect(greThr.y, logSwi.u3) annotation (Line(points={{6,-6},{58,-6},{58,2}},
                  color={255,0,255}));
  connect(have_pri, and2.u1) annotation (Line(points={{-120,80},{-36,80},{-36,
          64},{106,64},{106,18},{120,18}},
                                      color={255,0,255}));
  connect(logSwi.y, and2.u2) annotation (Line(points={{82,10},{120,10}},
                    color={255,0,255}));
  connect(and2.y, setShe.have_pri)
    annotation (Line(points={{144,18},{168,18},{168,-17.8462},{172.667,-17.8462}},
                                                          color={255,0,255}));
  connect(setPre.reach_uSetTar, reach_TSetTarPre) annotation (Line(points={{191.333,
          96.4444},{244,96.4444},{244,64},{270,64}},
                                              color={255,0,255}));
  connect(reach_TSetTarPre, reach_TSetTarPre)
    annotation (Line(points={{270,64},{270,64}}, color={255,0,255}));
  connect(setPre.uSetCur, TSetCur) annotation (Line(points={{168.667,93.4815},{
          168,93.4815},{168,94},{-84,94},{-84,-34},{-120,-34}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
        extent={{-100,-200},{250,100}},
        grid={2,2})),                                            Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-100,-200},{250,100}},
        grid={2,2})));
end SingleTemperatureSetpointControl;
