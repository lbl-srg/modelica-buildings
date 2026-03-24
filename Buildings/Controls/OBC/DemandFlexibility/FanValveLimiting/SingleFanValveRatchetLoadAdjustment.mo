within Buildings.Controls.OBC.DemandFlexibility.FanValveLimiting;
block SingleFanValveRatchetLoadAdjustment

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
  Generic.SetpointMultipleStepChange setShe(delCha=delChaShe, samPer=samPerShe)
    annotation (Placement(transformation(extent={{162,-34},{182,-14}})));
  Generic.SetpointMultipleStepChange setReb(delCha=delChaReb, samPer=samPerReb)
    annotation (Placement(transformation(extent={{162,-114},{182,-94}})));
  CDL.Interfaces.IntegerInput uMod
    "setpoint mode; 0 = normal;  1 = shed; 2 = rebound"
    annotation (Placement(transformation(extent={{-190,70},{-150,110}}),
        iconTransformation(extent={{-190,70},{-150,110}})));
  CDL.Interfaces.RealOutput uSetCom "setpoint command"
    annotation (Placement(transformation(extent={{250,-90},{290,-50}}),
        iconTransformation(extent={{250,-90},{290,-50}})));
  CDL.Interfaces.RealInput uSetNom "nominal setpoint"
    annotation (Placement(transformation(extent={{-190,-102},{-150,-62}})));
  CDL.Interfaces.RealInput uSetCur "current setpoint"
    annotation (Placement(transformation(extent={{-190,18},{-150,58}})));
  CDL.Interfaces.RealInput uSetTarShe "setpoint target for load shed"
    annotation (Placement(transformation(extent={{-192,-56},{-152,-16}}),
        iconTransformation(extent={{-192,-56},{-152,-16}})));
  CDL.Discrete.Sampler setNom(samplePeriod=samPerNom)
    annotation (Placement(transformation(extent={{160,48},{180,68}})));
  Generic.GeneralModeSelection chillerTemperatureModeSelection
    annotation (Placement(transformation(extent={{216,-78},{236,-58}})));
  CDL.Logical.Sources.Constant con(k=true)
    annotation (Placement(transformation(extent={{-20,-190},{0,-170}})));
  CDL.Interfaces.RealInput PBui "building electric power"
    annotation (Placement(transformation(extent={{-190,-150},{-150,-110}})));
  CDL.Interfaces.RealInput PBuiMaxTar "building electric power maximum target"
    annotation (Placement(transformation(extent={{-190,-200},{-150,-160}})));
  CDL.Reals.Greater gre
    annotation (Placement(transformation(extent={{-94,-150},{-52,-112}})));
equation
  connect(uSetTarShe, setShe.uSetTar) annotation (Line(points={{-172,-36},{76,
          -36},{76,-26},{160.667,-26}},
                                color={0,0,127}));
  connect(uSetTarShe, setReb.uSetTar) annotation (Line(points={{-172,-36},{76,
          -36},{76,-106},{160.667,-106}},
                                  color={0,0,127}));
  connect(uMod, chillerTemperatureModeSelection.uMod) annotation (Line(points={{-170,90},
          {208,90},{208,-60.6667},{214.261,-60.6667}},
        color={255,127,0}));
  connect(setNom.y, chillerTemperatureModeSelection.uNom) annotation (Line(
        points={{182,58},{198,58},{198,-67.3333},{214.261,-67.3333}}, color={0,0,
          127}));
  connect(setReb.ySetCom, chillerTemperatureModeSelection.uReb) annotation (
      Line(points={{183.333,-104},{200,-104},{200,-74.5},{214.261,-74.5}},
                                                                    color={0,0,127}));
  connect(chillerTemperatureModeSelection.y,uSetCom)  annotation (Line(points={{237.739,
          -68},{244,-68},{244,-70},{270,-70}},         color={0,0,127}));
  connect(setNom.u,uSetNom)  annotation (Line(points={{158,58},{148,58},{148,
          -82},{-170,-82}},   color={0,0,127}));
  connect(uSetNom, setReb.uSetNom) annotation (Line(points={{-170,-82},{48,-82},
          {48,-110},{162,-110},{162,-110.154},{160.667,-110.154}},      color={
          0,0,127}));
  connect(uSetNom, setShe.uSetNom) annotation (Line(points={{-170,-82},{148,-82},
          {148,-30.1538},{160.667,-30.1538}},       color={0,0,127}));
  connect(setShe.ySetCom, chillerTemperatureModeSelection.uShe) annotation (
      Line(points={{183.333,-24},{192,-24},{192,-70},{214.261,-70},{214.261,
          -70.6667}},
        color={0,0,127}));
  connect(con.y, setReb.have_pri) annotation (Line(points={{2,-180},{36,-180},{
          36,-97.8462},{160.667,-97.8462}},
                                         color={255,0,255}));
  connect(PBui, gre.u1) annotation (Line(points={{-170,-130},{-98,-130},{-98,
          -132},{-98.2,-132},{-98.2,-131}},
                                color={0,0,127}));
  connect(gre.u2, PBuiMaxTar) annotation (Line(points={{-98.2,-146.2},{-125.1,
          -146.2},{-125.1,-180},{-170,-180}}, color={0,0,127}));
  connect(gre.y, setShe.have_pri) annotation (Line(points={{-47.8,-131},{-47.8,
          -132},{22,-132},{22,-17.8462},{160.667,-17.8462}}, color={255,0,255}));
  connect(setReb.uSetCur, uSetCur) annotation (Line(points={{160.667,-101.385},
          {107.334,-101.385},{107.334,38},{-170,38}}, color={0,0,127}));
  connect(uSetCur, setShe.uSetCur) annotation (Line(points={{-170,38},{108,38},
          {108,-22},{160,-22},{160,-21.3846},{160.667,-21.3846}}, color={0,0,
          127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
        extent={{-150,-200},{250,120}},
        grid={2,2})),                                            Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-150,-200},{250,120}},
        grid={2,2})),
    Documentation(info="<html>
<p>This block controls the fan or valve limiting for a single fan or valve. It offers multiple step changes for the maximum fan or valve position setpoint, with consideration to the building electricity demand. This is based on the current mode uMod: 0 = baseline mode, 1 = load shed mode, and 2 = load rebound mode. </p>
<p>At the baseline mode , the maximum fan or valve position setpoint is equal to uSetNom. At the load shed mode, if the building electricity demand (PBui) is higher than the building electricity demand limit (PBuiMaxTar), the maximum fan or valve position setpoint will gradually decrease from uSetNom to uSetTarShe in multiple steps. However, if the building electricity demand is lower than the building electricity demand limit, the maximum fan or valve position setpoint will maintain at the current maximum fan or valve position setpoint. At the load rebound mode, the maximum fan or valve position setpoint will gradually increase from uSetTarShe to uSetNom in multiple steps.</p>
</html>"));
end SingleFanValveRatchetLoadAdjustment;
