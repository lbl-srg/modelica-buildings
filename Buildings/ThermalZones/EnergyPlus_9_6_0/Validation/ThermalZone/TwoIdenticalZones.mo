within Buildings.ThermalZones.EnergyPlus_9_6_0.Validation.ThermalZone;
model TwoIdenticalZones
  "Validation model with two identical zones"
  extends Modelica.Icons.Example;
  inner Building building(
    idfName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/Data/ThermalZones/EnergyPlus_9_6_0/Validation/TwoIdenticalZones/TwoIdenticalZones.idf"),
    epwName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw"),
    weaName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Building level declarations"
    annotation (Placement(transformation(extent={{-70,-60},{-50,-40}})));
  Zone zon1(
    zoneName="Thermal Zone 1")
    "Thermal zone 1 (core zone of the office building with 5 zones)"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Zone zon2(
    zoneName="Thermal Zone 2")
    "Thermal zone 2 (core zone of the office building with 5 zones)"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  // Models for cross validation
  Modelica.Blocks.Sources.CombiTimeTable datRea(
    tableOnFile=true,
    fileName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/Data/ThermalZones/EnergyPlus_9_6_0/Validation/TwoIdenticalZones/TwoIdenticalZones.dat"),
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    tableName="EnergyPlus",
    columns=2:5,
    y(each unit="K",
      each displayUnit="degC"),
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint)
    "Data reader with results from EnergyPlus"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Controls.OBC.UnitConversions.From_degC TAirEnePlu
    "Room air temperature computed by EnergyPlus"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Controls.OBC.CDL.Continuous.MultiplyByParameter relHumEnePlu(k=0.01)
    "Relative humidity in the room computed by EnergyPlus"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));

  Buildings.ThermalZones.EnergyPlus_9_6_0.OutputVariable inf1(
    name="Zone Infiltration Current Density Volume Flow Rate",
    key="Thermal Zone 1")
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));

  model Zone
    "Model of a thermal zone"
    extends Modelica.Blocks.Icons.Block;
    package Medium=Buildings.Media.Air
      "Medium model";
    parameter String zoneName=""
      "Name of the thermal zone";
    parameter Modelica.Units.SI.MassFlowRate mOut_flow=0.3/3600*zon.V*Buildings.Media.Air.dStp
      "Outside air mass flow rate with 0.3 ACH";
    Modelica.Blocks.Sources.Constant qConGai_flow(
      k=0)
      "Convective heat gain"
      annotation (Placement(transformation(extent={{-90,30},{-70,50}})));
    Modelica.Blocks.Sources.Constant qRadGai_flow(
      k=0)
      "Radiative heat gain"
      annotation (Placement(transformation(extent={{-90,60},{-70,80}})));
    Modelica.Blocks.Routing.Multiplex3 multiplex3_1
      "Multiplex to combine signals into a vector"
      annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
    Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zon(
      redeclare package Medium=Medium,
      zoneName=zoneName,
      nPorts=3)
      "Thermal zone (core zone of the office building with 5 zones)"
      annotation (Placement(transformation(extent={{-18,6},{22,46}})));
    Fluid.FixedResistances.PressureDrop duc(
      redeclare package Medium=Medium,
      allowFlowReversal=false,
      linearized=true,
      from_dp=false,
      dp_nominal=100,
      m_flow_nominal=47*6/3600*1.2)
      "Duct resistance (to decouple room and outside pressure)"
      annotation (Placement(transformation(extent={{-30,-60},{-50,-40}})));
    Fluid.Sources.MassFlowSource_WeatherData bou(
      redeclare package Medium=Medium,
      m_flow=mOut_flow,
      nPorts=1)
      "Mass flow rate boundary condition"
      annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
    Fluid.Sources.Boundary_pT freshAir(
      redeclare package Medium=Medium,
      nPorts=1)
      "Pressure boundary condition"
      annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
    Modelica.Blocks.Sources.Constant qLatGai_flow(
      k=0)
      "Latent heat gain"
      annotation (Placement(transformation(extent={{-90,0},{-70,20}})));
    Fluid.Sensors.RelativeHumidity senRelHum(
      redeclare package Medium=Medium,
      warnAboutOnePortConnection=false)
      "Relative humidity in the room as computed by Modelica"
      annotation (Placement(transformation(extent={{50,-50},{70,-30}})));
    Modelica.Blocks.Interfaces.RealOutput TAir(
      final unit="K",
      displayUnit="degC")
      "Air temperature of the zone"
      annotation (Placement(transformation(extent={{100,30},{120,50}})));
    Modelica.Blocks.Interfaces.RealOutput TRad(
      final unit="K",
      displayUnit="degC")
      "Radiative temperature of the zone"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    Modelica.Blocks.Interfaces.RealOutput phi(
      final unit="1")
      "Relative humidity of zone air"
      annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
    BoundaryConditions.WeatherData.Bus weaBus
      "Bus with weather data"
      annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

  equation
    connect(qRadGai_flow.y,multiplex3_1.u1[1])
      annotation (Line(points={{-69,70},{-62,70},{-62,47},{-52,47}},color={0,0,127},smooth=Smooth.None));
    connect(qConGai_flow.y,multiplex3_1.u2[1])
      annotation (Line(points={{-69,40},{-52,40}},color={0,0,127},smooth=Smooth.None));
    connect(zon.qGai_flow,multiplex3_1.y)
      annotation (Line(points={{-20,36},{-24,36},{-24,40},{-29,40}},color={0,0,127}));
    connect(multiplex3_1.u3[1],qLatGai_flow.y)
      annotation (Line(points={{-52,33},{-62,33},{-62,10},{-69,10}},color={0,0,127}));
    connect(freshAir.ports[1],duc.port_b)
      annotation (Line(points={{-60,-50},{-50,-50}},color={0,127,255}));
    connect(zon.TAir,TAir)
      annotation (Line(points={{23,39.8},{58.5,39.8},{58.5,40},{110,40}},color={0,0,127}));
    connect(zon.TRad,TRad)
      annotation (Line(points={{23,36},{60,36},{60,0},{110,0}},color={0,0,127}));
    connect(senRelHum.phi,phi)
      annotation (Line(points={{71,-40},{110,-40}},color={0,0,127}));
    connect(duc.port_a,zon.ports[1])
      annotation (Line(points={{-30,-50},{-0.666667,-50},{-0.666667,6.9}},color={0,127,255}));
    connect(bou.ports[1],zon.ports[2])
      annotation (Line(points={{-60,-80},{2,-80},{2,6.9}},color={0,127,255}));
    connect(senRelHum.port,zon.ports[3])
      annotation (Line(points={{60,-50},{60,-60},{4.66667,-60},{4.66667,6.9}},color={0,127,255}));
    connect(bou.weaBus,weaBus)
      annotation (Line(points={{-80,-79.8},{-86,-79.8},{-86,-80},{-94,-80},{-94,0},{-100,0}},color={255,204,51},thickness=0.5));
  end Zone;
