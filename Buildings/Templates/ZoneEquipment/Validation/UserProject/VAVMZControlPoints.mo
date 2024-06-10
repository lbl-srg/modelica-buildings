within Buildings.Templates.ZoneEquipment.Validation.UserProject;
block VAVMZControlPoints "Emulation of multiple-zone VAV control points"
  extends Modelica.Blocks.Icons.Block;

  parameter Integer nZon = 2
    "Number of served zones";

  Buildings.Templates.ZoneEquipment.Interfaces.Bus busTer[nZon]
    "Terminal unit control bus" annotation (Placement(transformation(
        extent={{-20,20},{20,-20}},
        rotation=90,
        origin={200,0}), iconTransformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={100,0})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TAirSupSet[nZon](
    each k=15 + 273.15) "AHU supply air temperature setpoint"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant yOpeMod[nZon](each k=1)
    "Group operating mode"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant VDesUncOutAir_flow[nZon](each k=1)
    "VDesUncOutAir_flow from AHU controller"
    annotation (Placement(transformation(extent={{0,130},{20,150}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant yReqOutAir[nZon](each k=true)
    "yReqOutAir from AHU controller"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
  Controls.OBC.CDL.Logical.Sources.Constant y1FanSup_actual[nZon](each k=true)
    "y1FanSup_actual from AHU controller"
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));
  Controls.OBC.CDL.Reals.Sources.Constant TAirSup[nZon](each k=15 + 273.15)
    "AHU supply air temperature"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
equation

  connect(TAirSupSet.y, busTer.TAirSupSet);
  connect(TAirSup.y, busTer.TAirSup);
  connect(yOpeMod.y, busTer.yOpeMod);

  connect(yReqOutAir.y, busTer.yReqOutAir);
  connect(VDesUncOutAir_flow.y, busTer.VDesUncOutAir_flow);
  connect(y1FanSup_actual.y, busTer.y1FanSup_actual);

  annotation (
    defaultComponentName="sigAirHan",
    Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-200,-180},{200,180}})),
    Documentation(info="<html>
<p>
This class generates signals typically provided by the AHU controller.
It is aimed for validation purposes only.
</p>
</html>"));
end VAVMZControlPoints;
