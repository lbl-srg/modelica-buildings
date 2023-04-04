within Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Examples;
model SingleSpeedHeating "Test model for single speed DX heating coil"
  package Medium = Buildings.Media.Air;
  extends Modelica.Icons.Example;
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=datCoi.sta[datCoi.nSta].nomVal.m_flow_nominal
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dp_nominal=1000
    "Pressure drop at m_flow_nominal";

  Buildings.Fluid.HeatExchangers.DXCoils.AirSource.SingleSpeedHeating sinSpeDX(
    datCoi(
      final nSta=datCoi.nSta,
      final minSpeRat=datCoi.minSpeRat,
      final sta=datCoi.sta),
    redeclare package Medium = Medium,
    final dp_nominal=dp_nominal,
    final T_start=datCoi.sta[1].nomVal.TConIn_nominal,
    final show_T=true,
    final from_dp=true,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final datDef=datDef)
    "Single speed DX coil"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    p(displayUnit="Pa") = 101325,
    T=303.15,
    nPorts=1)
    "Sink"
    annotation (Placement(transformation(extent={{68,-30},{48,-10}})));

  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    use_T_in=true,
    use_p_in=true,
    nPorts=1)      "Source"
    annotation (Placement(transformation(extent={{-12,-30},{8,-10}})));
  Modelica.Blocks.Sources.BooleanStep onOff(startTime=600)
    "Compressor on-off signal"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Modelica.Blocks.Sources.Ramp TConIn(
    duration=600,
    startTime=2400,
    height=-3,
    offset=273.15 + 23) "Temperature"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

  Modelica.Blocks.Sources.Ramp p(
    duration=600,
    startTime=600,
    height=dp_nominal,
    offset=101325) "Pressure"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));

  Modelica.Blocks.Sources.Constant TEvaIn(k=273.15 + 0)
    "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Modelica.Blocks.Sources.Constant XEvaIn(k=0.001/1.001)
    "Evaporator inlet humidity ratio"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));

  parameter
    Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.CoilHeatTransfer
    datCoi(
    activate_CooCoi=false,
    nSta=1,
    minSpeRat=0.2,
    sta={
        Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Stage(
        spe=1800/60,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=16381.47714,
          COP_nominal=3.90494,
          SHR_nominal=1,
          m_flow_nominal=2,
          TEvaIn_nominal=273.15 - 5,
          TConIn_nominal=273.15 + 21),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Examples.PerformanceCurves.DXHeating_Curve_II())})
                "Coil heat transfer data record"
    annotation (Placement(transformation(extent={{60,34},{80,54}})));

  parameter Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Defrost datDef(
    final defOpe=Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Types.DefrostOperation.resistive,
    final defTri=Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Types.DefrostTimeMethods.timed,
    final tDefRun=1/6,
    final TDefLim=273.65,
    final QDefResCap=10500,
    final QCraCap=200)
    "Heating coil defrost data"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));

equation
  connect(TConIn.y, sou.T_in) annotation (Line(
      points={{-59,-50},{-30,-50},{-30,-16},{-14,-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(onOff.y, sinSpeDX.on)
                               annotation (Line(
      points={{-19,60},{0,60},{0,8},{19,8}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(p.y, sou.p_in) annotation (Line(
      points={{-59,-20},{-40,-20},{-40,-12},{-14,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sinSpeDX.port_a, sou.ports[1]) annotation (Line(
      points={{20,0},{12,0},{12,-20},{8,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TEvaIn.y, sinSpeDX.TOut) annotation (Line(points={{-59,40},{-10,40},{-10,
          3},{19,3}},    color={0,0,127}));
  connect(sinSpeDX.port_b, sin.ports[1]) annotation (Line(
      points={{40,0},{44,0},{44,-20},{48,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(XEvaIn.y, sinSpeDX.XOut) annotation (Line(points={{-59,10},{-20,10},{-20,
          -9},{19,-9}},color={0,0,127}));
  annotation (             __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/DXCoils/AirSource/Examples/SingleSpeedHeating.mos"
        "Simulate and plot"),
    experiment(
      StopTime=3600,
      Tolerance=1e-06),
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
