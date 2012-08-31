within Buildings.Fluid.HeatExchangers.DXCoils.Examples;
model VarSpeed "Test model for variable speed DX coil"
  package Medium = Buildings.Media.GasesConstantDensity.MoistAirUnsaturated;
  extends Modelica.Icons.Example;
 parameter Modelica.SIunits.MassFlowRate m_flow_nominal = datCoi.per[datCoi.nSpe].nomVal.m_flow_nominal
    "Nominal mass flow rate";
 parameter Modelica.SIunits.Pressure dp_nominal = 1000
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
  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
   "Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos",
    TDryBulSou=Buildings.BoundaryConditions.Types.DataSource.File,
    relHumSou=Buildings.BoundaryConditions.Types.DataSource.File)
    "weather data"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  Buildings.Fluid.HeatExchangers.DXCoils.VarSpeed varSpeDX(
    redeclare package Medium = Medium,
    dp_nominal=dp_nominal,
    datCoi=datCoi,
    nSpe=datCoi.nSpe,
    minSpeRat=datCoi.minSpeRat,
    T_start=datCoi.per[1].nomVal.TIn_nominal) "Variable speed DX coil"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  Modelica.Blocks.Sources.Ramp TIn(
    duration=600,
    startTime=900,
    height=5,
    offset=273.15 + 20) "temperature"
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
  Data.CoilData datCoi(nSpe=4, per={
        Buildings.Fluid.HeatExchangers.DXCoils.Data.BaseClasses.Generic(
        spe=900,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.Data.BaseClasses.NominalValues(
          Q_flow_nominal=-12000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=0.9),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.Data.PerformanceCurves.Curve_I()),
              Buildings.Fluid.HeatExchangers.DXCoils.Data.BaseClasses.Generic(
        spe=1200,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.Data.BaseClasses.NominalValues(
          Q_flow_nominal=-18000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=1.2),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.Data.PerformanceCurves.Curve_I()),
              Buildings.Fluid.HeatExchangers.DXCoils.Data.BaseClasses.Generic(
        spe=1800,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.Data.BaseClasses.NominalValues(
          Q_flow_nominal=-21000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=1.5),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.Data.PerformanceCurves.Curve_II()),
              Buildings.Fluid.HeatExchangers.DXCoils.Data.BaseClasses.Generic(
        spe=2400,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.Data.BaseClasses.NominalValues(
          Q_flow_nominal=-30000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=1.8),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.Data.PerformanceCurves.Curve_III())})
    "Coil data"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
equation
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-80,30},{-70,30}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(sou.ports[1], varSpeDX.port_a)
                                        annotation (Line(
      points={{-20,-10},{-16,-10},{-16,10},{-10,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(varSpeDX.port_b, sin.ports[1])
                                        annotation (Line(
      points={{10,10},{14,10},{14,-10},{20,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TIn.y, sou.T_in) annotation (Line(
      points={{-79,-30},{-52,-30},{-52,-6},{-42,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaBus.TDryBul, varSpeDX.TConIn)
                                          annotation (Line(
      points={{-70,30},{-34,30},{-34,13},{-11,13}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(speRat.y, varSpeDX.speRat)   annotation (Line(
      points={{-63,60},{-22,60},{-22,17},{-11,17}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p.y, sou.p_in) annotation (Line(
      points={{-79,2},{-61.5,2},{-61.5,-2},{-42,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics),
             __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/DXCoils/Examples/VarSpeed.mos"
        "Simulate and plot"),
    experiment(StopTime=3600),
    experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}})),
            Documentation(info="<html>
<p>
This is a test model for variable speed DX Cooling Coil: 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.VarSpeed\"> Buildings.Fluid.HeatExchangers.DXCoils.VarSpeed</a> 
</p>
</html>",
revisions="<html>
<ul>
<li>
July 26, 2012 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>

</html>"));
end VarSpeed;
