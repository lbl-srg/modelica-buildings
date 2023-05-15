within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Examples;
model WetCoil "Test model for WetCoil"
 extends Modelica.Icons.Example;
 package Medium =  Buildings.Media.Air;
  Modelica.Blocks.Sources.Constant p(
    k=101325) "Pressure"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.WetCoil wetCoi(
    redeclare package Medium = Medium,
    datCoi=datCoi,
    variableSpeedCoil=true,
    use_mCon_flow=false,
    redeclare
      Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoilCapacityAirSource
      coiCap) "Performs calculation for wet coil condition"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Modelica.Blocks.Sources.Constant TConIn(
    k=273.15 + 35) "Condenser inlet air temperature"
    annotation (Placement(transformation(extent={{-80,44},{-60,64}})));
  Modelica.Blocks.Sources.IntegerStep onOff(
    startTime=600) "Compressor on-off signal"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Modelica.Blocks.Sources.Ramp m_flow(
    duration=600,
    startTime=1200,
    height=1.05) "Mass flow rate of air"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Modelica.Blocks.Sources.Ramp XEvaIn(
    duration=600,
    startTime=2400,
    height=-0.002,
    offset=0.012) "Inlet mass-fraction"
    annotation (Placement(transformation(extent={{-80,-94},{-60,-74}})));
  Modelica.Blocks.Sources.Ramp hEvaIn(
    duration=600,
    startTime=2400,
    offset=60000,
    height=-10000) "Specific enthalpy of air entering the coil"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Modelica.Blocks.Sources.Ramp TEvaIn(
    duration=600,
    startTime=2400,
    height=-5,
    offset=273.15 + 29) "Inlet air temperature"
    annotation (Placement(transformation(extent={{-80,-26},{-60,-6}})));
  Modelica.Blocks.Sources.TimeTable speRat(table=[0.0,0.0; 900,0.25; 1800,0.50;
        2700,0.75]) "Speed ratio "
    annotation (Placement(transformation(extent={{-80,74},{-60,94}})));
  parameter Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.CoolingCoil datCoi(nSta=4, sta={
        Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Stage(
        spe=900/60,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-12000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=0.9),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Examples.PerformanceCurves.Curve_I_AirCooled()),
        Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Stage(
        spe=1200/60,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-18000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=1.2),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Examples.PerformanceCurves.Curve_I_AirCooled()),
        Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Stage(
        spe=1800/60,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-21000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=1.5),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Examples.PerformanceCurves.Curve_II_AirCooled()),
        Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Stage(
        spe=2400/60,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-30000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=1.8),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Examples.PerformanceCurves.Curve_III_AirCooled())})
    "Coil data" annotation (Placement(transformation(extent={{60,60},{80,80}})));
equation
  connect(p.y, wetCoi.p)   annotation (Line(
      points={{-59,-50},{-44,-50},{-44,7.6},{19,7.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TConIn.y, wetCoi.TConIn)   annotation (Line(
      points={{-59,54},{-44,54},{-44,15},{19,15}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow.y, wetCoi.m_flow)  annotation (Line(
      points={{-59,20},{-50,20},{-50,12.4},{19,12.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XEvaIn.y, wetCoi.XEvaIn)  annotation (Line(
      points={{-59,-84},{-38,-84},{-38,5},{19,5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hEvaIn.y, wetCoi.hEvaIn)  annotation (Line(
      points={{1,-30},{8,-30},{8,2.3},{19,2.3}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TEvaIn.y, wetCoi.TEvaIn)  annotation (Line(
      points={{-59,-16},{-50,-16},{-50,10},{19,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat.y, wetCoi.speRat)     annotation (Line(
      points={{-59,84},{-38,84},{-38,17.6},{19,17.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(onOff.y, wetCoi.stage) annotation (Line(
      points={{1,50},{10,50},{10,20},{19,20}},
      color={255,127,0},
      smooth=Smooth.None));
  annotation (experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/DXCoils/BaseClasses/Examples/WetCoil.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This example illustrates working of WetCoil block
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.WetCoil\">
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.WetCoil</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
Changed redeclare in <code>wetCoi</code> from instance <code>cooCap</code> with
class <code>CoolingCapacityAirCooled</code> to instance <code>coiCap</code> with
class <a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoilCapacityAirSource\">
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoilCapacityAirSource</a>.<br/>
Changed class for data record <code>datCoi</code> from <code>DXCoil</code> to
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.CoolingCoil\">
Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.CoolingCoil</a>.
</li>
<li>
January 11, 2021, by Michael Wetter:<br/>
Corrected <code>datCoi</code> to be a parameter.
</li>
<li>
April 10, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>
</html>"));
end WetCoil;
