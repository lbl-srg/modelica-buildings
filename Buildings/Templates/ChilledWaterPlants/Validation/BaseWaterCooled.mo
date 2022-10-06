within Buildings.Templates.ChilledWaterPlants.Validation;
model BaseWaterCooled "Base model for validating CHW plant template with water-cooled chillers"
  extends Modelica.Icons.Example;
  replaceable package MediumChiWat=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW medium";
  replaceable package MediumConWat=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CW medium";

  parameter Integer nChi=2
    "Number of chillers"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Integer nPumChiWatPri=nChi
    "Number of primary CHW pumps"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Integer nPumConWat=nChi
    "Number of CW pumps"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Integer nCoo=nChi
    "Number of cooler units"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Integer nPumChiWatSec=nChi
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Buildings.Templates.ChilledWaterPlants.Validation.UserProject.Data.AllSystems dat(
    CHI(
      final nChi=CHI.nChi,
      final nPumChiWatPri=nPumChiWatPri,
      final nPumConWat=nPumConWat,
      final nCoo=CHI.nCoo,
      final typChi=CHI.typChi,
      final typEco=CHI.typEco,
      final typDisChiWat=CHI.typDisChiWat,
      final nPumChiWatSec=CHI.nPumChiWatSec,
      final typCoo=CHI.typCoo,
      final typCtrSpePumConWat=CHI.typCtrSpePumConWat))
    "Design and operating parameters"
    annotation (Placement(transformation(extent={{70,72},{90,92}})));

  parameter Modelica.Units.SI.Time tau=10
    "Time constant at nominal flow"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  replaceable Buildings.Templates.ChilledWaterPlants.WaterCooled CHI(
    typArrChi_select=Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Parallel,
    typDisChiWat=Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1Only,
    typArrPumChiWatPri_select=Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement.Dedicated,
    typArrPumConWat_select=Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement.Dedicated,
    typCtrSpePumConWat_select=Buildings.Templates.Components.Types.PumpSingleSpeedControl.Variable,
    typCtrHea=Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl.BuiltIn,
    chi(typValChiWatIso_select=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition,
    typValConWatIso_select=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition),
    redeclare replaceable
    Buildings.Templates.ChilledWaterPlants.Components.CoolerGroups.CoolingTowerOpen
    coo,
    redeclare replaceable Buildings.Templates.ChilledWaterPlants.Components.Economizers.None eco)
    constrainedby Buildings.Templates.ChilledWaterPlants.Interfaces.PartialChilledWaterLoop(
    redeclare final package MediumChiWat = MediumChiWat,
    redeclare replaceable package MediumCon = MediumConWat,
    final nChi=nChi,
    final nPumChiWatPri=nPumChiWatPri,
    final nPumConWat=nPumConWat,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final dat=dat.CHI)
    "CHW plant"
    annotation (Placement(transformation(extent={{-40,-30},{0,10}})));

  Fluid.Sources.Boundary_pT bou(
    redeclare final package Medium=MediumChiWat,
    p=200000,
    nPorts=2)
    "Boundary conditions for CHW distribution system"
    annotation (Placement(transformation(extent={{80,-20},{60,0}})));

  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare final package Medium = MediumChiWat,
    m_flow_nominal=CHI.mChiWat_flow_nominal,
    dp_nominal=dat.dpChiWatDis_nominal)
    "Flow resistance of CHW distribution system"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

equation
  connect(res.port_b, bou.ports[1])
    annotation (Line(points={{40,0},{60,0},{60,-11}},      color={0,127,255}));
  connect(weaDat.weaBus, CHI.busWea) annotation (Line(
      points={{-60,80},{-20,80},{-20,10}},
      color={255,204,51},
      thickness=0.5));
  connect(CHI.port_a, bou.ports[2]) annotation (Line(points={{0.2,-20.2},{60,-20.2},
          {60,-9}},       color={0,127,255}));
  connect(CHI.port_b, res.port_a)
    annotation (Line(points={{0.2,0},{20,0}},  color={0,127,255}));
  annotation (
  experiment(Tolerance=1e-6, StopTime=1),
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end BaseWaterCooled;
