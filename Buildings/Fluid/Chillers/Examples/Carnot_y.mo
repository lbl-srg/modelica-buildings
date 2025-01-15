within Buildings.Fluid.Chillers.Examples;
model Carnot_y "Test model for chiller based on Carnot_y efficiency"
  extends Modelica.Icons.Example;
 package Medium1 = Buildings.Media.Water "Medium model";
 package Medium2 = Buildings.Media.Water "Medium model";

  parameter Modelica.Units.SI.Power P_nominal=10E3
    "Nominal compressor power (at y=1)";
  parameter Modelica.Units.SI.TemperatureDifference dTEva_nominal=-10
    "Temperature difference evaporator outlet-inlet";
  parameter Modelica.Units.SI.TemperatureDifference dTCon_nominal=10
    "Temperature difference condenser outlet-inlet";
  parameter Real COPc_nominal = 3 "Chiller COP";

  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal=-P_nominal*
      COPc_nominal/dTEva_nominal/4200
    "Nominal mass flow rate at chilled water side";
  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal=m2_flow_nominal*(
      COPc_nominal + 1)/COPc_nominal
    "Nominal mass flow rate at condenser water wide";

  Buildings.Fluid.Chillers.Carnot_y chi(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    P_nominal=P_nominal,
    dTEva_nominal=dTEva_nominal,
    dTCon_nominal=dTCon_nominal,
    use_eta_Carnot_nominal=true,
    dp1_nominal=6000,
    dp2_nominal=6000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    show_T=true,
    T1_start=303.15,
    T2_start=278.15) "Chiller model"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou1(nPorts=1,
    redeclare package Medium = Medium1,
    use_T_in=true,
    m_flow=m1_flow_nominal,
    T=298.15)
    annotation (Placement(transformation(extent={{-60,6},{-40,26}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou2(nPorts=1,
    redeclare package Medium = Medium2,
    use_T_in=true,
    m_flow=m2_flow_nominal,
    T=291.15)
    annotation (Placement(transformation(extent={{60,-6},{40,14}})));
  Buildings.Fluid.Sources.Boundary_pT sin1(
    nPorts=1,
    redeclare package Medium = Medium1)
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={70,40})));
  Buildings.Fluid.Sources.Boundary_pT sin2(
    nPorts=1,
    redeclare package Medium = Medium2)
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        origin={-50,-20})));
  Modelica.Blocks.Sources.Ramp uCom(
    height=-1,
    duration=60,
    offset=1,
    startTime=1800) "Compressor control signal"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Modelica.Blocks.Sources.Ramp TCon_in(
    height=10,
    duration=60,
    offset=273.15 + 20,
    startTime=60) "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  Modelica.Blocks.Sources.Ramp TEva_in(
    height=10,
    duration=60,
    startTime=900,
    offset=273.15 + 15) "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{50,-40},{70,-20}})));
equation
  connect(sou1.ports[1], chi.port_a1)    annotation (Line(
      points={{-40,16},{-5.55112e-16,16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou2.ports[1], chi.port_a2)    annotation (Line(
      points={{40,4},{20,4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(chi.port_b1, sin1.ports[1])    annotation (Line(
      points={{20,16},{30,16},{30,40},{60,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin2.ports[1], chi.port_b2)    annotation (Line(
      points={{-40,-20},{-10,-20},{-10,4},{-5.55112e-16,4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TCon_in.y, sou1.T_in) annotation (Line(
      points={{-69,20},{-62,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TEva_in.y, sou2.T_in) annotation (Line(
      points={{71,-30},{80,-30},{80,8},{62,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(uCom.y, chi.y) annotation (Line(
      points={{-39,60},{-10,60},{-10,19},{-2,19}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Chillers/Examples/Carnot_y.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
February 10, 2023, by Michael Wetter:<br/>
Removed binding of parameter with same value as the default.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1692\">#1692</a>.
</li>
<li>
May 15, 2019, by Jianjun Hu:<br/>
Replaced fluid source. This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1072\"> #1072</a>.
</li>
<li>
November 25, 2015 by Michael Wetter:<br/>
Changed sign of <code>dTEva_nominal</code> to be consistent.
</li>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
March 26, 2013 by Michael Wetter:<br/>
Removed assignment of parameter that had attribute <code>fixed=false</code>.
</li>
<li>
March 3, 2009 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Example that simulates a chiller whose efficiency is scaled based on the
Carnot cycle.
The chiller control signal is the compressor speed.
</p>
</html>"));
end Carnot_y;
