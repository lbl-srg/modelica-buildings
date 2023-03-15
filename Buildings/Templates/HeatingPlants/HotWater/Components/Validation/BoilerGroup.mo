within Buildings.Templates.HeatingPlants.HotWater.Components.Validation;
model BoilerGroup "Validation model for boiler group"
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
    dp_nominal=1.5*(datBoi.dpHeaWatBoi_nominal .+ Buildings.Templates.Data.Defaults.dpValChe))
    "Parameter record for primary HW pumps";
  parameter Modelica.Units.SI.Time tau=10
    "Time constant at nominal flow"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  BoilerGroups.BoilerGroupPolynomial boi(
    redeclare final package Medium=Medium,
    final nBoi=nBoi,
    is_con=false,
    typArrPumHeaWatPri=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
    final dat=datBoi,
    final energyDynamics=energyDynamics)
    "Boiler group"
    annotation (Placement(transformation(extent={{-200,-80},{-120,80}})));
  Buildings.Templates.Components.Pumps.Multiple pumHeaWatPri(
    have_var=false,
    have_valChe=true,
    final nPum=nBoi,
    final dat=datPumHeaWatPri,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Primary HW pumps"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Templates.Components.Routing.MultipleToMultiple inlPumHeaWatPri(
    redeclare final package Medium=Medium,
    final nPorts_a=nBoi,
    final have_comLeg=boi.typArrPumHeaWatPri==Buildings.Templates.Components.Types.PumpArrangement.Headered,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final energyDynamics=energyDynamics)
    "Primary HW pumps inlet manifold"
    annotation (Placement(transformation(extent={{-110,30},{-90,50}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumHeaWatPri(
    redeclare final package Medium=Medium,final
      nPorts=nBoi, final m_flow_nominal=mHeaWat_flow_nominal)
    "Primary HW pumps outlet manifold"
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Fluid.Sensors.TemperatureTwoPort THeaWatSup(
    redeclare final package Medium=Medium,final m_flow_nominal=
        mHeaWat_flow_nominal) "HW supply temperature"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  Fluid.Sensors.MassFlowRate mHeaWat_flow(
    redeclare final package Medium=Medium) "HW mass flow rate"
    annotation (Placement(transformation(extent={{10,30},{30,50}})));
  Fluid.Sources.Boundary_pT bouHeaWat(
    redeclare final package Medium = Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_min,
    nPorts=1) "Boundary conditions for HW distribution system"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-20,-60})));
  Fluid.HeatExchangers.HeaterCooler_u loa(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final Q_flow_nominal=-sum(datBoi.capBoi_nominal),
    dp_nominal=0)
    "Heating load"
    annotation (Placement(transformation(extent={{30,-50},{10,-30}})));
  Fluid.Sensors.TemperatureTwoPort THeaWatRet(redeclare final package Medium =
        Medium, final m_flow_nominal=mHeaWat_flow_nominal)
    "HW return temperature"
    annotation (Placement(transformation(extent={{-50,-50},{-70,-30}})));
  Buildings.Templates.Components.Routing.SingleToMultiple inlBoi(
    redeclare final package Medium = Medium,
    final nPorts=nBoi,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final energyDynamics=energyDynamics)
    "Boiler group inlet manifold"
    annotation (Placement(transformation(extent={{-90,-50},{-110,-30}})));
  Controls.OpenLoop ctl(
    final nBoi=nBoi,
    typDisHeaWat=Buildings.Templates.HeatingPlants.HotWater.Types.Distribution.Variable1Only)
    "Controller"
    annotation (Placement(transformation(extent={{-140,150},{-120,170}})));
  Buildings.Templates.HeatingPlants.HotWater.Interfaces.Bus busPla
    "Plant control bus" annotation (Placement(transformation(extent={{-180,100},
            {-140,140}}), iconTransformation(extent={{-310,60},{-270,100}})));
  Buildings.Templates.Components.Interfaces.Bus busPumHeaWatPri
    "Primary HW pump control bus" annotation (Placement(transformation(extent={{-90,70},
            {-50,110}}),         iconTransformation(extent={{-276,64},{-236,104}})));
  Buildings.Templates.Components.Interfaces.Bus busBoi[nBoi]
    "Boiler control bus" annotation (Placement(transformation(extent={{60,70},{100,
            110}}), iconTransformation(extent={{-276,64},{-236,104}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(k=fill(1/nBoi, nBoi), nin=nBoi)
    "Sum up firing rate" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={80,40})));
equation
  connect(inlPumHeaWatPri.ports_b, pumHeaWatPri.ports_a)
    annotation (Line(points={{-90,40},{-80,40}}, color={0,127,255}));
  connect(boi.ports_bHeaWat, inlPumHeaWatPri.ports_a)
    annotation (Line(points={{-120,40},{-110,40}}, color={0,127,255}));
  connect(outPumHeaWatPri.port_b, THeaWatSup.port_a)
    annotation (Line(points={{-30,40},{-20,40}}, color={0,127,255}));
  connect(THeaWatSup.port_b, mHeaWat_flow.port_a)
    annotation (Line(points={{0,40},{10,40}}, color={0,127,255}));
  connect(inlBoi.ports_b, boi.ports_aHeaWat)
    annotation (Line(points={{-110,-40},{-120,-40}}, color={0,127,255}));
  connect(THeaWatRet.port_b, inlBoi.port_a)
    annotation (Line(points={{-70,-40},{-90,-40}}, color={0,127,255}));
  connect(loa.port_b, THeaWatRet.port_a)
    annotation (Line(points={{10,-40},{-50,-40}}, color={0,127,255}));
  connect(bouHeaWat.ports[1], loa.port_b) annotation (Line(points={{-20,-50},{-20,
          -40},{10,-40}}, color={0,127,255}));
  connect(mHeaWat_flow.port_b, loa.port_a) annotation (Line(points={{30,40},{40,
          40},{40,-40},{30,-40}}, color={0,127,255}));
  connect(boi.bus, busPla) annotation (Line(
      points={{-160,80},{-160,120}},
      color={255,204,51},
      thickness=0.5));
  connect(ctl.bus, busPla) annotation (Line(
      points={{-140,160},{-160,160},{-160,120}},
      color={255,204,51},
      thickness=0.5));
  connect(busPumHeaWatPri, pumHeaWatPri.bus) annotation (Line(
      points={{-70,90},{-70,50}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla.boi, busBoi) annotation (Line(
      points={{-160,120},{80,120},{80,90}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla.pumHeaWatPri, busPumHeaWatPri) annotation (Line(
      points={{-160,120},{-70,120},{-70,90}},
      color={255,204,51},
      thickness=0.5));
  connect(mulSum.y, loa.u)
    annotation (Line(points={{80,28},{80,-34},{32,-34}}, color={0,0,127}));
  connect(busBoi.y_actual, mulSum.u) annotation (Line(
      points={{80,90},{80,72},{80,52},{80,52}},
      color={255,204,51},
      thickness=0.5));
  connect(pumHeaWatPri.ports_b, outPumHeaWatPri.ports_a)
    annotation (Line(points={{-60,40},{-50,40}}, color={0,127,255}));
  annotation (
  Diagram(coordinateSystem(extent={{-220,-220},{220,220}})),
  experiment(
    StopTime=2000,
    Tolerance=1e-06),
  __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/Templates/HeatingPlants/HotWater/Components/Validation/BoilerGroup.mos"
  "Simulate and plot"),
  Documentation(info="<html>
<p>
This model validates the chiller group model
<a href=\"modelica://Buildings.Templates.ChilledWaterPlants.Components.ChillerGroups.Compression\">
Buildings.Templates.ChilledWaterPlants.Components.ChillerGroups.Compression</a>
for air-cooled chillers.
</p>"));
end BoilerGroup;
