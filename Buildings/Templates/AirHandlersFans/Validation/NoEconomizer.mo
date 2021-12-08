within Buildings.Templates.AirHandlersFans.Validation;
model NoEconomizer
  extends Modelica.Icons.Example;
  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium";
  replaceable package MediumCoo=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Cooling medium (such as CHW)";
  replaceable package MediumHea=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Heating medium (such as HHW)";

  inner parameter ExternData.JSONFile dat(
    fileName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/Data/Templates/Validation/systems.json"))
    annotation (Placement(transformation(extent={{76,76},{96,96}})));

  replaceable UserProject.AHUs.NoEconomizer ahu constrainedby
    Buildings.Templates.AirHandlersFans.VAVMultiZone(redeclare final package
      MediumAir = MediumAir, redeclare final package MediumCoo = MediumCoo)
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));
  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare final package Medium=MediumAir, nPorts=2)
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Buildings.Fluid.Sources.Boundary_pT bou1(
    redeclare final package Medium=MediumAir,
    nPorts=3)
    annotation (Placement(transformation(extent={{90,-10},{70,10}})));

  /*
  FIXME: test snippet working with Dymola but not with OCT
  External object constructors are not allowed inside functions.

  parameter Integer nTest = Templates.BaseClasses.getArraySize1D(
     varName="VAV_1.Supply fan.Pressure curve.value",
     fileName=dat.fileName);

  Modelica.Blocks.Sources.TimeTable timeTable(
  table=dat.getRealArray2D("VAV_1.Supply fan.Pressure curve.value", nTest, 2));
  */

  Fluid.FixedResistances.PressureDrop res(
    redeclare final package Medium=MediumAir,
    m_flow_nominal=1, dp_nominal=100)
    annotation (Placement(transformation(extent={{-50,-20},{-30,0}})));
  Fluid.FixedResistances.PressureDrop res1(
    redeclare final package Medium = MediumAir,
    m_flow_nominal=1,
    dp_nominal=100)
    annotation (Placement(transformation(extent={{30,-20},{50,0}})));
  Fluid.Sensors.Pressure pInd(
    redeclare final package Medium=MediumAir)
    "Indoor pressure"
    annotation (Placement(transformation(extent={{80,30},{60,50}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    annotation (Placement(transformation(extent={{-90,20},{-70,40}})));
  Fluid.FixedResistances.PressureDrop res2(
    redeclare final package Medium = MediumAir,
    m_flow_nominal=1,
    dp_nominal=100)
    annotation (Placement(transformation(extent={{-30,0},{-50,20}})));
  Fluid.FixedResistances.PressureDrop res3(
    redeclare final package Medium = MediumAir,
    m_flow_nominal=1,
    dp_nominal=100)
    annotation (Placement(transformation(extent={{50,0},{30,20}})));
protected
  Interfaces.Bus busAHU
  "Gateway bus only needed for Dymola SR00763223"
  annotation (
    Placement(
      transformation(extent={{-40,20},{0,60}}), iconTransformation(
        extent={{-258,-26},{-238,-6}})));
equation
  connect(bou.ports[1], res.port_a) annotation (Line(points={{-70,-1},{-60,-1},
          {-60,-10},{-50,-10}},color={0,127,255}));
  connect(res.port_b, ahu.port_Out)
    annotation (Line(points={{-30,-10},{-20,-10}}, color={0,127,255}));
  connect(ahu.port_Sup, res1.port_a)
    annotation (Line(points={{20,-10},{30,-10}}, color={0,127,255}));
  connect(res1.port_b, bou1.ports[1]) annotation (Line(points={{50,-10},{60,-10},
          {60,-1.33333},{70,-1.33333}},
                            color={0,127,255}));
  connect(bou1.ports[2], pInd.port) annotation (Line(points={{70,-2.22045e-16},
          {70,30}}, color={0,127,255}));
  connect(weaDat.weaBus,ahu.busWea)  annotation (Line(
      points={{-70,30},{0,30},{0,20}},
      color={255,204,51},
      thickness=0.5));
  connect(pInd.p, busAHU.pInd) annotation (Line(points={{59,40},{14,40},{14,40},
          {-20,40}},           color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(busAHU, ahu.bus) annotation (Line(
      points={{-20,40},{-20,28},{-20,16},{-19.9,16}},
      color={255,204,51},
      thickness=0.5));
  connect(ahu.port_Rel, res2.port_a)
    annotation (Line(points={{-20,10},{-30,10}}, color={0,127,255}));
  connect(res2.port_b, bou.ports[2]) annotation (Line(points={{-50,10},{-60,10},
          {-60,1},{-70,1}},   color={0,127,255}));
  connect(ahu.port_Ret, res3.port_b)
    annotation (Line(points={{20,10},{30,10}}, color={0,127,255}));
  connect(res3.port_a, bou1.ports[3]) annotation (Line(points={{50,10},{60,10},
          {60,1.33333},{70,1.33333}},   color={0,127,255}));
  annotation (
  experiment(Tolerance=1e-6, StopTime=1),
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end NoEconomizer;
