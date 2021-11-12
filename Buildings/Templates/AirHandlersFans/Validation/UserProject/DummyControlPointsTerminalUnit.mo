within Buildings.Templates.AirHandlersFans.Validation.UserProject;
block DummyControlPointsTerminalUnit
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
  Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Zone setZonMinOA(AFlo=10,
      minZonPriFlo=1)
    "Zone level calculation of the minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Controls.OBC.CDL.Integers.Sources.Constant FIXME_nOcc(k=1)
    "nOcc shall be Boolean, not integer"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.ZoneStatus staZon
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

  connect(VDis_flow.y, setZonMinOA.VDis_flow);
  connect(FIXME_nOcc.y, setZonMinOA.nOcc);
  connect(uWin.y, setZonMinOA.uWin);
  connect(TZon.y, setZonMinOA.TZon);
  connect(TDis.y, setZonMinOA.TDis);

  connect(setZonMinOA.yDesZonPeaOcc, bus.yDesZonPeaOcc);
  connect(setZonMinOA.VDesPopBreZon_flow, bus.VDesPopBreZon_flow);
  connect(setZonMinOA.VDesAreBreZon_flow, bus.VDesAreBreZon_flow);
  connect(setZonMinOA.yDesPriOutAirFra, bus.yDesPriOutAirFra);
  connect(setZonMinOA.VUncOutAir_flow, bus.VUncOutAir_flow);
  connect(setZonMinOA.yPriOutAirFra, bus.yPriOutAirFra);
  connect(setZonMinOA.VPriAir_flow, bus.VPriAir_flow);

  connect(cooDowTim.y,staZon. cooDowTim);
  connect(warUpTim.y,staZon. warUpTim);
  connect(bus.uWin,staZon. uWin);
  connect(bus.TZon,staZon. TZon);

  connect(staZon.yCooTim, bus.yCooTim);
  connect(staZon.yWarTim, bus.yWarTim);
  connect(staZon.THeaSetOn, bus.THeaSetOn);
  connect(staZon.yOccHeaHig, bus.yOccHeaHig);
  connect(staZon.TCooSetOn, bus.TCooSetOn);
  connect(staZon.yHigOccCoo, bus.yHigOccCoo);
  connect(staZon.THeaSetOff, bus.THeaSetOff);
  connect(staZon.yUnoHeaHig, bus.yUnoHeaHig);
  connect(staZon.yEndSetBac, bus.yEndSetBac);
  connect(staZon.TCooSetOff, bus.TCooSetOff);
  connect(staZon.yHigUnoCoo, bus.yHigUnoCoo);
  connect(staZon.yEndSetUp, bus.yEndSetUp);

  annotation (
    defaultComponentName="conPoiDum",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),       Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-200,-180},{200,180}})));
end DummyControlPointsTerminalUnit;
