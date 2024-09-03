within Buildings.Fluid.DXSystems.Cooling.BaseClasses.Examples;
model CoolingCapacityWaterCooled "Test model for CoolingCapacityWaterCooled"

  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air;
  Buildings.Fluid.DXSystems.Cooling.BaseClasses.CapacityWaterCooled
    cooCap(sta={sta},
    nSta=1) "Cooling capacity calculation"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Modelica.Blocks.Sources.Ramp m_flow(
    duration=2400,
    startTime=600,
    height=sta.nomVal.m_flow_nominal,
    offset=0) "Mass flow rate of air"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Sources.Ramp TWetBulIn(
    duration=2400,
    startTime=600,
    height=10,
    offset=273.15 + 19.4) "Air wet bulb temperature entering the coil"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Modelica.Blocks.Sources.IntegerStep onOff(startTime=600)
    "Compressor on-off signal"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.Blocks.Sources.Ramp TConIn(
    duration=2400,
    startTime=600,
    height=5,
    offset=273.15 + 30)
    "Condenser inlet temperature (Outside drybulb temperature)"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  parameter
  Buildings.Fluid.DXSystems.Cooling.WaterSource.Data.Generic.BaseClasses.Stage
   sta(nomVal(
    Q_flow_nominal=-21000,COP_nominal=3,SHR_nominal=0.8,
    m_flow_nominal=1.5,mCon_flow_nominal=1),
  perCur=Buildings.Fluid.DXSystems.Cooling.BaseClasses.Examples.PerformanceCurves.Curve_I_WaterCooled(),
    spe=188.49555921539) "Performance data"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  Modelica.Blocks.Sources.Ramp mCon_flow(
    duration=2400,
    startTime=600,
    offset=0,
    height=sta.nomVal.mCon_flow_nominal)
    "Mass flow rate of water at the condenser"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
equation
  connect(TConIn.y, cooCap.TConIn) annotation (Line(
      points={{-59,40},{-46,40},{-46,24.8},{-21,24.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow.y, cooCap.m_flow) annotation (Line(
      points={{-59,0},{-46,0},{-46,20},{-21,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(onOff.y, cooCap.stage) annotation (Line(
      points={{-59,80},{-32,80},{-32,30},{-21,30}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(TWetBulIn.y, cooCap.TEvaIn) annotation (Line(
      points={{-59,-40},{-32,-40},{-32,15.2},{-21,15.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mCon_flow.y, cooCap.mCon_flow) annotation (Line(points={{-59,-80},{-26,
          -80},{-26,10},{-21,10}}, color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/DXSystems/Cooling/BaseClasses/Examples/CoolingCapacityWaterCooled.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This example illustrates working of cooling capacity function
<a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.BaseClasses.CapacityWaterCooled\">
Buildings.Fluid.DXSystems.Cooling.BaseClasses.CapacityWaterCooled</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 28, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end CoolingCapacityWaterCooled;
