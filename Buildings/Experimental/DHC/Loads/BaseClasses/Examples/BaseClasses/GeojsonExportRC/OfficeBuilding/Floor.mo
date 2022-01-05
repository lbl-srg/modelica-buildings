within Buildings.Experimental.DHC.Loads.BaseClasses.Examples.BaseClasses.GeojsonExportRC.OfficeBuilding;
model Floor
  "This is the simulation model of Floor within building OfficeBuilding"
  Buildings.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil[6](
    each outSkyCon=true,
    each outGroCon=true,
    til={1.5707963267949,1.5707963267949,1.5707963267949,1.5707963267949,0,0},
    azi={3.1415926535898,0,1.5707963267949,-1.5707963267949,0,0})
    "Calculates diffuse solar radiation on titled surface for all directions"
    annotation (Placement(transformation(extent={{-68,20},{-48,40}})));
  Buildings.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil[6](til={
        1.5707963267949,1.5707963267949,1.5707963267949,1.5707963267949,0,0},
      azi={3.1415926535898,0,1.5707963267949,-1.5707963267949,0,0})
    "Calculates direct solar radiation on titled surface for all directions"
    annotation (Placement(transformation(extent={{-68,52},{-48,72}})));
  Buildings.ThermalZones.ReducedOrder.SolarGain.CorrectionGDoublePane corGDoublePane(
    n=6,
    UWin=1.8936557576825381)
    "Correction factor for solar transmission"
    annotation (Placement(transformation(extent={{6,54},{26,74}})));
  Buildings.ThermalZones.ReducedOrder.RC.TwoElements thermalZoneTwoElements(
    redeclare package Medium=Buildings.Media.Air,
    VAir=3261.7921338576007,
    hConExt=2.0490178828959134,
    hConWin=2.7000000000000006,
    gWin=0.6699999999999999,
    ratioWinConRad=0.029999999999999995,
    nExt=1,
    RExt={2.3174831586466932e-05},
    CExt={408244783.5430907},
    hRad=5.0,
    AInt=5119.003369012401,
    hConInt=2.3902922093005254,
    nInt=1,
    RInt={1.3425684356446266e-05},
    CInt={573809361.8851968},
    RWin=0.002198739011727672,
    RExtRem=0.0012526070384860479,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    extWallRC(
      thermCapExt(
        each der_T(
          fixed=true))),
    intWallRC(
      thermCapInt(
        each der_T(
          fixed=true))),
    nOrientations=6,
    AWin={74.54769655777831,74.54769655777831,6.910119334253305,6.910119334253305,0.0,0.0},
    ATransparent={74.54769655777831,74.54769655777831,6.910119334253305,6.910119334253305,0.0,0.0},
    AExt={223.64308967333497,223.64308967333497,20.730358002759914,20.730358002759914,455.8011269000001,455.8011269000001})
    "Thermal zone"
    annotation (Placement(transformation(extent={{44,-2},{92,34}})));
  Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.VDI6007WithWindow eqAirTemp(
    n=6,
    wfGro=0.3626976838332763,
    wfWall={0.15582361279765053,0.15582361279765053,0.014443903825944522,0.014443903825944522,0.2967672829195336,0.0},
    wfWin={0.4575846758314001,0.4575846758314001,0.04241532416859994,0.04241532416859994,0.0,0.0},
    withLongwave=true,
    aExt=0.5,
    hConWallOut=20.0,
    hRad=5.0,
    hConWinOut=20.0,
    TGro=286.15)
    "Computes equivalent air temperature"
    annotation (Placement(transformation(extent={{-24,-14},{-4,6}})));
  Modelica.Blocks.Math.Add solRad[6]
    "Sums up solar radiation of both directions"
    annotation (Placement(transformation(extent={{-38,6},{-28,16}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature
    "Prescribed temperature for exterior walls outdoor surface temperature"
    annotation (Placement(transformation(extent={{8,-6},{20,6}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature1
    "Prescribed temperature for windows outdoor surface temperature"
    annotation (Placement(transformation(extent={{8,14},{20,26}})));
  Modelica.Thermal.HeatTransfer.Components.Convection thermalConductorWin
    "Outdoor convective heat transfer of windows"
    annotation (Placement(transformation(extent={{38,16},{28,26}})));
  Modelica.Thermal.HeatTransfer.Components.Convection thermalConductorWall
    "Outdoor convective heat transfer of walls"
    annotation (Placement(transformation(extent={{36,6},{26,-4}})));
  Modelica.Blocks.Sources.Constant const[6](
    each k=0)
    "Sets sunblind signal to zero (open)"
    annotation (Placement(transformation(extent={{-20,14},{-14,20}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    "Weather data bus"
    annotation (Placement(transformation(extent={{-100,-10},{-66,22}}),iconTransformation(extent={{-70,-12},{-50,8}})));
  Modelica.Blocks.Sources.Constant hConWall(
    k=25.0*1400.34914915219)
    "Outdoor coefficient of heat transfer for walls"
    annotation (Placement(transformation(extent={{-4,-4},{4,4}},rotation=90,origin={30,-16})));
  Modelica.Blocks.Sources.Constant hConWin(
    k=25.0*162.91563178406324)
    "Outdoor coefficient of heat transfer for windows"
    annotation (Placement(transformation(extent={{4,-4},{-4,4}},rotation=90,origin={32,38})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow personsRad
    "Radiative heat flow of persons"
    annotation (Placement(transformation(extent={{48,-42},{68,-22}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow personsConv
    "Convective heat flow of persons"
    annotation (Placement(transformation(extent={{48,-62},{68,-42}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow machinesConv
    "Convective heat flow of machines"
    annotation (Placement(transformation(extent={{48,-84},{68,-64}})));
  Modelica.Blocks.Sources.CombiTimeTable internalGains(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    tableName="Internals",
    fileName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/BaseClasses/GeojsonExportRC/OfficeBuilding/InternalGains_Floor.txt"),
    columns={2,3,4})
    "Table with profiles for persons (radiative and convective) and machines (convective)"
    annotation (Placement(transformation(extent={{6,-60},{22,-44}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
    "Heat port for sensible convective gains"
    annotation (Placement(transformation(extent={{-10,90},{10,110}}),iconTransformation(extent={{-10,90},{10,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TAir(
    quantity="ThermodynamicTemperature",
    unit="K",
    displayUnit="degC")
    "Room air temperature"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  connect(eqAirTemp.TEqAirWin,prescribedTemperature1.T)
    annotation (Line(points={{-3,-0.2},{0,-0.2},{0,20},{6.8,20}},color={0,0,127}));
  connect(eqAirTemp.TEqAir,prescribedTemperature.T)
    annotation (Line(points={{-3,-4},{4,-4},{4,0},{6.8,0}},color={0,0,127}));
  connect(weaBus.TDryBul,eqAirTemp.TDryBul)
    annotation (Line(points={{-83,6},{-83,-2},{-38,-2},{-38,-10},{-26,-10}},color={255,204,51},thickness=0.5),Text(string="%first",index=-1,extent={{-6,3},{-6,3}}));
  connect(internalGains.y[1],personsRad.Q_flow)
    annotation (Line(points={{22.8,-52},{28,-52},{28,-32},{48,-32}},color={0,0,127}));
  connect(internalGains.y[2],personsConv.Q_flow)
    annotation (Line(points={{22.8,-52},{36,-52},{48,-52}},color={0,0,127}));
  connect(internalGains.y[3],machinesConv.Q_flow)
    annotation (Line(points={{22.8,-52},{28,-52},{28,-74},{48,-74}},color={0,0,127}));
  connect(const.y,eqAirTemp.sunblind)
    annotation (Line(points={{-13.7,17},{-12,17},{-12,8},{-14,8},{-14,8}},color={0,0,127}));
  connect(HDifTil.HSkyDifTil,corGDoublePane.HSkyDifTil)
    annotation (Line(points={{-47,36},{-28,36},{-6,36},{-6,66},{4,66}},color={0,0,127}));
  connect(HDirTil.H,corGDoublePane.HDirTil)
    annotation (Line(points={{-47,62},{-10,62},{-10,70},{4,70}},color={0,0,127}));
  connect(HDirTil.H,solRad.u1)
    annotation (Line(points={{-47,62},{-42,62},{-42,14},{-39,14}},color={0,0,127}));
  connect(HDirTil.inc,corGDoublePane.inc)
    annotation (Line(points={{-47,58},{4,58},{4,58}},color={0,0,127}));
  connect(HDifTil.H,solRad.u2)
    annotation (Line(points={{-47,30},{-44,30},{-44,8},{-39,8}},color={0,0,127}));
  connect(HDifTil.HGroDifTil,corGDoublePane.HGroDifTil)
    annotation (Line(points={{-47,24},{-4,24},{-4,62},{4,62}},color={0,0,127}));
  connect(solRad.y,eqAirTemp.HSol)
    annotation (Line(points={{-27.5,11},{-26,11},{-26,2},{-26,2}},color={0,0,127}));
  connect(weaBus,HDifTil[1].weaBus)
    annotation (Line(points={{-83,6},{-74,6},{-74,30},{-68,30}},color={255,204,51},thickness=0.5));
  connect(weaBus,HDirTil[1].weaBus)
    annotation (Line(points={{-83,6},{-68,6},{-68,62}},color={255,204,51},thickness=0.5));
  connect(weaBus,HDifTil[2].weaBus)
    annotation (Line(points={{-83,6},{-74,6},{-74,30},{-68,30}},color={255,204,51},thickness=0.5));
  connect(weaBus,HDirTil[2].weaBus)
    annotation (Line(points={{-83,6},{-68,6},{-68,62}},color={255,204,51},thickness=0.5));
  connect(weaBus,HDifTil[3].weaBus)
    annotation (Line(points={{-83,6},{-74,6},{-74,30},{-68,30}},color={255,204,51},thickness=0.5));
  connect(weaBus,HDirTil[3].weaBus)
    annotation (Line(points={{-83,6},{-68,6},{-68,62}},color={255,204,51},thickness=0.5));
  connect(weaBus,HDifTil[4].weaBus)
    annotation (Line(points={{-83,6},{-74,6},{-74,30},{-68,30}},color={255,204,51},thickness=0.5));
  connect(weaBus,HDirTil[4].weaBus)
    annotation (Line(points={{-83,6},{-68,6},{-68,62}},color={255,204,51},thickness=0.5));
  connect(weaBus,HDifTil[5].weaBus)
    annotation (Line(points={{-83,6},{-74,6},{-74,30},{-68,30}},color={255,204,51},thickness=0.5));
  connect(weaBus,HDirTil[5].weaBus)
    annotation (Line(points={{-83,6},{-68,6},{-68,62}},color={255,204,51},thickness=0.5));
  connect(weaBus,HDifTil[6].weaBus)
    annotation (Line(points={{-83,6},{-74,6},{-74,30},{-68,30}},color={255,204,51},thickness=0.5));
  connect(weaBus,HDirTil[6].weaBus)
    annotation (Line(points={{-83,6},{-68,6},{-68,62}},color={255,204,51},thickness=0.5));
  connect(personsRad.port,thermalZoneTwoElements.intGainsRad)
    annotation (Line(points={{68,-32},{84,-32},{100,-32},{100,24},{92,24}},color={191,0,0}));
  connect(thermalConductorWin.solid,thermalZoneTwoElements.window)
    annotation (Line(points={{38,21},{40,21},{40,20},{44,20}},color={191,0,0}));
  connect(prescribedTemperature1.port,thermalConductorWin.fluid)
    annotation (Line(points={{20,20},{28,20},{28,21}},color={191,0,0}));
  connect(thermalZoneTwoElements.extWall,thermalConductorWall.solid)
    annotation (Line(points={{44,12},{40,12},{40,1},{36,1}},color={191,0,0}));
  connect(thermalConductorWall.fluid,prescribedTemperature.port)
    annotation (Line(points={{26,1},{24,1},{24,0},{20,0}},color={191,0,0}));
  connect(hConWall.y,thermalConductorWall.Gc)
    annotation (Line(points={{30,-11.6},{30,-4},{31,-4}},color={0,0,127}));
  connect(hConWin.y,thermalConductorWin.Gc)
    annotation (Line(points={{32,33.6},{32,26},{33,26}},color={0,0,127}));
  connect(weaBus.TBlaSky,eqAirTemp.TBlaSky)
    annotation (Line(points={{-83,6},{-58,6},{-58,2},{-32,2},{-32,-4},{-26,-4}},color={255,204,51},thickness=0.5),Text(string="%first",index=-1,extent={{-6,3},{-6,3}}));
  connect(machinesConv.port,thermalZoneTwoElements.intGainsConv)
    annotation (Line(points={{68,-74},{82,-74},{96,-74},{96,20},{92,20}},color={191,0,0}));
  connect(personsConv.port,thermalZoneTwoElements.intGainsConv)
    annotation (Line(points={{68,-52},{96,-52},{96,20},{92,20}},color={191,0,0}));
  connect(corGDoublePane.solarRadWinTrans,thermalZoneTwoElements.solRad)
    annotation (Line(points={{27,64},{34,64},{40,64},{40,31},{43,31}},color={0,0,127}));
  connect(port_a,thermalZoneTwoElements.intGainsConv)
    annotation (Line(points={{0,100},{96,100},{96,20},{92,20}},color={191,0,0}));
  connect(thermalZoneTwoElements.TAir,TAir)
    annotation (Line(points={{93,32},{98,32},{98,0},{110,0}},color={0,0,127}));
end Floor;
