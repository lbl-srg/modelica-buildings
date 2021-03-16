within Buildings.Templates.AHUs.Controls;
block Guideline36 "Guideline 36 VAV single duct controller"
  extends Buildings.Templates.Interfaces.ControllerAHU;
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller conAHU
    annotation (Placement(transformation(extent={{-40,8},{40,152}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Zone
    zonOutAirSet[nZon]
    "Zone level calculation of the minimum outdoor airflow set point"
    annotation (Placement(transformation(extent={{160,-80},{140,-60}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.SumZone
    zonToSys(numZon=nZon) "Sum up zone calculation output"
    annotation (Placement(transformation(extent={{100,-80},{80,-60}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.ZoneStatus zonSta[numZon](
      have_winSen=true)
    "Evaluate zone temperature status"
    annotation (Placement(transformation(extent={{-180,-160},{-160,-132}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.GroupStatus zonGroSta(final
      numZon=numZon) "Evaluate zone group status from each zone status"
    annotation (Placement(transformation(extent={{-138,-166},{-118,-126}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode
    opeModSel(final numZon=nZon) "Operation mode selection"
    annotation (Placement(transformation(extent={{-80,-136},{-60,-104}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME1(k=24 + 273.15)
    "Where is the use of the average zone set point described?"
    annotation (Placement(transformation(extent={{-120,170},{-100,190}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant FIXME2
                                                           [nZon](k=fill(1,
        nZon)) "nOcc shall be Boolean, not integer"
    annotation (Placement(transformation(extent={{80,150},{100,170}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator TSupSet(nout=nZon)
    "Pass signal to terminal unit bus"
    annotation (Placement(transformation(extent={{20,-110},{40,-90}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerReplicator uOpeMod(nout=nZon)
    "Pass signal to terminal unit bus"
    annotation (Placement(transformation(extent={{20,-140},{40,-120}})));
  BaseClasses.Connectors.SubBusOutput busOutAHU annotation (Placement(
        transformation(extent={{70,40},{110,80}}), iconTransformation(extent={{
            -272,-74},{-252,-54}})));
  BaseClasses.Connectors.SubBusSoftware busSofAHU annotation (Placement(
        transformation(extent={{70,0},{110,40}}), iconTransformation(extent={{
            -442,-84},{-422,-64}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator VDesUncOutAir_flow(nout=
        nZon) "Pass signal to terminal unit bus"
    annotation (Placement(transformation(extent={{130,78},{150,98}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator yReqOutAir(nout=nZon)
    "Pass signal to terminal unit bus"
    annotation (Placement(transformation(extent={{130,42},{150,62}})));
  BaseClasses.Connectors.SubBusSoftware busSofTer[nZon] annotation (Placement(
        transformation(extent={{70,-140},{110,-100}}), iconTransformation(
          extent={{-442,-84},{-422,-64}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum reqZonTemRes(k=fill(1, nZon))
    "Sum up signals"
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum reqZonPreRes(k=fill(1, nZon))
    "Sum up signals"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));
equation
  for i in 1:nZon loop
    if zonOutAirSet[i].have_occSen then
      connect(terBus[i].nOcc, zonOutAirSet[i].nOcc);
    end if;
  end for;
  connect(terBus, zonOutAirSet.uWin) annotation (Line(
      points={{220,0},{200,0},{200,-64},{162,-64}},
      color={255,204,51},
      thickness=0.5));
  connect(terBus, zonOutAirSet.TZon) annotation (Line(
      points={{220,0},{200,0},{200,-70},{162,-70}},
      color={255,204,51},
      thickness=0.5));
  connect(terBus, zonOutAirSet.TDis) annotation (Line(
      points={{220,0},{200,0},{200,-73},{162,-73}},
      color={255,204,51},
      thickness=0.5));
  connect(terBus, zonOutAirSet.VDis_flow) annotation (Line(
      points={{220,0},{200,0},{200,-76},{162,-76}},
      color={255,204,51},
      thickness=0.5));
  connect(zonOutAirSet.yDesZonPeaOcc, zonToSys.uDesZonPeaOcc) annotation (Line(
        points={{138,-61},{140,-61},{140,-62},{102,-62}}, color={0,0,127}));
  connect(zonOutAirSet.VDesPopBreZon_flow, zonToSys.VDesPopBreZon_flow)
    annotation (Line(points={{138,-64},{102,-64}}, color={0,0,127}));
  connect(zonOutAirSet.VDesAreBreZon_flow, zonToSys.VDesAreBreZon_flow)
    annotation (Line(points={{138,-67},{140,-67},{140,-66},{102,-66}}, color={0,
          0,127}));
  connect(zonOutAirSet.yDesPriOutAirFra, zonToSys.uDesPriOutAirFra) annotation (
     Line(points={{138,-70},{130,-70},{130,-72},{102,-72}}, color={0,0,127}));
  connect(zonOutAirSet.VUncOutAir_flow, zonToSys.VUncOutAir_flow) annotation (
      Line(points={{138,-73},{140,-73},{140,-74},{102,-74}}, color={0,0,127}));
  connect(zonOutAirSet.yPriOutAirFra, zonToSys.uPriOutAirFra)
    annotation (Line(points={{138,-76},{102,-76}}, color={0,0,127}));
  connect(zonOutAirSet.VPriAir_flow, zonToSys.VPriAir_flow) annotation (Line(
        points={{138,-79},{140,-79},{140,-78},{102,-78}}, color={0,0,127}));
  connect(conAHU.yAveOutAirFraPlu, zonToSys.yAveOutAirFraPlu) annotation (Line(
        points={{44,92},{120,92},{120,-68},{102,-68}}, color={0,0,127}));
  connect(zonToSys.ySumDesZonPop, conAHU.sumDesZonPop) annotation (Line(points={{78,-61},
          {24,-61},{24,-62},{-52,-62},{-52,118},{-44,118}},           color={0,
          0,127}));
  connect(zonToSys.VSumDesPopBreZon_flow, conAHU.VSumDesPopBreZon_flow)
    annotation (Line(points={{78,-64},{-56,-64},{-56,112},{-44,112}},
                                                                    color={0,0,
          127}));
  connect(zonToSys.VSumDesAreBreZon_flow, conAHU.VSumDesAreBreZon_flow)
    annotation (Line(points={{78,-67},{20,-67},{20,-68},{-60,-68},{-60,106},{
          -44,106}},
                color={0,0,127}));
  connect(zonToSys.yDesSysVenEff, conAHU.uDesSysVenEff) annotation (Line(points={{78,-70},
          {16,-70},{16,-72},{-64,-72},{-64,100},{-44,100}},        color={0,0,
          127}));
  connect(zonToSys.VSumUncOutAir_flow, conAHU.VSumUncOutAir_flow) annotation (
      Line(points={{78,-73},{14,-73},{14,-76},{-68,-76},{-68,94},{-44,94}},
        color={0,0,127}));
  connect(zonToSys.VSumSysPriAir_flow, conAHU.VSumSysPriAir_flow) annotation (
      Line(points={{78,-79},{16,-79},{16,-80},{-80,-80},{-80,88},{-44,88}},
        color={0,0,127}));
  connect(zonToSys.uOutAirFra_max, conAHU.uOutAirFra_max) annotation (Line(
        points={{78,-76},{16,-76},{16,-78},{-76,-78},{-76,82},{-44,82}}, color=
          {0,0,127}));
  connect(busAHU.ahuI.TSup, conAHU.TSup) annotation (Line(
      points={{-200,0},{-160,0},{-160,80},{-100,80},{-100,70},{-44,70}},
      color={255,204,51},
      thickness=0.5));
  connect(busAHU.ahuI.TOut, conAHU.TOut) annotation (Line(
      points={{-200,0},{-160,0},{-160,136},{-44,136}},
      color={255,204,51},
      thickness=0.5));
  connect(busAHU.ahuI.pSup_rel, conAHU.ducStaPre) annotation (Line(
      points={{-200,0},{-160,0},{-160,128},{-100,128},{-100,130},{-44,130}},
      color={255,204,51},
      thickness=0.5));
  connect(busAHU.ahuI.VOut, conAHU.VOut_flow) annotation (Line(
      points={{-200,0},{-160,0},{-160,44},{-100,44},{-100,46},{-44,46}},
      color={255,204,51},
      thickness=0.5));
  connect(busAHU.ahuI.TMix, conAHU.TMix) annotation (Line(
      points={{-200,0},{-160,0},{-160,36},{-100,36},{-100,38},{-44,38}},
      color={255,204,51},
      thickness=0.5));
  connect(zonSta.yCooTim,zonGroSta. uCooTim) annotation (Line(points={{-158,
          -133},{-148,-133},{-148,-134},{-140,-134},{-140,-135}},
                                             color={0,0,127}));
  connect(zonSta.yWarTim,zonGroSta. uWarTim) annotation (Line(points={{-158,
          -135},{-150,-135},{-150,-136},{-142,-136},{-142,-137},{-140,-137}},
                                             color={0,0,127}));
  connect(zonSta.yOccHeaHig,zonGroSta. uOccHeaHig) annotation (Line(points={{-158,
          -140},{-146,-140},{-146,-141},{-140,-141}},
                                                  color={255,0,255}));
  connect(zonSta.yHigOccCoo,zonGroSta. uHigOccCoo)
    annotation (Line(points={{-158,-145},{-152,-145},{-152,-143},{-140,-143}},
                                                     color={255,0,255}));
  connect(zonSta.THeaSetOff,zonGroSta. THeaSetOff) annotation (Line(points={{-158,
          -148},{-142,-148},{-142,-149},{-140,-149}},
                                                  color={0,0,127}));
  connect(zonSta.yUnoHeaHig,zonGroSta. uUnoHeaHig) annotation (Line(points={{-158,
          -150},{-148,-150},{-148,-147},{-140,-147}},
                                                  color={255,0,255}));
  connect(zonSta.yEndSetBac,zonGroSta. uEndSetBac) annotation (Line(points={{-158,
          -152},{-148,-152},{-148,-151},{-140,-151}},
                                                  color={255,0,255}));
  connect(zonSta.TCooSetOff,zonGroSta. TCooSetOff) annotation (Line(points={{-158,
          -155},{-150,-155},{-150,-157},{-140,-157}},
                                                  color={0,0,127}));
  connect(zonSta.yHigUnoCoo,zonGroSta. uHigUnoCoo)
    annotation (Line(points={{-158,-157},{-152,-157},{-152,-155},{-140,-155}},
                                                     color={255,0,255}));
  connect(zonSta.yEndSetUp,zonGroSta. uEndSetUp) annotation (Line(points={{-158,
          -159},{-140,-159}},                     color={255,0,255}));
  connect(zonGroSta.uGroOcc,opeModSel. uOcc) annotation (Line(points={{-116,
          -127},{-116,-106},{-82,-106}},     color={255,0,255}));
  connect(zonGroSta.nexOcc,opeModSel. tNexOcc) annotation (Line(points={{-116,
          -129},{-114,-129},{-114,-108},{-82,-108}},
                                                  color={0,0,127}));
  connect(zonGroSta.yCooTim,opeModSel. maxCooDowTim) annotation (Line(points={{-116,
          -133},{-112,-133},{-112,-110},{-82,-110}},   color={0,0,127}));
  connect(zonGroSta.yWarTim,opeModSel. maxWarUpTim) annotation (Line(points={{-116,
          -135},{-108,-135},{-108,-114},{-82,-114}},
                                                  color={0,0,127}));
  connect(zonGroSta.yOccHeaHig,opeModSel. uOccHeaHig) annotation (Line(points={{-116,
          -139},{-106,-139},{-106,-116},{-82,-116}},    color={255,0,255}));
  connect(zonGroSta.yHigOccCoo,opeModSel. uHigOccCoo) annotation (Line(points={{-116,
          -141},{-110,-141},{-110,-112},{-82,-112}},    color={255,0,255}));
  connect(zonGroSta.yColZon,opeModSel. totColZon) annotation (Line(points={{-116,
          -144},{-102,-144},{-102,-120},{-82,-120}},
                                                  color={255,127,0}));
  connect(zonGroSta.ySetBac,opeModSel. uSetBac) annotation (Line(points={{-116,
          -146},{-100,-146},{-100,-122},{-82,-122}},
                                                  color={255,0,255}));
  connect(zonGroSta.yEndSetBac,opeModSel. uEndSetBac) annotation (Line(points={{-116,
          -148},{-98,-148},{-98,-124},{-82,-124}},      color={255,0,255}));
  connect(zonGroSta.TZonMax,opeModSel. TZonMax) annotation (Line(points={{-116,
          -159},{-96,-159},{-96,-126},{-82,-126}},color={0,0,127}));
  connect(zonGroSta.TZonMin,opeModSel. TZonMin) annotation (Line(points={{-116,
          -161},{-94,-161},{-94,-128},{-82,-128}},color={0,0,127}));
  connect(zonGroSta.yHotZon,opeModSel. totHotZon) annotation (Line(points={{-116,
          -151},{-92,-151},{-92,-130},{-82,-130}},color={255,127,0}));
  connect(zonGroSta.ySetUp,opeModSel. uSetUp) annotation (Line(points={{-116,
          -153},{-90,-153},{-90,-132},{-82,-132}},color={255,0,255}));
  connect(zonGroSta.yEndSetUp,opeModSel. uEndSetUp) annotation (Line(points={{-116,
          -155},{-88,-155},{-88,-134},{-82,-134}},color={255,0,255}));
  connect(zonGroSta.yOpeWin,opeModSel. uOpeWin) annotation (Line(points={{-116,
          -165},{-104,-165},{-104,-118},{-82,-118}},
                                             color={255,127,0}));
  connect(opeModSel.yOpeMod, conAHU.uOpeMod) annotation (Line(points={{-58,-120},
          {-48,-120},{-48,30},{-44,30}}, color={255,127,0}));
  connect(FIXME1.y, conAHU.TZonHeaSet) annotation (Line(points={{-98,180},{-80,
          180},{-80,148},{-44,148}}, color={0,0,127}));
  connect(FIXME1.y, conAHU.TZonCooSet) annotation (Line(points={{-98,180},{-80,
          180},{-80,142},{-44,142}}, color={0,0,127}));
  connect(FIXME2.y, zonOutAirSet.nOcc) annotation (Line(points={{102,160},{166,
          160},{166,-61},{162,-61}}, color={255,127,0}));
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
      Line(points={{152,88},{184,88},{184,-79},{162,-79}}, color={0,0,127}));
  connect(conAHU.yReqOutAir, yReqOutAir.u) annotation (Line(points={{44,68},{86,
          68},{86,52},{128,52}}, color={255,0,255}));
  connect(yReqOutAir.y, zonOutAirSet.uReqOutAir) annotation (Line(points={{152,
          52},{180,52},{180,-67},{162,-67}}, color={255,0,255}));
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
      points={{90,60},{104,60},{104,-24},{-184,-24},{-184,0.1},{-200.1,0.1}},
      color={255,204,51},
      thickness=0.5));
  connect(busAHU.sof.TSupSet, TSupSet.u) annotation (Line(
      points={{-200.1,0.1},{-200,0},{-188,0},{-188,-100},{18,-100}},
      color={255,204,51},
      thickness=0.5));
  connect(TSupSet.y, busSofTer.TSupSet) annotation (Line(points={{42,-100},{80,
          -100},{80,-120},{90,-120}}, color={0,0,127}));
  connect(uOpeMod.y, busSofTer.uOpeMod) annotation (Line(points={{42,-130},{80,
          -130},{80,-122},{90,-122},{90,-120}}, color={255,127,0}));
  connect(busSofTer, busTer.sof) annotation (Line(
      points={{90,-120},{204,-120},{204,0.1},{220.1,0.1}},
      color={255,204,51},
      thickness=0.5));
  connect(reqZonTemRes.y, conAHU.uZonTemResReq) annotation (Line(points={{-118,
          60},{-108,60},{-108,24},{-44,24}}, color={255,127,0}));
  connect(reqZonPreRes.y, conAHU.uZonPreResReq)
    annotation (Line(points={{-118,20},{-44,20},{-44,18}}, color={255,127,0}));
  connect(busTer.sof.yZonPreResReq, reqZonPreRes.u) annotation (Line(
      points={{220.1,0.1},{32,0.1},{32,0},{-150,0},{-150,20},{-142,20}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.sof.yZonTemResReq, reqZonTemRes.u) annotation (Line(
      points={{220.1,0.1},{-150,0.1},{-150,60},{-142,60}},
      color={255,204,51},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
WARNING: Do not use. Not configured and connected yet!
</p>
</html>"));
end Guideline36;
