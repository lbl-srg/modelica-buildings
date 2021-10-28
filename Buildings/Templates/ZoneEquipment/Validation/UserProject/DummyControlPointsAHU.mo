within Buildings.Templates.ZoneEquipment.Validation.UserProject;
block DummyControlPointsAHU
  extends Modelica.Blocks.Icons.Block;

  AirHandlersFans.Interfaces.Bus busAHU "AHU control bus" annotation (Placement(
        transformation(
        extent={{-20,20},{20,-20}},
        rotation=90,
        origin={200,0}), iconTransformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={100,0})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonHeaOccSet(final k=
        293.15) "Occupied heating setpoint"
    annotation (Placement(transformation(extent={{-140,130},{-120,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonCooOccSet(final k=
        297.15) "Occupied cooling setpoint"
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonHeaUnoSet(final k=
        285.15) "Unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonCooUnoSet(final k=
        303.15) "Unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZon(final k=303.15)
    "Zone temperature"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSupSet(final k=15 + 273.15)
    "AHU supply temperature set point"
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant yOpeMod(final k=1)
    "Group operating mode"
    annotation (Placement(transformation(extent={{-140,-110},{-120,-90}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant uHeaDemLimLev(final k=1)
    "Demand limiter level"
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant uCooDemLimLev(final k=1)
    "Demand limiter level"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VDesUncOutAir_flow(final k=1)
    "VDesUncOutAir_flow from AHU controller"
    annotation (Placement(transformation(extent={{40,130},{60,150}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant yReqOutAir(final k=true)
    "yReqOutAir from AHU controller"
    annotation (Placement(transformation(extent={{40,90},{60,110}})));
equation
  connect(TZon.y,busAHU. TZon);

  connect(TZonHeaOccSet.y, busAHU.TZonHeaOccSet);
  connect(TZonCooOccSet.y, busAHU.TZonCooOccSet);
  connect(TZonHeaUnoSet.y, busAHU.TZonHeaUnoSet);
  connect(TZonCooUnoSet.y, busAHU.TZonCooUnoSet);
  connect(TSupSet.y, busAHU.TSupSet);
  connect(yOpeMod.y, busAHU.yOpeMod);
  connect(uHeaDemLimLev.y, busAHU.uHeaDemLimLev);
  connect(uCooDemLimLev.y, busAHU.uCooDemLimLev);

  connect(yReqOutAir.y, busAHU.yReqOutAir);
  connect(VDesUncOutAir_flow.y, busAHU.VDesUncOutAir_flow);

  annotation (
    defaultComponentName="conPoiDum",
    Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-200,-180},{200,180}})));
end DummyControlPointsAHU;
