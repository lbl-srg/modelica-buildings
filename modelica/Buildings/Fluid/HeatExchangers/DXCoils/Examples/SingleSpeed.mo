within Buildings.Fluid.HeatExchangers.DXCoils.Examples;
model SingleSpeed "Test model for single speed DX coil"
  package Medium = Buildings.Media.GasesConstantDensity.MoistAirUnsaturated;
  extends Modelica.Icons.Example;
 parameter Modelica.SIunits.MassFlowRate m_flow_nominal = datCoi.per[datCoi.nSpe].nomVal.m_flow_nominal
    "Nominal mass flow rate";
 parameter Modelica.SIunits.Pressure dp_nominal = 1000
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
  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    annotation (Placement(transformation(extent={{-78,40},{-58,60}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos",
    TDryBulSou=Buildings.BoundaryConditions.Types.DataSource.File,
    relHumSou=Buildings.BoundaryConditions.Types.DataSource.File)
    "Weather data"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  Modelica.Blocks.Sources.BooleanStep onOff(startTime=600)
    "Compressor on-off signal"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Blocks.Sources.Ramp TIn(
    duration=600,
    startTime=2400,
    height=-5,
    offset=273.15 + 24) "Temperature"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Fluid.HeatExchangers.DXCoils.SingleSpeed sinSpeDX(
    redeclare package Medium = Medium,
    dp_nominal=dp_nominal,
    datCoi=datCoi,
    T_start=datCoi.per[1].nomVal.TIn_nominal,
    show_T=true,
    from_dp=true) "Single speed DX coil"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));

  Modelica.Blocks.Sources.Ramp p(
    duration=600,
    startTime=600,
    height=dp_nominal,
    offset=101325) "Pressure"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Data.CoilData datCoi(
    per={
        Buildings.Fluid.HeatExchangers.DXCoils.Data.BaseClasses.Generic(
        spe=1800/60,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.Data.BaseClasses.NominalValues(
          Q_flow_nominal=-21000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=1.5),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.Data.PerformanceCurves.Curve_II())}, nSpe=
       1) "Coil data"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
equation
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-80,50},{-68,50}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(TIn.y, sou.T_in) annotation (Line(
      points={{-79,-30},{-52,-30},{-52,-6},{-42,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(onOff.y, sinSpeDX.on)
                               annotation (Line(
      points={{-39,70},{-26,70},{-26,18},{-11,18}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(weaBus.TDryBul, sinSpeDX.TConIn)
                                          annotation (Line(
      points={{-68,50},{-40,50},{-40,13},{-11,13}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
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
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics),
             __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/DXCoils/Examples/SingleSpeed.mos"
        "Simulate and plot"),
    experiment(StopTime=3600),
    experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}})),
            Documentation(info="<html>
<p>
This is a test model for
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.SingleSpeed\">
Buildings.Fluid.HeatExchangers.DXCoils.SingleSpeed</a>. 
The model has open-loop control and time-varying input conditions.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 12, 2012 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>

</html>"));
end SingleSpeed;
