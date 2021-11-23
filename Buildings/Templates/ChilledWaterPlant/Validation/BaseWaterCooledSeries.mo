within Buildings.Templates.ChilledWaterPlant.Validation;
model BaseWaterCooledSeries
  extends Modelica.Icons.Example;
  replaceable package MediumCHW=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Chilled water medium";

  inner parameter ExternData.JSONFile dat(
    fileName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/Data/Templates/Validation/systems.json"))
    annotation (
      Evaluate=true,
      Placement(transformation(extent={{76,76},{96,96}})));

  replaceable Buildings.Templates.ChilledWaterPlant.WaterCooledSeries chw
    constrainedby
    Buildings.Templates.ChilledWaterPlant.Validation.UserProject.BaseWaterCooledSeries
    annotation (Placement(transformation(extent={{-40,-20},{0,20}})));
  Fluid.Sources.Boundary_pT bou1(
    redeclare final package Medium=MediumCHW,
    nPorts=3)
    annotation (Placement(transformation(extent={{90,-10},{70,10}})));

  Fluid.FixedResistances.PressureDrop res1(
    redeclare final package Medium = MediumCHW,
    m_flow_nominal=1,
    dp_nominal=100)
    annotation (Placement(transformation(extent={{28,-10},{48,10}})));
  Fluid.Sensors.Pressure pDem(
    redeclare final package Medium=MediumCHW) "Demand side pressure"
    annotation (Placement(transformation(extent={{80,30},{60,50}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    annotation (Placement(transformation(extent={{-90,20},{-70,40}})));
  Fluid.FixedResistances.PressureDrop res2(
    redeclare final package Medium = MediumCHW,
    m_flow_nominal=1,
    dp_nominal=100)
    annotation (Placement(transformation(extent={{48,-30},{28,-10}})));
protected
  Buildings.Templates.ChilledWaterPlant.BaseClasses.BusChilledWater busCHW(
    final nChi=chw.nChi,
    final nPumPri=chw.nPumPri,
    final nPumSec=chw.nPumSec)
  annotation (Placement(
      transformation(extent={{10,40},{50,80}}), iconTransformation(
        extent={{-258,-26},{-238,-6}})));
equation
  connect(res1.port_b, bou1.ports[1]) annotation (Line(points={{48,0},{60,0},{60,
          2.66667},{70,2.66667}},
                            color={0,127,255}));
  connect(bou1.ports[2],pDem. port) annotation (Line(points={{70,-2.22045e-16},
          {70,30}}, color={0,127,255}));
  connect(weaDat.weaBus, chw.weaBus) annotation (Line(
      points={{-70,30},{-20,30},{-20,20}},
      color={255,204,51},
      thickness=0.5));
  connect(res2.port_a, bou1.ports[3]) annotation (Line(points={{48,-20},{60,-20},
          {60,-2.66667},{70,-2.66667}}, color={0,127,255}));
  connect(res1.port_a, chw.port_a)
    annotation (Line(points={{28,0},{28,2},{0,2}},   color={0,127,255}));
  connect(res2.port_b, chw.port_b) annotation (Line(points={{28,-20},{6,-20},{6,
          -14},{0,-14}}, color={0,127,255}));
  connect(busCHW, chw.chwCon) annotation (Line(
      points={{30,60},{30,12},{0,12}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(pDem.p, busCHW.pDem) annotation (Line(points={{59,40},{54,40},{54,
          60},{30,60}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (
  experiment(Tolerance=1e-6, StopTime=1),
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end BaseWaterCooledSeries;
