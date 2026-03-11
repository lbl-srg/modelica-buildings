within Buildings.Controls.OBC.DemandFlexibility;
block MultipleZoneSetpointControl

  parameter Integer nZon=4;


   parameter Boolean demFleHeaAct=true "the demand flexibility for heating is active";
    parameter Boolean demFleCooAct=true "the demand flexibility for cooling is active";

       parameter Real delChaSheHea=-1
    "Change amount for ratchet for heating";

   parameter Real delChaRebHea=1
    "Change amount for rebound for heating";
        parameter Real samPerPreHea(unit="s")=300
    "Sample period for preheat";
            parameter Real samPerNomHea(unit="s")=300
    "Sample period for the nominal condition for heating";
        parameter Real samPerSheHea(unit="s")=300
    "Sample period for ratche for heatingt";
        parameter Real samPerRebHea(unit="s")=300
    "Sample period for rebound for heating";

    parameter Real delSheThoHea=0.5
    "Threshold below which heating ratcheting is triggerd. This is an absolute value, so it is always positive";

        parameter Real delSheThoCoo=0.5
    "Threshold below which cooling ratcheting is triggerd. This is an absolute value, so it is always positive";

       parameter Real delChaSheCoo=1
    "Change amount for ratchet for cooling";

   parameter Real delChaRebCoo=-1
    "Change amount for rebound for cooling";
        parameter Real samPerPreCoo(unit="s")=300
    "Sample period for precool";
            parameter Real samPerNomCoo(unit="s")=300
    "Sample period for the nominal condition for cooling";
        parameter Real samPerSheCoo(unit="s")=300
    "Sample period for ratchet for cooling";
        parameter Real samPerRebCoo(unit="s")=300
    "Sample period for rebound for cooling";




  CDL.Interfaces.IntegerInput uMod
    "setpoint mode; 0 = normal; -1 = precool or preheat; 1 = ratchet; 2 = rebound"
    annotation (Placement(transformation(extent={{-142,60},{-102,100}}),
        iconTransformation(extent={{-140,44},{-100,84}})));
  CDL.Interfaces.RealInput TSetTarPreHea[nZon] "setpoint target for preheat"
    annotation (Placement(transformation(extent={{-142,2},{-102,42}}),
        iconTransformation(extent={{-142,2},{-102,42}})));
  CDL.Interfaces.RealInput TSetTarSheHea[nZon] "setpoint target for load shed"
    annotation (Placement(transformation(extent={{-142,-34},{-102,6}})));
  CDL.Interfaces.RealInput TSetCurHea[nZon] "current setpoint"
    annotation (Placement(transformation(extent={{-140,-112},{-100,-72}})));
  CDL.Interfaces.RealInput TSetNomHea[nZon] "nominal setpoint"
    annotation (Placement(transformation(extent={{-142,-76},{-102,-36}})));
  CDL.Interfaces.RealInput TSetTarPreCoo[nZon] "setpoint target for precool"
    annotation (Placement(transformation(extent={{-142,-204},{-102,-164}})));
  CDL.Interfaces.RealInput TCur[nZon] "current zone temperature"
    annotation (Placement(transformation(extent={{-142,-158},{-102,-118}})));
  CDL.Interfaces.RealInput TSetTarSheCoo[nZon] "setpoint target for load shed"
    annotation (Placement(transformation(extent={{-144,-240},{-104,-200}})));
  CDL.Interfaces.RealInput TSetNomCoo[nZon] "nominal setpoint"
    annotation (Placement(transformation(extent={{-144,-278},{-104,-238}})));
  CDL.Interfaces.RealInput TSetCurCoo[nZon] "current setpoint"
    annotation (Placement(transformation(extent={{-138,-322},{-98,-282}})));
  CDL.Interfaces.RealOutput TSetComHea[nZon] "setpoint command" annotation (Placement(
        transformation(extent={{262,-10},{302,30}}),iconTransformation(extent={{260,4},
            {300,44}})));
  CDL.Interfaces.RealOutput TSetComCoo[nZon] "setpoint command"
    annotation (Placement(transformation(extent={{260,-206},{300,-166}}),
        iconTransformation(extent={{260,-206},{300,-166}})));
  SingleZoneSetpointControl dualTemperatureSetpointControl[nZon](
    demFleHeaAct=demFleHeaAct,
    demFleCooAct=demFleCooAct,
    delChaSheHea=delChaSheHea,
    delChaRebHea=delChaRebHea,
    samPerPreHea=samPerPreHea,
    samPerNomHea=samPerNomHea,
    samPerSheHea=samPerSheHea,
    samPerRebHea=samPerRebHea,
    delSheThoHea=delSheThoHea,
    delSheThoCoo=delSheThoCoo,
    delChaSheCoo=delChaSheCoo,
    delChaRebCoo=delChaRebCoo,
    samPerPreCoo=samPerPreCoo,
    samPerNomCoo=samPerNomCoo,
    samPerSheCoo=samPerSheCoo,
    samPerRebCoo=samPerRebCoo)
    annotation (Placement(transformation(extent={{84,-108},{206,64}})));
  CDL.Routing.IntegerScalarReplicator intScaRep(nout=nZon)
    annotation (Placement(transformation(extent={{-46,90},{-26,110}})));
  Subsequences.SelectSmallestTemperatureDifference
    selectSmallestTemperatureDifferenceSheHea(nZon=nZon, nSel=1)
    annotation (Placement(transformation(extent={{-28,10},{-8,30}})));
  Subsequences.SelectSmallestTemperatureDifference
    selectSmallestTemperatureDifferenceRebHea(nZon=nZon, nSel=1)
    annotation (Placement(transformation(extent={{-26,-28},{-6,-8}})));
  Subsequences.SelectSmallestTemperatureDifference
    selectSmallestTemperatureDifferencePreHea(nZon=nZon, nSel=1)
    annotation (Placement(transformation(extent={{-26,46},{-6,66}})));
  Subsequences.SelectLargestTemperatureDifference
    selectLargestTemperatureDifferencePreCoo(nZon=nZon, nSel=1)
    annotation (Placement(transformation(extent={{-20,-74},{10,-54}})));
  Subsequences.SelectLargestTemperatureDifference
    selectLargestTemperatureDifferenceSheCoo(nZon=nZon, nSel=1)
    annotation (Placement(transformation(extent={{-16,-136},{14,-116}})));
  Subsequences.SelectLargestTemperatureDifference
    selectLargestTemperatureDifferenceRebCoo(nZon=nZon, nSel=1)
    annotation (Placement(transformation(extent={{-18,-200},{12,-180}})));
  Subsequences.TemperatureModeSelectionBool
    singleTemperatureSetpointModeSelectionBoolHea[nZon]
    annotation (Placement(transformation(extent={{18,74},{38,94}})));
  Subsequences.TemperatureModeSelectionBool
    singleTemperatureSetpointModeSelectionBoolCoo[nZon]
    annotation (Placement(transformation(extent={{30,-166},{50,-146}})));
