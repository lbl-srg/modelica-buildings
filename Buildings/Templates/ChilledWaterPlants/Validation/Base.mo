within Buildings.Templates.ChilledWaterPlants.Validation;
model Base
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
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Buildings.Templates.ChilledWaterPlants.Validation.UserProject.Data.AllSystems dat(
    CHI(
      final typChi=CHI.typChi,
      final nChi=CHI.nChi,
      final typDisChiWat=CHI.typDisChiWat,
      final have_pumChiWatSec=CHI.have_pumChiWatSec,
      final nPumChiWatSec=CHI.nPumChiWatSec,
      final typCoo=CHI.typCoo,
      final nCoo=CHI.nCoo,
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

  replaceable Buildings.Templates.ChilledWaterPlants.AirCooled CHI
    constrainedby Buildings.Templates.ChilledWaterPlants.Interfaces.PartialChilledWaterLoop(
      redeclare final package MediumChiWat = MediumChiWat,
      redeclare replaceable package MediumCon = MediumConWat,
      final nChi=nChi,
      final energyDynamics=energyDynamics,
      final tau=tau,
      typArrChi_select=Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Parallel,
      typDisChiWat=Buildings.Templates.ChilledWaterPlants.Types.Distribution.Constant1Only,
      typArrPumChiWatPri_select=Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement.Headered,
      typArrPumConWat_select=Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement.Headered,
      typCtrSpePumConWat_select=Buildings.Templates.Components.Types.PumpSingleSpeedControl.Constant,
      typCtrHea=Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl.None,
      typEco=Buildings.Templates.ChilledWaterPlants.Types.Economizer.None,
      final dat=dat.CHI,
      chi(typValChiWatIso_select=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition,
          typValConWatIso_select=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition))
    "CHW plant"
    annotation (Placement(transformation(extent={{-40,-30},{0,10}})));

  Fluid.Sources.Boundary_pT bou(
    redeclare final package Medium=MediumChiWat,
    p=200000,
    nPorts=3)
    "Boundary conditions for CHW distribution system"
    annotation (Placement(transformation(extent={{80,-20},{60,0}})));

  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare final package Medium = MediumChiWat,
    m_flow_nominal=CHI.mChiWat_flow_nominal,
    dp_nominal=dat.dpChiWatDis_nominal)
    "Flow resistance of CHW distribution system"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Fluid.Sensors.Pressure pDem(
    redeclare final package Medium=MediumChiWat) "Demand side pressure"
    annotation (Placement(transformation(extent={{70,30},{50,50}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{-70,70},{-50,90}})));


equation
  connect(res.port_b, bou.ports[1])
    annotation (Line(points={{40,0},{60,0},{60,-11.3333}}, color={0,127,255}));
  connect(bou.ports[2], pDem.port)
    annotation (Line(points={{60,-10},{60,30}}, color={0,127,255}));
  connect(weaDat.weaBus, CHI.busWea) annotation (Line(
      points={{-50,80},{-20,80},{-20,10}},
      color={255,204,51},
      thickness=0.5));
  connect(res.port_a, CHI.port_b)
    annotation (Line(points={{20,0},{0.2,0}}, color={0,127,255}));
  connect(CHI.port_a, bou.ports[3]) annotation (Line(points={{0.2,-20.2},{60,-20.2},
          {60,-8.66667}}, color={0,127,255}));
  annotation (
  experiment(Tolerance=1e-6, StopTime=1),
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Base;
