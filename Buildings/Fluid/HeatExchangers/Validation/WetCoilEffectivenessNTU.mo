within Buildings.Fluid.HeatExchangers.Validation;
model WetCoilEffectivenessNTU
  "Model validation of the WetCoilEffNtu model compared with a reference"
  extends Modelica.Icons.Example;

  package Medium_W = Buildings.Media.Water;
  package Medium_A = Buildings.Media.Air;

  constant Modelica.SIunits.AbsolutePressure pAtm = 101325 "Atmospheric pressure";

  parameter Modelica.SIunits.Temperature TAirIn=
    Modelica.SIunits.Conversions.from_degF(80)
    "Inlet air temperature";
  parameter Modelica.SIunits.Temperature TAirOut=
    Modelica.SIunits.Conversions.from_degF(53)
    "Outlet air temperature";
  parameter Modelica.SIunits.Temperature TWatIn=
    Modelica.SIunits.Conversions.from_degF(42)
    "Inlet water temperature";
  parameter Modelica.SIunits.Temperature TWatOut=
    Modelica.SIunits.Conversions.from_degF(47.72)
    "Outlet water temperature";

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
    annotation (Placement(transformation(extent={{-130,-50},{-110,-30}})));
  Buildings.Fluid.Sources.Boundary_pT souAir(
    redeclare package Medium = Medium_A,
    p=pAirIn,
    T=TAirIn,
    use_Xi_in=true,
    nPorts=4)
    "Air source"
    annotation (Placement(transformation(extent={{48,-50},{28,-30}})));
  Buildings.Fluid.Sources.Boundary_pT sinWat(
    redeclare package Medium = Medium_W,
    p=pWatOut,
    T=TWatOut,
    nPorts=1)
    "Sink for water"
    annotation (Placement(transformation(extent={{30,50},{10,70}})));
  Buildings.Fluid.Sources.Boundary_pT souWat(
    redeclare package Medium = Medium_W,
    p=pWatIn,
    T=TWatIn,
    nPorts=1)
    "Source for water"
    annotation (Placement(transformation(extent={{-130,50},{-110,70}})));
  WetEffectivenessNTU_Fuzzy_V2_2_4 hexWetNTU(
    redeclare package Medium1 = Medium_W,
    redeclare package Medium2 = Medium_A,
    UA_nominal=UA_nominal,
    m1_flow_nominal=mWat_flow_nominal,
    m2_flow_nominal=mAir_flow_nominal,
    dp2_nominal=0,
    dp1_nominal=0,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CrossFlowStream1UnmixedStream2Mixed,
    show_T=true,
    r_nominal=1) "Heat exchanger coil"
    annotation (Placement(transformation(extent={{-64,-6},{-32,26}})));

  Buildings.Fluid.FixedResistances.PressureDrop watRes(
    redeclare package Medium = Medium_W,
    m_flow_nominal=mWat_flow_nominal,
    dp_nominal=pWatIn - pWatOut)
    "Pressure drop in water pipe"
    annotation (Placement(transformation(extent={{-92,10},{-72,30}})));
  Buildings.Fluid.FixedResistances.PressureDrop airRes(
    redeclare package Medium = Medium_A,
    m_flow_nominal=mAir_flow_nominal,
    dp_nominal=pAirIn - pAirOut)
    "Pressure drop in airway"
    annotation (Placement(transformation(extent={{14,-10},{-6,10}})));

  Modelica.SIunits.HeatFlowRate QTotWat = mWat_flow_nominal * (hWatOut - hWatIn)
    "Total heat transferred to the water";
  Modelica.SIunits.HeatFlowRate QTotAir = mAir_flow_nominal * (hAirOut - hAirIn)
    "Total heat tranferred to the air";

  Modelica.SIunits.SpecificEnthalpy hAirIn=Medium_W.specificEnthalpy(
      Medium_W.setState_phX(
      p=hexWetNTU.port_a2.p,
      h=actualStream(hexWetNTU.port_a2.h_outflow),
      X={actualStream(hexWetNTU.port_a2.Xi_outflow[1]),1 - actualStream(
        hexWetNTU.port_a2.Xi_outflow[1])})) "Specific enthalpy";

  Modelica.SIunits.SpecificEnthalpy hWatIn=Medium_W.specificEnthalpy(
      Medium_W.setState_ph(p=hexWetNTU.port_a1.p, h=actualStream(hexWetNTU.port_a1.h_outflow)))
    "Specific enthalpy";

  Modelica.SIunits.SpecificEnthalpy hAirOut=Medium_W.specificEnthalpy(
      Medium_W.setState_phX(
      p=hexWetNTU.port_b2.p,
      h=actualStream(hexWetNTU.port_b2.h_outflow),
      X={actualStream(hexWetNTU.port_b2.Xi_outflow[1]),1 - actualStream(
        hexWetNTU.port_b2.Xi_outflow[1])})) "Specific enthalpy";

  Modelica.SIunits.SpecificEnthalpy hWatOut=Medium_W.specificEnthalpy(
      Medium_W.setState_ph(p=hexWetNTU.port_b1.p, h=actualStream(hexWetNTU.port_b1.h_outflow)))
    "Specific enthalpy";

  Modelica.Blocks.Sources.TimeTable mAirGai(table=[0,0.0035383; 1,0.01765],
      timeScale=1)    "Gain for air mass flow rate"
    annotation (Placement(transformation(extent={{96,-54},{76,-34}})));

  Sensors.RelativeHumidity RelHumIn(redeclare package Medium = Medium_A)
    "Inlet relative humidity"
    annotation (Placement(transformation(extent={{28,-22},{48,-2}})));
  Sensors.Temperature TDryBulIn(redeclare package Medium = Medium_A)
    "Inlet dry bulb temperature"
    annotation (Placement(transformation(extent={{44,44},{64,64}})));
  Modelica.Blocks.Sources.RealExpression pAir(y=101325) "Pressure"
    annotation (Placement(transformation(extent={{66,-34},{84,-10}})));
  Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi wetBulIn(redeclare
      package Medium = Medium_A)
    annotation (Placement(transformation(extent={{94,10},{114,30}})));
  Sensors.MassFraction senMasFraIn(redeclare package Medium = Medium_A)
    annotation (Placement(transformation(extent={{32,10},{52,30}})));
  Sensors.MassFraction senMasFraOut(redeclare package Medium = Medium_A)
    annotation (Placement(transformation(extent={{-70,-62},{-50,-42}})));
  Sensors.Temperature TDryBulSupOut(redeclare package Medium = Medium_A)
    "Outlet dry bulb temperature"
    annotation (Placement(transformation(extent={{-70,-36},{-50,-16}})));
  Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi wetBulOut(redeclare
      package Medium = Medium_A)
    annotation (Placement(transformation(extent={{-36,-62},{-16,-42}})));
  Modelica.Blocks.Sources.RealExpression pAir1(y=101325)
                                                        "Pressure"
    annotation (Placement(transformation(extent={{-68,-88},{-50,-64}})));
