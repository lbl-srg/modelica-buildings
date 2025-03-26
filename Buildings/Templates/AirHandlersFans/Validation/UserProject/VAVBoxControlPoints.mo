within Buildings.Templates.AirHandlersFans.Validation.UserProject;
block VAVBoxControlPoints "Emulation of VAV box control points"
  extends Modelica.Blocks.Icons.Block;

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard stdVen
    "Ventilation standard"
    annotation(Evaluate=true);

  Buildings.Templates.ZoneEquipment.Interfaces.Bus bus
    "Terminal unit control bus"
    annotation (Placement(transformation(
        extent={{-20,20},{20,-20}},
        rotation=90,
        origin={200,0}), iconTransformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={100,0})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant tNexOcc(final k=3600)
    "Time next occupancy"
    annotation (Placement(transformation(extent={{-140,130},{-120,150}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant VAirDis_flow(final k=1)
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant yReqZonTemRes(final k=1)
    "Request"
    annotation (Placement(transformation(extent={{-140,-110},{-120,-90}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant yReqZonPreRes(final k=1)
    "Request"
    annotation (Placement(transformation(extent={{-140,-150},{-120,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TAirDis(final k=303.15)
    "Discharge temperature"
    annotation (Placement(transformation(extent={{-140,30},{-120,50}})));

  Controls.OBC.CDL.Integers.Sources.Constant uOpeMod(
    k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "Operating mode"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups.ZoneStatus sta
    "Evaluate zone temperature status"
    annotation (Placement(transformation(extent={{100,-74},{120,-46}})));
  Controls.OBC.CDL.Reals.Sources.Constant cooDowTim(final k=1800)
                  "Cooling down time"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  Controls.OBC.CDL.Reals.Sources.Constant warUpTim(final k=1800)
                  "Warm-up time"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Controls.OBC.ASHRAE.G36.VentilationZones.Title24.Setpoints setMinOA_T24(
    VOccMin_flow=2.5e-3,
    VAreMin_flow=3e-3,
    VMin_flow=5e-3) if stdVen==
    Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24
    "Zone level calculation of the minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{100,-20},{120,0}})));
  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.ASHRAE62_1.Setpoints setMinOA_62_1(
    VAreBreZon_flow=3e-3,
    VPopBreZon_flow=2.5e-3,
    VMin_flow=5.5e-3) if stdVen==
    Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1
    "Zone level calculation of the minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{100,20},{120,40}})));
equation
  connect(tNexOcc.y, bus.tNexOcc);
  connect(TAirDis.y, bus.TAirDis);
  connect(VAirDis_flow.y, bus.VAirDis_flow);
  connect(yReqZonTemRes.y, bus.yReqZonTemRes);
  connect(yReqZonPreRes.y, bus.yReqZonPreRes);

  connect(bus.y1Win, setMinOA_62_1.u1Win);
  connect(bus.TZon, setMinOA_62_1.TZon);
  connect(bus.TAirDis, setMinOA_62_1.TDis);

  connect(setMinOA_62_1.VAdjPopBreZon_flow, bus.VAdjPopBreZon_flow);
  connect(setMinOA_62_1.VOccZonMin_flow, bus.VOccZonMin_flow);
  connect(setMinOA_62_1.VAdjAreBreZon_flow, bus.VAdjAreBreZon_flow);
  connect(setMinOA_62_1.VMinOA_flow, bus.VMinOA_flow);

  connect(setMinOA_T24.VZonAbsMin_flow, bus.VZonAbsMin_flow);
  connect(setMinOA_T24.VZonDesMin_flow, bus.VZonDesMin_flow);
  connect(setMinOA_T24.VOccZonMin_flow, bus.VOccZonMin_flow);
  connect(setMinOA_T24.yCO2, bus.yCO2);
  connect(setMinOA_T24.VMinOA_flow, bus.VMinOA_flow);

  connect(cooDowTim.y, sta.cooDowTim);
  connect(warUpTim.y, sta.warUpTim);
  connect(bus.u1Win, sta.u1Win);
  connect(bus.TZon, sta.TZon);
  connect(bus.TZonHeaOccSet, sta.TOccHeaSet);
  connect(bus.TZonCooOccSet, sta.TOccCooSet);
  connect(bus.TZonHeaUnoSet, sta.TUnoHeaSet);
  connect(bus.TZonCooUnoSet, sta.TUnoCooSet);

  connect(sta.yCooTim, bus.yCooTim);
  connect(sta.yWarTim, bus.yWarTim);
  connect(sta.yOccHeaHig, bus.yOccHeaHig);
  connect(sta.yHigOccCoo, bus.yHigOccCoo);
  connect(sta.yUnoHeaHig, bus.yUnoHeaHig);
  connect(sta.yEndSetBac, bus.yEndSetBac);
  connect(sta.yHigUnoCoo, bus.yHigUnoCoo);
  connect(sta.yEndSetUp, bus.yEndSetUp);

  connect(uOpeMod.y, setMinOA_62_1.uOpeMod) annotation (Line(points={{62,20},{80,
          20},{80,35},{98,35}}, color={255,127,0}));
  annotation (
    defaultComponentName="conPoiDum",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),       Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-200,-180},{200,180}})),
    Documentation(info="<html>
<p>
This class generates signals typically provided by the terminal
unit controller.
It is aimed for validation purposes only.
</p>
</html>"));
end VAVBoxControlPoints;
