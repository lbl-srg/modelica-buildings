within Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Examples;
model MultiStageCooling
  "Test model for multi stage DX cooling coil"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air
    "Fluid medium for the model";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=datCoi.sta[datCoi.nSta].nomVal.m_flow_nominal
    "Nominal mass flow rate";

  parameter Modelica.Units.SI.PressureDifference dp_nominal=1000
    "Pressure drop at m_flow_nominal";

  Buildings.Fluid.HeatExchangers.DXCoils.AirSource.MultiStageCooling mulStaDX(
    redeclare package Medium = Medium,
    final dp_nominal=dp_nominal,
    final datCoi=datCoi,
    final T_start=datCoi.sta[1].nomVal.TEvaIn_nominal,
    final show_T=true,
    final from_dp=true,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Multispeed DX coil"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));

  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    final nPorts=1,
    final p(displayUnit="Pa") = 101325,
    final T=293.15)
    "Sink"
    annotation (Placement(transformation(extent={{40,-20},{20,0}})));

  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    final nPorts=1,
    final p(displayUnit="Pa") = 101325 + dp_nominal,
    final use_T_in=true,
    final use_p_in=true,
    final T=299.85)
    "Source"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));

  Modelica.Blocks.Sources.Ramp TEvaIn(
    final duration=600,
    final startTime=2400,
    final height=-5,
    final offset=273.15 + 23)
    "Temperature"
    annotation (Placement(transformation(extent={{-100,-38},{-80,-18}})));

  Modelica.Blocks.Sources.Ramp p(
    final duration=600,
    final startTime=600,
    final height=dp_nominal,
    final offset=101325)
    "Pressure"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));

  parameter
    Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.CoolingCoil
    datCoi(
      nSta=4,
      sta={Data.Generic.BaseClasses.Stage(
        spe=900/60,
        nomVal=Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-12000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=0.9),
        perCur=PerformanceCurves.Curve_I()),Data.Generic.BaseClasses.Stage(
        spe=1200/60,
        nomVal=Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-18000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=1.2),
        perCur=PerformanceCurves.Curve_I()),Data.Generic.BaseClasses.Stage(
        spe=1800/60,
        nomVal=Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-21000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=1.5),
        perCur=PerformanceCurves.Curve_II()),Data.Generic.BaseClasses.Stage(
        spe=2400/60,
        nomVal=Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-30000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=1.8),
        perCur=PerformanceCurves.Curve_III())})
    "Coil data"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  Modelica.Blocks.Sources.IntegerTable speRat(
    final table=[0.0,0.0;
                 900,1;
                 1800,4;
                 2700,3;
                 3600,2])
    "Speed ratio "
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));

  Modelica.Blocks.Sources.Constant TConIn(
    final k=273.15 + 25)
    "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));

equation
  connect(sou.ports[1], mulStaDX.port_a)
                                        annotation (Line(
      points={{-20,-10},{-16,-10},{-16,10},{-10,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mulStaDX.port_b, sin.ports[1])
                                        annotation (Line(
      points={{10,10},{14,10},{14,-10},{20,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TEvaIn.y, sou.T_in) annotation (Line(
      points={{-79,-28},{-52,-28},{-52,-6},{-42,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p.y, sou.p_in) annotation (Line(
      points={{-79,10},{-62,10},{-62,-2},{-42,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat.y, mulStaDX.stage) annotation (Line(
      points={{-39,70},{-18,70},{-18,18},{-11,18}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(TConIn.y, mulStaDX.TOut) annotation (Line(
      points={{-79,50},{-46,50},{-46,13},{-11,13}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (             __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/DXCoils/AirSource/Examples/MultiStageCooling.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=3600),
            Documentation(info="<html>
<p>
This is a test model for
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.AirSource.MultiStageCooling\">
Buildings.Fluid.HeatExchangers.DXCoils.AirSource.MultiStageCooling</a>.
The model has open-loop control and time-varying input conditions.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 19, 2023 by Xing Lu and Karthik Devaprasad:<br/>
Updated model name.<br/>
Changed instance class for <code>mulStaDX</code> to
<a href=\"Buildings.Fluid.HeatExchangers.DXCoils.AirSource.MultiStageCooling\">AirSource.MultiStageCooling</a>.<br/>
Updated connection statements due to change in output interface instance on 
<code>mulStaDX</code> from <code>TConIn</code> to <code>TOut</code>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
July 26, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>
</html>"));
end MultiStageCooling;
