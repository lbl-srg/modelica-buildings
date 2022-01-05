within Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Examples;
model VariableSpeed "Test model for variable speed DX coil"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Air "Medium model";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=datCoi.sta[datCoi.nSta].nomVal.m_flow_nominal
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dp_nominal=1000
    "Pressure drop at m_flow_nominal";
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=1,
    p(displayUnit="Pa") = 101325,
    T=293.15) "Sink"
    annotation (Placement(transformation(extent={{40,-20},{20,0}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    nPorts=1,
    p(displayUnit="Pa") = 101325 + dp_nominal,
    use_T_in=true,
    use_p_in=true,
    T=299.85) "Source"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.VariableSpeed varSpeDX(
    redeclare package Medium = Medium,
    dp_nominal=dp_nominal,
    datCoi=datCoi,
    minSpeRat=datCoi.minSpeRat,
    T_start=datCoi.sta[1].nomVal.TEvaIn_nominal,
    from_dp=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Variable speed DX coil"
    annotation (Placement(transformation(extent={{-10,2},{10,22}})));
  Modelica.Blocks.Sources.Ramp TEvaIn(
    duration=600,
    startTime=900,
    height=5,
    offset=273.15 + 20,
    y(unit="K")) "temperature"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Modelica.Blocks.Sources.TimeTable speRat(table=[0.0,0.0; 100,0.0; 900,0.2;
        1800,0.8; 2700,0.75; 3600,0.75]) "Speed ratio "
    annotation (Placement(transformation(extent={{-84,50},{-64,70}})));
  Modelica.Blocks.Sources.Ramp p(
    duration=600,
    height=dp_nominal,
    offset=101325,
    startTime=100) "Mass flow rate of air"
    annotation (Placement(transformation(extent={{-100,-8},{-80,12}})));
  parameter Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.DXCoil datCoi(
    nSta=4, sta={Data.Generic.BaseClasses.Stage(
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
        perCur=PerformanceCurves.Curve_III())}) "Coil data"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica.Blocks.Sources.Constant TConIn(k=273.15 + 25)
    "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
equation
  connect(sou.ports[1], varSpeDX.port_a)
                                        annotation (Line(
      points={{-20,-10},{-16,-10},{-16,12},{-10,12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(varSpeDX.port_b, sin.ports[1])
                                        annotation (Line(
      points={{10,12},{14,12},{14,-10},{20,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TEvaIn.y, sou.T_in) annotation (Line(
      points={{-79,-30},{-52,-30},{-52,-6},{-42,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat.y, varSpeDX.speRat)   annotation (Line(
      points={{-63,60},{-22,60},{-22,20},{-11,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p.y, sou.p_in) annotation (Line(
      points={{-79,2},{-61.5,2},{-61.5,-2},{-42,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(varSpeDX.TConIn, TConIn.y) annotation (Line(
      points={{-11,15},{-40.5,15},{-40.5,30},{-79,30}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (             __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/DXCoils/AirCooled/Examples/VariableSpeed.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=3600),
            Documentation(info="<html>
<p>
This is a test model for
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.VariableSpeed\">
Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.VariableSpeed</a>.
The model has open-loop control and time-varying input conditions.
</p>
</html>",
revisions="<html>
<ul>
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
end VariableSpeed;
