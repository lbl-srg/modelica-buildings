within Buildings.Controls.OBC.DemandFlexibility.ChillerSetpointControl.Subsequences;
block SingleChillerBase

   parameter Real delChaShe=1
    "Change amount for load shed";

   parameter Real delChaReb=-1
    "Change amount for rebound";

    parameter Real uCooCoiValTho(min=0)=0.95
    "Cooling coil valve threshold below which ratcheting is triggerd.";

            parameter Real samPerNom(unit="s")=300
    "Sample period for the nominal condition";
        parameter Real samPerShe(unit="s")=300
    "Sample period for ratchet";
        parameter Real samPerReb(unit="s")=300
    "Sample period for rebound";
  Generic.SetpointMultipleStepChange setShe(delCha=delChaShe, samPer=samPerShe)
    annotation (Placement(transformation(extent={{162,-34},{182,-14}})));
  Generic.SetpointMultipleStepChange setReb(delCha=delChaReb, samPer=samPerReb)
    annotation (Placement(transformation(extent={{182,-114},{202,-94}})));
  CDL.Interfaces.BooleanInput
                           have_pri "have priority"
    annotation (Placement(transformation(extent={{-190,60},{-150,100}}),
        iconTransformation(extent={{-190,60},{-150,100}})));
  CDL.Interfaces.IntegerInput uMod
    "setpoint mode; 0 = normal;  1 = shed; 2 = rebound"
    annotation (Placement(transformation(extent={{-190,24},{-150,64}}),
        iconTransformation(extent={{-190,24},{-150,64}})));
  CDL.Interfaces.BooleanOutput reach_TSetTarShe annotation (Placement(
        transformation(extent={{250,-20},{290,20}}),iconTransformation(extent={{250,-20},
            {290,20}})));
  CDL.Interfaces.BooleanOutput reach_TSetNom annotation (Placement(
        transformation(extent={{250,-170},{290,-130}}),iconTransformation(
          extent={{250,-156},{290,-116}})));
  CDL.Interfaces.RealOutput TSetCom "setpoint command"
    annotation (Placement(transformation(extent={{250,-90},{290,-50}}),
        iconTransformation(extent={{250,-90},{290,-50}})));
  CDL.Interfaces.RealInput TSetNom "nominal setpoint"
    annotation (Placement(transformation(extent={{-192,-204},{-152,-164}})));
  CDL.Interfaces.RealInput TSetCur "current setpoint"
    annotation (Placement(transformation(extent={{-190,-54},{-150,-14}})));
  CDL.Interfaces.RealInput TSetTarShe "setpoint target for load shed"
    annotation (Placement(transformation(extent={{-192,-156},{-152,-116}}),
        iconTransformation(extent={{-192,-156},{-152,-116}})));
  CDL.Discrete.Sampler setNom(samplePeriod=samPerNom)
    annotation (Placement(transformation(extent={{170,48},{190,68}})));
  Generic.GeneralModeSelection chillerTemperatureModeSelection
    annotation (Placement(transformation(extent={{216,-78},{236,-58}})));
  CDL.Interfaces.RealInput uCooCoiValCur "current cooling coil valve signal"
    annotation (Placement(transformation(extent={{-190,-12},{-150,28}})));
  CDL.Reals.LessThreshold lesThr(t=uCooCoiValTho)
    annotation (Placement(transformation(extent={{-30,0},{-10,20}})));
  CDL.Logical.And and2
    annotation (Placement(transformation(extent={{122,8},{142,28}})));
