within Buildings.Templates.AirHandlersFans.Validation.UserProject;
block DummyControlPointsVAVBox
  extends Modelica.Blocks.Icons.Block;

  ZoneEquipment.Interfaces.Bus bus "Terminal unit control bus"
    annotation (
      Placement(transformation(
        extent={{-20,20},{20,-20}},
        rotation=90,
        origin={200,0}), iconTransformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={100,0})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant tNexOcc(final k=3600)
    "Time next occupancy"
    annotation (Placement(transformation(extent={{-140,130},{-120,150}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uOccSch(final k=true)
    "Scheduled occupancy"
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZon(final k=303.15)
    "Zone temperature"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VDis_flow(final k=1)
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant yReqZonTemRes(final k=1)
    "Request"
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant yReqZonPreRes(final k=1)
    "Request"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uOveZon(final k=true)
    "Zone occupancy override"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TDis(final k=303.15)
    "Discharge temperature"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uOcc(final k=true)
    "Zone occupancy sensor"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uWin(final k=true)
    "Zone window sensor"
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));
  Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Zone setMinOA(AFlo=10,
      minZonPriFlo=1)
    "Zone level calculation of the minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Controls.OBC.CDL.Integers.Sources.Constant FIXME_nOcc(k=1)
    "nOcc shall be Boolean, not integer"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.ZoneStatus sta
    "Evaluate zone temperature status"
    annotation (Placement(transformation(extent={{80,-60},{100,-32}})));
  Controls.OBC.CDL.Continuous.Sources.Constant           cooDowTim(final k=1800)
                  "Cooling down time"
    annotation (Placement(transformation(extent={{42,-50},{62,-30}})));
  Controls.OBC.CDL.Continuous.Sources.Constant           warUpTim(final k=1800)
                  "Warm-up time"
    annotation (Placement(transformation(extent={{42,-90},{62,-70}})));
equation
  connect(tNexOcc.y, bus.tNexOcc);
  connect(uOccSch.y, bus.uOccSch);
  connect(uOveZon.y, bus.uOveZon);
  connect(uOcc.y, bus.uOcc);
  connect(uWin.y, bus.uWin);
  connect(TZon.y, bus.TZon);
  connect(TDis.y, bus.TDis);
  connect(VDis_flow.y, bus.VDis_flow);
  connect(yReqZonTemRes.y, bus.yReqZonTemRes);
  connect(yReqZonPreRes.y, bus.yReqZonPreRes);

  connect(FIXME_nOcc.y, setMinOA.nOcc);
  connect(bus.uWin, setMinOA.uWin);
  connect(bus.yReqOutAir, setMinOA.uReqOutAir);
  connect(bus.TZon, setMinOA.TZon);
  connect(bus.TDis, setMinOA.TDis);
  connect(bus.VDis_flow, setMinOA.VDis_flow);
  connect(bus.VDesUncOutAir_flow, setMinOA.VUncOut_flow_nominal);

  connect(setMinOA.yDesZonPeaOcc, bus.yDesZonPeaOcc);
  connect(setMinOA.VDesPopBreZon_flow, bus.VDesPopBreZon_flow);
  connect(setMinOA.VDesAreBreZon_flow, bus.VDesAreBreZon_flow);
  connect(setMinOA.yDesPriOutAirFra, bus.yDesPriOutAirFra);
  connect(setMinOA.VUncOutAir_flow, bus.VUncOutAir_flow);
  connect(setMinOA.yPriOutAirFra, bus.yPriOutAirFra);
  connect(setMinOA.VPriAir_flow, bus.VPriAir_flow);

  connect(cooDowTim.y, sta.cooDowTim);
  connect(warUpTim.y, sta.warUpTim);
  connect(bus.uWin, sta.uWin);
  connect(bus.TZon, sta.TZon);

  connect(sta.yCooTim, bus.yCooTim);
  connect(sta.yWarTim, bus.yWarTim);
  connect(sta.THeaSetOn, bus.THeaSetOn);
  connect(sta.yOccHeaHig, bus.yOccHeaHig);
  connect(sta.TCooSetOn, bus.TCooSetOn);
  connect(sta.yHigOccCoo, bus.yHigOccCoo);
  connect(sta.THeaSetOff, bus.THeaSetOff);
  connect(sta.yUnoHeaHig, bus.yUnoHeaHig);
  connect(sta.yEndSetBac, bus.yEndSetBac);
  connect(sta.TCooSetOff, bus.TCooSetOff);
  connect(sta.yHigUnoCoo, bus.yHigUnoCoo);
  connect(sta.yEndSetUp, bus.yEndSetUp);

  annotation (
    defaultComponentName="conPoiDum",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),       Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-200,-180},{200,180}})));
end DummyControlPointsVAVBox;