equation
  connect(TAirEnePlu.u,datRea.y[3])
    annotation (Line(points={{-2,70},{-39,70}},color={0,0,127}));
  connect(relHumEnePlu.u,datRea.y[4])
    annotation (Line(points={{-2,30},{-20,30},{-20,70},{-39,70}},color={0,0,127}));
  connect(building.weaBus,zon1.weaBus)
    annotation (Line(points={{-50,-50},{-20,-50},{-20,-30},{0,-30}},color={255,204,51},thickness=0.5));
  connect(building.weaBus,zon2.weaBus)
    annotation (Line(points={{-50,-50},{-20,-50},{-20,-70},{0,-70}},color={255,204,51},thickness=0.5));
  annotation (
    Documentation(
      info="<html>
<p>
Model with two identical thermal zones that validates that they yield the same indoor air temperatures and humidity,
and that these results are close to the values computed by EnergyPlus.
</p>
<p>
Each zone has a floor area of <i>900</i> m<sup>2</sup>,
the same door and two windows on the south side.
The internal gains for lighting, people and equipment are identical.
The zones are detached and do not shade each other.
The zones have an outside air exchange rate of <i>0.3</i> air changes per hour.
</p>
</html>",
      revisions="<html>
<ul>
<li>
September 23, 2019, by Michael Wetter and Yanfei Li:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus_9_6_0/Validation/ThermalZone/TwoIdenticalZones.mos" "Simulate and plot"),
    experiment(
      StopTime=604800,
      Tolerance=1e-06),
    Diagram(
      coordinateSystem(
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-74,-6},{80,-92}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-74,96},{80,10}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-70,96},{-40,86}},
          textColor={0,0,255},
          textString="EnergyPlus results"),
        Text(
          extent={{-70,-6},{-40,-16}},
          textColor={0,0,255},
          textString="Spawn results")}),
    Icon(
      coordinateSystem(
        extent={{-100,-100},{100,100}})));
end TwoIdenticalZones;
