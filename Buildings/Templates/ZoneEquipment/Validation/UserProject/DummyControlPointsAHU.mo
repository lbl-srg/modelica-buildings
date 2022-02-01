within Buildings.Templates.ZoneEquipment.Validation.UserProject;
block DummyControlPointsAHU "Control points from AHU"
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

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TAirSupSet[nZon](
    each k=15 + 273.15) "AHU supply air temperature set point"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant yOpeMod[nZon](each k=1)
    "Group operating mode"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant uHeaDemLimLev[nZon](each k=1)
    "Demand limiter level"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant uCooDemLimLev[nZon](each k=1)
    "Demand limiter level"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VDesUncOutAir_flow[nZon](each k=1)
    "VDesUncOutAir_flow from AHU controller"
    annotation (Placement(transformation(extent={{0,130},{20,150}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant yReqOutAir[nZon](each k=true)
    "yReqOutAir from AHU controller"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
  Controls.OBC.CDL.Logical.Sources.Constant yFanSup_actual[nZon](each k=true)
    "yFanSup_actual from AHU controller"
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TAirSup[nZon](each k=15 + 273.15)
    "AHU supply air temperature"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
equation

  connect(TAirSupSet.y, busTer.TAirSupSet);
  connect(TAirSup.y, busTer.TAirSup);
  connect(yOpeMod.y, busTer.yOpeMod);
  connect(uHeaDemLimLev.y, busTer.uHeaDemLimLev);
  connect(uCooDemLimLev.y, busTer.uCooDemLimLev);

  connect(yReqOutAir.y, busTer.yReqOutAir);
  connect(VDesUncOutAir_flow.y, busTer.VDesUncOutAir_flow);
  connect(yFanSup_actual.y, busTer.yFanSup_actual);


  annotation (
    defaultComponentName="conPoiDum",
    Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-200,-180},{200,180}})));
end DummyControlPointsAHU;
