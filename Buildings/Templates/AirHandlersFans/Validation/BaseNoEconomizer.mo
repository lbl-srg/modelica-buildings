within Buildings.Templates.AirHandlersFans.Validation;
model BaseNoEconomizer
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

  UserProject.DataTopLevel datTop(VAV_1(
      final typ=VAV_1.typ,
      final typFanSup=VAV_1.typFanSup,
      final typFanRet=VAV_1.typFanRet,
      final typFanRel=VAV_1.typFanRel,
      final have_souCoiCoo=VAV_1.have_souCoiCoo,
      final have_souCoiHeaPre=VAV_1.have_souCoiHeaPre,
      final have_souCoiHeaReh=VAV_1.have_souCoiHeaReh,
      mAirSup_flow_nominal=1,
      mAirRet_flow_nominal=1,
      final typCoiHeaPre=VAV_1.coiHeaPre.typ,
      final typCoiCoo=VAV_1.coiCoo.typ,
      final typCoiHeaReh=VAV_1.coiHeaReh.typ,
      final typValCoiHeaPre=VAV_1.coiHeaPre.typVal,
      final typValCoiCoo=VAV_1.coiCoo.typVal,
      final typValCoiHeaReh=VAV_1.coiHeaReh.typVal,
      mOutMin_flow_nominal=0.2,
      final typDamOut=VAV_1.secOutRel.typDamOut,
      final typDamOutMin=VAV_1.secOutRel.typDamOutMin,
      final typDamRet=VAV_1.secOutRel.typDamRet,
      final typDamRel=VAV_1.secOutRel.typDamRel))
    annotation (Placement(transformation(extent={{-10,80},{10,100}})));

  inner replaceable UserProject.AHUs.NoEconomizer VAV_1 constrainedby
    Buildings.Templates.AirHandlersFans.VAVMultiZone(
    datRec=datTop.VAV_1,
    id="VAV_1",
    redeclare final package MediumAir = MediumAir,
    redeclare final package MediumCoo = MediumCoo)
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));
  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare final package Medium=MediumAir, nPorts=2)
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Buildings.Fluid.Sources.Boundary_pT bou1(
    redeclare final package Medium=MediumAir,
    nPorts=3)
    annotation (Placement(transformation(extent={{90,-10},{70,10}})));
  Fluid.FixedResistances.PressureDrop res(
    redeclare final package Medium=MediumAir,
    m_flow_nominal=1, dp_nominal=100)
    annotation (Placement(transformation(extent={{-50,-20},{-30,0}})));
  Fluid.FixedResistances.PressureDrop res1(
    redeclare final package Medium = MediumAir,
    m_flow_nominal=1,
    dp_nominal=100)
    annotation (Placement(transformation(extent={{30,-20},{50,0}})));
  Fluid.Sensors.Pressure pAirBui(redeclare final package Medium = MediumAir)
    "Building absolute pressure in representative space"
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
  "Gateway bus"
  annotation (
    Placement(
      transformation(extent={{-40,20},{0,60}}), iconTransformation(
        extent={{-258,-26},{-238,-6}})));
equation
  connect(bou.ports[1], res.port_a) annotation (Line(points={{-70,-1},{-60,-1},
          {-60,-10},{-50,-10}},color={0,127,255}));
  connect(res.port_b, VAV_1.port_Out)
    annotation (Line(points={{-30,-10},{-20,-10}}, color={0,127,255}));
  connect(VAV_1.port_Sup, res1.port_a)
    annotation (Line(points={{20,-10},{30,-10}}, color={0,127,255}));
  connect(res1.port_b, bou1.ports[1]) annotation (Line(points={{50,-10},{60,-10},
          {60,-1.33333},{70,-1.33333}},
                            color={0,127,255}));
  connect(bou1.ports[2], pAirBui.port)
    annotation (Line(points={{70,-2.22045e-16},{70,30}}, color={0,127,255}));
  connect(weaDat.weaBus, VAV_1.busWea) annotation (Line(
      points={{-70,30},{0,30},{0,20}},
      color={255,204,51},
      thickness=0.5));
  connect(busAHU, VAV_1.bus) annotation (Line(
      points={{-20,40},{-20,28},{-20,16},{-19.9,16}},
      color={255,204,51},
      thickness=0.5));
  connect(VAV_1.port_Rel, res2.port_a)
    annotation (Line(points={{-20,10},{-30,10}}, color={0,127,255}));
  connect(res2.port_b, bou.ports[2]) annotation (Line(points={{-50,10},{-60,10},
          {-60,1},{-70,1}},   color={0,127,255}));
  connect(VAV_1.port_Ret, res3.port_b)
    annotation (Line(points={{20,10},{30,10}}, color={0,127,255}));
  connect(res3.port_a, bou1.ports[3]) annotation (Line(points={{50,10},{60,10},
          {60,1.33333},{70,1.33333}},   color={0,127,255}));
  connect(pAirBui.p, busAHU.pAirBui) annotation (Line(points={{59,40},{-20,40}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (
  experiment(Tolerance=1e-6, StopTime=1),
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end BaseNoEconomizer;
