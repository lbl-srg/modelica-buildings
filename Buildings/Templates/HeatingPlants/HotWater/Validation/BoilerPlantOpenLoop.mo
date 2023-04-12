within Buildings.Templates.HeatingPlants.HotWater.Validation;
model BoilerPlantOpenLoop
  "Validation of boiler plant template with open-loop controls"
  extends Modelica.Icons.Example;
  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "HW medium";

  replaceable parameter
    Buildings.Templates.HeatingPlants.HotWater.Validation.UserProject.Data.AllSystems
    datAll
    "Design and operating parameters"
    annotation (Placement(transformation(extent={{70,70},{90,90}})));

  parameter Modelica.Units.SI.Time tau=10
    "Time constant at nominal flow"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  inner Buildings.Templates.HeatingPlants.HotWater.BoilerPlant BOI(
    redeclare final package Medium = Medium,
    redeclare Buildings.Templates.HeatingPlants.HotWater.Components.Controls.OpenLoop ctl,
    typ=Buildings.Templates.HeatingPlants.HotWater.Types.Boiler.Hybrid,
    nBoiCon=2,
    nBoiNon=2,
    typPumHeaWatPriCon=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.Variable,
    typPumHeaWatPriNon=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.Variable,
    typArrPumHeaWatPriCon=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
    typArrPumHeaWatPriNon=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
    typPumHeaWatSec=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.Centralized,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final dat=datAll._BOI)
    "Boiler plant"
    annotation (Placement(transformation(extent={{-60,-30},{-20,10}})));

  Fluid.Sources.Boundary_pT bou(
    redeclare final package Medium=Medium,
    p=200000,
    T=Buildings.Templates.Data.Defaults.THeaWatRet,
    nPorts=2)
    "Boundary conditions for HW distribution system"
    annotation (Placement(transformation(extent={{90,-30},{70,-10}})));

  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare final package Medium = Medium,
    m_flow_nominal=BOI.mHeaWat_flow_nominal,
    dp_nominal=datAll._BOI.ctl.dpHeaWatLocSet_nominal)
    "Flow resistance of HW distribution system"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Fluid.Sensors.TemperatureTwoPort THeaWatRet(
    redeclare final package Medium =Medium,
    final m_flow_nominal=BOI.mHeaWat_flow_nominal)
    "HW return temperature"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={20,-40})));
  Fluid.Sensors.VolumeFlowRate VHeaWat_flow(
    redeclare final package Medium =Medium,
    final m_flow_nominal=BOI.mHeaWat_flow_nominal)
    "HW volume flow rate"
    annotation (Placement(transformation(extent={{60,-50},{40,-30}})));
equation
  connect(res.port_b, bou.ports[1])
    annotation (Line(points={{40,0},{70,0},{70,-21}},      color={0,127,255}));
  connect(BOI.port_b, res.port_a)
    annotation (Line(points={{-19.8,-10},{0,-10},{0,0},{20,0}},
                                               color={0,127,255}));
  connect(BOI.port_a, THeaWatRet.port_b) annotation (Line(points={{-19.8,-20},{
          0,-20},{0,-40},{10,-40}}, color={0,127,255}));
  connect(THeaWatRet.port_a, VHeaWat_flow.port_b)
    annotation (Line(points={{30,-40},{40,-40}}, color={0,127,255}));
  connect(VHeaWat_flow.port_a, bou.ports[2])
    annotation (Line(points={{60,-40},{70,-40},{70,-19}}, color={0,127,255}));
  annotation (
  experiment(
    StartTime=0,
    StopTime=2000,
    Tolerance=1e-06),
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
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
end BoilerPlantOpenLoop;
