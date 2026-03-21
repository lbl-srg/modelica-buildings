within Buildings.Controls.OBC.DemandFlexibility;
block SingleFanValveLimitingRatchetAdjustment

   parameter Real delChaShe=1
    "Change amount for load shed";

   parameter Real delChaReb=-1
    "Change amount for rebound";

            parameter Real samPerNom(unit="s")=300
    "Sample period for the nominal condition";
        parameter Real samPerShe(unit="s")=300
    "Sample period for ratchet";
        parameter Real samPerReb(unit="s")=300
    "Sample period for rebound";
  Subsequences.SetpointMultipleStepChange setShe(delCha=delChaShe, samPer=
        samPerShe)
    annotation (Placement(transformation(extent={{162,-34},{182,-14}})));
  Subsequences.SetpointMultipleStepChange setReb(delCha=delChaReb, samPer=
        samPerReb)
    annotation (Placement(transformation(extent={{182,-114},{202,-94}})));
  CDL.Interfaces.IntegerInput uMod
    "setpoint mode; 0 = normal;  1 = shed; 2 = rebound"
    annotation (Placement(transformation(extent={{-190,24},{-150,64}}),
        iconTransformation(extent={{-190,24},{-150,64}})));
  CDL.Interfaces.RealOutput uSetCom "setpoint command"
    annotation (Placement(transformation(extent={{250,-90},{290,-50}}),
        iconTransformation(extent={{250,-90},{290,-50}})));
  CDL.Interfaces.RealInput uSetNom "nominal setpoint"
    annotation (Placement(transformation(extent={{-192,-204},{-152,-164}})));
  CDL.Interfaces.RealInput uSetCur "current setpoint"
    annotation (Placement(transformation(extent={{-190,-54},{-150,-14}})));
  CDL.Interfaces.RealInput uSetTarShe "setpoint target for load shed"
    annotation (Placement(transformation(extent={{-192,-156},{-152,-116}}),
        iconTransformation(extent={{-192,-156},{-152,-116}})));
  CDL.Discrete.Sampler setNom(samplePeriod=samPerNom)
    annotation (Placement(transformation(extent={{170,48},{190,68}})));
  Subsequences.GeneralModeSelection chillerTemperatureModeSelection
    annotation (Placement(transformation(extent={{216,-78},{236,-58}})));
  CDL.Logical.Sources.Constant con(k=true)
    annotation (Placement(transformation(extent={{-74,86},{-54,106}})));
equation
  connect(uSetCur, setReb.uSetCur) annotation (Line(points={{-170,-34},{38,-34},
          {38,-101.385},{180.667,-101.385}},
                                  color={0,0,127}));
  connect(uSetCur, setShe.uSetCur) annotation (Line(points={{-170,-34},{140,-34},
          {140,-21.3846},{160.667,-21.3846}},
                                  color={0,0,127}));
  connect(uSetTarShe, setShe.uSetTar) annotation (Line(points={{-172,-136},{
          -116,-136},{-116,-52},{150,-52},{150,-26},{160.667,-26}},
                                color={0,0,127}));
  connect(uSetTarShe, setReb.uSetTar) annotation (Line(points={{-172,-136},{-56,
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
  connect(chillerTemperatureModeSelection.y,uSetCom)  annotation (Line(points={{237.739,
          -68},{244,-68},{244,-70},{270,-70}},         color={0,0,127}));
  connect(setNom.u,uSetNom)  annotation (Line(points={{168,58},{-106,58},{-106,
          -184},{-172,-184}}, color={0,0,127}));
  connect(uSetNom, setReb.uSetNom) annotation (Line(points={{-172,-184},{-28,
          -184},{-28,-110},{76,-110},{76,-110.154},{180.667,-110.154}}, color={
          0,0,127}));
  connect(uSetNom, setShe.uSetNom) annotation (Line(points={{-172,-184},{-28,
          -184},{-28,-30.1538},{160.667,-30.1538}}, color={0,0,127}));
  connect(setShe.ySetCom, chillerTemperatureModeSelection.uShe) annotation (
      Line(points={{183.333,-24},{192,-24},{192,-70},{214.261,-70},{214.261,
          -70.6667}},
        color={0,0,127}));
  connect(con.y, setReb.have_pri) annotation (Line(points={{-52,96},{64,96},{64,
          -97.8462},{180.667,-97.8462}}, color={255,0,255}));
  connect(con.y, setShe.have_pri) annotation (Line(points={{-52,96},{54,96},{54,
          -17.8462},{160.667,-17.8462}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
        extent={{-150,-200},{250,120}},
        grid={2,2})),                                            Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-150,-200},{250,120}},
        grid={2,2})),
    Documentation(info="<html>
<p>This block controls the fan or valve limiting for a single fan or valve. It offers multiple step changes for the maximum fan or valve position setpoint. This is based on the current mode uMod: 0 = baseline mode, 1 = load shed mode, and 2 = load rebound mode. </p>
<p>At the baseline mode , the maximum fan or valve position setpoint is equal to uSetNom. At the load shed mode, the maximum fan or valve position setpoint will gradually decrease from uSetNom to uSetTarShe in multiple steps. At the load rebound mode, the maximum fan or valve position setpoint will gradually increase from uSetTarShe to uSetNom in multiple steps.</p>
</html>"));
end SingleFanValveLimitingRatchetAdjustment;
