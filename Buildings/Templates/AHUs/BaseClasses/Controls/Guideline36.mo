within Buildings.Templates.AHUs.BaseClasses.Controls;
block Guideline36 "Guideline 36 VAV single duct controller"
  extends Interfaces.Controller;
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller conAHU
    annotation (Placement(transformation(extent={{-42,-8},{38,136}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Zone
    zonOutAirSet[nZon]
    "Zone level calculation of the minimum outdoor airflow set point"
    annotation (Placement(transformation(extent={{160,-80},{140,-60}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.SumZone
    zonToSys(numZon=nZon) "Sum up zone calculation output"
    annotation (Placement(transformation(extent={{120,-80},{100,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant FIXME[nZon](k=true)
    "uReqOutAir does not match G36 I/O"
    annotation (Placement(transformation(extent={{-10,170},{10,190}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.ZoneStatus zonSta[numZon]
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
equation
  for i in 1:nZon loop
    if zonOutAirSet[i].have_occSen then
      connect(terBus[i].nOcc, zonOutAirSet[i].nOcc);
    end if;
  end for;
  connect(terBus, zonOutAirSet.nOcc) annotation (Line(
      points={{220,0},{200,0},{200,-61},{162,-61}},
      color={255,204,51},
      thickness=0.5));
  connect(FIXME.y, zonOutAirSet.uReqOutAir) annotation (Line(points={{12,180},{
          180,180},{180,-67},{162,-67}}, color={255,0,255}));
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
  connect(terBus, zonOutAirSet.VUncOut_flow_nominal) annotation (Line(
      points={{220,0},{200,0},{200,-79},{162,-79}},
      color={255,204,51},
      thickness=0.5));
  connect(zonOutAirSet.yDesZonPeaOcc, zonToSys.uDesZonPeaOcc) annotation (Line(
        points={{138,-61},{140,-61},{140,-62},{122,-62}}, color={0,0,127}));
  connect(zonOutAirSet.VDesPopBreZon_flow, zonToSys.VDesPopBreZon_flow)
    annotation (Line(points={{138,-64},{122,-64}}, color={0,0,127}));
  connect(zonOutAirSet.VDesAreBreZon_flow, zonToSys.VDesAreBreZon_flow)
    annotation (Line(points={{138,-67},{140,-67},{140,-66},{122,-66}}, color={0,
          0,127}));
  connect(zonOutAirSet.yDesPriOutAirFra, zonToSys.uDesPriOutAirFra) annotation
    (Line(points={{138,-70},{130,-70},{130,-72},{122,-72}}, color={0,0,127}));
  connect(zonOutAirSet.VUncOutAir_flow, zonToSys.VUncOutAir_flow) annotation (
      Line(points={{138,-73},{140,-73},{140,-74},{122,-74}}, color={0,0,127}));
  connect(zonOutAirSet.yPriOutAirFra, zonToSys.uPriOutAirFra)
    annotation (Line(points={{138,-76},{122,-76}}, color={0,0,127}));
  connect(zonOutAirSet.VPriAir_flow, zonToSys.VPriAir_flow) annotation (Line(
        points={{138,-79},{140,-79},{140,-78},{122,-78}}, color={0,0,127}));
  connect(conAHU.yAveOutAirFraPlu, zonToSys.yAveOutAirFraPlu) annotation (Line(
        points={{42,76},{126,76},{126,-68},{122,-68}}, color={0,0,127}));
  connect(zonToSys.ySumDesZonPop, conAHU.sumDesZonPop) annotation (Line(points=
          {{98,-61},{24,-61},{24,-62},{-52,-62},{-52,102},{-46,102}}, color={0,
          0,127}));
  connect(zonToSys.VSumDesPopBreZon_flow, conAHU.VSumDesPopBreZon_flow)
    annotation (Line(points={{98,-64},{-56,-64},{-56,96},{-46,96}}, color={0,0,
          127}));
  connect(zonToSys.VSumDesAreBreZon_flow, conAHU.VSumDesAreBreZon_flow)
    annotation (Line(points={{98,-67},{20,-67},{20,-68},{-60,-68},{-60,90},{-46,
          90}}, color={0,0,127}));
  connect(zonToSys.yDesSysVenEff, conAHU.uDesSysVenEff) annotation (Line(points
        ={{98,-70},{16,-70},{16,-72},{-64,-72},{-64,84},{-46,84}}, color={0,0,
          127}));
  connect(zonToSys.VSumUncOutAir_flow, conAHU.VSumUncOutAir_flow) annotation (
      Line(points={{98,-73},{14,-73},{14,-76},{-68,-76},{-68,78},{-46,78}},
        color={0,0,127}));
  connect(zonToSys.VSumSysPriAir_flow, conAHU.VSumSysPriAir_flow) annotation (
      Line(points={{98,-79},{16,-79},{16,-80},{-80,-80},{-80,72},{-46,72}},
        color={0,0,127}));
  connect(zonToSys.uOutAirFra_max, conAHU.uOutAirFra_max) annotation (Line(
        points={{98,-76},{16,-76},{16,-78},{-76,-78},{-76,66},{-46,66}}, color=
          {0,0,127}));
  connect(ahuBus.ahuI.TSup, conAHU.TSup) annotation (Line(
      points={{-200.1,0.1},{-100,0.1},{-100,54},{-46,54}},
      color={255,204,51},
      thickness=0.5));
  connect(ahuBus.ahuI.TOut, conAHU.TOut) annotation (Line(
      points={{-200.1,0.1},{-100,0.1},{-100,120},{-46,120}},
      color={255,204,51},
      thickness=0.5));
  connect(ahuBus.ahuI.pSup_rel, conAHU.ducStaPre) annotation (Line(
      points={{-200.1,0.1},{-100,0.1},{-100,114},{-46,114}},
      color={255,204,51},
      thickness=0.5));
  connect(ahuBus.ahuI.VOut, conAHU.VOut_flow) annotation (Line(
      points={{-200.1,0.1},{-100,0.1},{-100,30},{-46,30}},
      color={255,204,51},
      thickness=0.5));
  connect(ahuBus.ahuI.TMix, conAHU.TMix) annotation (Line(
      points={{-200.1,0.1},{-100,0.1},{-100,22},{-46,22}},
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
          {-48,-120},{-48,14},{-46,14}}, color={255,127,0}));
  connect(FIXME1.y, conAHU.TZonHeaSet) annotation (Line(points={{-98,180},{-80,
          180},{-80,132},{-46,132}}, color={0,0,127}));
  connect(FIXME1.y, conAHU.TZonCooSet) annotation (Line(points={{-98,180},{-80,
          180},{-80,126},{-46,126}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
WARNING: Do not use. Not configured and connected yet!
</p>
</html>"));
end Guideline36;
