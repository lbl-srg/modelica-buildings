within Buildings.Examples.DemandFlexibility.ThermalZones.Subsequences;
block ModelicaRoom
          package MediumAir = Buildings.Media.Air;
  package MediumWater = Buildings.Media.Water;
    package MediumPropyleneGlycol =
      Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=273.15+50, X_a=
            0.4);

parameter Modelica.Units.SI.HeatCapacity C=250*1014.54*1.2
    "Heat capacity of element (= cp*m)";
  parameter Modelica.Units.SI.Height hRoo=2.4384 "Room height";
   parameter Modelica.Units.SI.Area AFlo=37 "Floor area";

   final parameter Modelica.Units.SI.Length LengthFlo=6.096 "length of floor";
   final parameter Modelica.Units.SI.Length WidthFlo=AFlo/LengthFlo "width of floor";
final parameter Modelica.Units.SI.Volume VRoo= AFlo*hRoo "Room volume";
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather Data Bus"
    annotation (Placement(transformation(extent={{90,128},{110,148}}),
        iconTransformation(extent={{286,104},{306,124}})));
  Modelica.Blocks.Interfaces.RealOutput TZon annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={334,210})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        MediumAir)
    annotation (Placement(transformation(extent={{84,74},{104,94}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        MediumAir)
    annotation (Placement(transformation(extent={{514,78},{534,98}})));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic conExtWal(
    final nLay=1,
    material={matBergSip},
    absSol_a=0.7,
    absSol_b=0.7,
    roughness_a=Buildings.HeatTransfer.Types.SurfaceRoughness.Smooth)
    "Exterior construction"
    annotation (Placement(transformation(extent={{392,176},{412,196}})));
  Buildings.ThermalZones.Detailed.MixedAir roo(
    datConExt(
      layers={conRoof,conExtWal,conExtWal,conExtWal,conExtWal},
      A={LengthFlo*WidthFlo,LengthFlo*hRoo,LengthFlo*hRoo,WidthFlo*hRoo,
          WidthFlo*hRoo},
      til={Buildings.Types.Tilt.Ceiling,Buildings.Types.Tilt.Wall,Buildings.Types.Tilt.Wall,
          Buildings.Types.Tilt.Wall,Buildings.Types.Tilt.Wall},
      azi={Buildings.Types.Azimuth.S,Buildings.Types.Azimuth.N,Buildings.Types.Azimuth.S,
          Buildings.Types.Azimuth.W,Buildings.Types.Azimuth.E}),
    datConBou(
      layers={conFloor},
      each A=LengthFlo*WidthFlo,
      each til=Buildings.Types.Tilt.Floor,
      each azi=Buildings.Types.Azimuth.S),
    redeclare package Medium = MediumAir,
    AFlo=AFlo,
    hRoo=hRoo,
    nConExt=5,
    nConExtWin=0,
    nConPar=0,
    nConBou=1,
    nSurBou=0,
    linearizeRadiation=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nPorts=2) "Floor"
    annotation (Placement(transformation(extent={{288,2},{328,42}})));
  Modelica.Blocks.Sources.Constant qConGai_flow(k=0) "Convective heat gain"
    annotation (Placement(transformation(extent={{162,26},{182,46}})));
  Modelica.Blocks.Sources.Constant qRadGai_flow(k=0) "Radiative heat gain"
    annotation (Placement(transformation(extent={{162,66},{182,86}})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1 "Multiplex"
    annotation (Placement(transformation(extent={{202,26},{222,46}})));
  Modelica.Blocks.Sources.Constant qLatGai_flow(k=0) "Latent heat gain"
    annotation (Placement(transformation(extent={{162,-14},{182,6}})));
  parameter Buildings.HeatTransfer.Data.Solids.Plywood matBergSip(
    x=0.053975,
    k=0.0204764,
    c=2343.04,
    d=37.4832042950667,
    nStaRef=1) "Wood for exterior construction"
    annotation (Placement(transformation(extent={{434,176},{454,196}})));
  parameter Buildings.HeatTransfer.Data.Solids.Plywood matBergRoof(
    x=0.0762,
    k=0.0253792,
    c=2343.04,
    d=37.4832042950667,
    nStaRef=1) "Wood for exterior construction"
    annotation (Placement(transformation(extent={{432,144},{452,164}})));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic conRoof(
    final nLay=1,
    material={matBergRoof},
    absSol_a=0.7,
    absSol_b=0.7,
    roughness_a=Buildings.HeatTransfer.Types.SurfaceRoughness.Smooth)
    "Exterior construction"
    annotation (Placement(transformation(extent={{392,144},{412,164}})));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic conFloor(
    final nLay=1,
    material={matBergFloor},
    absSol_a=0.7,
    absSol_b=0.7,
    roughness_a=Buildings.HeatTransfer.Types.SurfaceRoughness.Smooth)
    "Exterior construction"
    annotation (Placement(transformation(extent={{394,116},{414,136}})));
  parameter Buildings.HeatTransfer.Data.Solids.Plywood matBergFloor(
    x=0.0762,
    k=0.0253792,
    c=2343.04,
    d=37.4832042950667,
    nStaRef=1) "Wood for exterior construction"
    annotation (Placement(transformation(extent={{434,116},{454,136}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor
    annotation (Placement(transformation(extent={{286,146},{306,166}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
    annotation (Placement(transformation(extent={{210,-66},{230,-46}})));
  Modelica.Blocks.Interfaces.RealInput CustomHeatFlow annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={90,-62})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor(C=C)
    annotation (Placement(transformation(extent={{224,-12},{244,8}})));
equation
  connect(qRadGai_flow.y,multiplex3_1. u1[1])  annotation (Line(
      points={{183,76},{192,76},{192,43},{200,43}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(qConGai_flow.y,multiplex3_1. u2[1]) annotation (Line(
      points={{183,36},{200,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(qLatGai_flow.y,multiplex3_1. u3[1])  annotation (Line(
      points={{183,-4},{190,-4},{190,29},{200,29}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiplex3_1.y,roo. qGai_flow) annotation (Line(
      points={{223,36},{280,36},{280,30},{286.4,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(port_a, roo.ports[1]) annotation (Line(points={{94,84},{180,84},{180,
          92},{272,92},{272,11},{293,11}}, color={0,127,255}));
  connect(port_b, roo.ports[2]) annotation (Line(points={{524,88},{410,88},{410,
          -14},{293,-14},{293,13}}, color={0,127,255}));
  connect(roo.heaPorAir, temperatureSensor.port) annotation (Line(points={{307,
          22},{310,22},{310,50},{286,50},{286,156}}, color={191,0,0}));
  connect(TZon, temperatureSensor.T) annotation (Line(points={{334,210},{334,
          156},{307,156}},                     color={0,0,127}));
  connect(preHeaFlo.port, roo.heaPorAir) annotation (Line(points={{230,-56},{
          308,-56},{308,-48},{307,-48},{307,22}},
                                                color={191,0,0}));
  connect(preHeaFlo.Q_flow, CustomHeatFlow) annotation (Line(points={{210,-56},
          {102,-56},{102,-62},{90,-62}}, color={0,0,127}));
  connect(heatCapacitor.port, roo.heaPorAir) annotation (Line(points={{234,-12},
          {234,-18},{274,-18},{274,22},{307,22}},          color={191,0,0}));
  connect(weaBus, roo.weaBus) annotation (Line(
      points={{100,138},{325.9,138},{325.9,39.9}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{100,
            -100},{520,200}},
        grid={2,2})),                                            Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{100,-100},{520,200}},
        grid={2,2})),
    experiment(
      StartTime=24192000,
      StopTime=24364800,
      Interval=60,
      __Dymola_Algorithm="Dassl"));
end ModelicaRoom;
