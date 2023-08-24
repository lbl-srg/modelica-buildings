within Buildings.Templates.ChilledWaterPlants.Validation;
model WaterCooledOpenLoop
  "Validation of water-cooled chiller plant template with open-loop controls"
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

  replaceable parameter
    Buildings.Templates.ChilledWaterPlants.Validation.UserProject.Data.AllSystemsWaterCooled
    datAll(
    sysUni=Buildings.Templates.Types.Units.SI,
    stdEne=Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1,
    stdVen=Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.Not_Specified,
    ashCliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Not_Specified,
    tit24CliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Not_Specified)
           constrainedby
    Buildings.Templates.ChilledWaterPlants.Validation.UserProject.Data.AllSystems
    "Design and operating parameters"
    annotation (Placement(transformation(extent={{70,70},{90,90}})));

  parameter Modelica.Units.SI.Time tau=10
    "Time constant at nominal flow"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  inner replaceable Buildings.Templates.ChilledWaterPlants.WaterCooled CHI(
    typArrChi_select=Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Parallel,
    typDisChiWat=Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1Only,
    typArrPumChiWatPri_select=Buildings.Templates.Components.Types.PumpArrangement.Headered,
    typArrPumConWat_select=Buildings.Templates.Components.Types.PumpArrangement.Headered,
    have_varPumConWat_select=true,
    ctl(
      typCtlHea=Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl.BuiltIn,
      typCtlFanCoo=Buildings.Templates.ChilledWaterPlants.Types.CoolerFanSpeedControl.SupplyTemperature,
      have_senLevCoo=false),
    chi(
      typValChiWatChiIso_select=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition,
      typValConWatChiIso_select=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition),
    redeclare replaceable
      Buildings.Templates.ChilledWaterPlants.Components.CoolerGroups.CoolingTowerOpen
      coo,
    redeclare replaceable
      Buildings.Templates.ChilledWaterPlants.Components.Economizers.None eco)
    constrainedby Buildings.Templates.ChilledWaterPlants.Interfaces.PartialChilledWaterLoop(
      redeclare final package MediumChiWat = MediumChiWat,
      redeclare replaceable package MediumCon = MediumConWat,
      chi(
        have_senTChiWatChiSup_select=true,
        have_senTChiWatChiRet=true,
        have_senTConWatChiSup=true,
        have_senTConWatChiRet_select=true),
      final nChi=nChi,
      final energyDynamics=energyDynamics,
      final tau=tau,
      final dat=datAll._CHI)
    "CHW plant"
    annotation (Placement(transformation(extent={{-60,-30},{-20,10}})));

  Fluid.Sources.Boundary_pT bou(
    redeclare final package Medium=MediumChiWat,
    p=200000,
    T=Buildings.Templates.Data.Defaults.TChiWatRet,
    nPorts=2)
    "Boundary conditions for CHW distribution system"
    annotation (Placement(transformation(extent={{90,-30},{70,-10}})));

  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare final package Medium = MediumChiWat,
    m_flow_nominal=CHI.mChiWat_flow_nominal,
    dp_nominal=datAll._CHI.ctl.dpChiWatLocSet_nominal)
    "Flow resistance of CHW distribution system"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));

  Fluid.Sensors.TemperatureTwoPort TChiWatRet(
    redeclare final package Medium =MediumChiWat,
    final m_flow_nominal=sum(datAll._CHI.chi.mChiWatChi_flow_nominal))
    "CHW return temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={20,-40})));
  Fluid.Sensors.VolumeFlowRate VChiWat_flow(
    redeclare final package Medium =MediumChiWat,
    final m_flow_nominal=sum(datAll._CHI.chi.mChiWatChi_flow_nominal))
    "CHW volume flow rate"
    annotation (Placement(transformation(extent={{60,-50},{40,-30}})));
equation
  connect(res.port_b, bou.ports[1])
    annotation (Line(points={{40,0},{70,0},{70,-21}},      color={0,127,255}));
  connect(weaDat.weaBus, CHI.busWea) annotation (Line(
      points={{-70,80},{-40,80},{-40,10}},
      color={255,204,51},
      thickness=0.5));
  connect(CHI.port_b, res.port_a)
    annotation (Line(points={{-19.8,-10},{0,-10},{0,0},{20,0}},
                                               color={0,127,255}));
  connect(CHI.port_a, TChiWatRet.port_b) annotation (Line(points={{-19.8,-20},{
          0,-20},{0,-40},{10,-40}}, color={0,127,255}));
  connect(TChiWatRet.port_a, VChiWat_flow.port_b)
    annotation (Line(points={{30,-40},{40,-40}}, color={0,127,255}));
  connect(VChiWat_flow.port_a, bou.ports[2])
    annotation (Line(points={{60,-40},{70,-40},{70,-19}}, color={0,127,255}));
  annotation (
  experiment(
    StartTime=19612800,
    StopTime=19615000,
    Tolerance=1e-06),
  __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/Templates/ChilledWaterPlants/Validation/WaterCooledOpenLoop.mos"
  "Simulate and plot"),
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
November 18, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This is a validation model for the water-cooled chiller plant model
<a href=\"modelica://Buildings.Templates.ChilledWaterPlants.WaterCooled\">
Buildings.Templates.ChilledWaterPlants.WaterCooled</a>
with open-loop controls.
</p>
<p>
It is intended to check that the plant model is well-defined for
various plant configurations.
However, due to the open-loop controls a correct physical behavior
is not expected. For instance, the coolers are commanded at maximum
speed which may yield freezing conditions in the CW loop.
</p>
</html>"));
end WaterCooledOpenLoop;
