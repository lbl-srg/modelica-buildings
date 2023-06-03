within Buildings.Fluid.DXSystems.Heating.AirSource.Examples;
model SingleSpeed "Test model for single speed DX heating coil"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Air
    "Fluid medium for the model";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=datCoi.sta[datCoi.nSta].nomVal.m_flow_nominal
    "Nominal mass flow rate";

  parameter Modelica.Units.SI.PressureDifference dp_nominal=1000
    "Pressure drop at m_flow_nominal";

  parameter
    Buildings.Fluid.DXSystems.Heating.AirSource.Data.Generic.Coil
    datCoi(
    nSta=1,
    minSpeRat=0.2,
    sta={
        Buildings.Fluid.DXSystems.Heating.AirSource.Data.Generic.BaseClasses.Stage(
        spe=1800/60,
        nomVal=
          Buildings.Fluid.DXSystems.Heating.AirSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=16381.47714,
          COP_nominal=3.90494,
          SHR_nominal=1,
          m_flow_nominal=2,
          TEvaIn_nominal=273.15 - 5,
          TConIn_nominal=273.15 + 21),
        perCur=
          Buildings.Fluid.DXSystems.Heating.AirSource.Examples.PerformanceCurves.Curve_I())},
    final defOpe=Buildings.Fluid.DXSystems.Heating.BaseClasses.Types.DefrostOperation.resistive,
    final defTri=Buildings.Fluid.DXSystems.Heating.BaseClasses.Types.DefrostTimeMethods.timed,
    final tDefRun=1/6,
    final TDefLim=273.65,
    final QDefResCap=10500,
    final QCraCap=200)
    "DX heating coil data record"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));


  Buildings.Fluid.DXSystems.Heating.AirSource.SingleSpeed sinSpeDX(
    final datCoi=datCoi,
    redeclare package Medium = Medium,
    final dp_nominal=dp_nominal,
    final T_start=datCoi.sta[1].nomVal.TConIn_nominal,
    final show_T=true,
    final from_dp=true,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final dTHys=1e-6)
    "Single speed DX coil"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    final p(displayUnit="Pa") = 101325,
    final T=303.15,
    final nPorts=1)
    "Sink"
    annotation (Placement(transformation(extent={{68,-30},{48,-10}})));

  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    final use_T_in=true,
    final use_p_in=true,
    final nPorts=1)
    "Source"
    annotation (Placement(transformation(extent={{-20,-58},{0,-38}})));

  Modelica.Blocks.Sources.BooleanStep onOff(
    final startTime=600)
    "Compressor on-off signal"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));

  Modelica.Blocks.Sources.Ramp TConIn(
    final duration=600,
    final startTime=2400,
    final height=-3,
    final offset=273.15 + 23)
    "Temperature"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));

  Modelica.Blocks.Sources.Ramp p(
    final duration=600,
    final startTime=600,
    final height=dp_nominal,
    final offset=101325)
    "Pressure"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

  Modelica.Blocks.Sources.Constant TEvaIn(
    final k=273.15 + 0)
    "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{-80,-8},{-60,12}})));

  Modelica.Blocks.Sources.Constant phi(final k=0.1)
    "Outside air relative humidity"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));

equation
  connect(TConIn.y, sou.T_in) annotation (Line(
      points={{-59,-70},{-30,-70},{-30,-44},{-22,-44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(onOff.y, sinSpeDX.on)
                               annotation (Line(
      points={{-19,60},{0,60},{0,11},{19,11}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(p.y, sou.p_in) annotation (Line(
      points={{-59,-40},{-22,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sinSpeDX.port_a, sou.ports[1]) annotation (Line(
      points={{20,0},{12,0},{12,-48},{0,-48}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TEvaIn.y, sinSpeDX.TOut) annotation (Line(points={{-59,2},{-58,2},{
          -58,3},{19,3}},color={0,0,127}));
  connect(sinSpeDX.port_b, sin.ports[1]) annotation (Line(
      points={{40,0},{44,0},{44,-20},{48,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sinSpeDX.phi, phi.y) annotation (Line(points={{19,7},{-50,7},{-50,40},
          {-59,40}}, color={0,0,127}));
  annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/DXSystems/Heating/AirSource/Examples/SingleSpeed.mos"
        "Simulate and plot"),
    experiment(
      StopTime=3600,
      Tolerance=1e-06),
            Documentation(info="<html>
<p>
This is an example model for
<a href=\"modelica://Buildings.Fluid.DXSystems.Heating.AirSource.SingleSpeed\">
Buildings.Fluid.DXSystems.Heating.AirSource.SingleSpeed</a>.
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
end SingleSpeed;
