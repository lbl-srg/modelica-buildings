within Buildings.Examples.DistrictReservoirNetworks.Agents;
model BoreField "Borefield model"
  extends Buildings.Fluid.Geothermal.Borefields.TwoUTubes(
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final tLoaAgg(displayUnit="h") = 3600,
    final nSeg=5,
    TExt0_start=282.55,
    final z0=10,
    final dT_dz=0.02,
    final dynFil=true,
    borFieDat(
      final filDat=Buildings.Fluid.Geothermal.Borefields.Data.Filling.Bentonite(
          kFil=2.0,
          cFil=3040,
          dFil=1450),
      final soiDat=Buildings.Fluid.Geothermal.Borefields.Data.Soil.SandStone(
          kSoi=2.3,
          cSoi=1000,
          dSoi=2600),
      final conDat=
          Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
          borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel,
          dp_nominal=35000,
          hBor=250,
          rBor=0.19,
          nBor=350,
          cooBor={dBor*{mod(i - 1, 10),floor((i - 1)/10)} for i in 1:350},
          rTub=0.04,
          kTub=0.4,
          eTub=0.0037,
          xC=0.08)),
    final show_T=true);

  final parameter Integer dBor = 10 "Distance between boreholes";
  Modelica.Blocks.Interfaces.RealOutput Q_flow(final unit="W") "Heat extracted from soil"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));
equation
  connect(gaiQ_flow.y, Q_flow) annotation (Line(points={{1,80},{14,80},{14,54},{
          96,54},{96,80},{110,80}}, color={0,0,127}));
end BoreField;
