within Buildings.Templates.ZoneEquipment.Validation;
model VAVBoxCoolingOnly
  extends Modelica.Icons.Example;

  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium";

  replaceable package MediumHeaWat=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Heating medium (such as HHW)";

  Fluid.Sources.Boundary_pT bouPri(redeclare final package Medium = MediumAir,
      nPorts=1) "Boundary conditions for primary air distribution system"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Fluid.FixedResistances.PressureDrop res(
    redeclare final package Medium = MediumAir,
    m_flow_nominal=1,
    dp_nominal=100)
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Fluid.FixedResistances.PressureDrop res1(
    redeclare final package Medium = MediumAir,
    m_flow_nominal=1,
    dp_nominal=100)
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Fluid.Sources.Boundary_pT bouBui(redeclare final package Medium = MediumAir,
      nPorts=1) "Boundary conditions for indoor environment"
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  replaceable UserProject.ZoneEquipment.VAVBoxCoolingOnly ter(dat(
      id="Box_1",
      id_souAir="VAV_1",
      damVAV(dp_nominal=50),
      coiHea(
        cap_nominal=1e3,
        dpAir_nominal=70,
        dpWat_nominal=0.1e4,
        dpValve_nominal=0.05e4,
        mWat_flow_nominal=1e3/4186/10,
        TAirEnt_nominal=285.15,
        TWatEnt_nominal=323.15),
      ctl(
        VAirCooSet_flow_max=0.1,
        VAirHeaSet_flow_max=0.03,
        VAirSet_flow_min=0.01,
        AFlo=10,
        nPeo_nominal=1)),
      redeclare final package MediumAir = MediumAir,
      redeclare final package MediumHeaWat=MediumHeaWat)
    "Terminal unit"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));

  Fluid.Sources.Boundary_pT bouHeaWat(
    redeclare final package Medium = MediumHeaWat,
    nPorts=2) if ter.have_souHeaWat
    "Boundary conditions for HHW distribution system"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  UserProject.AirHandlersFans.VAVMultiZoneControlPoints sigAHU
    if ter.ctl.typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxCoolingOnly
    or ter.ctl.typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat
    "Control signals from AHU"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  UserProject.ZoneControlPoints sigZon
    if ter.ctl.typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxCoolingOnly
      or ter.ctl.typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat
    "Control signals from zone-level equipment"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
equation
  connect(bouPri.ports[1], res.port_a)
    annotation (Line(points={{-60,0},{-50,0}}, color={0,127,255}));
  connect(bouBui.ports[1], res1.port_b)
    annotation (Line(points={{60,0},{50,0}}, color={0,127,255}));
  connect(res.port_b, ter.port_Sup)
    annotation (Line(points={{-30,0},{-20,0}}, color={0,127,255}));
  connect(ter.port_Dis, res1.port_a)
    annotation (Line(points={{20,0},{30,0}}, color={0,127,255}));
  connect(ter.port_aHeaWat, bouHeaWat.ports[1]) annotation (Line(points={{5,-20},
          {5,-52},{-60,-52},{-60,-51}}, color={0,127,255}));
  connect(ter.port_bHeaWat, bouHeaWat.ports[2])
    annotation (Line(points={{-5,-20},{-5,-49},{-60,-49}}, color={0,127,255}));
  connect(sigZon.bus, ter.bus) annotation (Line(
      points={{-60,40},{-40,40},{-40,16},{-19.9,16}},
      color={255,204,51},
      thickness=0.5));
  connect(sigAHU.busTer[1], ter.bus) annotation (Line(
      points={{-60,80},{-20,80},{-20,16},{-19.9,16}},
      color={255,204,51},
      thickness=0.5));
    annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end VAVBoxCoolingOnly;
