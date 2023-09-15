within Buildings.Templates.AirHandlersFans.Validation;
model VAVMZBase
  "Validation model for multiple-zone VAV - Base model with open loop controls"
  extends Modelica.Icons.Example;
  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium";
  replaceable package MediumChiWat=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Cooling medium (such as CHW)";
  replaceable package MediumHeaWat=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Heating medium (such as HHW)";

  inner parameter UserProject.Data.AllSystems datAll(
    final VAV_1(cfg=VAV_1.cfg))
    "Design and operating parameters"
    annotation (Placement(transformation(extent={{90,92},{110,112}})));

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true,
      Dialog(tab = "Dynamics", group="Conservation equations"));

  inner replaceable UserProject.AirHandlersFans.VAVMZBase VAV_1 constrainedby
    Buildings.Templates.AirHandlersFans.VAVMultiZone(
    final dat=datAll.VAV_1,
    redeclare final package MediumAir = MediumAir,
    redeclare final package MediumChiWat = MediumChiWat,
    final energyDynamics=energyDynamics)
    "Air handling unit"
    annotation (Placement(transformation(extent={{-20,-50},{20,-10}})));
  Buildings.Fluid.Sources.Boundary_pT bouOut(
    redeclare final package Medium =MediumAir,
    nPorts=2)
    "Boundary conditions for outdoor environment"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Fluid.Sources.Boundary_pT bouBui(
    redeclare final package Medium =MediumAir,
    nPorts=3)
    "Boundary conditions for indoor environment"
    annotation (Placement(transformation(extent={{90,-40},{70,-20}})));
  Fluid.FixedResistances.PressureDrop res(
    redeclare final package Medium=MediumAir,
    m_flow_nominal=1, dp_nominal=100)
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Fluid.FixedResistances.PressureDrop res1(
    redeclare final package Medium = MediumAir,
    m_flow_nominal=1,
    dp_nominal=100)
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
  Fluid.Sensors.Pressure pBui(redeclare final package Medium = MediumAir)
    "Building absolute pressure in representative space"
    annotation (Placement(transformation(extent={{80,0},{60,20}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
    Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Fluid.FixedResistances.PressureDrop res2(
    redeclare final package Medium = MediumAir,
    m_flow_nominal=1,
    dp_nominal=100)
    annotation (Placement(transformation(extent={{-30,-30},{-50,-10}})));
  Fluid.FixedResistances.PressureDrop res3(
    redeclare final package Medium = MediumAir,
    m_flow_nominal=1,
    dp_nominal=100)
    annotation (Placement(transformation(extent={{50,-30},{30,-10}})));
  Fluid.Sources.Boundary_pT bouHeaWat(
    redeclare final package Medium = MediumHeaWat,
    nPorts=2) if VAV_1.have_souHeaWat
    "Boundary conditions for HHW distribution system"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  Fluid.Sources.Boundary_pT bouChiWat(
    redeclare final package Medium = MediumChiWat,
    nPorts=2) if VAV_1.have_souChiWat
    "Boundary conditions for CHW distribution system"
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
  UserProject.ZoneEquipment.VAVBoxControlPoints sigVAVBox[VAV_1.nZon](
    each final stdVen=datAll.stdVen)
    if VAV_1.ctl.typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone
    "Control signals from VAV box"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  ZoneEquipment.Validation.UserProject.BASControlPoints sigBAS(
    final nZon=VAV_1.nZon)
    "BAS control points"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  ZoneEquipment.Validation.UserProject.ZoneControlPoints sigZon[VAV_1.nZon]
    "Zone control points"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
protected
  Interfaces.Bus busAHU
  "Gateway bus"
  annotation (
    Placement(
      transformation(extent={{-40,-10},{0,30}}),iconTransformation(
        extent={{-258,-26},{-238,-6}})));

equation
  connect(bouHeaWat.ports[1], VAV_1.port_aHeaWat)
    annotation (Line(points={{-80,-71},{-5,-71},{-5,-50}}, color={0,127,255}));
  connect(bouChiWat.ports[2], VAV_1.port_bChiWat)
    annotation (Line(points={{-80,-99},{5,-99},{5,-50}},  color={0,127,255}));
  connect(VAV_1.port_bHeaWat, bouHeaWat.ports[2]) annotation (Line(points={{-13,-50},
          {-13,-68},{-80,-68},{-80,-69}},      color={0,127,255}));
  connect(VAV_1.port_aChiWat, bouChiWat.ports[1]) annotation (Line(points={{13,-50},
          {13,-102},{-80,-102},{-80,-101}},
                                      color={0,127,255}));
  connect(bouOut.ports[1], res.port_a) annotation (Line(points={{-80,-31},{-60,
          -31},{-60,-40},{-50,-40}},
                                color={0,127,255}));
  connect(res.port_b, VAV_1.port_Out)
    annotation (Line(points={{-30,-40},{-20,-40}}, color={0,127,255}));
  connect(VAV_1.port_Sup, res1.port_a)
    annotation (Line(points={{20,-40},{30,-40}}, color={0,127,255}));
  connect(res1.port_b, bouBui.ports[1]) annotation (Line(points={{50,-40},{60,
          -40},{60,-31.3333},{70,-31.3333}},
                                        color={0,127,255}));
  connect(bouBui.ports[2], pBui.port)
    annotation (Line(points={{70,-30},{70,0}},           color={0,127,255}));
  connect(weaDat.weaBus, VAV_1.busWea) annotation (Line(
      points={{-80,0},{0,0},{0,-10}},
      color={255,204,51},
      thickness=0.5));
  connect(busAHU, VAV_1.bus) annotation (Line(
      points={{-20,10},{-20,-14},{-19.9,-14}},
      color={255,204,51},
      thickness=0.5));
  connect(VAV_1.port_Rel, res2.port_a)
    annotation (Line(points={{-20,-20},{-30,-20}},
                                                 color={0,127,255}));
  connect(res2.port_b, bouOut.ports[2]) annotation (Line(points={{-50,-20},{-60,
          -20},{-60,-29},{-80,-29}},
                            color={0,127,255}));
  connect(VAV_1.port_Ret, res3.port_b)
    annotation (Line(points={{20,-20},{30,-20}},
                                               color={0,127,255}));
  connect(res3.port_a, bouBui.ports[3]) annotation (Line(points={{50,-20},{60,
          -20},{60,-28.6667},{70,-28.6667}},
                                      color={0,127,255}));
  connect(pBui.p, busAHU.pBui) annotation (Line(points={{59,10},{-20,10}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(sigVAVBox.bus, VAV_1.busTer) annotation (Line(
      points={{-80,30},{19.8,30},{19.8,-14}},
      color={255,204,51},
      thickness=0.5));

  connect(sigBAS.busTer, VAV_1.busTer) annotation (Line(
      points={{-80,90},{19.8,90},{19.8,-14}},
      color={255,204,51},
      thickness=0.5));
  connect(sigZon.bus, VAV_1.busTer) annotation (Line(
      points={{-80,60},{19.8,60},{19.8,-14}},
      color={255,204,51},
      thickness=0.5));
  annotation (
  __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/AirHandlersFans/Validation/VAVMZBase.mos"
  "Simulate and plot"),
  experiment(Tolerance=1e-6, StopTime=1), Documentation(info="<html>
<p>
This is a validation model for the configuration represented by
<a href=\"modelica://Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans.VAVMZBase\">
Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans.VAVMZBase</a>.
It is intended to check whether the template model is well-defined for
this particular system configuration.
However, due to the open-loop controls a correct physical behavior
is not expected and the plotted variables are for non-regression testing only.
</p>
</html>"),
    Diagram(coordinateSystem(extent={{-120,-120},{120,120}})));
end VAVMZBase;
