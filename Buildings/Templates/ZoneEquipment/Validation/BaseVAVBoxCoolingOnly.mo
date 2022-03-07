within Buildings.Templates.ZoneEquipment.Validation;
model BaseVAVBoxCoolingOnly
  extends Modelica.Icons.Example;

  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium";

  replaceable package MediumHea=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Heating medium (such as HHW)";

  Fluid.Sources.Boundary_pT bou(
    redeclare final package Medium = MediumAir,
    nPorts=1)
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
  Fluid.Sources.Boundary_pT bou1(redeclare final package Medium = MediumAir,
      nPorts=1)
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  replaceable UserProject.TerminalUnits.VAVBoxCoolingOnly ter(dat(
      id="Box_1",
      id_souAir="VAV_1",
      damVAV(dp_nominal=50),
      coiHea(
        cap_nominal=1e3,
        dpAir_nominal=75,
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
      redeclare final package MediumHea=MediumHea)
    "Terminal unit"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));

equation
  connect(bou.ports[1], res.port_a)
    annotation (Line(points={{-60,0},{-50,0}}, color={0,127,255}));
  connect(bou1.ports[1], res1.port_b)
    annotation (Line(points={{60,0},{50,0}}, color={0,127,255}));
  connect(res.port_b, ter.port_Sup)
    annotation (Line(points={{-30,0},{-20,0}}, color={0,127,255}));
  connect(ter.port_Dis, res1.port_a)
    annotation (Line(points={{20,0},{30,0}}, color={0,127,255}));
    annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end BaseVAVBoxCoolingOnly;
