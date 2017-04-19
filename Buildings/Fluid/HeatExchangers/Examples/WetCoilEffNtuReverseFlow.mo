within Buildings.Fluid.HeatExchangers.Examples;
model WetCoilEffNtuReverseFlow
  "Tests the WetEffectivenessNTU model under reverse flow"
  extends Modelica.Icons.Example;

  package Medium_W = Buildings.Media.Water;
  package Medium_A = Buildings.Media.Air;

  constant Modelica.SIunits.AbsolutePressure pAtm = 101325 "Atmospheric pressure";

  parameter Modelica.SIunits.Temperature TWatIn=
    Modelica.SIunits.Conversions.from_degF(42)
    "Inlet water temperature";
  parameter Modelica.SIunits.Temperature TWatOut=
    Modelica.SIunits.Conversions.from_degF(47.72)
    "Outlet water temperature";
  parameter Modelica.SIunits.Temperature TAirIn=
    Modelica.SIunits.Conversions.from_degF(80)
    "Inlet air temperature";
  parameter Modelica.SIunits.Temperature TAirOut=
    Modelica.SIunits.Conversions.from_degF(53)
    "Outlet air temperature";
  parameter Modelica.SIunits.Pressure pAirIn = pAtm + 20
    "Inlet air pressure";
  parameter Modelica.SIunits.Pressure pAirOut = pAtm
    "Outlet air pressure";
  parameter Modelica.SIunits.Pressure pWatIn = pAtm + 100
    "Inlet air pressure";
  parameter Modelica.SIunits.Pressure pWatOut = pAtm
    "Outlet air pressure";
  parameter Modelica.SIunits.MassFlowRate mWat_flow_nominal = 3.78
    "Nominal mass flow rate of water";
  parameter Modelica.SIunits.MassFlowRate mAir_flow_nominal = 2.646
    "Nominal mass flow rate of air";
  parameter Modelica.SIunits.ThermalConductance UA_nominal = 9495.5 / 2
    "Total thermal conductance at nominal flow, used to compute heat capacity";
  parameter Real XWatIn(min=0,max=1) = 0.0089757
    "Inlet air humidity ratio: mass of water per mass of moist air";

  Sources.Boundary_pT sinAir(
    redeclare package Medium = Medium_A,
    use_p_in=false,
    p=pAirOut,
    T=TAirOut,
    X={XWatIn, 1 - XWatIn},
    nPorts=1)
    "Air sink"
    annotation (Placement(transformation(extent={{-64,42},{-44,62}})));
  Sources.Boundary_pT souAir(
    redeclare package Medium = Medium_A,
    p=pAirIn,
    T=TAirIn,
    X={XWatIn, 1 - XWatIn},
    nPorts=1)
    "Air source"
    annotation (Placement(transformation(extent={{84,42},{64,62}})));
  Sources.Boundary_pT sinWat(
    redeclare package Medium = Medium_W,
    p=pWatOut,
    T=TWatOut,
    nPorts=1)
    "Sink for water"
    annotation (Placement(transformation(extent={{62,62},{42,82}})));
  Sources.Boundary_pT souWat(
    redeclare package Medium = Medium_W,
    p=pWatIn,
    T=TWatIn,
    nPorts=1)
    "Source for water"
    annotation (Placement(transformation(extent={{-86,62},{-66,82}})));
  WetEffectivenessNTU wetEffNtu(
    redeclare package Medium1 = Medium_W,
    redeclare package Medium2 = Medium_A,
    UA_nominal = UA_nominal,
    m1_flow_nominal=mWat_flow_nominal,
    m2_flow_nominal=mAir_flow_nominal,
    dp2_nominal=0,
    dp1_nominal=0,
    configuration=
    Buildings.Fluid.Types.HeatExchangerConfiguration.CrossFlowStream1UnmixedStream2Mixed,
    show_T=true,
    r_nominal=1,
    T_a1_nominal=TWatIn,
    T_a2_nominal=TAirIn)
    "Heat exchanger coil"
    annotation (Placement(transformation(extent={{-16,46},{16,78}})));
  FixedResistances.PressureDrop watRes(
    redeclare package Medium = Medium_W,
    m_flow_nominal=mWat_flow_nominal,
    dp_nominal=pWatIn - pWatOut)
    "Pressure drop in water pipe"
    annotation (Placement(transformation(extent={{-44,62},{-24,82}})));
  FixedResistances.PressureDrop airRes(
    redeclare package Medium = Medium_A,
    m_flow_nominal=mAir_flow_nominal,
    dp_nominal=pAirIn - pAirOut)
    "Pressure drop in airway"
    annotation (Placement(transformation(extent={{44,42},{24,62}})));
  Sources.Boundary_pT sinAir1(
    redeclare package Medium = Medium_A,
    use_p_in=false,
    p=pAirOut,
    T=TAirOut,
    X={XWatIn, 1 - XWatIn},
    nPorts=1)
    "Air sink"
    annotation (Placement(transformation(extent={{-64,-62},{-44,-42}})));
  Sources.Boundary_pT souAir1(
    redeclare package Medium = Medium_A,
    p=pAirIn,
    T=TAirIn,
    X={XWatIn, 1 - XWatIn},
    nPorts=1)
    "Air source"
    annotation (Placement(transformation(extent={{84,-62},{64,-42}})));
  Sources.Boundary_pT sinWat1(
    redeclare package Medium = Medium_W,
    p=pWatOut,
    T=TWatOut,
    nPorts=1)
    "Sink for water"
    annotation (Placement(transformation(extent={{62,-42},{42,-22}})));
  Sources.Boundary_pT souWat1(
    redeclare package Medium = Medium_W,
    p=pWatIn,
    T=TWatIn,
    nPorts=1)
    "Source for water"
    annotation (Placement(transformation(extent={{-86,-42},{-66,-22}})));
  WetEffectivenessNTU wetEffNtu1(
    redeclare package Medium1 = Medium_W,
    redeclare package Medium2 = Medium_A,
    UA_nominal = UA_nominal,
    m1_flow_nominal=mWat_flow_nominal,
    m2_flow_nominal=mAir_flow_nominal,
    dp2_nominal=0,
    dp1_nominal=0,
    configuration=
    Buildings.Fluid.Types.HeatExchangerConfiguration.CrossFlowStream1UnmixedStream2Mixed,
    show_T=true,
    r_nominal=1,
    T_a1_nominal=TWatIn,
    T_a2_nominal=TAirIn)
    "Heat exchanger coil"
    annotation (Placement(transformation(extent={{16,-16},{-16,16}},
        rotation=0,
        origin={0,-42})));
  FixedResistances.PressureDrop watRes1(
    redeclare package Medium = Medium_W,
    m_flow_nominal=mWat_flow_nominal,
    dp_nominal=pWatIn - pWatOut)
    "Pressure drop in water pipe"
    annotation (Placement(transformation(extent={{-44,-42},{-24,-22}})));
  FixedResistances.PressureDrop airRes1(
    redeclare package Medium = Medium_A,
    m_flow_nominal=mAir_flow_nominal,
    dp_nominal=pAirIn - pAirOut)
    "Pressure drop in airway"
    annotation (Placement(transformation(extent={{44,-62},{24,-42}})));
