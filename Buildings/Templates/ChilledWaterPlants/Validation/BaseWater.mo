within Buildings.Templates.ChilledWaterPlants.Validation;
model BaseWater
  extends Modelica.Icons.Example;
  replaceable package MediumChiWat=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW medium";
  replaceable package MediumConWat=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CW medium";
  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium";

  parameter Integer nChi=2
    "Number of chillers"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Integer nCoo=nChi
    "Number of cooler units"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Integer nPumChiWatSec=nChi
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement typArrChi=Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement
      .Series;
  parameter Buildings.Templates.Components.Types.Chiller typChi=Buildings.Templates.Components.Types.Chiller.WaterCooled;
  parameter Buildings.Templates.Components.Types.Cooler typCoo=
    Buildings.Templates.Components.Types.Cooler.CoolingTowerOpen;
  parameter Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement typArrPumChiWatPri=
    Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement.Dedicated;
  parameter Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement typArrPumConWat=
   Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement.Dedicated;
  parameter Buildings.Templates.ChilledWaterPlants.Types.Economizer typEco=
    Buildings.Templates.ChilledWaterPlants.Types.Economizer.None;
  parameter Buildings.Templates.ChilledWaterPlants.Types.Distribution typDisChiWat=Buildings.Templates.ChilledWaterPlants.Types.Distribution.
      Variable1Only;

  parameter Buildings.Templates.ChilledWaterPlants.Validation.UserProject.Data.AllSystems dat(
    CHI(
      final nChi=CHI.nChi,
      final nCoo=CHI.nCoo,
      final typChi=CHI.typChi,
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
      redeclare final package MediumChiWat = MediumChiWat,
    redeclare replaceable package MediumCon = MediumConWat,
      final nChi=nChi,
      final energyDynamics=energyDynamics,
      final tau=tau,
      final typArrChi_select=typArrChi,
      final typDisChiWat=typDisChiWat,
      final typArrPumChiWatPri_select=typArrPumChiWatPri,
      final typArrPumConWat_select=typArrPumConWat,
      typCtrSpePumConWat_select=Buildings.Templates.Components.Types.PumpSingleSpeedControl.Constant,
      typCtrHea=Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl.None,
      final typEco=typEco,
      final dat=dat.CHI,
      chi(typValChiWatIso_select=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition,
          typValConWatIso_select=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition),
    redeclare
      Buildings.Templates.ChilledWaterPlants.Components.CoolerGroups.CoolingTowerOpen
      coo)
    "CHW plant"
    annotation (Placement(transformation(extent={{-42,-30},{-2,10}})));

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
      points={{-60,80},{-22,80},{-22,10}},
      color={255,204,51},
      thickness=0.5));
  connect(CHI.port_a, bou.ports[2]) annotation (Line(points={{-1.8,-20.2},{60,-20.2},
          {60,-9}},       color={0,127,255}));
  connect(CHI.port_b, res.port_a)
    annotation (Line(points={{-1.8,0},{20,0}}, color={0,127,255}));
  annotation (
  experiment(Tolerance=1e-6, StopTime=1),
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end BaseWater;
