within Buildings.Fluid.DXSystems.BaseClasses.Examples;
model DryCoil "Test model for DryCoil"
extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air;
  Modelica.Blocks.Sources.Constant TConIn(
    k=273.15 + 35) "Condenser inlet air temperature"
    annotation (Placement(transformation(extent={{-80,46},{-60,66}})));
  Buildings.Fluid.DXSystems.BaseClasses.DryCoil dryCoi(
    redeclare package Medium = Medium,
    datCoi=datCoi,
    variableSpeedCoil=true,
    redeclare
      Buildings.Fluid.DXSystems.Cooling.BaseClasses.CapacityAirSource
      coiCap,
    use_mCon_flow=false) "Performs calculation for dry coil condition"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Sources.IntegerStep onOff(
    startTime=1200) "Compressor on-off signal"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Modelica.Blocks.Sources.Ramp m_flow(
    startTime=1200,
    duration=600,
    height=1.5) "Mass flow rate of air"
    annotation (Placement(transformation(extent={{-80,12},{-60,32}})));
  Modelica.Blocks.Sources.Ramp TEvaIn(
    duration=600,
    startTime=2400,
    height=-4,
    offset=273.15 + 29) "Dry bulb temperature of air entering the coil"
    annotation (Placement(transformation(extent={{-80,-28},{-60,-8}})));
  Modelica.Blocks.Sources.TimeTable speRat(table=[0.0,0.0; 900,0.25; 1800,0.50;
        2700,0.75]) "Speed ratio "
    annotation (Placement(transformation(extent={{-80,76},{-60,96}})));

  parameter Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.Coil datCoi(
    sta={
      Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
        spe=900/60,
        nomVal=
          Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-12000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=0.9),
        perCur=
          Buildings.Fluid.DXSystems.Cooling.BaseClasses.Examples.PerformanceCurves.Curve_I_AirCooled()),
      Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
        spe=1200/60,
        nomVal=
          Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-18000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=1.2),
        perCur=
          Buildings.Fluid.DXSystems.Cooling.BaseClasses.Examples.PerformanceCurves.Curve_I_AirCooled()),
      Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
        spe=1800/60,
        nomVal=
          Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-21000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=1.5),
        perCur=
          Buildings.Fluid.DXSystems.Cooling.BaseClasses.Examples.PerformanceCurves.Curve_II_AirCooled()),
      Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
        spe=2400/60,
        nomVal=
          Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-30000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=1.8),
        perCur=
          Buildings.Fluid.DXSystems.Cooling.BaseClasses.Examples.PerformanceCurves.Curve_III_AirCooled())},
      nSta=4)
    "Coil data"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
equation
  connect(TConIn.y, dryCoi.TConIn)  annotation (Line(
      points={{-59,56},{-42,56},{-42,5},{19,5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow.y, dryCoi.m_flow)  annotation (Line(
      points={{-59,22},{-48,22},{-48,2.4},{19,2.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TEvaIn.y, dryCoi.TEvaIn)  annotation (Line(
      points={{-59,-18},{-48,-18},{-48,6.10623e-16},{19,6.10623e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat.y, dryCoi.speRat)     annotation (Line(
      points={{-59,86},{-36,86},{-36,7.6},{19,7.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(onOff.y, dryCoi.stage) annotation (Line(
      points={{1,30},{10,30},{10,10},{19,10}},
      color={255,127,0},
      smooth=Smooth.None));
  annotation (experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/DXSystems/BaseClasses/Examples/DryCoil.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This example illustrates working of DryCoil block
<a href=\"modelica://Buildings.Fluid.DXSystems.BaseClasses.DryCoil\">
Buildings.Fluid.DXSystems.BaseClasses.DryCoil</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 5, 2023, by Karthik Devaprasad and Xing Lu:<br/>
Changed instance from <code>cooCap</code> with class <code>CoolingCapacityAirCooled</code>
to <code>coiCap</code> with class <a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.BaseClasses.CapacityAirSource\">
Buildings.Fluid.DXSystems.Cooling.BaseClasses.CapacityAirSource</a>.
<br/>
Updated class for data record <code>datCoi</code> from <code>DXCoil</code> to
<a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.CoilHeatTransfer\">
Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.CoilHeatTransfer</a>.
</li>
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
end DryCoil;
