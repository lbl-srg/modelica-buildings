within Buildings.Fluid.HeatExchangers.Examples;
model HeaterCoolerHumidifier_u
  "Example of the HeaterCoolerHumidifier_u model"
  extends Modelica.Icons.Example;

  package Medium_W = Buildings.Media.Water;
  package Medium_A = Buildings.Media.Air;

  constant Modelica.SIunits.AbsolutePressure pAtm = 101325;

  parameter Modelica.SIunits.Pressure pAirIn = pAtm + 20
    "Inlet air pressure";
  parameter Modelica.SIunits.Pressure pAirOut = pAtm
    "Outlet air pressure";
  parameter Modelica.SIunits.MassFlowRate masFloAir = 2.646
    "Nominal mass flow rate of air";
  parameter Modelica.SIunits.MassFlowRate masFloCon = 0.00246
    "Mass flow rate of condensate";
  parameter Modelica.SIunits.Temperature TAirIn=
    Modelica.SIunits.Conversions.from_degC(26.666);
  parameter Real XWatIn = 0.0089757;
  parameter Modelica.SIunits.Temperature TAirOut=
    Modelica.SIunits.Conversions.from_degC(10.8957);
  parameter Modelica.SIunits.Temperature TCon=
    Modelica.SIunits.Conversions.from_degC(10.064)
    "Mass flow rate of condensate";
  parameter Modelica.SIunits.HeatFlowRate QSet = 50484.6
    "Sensible heat flow rate setting; positive is out of the stream";

  Buildings.Fluid.HeatExchangers.HeaterCoolerHumidifier_u heaCooHum(
    redeclare package Medium = Medium_A,
    show_T=true,
    use_T_in=true,
    mWat_flow_nominal=1,
    Q_flow_nominal=1,
    m_flow_nominal=masFloAir,
    dp_nominal=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Sources.Boundary_pT souAir(
    redeclare package Medium = Medium_A,
    p=pAirIn,
    T=TAirIn,
    X={XWatIn, 1 - XWatIn},
    nPorts=1)
    "Air source"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-80,0})));
  Buildings.Fluid.Sources.Boundary_pT sinAir(
    redeclare package Medium = Medium_A,
    use_p_in=false,
    p=pAirOut,
    T=TAirOut,
    X={XWatIn, 1 - XWatIn},
    nPorts=1)
    "Air sink"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={56,0})));
  Buildings.Fluid.FixedResistances.PressureDrop airRes(
    redeclare package Medium = Medium_A,
    m_flow_nominal=masFloAir,
    dp_nominal=pAirIn - pAirOut)
    "Pressure drop in airway"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-42,0})));
  Modelica.Blocks.Sources.RealExpression masFloConInp(y=-1*masFloCon)
    "Expression for the mass flow of the condensate"
    annotation (Placement(transformation(extent={{-56,34},{-28,46}})));
  Modelica.Blocks.Sources.RealExpression TConInp(y=TCon)
    "Expression for the condensate temperature"
    annotation (Placement(transformation(extent={{-56,-26},{-28,-14}})));
  Modelica.Blocks.Sources.RealExpression QSenInp(y=-QSet)
    "Expression for the sensible heat flow rate; note sign change is to change
    positive as heat added to the stream"
    annotation (Placement(transformation(extent={{-56,-40},{-28,-28}})));

  Modelica.SIunits.Temperature TAirOutAtUnit
    "Outlet air temperature at the heaCooHum";
  Modelica.SIunits.HeatFlowRate QOut
    "Total heat flow out of the stream";
  Modelica.SIunits.SpecificEnthalpy h1
    "Specific enthalpy at port_a";
  Modelica.SIunits.SpecificEnthalpy h2
    "Specific enthalpy at port_b";
  Modelica.SIunits.SpecificEnthalpy hx
    "Specific enthalpy at a state that is the same temperature as the
    entering state and same humidity ratio as the leaving state. See
    Mitchell and Braun 2012 Chapter 5 - Heating and Cooling Coil and
    Figure 5.6";
  Modelica.SIunits.HeatFlowRate QSen
    "Sensible heat flow out of the stream";
  Modelica.SIunits.HeatFlowRate QLat
    "Latent heat flow out of the stream";

equation
  h1 = inStream(heaCooHum.port_a.h_outflow);
  h2 = actualStream(heaCooHum.port_b.h_outflow);
  QOut = masFloAir * (h1 - h2);
  QSen = masFloAir * (hx - h2)
    "Mitchell and Braun 2012 Eq 5.30";
  QLat = masFloAir * (h1 - hx)
    "Mitchell and Braun 2012 Eq 5.31";
  hx = Medium_A.specificEnthalpy_pTX(
    p = pAtm,
    T = TAirIn,
    X = {actualStream(heaCooHum.port_b.Xi_outflow[1]),
        1 - actualStream(heaCooHum.port_b.Xi_outflow[1])});
  TAirOutAtUnit = Medium_A.temperature(
    Medium_A.setState_phX(
      p=heaCooHum.port_b.p,
      h=heaCooHum.port_b.h_outflow,
      X={actualStream(heaCooHum.port_b.Xi_outflow[1]),
        1 - actualStream(heaCooHum.port_b.Xi_outflow[1])}));
  connect(heaCooHum.port_b, sinAir.ports[1]) annotation (
    Line(points={{10,0},{46,0}}, color={0,127,255}, thickness=1));
  connect(souAir.ports[1], airRes.port_a) annotation (Line(
      points={{-70,0},{-52,0}},
      color={0,127,255},
      thickness=1));
  connect(airRes.port_b, heaCooHum.port_a) annotation (Line(
      points={{-32,0},{-21,0},{-10,0}},
      color={0,127,255},
      thickness=1));
  connect(masFloConInp.y, heaCooHum.u) annotation (Line(points={{
          -26.6,40},{-20,40},{-20,6},{-12,6}}, color={0,0,127}));
  connect(TConInp.y, heaCooHum.T_in) annotation (Line(points={{-26.6,
          -20},{-22,-20},{-22,-6},{-12,-6}}, color={0,0,127}));
  connect(QSenInp.y, heaCooHum.u1) annotation (Line(points={{-26.6,
          -34},{-18,-34},{-18,-9},{-12,-9}}, color={0,0,127}));
  annotation (
    experiment(StopTime=1.0),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Examples/HeaterCoolerHumidifier_u.mos"
        "Simulate and plot"),
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
March 17, 2017, by Michael O'Keefe:<br/>
First implementation. See
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/622\">
issue 622</a> for more information.
</li>
</ul>
</html>", info="<html>
<p>
This model exercises the
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeaterCoolerHumidifier_u\">
HeaterCoolerHumidifier_u</a> model over the example SM2-1 from Mitchell and
Braun (2012).
</p>

<p>
The example introduces an \"x\" state enthalpy to split out and check the latent
versus sensible heat transfer. The \"x\" state enthalpy is the enthalpy
corresponding to the temperature of the entering state but the mass fraction of
water of the exit state. This is discussed in Chapter 5 of Mitchell and Braun
(2012a).
</p>

<p>
The example demonstrates that mosture can be extracted from the stream while
heat is also being transferred out of the stream and the results agree roughly
with both those of the
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.Examples.DryWetCalcs\">
DryWetCalcs</a> example and with Chapter 5 of Mitchell and Braun.
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

<p>
Mitchell, John W., and James E. Braun. 2012a. <i>Principles of heating,
  ventilation, and air conditioning in buildings</i>.  Hoboken, N.J.: Wiley.
</p>
</html>"));
end HeaterCoolerHumidifier_u;
