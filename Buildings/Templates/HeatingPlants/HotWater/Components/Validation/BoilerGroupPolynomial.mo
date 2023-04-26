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
    annotation (Placement(transformation(extent={{100,100},{120,120}})));
  parameter Buildings.Templates.Components.Data.PumpMultiple datPumHeaWatPri(
    final typ=Buildings.Templates.Components.Types.Pump.Multiple,
    final nPum=nBoi,
    final m_flow_nominal=fill(mHeaWat_flow_nominal/datPumHeaWatPri.nPum, datPumHeaWatPri.nPum),
    dp_nominal=datBoi.dpHeaWatBoi_nominal .+
      Buildings.Templates.Data.Defaults.dpValChe .+
      Buildings.Templates.Data.Defaults.dpValIso)
    "Parameter record for primary HW pumps"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));
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
    annotation (Placement(transformation(extent={{-120,-100},{-40,20}})));
  Buildings.Templates.Components.Pumps.Multiple pumHeaWatPri(
    have_var=false,
    have_valChe=true,
    final nPum=nBoi,
    final dat=datPumHeaWatPri,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Primary HW pumps"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Templates.Components.Routing.MultipleToMultiple inlPumHeaWatPri(
    redeclare final package Medium=Medium,
    final nPorts_a=nBoi,
    final have_comLeg=boi.typArrPumHeaWatPri==Buildings.Templates.Components.Types.PumpArrangement.Headered,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final energyDynamics=energyDynamics)
    "Primary HW pumps inlet manifold"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumHeaWatPri(
    redeclare final package Medium=Medium,
    final nPorts=nBoi,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final energyDynamics=energyDynamics)
    "Primary HW pumps outlet manifold"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Fluid.Sensors.TemperatureTwoPort THeaWatSup(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mHeaWat_flow_nominal)
    "HW supply temperature"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Fluid.Sensors.MassFlowRate mHeaWat_flow(
    redeclare final package Medium=Medium) "HW mass flow rate"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Fluid.Sources.Boundary_pT bouHeaWat(
    redeclare final package Medium = Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_min,
    T=Buildings.Templates.Data.Defaults.THeaWatRet,
    nPorts=2) "Boundary conditions for HW distribution system"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={60,-100})));
  Fluid.Sensors.TemperatureTwoPort THeaWatRet(
    redeclare final package Medium =Medium,
    final m_flow_nominal=mHeaWat_flow_nominal)
    "HW return temperature"
    annotation (Placement(transformation(extent={{30,-90},{10,-70}})));
  Buildings.Templates.Components.Routing.SingleToMultiple inlBoi(
    redeclare final package Medium = Medium,
    final nPorts=nBoi,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final energyDynamics=energyDynamics)
    "Boiler group inlet manifold"
    annotation (Placement(transformation(extent={{-10,-90},{-30,-70}})));
  Controls.OpenLoop ctl(
    final have_boiCon=true,
    final have_boiNon=false,
    final nBoiCon=nBoi,
    final nBoiNon=0,
    final typPumHeaWatPriCon=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.Variable,
    final typArrPumHeaWatPriCon=boi.typArrPumHeaWatPri,
    final typPumHeaWatSec=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None,
    have_valHeaWatMinBypCon=false,
    have_valHeaWatMinBypNon=false,
    dat(
      THeaWatSup_nominal=Buildings.Templates.Data.Defaults.THeaWatSup,
      sta={fill(0, nBoi)}))
    "Controller"
    annotation (Placement(transformation(extent={{-10,110},{10,130}})));

  Buildings.Templates.HeatingPlants.HotWater.Interfaces.Bus busPla
    "Plant control bus"
    annotation (Placement(transformation(extent={{-100,60},{-60,100}}),
                   iconTransformation(extent={{-310,60},{-270,100}})));

equation
  connect(inlPumHeaWatPri.ports_b, pumHeaWatPri.ports_a)
    annotation (Line(points={{-10,0},{0,0}},     color={0,127,255}));
  connect(boi.ports_bHeaWat, inlPumHeaWatPri.ports_a)
    annotation (Line(points={{-40,2.85714},{-36,2.85714},{-36,0},{-30,0}},
                                                   color={0,127,255}));
  connect(outPumHeaWatPri.port_b, THeaWatSup.port_a)
    annotation (Line(points={{50,0},{60,0}},     color={0,127,255}));
  connect(THeaWatSup.port_b, mHeaWat_flow.port_a)
    annotation (Line(points={{80,0},{90,0}},  color={0,127,255}));
  connect(inlBoi.ports_b, boi.ports_aHeaWat)
    annotation (Line(points={{-30,-80},{-36,-80},{-36,-82.8571},{-40,-82.8571}},
                                                     color={0,127,255}));
  connect(THeaWatRet.port_b, inlBoi.port_a)
    annotation (Line(points={{10,-80},{-10,-80}},  color={0,127,255}));
  connect(ctl.bus, busPla) annotation (Line(
      points={{-10,120},{-80,120},{-80,80}},
      color={255,204,51},
      thickness=0.5));
  connect(pumHeaWatPri.ports_b, outPumHeaWatPri.ports_a)
    annotation (Line(points={{20,0},{30,0}},     color={0,127,255}));
  connect(mHeaWat_flow.port_b, bouHeaWat.ports[1]) annotation (Line(points={{110,0},
          {120,0},{120,-80},{59,-80},{59,-90}},      color={0,127,255}));
  connect(bouHeaWat.ports[2], THeaWatRet.port_a) annotation (Line(points={{61,-90},
          {61,-80},{30,-80}},        color={0,127,255}));
  connect(busPla, boi.bus) annotation (Line(
      points={{-80,80},{-80,20}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla.pumHeaWatPriCon, pumHeaWatPri.bus) annotation (Line(
      points={{-80,80},{10,80},{10,10}},
      color={255,204,51},
      thickness=0.5));
  annotation (
  Diagram(coordinateSystem(extent={{-140,-140},{140,140}})),
  experiment(
    StopTime=2000,
    Tolerance=1e-06),
  __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/Templates/HeatingPlants/HotWater/Components/Validation/BoilerGroupPolynomial.mos"
  "Simulate and plot"),
  Documentation(info="<html>
<p>
This model validates the boiler group model
<a href=\"modelica://Buildings.Templates.HeatingPlants.HotWater.Components.BoilerGroup\">
Buildings.Templates.HeatingPlants.HotWater.Components.BoilerGroup</a>
in the case where a polynomial is used to represent the boiler efficiency.
The HW supply temperature setpoint, the HW return temperature and the 
primary HW pump speed are fixed at their design value when the boilers are
enabled.
</p>
<p>
The model illustrates a bug in Dymola (#SR01004314-01).
The parameter bindings for <code>pumHeaWatPri.dat</code> are not properly interpreted
and the start value is used for all those parameters without any warning being issued.
Hence, the total HW flow rate differs from its design value.
OCT properly propagates the parameter values from the composite component binding.
</p>
</html>"));
end BoilerGroupPolynomial;
