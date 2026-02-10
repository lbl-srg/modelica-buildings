within Buildings.Templates.Plants.Boilers.HotWater.Validation;
model BoilerPlantOpenLoop
  "Validation of boiler plant template with open-loop controls"
  extends Modelica.Icons.Example;

  replaceable package Medium = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "HW medium";

  replaceable parameter Buildings.Templates.Plants.Boilers.HotWater.Validation.UserProject.Data.AllSystems datAll(
    pla(final cfg=pla.cfg))
    "Design and operating parameters"
    annotation(Placement(transformation(extent={{70,70},{90,90}})));
  parameter Modelica.Units.SI.Time tau = 10
    "Time constant at nominal flow"
    annotation(Dialog(tab="Dynamics",
      group="Nominal condition"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics =
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true,
      Dialog(tab="Dynamics",
        group="Conservation equations"));
  Buildings.Templates.Plants.Boilers.HotWater.BoilerPlant pla(
    redeclare final package Medium=Medium,
    redeclare replaceable Buildings.Templates.Plants.Boilers.HotWater.Components.Controls.OpenLoop ctl,
    typ=Buildings.Templates.Plants.Boilers.HotWater.Types.Boiler.NonCondensing,
    nBoiNon_select=2,
    typPumHeaWatPriNon=Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsPrimary.Variable,
    typArrPumHeaWatPriNon_select=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
    typPumHeaWatSec1_select=Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsSecondary.None,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final dat=datAll.pla)
    "Boiler plant"
    annotation(Placement(transformation(extent={{-60,-30},{-20,10}})));
  Fluid.Sources.PropertySource_T setTHeaWatRet(
    use_T_in=true,
    redeclare final package Medium=Medium)
    "Set HWRT"
    annotation(Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=90,
      origin={80,-20})));
  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare final package Medium=Medium,
    m_flow_nominal=pla.mHeaWat_flow_nominal,
    dp_nominal=datAll.pla.ctl.dpHeaWatLocSet_max)
    "Flow resistance of HW distribution system"
    annotation(Placement(transformation(extent={{20,-10},{40,10}})));
  Fluid.Sensors.TemperatureTwoPort THeaWatRet(
    redeclare final package Medium=Medium,
    final m_flow_nominal=pla.mHeaWat_flow_nominal)
    "HW return temperature"
    annotation(Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=0,
      origin={20,-40})));
  Fluid.Sensors.VolumeFlowRate VHeaWat_flow(
    redeclare final package Medium=Medium,
    final m_flow_nominal=pla.mHeaWat_flow_nominal)
    "HW volume flow rate"
    annotation(Placement(transformation(extent={{60,-50},{40,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatRetPre(
    k=pla.THeaWatRet_nominal)
    "Prescribed HWRT"
    annotation(Placement(transformation(extent={{-90,30},{-70,50}})));
equation
  connect(pla.port_b, res.port_a)
    annotation(Line(points={{-19.8,-10},{0,-10},{0,0},{20,0}},
      color={0,127,255}));
  connect(pla.port_a, THeaWatRet.port_b)
    annotation(Line(points={{-19.8,-20},{0,-20},{0,-40},{10,-40}},
      color={0,127,255}));
  connect(THeaWatRet.port_a, VHeaWat_flow.port_b)
    annotation(Line(points={{30,-40},{40,-40}},
      color={0,127,255}));
  connect(setTHeaWatRet.port_b, VHeaWat_flow.port_a)
    annotation(Line(points={{80,-30},{80,-40},{60,-40}},
      color={0,127,255}));
  connect(res.port_b, setTHeaWatRet.port_a)
    annotation(Line(points={{40,0},{80,0},{80,-10}},
      color={0,127,255}));
  connect(THeaWatRetPre.y, setTHeaWatRet.T_in)
    annotation(Line(points={{-68,40},{60,40},{60,-16},{68,-16}},
      color={0,0,127}));
annotation(__Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Boilers/HotWater/Validation/BoilerPlantOpenLoop.mos"
    "Simulate and plot"),
  experiment(Tolerance=1e-6,
    StopTime=2200.0),
  Icon(coordinateSystem(preserveAspectRatio=false)),
  Diagram(coordinateSystem(preserveAspectRatio=false,
    extent={{-100,-100},{100,100}})),
  Documentation(
    revisions="<html>
<ul>
  <li>
    November 18, 2022, by Antoine Gautier:<br />
    First implementation.
  </li>
</ul>
</html>",
    info="<html>
<p>
  This is a validation model for the boiler plant model
  <a href=\"modelica://Buildings.Templates.Plants.Boilers.HotWater.BoilerPlant\">
    Buildings.Templates.Plants.Boilers.HotWater.BoilerPlant</a> with
  open-loop controls.
</p>
<p>
  It is intended to check that the plant model is well-defined for various
  plant configurations. However, due to the open-loop controls a correct
  physical behavior is not expected.
</p>
</html>"));
end BoilerPlantOpenLoop;
