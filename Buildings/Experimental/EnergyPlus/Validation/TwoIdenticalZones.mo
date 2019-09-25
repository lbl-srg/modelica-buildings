within Buildings.Experimental.EnergyPlus.Validation;
model TwoIdenticalZones "Validation model with two identical zones"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air "Medium model";

  parameter String idfName=Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/Data/Experimental/EnergyPlus/Validation/TwoIdenticalZones.idf")
    "Name of the IDF file";
  parameter String weaName = Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw")
    "Name of the weather file";

  Modelica.Blocks.Sources.Constant qConGai_flow(k=0) "Convective heat gain"
    annotation (Placement(transformation(extent={{-180,90},{-160,110}})));
  Modelica.Blocks.Sources.Constant qRadGai_flow(k=0) "Radiative heat gain"
    annotation (Placement(transformation(extent={{-180,120},{-160,140}})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1
    "Multiplex to combine signals into a vector"
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
  ThermalZone zon1(
    redeclare package Medium = Medium,
    idfName=idfName,
    weaName=weaName,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    zoneName="Thermal Zone 1",
    nPorts=3) "Thermal zone (core zone of the office building with 5 zones)"
    annotation (Placement(transformation(extent={{-40,70},{0,110}})));
  ThermalZone zon2(
    redeclare package Medium = Medium,
    idfName=idfName,
    weaName=weaName,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    zoneName="Thermal Zone 2",
    nPorts=2)   "Thermal zone (core zone of the office building with 5 zones)"
    annotation (Placement(transformation(extent={{-40,-30},{0,10}})));

//  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=weaName)
//    "Weather data reader"
//    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));

  Fluid.FixedResistances.PressureDrop duc(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    linearized=true,
    from_dp=true,
    dp_nominal=100,
    m_flow_nominal=47*6/3600*1.2)
    "Duct resistance (to decouple room and outside pressure)"
    annotation (Placement(transformation(extent={{-50,50},{-70,70}})));
  Fluid.Sources.MassFlowSource_T bou1(
    redeclare package Medium = Medium,
    nPorts=1,
    m_flow=0,
    T=293.15) "Boundary condition"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Fluid.Sources.Boundary_pT freshAir(
    redeclare package Medium = Medium,
    nPorts=2)
    "Boundary condition"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Modelica.Blocks.Sources.Constant qLatGai_flow(k=0) "Latent heat gain"
    annotation (Placement(transformation(extent={{-180,60},{-160,80}})));
  Fluid.FixedResistances.PressureDrop duc1(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    linearized=true,
    from_dp=true,
    dp_nominal=100,
    m_flow_nominal=47*6/3600*1.2)
    "Duct resistance (to decouple room and outside pressure)"
    annotation (Placement(transformation(extent={{-50,-50},{-70,-30}})));
  Fluid.Sources.MassFlowSource_T bou2(
    redeclare package Medium = Medium,
    nPorts=1,
    m_flow=0,
    T=293.15) "Boundary condition"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  Modelica.Blocks.Sources.CombiTimeTable datRea(
    tableOnFile=true,
    fileName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Experimental/EnergyPlus/Validation/TwoIdenticalZones.dat"),
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    tableName="EnergyPlus",
    columns=2:5,
    y(each unit="K", each displayUnit="degC"),
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint)
    "Data reader with results from EnergyPlus"
    annotation (Placement(transformation(extent={{40,120},{60,140}})));

  Controls.OBC.UnitConversions.From_degC TAirEnePlu
    "Room air temperature computed by EnergyPlus"
    annotation (Placement(transformation(extent={{100,120},{120,140}})));
  Controls.OBC.CDL.Continuous.Gain relHumEnePlu(k=0.01)
    "Relative humidity in the room computed by EnergyPlus"
    annotation (Placement(transformation(extent={{100,80},{120,100}})));
  Fluid.Sensors.RelativeHumidity senRelHum(redeclare package Medium = Medium)
    "Relative humidity in the room as computed by Modelica"
    annotation (Placement(transformation(extent={{100,40},{120,60}})));
equation
  connect(qRadGai_flow.y,multiplex3_1. u1[1])  annotation (Line(
      points={{-159,130},{-152,130},{-152,107},{-142,107}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(qConGai_flow.y,multiplex3_1. u2[1]) annotation (Line(
      points={{-159,100},{-142,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zon1.qGai_flow, multiplex3_1.y)
    annotation (Line(points={{-42,100},{-119,100}},
                                                color={0,0,127}));
  connect(multiplex3_1.u3[1], qLatGai_flow.y) annotation (Line(points={{-142,93},
          {-152,93},{-152,70},{-159,70}},
                                        color={0,0,127}));
  connect(freshAir.ports[1], duc.port_b)
    annotation (Line(points={{-80,-18},{-76,-18},{-76,60},{-70,60}},
                                                   color={0,127,255}));
  connect(duc.port_a, zon1.ports[1])
    annotation (Line(points={{-50,60},{-22.6667,60},{-22.6667,70.8}},
                                                         color={0,127,255}));
  connect(bou1.ports[1], zon1.ports[2])
    annotation (Line(points={{-80,30},{-20,30},{-20,70.8}},
                                                        color={0,127,255}));
  connect(duc1.port_a,zon2. ports[1]) annotation (Line(points={{-50,-40},{-22,-40},
          {-22,-29.2}},color={0,127,255}));
  connect(bou2.ports[1],zon2. ports[2]) annotation (Line(points={{-80,-70},{-18,
          -70},{-18,-29.2}}, color={0,127,255}));
  connect(zon2.qGai_flow, multiplex3_1.y) annotation (Line(points={{-42,0},{-110,
          0},{-110,100},{-119,100}},
                                   color={0,0,127}));
  connect(duc1.port_b, freshAir.ports[2]) annotation (Line(points={{-70,-40},{-76,
          -40},{-76,-22},{-80,-22}}, color={0,127,255}));
  connect(TAirEnePlu.u, datRea.y[3])
    annotation (Line(points={{98,130},{61,130}}, color={0,0,127}));
  connect(relHumEnePlu.u, datRea.y[4]) annotation (Line(points={{98,90},{80,90},
          {80,130},{61,130}}, color={0,0,127}));
  connect(senRelHum.port, zon1.ports[3]) annotation (Line(points={{110,40},{110,
          30},{-17.3333,30},{-17.3333,70.8}}, color={0,127,255}));
  annotation (Documentation(info="<html>
<p>
Model with two identical thermal zones that validates that they yield the same indoor air temperatures and humidity,
and that these results are close to the values computed by EnergyPlus 9.1.
</p>
<p>
Each zone has a floor area of <i>900</i> m<sup>2</sup>,
the same door and two windows on the south side.
The internal gains for lighting, people and equipment are identical.
The zones are detached and do not shade each other.
</p>
</html>", revisions="<html>
<ul><li>
September 23, 2019, by Michael Wetter and Yanfei Li:<br/>
First implementation.
</li>
</ul>
</html>"),
 __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/EnergyPlus/Validation/TwoIdenticalZones.mos"
        "Simulate and plot"),
experiment(
      StopTime=1209600,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    Diagram(coordinateSystem(extent={{-200,-160},{200,160}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end TwoIdenticalZones;
