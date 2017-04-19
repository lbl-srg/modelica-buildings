within Buildings.Fluid.HeatExchangers.Examples;
model WetCoilEffNtu "Example of usage of the WetCoilEffNtu model"
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

  Buildings.Fluid.Sources.Boundary_pT sinAir(
    redeclare package Medium = Medium_A,
    use_p_in=false,
    p=pAirOut,
    T=TAirOut,
    X={XWatIn, 1 - XWatIn},
    nPorts=1)
    "Air sink"
    annotation (Placement(transformation(extent={{-90,-90},{-70,-70}})));
  Buildings.Fluid.Sources.Boundary_pT souAir(
    redeclare package Medium = Medium_A,
    p=pAirIn,
    T=TAirIn,
    X={XWatIn, 1 - XWatIn},
    nPorts=1)
    "Air source"
    annotation (Placement(transformation(extent={{70,-90},{50,-70}})));
  Buildings.Fluid.Sources.Boundary_pT sinWat(
    redeclare package Medium = Medium_W,
    p=pWatOut,
    T=TWatOut,
    nPorts=1)
    "Sink for water"
    annotation (Placement(transformation(extent={{70,10},{50,30}})));
  Buildings.Fluid.Sources.Boundary_pT souWat(
    redeclare package Medium = Medium_W,
    p=pWatIn,
    T=TWatIn,
    nPorts=1)
    "Source for water"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  Buildings.Fluid.HeatExchangers.WetEffectivenessNTU wetEffNtu(
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
    T_a1_nominal = TWatIn,
    T_a2_nominal = TAirIn)
    "Heat exchanger coil"
    annotation (Placement(transformation(extent={{-24,-46},{8,-14}})));
  Buildings.Fluid.FixedResistances.PressureDrop watRes(
    redeclare package Medium = Medium_W,
    m_flow_nominal=mWat_flow_nominal,
    dp_nominal=pWatIn - pWatOut)
    "Pressure drop in water pipe"
    annotation (Placement(transformation(extent={{-52,-30},{-32,-10}})));
  Buildings.Fluid.FixedResistances.PressureDrop airRes(
    redeclare package Medium = Medium_A,
    m_flow_nominal=mAir_flow_nominal,
    dp_nominal=pAirIn - pAirOut)
    "Pressure drop in airway"
    annotation (Placement(transformation(extent={{36,-50},{16,-30}})));

  Modelica.SIunits.HeatFlowRate QTotWat = mWat_flow_nominal * (hWatOut - hWatIn)
    "Total heat transferred to the water";
  Modelica.SIunits.HeatFlowRate QTotAir = mAir_flow_nominal * (hAirOut - hAirIn)
    "Total heat tranferred to the air";

  Modelica.SIunits.SpecificEnthalpy hAirIn =
    Medium_W.specificEnthalpy(
      Medium_W.setState_phX(
        p=wetEffNtu.port_a2.p,
        h=actualStream(wetEffNtu.port_a2.h_outflow),
        X={actualStream(wetEffNtu.port_a2.Xi_outflow[1]),
          1 - actualStream(wetEffNtu.port_a2.Xi_outflow[1])}))
    "Specific enthalpy";

  Modelica.SIunits.SpecificEnthalpy hWatIn =
    Medium_W.specificEnthalpy(
      Medium_W.setState_ph(
        p=wetEffNtu.port_a1.p,
        h=actualStream(wetEffNtu.port_a1.h_outflow)))
    "Specific enthalpy";

  Modelica.SIunits.SpecificEnthalpy hAirOut =
    Medium_W.specificEnthalpy(
      Medium_W.setState_phX(
        p=wetEffNtu.port_b2.p,
        h=actualStream(wetEffNtu.port_b2.h_outflow),
        X={actualStream(wetEffNtu.port_b2.Xi_outflow[1]),
           1 - actualStream(wetEffNtu.port_b2.Xi_outflow[1])}))
    "Specific enthalpy";

  Modelica.SIunits.SpecificEnthalpy hWatOut =
    Medium_W.specificEnthalpy(
      Medium_W.setState_ph(
        p=wetEffNtu.port_b1.p,
        h=actualStream(wetEffNtu.port_b1.h_outflow)))
    "Specific enthalpy";

equation
  connect(souWat.ports[1], watRes.port_a) annotation (Line(points={{-70,20},{-60,
          20},{-60,-20},{-52,-20}}, color={0,127,255}));
  connect(watRes.port_b, wetEffNtu.port_a1) annotation (Line(points={{-32,-20},{-24,-20},{-24,-20.4}},
                                           color={0,127,255}));
  connect(souAir.ports[1], airRes.port_a) annotation (Line(points={{
          50,-80},{40,-80},{40,-40},{36,-40}}, color={0,127,255}));
  connect(airRes.port_b, wetEffNtu.port_a2) annotation (Line(points={{16,-40},{8,-40},{8,-39.6}}, color={0,127,255}));
  connect(wetEffNtu.port_b2, sinAir.ports[1]) annotation (Line(points=
       {{-24,-39.6},{-40,-39.6},{-40,-80},{-70,-80}}, color={0,127,255}));
  connect(wetEffNtu.port_b1, sinWat.ports[1]) annotation (Line(points=
       {{8,-20.4},{40,-20.4},{40,20},{50,20}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{80,40}})),
          experiment(Tolerance=1E-6, StopTime=1),
          __Dymola_Commands(
            file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Examples/WetCoilEffNtu.mos"
            "Simulate and plot"),
    Documentation(info="<html>
<p>
This example duplicates an example from Mitchell and Braun 2012, example SM-2-1
(Mitchell and Braun 2012) to validate a single case for the
<a href=\"modelica://Buildings.Fluid.HeatExchangers.WetEffectivenessNTU\">
Buildings.Fluid.HeatExchangers.WetEffectivenessNTU</a> model.
</p>

<h4>Validation</h4>

<p>
The example is a steady-state analysis of a partially wet coil with the inlet
conditions as specified in the model setup.
</p>

<p>
The slight deviations we find are believed due to differences in the tolerance
of the solver algorithms employed as well as differences in media property
calculations for air and water.
</p>

<h4>References</h4>

<p>
Mitchell, John W., and James E. Braun. 2012.
\"Supplementary Material Chapter 2: Heat Exchangers for Cooling Applications\".
Excerpt from <i>Principles of heating, ventilation, and air conditioning in buildings</i>.
Hoboken, N.J.: Wiley. Available online:
<a href=\"http://bcs.wiley.com/he-bcs/Books?action=index&amp;itemId=0470624574&amp;bcsId=7185\">
http://bcs.wiley.com/he-bcs/Books?action=index&amp;itemId=0470624574&amp;bcsId=7185</a>
</p>
</html>", revisions="<html>
<ul>
<li>
April 19, 2017, by Michael Wetter:<br/>
Revised model to avoid mixing textual equations and connect statements.
</li>
<li>
March 17, 2017, by Michael O'Keefe:<br/>
First implementation. See
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/622\">
issue 622</a> for more information.
</li>
</ul>
</html>"));
end WetCoilEffNtu;
