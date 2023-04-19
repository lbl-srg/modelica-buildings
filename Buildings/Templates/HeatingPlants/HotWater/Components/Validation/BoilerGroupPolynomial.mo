within Buildings.Templates.HeatingPlants.HotWater.Components.Validation;
model BoilerGroupPolynomial "Validation model for boiler group"
  extends Modelica.Icons.Example;

  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "HW medium";

  parameter Integer nBoi(final min=0) = 3
    "Number of boilers";
  final parameter Modelica.Units.SI.MassFlowRate mHeaWat_flow_nominal=
    sum(datBoi.mHeaWatBoi_flow_nominal)
    "HW mass flow rate"
    annotation (Dialog(group="Nominal condition"));

  parameter Buildings.Templates.HeatingPlants.HotWater.Components.Data.BoilerGroup datBoi(
    final typMod=boi.typMod,
    final nBoi=nBoi,
    fue=Buildings.Fluid.Data.Fuels.NaturalGasLowerHeatingValue(),
    mHeaWatBoi_flow_nominal=datBoi.capBoi_nominal/
      (Buildings.Templates.Data.Defaults.THeaWatSup - Buildings.Templates.Data.Defaults.THeaWatRet) /
      Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    capBoi_nominal=fill(1000E3, nBoi),
    dpHeaWatBoi_nominal=fill(Buildings.Templates.Data.Defaults.dpHeaWatBoi, nBoi),
    THeaWatBoiSup_nominal=fill(Buildings.Templates.Data.Defaults.THeaWatSup, nBoi))
    "Design and operating parameters"
    annotation (Placement(transformation(extent={{180,180},{200,200}})));
  parameter Buildings.Templates.Components.Data.PumpMultiple datPumHeaWatPri(
    final typ=Buildings.Templates.Components.Types.Pump.Multiple,
    final nPum=nBoi,
    final m_flow_nominal=fill(mHeaWat_flow_nominal/datPumHeaWatPri.nPum, datPumHeaWatPri.nPum),
    dp_nominal=datBoi.dpHeaWatBoi_nominal .+ Buildings.Templates.Data.Defaults.dpValChe)
    "Parameter record for primary HW pumps";
  parameter Modelica.Units.SI.Time tau=10
    "Time constant at nominal flow"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  Buildings.Templates.HeatingPlants.HotWater.Components.BoilerGroup boi(
    redeclare final package Medium=Medium,
    final nBoi=nBoi,
    typMod=Buildings.Templates.Components.Types.BoilerHotWaterModel.Polynomial,
    final is_con=true,
    typArrPumHeaWatPri=Buildings.Templates.Components.Types.PumpArrangement.Headered,
    final dat=datBoi,
    final energyDynamics=energyDynamics)
    "Boiler group"
    annotation (Placement(transformation(extent={{-120,-60},{-40,60}})));
  Buildings.Templates.Components.Pumps.Multiple pumHeaWatPri(
    have_var=false,
    have_valChe=true,
    final nPum=nBoi,
    final dat=datPumHeaWatPri,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Primary HW pumps"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Buildings.Templates.Components.Routing.MultipleToMultiple inlPumHeaWatPri(
    redeclare final package Medium=Medium,
    final nPorts_a=nBoi,
    final have_comLeg=boi.typArrPumHeaWatPri==Buildings.Templates.Components.Types.PumpArrangement.Headered,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final energyDynamics=energyDynamics)
    "Primary HW pumps inlet manifold"
    annotation (Placement(transformation(extent={{-30,30},{-10,50}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumHeaWatPri(
    redeclare final package Medium=Medium,
    final nPorts=nBoi,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final energyDynamics=energyDynamics)
    "Primary HW pumps outlet manifold"
    annotation (Placement(transformation(extent={{30,30},{50,50}})));
  Fluid.Sensors.TemperatureTwoPort THeaWatSup(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mHeaWat_flow_nominal)
    "HW supply temperature"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  Fluid.Sensors.MassFlowRate mHeaWat_flow(
    redeclare final package Medium=Medium) "HW mass flow rate"
    annotation (Placement(transformation(extent={{90,30},{110,50}})));
  Fluid.Sources.Boundary_pT bouHeaWat(
    redeclare final package Medium = Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_min,
    T=Buildings.Templates.Data.Defaults.THeaWatRet,
    nPorts=2) "Boundary conditions for HW distribution system"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={60,-60})));
  Fluid.Sensors.TemperatureTwoPort THeaWatRet(
    redeclare final package Medium =Medium,
    final m_flow_nominal=mHeaWat_flow_nominal)
    "HW return temperature"
    annotation (Placement(transformation(extent={{30,-50},{10,-30}})));
  Buildings.Templates.Components.Routing.SingleToMultiple inlBoi(
    redeclare final package Medium = Medium,
    final nPorts=nBoi,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final energyDynamics=energyDynamics)
    "Boiler group inlet manifold"
    annotation (Placement(transformation(extent={{-10,-50},{-30,-30}})));
  Controls.OpenLoop ctl(
    final have_boiCon=true,
    final have_boiNon=false,
    final nBoiCon=nBoi,
    final nBoiNon=0,
    final typArrPumHeaWatPriCon=boi.typArrPumHeaWatPri,
    final have_varPumHeaWatPriCon=pumHeaWatPri.have_var,
    final have_varPumHeaWatPriNon=false,
    final typPumHeaWatSec=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None,
    have_valHeaWatMinBypCon=false,
    have_valHeaWatMinBypNon=false,
    dat(
      THeaWatSup_nominal=Buildings.Templates.Data.Defaults.THeaWatSup,
      sta={fill(0, nBoi)}))
    "Controller"
    annotation (Placement(transformation(extent={{-10,150},{10,170}})));

  Buildings.Templates.HeatingPlants.HotWater.Interfaces.Bus busPla
    "Plant control bus"
    annotation (Placement(transformation(extent={{-100,100},
     {-60,140}}),  iconTransformation(extent={{-310,60},{-270,100}})));

equation
  connect(inlPumHeaWatPri.ports_b, pumHeaWatPri.ports_a)
    annotation (Line(points={{-10,40},{0,40}},   color={0,127,255}));
  connect(boi.ports_bHeaWat, inlPumHeaWatPri.ports_a)
    annotation (Line(points={{-40,40},{-30,40}},   color={0,127,255}));
  connect(outPumHeaWatPri.port_b, THeaWatSup.port_a)
    annotation (Line(points={{50,40},{60,40}},   color={0,127,255}));
  connect(THeaWatSup.port_b, mHeaWat_flow.port_a)
    annotation (Line(points={{80,40},{90,40}},color={0,127,255}));
  connect(inlBoi.ports_b, boi.ports_aHeaWat)
    annotation (Line(points={{-30,-40},{-40,-40}},   color={0,127,255}));
  connect(THeaWatRet.port_b, inlBoi.port_a)
    annotation (Line(points={{10,-40},{-10,-40}},  color={0,127,255}));
  connect(ctl.bus, busPla) annotation (Line(
      points={{-10,160},{-80,160},{-80,120}},
      color={255,204,51},
      thickness=0.5));
  connect(pumHeaWatPri.ports_b, outPumHeaWatPri.ports_a)
    annotation (Line(points={{20,40},{30,40}},   color={0,127,255}));
  connect(mHeaWat_flow.port_b, bouHeaWat.ports[1]) annotation (Line(points={{110,40},
          {120,40},{120,-40},{59,-40},{59,-50}},     color={0,127,255}));
  connect(bouHeaWat.ports[2], THeaWatRet.port_a) annotation (Line(points={{61,-50},
          {61,-40},{30,-40}},        color={0,127,255}));
  connect(busPla, boi.bus) annotation (Line(
      points={{-80,120},{-80,60}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla.pumHeaWatPriCon, pumHeaWatPri.bus) annotation (Line(
      points={{-80,120},{10,120},{10,50}},
      color={255,204,51},
      thickness=0.5));
  annotation (
  Diagram(coordinateSystem(extent={{-220,-220},{220,220}})),
  experiment(
    StopTime=2000,
    Tolerance=1e-06),
  __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/Templates/HeatingPlants/HotWater/Components/Validation/BoilerGroupPolynomial.mos"
  "Simulate and plot"),
  Documentation(info="<html>
<p>
FIXME: Bug in Dymola #SR01004314-01.
The parameters inside pumHeaWatPri.dat are left unassigned and the start value
is used instead without any warning being issued.
OCT properly propagates the parameter values from the composite component binding.
</p>
<p>
This model validates the boiler group model
<a href=\"modelica://Buildings.Templates.HeatingPlants.HotWater.Components.BoilerGroups.BoilerGroupPolynomial\">
Buildings.Templates.HeatingPlants.HotWater.Components.BoilerGroups.BoilerGroupPolynomial</a>.
</p>
</html>"));
end BoilerGroupPolynomial;
