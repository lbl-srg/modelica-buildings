within Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Examples;
model SingleSpeedHeating "Test model for single speed DX heating coil"
  package Medium = Buildings.Media.Air;
  extends Modelica.Icons.Example;
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=datCoi.sta[datCoi.nSta].nomVal.m_flow_nominal
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dp_nominal=1000
    "Pressure drop at m_flow_nominal";

  parameter
    Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.HeatingCoil
    datCoi(sta={
        Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Stage(
        spe=1800/60,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.NominalValues(
          activate_CooCoi=false,
          Q_flow_nominal=16381.47714,
          COP_nominal=3.90494,
          SHR_nominal=1,
          m_flow_nominal=2,
          TEvaIn_nominal=273.15 - 5,
          TConIn_nominal=273.15 + 21),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Examples.PerformanceCurves.DXHeating_Curve_I())},
                nSta=1) "Coil data"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  Buildings.Fluid.HeatExchangers.DXCoils.AirSource.SingleSpeedHeating
    sinSpeDX(
    redeclare package Medium = Medium,
    final dp_nominal=dp_nominal,
    final datCoi=datCoi,
    final T_start=datCoi.sta[1].nomVal.TConIn_nominal,
    final show_T=true,
    final from_dp=true,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Single speed DX coil"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));

  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    p(displayUnit="Pa") = 101325,
    T=303.15,
    nPorts=1)
    "Sink"
    annotation (Placement(transformation(extent={{40,-20},{20,0}})));

  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    use_T_in=true,
    use_p_in=true,
    nPorts=1)      "Source"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Modelica.Blocks.Sources.BooleanStep onOff(startTime=600)
    "Compressor on-off signal"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Blocks.Sources.Ramp TConIn(
    duration=600,
    startTime=2400,
    height=-3,
    offset=273.15 + 23) "Temperature"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));

  Modelica.Blocks.Sources.Ramp p(
    duration=600,
    startTime=600,
    height=dp_nominal,
    offset=101325) "Pressure"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));

  Modelica.Blocks.Sources.Constant TEvaIn(k=273.15 + 0)
    "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
equation
  connect(TConIn.y, sou.T_in) annotation (Line(
      points={{-79,-30},{-52,-30},{-52,-6},{-42,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(onOff.y, sinSpeDX.on)
                               annotation (Line(
      points={{-39,70},{-26,70},{-26,18},{-11,18}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(p.y, sou.p_in) annotation (Line(
      points={{-79,10},{-62,10},{-62,-2},{-42,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sinSpeDX.port_a, sou.ports[1]) annotation (Line(
      points={{-10,10},{-16,10},{-16,-10},{-20,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TEvaIn.y, sinSpeDX.TOut) annotation (Line(points={{-79,50},{-42,50},{-42,
          13},{-11,13}}, color={0,0,127}));
  connect(sinSpeDX.port_b, sin.ports[1]) annotation (Line(
      points={{10,10},{16,10},{16,-10},{20,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (             __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/DXCoils/AirSource/Examples/SingleSpeedHeating.mos"
        "Simulate and plot"),
    experiment(
      StopTime=3600,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
            Documentation(info="<html>
<p>
This is an example model for
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.AirSource.SingleSpeedHeating\">
Buildings.Fluid.HeatExchangers.DXCoils.AirSource.SingleSpeedHeating</a>.
The model has time-varying control signals and input conditions.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 08, 2023 by Xing Lu and Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end SingleSpeedHeating;