equation
  connect(have_pri, setReb.have_pri) annotation (Line(points={{-170,80},{-74,80},
          {-74,-98},{78,-98},{78,-97.8462},{180.667,-97.8462}},
                              color={255,0,255}));
  connect(setShe.reach_uSetNom,reach_TSetNom)  annotation (Line(points={{183.333,
          -29.2308},{198,-29.2308},{198,-86},{210,-86},{210,-150},{270,-150}},
                                                 color={255,0,255}));
  connect(setShe.reach_uSetTar,reach_TSetTarShe)
    annotation (Line(points={{183.333,-18.1538},{244,-18.1538},{244,0},{270,0}},
                                                          color={255,0,255}));
  connect(TSetCur, setReb.uSetCur) annotation (Line(points={{-170,-34},{38,-34},
          {38,-101.385},{180.667,-101.385}},
                                  color={0,0,127}));
  connect(TSetCur, setShe.uSetCur) annotation (Line(points={{-170,-34},{140,-34},
          {140,-21.3846},{160.667,-21.3846}},
                                  color={0,0,127}));
  connect(TSetTarShe, setShe.uSetTar) annotation (Line(points={{-172,-136},{
          -116,-136},{-116,-52},{150,-52},{150,-26},{160.667,-26}},
                                color={0,0,127}));
  connect(TSetTarShe, setReb.uSetTar) annotation (Line(points={{-172,-136},{-56,
          -136},{-56,-106},{180.667,-106}},
                                  color={0,0,127}));
  connect(uMod, chillerTemperatureModeSelection.uMod) annotation (Line(points={{-170,44},
          {-24,44},{-24,50},{86,50},{86,-60.6667},{214.261,-60.6667}},
        color={255,127,0}));
  connect(setNom.y, chillerTemperatureModeSelection.uNom) annotation (Line(
        points={{192,58},{204,58},{204,-67.3333},{214.261,-67.3333}}, color={0,0,
          127}));
  connect(setReb.ySetCom, chillerTemperatureModeSelection.uReb) annotation (
      Line(points={{203.333,-104},{203.333,-74.5},{214.261,-74.5}}, color={0,0,127}));
  connect(chillerTemperatureModeSelection.y, TSetCom) annotation (Line(points={{237.739,
          -68},{244,-68},{244,-70},{270,-70}},         color={0,0,127}));
  connect(have_pri, and2.u1) annotation (Line(points={{-170,80},{-36,80},{-36,
          64},{106,64},{106,18},{120,18}},
                                      color={255,0,255}));
  connect(and2.y, setShe.have_pri)
    annotation (Line(points={{144,18},{152,18},{152,-17.8462},{160.667,-17.8462}},
                                                          color={255,0,255}));
  connect(setNom.u, TSetNom) annotation (Line(points={{168,58},{-106,58},{-106,
          -184},{-172,-184}}, color={0,0,127}));
  connect(TSetNom, setReb.uSetNom) annotation (Line(points={{-172,-184},{-28,
          -184},{-28,-110},{76,-110},{76,-110.154},{180.667,-110.154}}, color={
          0,0,127}));
  connect(TSetNom, setShe.uSetNom) annotation (Line(points={{-172,-184},{-28,
          -184},{-28,-30.1538},{160.667,-30.1538}}, color={0,0,127}));
  connect(setShe.ySetCom, chillerTemperatureModeSelection.uShe) annotation (
      Line(points={{183.333,-24},{192,-24},{192,-70},{214.261,-70},{214.261,
          -70.6667}},
        color={0,0,127}));
  connect(lesThr.y, and2.u2)
    annotation (Line(points={{-8,10},{120,10}}, color={255,0,255}));
  connect(uCooCoiValCur, lesThr.u) annotation (Line(points={{-170,8},{-40,8},{-40,
          10},{-32,10}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
        extent={{-150,-200},{250,120}},
        grid={2,2})),                                            Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-150,-200},{250,120}},
        grid={2,2})),
    Documentation(info="<html>
<p>This is a block that brings the full suite of control for a single chiller temperature setpoint. It contains the load shed mode, load rebound mode, and baseline mode. Each of the 3 modes includes a sampler block, where users can set the sampling period independently for each mode.</p>
<p>For the load shed mode specifically, there are specific elements in this logic block that checks whether a zone has remained under a cooling coil valve maximum signal (uCooCoiValCur) for ratcheting the chiller setpoint.  If the current cooling coil valve signal is less than uCooCoiValCur, the load shed mode will be activated. Otherwise, it will not be activated.</p>
</html>"));
end SingleChillerBase;
