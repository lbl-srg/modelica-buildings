within Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Examples;
model SingleSpeed "Test model for single speed DX coil"
  package Medium = Buildings.Media.Air;
  extends Modelica.Icons.Example;
 parameter Modelica.SIunits.MassFlowRate m_flow_nominal = datCoi.sta[datCoi.nSta].nomVal.m_flow_nominal
    "Nominal mass flow rate";
 parameter Modelica.SIunits.PressureDifference dp_nominal = 1000
    "Pressure drop at m_flow_nominal";
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    p(displayUnit="Pa") = 101325,
    nPorts=1,
    T=303.15) "Sink"
    annotation (Placement(transformation(extent={{40,-20},{20,0}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    p(displayUnit="Pa") = 101325 + dp_nominal,
    use_T_in=true,
    nPorts=1,
    use_p_in=true,
    T=299.85) "Source"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Modelica.Blocks.Sources.BooleanStep onOff(startTime=600)
    "Compressor on-off signal"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Blocks.Sources.Ramp TEvaIn(
    duration=600,
    startTime=2400,
    height=-5,
    offset=273.15 + 23) "Temperature"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.SingleSpeed sinSpeDX(
    redeclare package Medium = Medium,
    dp_nominal=dp_nominal,
    datCoi=datCoi,
    T_start=datCoi.sta[1].nomVal.TEvaIn_nominal,
    show_T=true,
    from_dp=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Single speed DX coil"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));

  Modelica.Blocks.Sources.Ramp p(
    duration=600,
    startTime=600,
    height=dp_nominal,
    offset=101325) "Pressure"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.DXCoil datCoi(
    sta={Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.Stage(
        spe=1800/60,
        nomVal=Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-21000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=1.5),
        perCur=Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Examples.PerformanceCurves.Curve_II())}, nSta=1) "Coil data"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica.Blocks.Sources.Constant TConIn(k=273.15 + 25)
    "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
equation
  connect(TEvaIn.y, sou.T_in) annotation (Line(
      points={{-79,-30},{-52,-30},{-52,-6},{-42,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(onOff.y, sinSpeDX.on)
                               annotation (Line(
      points={{-39,70},{-26,70},{-26,18},{-11,18}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(sou.ports[1], sinSpeDX.port_a)
                                        annotation (Line(
      points={{-20,-10},{-16,-10},{-16,10},{-10,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sinSpeDX.port_b, sin.ports[1])
                                        annotation (Line(
      points={{10,10},{16,10},{16,-10},{20,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(p.y, sou.p_in) annotation (Line(
      points={{-79,10},{-62,10},{-62,-2},{-42,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TConIn.y, sinSpeDX.TConIn) annotation (Line(
      points={{-79,50},{-46,50},{-46,13},{-11,13}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (             __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/DXCoils/AirCooled/Examples/SingleSpeed.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=3600),
            Documentation(info="<html>
<p>
This is a test model for
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.SingleSpeed\">
Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.SingleSpeed</a>.
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
April 12, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>
</html>"));
end SingleSpeed;
