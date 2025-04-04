within Buildings.Templates.ZoneEquipment.Validation;
model VAVBoxCoolingOnly "Validation model for VAV terminal unit cooling only"
  extends Modelica.Icons.Example;

  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium";
  replaceable package MediumHeaWat=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Heating medium (such as HHW)";

  inner parameter UserProject.Data.AllSystems datAll(
    final VAVBox_1(cfg=VAVBox_1.cfg))
    "System parameters"
    annotation (Placement(transformation(extent={{90,92},{110,112}})));

  Fluid.Sources.Boundary_pT bouPri(
    redeclare final package Medium = MediumAir,
    p=MediumAir.p_default + 200,
    nPorts=1) "Boundary conditions for primary air distribution system"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Fluid.FixedResistances.PressureDrop res(
    redeclare final package Medium = MediumAir,
    m_flow_nominal=1,
    dp_nominal=100)
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Fluid.FixedResistances.PressureDrop res1(
    redeclare final package Medium = MediumAir,
    m_flow_nominal=1,
    dp_nominal=100)
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
  Fluid.Sources.Boundary_pT bouBui(
    redeclare final package Medium = MediumAir,
    nPorts=1) "Boundary conditions for indoor environment"
    annotation (Placement(transformation(extent={{80,-50},{60,-30}})));

  replaceable Buildings.Templates.ZoneEquipment.VAVBoxCoolingOnly VAVBox_1(
    final dat=datAll.VAVBox_1,
    redeclare final package MediumAir = MediumAir,
    redeclare final package MediumHeaWat = MediumHeaWat)
    "Terminal unit"
    annotation (Placement(transformation(extent={{-20,-60},{20,-20}})));

  Fluid.Sources.Boundary_pT bouHeaWat(
    redeclare final package Medium = MediumHeaWat,
    nPorts=2) if VAVBox_1.have_souHeaWat
    "Boundary conditions for HHW distribution system"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  UserProject.VAVMZControlPoints sigAirHan if VAVBox_1.ctl.typ == Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxCoolingOnly
     or VAVBox_1.ctl.typ == Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat
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
    "BAS control points"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
equation
  connect(bouPri.ports[1], res.port_a)
    annotation (Line(points={{-60,-40},{-50,-40}},
                                               color={0,127,255}));
  connect(bouBui.ports[1], res1.port_b)
    annotation (Line(points={{60,-40},{50,-40}},
                                             color={0,127,255}));
  connect(res.port_b, VAVBox_1.port_Sup)
    annotation (Line(points={{-30,-40},{-20,-40}}, color={0,127,255}));
  connect(VAVBox_1.port_Dis, res1.port_a)
    annotation (Line(points={{20,-40},{30,-40}}, color={0,127,255}));
  connect(VAVBox_1.port_aHeaWat, bouHeaWat.ports[1]) annotation (Line(points={{5,-60},
          {5,-82},{-60,-82},{-60,-81}},      color={0,127,255}));
  connect(VAVBox_1.port_bHeaWat, bouHeaWat.ports[2])
    annotation (Line(points={{-5,-60},{-5,-79},{-60,-79}}, color={0,127,255}));
  connect(sigZon.bus, VAVBox_1.bus) annotation (Line(
      points={{-60,0},{-20,0},{-20,-24},{-19.9,-24}},
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
  __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/ZoneEquipment/Validation/VAVBoxCoolingOnly.mos"
  "Simulate and plot"),
  experiment(Tolerance=1e-6, StopTime=3600), Documentation(info="<html>
<p>
This is a validation model for the template
<a href=\"modelica://Buildings.Templates.ZoneEquipment.VAVBoxCoolingOnly\">
Buildings.Templates.ZoneEquipment.VAVBoxCoolingOnly</a>.
</p>
<p>
All supported system configurations can be generated by the Python script
<code>Buildings/Resources/Scripts/travis/templates/VAVBox.py</code>.
</p>
</html>"),
Diagram(coordinateSystem(extent={{-120,-120},{120,120}})));
end VAVBoxCoolingOnly;
