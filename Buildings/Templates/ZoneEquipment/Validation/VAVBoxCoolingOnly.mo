within Buildings.Templates.ZoneEquipment.Validation;
model VAVBoxCoolingOnly "Validation model for VAV terminal unit cooling only"
  extends Modelica.Icons.Example;

  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium";

  replaceable package MediumHeaWat=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Heating medium (such as HHW)";

  parameter UserProject.Data.AllSystems dat(VAVBox_1(
    final typ=VAVBox_1.typ,
    final have_souChiWat=VAVBox_1.have_souChiWat,
    final have_souHeaWat=VAVBox_1.have_souHeaWat,
    final typCtl=VAVBox_1.ctl.typ,
    final typDamVAV=VAVBox_1.damVAV.typ,
    final typCoiHea=VAVBox_1.coiHea.typ,
    final typValCoiHea=VAVBox_1.coiHea.typVal,
    final have_CO2Sen=VAVBox_1.ctl.have_CO2Sen,
    ctl(
      final stdVen=VAVBox_1.ctl.stdVen)))
    "System parameters"
    annotation (Placement(transformation(extent={{0,52},{20,72}})));

  Fluid.Sources.Boundary_pT bouPri(redeclare final package Medium = MediumAir,
      nPorts=1) "Boundary conditions for primary air distribution system"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Fluid.FixedResistances.PressureDrop res(
    redeclare final package Medium = MediumAir,
    m_flow_nominal=1,
    dp_nominal=100)
    annotation (Placement(transformation(extent={{-48,-50},{-28,-30}})));
  Fluid.FixedResistances.PressureDrop res1(
    redeclare final package Medium = MediumAir,
    m_flow_nominal=1,
    dp_nominal=100)
    annotation (Placement(transformation(extent={{32,-50},{52,-30}})));
  Fluid.Sources.Boundary_pT bouBui(redeclare final package Medium = MediumAir,
      nPorts=1) "Boundary conditions for indoor environment"
    annotation (Placement(transformation(extent={{80,-50},{60,-30}})));
  replaceable UserProject.ZoneEquipment.VAVBoxCoolingOnly VAVBox_1(
    final dat=dat.VAVBox_1,
    redeclare final package MediumAir = MediumAir,
    redeclare final package MediumHeaWat = MediumHeaWat)
    "Terminal unit"
    annotation (Placement(transformation(extent={{-20,-60},{20,-20}})));

  Fluid.Sources.Boundary_pT bouHeaWat(
    redeclare final package Medium = MediumHeaWat,
    nPorts=2) if VAVBox_1.have_souHeaWat
    "Boundary conditions for HHW distribution system"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  UserProject.AirHandlersFans.VAVMZControlPoints sigAirHan if VAVBox_1.ctl.typ ==
    Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxCoolingOnly or
    VAVBox_1.ctl.typ == Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat
    "Control signals from AHU"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  UserProject.ZoneControlPoints sigZon
 if VAVBox_1.ctl.typ == Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxCoolingOnly
     or VAVBox_1.ctl.typ == Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat
    "Control signals from zone-level equipment"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  UserProject.PlantControlPoints sigPla if VAVBox_1.ctl.typ ==
    Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxCoolingOnly or
    VAVBox_1.ctl.typ == Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat
    "Control signals from AHU"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));

  UserProject.BASControlPoints sigBAS
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
equation
  connect(bouPri.ports[1], res.port_a)
    annotation (Line(points={{-60,-40},{-48,-40}},
                                               color={0,127,255}));
  connect(bouBui.ports[1], res1.port_b)
    annotation (Line(points={{60,-40},{52,-40}},
                                             color={0,127,255}));
  connect(res.port_b, VAVBox_1.port_Sup)
    annotation (Line(points={{-28,-40},{-20,-40}}, color={0,127,255}));
  connect(VAVBox_1.port_Dis, res1.port_a)
    annotation (Line(points={{20,-40},{32,-40}}, color={0,127,255}));
  connect(VAVBox_1.port_aHeaWat, bouHeaWat.ports[1]) annotation (Line(points={{5,-60},
          {5,-82},{-60,-82},{-60,-81}},      color={0,127,255}));
  connect(VAVBox_1.port_bHeaWat, bouHeaWat.ports[2])
    annotation (Line(points={{-5,-60},{-5,-79},{-60,-79}}, color={0,127,255}));
  connect(sigZon.bus, VAVBox_1.bus) annotation (Line(
      points={{-60,0},{-40,0},{-40,-24},{-19.9,-24}},
      color={255,204,51},
      thickness=0.5));
  connect(sigAirHan.busTer[1], VAVBox_1.bus) annotation (Line(
      points={{-60,30},{-20,30},{-20,-24},{-19.9,-24}},
      color={255,204,51},
      thickness=0.5));
  connect(sigPla.busTer[1], VAVBox_1.bus) annotation (Line(
      points={{-60,60},{-19.9,60},{-19.9,-24}},
      color={255,204,51},
      thickness=0.5));
  connect(sigBAS.busTer[1], VAVBox_1.bus) annotation (Line(
      points={{-60,90},{-19.9,90},{-19.9,-24}},
      color={255,204,51},
      thickness=0.5));
    annotation (
  experiment(Tolerance=1e-6, StopTime=1), Documentation(info="<html>
<p>
This is a validation model for the configuration represented by
<a href=\"modelica://Buildings.Templates.ZoneEquipment.Validation.UserProject.ZoneEquipment.VAVBoxCoolingOnly\">
Buildings.Templates.ZoneEquipment.Validation.UserProject.ZoneEquipment.VAVBoxCoolingOnly</a>
</p>
</html>"),
    Diagram(coordinateSystem(extent={{-120,-120},{120,120}})),
    Icon(coordinateSystem(extent={{-120,-120},{120,120}})));
end VAVBoxCoolingOnly;