equation
  connect(souWat.ports[1], watRes.port_a) annotation (Line(points={{-110,60},{-100,
          60},{-100,20},{-92,20}},  color={0,127,255}));
  connect(watRes.port_b, hexWetNTU.port_a1) annotation (Line(points={{-72,20},{
          -64,20},{-64,19.6}}, color={0,127,255}));
  connect(souAir.ports[1], airRes.port_a) annotation (Line(points={{28,-37},{18,
          -37},{18,0},{14,0}},                 color={0,127,255}));
  connect(hexWetNTU.port_b2, sinAir.ports[1]) annotation (Line(points={{-64,0.4},
          {-80,0.4},{-80,-40},{-110,-40}}, color={0,127,255}));
  connect(hexWetNTU.port_b1, sinWat.ports[1]) annotation (Line(points={{-32,
          19.6},{0,19.6},{0,60},{10,60}}, color={0,127,255}));
  connect(mAirGai.y, souAir.Xi_in[1])
    annotation (Line(points={{75,-44},{50,-44}},  color={0,0,127}));
  connect(souAir.ports[2], RelHumIn.port) annotation (Line(points={{28,-39},{28,
          -38},{22,-38},{22,-22},{38,-22}}, color={0,127,255}));
  connect(souAir.ports[3], TDryBulIn.port) annotation (Line(points={{28,-41},{28,
          -38},{22,-38},{22,44},{54,44}},  color={0,127,255}));
  connect(airRes.port_b, hexWetNTU.port_a2)
    annotation (Line(points={{-6,0},{-6,0.4},{-32,0.4}}, color={0,127,255}));
  connect(souAir.ports[4], senMasFraIn.port) annotation (Line(points={{28,-43},{
          22,-43},{22,8},{42,8},{42,10}},       color={0,127,255}));
  connect(senMasFraIn.X, wetBulIn.Xi[1])
    annotation (Line(points={{53,20},{93,20}},    color={0,0,127}));
  connect(TDryBulIn.T, wetBulIn.TDryBul) annotation (Line(points={{61,54},{68,54},
          {68,28},{93,28}},         color={0,0,127}));
  connect(pAir.y, wetBulIn.p) annotation (Line(points={{84.9,-22},{84,-22},{84,12},
          {93,12}},            color={0,0,127}));
  connect(hexWetNTU.port_b2, senMasFraOut.port) annotation (Line(points={{-64,
          0.4},{-72,0.4},{-72,-62},{-60,-62}}, color={0,127,255}));
  connect(hexWetNTU.port_b2, TDryBulSupOut.port) annotation (Line(points={{-64,
          0.4},{-70,0.4},{-70,-36},{-60,-36}}, color={0,127,255}));
  connect(TDryBulSupOut.T, wetBulOut.TDryBul) annotation (Line(points={{-53,-26},
          {-46,-26},{-46,-44},{-37,-44}},
                                      color={0,0,127}));
  connect(senMasFraOut.X, wetBulOut.Xi[1])
    annotation (Line(points={{-49,-52},{-37,-52}},
                                                color={0,0,127}));
  connect(pAir1.y, wetBulOut.p) annotation (Line(points={{-49.1,-76},{-49.1,-68},
          {-37,-68},{-37,-60}},
                              color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true,
    extent={{-180,-140},{180,140}})),
    experiment(Tolerance=1E-6, StopTime=1),
    __Dymola_Commands(
    file="Resources/Scripts/Dymola/Fluid/HeatExchangers/Validation/WetCoilEffectivenessNTU.mos"
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
end WetCoilEffectivenessNTU;