equation
  connect(uMod, intScaRep.u) annotation (Line(points={{-122,80},{-58,80},{-58,100},
          {-48,100}},      color={255,127,0}));
  connect(intScaRep.y, dualTemperatureSetpointControl.uMod) annotation (Line(
        points={{-24,100},{54,100},{54,30.5053},{71.8,30.5053}}, color={255,127,
          0}));
  connect(TCur,selectSmallestTemperatureDifferenceSheHea. TCur) annotation (
      Line(points={{-122,-138},{-40,-138},{-40,-54},{-44,-54},{-44,-14},{-48,
          -14},{-48,4},{-38,4},{-38,26},{-29.3793,26}},
                color={0,0,127}));
  connect(TSetCurHea,selectSmallestTemperatureDifferenceSheHea. TSetCur)
    annotation (Line(points={{-120,-92},{-92,-92},{-92,-18},{-42,-18},{-42,24},
          {-34,24},{-34,20},{-29.3793,20}},
                                          color={0,0,127}));
  connect(dualTemperatureSetpointControl.reach_TSetTarSheHea,
    selectSmallestTemperatureDifferenceSheHea.uIgnFla) annotation (Line(points={{218.2,
          34.1263},{218.2,74},{52,74},{52,42},{-34,42},{-34,26},{-36,26},{-36,
          14.2},{-29.3793,14.2}},      color={255,0,255}));
  connect(TCur, selectSmallestTemperatureDifferenceRebHea.TCur) annotation (
      Line(points={{-122,-138},{-40,-138},{-40,-54},{-44,-54},{-44,-30},{-32,
          -30},{-32,-12},{-27.3793,-12}},
                 color={0,0,127}));
  connect(TSetCurHea, selectSmallestTemperatureDifferenceRebHea.TSetCur)
    annotation (Line(points={{-120,-92},{-92,-92},{-92,-18},{-27.3793,-18}},
        color={0,0,127}));
  connect(dualTemperatureSetpointControl.reach_TSetNomHea,
    selectSmallestTemperatureDifferenceRebHea.uIgnFla) annotation (Line(points={{218.2,
          0.631579},{236,0.631579},{236,60},{212,60},{212,70},{-30,70},{-30,74},
          {-38,74},{-38,52},{-40,52},{-40,8},{-36,8},{-36,-23.8},{-27.3793,
          -23.8}}, color={255,0,255}));
  connect(TCur, selectSmallestTemperatureDifferencePreHea.TCur) annotation (
      Line(points={{-122,-138},{-40,-138},{-40,-54},{-44,-54},{-44,-14},{-48,
          -14},{-48,54},{-36,54},{-36,62},{-27.3793,62}},        color={0,0,127}));
  connect(TSetCurHea, selectSmallestTemperatureDifferencePreHea.TSetCur)
    annotation (Line(points={{-120,-92},{-92,-92},{-92,-18},{-42,-18},{-42,24},
          {-38,24},{-38,50},{-34,50},{-34,56},{-27.3793,56}}, color={0,0,127}));
  connect(dualTemperatureSetpointControl.reach_TSetTarPreHea,
    selectSmallestTemperatureDifferencePreHea.uIgnFla) annotation (Line(points={{218.2,
          53.1368},{218.2,50.2},{-27.3793,50.2}},        color={255,0,255}));
  connect(TCur, selectLargestTemperatureDifferencePreCoo.TCur) annotation (Line(
        points={{-122,-138},{-40,-138},{-40,-58},{-22.069,-58}}, color={0,0,127}));
  connect(TSetCurCoo, selectLargestTemperatureDifferencePreCoo.TSetCur)
    annotation (Line(points={{-118,-302},{-90,-302},{-90,-190},{-28,-190},{-28,
          -78},{-30,-78},{-30,-64},{-22.069,-64}},
                                              color={0,0,127}));
  connect(TCur, selectLargestTemperatureDifferenceSheCoo.TCur) annotation (Line(
        points={{-122,-138},{-26,-138},{-26,-120},{-18.069,-120}}, color={0,0,127}));
  connect(TSetCurCoo, selectLargestTemperatureDifferenceSheCoo.TSetCur)
    annotation (Line(points={{-118,-302},{-90,-302},{-90,-190},{-28,-190},{-28,
          -126},{-18.069,-126}},
                           color={0,0,127}));
  connect(TCur, selectLargestTemperatureDifferenceRebCoo.TCur) annotation (Line(
        points={{-122,-138},{-30,-138},{-30,-184},{-20.069,-184}}, color={0,0,127}));
  connect(TSetCurCoo, selectLargestTemperatureDifferenceRebCoo.TSetCur)
    annotation (Line(points={{-118,-302},{-90,-302},{-90,-190},{-20.069,-190}},
        color={0,0,127}));
  connect(dualTemperatureSetpointControl.reach_TSetTarPreCoo,
    selectLargestTemperatureDifferencePreCoo.uIgnFla) annotation (Line(points={{218.2,
          -30.1474},{-26,-30.1474},{-26,-69.8},{-22.069,-69.8}},       color={255,
          0,255}));
  connect(dualTemperatureSetpointControl.reach_TSetTarSheCoo,
    selectLargestTemperatureDifferenceSheCoo.uIgnFla) annotation (Line(points={{218.2,
          -49.1579},{232,-49.1579},{232,-131.8},{-18.069,-131.8}},       color={
          255,0,255}));
  connect(dualTemperatureSetpointControl.reach_TSetNomCoo,
    selectLargestTemperatureDifferenceRebCoo.uIgnFla) annotation (Line(points={{218.2,
          -64.5474},{246,-64.5474},{246,-228},{-20.069,-228},{-20.069,-195.8}},
        color={255,0,255}));
  connect(TSetTarPreHea, dualTemperatureSetpointControl.TSetTarPreHea)
    annotation (Line(points={{-122,22},{-42,22},{-42,30},{-36,30},{-36,36},{50,36},
          {50,19.6421},{71.8,19.6421}}, color={0,0,127}));
  connect(TSetTarSheHea, dualTemperatureSetpointControl.TSetTarSheHea)
    annotation (Line(points={{-122,-14},{-50,-14},{-50,-12},{-34,-12},{-34,0},{52,
          0},{52,3.34737},{71.8,3.34737}}, color={0,0,127}));
  connect(TSetNomHea, dualTemperatureSetpointControl.TSetNomHea) annotation (
      Line(points={{-122,-56},{-48,-56},{-48,-42},{2,-42},{2,-18},{52,-18},{52,-9.32632},
          {71.8,-9.32632}}, color={0,0,127}));
  connect(TSetCurHea, dualTemperatureSetpointControl.TSetCurHea) annotation (
      Line(points={{-120,-92},{-92,-92},{-92,-18},{-42,-18},{-42,24},{-34,24},{
          -34,4},{50,4},{50,-20.1895},{71.8,-20.1895}},
                                                    color={0,0,127}));
  connect(TCur, dualTemperatureSetpointControl.TCur) annotation (Line(points={{-122,
          -138},{-40,-138},{-40,-54},{-44,-54},{-44,-44},{54,-44},{54,-34.6737},
          {71.8,-34.6737}}, color={0,0,127}));
  connect(TSetTarPreCoo, dualTemperatureSetpointControl.TSetTarPreCoo)
    annotation (Line(points={{-122,-184},{-38,-184},{-38,-80},{50,-80},{50,-49.1579},
          {71.8,-49.1579}}, color={0,0,127}));
  connect(TSetTarSheCoo, dualTemperatureSetpointControl.TSetTarSheCoo)
    annotation (Line(points={{-124,-220},{-42,-220},{-42,-56},{-30,-56},{-30,
          -48},{52,-48},{52,-60.9263},{71.8,-60.9263}},
                                                   color={0,0,127}));
  connect(TSetNomCoo, dualTemperatureSetpointControl.TSetNomCoo) annotation (
      Line(points={{-124,-258},{-22,-258},{-22,-77.2211},{71.8,-77.2211}},
        color={0,0,127}));
  connect(TSetCurCoo, dualTemperatureSetpointControl.TSetCurCoo) annotation (
      Line(points={{-118,-302},{-90,-302},{-90,-190},{-28,-190},{-28,-86},{54,
          -86},{54,-106},{71.8,-106},{71.8,-92.6105}},
                                                  color={0,0,127}));
  connect(intScaRep.y, singleTemperatureSetpointModeSelectionBoolHea.uMod)
    annotation (Line(points={{-24,100},{8,100},{8,92.8},{16,92.8}}, color={255,127,
          0}));
  connect(selectSmallestTemperatureDifferencePreHea.yAcnFla,
    singleTemperatureSetpointModeSelectionBoolHea.uPre) annotation (Line(points
        ={{-4.62069,56.2},{2,56.2},{2,88.6},{16,88.6}}, color={255,0,255}));
  connect(selectSmallestTemperatureDifferenceSheHea.yAcnFla,
    singleTemperatureSetpointModeSelectionBoolHea.uShe) annotation (Line(points
        ={{-6.62069,20.2},{-2,20.2},{-2,40},{14,40},{14,68},{8,68},{8,80.8},{16,
          80.8}}, color={255,0,255}));
  connect(selectSmallestTemperatureDifferenceRebHea.yAcnFla,
    singleTemperatureSetpointModeSelectionBoolHea.uReb) annotation (Line(points
        ={{-4.62069,-17.8},{-4.62069,76.2},{16,76.2}}, color={255,0,255}));
  connect(singleTemperatureSetpointModeSelectionBoolHea.y,
    dualTemperatureSetpointControl.have_priHea) annotation (Line(points={{40,84},
          {71.8,84},{71.8,60.3789}}, color={255,0,255}));
  connect(selectLargestTemperatureDifferencePreCoo.yAcnFla,
    singleTemperatureSetpointModeSelectionBoolCoo.uPre) annotation (Line(points={{12.069,
          -63.8},{52,-63.8},{52,-140},{60,-140},{60,-172},{20,-172},{20,-151.4},
          {28,-151.4}},         color={255,0,255}));
  connect(selectLargestTemperatureDifferenceSheCoo.yAcnFla,
    singleTemperatureSetpointModeSelectionBoolCoo.uShe) annotation (Line(points={{16.069,
          -125.8},{26,-125.8},{26,-140},{20,-140},{20,-150},{18,-150},{18,
          -159.2},{28,-159.2}}, color={255,0,255}));
  connect(selectLargestTemperatureDifferenceRebCoo.yAcnFla,
    singleTemperatureSetpointModeSelectionBoolCoo.uReb) annotation (Line(points={{14.069,
          -189.8},{28,-189.8},{28,-163.8}},         color={255,0,255}));
  connect(intScaRep.y, singleTemperatureSetpointModeSelectionBoolCoo.uMod)
    annotation (Line(points={{-24,100},{54,100},{54,6},{0,6},{0,2},{-46,2},{-46,
          -147.2},{28,-147.2}}, color={255,127,0}));
  connect(singleTemperatureSetpointModeSelectionBoolCoo.y,
    dualTemperatureSetpointControl.have_priCoo) annotation (Line(points={{52,-156},
          {64,-156},{64,45.8947},{71.8,45.8947}}, color={255,0,255}));
  connect(dualTemperatureSetpointControl.TSetComHea, TSetComHea) annotation (
      Line(points={{218.2,18.7368},{256,18.7368},{256,10},{282,10}}, color={0,0,
          127}));
  connect(dualTemperatureSetpointControl.TSetComCoo, TSetComCoo) annotation (
      Line(points={{218.2,-87.1789},{218.2,-134},{256,-134},{256,-186},{280,
          -186}},
        color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-320},
            {260,100}})), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-320},{260,100}})));
end MultipleZoneSetpointControl;
