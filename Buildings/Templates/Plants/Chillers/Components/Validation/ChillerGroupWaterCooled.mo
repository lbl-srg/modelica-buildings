within Buildings.Templates.Plants.Chillers.Components.Validation;
model ChillerGroupWaterCooled
  "Validation model for water-cooled chiller group"
  extends Buildings.Templates.Plants.Chillers.Components.Validation.ChillerGroupAirCooled(
    chi(
      redeclare final package MediumCon=MediumConWat,
      final typ=Buildings.Templates.Components.Types.Chiller.WaterCooled),
    datChi(
      final typ=Buildings.Templates.Components.Types.Chiller.WaterCooled,
      final mConWatChi_flow_nominal=mConWatChi_flow_nominal,
      final dpConChi_nominal=dpConWatChi_nominal,
      final TConWatChi_nominal=fill(TConWatRet_nominal, nChi),
      perChi(
        each fileName=Modelica.Utilities.Files.loadResource(
          "modelica://Buildings/Resources/Data/Fluid/Chillers/ModularReversible/Validation/McQuay_WSC_471kW_5_89COP_Vanes.txt"),
        each PLRSup={0.1, 0.43, 0.75, 1., 1.08},
        each devIde="McQuay_WSC_471kW_5_89COP_Vanes",
        each use_TEvaOutForTab=true,
        each use_TConOutForTab=true)));

  replaceable package MediumConWat = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CW medium";

  parameter Modelica.Units.SI.MassFlowRate mConWatChi_flow_nominal[nChi] =
    capChi_nominal * (1 + 1 / Buildings.Templates.Data.Defaults.COPChiWatCoo) /
    Buildings.Utilities.Psychrometrics.Constants.cpWatLiq /
    (TConWatRet_nominal - TConWatSup_nominal)
    "CW mass flow rate - Each water-cooled chiller"
    annotation(Evaluate=true,
      Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mConWat_flow_nominal = sum(
    mConWatChi_flow_nominal)
    "CW mass flow rate (total)"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpConWatChi_nominal[nChi] =
    fill(Buildings.Templates.Data.Defaults.dpConWatChi, nChi)
    "WSE CHW pressure drop"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TConWatSup_nominal =
    Buildings.Templates.Data.Defaults.TConWatSup
    "CW supply temperature";
  parameter Modelica.Units.SI.Temperature TConWatRet_nominal =
    Buildings.Templates.Data.Defaults.TConWatRet
    "CW return temperature";
  parameter Buildings.Templates.Components.Data.PumpMultiple datPumChiWatPri(
    final typ=Buildings.Templates.Components.Types.Pump.Multiple,
    final nPum=nChi,
    final m_flow_nominal=mChiWatChi_flow_nominal,
    dp_nominal=1.5 * dpChiWatChi_nominal)
    "Parameter record for primary CHW pumps";
  parameter Buildings.Templates.Components.Data.PumpMultiple datPumConWat(
    final typ=Buildings.Templates.Components.Types.Pump.Multiple,
    final nPum=nChi,
    final m_flow_nominal=mConWatChi_flow_nominal,
    dp_nominal=1.5 * dpConWatChi_nominal)
    "Parameter record for CW pumps";
  Fluid.Sources.PropertySource_T tow(
    redeclare final package Medium=MediumConWat,
    final use_T_in=true)
    "Ideal cooling to input set point (representing cooling tower)"
    annotation(Placement(transformation(extent={{-230,-90},{-210,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TConWat(
    final k=TConWatSup_nominal)
    "CW supply temperature set point"
    annotation(Placement(transformation(extent={{-250,130},{-230,150}})));
  Buildings.Templates.Components.Pumps.Multiple pumConWat(
    redeclare final package Medium=MediumConWat,
    final dat=datPumConWat,
    final nPum=nChi,
    final have_var=false,
    final energyDynamics=energyDynamics)
    "CW pumps"
    annotation(Placement(transformation(extent={{-180,-90},{-160,-70}})));
  Buildings.Templates.Components.Routing.SingleToMultiple inlPumConWat(
    redeclare final package Medium=MediumConWat,
    final nPorts=nChi,
    final m_flow_nominal=mConWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "CW pumps inlet manifold"
    annotation(Placement(transformation(extent={{-200,-90},{-180,-70}})));
  Buildings.Templates.Components.Routing.SingleToMultiple outConWatChi(
    redeclare final package Medium=MediumConWat,
    final nPorts=nChi,
    final m_flow_nominal=mConWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Chiller group CW outlet manifold"
    annotation(Placement(transformation(extent={{-160,102},{-140,122}})));
  Fluid.Sources.Boundary_pT bouCon(
    redeclare final package Medium=MediumConWat,
    nPorts=1)
    "CW pressure boundary condition"
    annotation(Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=-90,
      origin={-200,-110})));
  Buildings.Templates.Components.Routing.MultipleToMultiple outPumConWat(
    redeclare final package Medium=MediumConWat,
    nPorts_a=nChi,
    final m_flow_nominal=mConWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "CW pumps outlet manifold"
    annotation(Placement(transformation(extent={{-160,-90},{-140,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yValConWatChiIso[nChi](
    each k=1)
    if chi.typValConWatChiIso ==
      Buildings.Templates.Components.Types.Valve.TwoWayModulating
    "Chiller CW isolation valve opening signal"
    annotation(Placement(transformation(extent={{-10,270},{-30,290}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValConWatChiIso[nChi](
    each table=[0, 0; 1, 0; 1, 1; 2, 1],
    each timeScale=1000,
    each period=2000)
    if chi.typValConWatChiIso ==
      Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
    "Chiller CW isolation valve opening signal"
    annotation(Placement(transformation(extent={{20,290},{0,310}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1PumConWat[nChi](
    each table=[0, 0; 1, 0; 1, 1; 2, 1],
    each timeScale=1000,
    each period=2000)
    "CW pump Start/Stop signal"
    annotation(Placement(transformation(extent={{-10,190},{-30,210}})));
  protected
  Buildings.Templates.Components.Interfaces.Bus busValConWatChiIso[nChi]
    "Chiller CW isolation valve control bus"
    annotation(Placement(transformation(extent={{-80,260},{-40,300}}),
      iconTransformation(extent={{-756,150},{-716,190}})));
  Buildings.Templates.Components.Interfaces.Bus busPumConWat
    "CW pumps control bus"
    annotation(Placement(transformation(extent={{-80,180},{-40,220}}),
      iconTransformation(extent={{-316,184},{-276,224}})));
equation
  connect(TConWat.y, tow.T_in)
    annotation(Line(points={{-228,140},{-224,140},{-224,-68}},
      color={0,0,127}));
  connect(tow.port_b, inlPumConWat.port_a)
    annotation(Line(points={{-210,-80},{-200,-80}},
      color={0,127,255}));
  connect(pumConWat.ports_a, inlPumConWat.ports_b)
    annotation(Line(points={{-180,-80},{-180,-80}},
      color={0,127,255}));
  connect(outConWatChi.port_a, tow.port_a)
    annotation(Line(points={{-160,112},{-240,112},{-240,-80},{-230,-80}},
      color={0,127,255}));
  connect(pumConWat.ports_b, outPumConWat.ports_a)
    annotation(Line(points={{-160,-80},{-160,-80}},
      color={0,127,255}));
  connect(tow.port_b, bouCon.ports[1])
    annotation(Line(points={{-210,-80},{-200,-80},{-200,-100}},
      color={0,127,255}));
  connect(y1ValConWatChiIso.y[1], busValConWatChiIso.y1)
    annotation(Line(points={{-2,300},{-60,300},{-60,280}},
      color={255,0,255}));
  connect(yValConWatChiIso.y, busValConWatChiIso.y)
    annotation(Line(points={{-32,280},{-60,280}},
      color={0,0,127}));
  connect(chi.ports_bCon, outConWatChi.ports_b)
    annotation(Line(points={{-140,112},{-140,112}},
      color={0,127,255}));
  connect(outPumConWat.ports_b, chi.ports_aCon)
    annotation(Line(points={{-140,-80},{-140,-80}},
      color={0,127,255}));
  connect(busValConWatChiIso, busPla.valConWatChiIso)
    annotation(Line(points={{-60,280},{-100,280},{-100,140}},
      color={255,204,51},
      thickness=0.5));
  connect(y1PumConWat.y[1], busPumConWat.y1)
    annotation(Line(points={{-32,200},{-60,200}},
      color={255,0,255}));
  connect(busPumConWat, busPla.pumConWat)
    annotation(Line(points={{-60,200},{-100,200},{-100,140}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla.pumConWat, pumConWat.bus)
    annotation(Line(points={{-100,140},{-170,140},{-170,-70}},
      color={255,204,51},
      thickness=0.5));
annotation(experiment(StopTime=2000,
  Tolerance=1e-06),
  __Dymola_Commands(
    file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Chillers/Components/Validation/ChillerGroupWaterCooled.mos"
      "Simulate and plot"),
  Documentation(
    info="<html>
<p>
  This model validates the chiller group model
  <a href=\"modelica://Buildings.Templates.Plants.Chillers.Components.ChillerGroups.Compression\">
    Buildings.Templates.Plants.Chillers.Components.ChillerGroups.Compression</a>
  for water-cooled chillers.
</p>
<p>
  The validation uses open-loop controls and tests a single system
  configuration. The controls are automatically configured (by means of
  parameters bindings with the chiller group component parameters) to provide
  the necessary signals for any system configuration. To test a different
  system configuration, one needs only to modify the chiller group component.
</p>
</html>",
    revisions="<html>
<ul>
  <li>
    April 17, 2025, by Antoine Gautier:<br />
    First implementation.
  </li>
</ul>
</html>"));
end ChillerGroupWaterCooled;
