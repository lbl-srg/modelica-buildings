within Buildings.Templates.AHUs.Controls;
block Guideline36 "Guideline 36 VAV single duct controller"
  extends Buildings.Templates.Interfaces.ControllerAHU;

  parameter Boolean have_difEco
    "Set to true"
    annotation(Evaluate=true, Dialog(tab="economizer"));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller conAHU
    "AHU controller"
    annotation (Placement(transformation(extent={{-40,8},{40,152}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Zone
    zonOutAirSet[nZon]
    "Zone level calculation of the minimum outdoor airflow set point"
    annotation (Placement(transformation(extent={{150,-60},{130,-40}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.SumZone
    zonToSys(final numZon=nZon)
    "Sum up zone calculation output"
    annotation (Placement(transformation(extent={{40,-60},{20,-40}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.ZoneStatus zonSta[nZon]
    "Evaluate zone temperature status"
    annotation (Placement(transformation(extent={{0,-184},{-20,-156}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.GroupStatus zonGroSta(
    final numZon=nZon)
    "Evaluate zone group status from each zone status"
    annotation (Placement(transformation(extent={{-54,-188},{-74,-148}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode
    opeModSel(final numZon=nZon)
    "Operation mode selection"
    annotation (Placement(transformation(extent={{-80,-136},{-60,-104}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME1(k=24 + 273.15)
    "Where is the use of the average zone set point described?"
    annotation (Placement(transformation(extent={{260,170},{240,190}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant FIXME2
                                                           [nZon](k=fill(1,
        nZon)) "nOcc shall be Boolean, not integer"
    annotation (Placement(transformation(extent={{260,140},{240,160}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator TSupSet(
    final nout=nZon)
    "Pass signal to terminal unit bus"
    annotation (Placement(transformation(extent={{20,-110},{40,-90}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerReplicator uOpeMod(
    final nout=nZon)
    "Pass signal to terminal unit bus"
    annotation (Placement(transformation(extent={{20,-140},{40,-120}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator VDesUncOutAir_flow(
    final nout=nZon)
    "Pass signal to terminal unit bus"
    annotation (Placement(transformation(extent={{130,78},{150,98}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator yReqOutAir(
    final nout=nZon)
    "Pass signal to terminal unit bus"
    annotation (Placement(transformation(extent={{130,42},{150,62}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum reqZonTemRes(
    final k=fill(1, nZon),
    final nin=nZon)
    "Sum up signals"
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum reqZonPreRes(
    final k=fill(1, nZon),
    final nin=nZon)
    "Sum up signals"
    annotation (Placement(transformation(extent={{-140,8},{-120,28}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME3[nZon](
    k=fill(1800, nZon))
    "Optimal start using global outdoor air temperature not associated with any AHU"
    annotation (Placement(transformation(extent={{260,-170},{240,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME4(k=24 + 273.15)
  "To be determined determined by the control sequence based on energy standard, climate
zone, and economizer high-limit-control device type"
    annotation (Placement(transformation(extent={{260,100},{240,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME5(k=1)
    "Various economizer configurations not handled: yDamRel (or exhaust), yDamOutMin "
    annotation (Placement(transformation(extent={{260,50},{240,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME6(k=1)
    "Various fan configurations not handled: yFanRet (or relief)"
    annotation (Placement(transformation(extent={{260,14},{240,34}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant    FIXME7(k=true)
    "Various fan configurations not handled: yFanRet (or relief)"
    annotation (Placement(transformation(extent={{298,10},{278,30}})));

protected
    BaseClasses.Connectors.SubBusOutput busOutAHU
    "AHU output points"
    annotation (
      Placement(
        transformation(extent={{70,40},{110,80}}), iconTransformation(extent={{-10,24},
            {10,44}})));
  BaseClasses.Connectors.SubBusSoftware busSofAHU
    "AHU software points"
    annotation (
      Placement(
        transformation(extent={{70,0},{110,40}}),
        iconTransformation(extent={{-10,44}, {10,64}})));
  BaseClasses.Connectors.SubBusSoftware busSofTer[nZon]
    "Terminal unit software points"
    annotation (
      Placement(
        transformation(extent={{70,-140},{110,-100}}), iconTransformation(
          extent={{-10,64},{10,84}})));
equation

  connect(zonOutAirSet.yDesZonPeaOcc, zonToSys.uDesZonPeaOcc) annotation (Line(
        points={{128,-41},{60,-41},{60,-42},{42,-42}},    color={0,0,127}));
  connect(zonOutAirSet.VDesPopBreZon_flow, zonToSys.VDesPopBreZon_flow)
    annotation (Line(points={{128,-44},{42,-44}},  color={0,0,127}));
  connect(zonOutAirSet.VDesAreBreZon_flow, zonToSys.VDesAreBreZon_flow)
    annotation (Line(points={{128,-47},{60,-47},{60,-46},{42,-46}},    color={0,
          0,127}));
  connect(zonOutAirSet.yDesPriOutAirFra, zonToSys.uDesPriOutAirFra) annotation (
     Line(points={{128,-50},{68,-50},{68,-52},{42,-52}},    color={0,0,127}));
  connect(zonOutAirSet.VUncOutAir_flow, zonToSys.VUncOutAir_flow) annotation (
      Line(points={{128,-53},{50,-53},{50,-54},{42,-54}},    color={0,0,127}));
  connect(zonOutAirSet.yPriOutAirFra, zonToSys.uPriOutAirFra)
    annotation (Line(points={{128,-56},{42,-56}},  color={0,0,127}));
  connect(zonOutAirSet.VPriAir_flow, zonToSys.VPriAir_flow) annotation (Line(
        points={{128,-59},{50,-59},{50,-58},{42,-58}},    color={0,0,127}));
  connect(conAHU.yAveOutAirFraPlu, zonToSys.yAveOutAirFraPlu) annotation (Line(
        points={{44,92},{120,92},{120,-48},{42,-48}},  color={0,0,127}));
  connect(zonToSys.ySumDesZonPop, conAHU.sumDesZonPop) annotation (Line(points={{18,-41},
          {-52,-41},{-52,118},{-44,118}},                             color={0,
          0,127}));
  connect(zonToSys.VSumDesPopBreZon_flow, conAHU.VSumDesPopBreZon_flow)
    annotation (Line(points={{18,-44},{-56,-44},{-56,112},{-44,112}},
                                                                    color={0,0,
          127}));
  connect(zonToSys.VSumDesAreBreZon_flow, conAHU.VSumDesAreBreZon_flow)
    annotation (Line(points={{18,-47},{-60,-47},{-60,106},{-44,106}},
                color={0,0,127}));
  connect(zonToSys.yDesSysVenEff, conAHU.uDesSysVenEff) annotation (Line(points={{18,-50},
          {-64,-50},{-64,100},{-44,100}},                          color={0,0,
          127}));
  connect(zonToSys.VSumUncOutAir_flow, conAHU.VSumUncOutAir_flow) annotation (
      Line(points={{18,-53},{-68,-53},{-68,94},{-44,94}},
        color={0,0,127}));
  connect(zonToSys.VSumSysPriAir_flow, conAHU.VSumSysPriAir_flow) annotation (
      Line(points={{18,-59},{-76,-59},{-76,88},{-44,88}},
        color={0,0,127}));
  connect(zonToSys.uOutAirFra_max, conAHU.uOutAirFra_max) annotation (Line(
        points={{18,-56},{-72,-56},{-72,82},{-44,82}},                   color=
          {0,0,127}));
  connect(busAHU.inp.TSup, conAHU.TSup) annotation (Line(
      points={{-200.1,0.1},{-180,0.1},{-180,80},{-100,80},{-100,70},{-44,70}},
      color={255,204,51},
      thickness=0.5));
  connect(busAHU.inp.TOut, conAHU.TOut) annotation (Line(
      points={{-200.1,0.1},{-180,0.1},{-180,136},{-44,136}},
      color={255,204,51},
      thickness=0.5));
  connect(busAHU.inp.pSup_rel, conAHU.ducStaPre) annotation (Line(
      points={{-200.1,0.1},{-180,0.1},{-180,130},{-44,130}},
      color={255,204,51},
      thickness=0.5));
  connect(busAHU.inp.VOut_flow, conAHU.VOut_flow) annotation (Line(
      points={{-200.1,0.1},{-180,0.1},{-180,46},{-44,46}},
      color={255,204,51},
      thickness=0.5));
  connect(busAHU.inp.TMix, conAHU.TMix) annotation (Line(
      points={{-200.1,0.1},{-180,0.1},{-180,38},{-44,38}},
      color={255,204,51},
      thickness=0.5));
  connect(zonSta.yCooTim,zonGroSta.uCooTim) annotation (Line(points={{-22,-157},
          {-52,-157}},                       color={0,0,127}));
  connect(zonSta.yWarTim,zonGroSta.uWarTim) annotation (Line(points={{-22,-159},
          {-52,-159}},                       color={0,0,127}));
  connect(zonSta.yOccHeaHig,zonGroSta.uOccHeaHig) annotation (Line(points={{-22,
          -164},{-40,-164},{-40,-163},{-52,-163}},color={255,0,255}));
  connect(zonSta.yHigOccCoo,zonGroSta. uHigOccCoo)
    annotation (Line(points={{-22,-169},{-40,-169},{-40,-165},{-52,-165}},
                                                     color={255,0,255}));
  connect(zonSta.THeaSetOff,zonGroSta.THeaSetOff) annotation (Line(points={{-22,
          -172},{-46,-172},{-46,-171},{-52,-171}},color={0,0,127}));
  connect(zonSta.yUnoHeaHig,zonGroSta. uUnoHeaHig) annotation (Line(points={{-22,
          -174},{-42,-174},{-42,-169},{-52,-169}},color={255,0,255}));
  connect(zonSta.yEndSetBac,zonGroSta. uEndSetBac) annotation (Line(points={{-22,
          -176},{-50,-176},{-50,-173},{-52,-173}},color={255,0,255}));
  connect(zonSta.TCooSetOff,zonGroSta. TCooSetOff) annotation (Line(points={{-22,
          -179},{-52,-179}},                      color={0,0,127}));
  connect(zonSta.yHigUnoCoo,zonGroSta. uHigUnoCoo)
    annotation (Line(points={{-22,-181},{-38,-181},{-38,-177},{-52,-177}},
                                                     color={255,0,255}));
  connect(zonSta.yEndSetUp,zonGroSta. uEndSetUp) annotation (Line(points={{-22,-183},
          {-40,-183},{-40,-181},{-52,-181}},      color={255,0,255}));
  connect(zonGroSta.uGroOcc,opeModSel.uOcc) annotation (Line(points={{-76,-149},
          {-86,-149},{-86,-106},{-82,-106}}, color={255,0,255}));
  connect(zonGroSta.nexOcc,opeModSel.tNexOcc) annotation (Line(points={{-76,-151},
          {-102,-151},{-102,-108},{-82,-108}},    color={0,0,127}));
  connect(zonGroSta.yCooTim,opeModSel.maxCooDowTim) annotation (Line(points={{-76,
          -155},{-112,-155},{-112,-110},{-82,-110}},   color={0,0,127}));
  connect(zonGroSta.yWarTim,opeModSel.maxWarUpTim) annotation (Line(points={{-76,
          -157},{-108,-157},{-108,-114},{-82,-114}},
                                                  color={0,0,127}));
  connect(zonGroSta.yOccHeaHig,opeModSel.uOccHeaHig) annotation (Line(points={{-76,
          -161},{-102,-161},{-102,-116},{-82,-116}},    color={255,0,255}));
  connect(zonGroSta.yHigOccCoo,opeModSel.uHigOccCoo) annotation (Line(points={{-76,
          -163},{-102,-163},{-102,-112},{-82,-112}},    color={255,0,255}));
  connect(zonGroSta.yColZon,opeModSel.totColZon) annotation (Line(points={{-76,
          -166},{-102,-166},{-102,-120},{-82,-120}},
                                                  color={255,127,0}));
  connect(zonGroSta.ySetBac,opeModSel.uSetBac) annotation (Line(points={{-76,-168},
          {-100,-168},{-100,-122},{-82,-122}},    color={255,0,255}));
  connect(zonGroSta.yEndSetBac,opeModSel.uEndSetBac) annotation (Line(points={{-76,
          -170},{-98,-170},{-98,-124},{-82,-124}},      color={255,0,255}));
  connect(zonGroSta.TZonMax,opeModSel.TZonMax) annotation (Line(points={{-76,-181},
          {-96,-181},{-96,-126},{-82,-126}},      color={0,0,127}));
  connect(zonGroSta.TZonMin,opeModSel.TZonMin) annotation (Line(points={{-76,-183},
          {-94,-183},{-94,-128},{-82,-128}},      color={0,0,127}));
  connect(zonGroSta.yHotZon,opeModSel. totHotZon) annotation (Line(points={{-76,
          -173},{-90,-173},{-90,-130},{-82,-130}},color={255,127,0}));
  connect(zonGroSta.ySetUp,opeModSel. uSetUp) annotation (Line(points={{-76,-175},
          {-90,-175},{-90,-132},{-82,-132}},      color={255,0,255}));
  connect(zonGroSta.yEndSetUp,opeModSel. uEndSetUp) annotation (Line(points={{-76,
          -177},{-88,-177},{-88,-134},{-82,-134}},color={255,0,255}));
  connect(zonGroSta.yOpeWin,opeModSel. uOpeWin) annotation (Line(points={{-76,-187},
          {-104,-187},{-104,-118},{-82,-118}},
                                             color={255,127,0}));
  connect(opeModSel.yOpeMod, conAHU.uOpeMod) annotation (Line(points={{-58,-120},
          {-48,-120},{-48,30},{-44,30}}, color={255,127,0}));
  connect(FIXME1.y, conAHU.TZonHeaSet) annotation (Line(points={{238,180},{-60,180},
          {-60,148},{-44,148}},      color={0,0,127}));
  connect(FIXME1.y, conAHU.TZonCooSet) annotation (Line(points={{238,180},{-60,180},
          {-60,142},{-44,142}},      color={0,0,127}));
  connect(FIXME2.y, zonOutAirSet.nOcc) annotation (Line(points={{238,150},{166,
          150},{166,-41},{152,-41}}, color={255,127,0}));
  connect(opeModSel.yOpeMod, uOpeMod.u) annotation (Line(points={{-58,-120},{
          -48,-120},{-48,-130},{18,-130}}, color={255,127,0}));
  connect(conAHU.ySupFan, busOutAHU.yFanSup)
    annotation (Line(points={{44,140},{90,140},{90,60}}, color={255,0,255}));
  connect(conAHU.ySupFanSpe, busOutAHU.ySpeFanSup) annotation (Line(points={{44,
          128},{86,128},{86,60},{90,60}}, color={0,0,127}));
  connect(conAHU.TSupSet, busSofAHU.TSupSet) annotation (Line(points={{44,116},
          {76,116},{76,20},{90,20}}, color={0,0,127}));
  connect(conAHU.VDesUncOutAir_flow, VDesUncOutAir_flow.u) annotation (Line(
        points={{44,104},{86,104},{86,88},{128,88}}, color={0,0,127}));
  connect(VDesUncOutAir_flow.y, zonOutAirSet.VUncOut_flow_nominal) annotation (
      Line(points={{152,88},{184,88},{184,-59},{152,-59}}, color={0,0,127}));
  connect(conAHU.yReqOutAir, yReqOutAir.u) annotation (Line(points={{44,68},{86,
          68},{86,52},{128,52}}, color={255,0,255}));
  connect(yReqOutAir.y, zonOutAirSet.uReqOutAir) annotation (Line(points={{152,52},
          {180,52},{180,-47},{152,-47}},     color={255,0,255}));
  connect(conAHU.yHea, busOutAHU.yCoiHea) annotation (Line(points={{44,56},{60,
          56},{60,60},{90,60}}, color={0,0,127}));
  connect(conAHU.yCoo, busOutAHU.yCoiCoo) annotation (Line(points={{44,44},{64,
          44},{64,56},{90,56},{90,60}}, color={0,0,127}));
  connect(conAHU.yRetDamPos, busOutAHU.yDamRet) annotation (Line(points={{44,32},
          {68,32},{68,50},{90,50},{90,60}}, color={0,0,127}));
  connect(conAHU.yOutDamPos, busOutAHU.yDamOut) annotation (Line(points={{44,20},
          {72,20},{72,46},{94,46},{94,60},{90,60}}, color={0,0,127}));
  connect(busSofAHU, busAHU.sof) annotation (Line(
      points={{90,20},{100,20},{100,-20},{-180,-20},{-180,0.1},{-200.1,0.1}},
      color={255,204,51},
      thickness=0.5));
  connect(busOutAHU, busAHU.out) annotation (Line(
      points={{90,60},{100,60},{100,-20},{-180,-20},{-180,0.1},{-200.1,0.1}},
      color={255,204,51},
      thickness=0.5));
  connect(busAHU.sof.TSupSet, TSupSet.u) annotation (Line(
      points={{-200.1,0.1},{-200.1,0},{-180,0},{-180,-100},{18,-100}},
      color={255,204,51},
      thickness=0.5));
  connect(TSupSet.y, busSofTer.TSupSet) annotation (Line(points={{42,-100},{80,-100},
          {80,-120},{90,-120}},       color={0,0,127}));
  connect(uOpeMod.y, busSofTer.uOpeMod) annotation (Line(points={{42,-130},{80,
          -130},{80,-122},{90,-122},{90,-120}}, color={255,127,0}));
  connect(busSofTer, busTer.sof) annotation (Line(
      points={{90,-120},{200,-120},{200,0.1},{220.1,0.1}},
      color={255,204,51},
      thickness=0.5));
  connect(reqZonTemRes.y, conAHU.uZonTemResReq) annotation (Line(points={{-118,60},
          {-108,60},{-108,24},{-44,24}},     color={255,127,0}));
  connect(reqZonPreRes.y, conAHU.uZonPreResReq)
    annotation (Line(points={{-118,18},{-44,18}},          color={255,127,0}));
  connect(busTer.sof.yReqZonPreRes, reqZonPreRes.u) annotation (Line(
      points={{220.1,0.1},{22,0.1},{22,0},{-160,0},{-160,18},{-142,18}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.sof.yReqZonTemRes, reqZonTemRes.u) annotation (Line(
      points={{220.1,0.1},{-160,0.1},{-160,60},{-142,60}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.inp.uWin, zonSta.uWin) annotation (Line(
      points={{220.1,0.1},{220.1,0},{200,0},{200,-174},{2,-174}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.inp.TZon, zonSta.TZon) annotation (Line(
      points={{220.1,0.1},{200,0.1},{200,-178},{2,-178}},
      color={255,204,51},
      thickness=0.5));
  connect(FIXME3.y, zonSta.cooDowTim) annotation (Line(points={{238,-160},{120,-160},
          {120,-162},{2,-162}}, color={0,0,127}));
  connect(FIXME3.y, zonSta.warUpTim) annotation (Line(points={{238,-160},{120,-160},
          {120,-166},{2,-166}}, color={0,0,127}));
  connect(busTer.inp.TZon, zonGroSta.TZon) annotation (Line(
      points={{220.1,0.1},{220.1,0},{200,0},{200,-185},{-52,-185}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.inp.uWin, zonGroSta.uWin) annotation (Line(
      points={{220.1,0.1},{84,0.1},{84,-187},{-52,-187}},
      color={255,204,51},
      thickness=0.5));
  connect(busSofTer.uOveZon, zonGroSta.zonOcc) annotation (Line(
      points={{90,-120},{90,-149},{-52,-149}},
      color={255,204,51},
      thickness=0.5));
  connect(busSofTer.uOccSch, zonGroSta.uOcc) annotation (Line(
      points={{90,-120},{90,-151},{-52,-151}},
      color={255,204,51},
      thickness=0.5));
  connect(busSofTer.tNexOcc, zonGroSta.tNexOcc) annotation (Line(
      points={{90,-120},{90,-153},{-52,-153}},
      color={255,204,51},
      thickness=0.5));

  connect(FIXME4.y, conAHU.TOutCut) annotation (Line(points={{238,110},{-80,110},
          {-80,64},{-44,64}}, color={0,0,127}));
  connect(busAHU.inp.hOut, conAHU.hOut) annotation (Line(
      points={{-200.1,0.1},{-180,0.1},{-180,80},{-100,80},{-100,58},{-44,58}},
      color={255,204,51},
      thickness=0.5));
  connect(FIXME4.y, conAHU.hOutCut) annotation (Line(points={{238,110},{-80,110},
          {-80,52},{-44,52}}, color={0,0,127}));
  connect(busTer.inp.uWin, zonOutAirSet.uWin) annotation (Line(
      points={{220.1,0.1},{200,0.1},{200,-44},{152,-44}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.inp.TZon, zonOutAirSet.TZon) annotation (Line(
      points={{220.1,0.1},{200,0.1},{200,-50},{152,-50}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.inp.TDis, zonOutAirSet.TDis) annotation (Line(
      points={{220.1,0.1},{218,0.1},{218,0},{200,0},{200,-53},{152,-53}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.inp.VDis_flow, zonOutAirSet.VDis_flow) annotation (Line(
      points={{220.1,0.1},{200,0.1},{200,-56},{152,-56}},
      color={255,204,51},
      thickness=0.5));
  connect(FIXME5.y, busOutAHU.yDamRel)
    annotation (Line(points={{238,60},{90,60}}, color={0,0,127}));
  connect(FIXME5.y, busOutAHU.yDamOutMin) annotation (Line(points={{238,60},{166,
          60},{166,60},{90,60}}, color={0,0,127}));
  connect(FIXME7.y, busOutAHU.yFanRet) annotation (Line(points={{276,20},{106,20},
          {106,60},{90,60}}, color={255,0,255}));
  connect(FIXME6.y, busOutAHU.ySpeFanRet) annotation (Line(points={{238,24},{110,
          24},{110,60},{90,60}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-296,-46},{-90,-100}},
          lineColor={238,46,47},
          textString="Todo: subset indices for different Boolean values (such as have_occSen)")}),
    Documentation(info="<html>
<p>
WARNING: Do not use. Not configured and connected yet!
</p>
</html>"));
end Guideline36;
