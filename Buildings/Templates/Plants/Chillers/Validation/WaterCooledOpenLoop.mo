within Buildings.Templates.Plants.Chillers.Validation;
model WaterCooledOpenLoop
  "Validation of water-cooled chiller plant template with open-loop controls"
  extends Modelica.Icons.Example;
  replaceable package MediumChiWat=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW medium";
  replaceable package MediumConWat=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CW medium";

  replaceable parameter
    Buildings.Templates.Plants.Chillers.Validation.UserProject.Data.AllSystemsWaterCooled
    datAll(pla(cfg=pla.cfg))
    "Design and operating parameters"
    annotation (Placement(transformation(extent={{70,70},{90,90}})));

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  replaceable Buildings.Templates.Plants.Chillers.WaterCooled pla(
    typArrPumConWat_select=Buildings.Templates.Components.Types.PumpArrangement.Headered,
    have_pumConWatVar_select=true,
    ctl(
      typCtlHea=Buildings.Templates.Plants.Chillers.Types.ChillerLiftControl.BuiltIn,
      typCtlFanCoo=Buildings.Templates.Plants.Chillers.Types.CoolerFanSpeedControl.SupplyTemperature,
      have_senLevCoo=false),
    chi(
      typValConWatChiIso_select=Buildings.Templates.Components.Types.Valve.TwoWayModulating),
    redeclare replaceable
      Buildings.Templates.Plants.Chillers.Components.CoolerGroups.CoolingTowerOpen
      coo,
    redeclare replaceable
      Buildings.Templates.Plants.Chillers.Components.Economizers.None eco)
    constrainedby Buildings.Templates.Plants.Chillers.Interfaces.PartialChilledWaterLoop(
      redeclare final package MediumChiWat = MediumChiWat,
      redeclare replaceable package MediumCon = MediumConWat,
      nChi=2,
      chi(
        have_senTChiWatChiSup_select=true,
        have_senTChiWatChiRet=true,
        have_senTConWatChiSup=true,
        have_senTConWatChiRet_select=true),
      final energyDynamics=energyDynamics,
      final dat=datAll.pla)
    "CHW plant"
    annotation (Placement(transformation(extent={{-60,-30},{-20,10}})));

  Fluid.Sources.PropertySource_T proSou(use_T_in=true,
    redeclare final package Medium=MediumChiWat)
    "Boundary conditions for CHW distribution system"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={80,-20})));

  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare final package Medium = MediumChiWat,
    m_flow_nominal=pla.mChiWat_flow_nominal,
    dp_nominal=datAll.pla.ctl.dpChiWatLocSet_max)
    "Flow resistance of CHW distribution system"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));

  Fluid.Sensors.TemperatureTwoPort TChiWatRet(
    redeclare final package Medium =MediumChiWat,
    final m_flow_nominal=sum(datAll.pla.chi.mChiWatChi_flow_nominal))
    "CHW return temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={20,-40})));
  Fluid.Sensors.VolumeFlowRate VChiWat_flow(
    redeclare final package Medium =MediumChiWat,
    final m_flow_nominal=sum(datAll.pla.chi.mChiWatChi_flow_nominal))
    "CHW volume flow rate"
    annotation (Placement(transformation(extent={{60,-50},{40,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatRetPre(k=pla.TChiWatRet_nominal)
    "Prescribed CHW return temperatue"
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));
equation
  connect(weaDat.weaBus,pla. busWea) annotation (Line(
      points={{-70,80},{-40,80},{-40,10}},
      color={255,204,51},
      thickness=0.5));
  connect(pla.port_b, res.port_a)
    annotation (Line(points={{-19.8,-10},{0,-10},{0,0},{20,0}}, color={0,127,255}));
  connect(pla.port_a, TChiWatRet.port_b) annotation (Line(points={{-19.8,-20},{
          0,-20},{0,-40},{10,-40}}, color={0,127,255}));
  connect(TChiWatRet.port_a, VChiWat_flow.port_b)
    annotation (Line(points={{30,-40},{40,-40}}, color={0,127,255}));
  connect(res.port_b, proSou.port_a)
    annotation (Line(points={{40,0},{80,0},{80,-10}}, color={0,127,255}));
  connect(VChiWat_flow.port_a, proSou.port_b)
    annotation (Line(points={{60,-40},{80,-40},{80,-30}}, color={0,127,255}));
  connect(TChiWatRetPre.y, proSou.T_in) annotation (Line(points={{-68,40},{60,40},
          {60,-16},{68,-16}}, color={0,0,127}));
  annotation (
  experiment(
    StartTime=19612800,
    StopTime=19615000,
    Tolerance=1e-06),
  __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Chillers/Validation/WaterCooledOpenLoop.mos"
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
<a href=\"modelica://Buildings.Templates.Plants.Chillers.WaterCooled\">
Buildings.Templates.Plants.Chillers.WaterCooled</a>
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