equation
  connect(souWat.ports[1],watRes. port_a) annotation (Line(points={{-66,72},{-52,
          72},{-44,72}},            color={0,127,255}));
  connect(watRes.port_b,wetEffNtu. port_a1) annotation (Line(points={{-24,72},{-16,
          72},{-16,71.6}},                 color={0,127,255}));
  connect(souAir.ports[1],airRes. port_a) annotation (Line(points={{64,52},{48,52},
          {44,52}},                            color={0,127,255}));
  connect(airRes.port_b,wetEffNtu. port_a2) annotation (Line(points={{24,52},{16,
          52},{16,52.4}},                                                                         color={0,127,255}));
  connect(wetEffNtu.port_b2,sinAir. ports[1]) annotation (Line(points={{-16,52.4},
          {-44,52.4},{-44,52}},                       color={0,127,255}));
  connect(wetEffNtu.port_b1,sinWat. ports[1]) annotation (Line(points={{16,71.6},
          {42,71.6},{42,72}},                  color={0,127,255}));
  connect(souWat1.ports[1], watRes1.port_a)
    annotation (Line(points={{-66,-32},{-44,-32}}, color={0,127,255}));
  connect(souAir1.ports[1], airRes1.port_a)
    annotation (Line(points={{64,-52},{44,-52}}, color={0,127,255}));
  connect(watRes1.port_b, wetEffNtu1.port_b1) annotation (Line(points={{-24,-32},
          {-16,-32},{-16,-32.4}}, color={0,127,255}));
  connect(sinWat1.ports[1], wetEffNtu1.port_a1) annotation (Line(points={{42,-32},
          {16,-32},{16,-32.4}}, color={0,127,255}));
  connect(sinAir1.ports[1], wetEffNtu1.port_a2) annotation (Line(points={{-44,-52},
          {-16,-52},{-16,-51.6}}, color={0,127,255}));
  connect(airRes1.port_b, wetEffNtu1.port_b2) annotation (Line(points={{24,-52},
          {16,-52},{16,-51.6}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(Tolerance=1E-6, StopTime=1),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Examples/WetCoilEffNtuReverseFlow.mos"
      "Simulate and plot"),
    Documentation(info="<html>
<p>
This example confirms that we get the same results when hooking up the heat
exchanger backwards as forwards. Two heat exchangers are simulated: one
configured with inflow into the \"a\" ports and another with inflow into the
\"b\" ports.
</p>
</html>", revisions="<html>
<ul>
<li>
April 17, 2017, by Michael O'Keefe:<br/>
First implementation.
</li>
</ul>
</html>"));
end WetCoilEffNtuReverseFlow;
