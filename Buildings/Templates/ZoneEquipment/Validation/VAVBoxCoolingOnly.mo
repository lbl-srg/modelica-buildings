within Buildings.Templates.ZoneEquipment.Validation;
model VAVBoxCoolingOnly
  extends Modelica.Icons.Example;

  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium";

  replaceable package MediumHea=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Heating medium (such as HHW)";

  Fluid.Sources.Boundary_pT bou(redeclare final package Medium = MediumAir,
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
  replaceable UserProject.TerminalUnits.VAVBoxCoolingOnly ter constrainedby
    Buildings.Templates.ZoneEquipment.Interfaces.PartialAirTerminal(
      redeclare final package MediumAir = MediumAir)
    "Terminal unit"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));
  inner parameter ExternData.JSONFile dat(fileName=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Templates/Validation/systems.json"))
    annotation (
      Evaluate=true,
      Placement(transformation(extent={{76,76},{96,96}})));
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
end VAVBoxCoolingOnly;
