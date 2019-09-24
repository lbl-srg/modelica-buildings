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
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  Modelica.Blocks.Sources.Constant qRadGai_flow(k=0) "Radiative heat gain"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1
    "Multiplex to combine signals into a vector"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  ThermalZone zon1(
    redeclare package Medium = Medium,
    idfName=idfName,
    weaName=weaName,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    zoneName="Thermal Zone 1",
    nPorts=2) "Thermal zone (core zone of the office building with 5 zones)"
    annotation (Placement(transformation(extent={{20,40},{60,80}})));
  ThermalZone zon2(
    redeclare package Medium = Medium,
    idfName=idfName,
    weaName=weaName,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    zoneName="Thermal Zone 2",
    nPorts=2)   "Thermal zone (core zone of the office building with 5 zones)"
    annotation (Placement(transformation(extent={{20,-60},{60,-20}})));

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
    annotation (Placement(transformation(extent={{10,20},{-10,40}})));
  Fluid.Sources.MassFlowSource_T bou1(
    redeclare package Medium = Medium,
    nPorts=1,
    m_flow=0,
    T=293.15) "Boundary condition"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Fluid.Sources.Boundary_pT freshAir(
    redeclare package Medium = Medium,
    nPorts=2)
    "Boundary condition"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Modelica.Blocks.Sources.Constant qLatGai_flow(k=0) "Latent heat gain"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Fluid.FixedResistances.PressureDrop duc1(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    linearized=true,
    from_dp=true,
    dp_nominal=100,
    m_flow_nominal=47*6/3600*1.2)
    "Duct resistance (to decouple room and outside pressure)"
    annotation (Placement(transformation(extent={{10,-80},{-10,-60}})));
  Fluid.Sources.MassFlowSource_T bou2(
    redeclare package Medium = Medium,
    nPorts=1,
    m_flow=0,
    T=293.15) "Boundary condition"
    annotation (Placement(transformation(extent={{-40,-110},{-20,-90}})));
equation
  connect(qRadGai_flow.y,multiplex3_1. u1[1])  annotation (Line(
      points={{-99,100},{-92,100},{-92,77},{-82,77}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(qConGai_flow.y,multiplex3_1. u2[1]) annotation (Line(
      points={{-99,70},{-82,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zon1.qGai_flow, multiplex3_1.y)
    annotation (Line(points={{18,70},{-59,70}}, color={0,0,127}));
  connect(multiplex3_1.u3[1], qLatGai_flow.y) annotation (Line(points={{-82,63},
          {-92,63},{-92,40},{-99,40}},  color={0,0,127}));
  connect(freshAir.ports[1], duc.port_b)
    annotation (Line(points={{-20,-48},{-16,-48},{-16,30},{-10,30}},
                                                   color={0,127,255}));
  connect(duc.port_a, zon1.ports[1])
    annotation (Line(points={{10,30},{38,30},{38,40.8}}, color={0,127,255}));
  connect(bou1.ports[1], zon1.ports[2])
    annotation (Line(points={{-20,0},{42,0},{42,40.8}}, color={0,127,255}));
  connect(duc1.port_a,zon2. ports[1]) annotation (Line(points={{10,-70},{38,-70},
          {38,-59.2}}, color={0,127,255}));
  connect(bou2.ports[1],zon2. ports[2]) annotation (Line(points={{-20,-100},{42,
          -100},{42,-59.2}}, color={0,127,255}));
  connect(zon2.qGai_flow, multiplex3_1.y) annotation (Line(points={{18,-30},{-50,
          -30},{-50,70},{-59,70}}, color={0,0,127}));
  connect(duc1.port_b, freshAir.ports[2]) annotation (Line(points={{-10,-70},{-16,
          -70},{-16,-52},{-20,-52}}, color={0,127,255}));
  annotation (Documentation(info="<html>
<p>
Model with two identical thermal zones that validates that they yield the same result.
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
      StopTime=432000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    Diagram(coordinateSystem(extent={{-140,-120},{140,120}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end TwoIdenticalZones;
