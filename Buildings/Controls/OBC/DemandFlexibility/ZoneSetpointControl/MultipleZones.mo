within Buildings.Controls.OBC.DemandFlexibility.ZoneSetpointControl;
block MultipleZones

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
    annotation (Placement(transformation(extent={{-300,138},{-260,178}}),
        iconTransformation(extent={{-300,138},{-260,178}})));
  CDL.Interfaces.RealInput TSetTarPreHea[nZon] "setpoint target for preheat"
    annotation (Placement(transformation(extent={{-300,-62},{-260,-22}}),
        iconTransformation(extent={{-300,-62},{-260,-22}})));
  CDL.Interfaces.RealInput TSetTarSheHea[nZon] "setpoint target for load shed"
    annotation (Placement(transformation(extent={{-300,-110},{-260,-70}})));
  CDL.Interfaces.RealInput TSetCurHea[nZon] "current setpoint"
    annotation (Placement(transformation(extent={{-300,94},{-260,134}}),
        iconTransformation(extent={{-300,94},{-260,134}})));
  CDL.Interfaces.RealInput TSetNomHea[nZon] "nominal setpoint"
    annotation (Placement(transformation(extent={{-300,-146},{-260,-106}})));
  CDL.Interfaces.RealInput TSetTarPreCoo[nZon] "setpoint target for precool"
    annotation (Placement(transformation(extent={{-300,-204},{-260,-164}})));
  CDL.Interfaces.RealInput TCur[nZon] "current zone temperature"
    annotation (Placement(transformation(extent={{-300,38},{-260,78}}),
        iconTransformation(extent={{-300,38},{-260,78}})));
  CDL.Interfaces.RealInput TSetTarSheCoo[nZon] "setpoint target for load shed"
    annotation (Placement(transformation(extent={{-300,-248},{-260,-208}}),
        iconTransformation(extent={{-300,-248},{-260,-208}})));
  CDL.Interfaces.RealInput TSetNomCoo[nZon] "nominal setpoint"
    annotation (Placement(transformation(extent={{-300,-292},{-260,-252}}),
        iconTransformation(extent={{-300,-292},{-260,-252}})));
  CDL.Interfaces.RealInput TSetCurCoo[nZon] "current setpoint"
    annotation (Placement(transformation(extent={{-300,-10},{-260,30}}),
        iconTransformation(extent={{-300,-10},{-260,30}})));
  CDL.Interfaces.RealOutput TSetComHea[nZon] "setpoint command" annotation (Placement(
        transformation(extent={{262,-10},{302,30}}),iconTransformation(extent={{260,4},
            {300,44}})));
  CDL.Interfaces.RealOutput TSetComCoo[nZon] "setpoint command"
    annotation (Placement(transformation(extent={{260,-206},{300,-166}}),
        iconTransformation(extent={{260,-206},{300,-166}})));
  Subsequences.BaseTemperatureSetpointElements.DualTemperatureSetpoint
    dualTemperatureSetpoint[nZon](
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
    annotation (Placement(transformation(extent={{70,-158},{192,14}})));
  CDL.Routing.IntegerScalarReplicator intScaRep(nout=nZon)
    annotation (Placement(transformation(extent={{-240,148},{-220,168}})));
  Subsequences.SelectSmallestTemperatureDifference
    selectSmallestTemperatureDifferenceSheHea(nZon=nZon, nSel=1)
    annotation (Placement(transformation(extent={{-122,78},{-102,98}})));
  Subsequences.SelectSmallestTemperatureDifference
    selectSmallestTemperatureDifferenceRebHea(nZon=nZon, nSel=1)
    annotation (Placement(transformation(extent={{-122,36},{-102,56}})));
  Subsequences.SelectSmallestTemperatureDifference
    selectSmallestTemperatureDifferencePreHea(nZon=nZon, nSel=1)
    annotation (Placement(transformation(extent={{-122,124},{-102,144}})));
  Subsequences.SelectLargestTemperatureDifference
    selectLargestTemperatureDifferencePreCoo(nZon=nZon, nSel=1)
    annotation (Placement(transformation(extent={{-120,-204},{-100,-184}})));
  Subsequences.SelectLargestTemperatureDifference
    selectLargestTemperatureDifferenceSheCoo(nZon=nZon, nSel=1)
    annotation (Placement(transformation(extent={{-118,-254},{-98,-234}})));
  Subsequences.SelectLargestTemperatureDifference
    selectLargestTemperatureDifferenceRebCoo(nZon=nZon, nSel=1)
    annotation (Placement(transformation(extent={{-118,-290},{-98,-270}})));
  Subsequences.ModeSelectionBool singleTemperatureSetpointModeSelectionBoolHea[
    nZon] annotation (Placement(transformation(extent={{-38,88},{-18,108}})));
  Subsequences.ModeSelectionBool singleTemperatureSetpointModeSelectionBoolCoo[
    nZon] annotation (Placement(transformation(extent={{-32,-242},{-12,-222}})));
equation
  connect(uMod, intScaRep.u) annotation (Line(points={{-280,158},{-242,158}},
                           color={255,127,0}));
  connect(intScaRep.y, dualTemperatureSetpoint.uMod) annotation (Line(points={{
          -218,158},{-208,158},{-208,-20},{61.2857,-20},{61.2857,-22.8571}},
        color={255,127,0}));
  connect(TCur,selectSmallestTemperatureDifferenceSheHea. TCur) annotation (
      Line(points={{-280,58},{-200,58},{-200,94},{-124,94}},
                color={0,0,127}));
  connect(TSetCurHea,selectSmallestTemperatureDifferenceSheHea. TSetCur)
    annotation (Line(points={{-280,114},{-192,114},{-192,88},{-124,88}},
                                          color={0,0,127}));
  connect(dualTemperatureSetpoint.reach_TSetTarSheHea,
    selectSmallestTemperatureDifferenceSheHea.uIgnFla) annotation (Line(points=
          {{200.714,-21.219},{232,-21.219},{232,64},{-140,64},{-140,82.2},{-124,
          82.2}}, color={255,0,255}));
  connect(TCur, selectSmallestTemperatureDifferenceRebHea.TCur) annotation (
      Line(points={{-280,58},{-200,58},{-200,52},{-124,52}},
                 color={0,0,127}));
  connect(TSetCurHea, selectSmallestTemperatureDifferenceRebHea.TSetCur)
    annotation (Line(points={{-280,114},{-192,114},{-192,46},{-124,46}},
        color={0,0,127}));
  connect(dualTemperatureSetpoint.reach_TSetNomHea,
    selectSmallestTemperatureDifferenceRebHea.uIgnFla) annotation (Line(points=
          {{200.714,-51.5238},{200.714,-50},{242,-50},{242,28},{-132,28},{-132,
          40.2},{-124,40.2}}, color={255,0,255}));
  connect(TCur, selectSmallestTemperatureDifferencePreHea.TCur) annotation (
      Line(points={{-280,58},{-200,58},{-200,140},{-124,140}},   color={0,0,127}));
  connect(TSetCurHea, selectSmallestTemperatureDifferencePreHea.TSetCur)
    annotation (Line(points={{-280,114},{-192,114},{-192,134},{-124,134}},
                                                              color={0,0,127}));
  connect(dualTemperatureSetpoint.reach_TSetTarPreHea,
    selectSmallestTemperatureDifferencePreHea.uIgnFla) annotation (Line(points=
          {{200.714,-4.01905},{200.714,-4},{214,-4},{214,114},{-162,114},{-162,
          128.2},{-124,128.2}}, color={255,0,255}));
  connect(TCur, selectLargestTemperatureDifferencePreCoo.TCur) annotation (Line(
        points={{-280,58},{-150,58},{-150,-188},{-122,-188}},    color={0,0,127}));
  connect(TSetCurCoo, selectLargestTemperatureDifferencePreCoo.TSetCur)
    annotation (Line(points={{-280,10},{-232,10},{-232,-280},{-214,-280},{-214,
          -194},{-122,-194}},                 color={0,0,127}));
  connect(TCur, selectLargestTemperatureDifferenceSheCoo.TCur) annotation (Line(
        points={{-280,58},{-150,58},{-150,-238},{-120,-238}},      color={0,0,127}));
  connect(TSetCurCoo, selectLargestTemperatureDifferenceSheCoo.TSetCur)
    annotation (Line(points={{-280,10},{-232,10},{-232,-280},{-190,-280},{-190,
          -244},{-120,-244}},
                           color={0,0,127}));
  connect(TCur, selectLargestTemperatureDifferenceRebCoo.TCur) annotation (Line(
        points={{-280,58},{-150,58},{-150,-274},{-120,-274}},      color={0,0,127}));
  connect(TSetCurCoo, selectLargestTemperatureDifferenceRebCoo.TSetCur)
    annotation (Line(points={{-280,10},{-232,10},{-232,-280},{-120,-280}},
        color={0,0,127}));
  connect(dualTemperatureSetpoint.reach_TSetTarPreCoo,
    selectLargestTemperatureDifferencePreCoo.uIgnFla) annotation (Line(points={
          {200.714,-79.3714},{200.714,-80},{228,-80},{228,-216},{-136,-216},{
          -136,-199.8},{-122,-199.8}}, color={255,0,255}));
  connect(dualTemperatureSetpoint.reach_TSetTarSheCoo,
    selectLargestTemperatureDifferenceSheCoo.uIgnFla) annotation (Line(points={
          {200.714,-96.5714},{218,-96.5714},{218,-266},{-128,-266},{-128,-249.8},
          {-120,-249.8}}, color={255,0,255}));
  connect(dualTemperatureSetpoint.reach_TSetNomCoo,
    selectLargestTemperatureDifferenceRebCoo.uIgnFla) annotation (Line(points={
          {200.714,-135.067},{200.714,-300},{-128,-300},{-128,-285.8},{-120,
          -285.8}}, color={255,0,255}));
  connect(TSetTarPreHea, dualTemperatureSetpoint.TSetTarPreHea) annotation (
      Line(points={{-280,-42},{-172,-42},{-172,-74},{62.1571,-74},{62.1571,
          -74.4571}}, color={0,0,127}));
  connect(TSetTarSheHea, dualTemperatureSetpoint.TSetTarSheHea) annotation (
      Line(points={{-280,-90},{62.1571,-90},{62.1571,-89.2}}, color={0,0,127}));
  connect(TSetNomHea, dualTemperatureSetpoint.TSetNomHea) annotation (Line(
        points={{-280,-126},{-196,-126},{-196,-104},{62.1571,-104},{62.1571,
          -103.124}}, color={0,0,127}));
  connect(TSetCurHea, dualTemperatureSetpoint.TSetCurHea) annotation (Line(
        points={{-280,114},{-166,114},{-166,-32},{58,-32},{58,-35.9619},{
          62.1571,-35.9619}}, color={0,0,127}));
  connect(TCur, dualTemperatureSetpoint.TCur) annotation (Line(points={{-280,58},
          {-200,58},{-200,-48.2476},{62.1571,-48.2476}}, color={0,0,127}));
  connect(TSetTarSheCoo, dualTemperatureSetpoint.TSetTarSheCoo) annotation (
      Line(points={{-280,-228},{-176,-228},{-176,-158},{-28,-158},{-28,-134.248},
          {62.1571,-134.248}}, color={0,0,127}));
  connect(TSetNomCoo, dualTemperatureSetpoint.TSetNomCoo) annotation (Line(
        points={{-280,-272},{-240,-272},{-240,-312},{28,-312},{28,-148},{
          62.1571,-148},{62.1571,-148.171}}, color={0,0,127}));
  connect(TSetCurCoo, dualTemperatureSetpoint.TSetCurCoo) annotation (Line(
        points={{-280,10},{-232,10},{-232,-280},{-214,-280},{-214,-58},{62.1571,
          -58},{62.1571,-59.7143}}, color={0,0,127}));
  connect(intScaRep.y, singleTemperatureSetpointModeSelectionBoolHea.uMod)
    annotation (Line(points={{-218,158},{-208,158},{-208,106},{-39.7391,106},{
          -39.7391,105.333}},                                       color={255,127,
          0}));
  connect(selectSmallestTemperatureDifferencePreHea.yAcnFla,
    singleTemperatureSetpointModeSelectionBoolHea.uPre) annotation (Line(points={{-100,
          134},{-56,134},{-56,101.833},{-39.7391,101.833}},
                                                        color={255,0,255}));
  connect(selectSmallestTemperatureDifferenceRebHea.yAcnFla,
    singleTemperatureSetpointModeSelectionBoolHea.uReb) annotation (Line(points={{-100,46},
          {-66,46},{-66,91.5},{-39.7391,91.5}},        color={255,0,255}));
  connect(singleTemperatureSetpointModeSelectionBoolHea.y,
    dualTemperatureSetpoint.have_priHea) annotation (Line(points={{-16.2609,98},
          {61.2857,98},{61.2857,4.17143}}, color={255,0,255}));
  connect(selectLargestTemperatureDifferencePreCoo.yAcnFla,
    singleTemperatureSetpointModeSelectionBoolCoo.uPre) annotation (Line(points={{-98,
          -194},{-66,-194},{-66,-228.167},{-33.7391,-228.167}},
                                color={255,0,255}));
  connect(selectLargestTemperatureDifferenceSheCoo.yAcnFla,
    singleTemperatureSetpointModeSelectionBoolCoo.uShe) annotation (Line(points={{-96,
          -244},{-76,-244},{-76,-234},{-33.7391,-234},{-33.7391,-234.667}},
                                color={255,0,255}));
  connect(selectLargestTemperatureDifferenceRebCoo.yAcnFla,
    singleTemperatureSetpointModeSelectionBoolCoo.uReb) annotation (Line(points={{-96,
          -280},{-68,-280},{-68,-238},{-33.7391,-238},{-33.7391,-238.5}},
                                                    color={255,0,255}));
  connect(intScaRep.y, singleTemperatureSetpointModeSelectionBoolCoo.uMod)
    annotation (Line(points={{-218,158},{-208,158},{-208,-224},{-33.7391,-224},
          {-33.7391,-224.667}}, color={255,127,0}));
  connect(singleTemperatureSetpointModeSelectionBoolCoo.y,
    dualTemperatureSetpoint.have_priCoo) annotation (Line(points={{-10.2609,
          -232},{-4,-232},{-4,-8.93333},{61.2857,-8.93333}}, color={255,0,255}));
  connect(dualTemperatureSetpoint.TSetComHea, TSetComHea) annotation (Line(
        points={{200.714,-35.1429},{252,-35.1429},{252,10},{282,10}}, color={0,
          0,127}));
  connect(dualTemperatureSetpoint.TSetComCoo, TSetComCoo) annotation (Line(
        points={{200.714,-115.41},{248,-115.41},{248,-186},{280,-186}}, color={
          0,0,127}));
  connect(TSetTarPreCoo, dualTemperatureSetpoint.TSetTarPreCoo) annotation (
      Line(points={{-280,-184},{-186,-184},{-186,-118},{62.1571,-118},{62.1571,
          -117.867}}, color={0,0,127}));
  connect(selectSmallestTemperatureDifferenceSheHea.yAcnFla,
    singleTemperatureSetpointModeSelectionBoolHea.uShe) annotation (Line(points
        ={{-100,88},{-82,88},{-82,95.3333},{-39.7391,95.3333}}, color={255,0,
          255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-260,
            -320},{260,180}},
        grid={2,2})),     Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-260,-320},{260,180}},
        grid={2,2})),
    Documentation(info="<html>
<p><span style=\"font-size: 9pt;\">This is a utility block that controls both the cooling setpoint and the heating setpoint for multiple building zones, based on the current demand flexibility mode (uMod): -1 = pre-cool/pre-heat mode, 1 = load shed mode, 2 = load rebound mode, and 0 = baseline mode. </span></p>
<p>In this block, out of the many building zones, we need to decide which zone has the priority to perform the zone setpoint change via the variables have_priHea and have_priCoo. The zone temperature difference is defined as the current zone temperature minus the current zone temperature heating or cooling setpoint. </p>
<p>For the heating mode, for the one zone with the **smallest** zone temperature difference, this zone will have its have_priHea variable set to true, and the other zones will have their have_priHea variable set to false. This applies for the pre-heat mode, load shed mode and load rebound mode. </p>
<p>For the cooling mode, for the one zone with the **largest** zone temperature difference, this zone will have its have_priCoo variable set to true, and the other zones will have their have_priCoo variable set to false. This applies for the pre-cool mode, load shed mode and load rebound mode. </p>
<p>The heating setpoint and the cooling setpoint are controlled independently. This means that one zone might have the priority have_priHea =true, while another zone might have the priority have_priCoo =true at the same time.</p>
</html>"));
end MultipleZones;
