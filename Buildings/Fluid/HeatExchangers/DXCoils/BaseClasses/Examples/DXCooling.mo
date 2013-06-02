within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Examples;
model DXCooling "Test model for DXCooling"
  extends Modelica.Icons.Example;
  package Medium =
      Buildings.Media.GasesConstantDensity.MoistAirUnsaturated;
  Modelica.Blocks.Sources.Constant p(
    k=101325) "pressure"
    annotation (Placement(transformation(extent={{-80,-56},{-60,-36}})));
  Modelica.Blocks.Sources.Constant TConIn(
    k=273.15 + 35)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DXCooling dxCoo(
    redeclare package Medium = Medium,
    datCoi=datCoi,
    variableSpeedCoil=true)
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Modelica.Blocks.Sources.IntegerStep onOff(
    startTime=600) "Compressor on-off signal"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Sources.Ramp m_flow(
    duration=600,
    startTime=1200,
    height=1.05) "Mass flow rate of air"
    annotation (Placement(transformation(extent={{-80,8},{-60,28}})));
  Modelica.Blocks.Sources.Ramp TEvaIn(
    duration=600,
    startTime=2400,
    height=-5,
    offset=273.15 + 29) "Dry bulb temperature of air entering the coil"
    annotation (Placement(transformation(extent={{-80,-24},{-60,-4}})));
  Modelica.Blocks.Sources.Ramp XEvaIn(
    duration=600,
    startTime=2400,
    height=-0.002,
    offset=0.012) "Inlet mass-fraction"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Modelica.Blocks.Sources.Ramp hEvaIn(
    duration=600,
    startTime=2400,
    offset=60000,
    height=-10000) "Specific enthalpy of air entering the coil"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Modelica.Blocks.Sources.TimeTable speRat(table=[0.0,0.0; 900,0.25; 1800,0.50;
        2700,0.75]) "Speed ratio "
    annotation (Placement(transformation(extent={{-80,74},{-60,94}})));
  parameter Data.Generic.DXCoil
                datCoi(sta={
        Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage(
        spe=900/60,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-12000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=0.9),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage(
        spe=1200/60,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-18000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=1.2),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage(
        spe=1800/60,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-21000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=1.5),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage(
        spe=2400/60,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-30000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=1.8),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Examples.PerformanceCurves.Curve_III())},           nSta=
       4) "Coil data"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
equation
  connect(TConIn.y, dxCoo.TConIn)  annotation (Line(
      points={{-59,50},{-48,50},{-48,15},{-1,15}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p.y, dxCoo.p)  annotation (Line(
      points={{-59,-46},{-48,-46},{-48,7.6},{-1,7.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow.y, dxCoo.m_flow)  annotation (Line(
      points={{-59,18},{-52,18},{-52,12.4},{-1,12.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TEvaIn.y, dxCoo.TEvaIn)  annotation (Line(
      points={{-59,-14},{-52,-14},{-52,10},{-1,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XEvaIn.y, dxCoo.XEvaIn)  annotation (Line(
      points={{-59,-80},{-44,-80},{-44,5},{-1,5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hEvaIn.y, dxCoo.hEvaIn)  annotation (Line(
      points={{-19,-30},{-10,-30},{-10,2.3},{-1,2.3}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat.y, dxCoo.speRat)     annotation (Line(
      points={{-59,84},{-44,84},{-44,17.6},{-1,17.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(onOff.y, dxCoo.stage) annotation (Line(
      points={{-19,50},{-10,50},{-10,20},{-1,20}},
      color={255,127,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics),
experiment(StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/DXCoils/BaseClasses/Examples/DXCooling.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This example illustrates working of DXCooling block 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DXCooling\">
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DXCooling</a>. 
</p>
</html>",
revisions="<html>
<ul>
<li>
May 1, 2013, by Michael Wetter:<br/>
Declared the parameter record to be a parameter, as declaring its elements
to be parameters does not imply that the whole record has the variability of a parameter.
</li>
<li>
April 10, 2012 by Kaustubh Phalak:<br/>
First implementation. 
</li>
</ul>
</html>"));
end DXCooling;
