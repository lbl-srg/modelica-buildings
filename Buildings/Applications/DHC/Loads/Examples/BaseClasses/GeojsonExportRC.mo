within Buildings.Applications.DHC.Loads.Examples.BaseClasses;
package GeojsonExportRC
  extends Modelica.Icons.Package;

  package B5a6b99ec37f4de7f94020090
    extends Modelica.Icons.Package;

    model Office
      "This is the simulation model of Office within building B5a6b99ec37f4de7f94020090 with traceable ID None"

      Buildings.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil[6](    each outSkyCon=true,
        each outGroCon=true,
        til={1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 0.0, 0.0},
        each lat = 0.88645272708792,
        azi = {3.141592653589793, 0.0, 1.5707963267948966, -1.5707963267948966, 0.0, 0.0})
        "Calculates diffuse solar radiation on titled surface for all directions"
        annotation (Placement(transformation(extent={{-68,20},{-48,40}})));
      Buildings.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil[6](    til={1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 0.0, 0.0},
        each lat =  0.88645272708792,
        azi={3.141592653589793, 0.0, 1.5707963267948966, -1.5707963267948966, 0.0, 0.0})
        "Calculates direct solar radiation on titled surface for all directions"
        annotation (Placement(transformation(extent={{-68,52},{-48,72}})));
      Buildings.ThermalZones.ReducedOrder.SolarGain.CorrectionGDoublePane corGDoublePane(n=6,  UWin=1.8936557576825381)
        "Correction factor for solar transmission"
        annotation (Placement(transformation(extent={{6,54},{26,74}})));
      Buildings.ThermalZones.ReducedOrder.RC.TwoElements
      thermalZoneTwoElements(
        redeclare package Medium = Modelica.Media.Air.DryAirNasa,
        VAir=6523.584267715201,
        hConExt=2.0490178828959134,
        hConWin=2.7000000000000006,
        gWin=0.6699999999999999,
        ratioWinConRad=0.029999999999999995,
        nExt=1,
        RExt={1.1587415793233466e-05},
        CExt={816489567.0861814},
        hRad=4.999999999999999,
        AInt=6432.582581857601,
        hConInt=2.2070734953418447,
        nInt=1,
        RInt={8.447576025701151e-06},
        CInt={927877114.2946483},
        RWin=0.001099369505863836,
        RExtRem=0.0006263035192430239,
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        extWallRC(thermCapExt(each der_T(fixed=true))),
        intWallRC(thermCapInt(each der_T(fixed=true))),
        nOrientations=6,
        AWin={149.09539311555662, 149.09539311555662, 13.82023866850661, 13.82023866850661, 0.0, 0.0},
        ATransparent={149.09539311555662, 149.09539311555662, 13.82023866850661, 13.82023866850661, 0.0, 0.0},
        AExt={447.28617934666994, 447.28617934666994, 41.46071600551983, 41.46071600551983, 911.6022538000002, 911.6022538000002})
        "Thermal zone"
        annotation (Placement(transformation(extent={{44,-2},{92,34}})));
      Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.VDI6007WithWindow eqAirTemp(
        n=6,
        wfGro=0.3626976838332763,
        wfWall={0.15582361279765053, 0.15582361279765053, 0.014443903825944522, 0.014443903825944522, 0.2967672829195336, 0.0},
        wfWin={0.4575846758314001, 0.4575846758314001, 0.04241532416859994, 0.04241532416859994, 0.0, 0.0},
        withLongwave=true,
        aExt=0.5,
        hConWallOut=20.0,
        hRad=5.0,
        hConWinOut=20.0,
        TGro=286.15) "Computes equivalent air temperature"
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
      Modelica.Blocks.Sources.Constant const[6](each k=0)
        "Sets sunblind signal to zero (open)"
        annotation (Placement(transformation(extent={{-20,14},{-14,20}})));
      Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
        annotation (Placement(
        transformation(extent={{-158,-10},{-124,22}}),
                                                     iconTransformation(
        extent={{-70,-12},{-50,8}})));
      Modelica.Blocks.Sources.Constant alphaWall(k=25.0*2800.69829830438)
        "Outdoor coefficient of heat transfer for walls"
        annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={30,-16})));
      Modelica.Blocks.Sources.Constant hConWin(k=25.0*325.8312635681265)
        "Outdoor coefficient of heat transfer for windows"
        annotation (Placement(
        transformation(
        extent={{4,-4},{-4,4}},
        rotation=90,
        origin={32,38})));
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
              "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportRC/Resources/Data/B5a6b99ec37f4de7f94020090/InternalGains_Office.mat"),
          columns={2,3,4})
          "Table with profiles for persons (radiative and convective) and machines (convective)"
          annotation (Placement(transformation(extent={{6,-60},{22,-44}})));
      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
        annotation (Placement(transformation(extent={{-10,90},{10,110}}), iconTransformation(extent={{-10,90},{10,110}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealOutput TAir(
        quantity="ThermodynamicTemperature", unit="K", displayUnit="degC")
        "Room air temperature"
        annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    equation
      connect(eqAirTemp.TEqAirWin, prescribedTemperature1.T)
        annotation (Line(
        points={{-3,-0.2},{0,-0.2},{0,20},{6.8,20}},   color={0,0,127}));
      connect(eqAirTemp.TEqAir, prescribedTemperature.T)
        annotation (Line(points={{-3,-4},{4,-4},{4,0},{6.8,0}},
        color={0,0,127}));
      connect(weaBus, weaBus)
        annotation (Line(
        points={{-141,6},{-74,6},{-74,18},{-84,18},{-84,12},{-141,12},{-141,6}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
      connect(weaBus.TDryBul, eqAirTemp.TDryBul)
        annotation (Line(
        points={{-141,6},{-141,-2},{-38,-2},{-38,-10},{-26,-10}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
      connect(internalGains.y[1], personsRad.Q_flow)
        annotation (Line(points={{22.8,
        -52},{28,-52},{28,-32},{48,-32}}, color={0,0,127}));
      connect(internalGains.y[2], personsConv.Q_flow)
        annotation (Line(points={{22.8,-52},{36,-52},{48,-52}}, color={0,0,127}));
      connect(internalGains.y[3], machinesConv.Q_flow)
        annotation (Line(points={{22.8,
        -52},{28,-52},{28,-74},{48,-74}}, color={0,0,127}));
      connect(const.y, eqAirTemp.sunblind)
        annotation (Line(points={{-13.7,17},{-12,17},{-12,8},{-14,8},{-14,8}},
        color={0,0,127}));
      connect(HDifTil.HSkyDifTil, corGDoublePane.HSkyDifTil)
        annotation (Line(
        points={{-47,36},{-28,36},{-6,36},{-6,66},{4,66}}, color={0,0,127}));
      connect(HDirTil.H, corGDoublePane.HDirTil)
        annotation (Line(points={{-47,62},{-10,62},{-10,70},{4,70}},
        color={0,0,127}));
      connect(HDirTil.H,solRad. u1)
        annotation (Line(points={{-47,62},{-42,62},{-42,
        14},{-39,14}}, color={0,0,127}));
      connect(HDirTil.inc, corGDoublePane.inc)
        annotation (Line(points={{-47,58},{4,58},{4,58}}, color={0,0,127}));
      connect(HDifTil.H,solRad. u2)
        annotation (Line(points={{-47,30},{-44,30},{-44,
        8},{-39,8}}, color={0,0,127}));
      connect(HDifTil.HGroDifTil, corGDoublePane.HGroDifTil)
        annotation (Line(
        points={{-47,24},{-4,24},{-4,62},{4,62}}, color={0,0,127}));
      connect(solRad.y, eqAirTemp.HSol)
        annotation (Line(points={{-27.5,11},{-26,11},{-26,2},{-26,2}},
        color={0,0,127}));
        connect(weaBus, HDifTil[1].weaBus)
        annotation (Line(
        points={{-141,6},{-74,6},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[1].weaBus)
        annotation (Line(
        points={{-141,6},{-68,6},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[2].weaBus)
        annotation (Line(
        points={{-141,6},{-74,6},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[2].weaBus)
        annotation (Line(
        points={{-141,6},{-68,6},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[3].weaBus)
        annotation (Line(
        points={{-141,6},{-74,6},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[3].weaBus)
        annotation (Line(
        points={{-141,6},{-68,6},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[4].weaBus)
        annotation (Line(
        points={{-141,6},{-74,6},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[4].weaBus)
        annotation (Line(
        points={{-141,6},{-68,6},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[5].weaBus)
        annotation (Line(
        points={{-141,6},{-74,6},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[5].weaBus)
        annotation (Line(
        points={{-141,6},{-68,6},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[6].weaBus)
        annotation (Line(
        points={{-141,6},{-74,6},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[6].weaBus)
        annotation (Line(
        points={{-141,6},{-68,6},{-68,62}},
        color={255,204,51},
        thickness=0.5));
      connect(personsRad.port, thermalZoneTwoElements.intGainsRad)
        annotation (Line(
        points={{68,-32},{84,-32},{100,-32},{100,24},{92,24}},
        color={191,0,0}));
      connect(thermalConductorWin.solid, thermalZoneTwoElements.window)
        annotation (
         Line(points={{38,21},{40,21},{40,20},{44,20}},   color={191,0,0}));
      connect(prescribedTemperature1.port, thermalConductorWin.fluid)
        annotation (Line(points={{20,20},{28,20},{28,21}}, color={191,0,0}));
      connect(thermalZoneTwoElements.extWall, thermalConductorWall.solid)
        annotation (Line(points={{44,12},{40,12},{40,1},{36,1}},
        color={191,0,0}));
      connect(thermalConductorWall.fluid, prescribedTemperature.port)
        annotation (Line(points={{26,1},{24,1},{24,0},{20,0}}, color={191,0,0}));
      connect(alphaWall.y, thermalConductorWall.Gc)
        annotation (Line(points={{30,-11.6},{30,-4},{31,-4}}, color={0,0,127}));
      connect(hConWin.y, thermalConductorWin.Gc)
        annotation (Line(points={{32,33.6},{32,26},{33,26}}, color={0,0,127}));
      connect(weaBus.TBlaSky, eqAirTemp.TBlaSky)
        annotation (Line(
        points={{-141,6},{-58,6},{-58,2},{-32,2},{-32,-4},{-26,-4}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
      connect(machinesConv.port, thermalZoneTwoElements.intGainsConv)
        annotation (
        Line(points={{68,-74},{82,-74},{96,-74},{96,20},{92,20}}, color={191,
        0,0}));
      connect(personsConv.port, thermalZoneTwoElements.intGainsConv)
        annotation (
        Line(points={{68,-52},{96,-52},{96,20},{92,20}}, color={191,0,0}));
      connect(corGDoublePane.solarRadWinTrans, thermalZoneTwoElements.solRad)
        annotation (Line(points={{27,64},{34,64},{40,64},{40,31},{43,31}}, color={0,
        0,127}));
      connect(port_a, thermalZoneTwoElements.intGainsConv)
        annotation (Line(points={{0,100},{96,100},{96,20},{92,20}}, color={191,0,0}));
      connect(thermalZoneTwoElements.TAir, TAir)
        annotation (Line(points={{93,32},{98,32},{98,0},{110,0}}, color={0,0,127}));
      annotation (experiment(
      StopTime=31536000,
      Interval=3600,
      __Dymola_Algorithm="Cvode"),
      __Dymola_experimentSetupOutput(equidistant=true,
      events=false));
    end Office;

    model Floor
      "This is the simulation model of Floor within building B5a6b99ec37f4de7f94020090 with traceable ID None"

      Buildings.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil[6](    each outSkyCon=true,
        each outGroCon=true,
        til={1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 0.0, 0.0},
        each lat = 0.88645272708792,
        azi = {3.141592653589793, 0.0, 1.5707963267948966, -1.5707963267948966, 0.0, 0.0})
        "Calculates diffuse solar radiation on titled surface for all directions"
        annotation (Placement(transformation(extent={{-68,20},{-48,40}})));
      Buildings.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil[6](    til={1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 0.0, 0.0},
        each lat =  0.88645272708792,
        azi={3.141592653589793, 0.0, 1.5707963267948966, -1.5707963267948966, 0.0, 0.0})
        "Calculates direct solar radiation on titled surface for all directions"
        annotation (Placement(transformation(extent={{-68,52},{-48,72}})));
      Buildings.ThermalZones.ReducedOrder.SolarGain.CorrectionGDoublePane corGDoublePane(n=6,  UWin=1.8936557576825381)
        "Correction factor for solar transmission"
        annotation (Placement(transformation(extent={{6,54},{26,74}})));
      Buildings.ThermalZones.ReducedOrder.RC.TwoElements
      thermalZoneTwoElements(
        redeclare package Medium = Modelica.Media.Air.DryAirNasa,
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
        extWallRC(thermCapExt(each der_T(fixed=true))),
        intWallRC(thermCapInt(each der_T(fixed=true))),
        nOrientations=6,
        AWin={74.54769655777831, 74.54769655777831, 6.910119334253305, 6.910119334253305, 0.0, 0.0},
        ATransparent={74.54769655777831, 74.54769655777831, 6.910119334253305, 6.910119334253305, 0.0, 0.0},
        AExt={223.64308967333497, 223.64308967333497, 20.730358002759914, 20.730358002759914, 455.8011269000001, 455.8011269000001})
        "Thermal zone"
        annotation (Placement(transformation(extent={{44,-2},{92,34}})));
      Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.VDI6007WithWindow eqAirTemp(
        n=6,
        wfGro=0.3626976838332763,
        wfWall={0.15582361279765053, 0.15582361279765053, 0.014443903825944522, 0.014443903825944522, 0.2967672829195336, 0.0},
        wfWin={0.4575846758314001, 0.4575846758314001, 0.04241532416859994, 0.04241532416859994, 0.0, 0.0},
        withLongwave=true,
        aExt=0.5,
        hConWallOut=20.0,
        hRad=5.0,
        hConWinOut=20.0,
        TGro=286.15) "Computes equivalent air temperature"
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
      Modelica.Blocks.Sources.Constant const[6](each k=0)
        "Sets sunblind signal to zero (open)"
        annotation (Placement(transformation(extent={{-20,14},{-14,20}})));
      Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
        annotation (Placement(
        transformation(extent={{-100,-10},{-66,22}}),iconTransformation(
        extent={{-70,-12},{-50,8}})));
      Modelica.Blocks.Sources.Constant alphaWall(k=25.0*1400.34914915219)
        "Outdoor coefficient of heat transfer for walls"
        annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={30,-16})));
      Modelica.Blocks.Sources.Constant hConWin(k=25.0*162.91563178406324)
        "Outdoor coefficient of heat transfer for windows"
        annotation (Placement(
        transformation(
        extent={{4,-4},{-4,4}},
        rotation=90,
        origin={32,38})));
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
              "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportRC/Resources/Data/B5a6b99ec37f4de7f94020090/InternalGains_Floor.mat"),
          columns={2,3,4})
          "Table with profiles for persons (radiative and convective) and machines (convective)"
          annotation (Placement(transformation(extent={{6,-60},{22,-44}})));
      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
        annotation (Placement(transformation(extent={{-10,90},{10,110}}), iconTransformation(extent={{-10,90},{10,110}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealOutput TAir(
        quantity="ThermodynamicTemperature", unit="K", displayUnit="degC")
        "Room air temperature"
        annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    equation
      connect(eqAirTemp.TEqAirWin, prescribedTemperature1.T)
        annotation (Line(
        points={{-3,-0.2},{0,-0.2},{0,20},{6.8,20}},   color={0,0,127}));
      connect(eqAirTemp.TEqAir, prescribedTemperature.T)
        annotation (Line(points={{-3,-4},{4,-4},{4,0},{6.8,0}},
        color={0,0,127}));
      connect(weaBus, weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,18},{-84,18},{-84,12},{-83,12},{-83,6}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
      connect(weaBus.TDryBul, eqAirTemp.TDryBul)
        annotation (Line(
        points={{-83,6},{-83,-2},{-38,-2},{-38,-10},{-26,-10}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
      connect(internalGains.y[1], personsRad.Q_flow)
        annotation (Line(points={{22.8,
        -52},{28,-52},{28,-32},{48,-32}}, color={0,0,127}));
      connect(internalGains.y[2], personsConv.Q_flow)
        annotation (Line(points={{22.8,-52},{36,-52},{48,-52}}, color={0,0,127}));
      connect(internalGains.y[3], machinesConv.Q_flow)
        annotation (Line(points={{22.8,
        -52},{28,-52},{28,-74},{48,-74}}, color={0,0,127}));
      connect(const.y, eqAirTemp.sunblind)
        annotation (Line(points={{-13.7,17},{-12,17},{-12,8},{-14,8},{-14,8}},
        color={0,0,127}));
      connect(HDifTil.HSkyDifTil, corGDoublePane.HSkyDifTil)
        annotation (Line(
        points={{-47,36},{-28,36},{-6,36},{-6,66},{4,66}}, color={0,0,127}));
      connect(HDirTil.H, corGDoublePane.HDirTil)
        annotation (Line(points={{-47,62},{-10,62},{-10,70},{4,70}},
        color={0,0,127}));
      connect(HDirTil.H,solRad. u1)
        annotation (Line(points={{-47,62},{-42,62},{-42,
        14},{-39,14}}, color={0,0,127}));
      connect(HDirTil.inc, corGDoublePane.inc)
        annotation (Line(points={{-47,58},{4,58},{4,58}}, color={0,0,127}));
      connect(HDifTil.H,solRad. u2)
        annotation (Line(points={{-47,30},{-44,30},{-44,
        8},{-39,8}}, color={0,0,127}));
      connect(HDifTil.HGroDifTil, corGDoublePane.HGroDifTil)
        annotation (Line(
        points={{-47,24},{-4,24},{-4,62},{4,62}}, color={0,0,127}));
      connect(solRad.y, eqAirTemp.HSol)
        annotation (Line(points={{-27.5,11},{-26,11},{-26,2},{-26,2}},
        color={0,0,127}));
        connect(weaBus, HDifTil[1].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[1].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[2].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[2].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[3].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[3].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[4].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[4].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[5].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[5].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[6].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[6].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
      connect(personsRad.port, thermalZoneTwoElements.intGainsRad)
        annotation (Line(
        points={{68,-32},{84,-32},{100,-32},{100,24},{92.2,24}},
        color={191,0,0}));
      connect(thermalConductorWin.solid, thermalZoneTwoElements.window)
        annotation (
         Line(points={{38,21},{40,21},{40,20},{43.8,20}}, color={191,0,0}));
      connect(prescribedTemperature1.port, thermalConductorWin.fluid)
        annotation (Line(points={{20,20},{28,20},{28,21}}, color={191,0,0}));
      connect(thermalZoneTwoElements.extWall, thermalConductorWall.solid)
        annotation (Line(points={{43.8,12},{40,12},{40,1},{36,1}},
        color={191,0,0}));
      connect(thermalConductorWall.fluid, prescribedTemperature.port)
        annotation (Line(points={{26,1},{24,1},{24,0},{20,0}}, color={191,0,0}));
      connect(alphaWall.y, thermalConductorWall.Gc)
        annotation (Line(points={{30,-11.6},{30,-4},{31,-4}}, color={0,0,127}));
      connect(hConWin.y, thermalConductorWin.Gc)
        annotation (Line(points={{32,33.6},{32,26},{33,26}}, color={0,0,127}));
      connect(weaBus.TBlaSky, eqAirTemp.TBlaSky)
        annotation (Line(
        points={{-83,6},{-58,6},{-58,2},{-32,2},{-32,-4},{-26,-4}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
      connect(machinesConv.port, thermalZoneTwoElements.intGainsConv)
        annotation (
        Line(points={{68,-74},{82,-74},{96,-74},{96,20},{92,20}}, color={191,
        0,0}));
      connect(personsConv.port, thermalZoneTwoElements.intGainsConv)
        annotation (
        Line(points={{68,-52},{96,-52},{96,20},{92,20}}, color={191,0,0}));
      connect(corGDoublePane.solarRadWinTrans, thermalZoneTwoElements.solRad)
        annotation (Line(points={{27,64},{34,64},{40,64},{40,31},{43,31}}, color={0,
        0,127}));
      connect(port_a, thermalZoneTwoElements.intGainsConv)
        annotation (Line(points={{0,100},{96,100},{96,20},{92,20}}, color={191,0,0}));
      connect(thermalZoneTwoElements.TAir, TAir)
        annotation (Line(points={{93,32},{98,32},{98,0},{110,0}}, color={0,0,127}));
      annotation (experiment(
      StopTime=31536000,
      Interval=3600,
      __Dymola_Algorithm="Cvode"),
      __Dymola_experimentSetupOutput(equidistant=true,
      events=false));
    end Floor;

    model Storage
      "This is the simulation model of Storage within building B5a6b99ec37f4de7f94020090 with traceable ID None"

      Buildings.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil[6](    each outSkyCon=true,
        each outGroCon=true,
        til={1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 0.0, 0.0},
        each lat = 0.88645272708792,
        azi = {3.141592653589793, 0.0, 1.5707963267948966, -1.5707963267948966, 0.0, 0.0})
        "Calculates diffuse solar radiation on titled surface for all directions"
        annotation (Placement(transformation(extent={{-68,20},{-48,40}})));
      Buildings.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil[6](    til={1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 0.0, 0.0},
        each lat =  0.88645272708792,
        azi={3.141592653589793, 0.0, 1.5707963267948966, -1.5707963267948966, 0.0, 0.0})
        "Calculates direct solar radiation on titled surface for all directions"
        annotation (Placement(transformation(extent={{-68,52},{-48,72}})));
      Buildings.ThermalZones.ReducedOrder.SolarGain.CorrectionGDoublePane corGDoublePane(n=6,  UWin=1.8936557576825388)
        "Correction factor for solar transmission"
        annotation (Placement(transformation(extent={{6,54},{26,74}})));
      Buildings.ThermalZones.ReducedOrder.RC.TwoElements
      thermalZoneTwoElements(
        redeclare package Medium = Modelica.Media.Air.DryAirNasa,
        VAir=1957.0752803145606,
        hConExt=2.049017882895913,
        hConWin=2.7,
        gWin=0.67,
        ratioWinConRad=0.03,
        nExt=1,
        RExt={3.86247193107782e-05},
        CExt={244946870.12585458},
        hRad=4.999999999999999,
        AInt=1929.7747745572801,
        hConInt=2.207073495341845,
        nInt=1,
        RInt={2.8158586752337178e-05},
        CInt={278363134.2883944},
        RWin=0.0036645650195461206,
        RExtRem=0.0020876783974767463,
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        extWallRC(thermCapExt(each der_T(fixed=true))),
        intWallRC(thermCapInt(each der_T(fixed=true))),
        nOrientations=6,
        AWin={44.728617934666985, 44.728617934666985, 4.146071600551982, 4.146071600551982, 0.0, 0.0},
        ATransparent={44.728617934666985, 44.728617934666985, 4.146071600551982, 4.146071600551982, 0.0, 0.0},
        AExt={134.185853804001, 134.185853804001, 12.438214801655947, 12.438214801655947, 273.48067614000007, 273.48067614000007})
        "Thermal zone"
        annotation (Placement(transformation(extent={{44,-2},{92,34}})));
      Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.VDI6007WithWindow eqAirTemp(
        n=6,
        wfGro=0.36269768383327633,
        wfWall={0.15582361279765056, 0.15582361279765056, 0.014443903825944526, 0.014443903825944526, 0.2967672829195335, 0.0},
        wfWin={0.4575846758314, 0.4575846758314, 0.04241532416859994, 0.04241532416859994, 0.0, 0.0},
        withLongwave=true,
        aExt=0.5,
        hConWallOut=20.000000000000004,
        hRad=4.999999999999999,
        hConWinOut=19.999999999999996,
        TGro=286.15) "Computes equivalent air temperature"
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
      Modelica.Blocks.Sources.Constant const[6](each k=0)
        "Sets sunblind signal to zero (open)"
        annotation (Placement(transformation(extent={{-20,14},{-14,20}})));
      Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
        annotation (Placement(
        transformation(extent={{-100,-10},{-66,22}}),iconTransformation(
        extent={{-70,-12},{-50,8}})));
      Modelica.Blocks.Sources.Constant alphaWall(k=25.000000000000004*840.2094894913139)
        "Outdoor coefficient of heat transfer for walls"
        annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={30,-16})));
      Modelica.Blocks.Sources.Constant hConWin(k=25.000000000000004*97.74937907043793)
        "Outdoor coefficient of heat transfer for windows"
        annotation (Placement(
        transformation(
        extent={{4,-4},{-4,4}},
        rotation=90,
        origin={32,38})));
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
              "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportRC/Resources/Data/B5a6b99ec37f4de7f94020090/InternalGains_Storage.mat"),
          columns={2,3,4})
          "Table with profiles for persons (radiative and convective) and machines (convective)"
          annotation (Placement(transformation(extent={{6,-60},{22,-44}})));
      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
        annotation (Placement(transformation(extent={{-10,90},{10,110}}), iconTransformation(extent={{-10,90},{10,110}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealOutput TAir(
        quantity="ThermodynamicTemperature", unit="K", displayUnit="degC")
        "Room air temperature"
        annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    equation
      connect(eqAirTemp.TEqAirWin, prescribedTemperature1.T)
        annotation (Line(
        points={{-3,-0.2},{0,-0.2},{0,20},{6.8,20}},   color={0,0,127}));
      connect(eqAirTemp.TEqAir, prescribedTemperature.T)
        annotation (Line(points={{-3,-4},{4,-4},{4,0},{6.8,0}},
        color={0,0,127}));
      connect(weaBus, weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,18},{-84,18},{-84,12},{-83,12},{-83,6}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
      connect(weaBus.TDryBul, eqAirTemp.TDryBul)
        annotation (Line(
        points={{-83,6},{-83,-2},{-38,-2},{-38,-10},{-26,-10}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
      connect(internalGains.y[1], personsRad.Q_flow)
        annotation (Line(points={{22.8,
        -52},{28,-52},{28,-32},{48,-32}}, color={0,0,127}));
      connect(internalGains.y[2], personsConv.Q_flow)
        annotation (Line(points={{22.8,-52},{36,-52},{48,-52}}, color={0,0,127}));
      connect(internalGains.y[3], machinesConv.Q_flow)
        annotation (Line(points={{22.8,
        -52},{28,-52},{28,-74},{48,-74}}, color={0,0,127}));
      connect(const.y, eqAirTemp.sunblind)
        annotation (Line(points={{-13.7,17},{-12,17},{-12,8},{-14,8},{-14,8}},
        color={0,0,127}));
      connect(HDifTil.HSkyDifTil, corGDoublePane.HSkyDifTil)
        annotation (Line(
        points={{-47,36},{-28,36},{-6,36},{-6,66},{4,66}}, color={0,0,127}));
      connect(HDirTil.H, corGDoublePane.HDirTil)
        annotation (Line(points={{-47,62},{-10,62},{-10,70},{4,70}},
        color={0,0,127}));
      connect(HDirTil.H,solRad. u1)
        annotation (Line(points={{-47,62},{-42,62},{-42,
        14},{-39,14}}, color={0,0,127}));
      connect(HDirTil.inc, corGDoublePane.inc)
        annotation (Line(points={{-47,58},{4,58},{4,58}}, color={0,0,127}));
      connect(HDifTil.H,solRad. u2)
        annotation (Line(points={{-47,30},{-44,30},{-44,
        8},{-39,8}}, color={0,0,127}));
      connect(HDifTil.HGroDifTil, corGDoublePane.HGroDifTil)
        annotation (Line(
        points={{-47,24},{-4,24},{-4,62},{4,62}}, color={0,0,127}));
      connect(solRad.y, eqAirTemp.HSol)
        annotation (Line(points={{-27.5,11},{-26,11},{-26,2},{-26,2}},
        color={0,0,127}));
        connect(weaBus, HDifTil[1].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[1].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[2].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[2].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[3].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[3].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[4].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[4].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[5].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[5].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[6].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[6].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
      connect(personsRad.port, thermalZoneTwoElements.intGainsRad)
        annotation (Line(
        points={{68,-32},{84,-32},{100,-32},{100,24},{92.2,24}},
        color={191,0,0}));
      connect(thermalConductorWin.solid, thermalZoneTwoElements.window)
        annotation (
         Line(points={{38,21},{40,21},{40,20},{43.8,20}}, color={191,0,0}));
      connect(prescribedTemperature1.port, thermalConductorWin.fluid)
        annotation (Line(points={{20,20},{28,20},{28,21}}, color={191,0,0}));
      connect(thermalZoneTwoElements.extWall, thermalConductorWall.solid)
        annotation (Line(points={{43.8,12},{40,12},{40,1},{36,1}},
        color={191,0,0}));
      connect(thermalConductorWall.fluid, prescribedTemperature.port)
        annotation (Line(points={{26,1},{24,1},{24,0},{20,0}}, color={191,0,0}));
      connect(alphaWall.y, thermalConductorWall.Gc)
        annotation (Line(points={{30,-11.6},{30,-4},{31,-4}}, color={0,0,127}));
      connect(hConWin.y, thermalConductorWin.Gc)
        annotation (Line(points={{32,33.6},{32,26},{33,26}}, color={0,0,127}));
      connect(weaBus.TBlaSky, eqAirTemp.TBlaSky)
        annotation (Line(
        points={{-83,6},{-58,6},{-58,2},{-32,2},{-32,-4},{-26,-4}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
      connect(machinesConv.port, thermalZoneTwoElements.intGainsConv)
        annotation (
        Line(points={{68,-74},{82,-74},{96,-74},{96,20},{92,20}}, color={191,
        0,0}));
      connect(personsConv.port, thermalZoneTwoElements.intGainsConv)
        annotation (
        Line(points={{68,-52},{96,-52},{96,20},{92,20}}, color={191,0,0}));
      connect(corGDoublePane.solarRadWinTrans, thermalZoneTwoElements.solRad)
        annotation (Line(points={{27,64},{34,64},{40,64},{40,31},{43,31}}, color={0,
        0,127}));
      connect(port_a, thermalZoneTwoElements.intGainsConv)
        annotation (Line(points={{0,100},{96,100},{96,20},{92,20}}, color={191,0,0}));
      connect(thermalZoneTwoElements.TAir, TAir)
        annotation (Line(points={{93,32},{98,32},{98,0},{110,0}}, color={0,0,127}));
      annotation (experiment(
      StopTime=31536000,
      Interval=3600,
      __Dymola_Algorithm="Cvode"),
      __Dymola_experimentSetupOutput(equidistant=true,
      events=false));
    end Storage;

    model Meeting
      "This is the simulation model of Meeting within building B5a6b99ec37f4de7f94020090 with traceable ID None"

      Buildings.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil[6](    each outSkyCon=true,
        each outGroCon=true,
        til={1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 0.0, 0.0},
        each lat = 0.88645272708792,
        azi = {3.141592653589793, 0.0, 1.5707963267948966, -1.5707963267948966, 0.0, 0.0})
        "Calculates diffuse solar radiation on titled surface for all directions"
        annotation (Placement(transformation(extent={{-68,20},{-48,40}})));
      Buildings.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil[6](    til={1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 0.0, 0.0},
        each lat =  0.88645272708792,
        azi={3.141592653589793, 0.0, 1.5707963267948966, -1.5707963267948966, 0.0, 0.0})
        "Calculates direct solar radiation on titled surface for all directions"
        annotation (Placement(transformation(extent={{-68,52},{-48,72}})));
      Buildings.ThermalZones.ReducedOrder.SolarGain.CorrectionGDoublePane corGDoublePane(n=6,  UWin=1.8936557576825384)
        "Correction factor for solar transmission"
        annotation (Placement(transformation(extent={{6,54},{26,74}})));
      Buildings.ThermalZones.ReducedOrder.RC.TwoElements
      thermalZoneTwoElements(
        redeclare package Medium = Modelica.Media.Air.DryAirNasa,
        VAir=521.8867414172162,
        hConExt=2.0490178828959125,
        hConWin=2.7000000000000006,
        gWin=0.6700000000000002,
        ratioWinConRad=0.030000000000000002,
        nExt=1,
        RExt={0.00014484269741541823},
        CExt={65319165.36689455},
        hRad=5.000000000000001,
        AInt=514.606606548608,
        hConInt=2.207073495341845,
        nInt=1,
        RInt={0.0001055947003212644},
        CInt={74230169.14357185},
        RWin=0.013742118823297953,
        RExtRem=0.007828793990537798,
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        extWallRC(thermCapExt(each der_T(fixed=true))),
        intWallRC(thermCapInt(each der_T(fixed=true))),
        nOrientations=6,
        AWin={11.92763144924453, 11.92763144924453, 1.1056190934805288, 1.1056190934805288, 0.0, 0.0},
        ATransparent={11.92763144924453, 11.92763144924453, 1.1056190934805288, 1.1056190934805288, 0.0, 0.0},
        AExt={35.782894347733595, 35.782894347733595, 3.316857280441586, 3.316857280441586, 72.92818030400002, 72.92818030400002})
        "Thermal zone"
        annotation (Placement(transformation(extent={{44,-2},{92,34}})));
      Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.VDI6007WithWindow eqAirTemp(
        n=6,
        wfGro=0.3626976838332763,
        wfWall={0.15582361279765056, 0.15582361279765056, 0.014443903825944524, 0.014443903825944524, 0.2967672829195336, 0.0},
        wfWin={0.45758467583140006, 0.45758467583140006, 0.04241532416859994, 0.04241532416859994, 0.0, 0.0},
        withLongwave=true,
        aExt=0.5,
        hConWallOut=20.0,
        hRad=5.0,
        hConWinOut=20.0,
        TGro=286.15) "Computes equivalent air temperature"
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
      Modelica.Blocks.Sources.Constant const[6](each k=0)
        "Sets sunblind signal to zero (open)"
        annotation (Placement(transformation(extent={{-20,14},{-14,20}})));
      Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
        annotation (Placement(
        transformation(extent={{-100,-10},{-66,22}}),iconTransformation(
        extent={{-70,-12},{-50,8}})));
      Modelica.Blocks.Sources.Constant alphaWall(k=25.000000000000004*224.0558638643504)
        "Outdoor coefficient of heat transfer for walls"
        annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={30,-16})));
      Modelica.Blocks.Sources.Constant hConWin(k=24.999999999999996*26.066501085450113)
        "Outdoor coefficient of heat transfer for windows"
        annotation (Placement(
        transformation(
        extent={{4,-4},{-4,4}},
        rotation=90,
        origin={32,38})));
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
              "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportRC/Resources/Data/B5a6b99ec37f4de7f94020090/InternalGains_Meeting.mat"),
          columns={2,3,4})
          "Table with profiles for persons (radiative and convective) and machines (convective)"
          annotation (Placement(transformation(extent={{6,-60},{22,-44}})));
      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
        annotation (Placement(transformation(extent={{-10,90},{10,110}}), iconTransformation(extent={{-10,90},{10,110}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealOutput TAir(
        quantity="ThermodynamicTemperature", unit="K", displayUnit="degC")
        "Room air temperature"
        annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    equation
      connect(eqAirTemp.TEqAirWin, prescribedTemperature1.T)
        annotation (Line(
        points={{-3,-0.2},{0,-0.2},{0,20},{6.8,20}},   color={0,0,127}));
      connect(eqAirTemp.TEqAir, prescribedTemperature.T)
        annotation (Line(points={{-3,-4},{4,-4},{4,0},{6.8,0}},
        color={0,0,127}));
      connect(weaBus, weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,18},{-84,18},{-84,12},{-83,12},{-83,6}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
      connect(weaBus.TDryBul, eqAirTemp.TDryBul)
        annotation (Line(
        points={{-83,6},{-83,-2},{-38,-2},{-38,-10},{-26,-10}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
      connect(internalGains.y[1], personsRad.Q_flow)
        annotation (Line(points={{22.8,
        -52},{28,-52},{28,-32},{48,-32}}, color={0,0,127}));
      connect(internalGains.y[2], personsConv.Q_flow)
        annotation (Line(points={{22.8,-52},{36,-52},{48,-52}}, color={0,0,127}));
      connect(internalGains.y[3], machinesConv.Q_flow)
        annotation (Line(points={{22.8,
        -52},{28,-52},{28,-74},{48,-74}}, color={0,0,127}));
      connect(const.y, eqAirTemp.sunblind)
        annotation (Line(points={{-13.7,17},{-12,17},{-12,8},{-14,8},{-14,8}},
        color={0,0,127}));
      connect(HDifTil.HSkyDifTil, corGDoublePane.HSkyDifTil)
        annotation (Line(
        points={{-47,36},{-28,36},{-6,36},{-6,66},{4,66}}, color={0,0,127}));
      connect(HDirTil.H, corGDoublePane.HDirTil)
        annotation (Line(points={{-47,62},{-10,62},{-10,70},{4,70}},
        color={0,0,127}));
      connect(HDirTil.H,solRad. u1)
        annotation (Line(points={{-47,62},{-42,62},{-42,
        14},{-39,14}}, color={0,0,127}));
      connect(HDirTil.inc, corGDoublePane.inc)
        annotation (Line(points={{-47,58},{4,58},{4,58}}, color={0,0,127}));
      connect(HDifTil.H,solRad. u2)
        annotation (Line(points={{-47,30},{-44,30},{-44,
        8},{-39,8}}, color={0,0,127}));
      connect(HDifTil.HGroDifTil, corGDoublePane.HGroDifTil)
        annotation (Line(
        points={{-47,24},{-4,24},{-4,62},{4,62}}, color={0,0,127}));
      connect(solRad.y, eqAirTemp.HSol)
        annotation (Line(points={{-27.5,11},{-26,11},{-26,2},{-26,2}},
        color={0,0,127}));
        connect(weaBus, HDifTil[1].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[1].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[2].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[2].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[3].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[3].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[4].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[4].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[5].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[5].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[6].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[6].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
      connect(personsRad.port, thermalZoneTwoElements.intGainsRad)
        annotation (Line(
        points={{68,-32},{84,-32},{100,-32},{100,24},{92.2,24}},
        color={191,0,0}));
      connect(thermalConductorWin.solid, thermalZoneTwoElements.window)
        annotation (
         Line(points={{38,21},{40,21},{40,20},{43.8,20}}, color={191,0,0}));
      connect(prescribedTemperature1.port, thermalConductorWin.fluid)
        annotation (Line(points={{20,20},{28,20},{28,21}}, color={191,0,0}));
      connect(thermalZoneTwoElements.extWall, thermalConductorWall.solid)
        annotation (Line(points={{43.8,12},{40,12},{40,1},{36,1}},
        color={191,0,0}));
      connect(thermalConductorWall.fluid, prescribedTemperature.port)
        annotation (Line(points={{26,1},{24,1},{24,0},{20,0}}, color={191,0,0}));
      connect(alphaWall.y, thermalConductorWall.Gc)
        annotation (Line(points={{30,-11.6},{30,-4},{31,-4}}, color={0,0,127}));
      connect(hConWin.y, thermalConductorWin.Gc)
        annotation (Line(points={{32,33.6},{32,26},{33,26}}, color={0,0,127}));
      connect(weaBus.TBlaSky, eqAirTemp.TBlaSky)
        annotation (Line(
        points={{-83,6},{-58,6},{-58,2},{-32,2},{-32,-4},{-26,-4}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
      connect(machinesConv.port, thermalZoneTwoElements.intGainsConv)
        annotation (
        Line(points={{68,-74},{82,-74},{96,-74},{96,20},{92,20}}, color={191,
        0,0}));
      connect(personsConv.port, thermalZoneTwoElements.intGainsConv)
        annotation (
        Line(points={{68,-52},{96,-52},{96,20},{92,20}}, color={191,0,0}));
      connect(corGDoublePane.solarRadWinTrans, thermalZoneTwoElements.solRad)
        annotation (Line(points={{27,64},{34,64},{40,64},{40,31},{43,31}}, color={0,
        0,127}));
      connect(port_a, thermalZoneTwoElements.intGainsConv)
        annotation (Line(points={{0,100},{96,100},{96,20},{92,20}}, color={191,0,0}));
      connect(thermalZoneTwoElements.TAir, TAir)
        annotation (Line(points={{93,32},{98,32},{98,0},{110,0}}, color={0,0,127}));
      annotation (experiment(
      StopTime=31536000,
      Interval=3600,
      __Dymola_Algorithm="Cvode"),
      __Dymola_experimentSetupOutput(equidistant=true,
      events=false));
    end Meeting;

    model Restroom
      "This is the simulation model of Restroom within building B5a6b99ec37f4de7f94020090 with traceable ID None"

      Buildings.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil[6](    each outSkyCon=true,
        each outGroCon=true,
        til={1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 0.0, 0.0},
        each lat = 0.88645272708792,
        azi = {3.141592653589793, 0.0, 1.5707963267948966, -1.5707963267948966, 0.0, 0.0})
        "Calculates diffuse solar radiation on titled surface for all directions"
        annotation (Placement(transformation(extent={{-68,20},{-48,40}})));
      Buildings.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil[6](    til={1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 0.0, 0.0},
        each lat =  0.88645272708792,
        azi={3.141592653589793, 0.0, 1.5707963267948966, -1.5707963267948966, 0.0, 0.0})
        "Calculates direct solar radiation on titled surface for all directions"
        annotation (Placement(transformation(extent={{-68,52},{-48,72}})));
      Buildings.ThermalZones.ReducedOrder.SolarGain.CorrectionGDoublePane corGDoublePane(n=6,  UWin=1.8936557576825384)
        "Correction factor for solar transmission"
        annotation (Placement(transformation(extent={{6,54},{26,74}})));
      Buildings.ThermalZones.ReducedOrder.RC.TwoElements
      thermalZoneTwoElements(
        redeclare package Medium = Modelica.Media.Air.DryAirNasa,
        VAir=521.8867414172162,
        hConExt=2.0490178828959125,
        hConWin=2.7000000000000006,
        gWin=0.6700000000000002,
        ratioWinConRad=0.030000000000000002,
        nExt=1,
        RExt={0.00014484269741541823},
        CExt={65319165.36689455},
        hRad=5.000000000000001,
        AInt=688.5688536876802,
        hConInt=2.3316080309449254,
        nInt=1,
        RInt={9.201439908964808e-05},
        CInt={84275425.00414628},
        RWin=0.013742118823297953,
        RExtRem=0.007828793990537798,
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        extWallRC(thermCapExt(each der_T(fixed=true))),
        intWallRC(thermCapInt(each der_T(fixed=true))),
        nOrientations=6,
        AWin={11.92763144924453, 11.92763144924453, 1.1056190934805288, 1.1056190934805288, 0.0, 0.0},
        ATransparent={11.92763144924453, 11.92763144924453, 1.1056190934805288, 1.1056190934805288, 0.0, 0.0},
        AExt={35.782894347733595, 35.782894347733595, 3.316857280441586, 3.316857280441586, 72.92818030400002, 72.92818030400002})
        "Thermal zone"
        annotation (Placement(transformation(extent={{44,-2},{92,34}})));
      Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.VDI6007WithWindow eqAirTemp(
        n=6,
        wfGro=0.3626976838332763,
        wfWall={0.15582361279765056, 0.15582361279765056, 0.014443903825944524, 0.014443903825944524, 0.2967672829195336, 0.0},
        wfWin={0.45758467583140006, 0.45758467583140006, 0.04241532416859994, 0.04241532416859994, 0.0, 0.0},
        withLongwave=true,
        aExt=0.5,
        hConWallOut=20.0,
        hRad=5.0,
        hConWinOut=20.0,
        TGro=286.15) "Computes equivalent air temperature"
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
      Modelica.Blocks.Sources.Constant const[6](each k=0)
        "Sets sunblind signal to zero (open)"
        annotation (Placement(transformation(extent={{-20,14},{-14,20}})));
      Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
        annotation (Placement(
        transformation(extent={{-100,-10},{-66,22}}),iconTransformation(
        extent={{-70,-12},{-50,8}})));
      Modelica.Blocks.Sources.Constant alphaWall(k=25.000000000000004*224.0558638643504)
        "Outdoor coefficient of heat transfer for walls"
        annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={30,-16})));
      Modelica.Blocks.Sources.Constant hConWin(k=24.999999999999996*26.066501085450113)
        "Outdoor coefficient of heat transfer for windows"
        annotation (Placement(
        transformation(
        extent={{4,-4},{-4,4}},
        rotation=90,
        origin={32,38})));
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
              "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportRC/Resources/Data/B5a6b99ec37f4de7f94020090/InternalGains_Restroom.mat"),
          columns={2,3,4})
          "Table with profiles for persons (radiative and convective) and machines (convective)"
          annotation (Placement(transformation(extent={{6,-60},{22,-44}})));
      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
        annotation (Placement(transformation(extent={{-10,90},{10,110}}), iconTransformation(extent={{-10,90},{10,110}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealOutput TAir(
        quantity="ThermodynamicTemperature", unit="K", displayUnit="degC")
        "Room air temperature"
        annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    equation
      connect(eqAirTemp.TEqAirWin, prescribedTemperature1.T)
        annotation (Line(
        points={{-3,-0.2},{0,-0.2},{0,20},{6.8,20}},   color={0,0,127}));
      connect(eqAirTemp.TEqAir, prescribedTemperature.T)
        annotation (Line(points={{-3,-4},{4,-4},{4,0},{6.8,0}},
        color={0,0,127}));
      connect(weaBus, weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,18},{-84,18},{-84,12},{-83,12},{-83,6}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
      connect(weaBus.TDryBul, eqAirTemp.TDryBul)
        annotation (Line(
        points={{-83,6},{-83,-2},{-38,-2},{-38,-10},{-26,-10}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
      connect(internalGains.y[1], personsRad.Q_flow)
        annotation (Line(points={{22.8,
        -52},{28,-52},{28,-32},{48,-32}}, color={0,0,127}));
      connect(internalGains.y[2], personsConv.Q_flow)
        annotation (Line(points={{22.8,-52},{36,-52},{48,-52}}, color={0,0,127}));
      connect(internalGains.y[3], machinesConv.Q_flow)
        annotation (Line(points={{22.8,
        -52},{28,-52},{28,-74},{48,-74}}, color={0,0,127}));
      connect(const.y, eqAirTemp.sunblind)
        annotation (Line(points={{-13.7,17},{-12,17},{-12,8},{-14,8},{-14,8}},
        color={0,0,127}));
      connect(HDifTil.HSkyDifTil, corGDoublePane.HSkyDifTil)
        annotation (Line(
        points={{-47,36},{-28,36},{-6,36},{-6,66},{4,66}}, color={0,0,127}));
      connect(HDirTil.H, corGDoublePane.HDirTil)
        annotation (Line(points={{-47,62},{-10,62},{-10,70},{4,70}},
        color={0,0,127}));
      connect(HDirTil.H,solRad. u1)
        annotation (Line(points={{-47,62},{-42,62},{-42,
        14},{-39,14}}, color={0,0,127}));
      connect(HDirTil.inc, corGDoublePane.inc)
        annotation (Line(points={{-47,58},{4,58},{4,58}}, color={0,0,127}));
      connect(HDifTil.H,solRad. u2)
        annotation (Line(points={{-47,30},{-44,30},{-44,
        8},{-39,8}}, color={0,0,127}));
      connect(HDifTil.HGroDifTil, corGDoublePane.HGroDifTil)
        annotation (Line(
        points={{-47,24},{-4,24},{-4,62},{4,62}}, color={0,0,127}));
      connect(solRad.y, eqAirTemp.HSol)
        annotation (Line(points={{-27.5,11},{-26,11},{-26,2},{-26,2}},
        color={0,0,127}));
        connect(weaBus, HDifTil[1].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[1].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[2].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[2].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[3].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[3].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[4].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[4].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[5].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[5].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[6].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[6].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
      connect(personsRad.port, thermalZoneTwoElements.intGainsRad)
        annotation (Line(
        points={{68,-32},{84,-32},{100,-32},{100,24},{92.2,24}},
        color={191,0,0}));
      connect(thermalConductorWin.solid, thermalZoneTwoElements.window)
        annotation (
         Line(points={{38,21},{40,21},{40,20},{43.8,20}}, color={191,0,0}));
      connect(prescribedTemperature1.port, thermalConductorWin.fluid)
        annotation (Line(points={{20,20},{28,20},{28,21}}, color={191,0,0}));
      connect(thermalZoneTwoElements.extWall, thermalConductorWall.solid)
        annotation (Line(points={{43.8,12},{40,12},{40,1},{36,1}},
        color={191,0,0}));
      connect(thermalConductorWall.fluid, prescribedTemperature.port)
        annotation (Line(points={{26,1},{24,1},{24,0},{20,0}}, color={191,0,0}));
      connect(alphaWall.y, thermalConductorWall.Gc)
        annotation (Line(points={{30,-11.6},{30,-4},{31,-4}}, color={0,0,127}));
      connect(hConWin.y, thermalConductorWin.Gc)
        annotation (Line(points={{32,33.6},{32,26},{33,26}}, color={0,0,127}));
      connect(weaBus.TBlaSky, eqAirTemp.TBlaSky)
        annotation (Line(
        points={{-83,6},{-58,6},{-58,2},{-32,2},{-32,-4},{-26,-4}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
      connect(machinesConv.port, thermalZoneTwoElements.intGainsConv)
        annotation (
        Line(points={{68,-74},{82,-74},{96,-74},{96,20},{92,20}}, color={191,
        0,0}));
      connect(personsConv.port, thermalZoneTwoElements.intGainsConv)
        annotation (
        Line(points={{68,-52},{96,-52},{96,20},{92,20}}, color={191,0,0}));
      connect(corGDoublePane.solarRadWinTrans, thermalZoneTwoElements.solRad)
        annotation (Line(points={{27,64},{34,64},{40,64},{40,31},{43,31}}, color={0,
        0,127}));
      connect(port_a, thermalZoneTwoElements.intGainsConv)
        annotation (Line(points={{0,100},{96,100},{96,20},{92,20}}, color={191,0,0}));
      connect(thermalZoneTwoElements.TAir, TAir)
        annotation (Line(points={{93,32},{98,32},{98,0},{110,0}}, color={0,0,127}));
      annotation (experiment(
      StopTime=31536000,
      Interval=3600,
      __Dymola_Algorithm="Cvode"),
      __Dymola_experimentSetupOutput(equidistant=true,
      events=false));
    end Restroom;

    model ICT
      "This is the simulation model of ICT within building B5a6b99ec37f4de7f94020090 with traceable ID None"

      Buildings.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil[6](    each outSkyCon=true,
        each outGroCon=true,
        til={1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 0.0, 0.0},
        each lat = 0.88645272708792,
        azi = {3.141592653589793, 0.0, 1.5707963267948966, -1.5707963267948966, 0.0, 0.0})
        "Calculates diffuse solar radiation on titled surface for all directions"
        annotation (Placement(transformation(extent={{-68,20},{-48,40}})));
      Buildings.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil[6](    til={1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 0.0, 0.0},
        each lat =  0.88645272708792,
        azi={3.141592653589793, 0.0, 1.5707963267948966, -1.5707963267948966, 0.0, 0.0})
        "Calculates direct solar radiation on titled surface for all directions"
        annotation (Placement(transformation(extent={{-68,52},{-48,72}})));
      Buildings.ThermalZones.ReducedOrder.SolarGain.CorrectionGDoublePane corGDoublePane(n=6,  UWin=1.8936557576825384)
        "Correction factor for solar transmission"
        annotation (Placement(transformation(extent={{6,54},{26,74}})));
      Buildings.ThermalZones.ReducedOrder.RC.TwoElements
      thermalZoneTwoElements(
        redeclare package Medium = Modelica.Media.Air.DryAirNasa,
        VAir=260.9433707086081,
        hConExt=2.0490178828959125,
        hConWin=2.7000000000000006,
        gWin=0.6700000000000002,
        ratioWinConRad=0.030000000000000002,
        nExt=1,
        RExt={0.00028968539483083646},
        CExt={32659582.683447275},
        hRad=5.000000000000001,
        AInt=257.303303274304,
        hConInt=2.207073495341845,
        nInt=1,
        RInt={0.0002111894006425288},
        CInt={37115084.57178593},
        RWin=0.027484237646595907,
        RExtRem=0.015657587981075596,
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        extWallRC(thermCapExt(each der_T(fixed=true))),
        intWallRC(thermCapInt(each der_T(fixed=true))),
        nOrientations=6,
        AWin={5.963815724622265, 5.963815724622265, 0.5528095467402644, 0.5528095467402644, 0.0, 0.0},
        ATransparent={5.963815724622265, 5.963815724622265, 0.5528095467402644, 0.5528095467402644, 0.0, 0.0},
        AExt={17.891447173866798, 17.891447173866798, 1.658428640220793, 1.658428640220793, 36.46409015200001, 36.46409015200001})
        "Thermal zone"
        annotation (Placement(transformation(extent={{44,-2},{92,34}})));
      Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.VDI6007WithWindow eqAirTemp(
        n=6,
        wfGro=0.3626976838332763,
        wfWall={0.15582361279765056, 0.15582361279765056, 0.014443903825944524, 0.014443903825944524, 0.2967672829195336, 0.0},
        wfWin={0.45758467583140006, 0.45758467583140006, 0.04241532416859994, 0.04241532416859994, 0.0, 0.0},
        withLongwave=true,
        aExt=0.5,
        hConWallOut=20.0,
        hRad=5.0,
        hConWinOut=20.0,
        TGro=286.15) "Computes equivalent air temperature"
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
      Modelica.Blocks.Sources.Constant const[6](each k=0)
        "Sets sunblind signal to zero (open)"
        annotation (Placement(transformation(extent={{-20,14},{-14,20}})));
      Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
        annotation (Placement(
        transformation(extent={{-100,-10},{-66,22}}),iconTransformation(
        extent={{-70,-12},{-50,8}})));
      Modelica.Blocks.Sources.Constant alphaWall(k=25.000000000000004*112.0279319321752)
        "Outdoor coefficient of heat transfer for walls"
        annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={30,-16})));
      Modelica.Blocks.Sources.Constant hConWin(k=24.999999999999996*13.033250542725057)
        "Outdoor coefficient of heat transfer for windows"
        annotation (Placement(
        transformation(
        extent={{4,-4},{-4,4}},
        rotation=90,
        origin={32,38})));
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
              "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportRC/Resources/Data/B5a6b99ec37f4de7f94020090/InternalGains_ICT.mat"),
          columns={2,3,4})
          "Table with profiles for persons (radiative and convective) and machines (convective)"
          annotation (Placement(transformation(extent={{6,-60},{22,-44}})));
      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
        annotation (Placement(transformation(extent={{-10,90},{10,110}}), iconTransformation(extent={{-10,90},{10,110}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealOutput TAir(
        quantity="ThermodynamicTemperature", unit="K", displayUnit="degC")
        "Room air temperature"
        annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    equation
      connect(eqAirTemp.TEqAirWin, prescribedTemperature1.T)
        annotation (Line(
        points={{-3,-0.2},{0,-0.2},{0,20},{6.8,20}},   color={0,0,127}));
      connect(eqAirTemp.TEqAir, prescribedTemperature.T)
        annotation (Line(points={{-3,-4},{4,-4},{4,0},{6.8,0}},
        color={0,0,127}));
      connect(weaBus, weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,18},{-84,18},{-84,12},{-83,12},{-83,6}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
      connect(weaBus.TDryBul, eqAirTemp.TDryBul)
        annotation (Line(
        points={{-83,6},{-83,-2},{-38,-2},{-38,-10},{-26,-10}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
      connect(internalGains.y[1], personsRad.Q_flow)
        annotation (Line(points={{22.8,
        -52},{28,-52},{28,-32},{48,-32}}, color={0,0,127}));
      connect(internalGains.y[2], personsConv.Q_flow)
        annotation (Line(points={{22.8,-52},{36,-52},{48,-52}}, color={0,0,127}));
      connect(internalGains.y[3], machinesConv.Q_flow)
        annotation (Line(points={{22.8,
        -52},{28,-52},{28,-74},{48,-74}}, color={0,0,127}));
      connect(const.y, eqAirTemp.sunblind)
        annotation (Line(points={{-13.7,17},{-12,17},{-12,8},{-14,8},{-14,8}},
        color={0,0,127}));
      connect(HDifTil.HSkyDifTil, corGDoublePane.HSkyDifTil)
        annotation (Line(
        points={{-47,36},{-28,36},{-6,36},{-6,66},{4,66}}, color={0,0,127}));
      connect(HDirTil.H, corGDoublePane.HDirTil)
        annotation (Line(points={{-47,62},{-10,62},{-10,70},{4,70}},
        color={0,0,127}));
      connect(HDirTil.H,solRad. u1)
        annotation (Line(points={{-47,62},{-42,62},{-42,
        14},{-39,14}}, color={0,0,127}));
      connect(HDirTil.inc, corGDoublePane.inc)
        annotation (Line(points={{-47,58},{4,58},{4,58}}, color={0,0,127}));
      connect(HDifTil.H,solRad. u2)
        annotation (Line(points={{-47,30},{-44,30},{-44,
        8},{-39,8}}, color={0,0,127}));
      connect(HDifTil.HGroDifTil, corGDoublePane.HGroDifTil)
        annotation (Line(
        points={{-47,24},{-4,24},{-4,62},{4,62}}, color={0,0,127}));
      connect(solRad.y, eqAirTemp.HSol)
        annotation (Line(points={{-27.5,11},{-26,11},{-26,2},{-26,2}},
        color={0,0,127}));
        connect(weaBus, HDifTil[1].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[1].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[2].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[2].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[3].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[3].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[4].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[4].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[5].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[5].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[6].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[6].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
      connect(personsRad.port, thermalZoneTwoElements.intGainsRad)
        annotation (Line(
        points={{68,-32},{84,-32},{100,-32},{100,24},{92.2,24}},
        color={191,0,0}));
      connect(thermalConductorWin.solid, thermalZoneTwoElements.window)
        annotation (
         Line(points={{38,21},{40,21},{40,20},{43.8,20}}, color={191,0,0}));
      connect(prescribedTemperature1.port, thermalConductorWin.fluid)
        annotation (Line(points={{20,20},{28,20},{28,21}}, color={191,0,0}));
      connect(thermalZoneTwoElements.extWall, thermalConductorWall.solid)
        annotation (Line(points={{43.8,12},{40,12},{40,1},{36,1}},
        color={191,0,0}));
      connect(thermalConductorWall.fluid, prescribedTemperature.port)
        annotation (Line(points={{26,1},{24,1},{24,0},{20,0}}, color={191,0,0}));
      connect(alphaWall.y, thermalConductorWall.Gc)
        annotation (Line(points={{30,-11.6},{30,-4},{31,-4}}, color={0,0,127}));
      connect(hConWin.y, thermalConductorWin.Gc)
        annotation (Line(points={{32,33.6},{32,26},{33,26}}, color={0,0,127}));
      connect(weaBus.TBlaSky, eqAirTemp.TBlaSky)
        annotation (Line(
        points={{-83,6},{-58,6},{-58,2},{-32,2},{-32,-4},{-26,-4}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
      connect(machinesConv.port, thermalZoneTwoElements.intGainsConv)
        annotation (
        Line(points={{68,-74},{82,-74},{96,-74},{96,20},{92,20}}, color={191,
        0,0}));
      connect(personsConv.port, thermalZoneTwoElements.intGainsConv)
        annotation (
        Line(points={{68,-52},{96,-52},{96,20},{92,20}}, color={191,0,0}));
      connect(corGDoublePane.solarRadWinTrans, thermalZoneTwoElements.solRad)
        annotation (Line(points={{27,64},{34,64},{40,64},{40,31},{43,31}}, color={0,
        0,127}));
      connect(port_a, thermalZoneTwoElements.intGainsConv)
        annotation (Line(points={{0,100},{96,100},{96,20},{92,20}}, color={191,0,0}));
      connect(thermalZoneTwoElements.TAir, TAir)
        annotation (Line(points={{93,32},{98,32},{98,0},{110,0}}, color={0,0,127}));
      annotation (experiment(
      StopTime=31536000,
      Interval=3600,
      __Dymola_Algorithm="Cvode"),
      __Dymola_experimentSetupOutput(equidistant=true,
      events=false));
    end ICT;
  end B5a6b99ec37f4de7f94020090;

  package B5a72287837f4de77124f946a
    extends Modelica.Icons.Package;

    model Office
      "This is the simulation model of Office within building B5a72287837f4de77124f946a with traceable ID None"

      Buildings.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil[6](    each outSkyCon=true,
        each outGroCon=true,
        til={1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 0.0, 0.0},
        each lat = 0.88645272708792,
        azi = {3.141592653589793, 0.0, 1.5707963267948966, -1.5707963267948966, 0.0, 0.0})
        "Calculates diffuse solar radiation on titled surface for all directions"
        annotation (Placement(transformation(extent={{-68,20},{-48,40}})));
      Buildings.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil[6](    til={1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 0.0, 0.0},
        each lat =  0.88645272708792,
        azi={3.141592653589793, 0.0, 1.5707963267948966, -1.5707963267948966, 0.0, 0.0})
        "Calculates direct solar radiation on titled surface for all directions"
        annotation (Placement(transformation(extent={{-68,52},{-48,72}})));
      Buildings.ThermalZones.ReducedOrder.SolarGain.CorrectionGDoublePane corGDoublePane(n=6,  UWin=1.8936557576825386)
        "Correction factor for solar transmission"
        annotation (Placement(transformation(extent={{6,54},{26,74}})));
      Buildings.ThermalZones.ReducedOrder.RC.TwoElements
      thermalZoneTwoElements(
        redeclare package Medium = Modelica.Media.Air.DryAirNasa,
        VAir=1043.8601631264,
        hConExt=1.8547827733865787,
        hConWin=2.7,
        gWin=0.67,
        ratioWinConRad=0.030000000000000002,
        nExt=1,
        RExt={1.0773003154741527e-05},
        CExt={786694415.3102263},
        hRad=5.0,
        AInt=521.9300815632001,
        hConInt=2.7000000000000006,
        nInt=1,
        RInt={0.00023678761956083481},
        CInt={32603332.846306838},
        RWin=0.002234958519462838,
        RExtRem=0.0005599853795025085,
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        extWallRC(thermCapExt(each der_T(fixed=true))),
        intWallRC(thermCapInt(each der_T(fixed=true))),
        nOrientations=6,
        AWin={75.29154525378061, 75.29154525378061, 4.846173657882763, 4.846173657882763, 0.0, 0.0},
        ATransparent={75.29154525378061, 75.29154525378061, 4.846173657882763, 4.846173657882763, 0.0, 0.0},
        AExt={225.8746357613418, 225.8746357613418, 14.53852097364829, 14.53852097364829, 1312.8162593999998, 1312.8162593999998})
        "Thermal zone"
        annotation (Placement(transformation(extent={{44,-2},{92,34}})));
      Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.VDI6007WithWindow eqAirTemp(
        n=6,
        wfGro=0.46752620860272986,
        wfWall={0.0704332742708251, 0.0704332742708251, 0.004533468894272231, 0.004533468894272231, 0.3825403050670754, 0.0},
        wfWin={0.46976346641944755, 0.46976346641944755, 0.030236533580552432, 0.030236533580552432, 0.0, 0.0},
        withLongwave=true,
        aExt=0.5,
        hConWallOut=20.0,
        hRad=5.0,
        hConWinOut=20.0,
        TGro=286.15) "Computes equivalent air temperature"
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
      Modelica.Blocks.Sources.Constant const[6](each k=0)
        "Sets sunblind signal to zero (open)"
        annotation (Placement(transformation(extent={{-20,14},{-14,20}})));
      Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
        annotation (Placement(
        transformation(extent={{-100,-10},{-66,22}}),iconTransformation(
        extent={{-70,-12},{-50,8}})));
      Modelica.Blocks.Sources.Constant alphaWall(k=25.000000000000004*3106.45883226998)
        "Outdoor coefficient of heat transfer for walls"
        annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={30,-16})));
      Modelica.Blocks.Sources.Constant hConWin(k=25.000000000000004*160.27543782332674)
        "Outdoor coefficient of heat transfer for windows"
        annotation (Placement(
        transformation(
        extent={{4,-4},{-4,4}},
        rotation=90,
        origin={32,38})));
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
              "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportRC/Resources/Data/B5a72287837f4de77124f946a/InternalGains_Office.mat"),
          columns={2,3,4})
          "Table with profiles for persons (radiative and convective) and machines (convective)"
          annotation (Placement(transformation(extent={{6,-60},{22,-44}})));
      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
        annotation (Placement(transformation(extent={{-10,90},{10,110}}), iconTransformation(extent={{-10,90},{10,110}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealOutput TAir(
        quantity="ThermodynamicTemperature", unit="K", displayUnit="degC")
        "Room air temperature"
        annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    equation
      connect(eqAirTemp.TEqAirWin, prescribedTemperature1.T)
        annotation (Line(
        points={{-3,-0.2},{0,-0.2},{0,20},{6.8,20}},   color={0,0,127}));
      connect(eqAirTemp.TEqAir, prescribedTemperature.T)
        annotation (Line(points={{-3,-4},{4,-4},{4,0},{6.8,0}},
        color={0,0,127}));
      connect(weaBus, weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,18},{-84,18},{-84,12},{-83,12},{-83,6}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
      connect(weaBus.TDryBul, eqAirTemp.TDryBul)
        annotation (Line(
        points={{-83,6},{-83,-2},{-38,-2},{-38,-10},{-26,-10}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
      connect(internalGains.y[1], personsRad.Q_flow)
        annotation (Line(points={{22.8,
        -52},{28,-52},{28,-32},{48,-32}}, color={0,0,127}));
      connect(internalGains.y[2], personsConv.Q_flow)
        annotation (Line(points={{22.8,-52},{36,-52},{48,-52}}, color={0,0,127}));
      connect(internalGains.y[3], machinesConv.Q_flow)
        annotation (Line(points={{22.8,
        -52},{28,-52},{28,-74},{48,-74}}, color={0,0,127}));
      connect(const.y, eqAirTemp.sunblind)
        annotation (Line(points={{-13.7,17},{-12,17},{-12,8},{-14,8},{-14,8}},
        color={0,0,127}));
      connect(HDifTil.HSkyDifTil, corGDoublePane.HSkyDifTil)
        annotation (Line(
        points={{-47,36},{-28,36},{-6,36},{-6,66},{4,66}}, color={0,0,127}));
      connect(HDirTil.H, corGDoublePane.HDirTil)
        annotation (Line(points={{-47,62},{-10,62},{-10,70},{4,70}},
        color={0,0,127}));
      connect(HDirTil.H,solRad. u1)
        annotation (Line(points={{-47,62},{-42,62},{-42,
        14},{-39,14}}, color={0,0,127}));
      connect(HDirTil.inc, corGDoublePane.inc)
        annotation (Line(points={{-47,58},{4,58},{4,58}}, color={0,0,127}));
      connect(HDifTil.H,solRad. u2)
        annotation (Line(points={{-47,30},{-44,30},{-44,
        8},{-39,8}}, color={0,0,127}));
      connect(HDifTil.HGroDifTil, corGDoublePane.HGroDifTil)
        annotation (Line(
        points={{-47,24},{-4,24},{-4,62},{4,62}}, color={0,0,127}));
      connect(solRad.y, eqAirTemp.HSol)
        annotation (Line(points={{-27.5,11},{-26,11},{-26,2},{-26,2}},
        color={0,0,127}));
        connect(weaBus, HDifTil[1].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[1].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[2].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[2].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[3].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[3].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[4].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[4].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[5].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[5].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[6].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[6].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
      connect(personsRad.port, thermalZoneTwoElements.intGainsRad)
        annotation (Line(
        points={{68,-32},{84,-32},{100,-32},{100,24},{92.2,24}},
        color={191,0,0}));
      connect(thermalConductorWin.solid, thermalZoneTwoElements.window)
        annotation (
         Line(points={{38,21},{40,21},{40,20},{43.8,20}}, color={191,0,0}));
      connect(prescribedTemperature1.port, thermalConductorWin.fluid)
        annotation (Line(points={{20,20},{28,20},{28,21}}, color={191,0,0}));
      connect(thermalZoneTwoElements.extWall, thermalConductorWall.solid)
        annotation (Line(points={{43.8,12},{40,12},{40,1},{36,1}},
        color={191,0,0}));
      connect(thermalConductorWall.fluid, prescribedTemperature.port)
        annotation (Line(points={{26,1},{24,1},{24,0},{20,0}}, color={191,0,0}));
      connect(alphaWall.y, thermalConductorWall.Gc)
        annotation (Line(points={{30,-11.6},{30,-4},{31,-4}}, color={0,0,127}));
      connect(hConWin.y, thermalConductorWin.Gc)
        annotation (Line(points={{32,33.6},{32,26},{33,26}}, color={0,0,127}));
      connect(weaBus.TBlaSky, eqAirTemp.TBlaSky)
        annotation (Line(
        points={{-83,6},{-58,6},{-58,2},{-32,2},{-32,-4},{-26,-4}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
      connect(machinesConv.port, thermalZoneTwoElements.intGainsConv)
        annotation (
        Line(points={{68,-74},{82,-74},{96,-74},{96,20},{92,20}}, color={191,
        0,0}));
      connect(personsConv.port, thermalZoneTwoElements.intGainsConv)
        annotation (
        Line(points={{68,-52},{96,-52},{96,20},{92,20}}, color={191,0,0}));
      connect(corGDoublePane.solarRadWinTrans, thermalZoneTwoElements.solRad)
        annotation (Line(points={{27,64},{34,64},{40,64},{40,31},{43,31}}, color={0,
        0,127}));
      connect(port_a, thermalZoneTwoElements.intGainsConv)
        annotation (Line(points={{0,100},{96,100},{96,20},{92,20}}, color={191,0,0}));
      connect(thermalZoneTwoElements.TAir, TAir)
        annotation (Line(points={{93,32},{98,32},{98,0},{110,0}}, color={0,0,127}));
      annotation (experiment(
      StopTime=31536000,
      Interval=3600,
      __Dymola_Algorithm="Cvode"),
      __Dymola_experimentSetupOutput(equidistant=true,
      events=false));
    end Office;

    model Floor
      "This is the simulation model of Floor within building B5a72287837f4de77124f946a with traceable ID None"

      Buildings.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil[6](    each outSkyCon=true,
        each outGroCon=true,
        til={1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 0.0, 0.0},
        each lat = 0.88645272708792,
        azi = {3.141592653589793, 0.0, 1.5707963267948966, -1.5707963267948966, 0.0, 0.0})
        "Calculates diffuse solar radiation on titled surface for all directions"
        annotation (Placement(transformation(extent={{-68,20},{-48,40}})));
      Buildings.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil[6](    til={1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 0.0, 0.0},
        each lat =  0.88645272708792,
        azi={3.141592653589793, 0.0, 1.5707963267948966, -1.5707963267948966, 0.0, 0.0})
        "Calculates direct solar radiation on titled surface for all directions"
        annotation (Placement(transformation(extent={{-68,52},{-48,72}})));
      Buildings.ThermalZones.ReducedOrder.SolarGain.CorrectionGDoublePane corGDoublePane(n=6,  UWin=1.8936557576825386)
        "Correction factor for solar transmission"
        annotation (Placement(transformation(extent={{6,54},{26,74}})));
      Buildings.ThermalZones.ReducedOrder.RC.TwoElements
      thermalZoneTwoElements(
        redeclare package Medium = Modelica.Media.Air.DryAirNasa,
        VAir=521.9300815632,
        hConExt=1.8547827733865787,
        hConWin=2.7,
        gWin=0.67,
        ratioWinConRad=0.030000000000000002,
        nExt=1,
        RExt={2.1546006309483054e-05},
        CExt={393347207.65511316},
        hRad=5.000000000000001,
        AInt=565.4242550268001,
        hConInt=2.7,
        nInt=1,
        RInt={0.00021857318728692448},
        CInt={35320277.250165574},
        RWin=0.004469917038925676,
        RExtRem=0.001119970759005017,
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        extWallRC(thermCapExt(each der_T(fixed=true))),
        intWallRC(thermCapInt(each der_T(fixed=true))),
        nOrientations=6,
        AWin={37.645772626890306, 37.645772626890306, 2.4230868289413814, 2.4230868289413814, 0.0, 0.0},
        ATransparent={37.645772626890306, 37.645772626890306, 2.4230868289413814, 2.4230868289413814, 0.0, 0.0},
        AExt={112.9373178806709, 112.9373178806709, 7.269260486824145, 7.269260486824145, 656.4081296999999, 656.4081296999999})
        "Thermal zone"
        annotation (Placement(transformation(extent={{44,-2},{92,34}})));
      Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.VDI6007WithWindow eqAirTemp(
        n=6,
        wfGro=0.46752620860272986,
        wfWall={0.0704332742708251, 0.0704332742708251, 0.004533468894272231, 0.004533468894272231, 0.3825403050670754, 0.0},
        wfWin={0.46976346641944755, 0.46976346641944755, 0.030236533580552432, 0.030236533580552432, 0.0, 0.0},
        withLongwave=true,
        aExt=0.5,
        hConWallOut=20.0,
        hRad=5.0,
        hConWinOut=20.0,
        TGro=286.15) "Computes equivalent air temperature"
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
      Modelica.Blocks.Sources.Constant const[6](each k=0)
        "Sets sunblind signal to zero (open)"
        annotation (Placement(transformation(extent={{-20,14},{-14,20}})));
      Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
        annotation (Placement(
        transformation(extent={{-100,-10},{-66,22}}),iconTransformation(
        extent={{-70,-12},{-50,8}})));
      Modelica.Blocks.Sources.Constant alphaWall(k=25.000000000000004*1553.22941613499)
        "Outdoor coefficient of heat transfer for walls"
        annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={30,-16})));
      Modelica.Blocks.Sources.Constant hConWin(k=25.000000000000004*80.13771891166337)
        "Outdoor coefficient of heat transfer for windows"
        annotation (Placement(
        transformation(
        extent={{4,-4},{-4,4}},
        rotation=90,
        origin={32,38})));
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
              "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportRC/Resources/Data/B5a72287837f4de77124f946a/InternalGains_Floor.mat"),
          columns={2,3,4})
          "Table with profiles for persons (radiative and convective) and machines (convective)"
          annotation (Placement(transformation(extent={{6,-60},{22,-44}})));
      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
        annotation (Placement(transformation(extent={{-10,90},{10,110}}), iconTransformation(extent={{-10,90},{10,110}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealOutput TAir(
        quantity="ThermodynamicTemperature", unit="K", displayUnit="degC")
        "Room air temperature"
        annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    equation
      connect(eqAirTemp.TEqAirWin, prescribedTemperature1.T)
        annotation (Line(
        points={{-3,-0.2},{0,-0.2},{0,20},{6.8,20}},   color={0,0,127}));
      connect(eqAirTemp.TEqAir, prescribedTemperature.T)
        annotation (Line(points={{-3,-4},{4,-4},{4,0},{6.8,0}},
        color={0,0,127}));
      connect(weaBus, weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,18},{-84,18},{-84,12},{-83,12},{-83,6}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
      connect(weaBus.TDryBul, eqAirTemp.TDryBul)
        annotation (Line(
        points={{-83,6},{-83,-2},{-38,-2},{-38,-10},{-26,-10}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
      connect(internalGains.y[1], personsRad.Q_flow)
        annotation (Line(points={{22.8,
        -52},{28,-52},{28,-32},{48,-32}}, color={0,0,127}));
      connect(internalGains.y[2], personsConv.Q_flow)
        annotation (Line(points={{22.8,-52},{36,-52},{48,-52}}, color={0,0,127}));
      connect(internalGains.y[3], machinesConv.Q_flow)
        annotation (Line(points={{22.8,
        -52},{28,-52},{28,-74},{48,-74}}, color={0,0,127}));
      connect(const.y, eqAirTemp.sunblind)
        annotation (Line(points={{-13.7,17},{-12,17},{-12,8},{-14,8},{-14,8}},
        color={0,0,127}));
      connect(HDifTil.HSkyDifTil, corGDoublePane.HSkyDifTil)
        annotation (Line(
        points={{-47,36},{-28,36},{-6,36},{-6,66},{4,66}}, color={0,0,127}));
      connect(HDirTil.H, corGDoublePane.HDirTil)
        annotation (Line(points={{-47,62},{-10,62},{-10,70},{4,70}},
        color={0,0,127}));
      connect(HDirTil.H,solRad. u1)
        annotation (Line(points={{-47,62},{-42,62},{-42,
        14},{-39,14}}, color={0,0,127}));
      connect(HDirTil.inc, corGDoublePane.inc)
        annotation (Line(points={{-47,58},{4,58},{4,58}}, color={0,0,127}));
      connect(HDifTil.H,solRad. u2)
        annotation (Line(points={{-47,30},{-44,30},{-44,
        8},{-39,8}}, color={0,0,127}));
      connect(HDifTil.HGroDifTil, corGDoublePane.HGroDifTil)
        annotation (Line(
        points={{-47,24},{-4,24},{-4,62},{4,62}}, color={0,0,127}));
      connect(solRad.y, eqAirTemp.HSol)
        annotation (Line(points={{-27.5,11},{-26,11},{-26,2},{-26,2}},
        color={0,0,127}));
        connect(weaBus, HDifTil[1].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[1].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[2].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[2].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[3].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[3].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[4].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[4].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[5].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[5].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[6].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[6].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
      connect(personsRad.port, thermalZoneTwoElements.intGainsRad)
        annotation (Line(
        points={{68,-32},{84,-32},{100,-32},{100,24},{92.2,24}},
        color={191,0,0}));
      connect(thermalConductorWin.solid, thermalZoneTwoElements.window)
        annotation (
         Line(points={{38,21},{40,21},{40,20},{43.8,20}}, color={191,0,0}));
      connect(prescribedTemperature1.port, thermalConductorWin.fluid)
        annotation (Line(points={{20,20},{28,20},{28,21}}, color={191,0,0}));
      connect(thermalZoneTwoElements.extWall, thermalConductorWall.solid)
        annotation (Line(points={{43.8,12},{40,12},{40,1},{36,1}},
        color={191,0,0}));
      connect(thermalConductorWall.fluid, prescribedTemperature.port)
        annotation (Line(points={{26,1},{24,1},{24,0},{20,0}}, color={191,0,0}));
      connect(alphaWall.y, thermalConductorWall.Gc)
        annotation (Line(points={{30,-11.6},{30,-4},{31,-4}}, color={0,0,127}));
      connect(hConWin.y, thermalConductorWin.Gc)
        annotation (Line(points={{32,33.6},{32,26},{33,26}}, color={0,0,127}));
      connect(weaBus.TBlaSky, eqAirTemp.TBlaSky)
        annotation (Line(
        points={{-83,6},{-58,6},{-58,2},{-32,2},{-32,-4},{-26,-4}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
      connect(machinesConv.port, thermalZoneTwoElements.intGainsConv)
        annotation (
        Line(points={{68,-74},{82,-74},{96,-74},{96,20},{92,20}}, color={191,
        0,0}));
      connect(personsConv.port, thermalZoneTwoElements.intGainsConv)
        annotation (
        Line(points={{68,-52},{96,-52},{96,20},{92,20}}, color={191,0,0}));
      connect(corGDoublePane.solarRadWinTrans, thermalZoneTwoElements.solRad)
        annotation (Line(points={{27,64},{34,64},{40,64},{40,31},{43,31}}, color={0,
        0,127}));
      connect(port_a, thermalZoneTwoElements.intGainsConv)
        annotation (Line(points={{0,100},{96,100},{96,20},{92,20}}, color={191,0,0}));
      connect(thermalZoneTwoElements.TAir, TAir)
        annotation (Line(points={{93,32},{98,32},{98,0},{110,0}}, color={0,0,127}));
      annotation (experiment(
      StopTime=31536000,
      Interval=3600,
      __Dymola_Algorithm="Cvode"),
      __Dymola_experimentSetupOutput(equidistant=true,
      events=false));
    end Floor;

    model Storage
      "This is the simulation model of Storage within building B5a72287837f4de77124f946a with traceable ID None"

      Buildings.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil[6](    each outSkyCon=true,
        each outGroCon=true,
        til={1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 0.0, 0.0},
        each lat = 0.88645272708792,
        azi = {3.141592653589793, 0.0, 1.5707963267948966, -1.5707963267948966, 0.0, 0.0})
        "Calculates diffuse solar radiation on titled surface for all directions"
        annotation (Placement(transformation(extent={{-68,20},{-48,40}})));
      Buildings.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil[6](    til={1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 0.0, 0.0},
        each lat =  0.88645272708792,
        azi={3.141592653589793, 0.0, 1.5707963267948966, -1.5707963267948966, 0.0, 0.0})
        "Calculates direct solar radiation on titled surface for all directions"
        annotation (Placement(transformation(extent={{-68,52},{-48,72}})));
      Buildings.ThermalZones.ReducedOrder.SolarGain.CorrectionGDoublePane corGDoublePane(n=6,  UWin=1.8936557576825381)
        "Correction factor for solar transmission"
        annotation (Placement(transformation(extent={{6,54},{26,74}})));
      Buildings.ThermalZones.ReducedOrder.RC.TwoElements
      thermalZoneTwoElements(
        redeclare package Medium = Modelica.Media.Air.DryAirNasa,
        VAir=313.15804893792,
        hConExt=1.8547827733865792,
        hConWin=2.6999999999999997,
        gWin=0.67,
        ratioWinConRad=0.029999999999999992,
        nExt=1,
        RExt={3.591001051580503e-05},
        CExt={236008324.59306812},
        hRad=5.0,
        AInt=156.57902446896003,
        hConInt=2.7,
        nInt=1,
        RInt={0.0007892920652027828},
        CInt={9780999.85389205},
        RWin=0.0074498617315427946,
        RExtRem=0.001866617931675028,
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        extWallRC(thermCapExt(each der_T(fixed=true))),
        intWallRC(thermCapInt(each der_T(fixed=true))),
        nOrientations=6,
        AWin={22.587463576134184, 22.587463576134184, 1.4538520973648288, 1.4538520973648288, 0.0, 0.0},
        ATransparent={22.587463576134184, 22.587463576134184, 1.4538520973648288, 1.4538520973648288, 0.0, 0.0},
        AExt={67.76239072840255, 67.76239072840255, 4.361556292094487, 4.361556292094487, 393.84487781999997, 393.84487781999997})
        "Thermal zone"
        annotation (Placement(transformation(extent={{44,-2},{92,34}})));
      Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.VDI6007WithWindow eqAirTemp(
        n=6,
        wfGro=0.4675262086027299,
        wfWall={0.07043327427082512, 0.07043327427082512, 0.0045334688942722315, 0.0045334688942722315, 0.3825403050670754, 0.0},
        wfWin={0.46976346641944755, 0.46976346641944755, 0.030236533580552435, 0.030236533580552435, 0.0, 0.0},
        withLongwave=true,
        aExt=0.5,
        hConWallOut=20.000000000000004,
        hRad=5.000000000000001,
        hConWinOut=19.999999999999996,
        TGro=286.15) "Computes equivalent air temperature"
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
      Modelica.Blocks.Sources.Constant const[6](each k=0)
        "Sets sunblind signal to zero (open)"
        annotation (Placement(transformation(extent={{-20,14},{-14,20}})));
      Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
        annotation (Placement(
        transformation(extent={{-100,-10},{-66,22}}),iconTransformation(
        extent={{-70,-12},{-50,8}})));
      Modelica.Blocks.Sources.Constant alphaWall(k=25.000000000000004*931.937649680994)
        "Outdoor coefficient of heat transfer for walls"
        annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={30,-16})));
      Modelica.Blocks.Sources.Constant hConWin(k=24.999999999999996*48.08263134699803)
        "Outdoor coefficient of heat transfer for windows"
        annotation (Placement(
        transformation(
        extent={{4,-4},{-4,4}},
        rotation=90,
        origin={32,38})));
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
              "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportRC/Resources/Data/B5a72287837f4de77124f946a/InternalGains_Storage.mat"),
          columns={2,3,4})
          "Table with profiles for persons (radiative and convective) and machines (convective)"
          annotation (Placement(transformation(extent={{6,-60},{22,-44}})));
      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
        annotation (Placement(transformation(extent={{-10,90},{10,110}}), iconTransformation(extent={{-10,90},{10,110}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealOutput TAir(
        quantity="ThermodynamicTemperature", unit="K", displayUnit="degC")
        "Room air temperature"
        annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    equation
      connect(eqAirTemp.TEqAirWin, prescribedTemperature1.T)
        annotation (Line(
        points={{-3,-0.2},{0,-0.2},{0,20},{6.8,20}},   color={0,0,127}));
      connect(eqAirTemp.TEqAir, prescribedTemperature.T)
        annotation (Line(points={{-3,-4},{4,-4},{4,0},{6.8,0}},
        color={0,0,127}));
      connect(weaBus, weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,18},{-84,18},{-84,12},{-83,12},{-83,6}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
      connect(weaBus.TDryBul, eqAirTemp.TDryBul)
        annotation (Line(
        points={{-83,6},{-83,-2},{-38,-2},{-38,-10},{-26,-10}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
      connect(internalGains.y[1], personsRad.Q_flow)
        annotation (Line(points={{22.8,
        -52},{28,-52},{28,-32},{48,-32}}, color={0,0,127}));
      connect(internalGains.y[2], personsConv.Q_flow)
        annotation (Line(points={{22.8,-52},{36,-52},{48,-52}}, color={0,0,127}));
      connect(internalGains.y[3], machinesConv.Q_flow)
        annotation (Line(points={{22.8,
        -52},{28,-52},{28,-74},{48,-74}}, color={0,0,127}));
      connect(const.y, eqAirTemp.sunblind)
        annotation (Line(points={{-13.7,17},{-12,17},{-12,8},{-14,8},{-14,8}},
        color={0,0,127}));
      connect(HDifTil.HSkyDifTil, corGDoublePane.HSkyDifTil)
        annotation (Line(
        points={{-47,36},{-28,36},{-6,36},{-6,66},{4,66}}, color={0,0,127}));
      connect(HDirTil.H, corGDoublePane.HDirTil)
        annotation (Line(points={{-47,62},{-10,62},{-10,70},{4,70}},
        color={0,0,127}));
      connect(HDirTil.H,solRad. u1)
        annotation (Line(points={{-47,62},{-42,62},{-42,
        14},{-39,14}}, color={0,0,127}));
      connect(HDirTil.inc, corGDoublePane.inc)
        annotation (Line(points={{-47,58},{4,58},{4,58}}, color={0,0,127}));
      connect(HDifTil.H,solRad. u2)
        annotation (Line(points={{-47,30},{-44,30},{-44,
        8},{-39,8}}, color={0,0,127}));
      connect(HDifTil.HGroDifTil, corGDoublePane.HGroDifTil)
        annotation (Line(
        points={{-47,24},{-4,24},{-4,62},{4,62}}, color={0,0,127}));
      connect(solRad.y, eqAirTemp.HSol)
        annotation (Line(points={{-27.5,11},{-26,11},{-26,2},{-26,2}},
        color={0,0,127}));
        connect(weaBus, HDifTil[1].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[1].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[2].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[2].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[3].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[3].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[4].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[4].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[5].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[5].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[6].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[6].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
      connect(personsRad.port, thermalZoneTwoElements.intGainsRad)
        annotation (Line(
        points={{68,-32},{84,-32},{100,-32},{100,24},{92.2,24}},
        color={191,0,0}));
      connect(thermalConductorWin.solid, thermalZoneTwoElements.window)
        annotation (
         Line(points={{38,21},{40,21},{40,20},{43.8,20}}, color={191,0,0}));
      connect(prescribedTemperature1.port, thermalConductorWin.fluid)
        annotation (Line(points={{20,20},{28,20},{28,21}}, color={191,0,0}));
      connect(thermalZoneTwoElements.extWall, thermalConductorWall.solid)
        annotation (Line(points={{43.8,12},{40,12},{40,1},{36,1}},
        color={191,0,0}));
      connect(thermalConductorWall.fluid, prescribedTemperature.port)
        annotation (Line(points={{26,1},{24,1},{24,0},{20,0}}, color={191,0,0}));
      connect(alphaWall.y, thermalConductorWall.Gc)
        annotation (Line(points={{30,-11.6},{30,-4},{31,-4}}, color={0,0,127}));
      connect(hConWin.y, thermalConductorWin.Gc)
        annotation (Line(points={{32,33.6},{32,26},{33,26}}, color={0,0,127}));
      connect(weaBus.TBlaSky, eqAirTemp.TBlaSky)
        annotation (Line(
        points={{-83,6},{-58,6},{-58,2},{-32,2},{-32,-4},{-26,-4}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
      connect(machinesConv.port, thermalZoneTwoElements.intGainsConv)
        annotation (
        Line(points={{68,-74},{82,-74},{96,-74},{96,20},{92,20}}, color={191,
        0,0}));
      connect(personsConv.port, thermalZoneTwoElements.intGainsConv)
        annotation (
        Line(points={{68,-52},{96,-52},{96,20},{92,20}}, color={191,0,0}));
      connect(corGDoublePane.solarRadWinTrans, thermalZoneTwoElements.solRad)
        annotation (Line(points={{27,64},{34,64},{40,64},{40,31},{43,31}}, color={0,
        0,127}));
      connect(port_a, thermalZoneTwoElements.intGainsConv)
        annotation (Line(points={{0,100},{96,100},{96,20},{92,20}}, color={191,0,0}));
      connect(thermalZoneTwoElements.TAir, TAir)
        annotation (Line(points={{93,32},{98,32},{98,0},{110,0}}, color={0,0,127}));
      annotation (experiment(
      StopTime=31536000,
      Interval=3600,
      __Dymola_Algorithm="Cvode"),
      __Dymola_experimentSetupOutput(equidistant=true,
      events=false));
    end Storage;

    model Meeting
      "This is the simulation model of Meeting within building B5a72287837f4de77124f946a with traceable ID None"

      Buildings.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil[6](    each outSkyCon=true,
        each outGroCon=true,
        til={1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 0.0, 0.0},
        each lat = 0.88645272708792,
        azi = {3.141592653589793, 0.0, 1.5707963267948966, -1.5707963267948966, 0.0, 0.0})
        "Calculates diffuse solar radiation on titled surface for all directions"
        annotation (Placement(transformation(extent={{-68,20},{-48,40}})));
      Buildings.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil[6](    til={1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 0.0, 0.0},
        each lat =  0.88645272708792,
        azi={3.141592653589793, 0.0, 1.5707963267948966, -1.5707963267948966, 0.0, 0.0})
        "Calculates direct solar radiation on titled surface for all directions"
        annotation (Placement(transformation(extent={{-68,52},{-48,72}})));
      Buildings.ThermalZones.ReducedOrder.SolarGain.CorrectionGDoublePane corGDoublePane(n=6,  UWin=1.8936557576825384)
        "Correction factor for solar transmission"
        annotation (Placement(transformation(extent={{6,54},{26,74}})));
      Buildings.ThermalZones.ReducedOrder.RC.TwoElements
      thermalZoneTwoElements(
        redeclare package Medium = Modelica.Media.Air.DryAirNasa,
        VAir=83.508813050112,
        hConExt=1.8547827733865787,
        hConWin=2.700000000000001,
        gWin=0.67,
        ratioWinConRad=0.030000000000000006,
        nExt=1,
        RExt={0.00013466253943426908},
        CExt={62935553.224818096},
        hRad=4.999999999999998,
        AInt=41.754406525056005,
        hConInt=2.6999999999999997,
        nInt=1,
        RInt={0.0029598452445104358},
        CInt={2608266.6277045463},
        RWin=0.027936981493285485,
        RExtRem=0.006999817243781356,
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        extWallRC(thermCapExt(each der_T(fixed=true))),
        intWallRC(thermCapInt(each der_T(fixed=true))),
        nOrientations=6,
        AWin={6.023323620302449, 6.023323620302449, 0.387693892630621, 0.387693892630621, 0.0, 0.0},
        ATransparent={6.023323620302449, 6.023323620302449, 0.387693892630621, 0.387693892630621, 0.0, 0.0},
        AExt={18.069970860907343, 18.069970860907343, 1.1630816778918631, 1.1630816778918631, 105.02530075199998, 105.02530075199998})
        "Thermal zone"
        annotation (Placement(transformation(extent={{44,-2},{92,34}})));
      Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.VDI6007WithWindow eqAirTemp(
        n=6,
        wfGro=0.46752620860272986,
        wfWall={0.07043327427082512, 0.07043327427082512, 0.004533468894272232, 0.004533468894272232, 0.3825403050670754, 0.0},
        wfWin={0.4697634664194476, 0.4697634664194476, 0.030236533580552432, 0.030236533580552432, 0.0, 0.0},
        withLongwave=true,
        aExt=0.5,
        hConWallOut=20.0,
        hRad=4.999999999999998,
        hConWinOut=20.000000000000007,
        TGro=286.15) "Computes equivalent air temperature"
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
      Modelica.Blocks.Sources.Constant const[6](each k=0)
        "Sets sunblind signal to zero (open)"
        annotation (Placement(transformation(extent={{-20,14},{-14,20}})));
      Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
        annotation (Placement(
        transformation(extent={{-100,-10},{-66,22}}),iconTransformation(
        extent={{-70,-12},{-50,8}})));
      Modelica.Blocks.Sources.Constant alphaWall(k=25.0*248.51670658159838)
        "Outdoor coefficient of heat transfer for walls"
        annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={30,-16})));
      Modelica.Blocks.Sources.Constant hConWin(k=25.000000000000007*12.822035025866139)
        "Outdoor coefficient of heat transfer for windows"
        annotation (Placement(
        transformation(
        extent={{4,-4},{-4,4}},
        rotation=90,
        origin={32,38})));
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
              "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportRC/Resources/Data/B5a72287837f4de77124f946a/InternalGains_Meeting.mat"),
          columns={2,3,4})
          "Table with profiles for persons (radiative and convective) and machines (convective)"
          annotation (Placement(transformation(extent={{6,-60},{22,-44}})));
      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
        annotation (Placement(transformation(extent={{-10,90},{10,110}}), iconTransformation(extent={{-10,90},{10,110}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealOutput TAir(
        quantity="ThermodynamicTemperature", unit="K", displayUnit="degC")
        "Room air temperature"
        annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    equation
      connect(eqAirTemp.TEqAirWin, prescribedTemperature1.T)
        annotation (Line(
        points={{-3,-0.2},{0,-0.2},{0,20},{6.8,20}},   color={0,0,127}));
      connect(eqAirTemp.TEqAir, prescribedTemperature.T)
        annotation (Line(points={{-3,-4},{4,-4},{4,0},{6.8,0}},
        color={0,0,127}));
      connect(weaBus, weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,18},{-84,18},{-84,12},{-83,12},{-83,6}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
      connect(weaBus.TDryBul, eqAirTemp.TDryBul)
        annotation (Line(
        points={{-83,6},{-83,-2},{-38,-2},{-38,-10},{-26,-10}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
      connect(internalGains.y[1], personsRad.Q_flow)
        annotation (Line(points={{22.8,
        -52},{28,-52},{28,-32},{48,-32}}, color={0,0,127}));
      connect(internalGains.y[2], personsConv.Q_flow)
        annotation (Line(points={{22.8,-52},{36,-52},{48,-52}}, color={0,0,127}));
      connect(internalGains.y[3], machinesConv.Q_flow)
        annotation (Line(points={{22.8,
        -52},{28,-52},{28,-74},{48,-74}}, color={0,0,127}));
      connect(const.y, eqAirTemp.sunblind)
        annotation (Line(points={{-13.7,17},{-12,17},{-12,8},{-14,8},{-14,8}},
        color={0,0,127}));
      connect(HDifTil.HSkyDifTil, corGDoublePane.HSkyDifTil)
        annotation (Line(
        points={{-47,36},{-28,36},{-6,36},{-6,66},{4,66}}, color={0,0,127}));
      connect(HDirTil.H, corGDoublePane.HDirTil)
        annotation (Line(points={{-47,62},{-10,62},{-10,70},{4,70}},
        color={0,0,127}));
      connect(HDirTil.H,solRad. u1)
        annotation (Line(points={{-47,62},{-42,62},{-42,
        14},{-39,14}}, color={0,0,127}));
      connect(HDirTil.inc, corGDoublePane.inc)
        annotation (Line(points={{-47,58},{4,58},{4,58}}, color={0,0,127}));
      connect(HDifTil.H,solRad. u2)
        annotation (Line(points={{-47,30},{-44,30},{-44,
        8},{-39,8}}, color={0,0,127}));
      connect(HDifTil.HGroDifTil, corGDoublePane.HGroDifTil)
        annotation (Line(
        points={{-47,24},{-4,24},{-4,62},{4,62}}, color={0,0,127}));
      connect(solRad.y, eqAirTemp.HSol)
        annotation (Line(points={{-27.5,11},{-26,11},{-26,2},{-26,2}},
        color={0,0,127}));
        connect(weaBus, HDifTil[1].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[1].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[2].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[2].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[3].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[3].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[4].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[4].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[5].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[5].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[6].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[6].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
      connect(personsRad.port, thermalZoneTwoElements.intGainsRad)
        annotation (Line(
        points={{68,-32},{84,-32},{100,-32},{100,24},{92.2,24}},
        color={191,0,0}));
      connect(thermalConductorWin.solid, thermalZoneTwoElements.window)
        annotation (
         Line(points={{38,21},{40,21},{40,20},{43.8,20}}, color={191,0,0}));
      connect(prescribedTemperature1.port, thermalConductorWin.fluid)
        annotation (Line(points={{20,20},{28,20},{28,21}}, color={191,0,0}));
      connect(thermalZoneTwoElements.extWall, thermalConductorWall.solid)
        annotation (Line(points={{43.8,12},{40,12},{40,1},{36,1}},
        color={191,0,0}));
      connect(thermalConductorWall.fluid, prescribedTemperature.port)
        annotation (Line(points={{26,1},{24,1},{24,0},{20,0}}, color={191,0,0}));
      connect(alphaWall.y, thermalConductorWall.Gc)
        annotation (Line(points={{30,-11.6},{30,-4},{31,-4}}, color={0,0,127}));
      connect(hConWin.y, thermalConductorWin.Gc)
        annotation (Line(points={{32,33.6},{32,26},{33,26}}, color={0,0,127}));
      connect(weaBus.TBlaSky, eqAirTemp.TBlaSky)
        annotation (Line(
        points={{-83,6},{-58,6},{-58,2},{-32,2},{-32,-4},{-26,-4}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
      connect(machinesConv.port, thermalZoneTwoElements.intGainsConv)
        annotation (
        Line(points={{68,-74},{82,-74},{96,-74},{96,20},{92,20}}, color={191,
        0,0}));
      connect(personsConv.port, thermalZoneTwoElements.intGainsConv)
        annotation (
        Line(points={{68,-52},{96,-52},{96,20},{92,20}}, color={191,0,0}));
      connect(corGDoublePane.solarRadWinTrans, thermalZoneTwoElements.solRad)
        annotation (Line(points={{27,64},{34,64},{40,64},{40,31},{43,31}}, color={0,
        0,127}));
      connect(port_a, thermalZoneTwoElements.intGainsConv)
        annotation (Line(points={{0,100},{96,100},{96,20},{92,20}}, color={191,0,0}));
      connect(thermalZoneTwoElements.TAir, TAir)
        annotation (Line(points={{93,32},{98,32},{98,0},{110,0}}, color={0,0,127}));
      annotation (experiment(
      StopTime=31536000,
      Interval=3600,
      __Dymola_Algorithm="Cvode"),
      __Dymola_experimentSetupOutput(equidistant=true,
      events=false));
    end Meeting;

    model Restroom
      "This is the simulation model of Restroom within building B5a72287837f4de77124f946a with traceable ID None"

      Buildings.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil[6](    each outSkyCon=true,
        each outGroCon=true,
        til={1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 0.0, 0.0},
        each lat = 0.88645272708792,
        azi = {3.141592653589793, 0.0, 1.5707963267948966, -1.5707963267948966, 0.0, 0.0})
        "Calculates diffuse solar radiation on titled surface for all directions"
        annotation (Placement(transformation(extent={{-68,20},{-48,40}})));
      Buildings.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil[6](    til={1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 0.0, 0.0},
        each lat =  0.88645272708792,
        azi={3.141592653589793, 0.0, 1.5707963267948966, -1.5707963267948966, 0.0, 0.0})
        "Calculates direct solar radiation on titled surface for all directions"
        annotation (Placement(transformation(extent={{-68,52},{-48,72}})));
      Buildings.ThermalZones.ReducedOrder.SolarGain.CorrectionGDoublePane corGDoublePane(n=6,  UWin=1.8936557576825384)
        "Correction factor for solar transmission"
        annotation (Placement(transformation(extent={{6,54},{26,74}})));
      Buildings.ThermalZones.ReducedOrder.RC.TwoElements
      thermalZoneTwoElements(
        redeclare package Medium = Modelica.Media.Air.DryAirNasa,
        VAir=83.508813050112,
        hConExt=1.8547827733865787,
        hConWin=2.700000000000001,
        gWin=0.67,
        ratioWinConRad=0.030000000000000006,
        nExt=1,
        RExt={0.00013466253943426908},
        CExt={62935553.224818096},
        hRad=4.999999999999998,
        AInt=69.59067754176,
        hConInt=2.7,
        nInt=1,
        RInt={0.0017759071467062615},
        CInt={4347111.046174244},
        RWin=0.027936981493285485,
        RExtRem=0.006999817243781356,
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        extWallRC(thermCapExt(each der_T(fixed=true))),
        intWallRC(thermCapInt(each der_T(fixed=true))),
        nOrientations=6,
        AWin={6.023323620302449, 6.023323620302449, 0.387693892630621, 0.387693892630621, 0.0, 0.0},
        ATransparent={6.023323620302449, 6.023323620302449, 0.387693892630621, 0.387693892630621, 0.0, 0.0},
        AExt={18.069970860907343, 18.069970860907343, 1.1630816778918631, 1.1630816778918631, 105.02530075199998, 105.02530075199998})
        "Thermal zone"
        annotation (Placement(transformation(extent={{44,-2},{92,34}})));
      Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.VDI6007WithWindow eqAirTemp(
        n=6,
        wfGro=0.46752620860272986,
        wfWall={0.07043327427082512, 0.07043327427082512, 0.004533468894272232, 0.004533468894272232, 0.3825403050670754, 0.0},
        wfWin={0.4697634664194476, 0.4697634664194476, 0.030236533580552432, 0.030236533580552432, 0.0, 0.0},
        withLongwave=true,
        aExt=0.5,
        hConWallOut=20.0,
        hRad=4.999999999999998,
        hConWinOut=20.000000000000007,
        TGro=286.15) "Computes equivalent air temperature"
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
      Modelica.Blocks.Sources.Constant const[6](each k=0)
        "Sets sunblind signal to zero (open)"
        annotation (Placement(transformation(extent={{-20,14},{-14,20}})));
      Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
        annotation (Placement(
        transformation(extent={{-100,-10},{-66,22}}),iconTransformation(
        extent={{-70,-12},{-50,8}})));
      Modelica.Blocks.Sources.Constant alphaWall(k=25.0*248.51670658159838)
        "Outdoor coefficient of heat transfer for walls"
        annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={30,-16})));
      Modelica.Blocks.Sources.Constant hConWin(k=25.000000000000007*12.822035025866139)
        "Outdoor coefficient of heat transfer for windows"
        annotation (Placement(
        transformation(
        extent={{4,-4},{-4,4}},
        rotation=90,
        origin={32,38})));
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
              "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportRC/Resources/Data/B5a72287837f4de77124f946a/InternalGains_Restroom.mat"),
          columns={2,3,4})
          "Table with profiles for persons (radiative and convective) and machines (convective)"
          annotation (Placement(transformation(extent={{6,-60},{22,-44}})));
      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
        annotation (Placement(transformation(extent={{-10,90},{10,110}}), iconTransformation(extent={{-10,90},{10,110}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealOutput TAir(
        quantity="ThermodynamicTemperature", unit="K", displayUnit="degC")
        "Room air temperature"
        annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    equation
      connect(eqAirTemp.TEqAirWin, prescribedTemperature1.T)
        annotation (Line(
        points={{-3,-0.2},{0,-0.2},{0,20},{6.8,20}},   color={0,0,127}));
      connect(eqAirTemp.TEqAir, prescribedTemperature.T)
        annotation (Line(points={{-3,-4},{4,-4},{4,0},{6.8,0}},
        color={0,0,127}));
      connect(weaBus, weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,18},{-84,18},{-84,12},{-83,12},{-83,6}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
      connect(weaBus.TDryBul, eqAirTemp.TDryBul)
        annotation (Line(
        points={{-83,6},{-83,-2},{-38,-2},{-38,-10},{-26,-10}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
      connect(internalGains.y[1], personsRad.Q_flow)
        annotation (Line(points={{22.8,
        -52},{28,-52},{28,-32},{48,-32}}, color={0,0,127}));
      connect(internalGains.y[2], personsConv.Q_flow)
        annotation (Line(points={{22.8,-52},{36,-52},{48,-52}}, color={0,0,127}));
      connect(internalGains.y[3], machinesConv.Q_flow)
        annotation (Line(points={{22.8,
        -52},{28,-52},{28,-74},{48,-74}}, color={0,0,127}));
      connect(const.y, eqAirTemp.sunblind)
        annotation (Line(points={{-13.7,17},{-12,17},{-12,8},{-14,8},{-14,8}},
        color={0,0,127}));
      connect(HDifTil.HSkyDifTil, corGDoublePane.HSkyDifTil)
        annotation (Line(
        points={{-47,36},{-28,36},{-6,36},{-6,66},{4,66}}, color={0,0,127}));
      connect(HDirTil.H, corGDoublePane.HDirTil)
        annotation (Line(points={{-47,62},{-10,62},{-10,70},{4,70}},
        color={0,0,127}));
      connect(HDirTil.H,solRad. u1)
        annotation (Line(points={{-47,62},{-42,62},{-42,
        14},{-39,14}}, color={0,0,127}));
      connect(HDirTil.inc, corGDoublePane.inc)
        annotation (Line(points={{-47,58},{4,58},{4,58}}, color={0,0,127}));
      connect(HDifTil.H,solRad. u2)
        annotation (Line(points={{-47,30},{-44,30},{-44,
        8},{-39,8}}, color={0,0,127}));
      connect(HDifTil.HGroDifTil, corGDoublePane.HGroDifTil)
        annotation (Line(
        points={{-47,24},{-4,24},{-4,62},{4,62}}, color={0,0,127}));
      connect(solRad.y, eqAirTemp.HSol)
        annotation (Line(points={{-27.5,11},{-26,11},{-26,2},{-26,2}},
        color={0,0,127}));
        connect(weaBus, HDifTil[1].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[1].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[2].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[2].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[3].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[3].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[4].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[4].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[5].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[5].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[6].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[6].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
      connect(personsRad.port, thermalZoneTwoElements.intGainsRad)
        annotation (Line(
        points={{68,-32},{84,-32},{100,-32},{100,24},{92.2,24}},
        color={191,0,0}));
      connect(thermalConductorWin.solid, thermalZoneTwoElements.window)
        annotation (
         Line(points={{38,21},{40,21},{40,20},{43.8,20}}, color={191,0,0}));
      connect(prescribedTemperature1.port, thermalConductorWin.fluid)
        annotation (Line(points={{20,20},{28,20},{28,21}}, color={191,0,0}));
      connect(thermalZoneTwoElements.extWall, thermalConductorWall.solid)
        annotation (Line(points={{43.8,12},{40,12},{40,1},{36,1}},
        color={191,0,0}));
      connect(thermalConductorWall.fluid, prescribedTemperature.port)
        annotation (Line(points={{26,1},{24,1},{24,0},{20,0}}, color={191,0,0}));
      connect(alphaWall.y, thermalConductorWall.Gc)
        annotation (Line(points={{30,-11.6},{30,-4},{31,-4}}, color={0,0,127}));
      connect(hConWin.y, thermalConductorWin.Gc)
        annotation (Line(points={{32,33.6},{32,26},{33,26}}, color={0,0,127}));
      connect(weaBus.TBlaSky, eqAirTemp.TBlaSky)
        annotation (Line(
        points={{-83,6},{-58,6},{-58,2},{-32,2},{-32,-4},{-26,-4}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
      connect(machinesConv.port, thermalZoneTwoElements.intGainsConv)
        annotation (
        Line(points={{68,-74},{82,-74},{96,-74},{96,20},{92,20}}, color={191,
        0,0}));
      connect(personsConv.port, thermalZoneTwoElements.intGainsConv)
        annotation (
        Line(points={{68,-52},{96,-52},{96,20},{92,20}}, color={191,0,0}));
      connect(corGDoublePane.solarRadWinTrans, thermalZoneTwoElements.solRad)
        annotation (Line(points={{27,64},{34,64},{40,64},{40,31},{43,31}}, color={0,
        0,127}));
      connect(port_a, thermalZoneTwoElements.intGainsConv)
        annotation (Line(points={{0,100},{96,100},{96,20},{92,20}}, color={191,0,0}));
      connect(thermalZoneTwoElements.TAir, TAir)
        annotation (Line(points={{93,32},{98,32},{98,0},{110,0}}, color={0,0,127}));
      annotation (experiment(
      StopTime=31536000,
      Interval=3600,
      __Dymola_Algorithm="Cvode"),
      __Dymola_experimentSetupOutput(equidistant=true,
      events=false));
    end Restroom;

    model ICT
      "This is the simulation model of ICT within building B5a72287837f4de77124f946a with traceable ID None"

      Buildings.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil[6](    each outSkyCon=true,
        each outGroCon=true,
        til={1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 0.0, 0.0},
        each lat = 0.88645272708792,
        azi = {3.141592653589793, 0.0, 1.5707963267948966, -1.5707963267948966, 0.0, 0.0})
        "Calculates diffuse solar radiation on titled surface for all directions"
        annotation (Placement(transformation(extent={{-68,20},{-48,40}})));
      Buildings.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil[6](    til={1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 0.0, 0.0},
        each lat =  0.88645272708792,
        azi={3.141592653589793, 0.0, 1.5707963267948966, -1.5707963267948966, 0.0, 0.0})
        "Calculates direct solar radiation on titled surface for all directions"
        annotation (Placement(transformation(extent={{-68,52},{-48,72}})));
      Buildings.ThermalZones.ReducedOrder.SolarGain.CorrectionGDoublePane corGDoublePane(n=6,  UWin=1.8936557576825384)
        "Correction factor for solar transmission"
        annotation (Placement(transformation(extent={{6,54},{26,74}})));
      Buildings.ThermalZones.ReducedOrder.RC.TwoElements
      thermalZoneTwoElements(
        redeclare package Medium = Modelica.Media.Air.DryAirNasa,
        VAir=41.754406525056,
        hConExt=1.8547827733865787,
        hConWin=2.700000000000001,
        gWin=0.67,
        ratioWinConRad=0.030000000000000006,
        nExt=1,
        RExt={0.00026932507886853817},
        CExt={31467776.612409048},
        hRad=4.999999999999998,
        AInt=20.877203262528003,
        hConInt=2.6999999999999997,
        nInt=1,
        RInt={0.0059196904890208716},
        CInt={1304133.3138522732},
        RWin=0.05587396298657097,
        RExtRem=0.013999634487562713,
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        extWallRC(thermCapExt(each der_T(fixed=true))),
        intWallRC(thermCapInt(each der_T(fixed=true))),
        nOrientations=6,
        AWin={3.0116618101512245, 3.0116618101512245, 0.1938469463153105, 0.1938469463153105, 0.0, 0.0},
        ATransparent={3.0116618101512245, 3.0116618101512245, 0.1938469463153105, 0.1938469463153105, 0.0, 0.0},
        AExt={9.034985430453672, 9.034985430453672, 0.5815408389459316, 0.5815408389459316, 52.51265037599999, 52.51265037599999})
        "Thermal zone"
        annotation (Placement(transformation(extent={{44,-2},{92,34}})));
      Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.VDI6007WithWindow eqAirTemp(
        n=6,
        wfGro=0.46752620860272986,
        wfWall={0.07043327427082512, 0.07043327427082512, 0.004533468894272232, 0.004533468894272232, 0.3825403050670754, 0.0},
        wfWin={0.4697634664194476, 0.4697634664194476, 0.030236533580552432, 0.030236533580552432, 0.0, 0.0},
        withLongwave=true,
        aExt=0.5,
        hConWallOut=20.0,
        hRad=4.999999999999998,
        hConWinOut=20.000000000000007,
        TGro=286.15) "Computes equivalent air temperature"
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
      Modelica.Blocks.Sources.Constant const[6](each k=0)
        "Sets sunblind signal to zero (open)"
        annotation (Placement(transformation(extent={{-20,14},{-14,20}})));
      Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
        annotation (Placement(
        transformation(extent={{-100,-10},{-66,22}}),iconTransformation(
        extent={{-70,-12},{-50,8}})));
      Modelica.Blocks.Sources.Constant alphaWall(k=25.0*124.25835329079919)
        "Outdoor coefficient of heat transfer for walls"
        annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={30,-16})));
      Modelica.Blocks.Sources.Constant hConWin(k=25.000000000000007*6.4110175129330695)
        "Outdoor coefficient of heat transfer for windows"
        annotation (Placement(
        transformation(
        extent={{4,-4},{-4,4}},
        rotation=90,
        origin={32,38})));
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
              "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportRC/Resources/Data/B5a72287837f4de77124f946a/InternalGains_ICT.mat"),
          columns={2,3,4})
          "Table with profiles for persons (radiative and convective) and machines (convective)"
          annotation (Placement(transformation(extent={{6,-60},{22,-44}})));
      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
        annotation (Placement(transformation(extent={{-10,90},{10,110}}), iconTransformation(extent={{-10,90},{10,110}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealOutput TAir(
        quantity="ThermodynamicTemperature", unit="K", displayUnit="degC")
        "Room air temperature"
        annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    equation
      connect(eqAirTemp.TEqAirWin, prescribedTemperature1.T)
        annotation (Line(
        points={{-3,-0.2},{0,-0.2},{0,20},{6.8,20}},   color={0,0,127}));
      connect(eqAirTemp.TEqAir, prescribedTemperature.T)
        annotation (Line(points={{-3,-4},{4,-4},{4,0},{6.8,0}},
        color={0,0,127}));
      connect(weaBus, weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,18},{-84,18},{-84,12},{-83,12},{-83,6}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
      connect(weaBus.TDryBul, eqAirTemp.TDryBul)
        annotation (Line(
        points={{-83,6},{-83,-2},{-38,-2},{-38,-10},{-26,-10}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
      connect(internalGains.y[1], personsRad.Q_flow)
        annotation (Line(points={{22.8,
        -52},{28,-52},{28,-32},{48,-32}}, color={0,0,127}));
      connect(internalGains.y[2], personsConv.Q_flow)
        annotation (Line(points={{22.8,-52},{36,-52},{48,-52}}, color={0,0,127}));
      connect(internalGains.y[3], machinesConv.Q_flow)
        annotation (Line(points={{22.8,
        -52},{28,-52},{28,-74},{48,-74}}, color={0,0,127}));
      connect(const.y, eqAirTemp.sunblind)
        annotation (Line(points={{-13.7,17},{-12,17},{-12,8},{-14,8},{-14,8}},
        color={0,0,127}));
      connect(HDifTil.HSkyDifTil, corGDoublePane.HSkyDifTil)
        annotation (Line(
        points={{-47,36},{-28,36},{-6,36},{-6,66},{4,66}}, color={0,0,127}));
      connect(HDirTil.H, corGDoublePane.HDirTil)
        annotation (Line(points={{-47,62},{-10,62},{-10,70},{4,70}},
        color={0,0,127}));
      connect(HDirTil.H,solRad. u1)
        annotation (Line(points={{-47,62},{-42,62},{-42,
        14},{-39,14}}, color={0,0,127}));
      connect(HDirTil.inc, corGDoublePane.inc)
        annotation (Line(points={{-47,58},{4,58},{4,58}}, color={0,0,127}));
      connect(HDifTil.H,solRad. u2)
        annotation (Line(points={{-47,30},{-44,30},{-44,
        8},{-39,8}}, color={0,0,127}));
      connect(HDifTil.HGroDifTil, corGDoublePane.HGroDifTil)
        annotation (Line(
        points={{-47,24},{-4,24},{-4,62},{4,62}}, color={0,0,127}));
      connect(solRad.y, eqAirTemp.HSol)
        annotation (Line(points={{-27.5,11},{-26,11},{-26,2},{-26,2}},
        color={0,0,127}));
        connect(weaBus, HDifTil[1].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[1].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[2].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[2].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[3].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[3].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[4].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[4].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[5].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[5].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[6].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[6].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
      connect(personsRad.port, thermalZoneTwoElements.intGainsRad)
        annotation (Line(
        points={{68,-32},{84,-32},{100,-32},{100,24},{92.2,24}},
        color={191,0,0}));
      connect(thermalConductorWin.solid, thermalZoneTwoElements.window)
        annotation (
         Line(points={{38,21},{40,21},{40,20},{43.8,20}}, color={191,0,0}));
      connect(prescribedTemperature1.port, thermalConductorWin.fluid)
        annotation (Line(points={{20,20},{28,20},{28,21}}, color={191,0,0}));
      connect(thermalZoneTwoElements.extWall, thermalConductorWall.solid)
        annotation (Line(points={{43.8,12},{40,12},{40,1},{36,1}},
        color={191,0,0}));
      connect(thermalConductorWall.fluid, prescribedTemperature.port)
        annotation (Line(points={{26,1},{24,1},{24,0},{20,0}}, color={191,0,0}));
      connect(alphaWall.y, thermalConductorWall.Gc)
        annotation (Line(points={{30,-11.6},{30,-4},{31,-4}}, color={0,0,127}));
      connect(hConWin.y, thermalConductorWin.Gc)
        annotation (Line(points={{32,33.6},{32,26},{33,26}}, color={0,0,127}));
      connect(weaBus.TBlaSky, eqAirTemp.TBlaSky)
        annotation (Line(
        points={{-83,6},{-58,6},{-58,2},{-32,2},{-32,-4},{-26,-4}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
      connect(machinesConv.port, thermalZoneTwoElements.intGainsConv)
        annotation (
        Line(points={{68,-74},{82,-74},{96,-74},{96,20},{92,20}}, color={191,
        0,0}));
      connect(personsConv.port, thermalZoneTwoElements.intGainsConv)
        annotation (
        Line(points={{68,-52},{96,-52},{96,20},{92,20}}, color={191,0,0}));
      connect(corGDoublePane.solarRadWinTrans, thermalZoneTwoElements.solRad)
        annotation (Line(points={{27,64},{34,64},{40,64},{40,31},{43,31}}, color={0,
        0,127}));
      connect(port_a, thermalZoneTwoElements.intGainsConv)
        annotation (Line(points={{0,100},{96,100},{96,20},{92,20}}, color={191,0,0}));
      connect(thermalZoneTwoElements.TAir, TAir)
        annotation (Line(points={{93,32},{98,32},{98,0},{110,0}}, color={0,0,127}));
      annotation (experiment(
      StopTime=31536000,
      Interval=3600,
      __Dymola_Algorithm="Cvode"),
      __Dymola_experimentSetupOutput(equidistant=true,
      events=false));
    end ICT;
  end B5a72287837f4de77124f946a;

  package B5a7229e737f4de77124f946d
    extends Modelica.Icons.Package;

    model Office
      "This is the simulation model of Office within building B5a7229e737f4de77124f946d with traceable ID None"

      Buildings.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil[6](    each outSkyCon=true,
        each outGroCon=true,
        til={1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 0.0, 0.0},
        each lat = 0.88645272708792,
        azi = {3.141592653589793, 0.0, 1.5707963267948966, -1.5707963267948966, 0.0, 0.0})
        "Calculates diffuse solar radiation on titled surface for all directions"
        annotation (Placement(transformation(extent={{-68,20},{-48,40}})));
      Buildings.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil[6](    til={1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 0.0, 0.0},
        each lat =  0.88645272708792,
        azi={3.141592653589793, 0.0, 1.5707963267948966, -1.5707963267948966, 0.0, 0.0})
        "Calculates direct solar radiation on titled surface for all directions"
        annotation (Placement(transformation(extent={{-68,52},{-48,72}})));
      Buildings.ThermalZones.ReducedOrder.SolarGain.CorrectionGDoublePane corGDoublePane(n=6,  UWin=1.8936557576825381)
        "Correction factor for solar transmission"
        annotation (Placement(transformation(extent={{6,54},{26,74}})));
      Buildings.ThermalZones.ReducedOrder.RC.TwoElements
      thermalZoneTwoElements(
        redeclare package Medium = Modelica.Media.Air.DryAirNasa,
        VAir=5854.828819046401,
        hConExt=2.1199708957531502,
        hConWin=2.7000000000000006,
        gWin=0.67,
        ratioWinConRad=0.03,
        nExt=1,
        RExt={2.013205270301902e-05},
        CExt={484847611.723353},
        hRad=5.0,
        AInt=5328.508905523201,
        hConInt=2.2493871665465037,
        nInt=1,
        RInt={1.0716462019469407e-05},
        CInt={729051192.1847438},
        RWin=0.0016125101133058688,
        RExtRem=0.0011088487567730604,
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        extWallRC(thermCapExt(each der_T(fixed=true))),
        intWallRC(thermCapInt(each der_T(fixed=true))),
        nOrientations=6,
        AWin={93.84144073171085, 93.84144073171085, 17.230406901387923, 17.230406901387923, 0.0, 0.0},
        ATransparent={93.84144073171085, 93.84144073171085, 17.230406901387923, 17.230406901387923, 0.0, 0.0},
        AExt={281.5243221951326, 281.5243221951326, 51.69122070416377, 51.69122070416377, 460.2097784, 460.2097784})
        "Thermal zone"
        annotation (Placement(transformation(extent={{44,-2},{92,34}})));
      Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.VDI6007WithWindow eqAirTemp(
        n=6,
        wfGro=0.32402425378350974,
        wfWall={0.1735585434113848, 0.1735585434113848, 0.031867417005457546, 0.031867417005457546, 0.2651238253828056, 0.0},
        wfWin={0.42243575996725674, 0.42243575996725674, 0.0775642400327433, 0.0775642400327433, 0.0, 0.0},
        withLongwave=true,
        aExt=0.5,
        hConWallOut=20.0,
        hRad=5.0,
        hConWinOut=20.0,
        TGro=286.15) "Computes equivalent air temperature"
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
      Modelica.Blocks.Sources.Constant const[6](each k=0)
        "Sets sunblind signal to zero (open)"
        annotation (Placement(transformation(extent={{-20,14},{-14,20}})));
      Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
        annotation (Placement(
        transformation(extent={{-100,-10},{-66,22}}),iconTransformation(
        extent={{-70,-12},{-50,8}})));
      Modelica.Blocks.Sources.Constant alphaWall(k=25.000000000000007*1586.8506425985927)
        "Outdoor coefficient of heat transfer for walls"
        annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={30,-16})));
      Modelica.Blocks.Sources.Constant hConWin(k=25.0*222.14369526619754)
        "Outdoor coefficient of heat transfer for windows"
        annotation (Placement(
        transformation(
        extent={{4,-4},{-4,4}},
        rotation=90,
        origin={32,38})));
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
              "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportRC/Resources/Data/B5a7229e737f4de77124f946d/InternalGains_Office.mat"),
          columns={2,3,4})
          "Table with profiles for persons (radiative and convective) and machines (convective)"
          annotation (Placement(transformation(extent={{6,-60},{22,-44}})));
      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
        annotation (Placement(transformation(extent={{-10,90},{10,110}}), iconTransformation(extent={{-10,90},{10,110}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealOutput TAir(
        quantity="ThermodynamicTemperature", unit="K", displayUnit="degC")
        "Room air temperature"
        annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    equation
      connect(eqAirTemp.TEqAirWin, prescribedTemperature1.T)
        annotation (Line(
        points={{-3,-0.2},{0,-0.2},{0,20},{6.8,20}},   color={0,0,127}));
      connect(eqAirTemp.TEqAir, prescribedTemperature.T)
        annotation (Line(points={{-3,-4},{4,-4},{4,0},{6.8,0}},
        color={0,0,127}));
      connect(weaBus, weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,18},{-84,18},{-84,12},{-83,12},{-83,6}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
      connect(weaBus.TDryBul, eqAirTemp.TDryBul)
        annotation (Line(
        points={{-83,6},{-83,-2},{-38,-2},{-38,-10},{-26,-10}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
      connect(internalGains.y[1], personsRad.Q_flow)
        annotation (Line(points={{22.8,
        -52},{28,-52},{28,-32},{48,-32}}, color={0,0,127}));
      connect(internalGains.y[2], personsConv.Q_flow)
        annotation (Line(points={{22.8,-52},{36,-52},{48,-52}}, color={0,0,127}));
      connect(internalGains.y[3], machinesConv.Q_flow)
        annotation (Line(points={{22.8,
        -52},{28,-52},{28,-74},{48,-74}}, color={0,0,127}));
      connect(const.y, eqAirTemp.sunblind)
        annotation (Line(points={{-13.7,17},{-12,17},{-12,8},{-14,8},{-14,8}},
        color={0,0,127}));
      connect(HDifTil.HSkyDifTil, corGDoublePane.HSkyDifTil)
        annotation (Line(
        points={{-47,36},{-28,36},{-6,36},{-6,66},{4,66}}, color={0,0,127}));
      connect(HDirTil.H, corGDoublePane.HDirTil)
        annotation (Line(points={{-47,62},{-10,62},{-10,70},{4,70}},
        color={0,0,127}));
      connect(HDirTil.H,solRad. u1)
        annotation (Line(points={{-47,62},{-42,62},{-42,
        14},{-39,14}}, color={0,0,127}));
      connect(HDirTil.inc, corGDoublePane.inc)
        annotation (Line(points={{-47,58},{4,58},{4,58}}, color={0,0,127}));
      connect(HDifTil.H,solRad. u2)
        annotation (Line(points={{-47,30},{-44,30},{-44,
        8},{-39,8}}, color={0,0,127}));
      connect(HDifTil.HGroDifTil, corGDoublePane.HGroDifTil)
        annotation (Line(
        points={{-47,24},{-4,24},{-4,62},{4,62}}, color={0,0,127}));
      connect(solRad.y, eqAirTemp.HSol)
        annotation (Line(points={{-27.5,11},{-26,11},{-26,2},{-26,2}},
        color={0,0,127}));
        connect(weaBus, HDifTil[1].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[1].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[2].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[2].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[3].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[3].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[4].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[4].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[5].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[5].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[6].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[6].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
      connect(personsRad.port, thermalZoneTwoElements.intGainsRad)
        annotation (Line(
        points={{68,-32},{84,-32},{100,-32},{100,24},{92.2,24}},
        color={191,0,0}));
      connect(thermalConductorWin.solid, thermalZoneTwoElements.window)
        annotation (
         Line(points={{38,21},{40,21},{40,20},{43.8,20}}, color={191,0,0}));
      connect(prescribedTemperature1.port, thermalConductorWin.fluid)
        annotation (Line(points={{20,20},{28,20},{28,21}}, color={191,0,0}));
      connect(thermalZoneTwoElements.extWall, thermalConductorWall.solid)
        annotation (Line(points={{43.8,12},{40,12},{40,1},{36,1}},
        color={191,0,0}));
      connect(thermalConductorWall.fluid, prescribedTemperature.port)
        annotation (Line(points={{26,1},{24,1},{24,0},{20,0}}, color={191,0,0}));
      connect(alphaWall.y, thermalConductorWall.Gc)
        annotation (Line(points={{30,-11.6},{30,-4},{31,-4}}, color={0,0,127}));
      connect(hConWin.y, thermalConductorWin.Gc)
        annotation (Line(points={{32,33.6},{32,26},{33,26}}, color={0,0,127}));
      connect(weaBus.TBlaSky, eqAirTemp.TBlaSky)
        annotation (Line(
        points={{-83,6},{-58,6},{-58,2},{-32,2},{-32,-4},{-26,-4}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
      connect(machinesConv.port, thermalZoneTwoElements.intGainsConv)
        annotation (
        Line(points={{68,-74},{82,-74},{96,-74},{96,20},{92,20}}, color={191,
        0,0}));
      connect(personsConv.port, thermalZoneTwoElements.intGainsConv)
        annotation (
        Line(points={{68,-52},{96,-52},{96,20},{92,20}}, color={191,0,0}));
      connect(corGDoublePane.solarRadWinTrans, thermalZoneTwoElements.solRad)
        annotation (Line(points={{27,64},{34,64},{40,64},{40,31},{43,31}}, color={0,
        0,127}));
      connect(port_a, thermalZoneTwoElements.intGainsConv)
        annotation (Line(points={{0,100},{96,100},{96,20},{92,20}}, color={191,0,0}));
      connect(thermalZoneTwoElements.TAir, TAir)
        annotation (Line(points={{93,32},{98,32},{98,0},{110,0}}, color={0,0,127}));
      annotation (experiment(
      StopTime=31536000,
      Interval=3600,
      __Dymola_Algorithm="Cvode"),
      __Dymola_experimentSetupOutput(equidistant=true,
      events=false));
    end Office;

    model Floor
      "This is the simulation model of Floor within building B5a7229e737f4de77124f946d with traceable ID None"

      Buildings.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil[6](    each outSkyCon=true,
        each outGroCon=true,
        til={1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 0.0, 0.0},
        each lat = 0.88645272708792,
        azi = {3.141592653589793, 0.0, 1.5707963267948966, -1.5707963267948966, 0.0, 0.0})
        "Calculates diffuse solar radiation on titled surface for all directions"
        annotation (Placement(transformation(extent={{-68,20},{-48,40}})));
      Buildings.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil[6](    til={1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 0.0, 0.0},
        each lat =  0.88645272708792,
        azi={3.141592653589793, 0.0, 1.5707963267948966, -1.5707963267948966, 0.0, 0.0})
        "Calculates direct solar radiation on titled surface for all directions"
        annotation (Placement(transformation(extent={{-68,52},{-48,72}})));
      Buildings.ThermalZones.ReducedOrder.SolarGain.CorrectionGDoublePane corGDoublePane(n=6,  UWin=1.8936557576825381)
        "Correction factor for solar transmission"
        annotation (Placement(transformation(extent={{6,54},{26,74}})));
      Buildings.ThermalZones.ReducedOrder.RC.TwoElements
      thermalZoneTwoElements(
        redeclare package Medium = Modelica.Media.Air.DryAirNasa,
        VAir=2927.4144095232004,
        hConExt=2.1199708957531502,
        hConWin=2.7000000000000006,
        gWin=0.67,
        ratioWinConRad=0.03,
        nExt=1,
        RExt={4.026410540603804e-05},
        CExt={242423805.8616765},
        hRad=5.0,
        AInt=4371.912858316801,
        hConInt=2.4253954305799645,
        nInt=1,
        RInt={1.6558289956160254e-05},
        CInt={463133947.3301717},
        RWin=0.0032250202266117375,
        RExtRem=0.002217697513546121,
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        extWallRC(thermCapExt(each der_T(fixed=true))),
        intWallRC(thermCapInt(each der_T(fixed=true))),
        nOrientations=6,
        AWin={46.92072036585542, 46.92072036585542, 8.615203450693961, 8.615203450693961, 0.0, 0.0},
        ATransparent={46.92072036585542, 46.92072036585542, 8.615203450693961, 8.615203450693961, 0.0, 0.0},
        AExt={140.7621610975663, 140.7621610975663, 25.845610352081884, 25.845610352081884, 230.1048892, 230.1048892})
        "Thermal zone"
        annotation (Placement(transformation(extent={{44,-2},{92,34}})));
      Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.VDI6007WithWindow eqAirTemp(
        n=6,
        wfGro=0.32402425378350974,
        wfWall={0.1735585434113848, 0.1735585434113848, 0.031867417005457546, 0.031867417005457546, 0.2651238253828056, 0.0},
        wfWin={0.42243575996725674, 0.42243575996725674, 0.0775642400327433, 0.0775642400327433, 0.0, 0.0},
        withLongwave=true,
        aExt=0.5,
        hConWallOut=20.0,
        hRad=5.0,
        hConWinOut=20.0,
        TGro=286.15) "Computes equivalent air temperature"
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
      Modelica.Blocks.Sources.Constant const[6](each k=0)
        "Sets sunblind signal to zero (open)"
        annotation (Placement(transformation(extent={{-20,14},{-14,20}})));
      Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
        annotation (Placement(
        transformation(extent={{-100,-10},{-66,22}}),iconTransformation(
        extent={{-70,-12},{-50,8}})));
      Modelica.Blocks.Sources.Constant alphaWall(k=25.000000000000007*793.4253212992963)
        "Outdoor coefficient of heat transfer for walls"
        annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={30,-16})));
      Modelica.Blocks.Sources.Constant hConWin(k=25.0*111.07184763309877)
        "Outdoor coefficient of heat transfer for windows"
        annotation (Placement(
        transformation(
        extent={{4,-4},{-4,4}},
        rotation=90,
        origin={32,38})));
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
              "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportRC/Resources/Data/B5a7229e737f4de77124f946d/InternalGains_Floor.mat"),
          columns={2,3,4})
          "Table with profiles for persons (radiative and convective) and machines (convective)"
          annotation (Placement(transformation(extent={{6,-60},{22,-44}})));
      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
        annotation (Placement(transformation(extent={{-10,90},{10,110}}), iconTransformation(extent={{-10,90},{10,110}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealOutput TAir(
        quantity="ThermodynamicTemperature", unit="K", displayUnit="degC")
        "Room air temperature"
        annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    equation
      connect(eqAirTemp.TEqAirWin, prescribedTemperature1.T)
        annotation (Line(
        points={{-3,-0.2},{0,-0.2},{0,20},{6.8,20}},   color={0,0,127}));
      connect(eqAirTemp.TEqAir, prescribedTemperature.T)
        annotation (Line(points={{-3,-4},{4,-4},{4,0},{6.8,0}},
        color={0,0,127}));
      connect(weaBus, weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,18},{-84,18},{-84,12},{-83,12},{-83,6}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
      connect(weaBus.TDryBul, eqAirTemp.TDryBul)
        annotation (Line(
        points={{-83,6},{-83,-2},{-38,-2},{-38,-10},{-26,-10}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
      connect(internalGains.y[1], personsRad.Q_flow)
        annotation (Line(points={{22.8,
        -52},{28,-52},{28,-32},{48,-32}}, color={0,0,127}));
      connect(internalGains.y[2], personsConv.Q_flow)
        annotation (Line(points={{22.8,-52},{36,-52},{48,-52}}, color={0,0,127}));
      connect(internalGains.y[3], machinesConv.Q_flow)
        annotation (Line(points={{22.8,
        -52},{28,-52},{28,-74},{48,-74}}, color={0,0,127}));
      connect(const.y, eqAirTemp.sunblind)
        annotation (Line(points={{-13.7,17},{-12,17},{-12,8},{-14,8},{-14,8}},
        color={0,0,127}));
      connect(HDifTil.HSkyDifTil, corGDoublePane.HSkyDifTil)
        annotation (Line(
        points={{-47,36},{-28,36},{-6,36},{-6,66},{4,66}}, color={0,0,127}));
      connect(HDirTil.H, corGDoublePane.HDirTil)
        annotation (Line(points={{-47,62},{-10,62},{-10,70},{4,70}},
        color={0,0,127}));
      connect(HDirTil.H,solRad. u1)
        annotation (Line(points={{-47,62},{-42,62},{-42,
        14},{-39,14}}, color={0,0,127}));
      connect(HDirTil.inc, corGDoublePane.inc)
        annotation (Line(points={{-47,58},{4,58},{4,58}}, color={0,0,127}));
      connect(HDifTil.H,solRad. u2)
        annotation (Line(points={{-47,30},{-44,30},{-44,
        8},{-39,8}}, color={0,0,127}));
      connect(HDifTil.HGroDifTil, corGDoublePane.HGroDifTil)
        annotation (Line(
        points={{-47,24},{-4,24},{-4,62},{4,62}}, color={0,0,127}));
      connect(solRad.y, eqAirTemp.HSol)
        annotation (Line(points={{-27.5,11},{-26,11},{-26,2},{-26,2}},
        color={0,0,127}));
        connect(weaBus, HDifTil[1].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[1].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[2].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[2].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[3].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[3].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[4].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[4].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[5].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[5].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[6].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[6].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
      connect(personsRad.port, thermalZoneTwoElements.intGainsRad)
        annotation (Line(
        points={{68,-32},{84,-32},{100,-32},{100,24},{92.2,24}},
        color={191,0,0}));
      connect(thermalConductorWin.solid, thermalZoneTwoElements.window)
        annotation (
         Line(points={{38,21},{40,21},{40,20},{43.8,20}}, color={191,0,0}));
      connect(prescribedTemperature1.port, thermalConductorWin.fluid)
        annotation (Line(points={{20,20},{28,20},{28,21}}, color={191,0,0}));
      connect(thermalZoneTwoElements.extWall, thermalConductorWall.solid)
        annotation (Line(points={{43.8,12},{40,12},{40,1},{36,1}},
        color={191,0,0}));
      connect(thermalConductorWall.fluid, prescribedTemperature.port)
        annotation (Line(points={{26,1},{24,1},{24,0},{20,0}}, color={191,0,0}));
      connect(alphaWall.y, thermalConductorWall.Gc)
        annotation (Line(points={{30,-11.6},{30,-4},{31,-4}}, color={0,0,127}));
      connect(hConWin.y, thermalConductorWin.Gc)
        annotation (Line(points={{32,33.6},{32,26},{33,26}}, color={0,0,127}));
      connect(weaBus.TBlaSky, eqAirTemp.TBlaSky)
        annotation (Line(
        points={{-83,6},{-58,6},{-58,2},{-32,2},{-32,-4},{-26,-4}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
      connect(machinesConv.port, thermalZoneTwoElements.intGainsConv)
        annotation (
        Line(points={{68,-74},{82,-74},{96,-74},{96,20},{92,20}}, color={191,
        0,0}));
      connect(personsConv.port, thermalZoneTwoElements.intGainsConv)
        annotation (
        Line(points={{68,-52},{96,-52},{96,20},{92,20}}, color={191,0,0}));
      connect(corGDoublePane.solarRadWinTrans, thermalZoneTwoElements.solRad)
        annotation (Line(points={{27,64},{34,64},{40,64},{40,31},{43,31}}, color={0,
        0,127}));
      connect(port_a, thermalZoneTwoElements.intGainsConv)
        annotation (Line(points={{0,100},{96,100},{96,20},{92,20}}, color={191,0,0}));
      connect(thermalZoneTwoElements.TAir, TAir)
        annotation (Line(points={{93,32},{98,32},{98,0},{110,0}}, color={0,0,127}));
      annotation (experiment(
      StopTime=31536000,
      Interval=3600,
      __Dymola_Algorithm="Cvode"),
      __Dymola_experimentSetupOutput(equidistant=true,
      events=false));
    end Floor;

    model Storage
      "This is the simulation model of Storage within building B5a7229e737f4de77124f946d with traceable ID None"

      Buildings.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil[6](    each outSkyCon=true,
        each outGroCon=true,
        til={1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 0.0, 0.0},
        each lat = 0.88645272708792,
        azi = {3.141592653589793, 0.0, 1.5707963267948966, -1.5707963267948966, 0.0, 0.0})
        "Calculates diffuse solar radiation on titled surface for all directions"
        annotation (Placement(transformation(extent={{-68,20},{-48,40}})));
      Buildings.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil[6](    til={1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 0.0, 0.0},
        each lat =  0.88645272708792,
        azi={3.141592653589793, 0.0, 1.5707963267948966, -1.5707963267948966, 0.0, 0.0})
        "Calculates direct solar radiation on titled surface for all directions"
        annotation (Placement(transformation(extent={{-68,52},{-48,72}})));
      Buildings.ThermalZones.ReducedOrder.SolarGain.CorrectionGDoublePane corGDoublePane(n=6,  UWin=1.8936557576825381)
        "Correction factor for solar transmission"
        annotation (Placement(transformation(extent={{6,54},{26,74}})));
      Buildings.ThermalZones.ReducedOrder.RC.TwoElements
      thermalZoneTwoElements(
        redeclare package Medium = Modelica.Media.Air.DryAirNasa,
        VAir=1756.4486457139203,
        hConExt=2.1199708957531502,
        hConWin=2.6999999999999997,
        gWin=0.67,
        ratioWinConRad=0.029999999999999995,
        nExt=1,
        RExt={6.71068423433967e-05},
        CExt={145454283.5170059},
        hRad=5.0,
        AInt=1598.5526716569602,
        hConInt=2.2493871665465037,
        nInt=1,
        RInt={3.572154006489803e-05},
        CInt={218715357.65542313},
        RWin=0.005375033711019562,
        RExtRem=0.0036961625225768687,
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        extWallRC(thermCapExt(each der_T(fixed=true))),
        intWallRC(thermCapInt(each der_T(fixed=true))),
        nOrientations=6,
        AWin={28.15243221951325, 28.15243221951325, 5.1691220704163765, 5.1691220704163765, 0.0, 0.0},
        ATransparent={28.15243221951325, 28.15243221951325, 5.1691220704163765, 5.1691220704163765, 0.0, 0.0},
        AExt={84.45729665853976, 84.45729665853976, 15.50736621124913, 15.50736621124913, 138.06293352, 138.06293352})
        "Thermal zone"
        annotation (Placement(transformation(extent={{44,-2},{92,34}})));
      Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.VDI6007WithWindow eqAirTemp(
        n=6,
        wfGro=0.3240242537835098,
        wfWall={0.1735585434113848, 0.1735585434113848, 0.03186741700545756, 0.03186741700545756, 0.26512382538280566, 0.0},
        wfWin={0.42243575996725674, 0.42243575996725674, 0.07756424003274329, 0.07756424003274329, 0.0, 0.0},
        withLongwave=true,
        aExt=0.5,
        hConWallOut=20.0,
        hRad=5.0,
        hConWinOut=20.0,
        TGro=286.15) "Computes equivalent air temperature"
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
      Modelica.Blocks.Sources.Constant const[6](each k=0)
        "Sets sunblind signal to zero (open)"
        annotation (Placement(transformation(extent={{-20,14},{-14,20}})));
      Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
        annotation (Placement(
        transformation(extent={{-100,-10},{-66,22}}),iconTransformation(
        extent={{-70,-12},{-50,8}})));
      Modelica.Blocks.Sources.Constant alphaWall(k=25.000000000000004*476.0551927795778)
        "Outdoor coefficient of heat transfer for walls"
        annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={30,-16})));
      Modelica.Blocks.Sources.Constant hConWin(k=25.0*66.64310857985926)
        "Outdoor coefficient of heat transfer for windows"
        annotation (Placement(
        transformation(
        extent={{4,-4},{-4,4}},
        rotation=90,
        origin={32,38})));
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
              "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportRC/Resources/Data/B5a7229e737f4de77124f946d/InternalGains_Storage.mat"),
          columns={2,3,4})
          "Table with profiles for persons (radiative and convective) and machines (convective)"
          annotation (Placement(transformation(extent={{6,-60},{22,-44}})));
      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
        annotation (Placement(transformation(extent={{-10,90},{10,110}}), iconTransformation(extent={{-10,90},{10,110}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealOutput TAir(
        quantity="ThermodynamicTemperature", unit="K", displayUnit="degC")
        "Room air temperature"
        annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    equation
      connect(eqAirTemp.TEqAirWin, prescribedTemperature1.T)
        annotation (Line(
        points={{-3,-0.2},{0,-0.2},{0,20},{6.8,20}},   color={0,0,127}));
      connect(eqAirTemp.TEqAir, prescribedTemperature.T)
        annotation (Line(points={{-3,-4},{4,-4},{4,0},{6.8,0}},
        color={0,0,127}));
      connect(weaBus, weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,18},{-84,18},{-84,12},{-83,12},{-83,6}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
      connect(weaBus.TDryBul, eqAirTemp.TDryBul)
        annotation (Line(
        points={{-83,6},{-83,-2},{-38,-2},{-38,-10},{-26,-10}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
      connect(internalGains.y[1], personsRad.Q_flow)
        annotation (Line(points={{22.8,
        -52},{28,-52},{28,-32},{48,-32}}, color={0,0,127}));
      connect(internalGains.y[2], personsConv.Q_flow)
        annotation (Line(points={{22.8,-52},{36,-52},{48,-52}}, color={0,0,127}));
      connect(internalGains.y[3], machinesConv.Q_flow)
        annotation (Line(points={{22.8,
        -52},{28,-52},{28,-74},{48,-74}}, color={0,0,127}));
      connect(const.y, eqAirTemp.sunblind)
        annotation (Line(points={{-13.7,17},{-12,17},{-12,8},{-14,8},{-14,8}},
        color={0,0,127}));
      connect(HDifTil.HSkyDifTil, corGDoublePane.HSkyDifTil)
        annotation (Line(
        points={{-47,36},{-28,36},{-6,36},{-6,66},{4,66}}, color={0,0,127}));
      connect(HDirTil.H, corGDoublePane.HDirTil)
        annotation (Line(points={{-47,62},{-10,62},{-10,70},{4,70}},
        color={0,0,127}));
      connect(HDirTil.H,solRad. u1)
        annotation (Line(points={{-47,62},{-42,62},{-42,
        14},{-39,14}}, color={0,0,127}));
      connect(HDirTil.inc, corGDoublePane.inc)
        annotation (Line(points={{-47,58},{4,58},{4,58}}, color={0,0,127}));
      connect(HDifTil.H,solRad. u2)
        annotation (Line(points={{-47,30},{-44,30},{-44,
        8},{-39,8}}, color={0,0,127}));
      connect(HDifTil.HGroDifTil, corGDoublePane.HGroDifTil)
        annotation (Line(
        points={{-47,24},{-4,24},{-4,62},{4,62}}, color={0,0,127}));
      connect(solRad.y, eqAirTemp.HSol)
        annotation (Line(points={{-27.5,11},{-26,11},{-26,2},{-26,2}},
        color={0,0,127}));
        connect(weaBus, HDifTil[1].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[1].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[2].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[2].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[3].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[3].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[4].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[4].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[5].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[5].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[6].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[6].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
      connect(personsRad.port, thermalZoneTwoElements.intGainsRad)
        annotation (Line(
        points={{68,-32},{84,-32},{100,-32},{100,24},{92.2,24}},
        color={191,0,0}));
      connect(thermalConductorWin.solid, thermalZoneTwoElements.window)
        annotation (
         Line(points={{38,21},{40,21},{40,20},{43.8,20}}, color={191,0,0}));
      connect(prescribedTemperature1.port, thermalConductorWin.fluid)
        annotation (Line(points={{20,20},{28,20},{28,21}}, color={191,0,0}));
      connect(thermalZoneTwoElements.extWall, thermalConductorWall.solid)
        annotation (Line(points={{43.8,12},{40,12},{40,1},{36,1}},
        color={191,0,0}));
      connect(thermalConductorWall.fluid, prescribedTemperature.port)
        annotation (Line(points={{26,1},{24,1},{24,0},{20,0}}, color={191,0,0}));
      connect(alphaWall.y, thermalConductorWall.Gc)
        annotation (Line(points={{30,-11.6},{30,-4},{31,-4}}, color={0,0,127}));
      connect(hConWin.y, thermalConductorWin.Gc)
        annotation (Line(points={{32,33.6},{32,26},{33,26}}, color={0,0,127}));
      connect(weaBus.TBlaSky, eqAirTemp.TBlaSky)
        annotation (Line(
        points={{-83,6},{-58,6},{-58,2},{-32,2},{-32,-4},{-26,-4}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
      connect(machinesConv.port, thermalZoneTwoElements.intGainsConv)
        annotation (
        Line(points={{68,-74},{82,-74},{96,-74},{96,20},{92,20}}, color={191,
        0,0}));
      connect(personsConv.port, thermalZoneTwoElements.intGainsConv)
        annotation (
        Line(points={{68,-52},{96,-52},{96,20},{92,20}}, color={191,0,0}));
      connect(corGDoublePane.solarRadWinTrans, thermalZoneTwoElements.solRad)
        annotation (Line(points={{27,64},{34,64},{40,64},{40,31},{43,31}}, color={0,
        0,127}));
      connect(port_a, thermalZoneTwoElements.intGainsConv)
        annotation (Line(points={{0,100},{96,100},{96,20},{92,20}}, color={191,0,0}));
      connect(thermalZoneTwoElements.TAir, TAir)
        annotation (Line(points={{93,32},{98,32},{98,0},{110,0}}, color={0,0,127}));
      annotation (experiment(
      StopTime=31536000,
      Interval=3600,
      __Dymola_Algorithm="Cvode"),
      __Dymola_experimentSetupOutput(equidistant=true,
      events=false));
    end Storage;

    model Meeting
      "This is the simulation model of Meeting within building B5a7229e737f4de77124f946d with traceable ID None"

      Buildings.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil[6](    each outSkyCon=true,
        each outGroCon=true,
        til={1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 0.0, 0.0},
        each lat = 0.88645272708792,
        azi = {3.141592653589793, 0.0, 1.5707963267948966, -1.5707963267948966, 0.0, 0.0})
        "Calculates diffuse solar radiation on titled surface for all directions"
        annotation (Placement(transformation(extent={{-68,20},{-48,40}})));
      Buildings.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil[6](    til={1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 0.0, 0.0},
        each lat =  0.88645272708792,
        azi={3.141592653589793, 0.0, 1.5707963267948966, -1.5707963267948966, 0.0, 0.0})
        "Calculates direct solar radiation on titled surface for all directions"
        annotation (Placement(transformation(extent={{-68,52},{-48,72}})));
      Buildings.ThermalZones.ReducedOrder.SolarGain.CorrectionGDoublePane corGDoublePane(n=6,  UWin=1.8936557576825384)
        "Correction factor for solar transmission"
        annotation (Placement(transformation(extent={{6,54},{26,74}})));
      Buildings.ThermalZones.ReducedOrder.RC.TwoElements
      thermalZoneTwoElements(
        redeclare package Medium = Modelica.Media.Air.DryAirNasa,
        VAir=468.38630552371217,
        hConExt=2.1199708957531502,
        hConWin=2.7,
        gWin=0.6700000000000002,
        ratioWinConRad=0.030000000000000002,
        nExt=1,
        RExt={0.0002516506587877377},
        CExt={38787808.93786824},
        hRad=5.0,
        AInt=426.2807124418561,
        hConInt=2.2493871665465033,
        nInt=1,
        RInt={0.00013395577524336755},
        CInt={58324095.37477952},
        RWin=0.02015637641632336,
        RExtRem=0.013860609459663257,
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        extWallRC(thermCapExt(each der_T(fixed=true))),
        intWallRC(thermCapInt(each der_T(fixed=true))),
        nOrientations=6,
        AWin={7.5073152585368685, 7.5073152585368685, 1.3784325521110339, 1.3784325521110339, 0.0, 0.0},
        ATransparent={7.5073152585368685, 7.5073152585368685, 1.3784325521110339, 1.3784325521110339, 0.0, 0.0},
        AExt={22.521945775610607, 22.521945775610607, 4.135297656333102, 4.135297656333102, 36.816782272000005, 36.816782272000005})
        "Thermal zone"
        annotation (Placement(transformation(extent={{44,-2},{92,34}})));
      Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.VDI6007WithWindow eqAirTemp(
        n=6,
        wfGro=0.32402425378350974,
        wfWall={0.1735585434113848, 0.1735585434113848, 0.03186741700545756, 0.03186741700545756, 0.2651238253828056, 0.0},
        wfWin={0.42243575996725674, 0.42243575996725674, 0.07756424003274327, 0.07756424003274327, 0.0, 0.0},
        withLongwave=true,
        aExt=0.5,
        hConWallOut=20.000000000000004,
        hRad=5.0,
        hConWinOut=20.0,
        TGro=286.15) "Computes equivalent air temperature"
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
      Modelica.Blocks.Sources.Constant const[6](each k=0)
        "Sets sunblind signal to zero (open)"
        annotation (Placement(transformation(extent={{-20,14},{-14,20}})));
      Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
        annotation (Placement(
        transformation(extent={{-100,-10},{-66,22}}),iconTransformation(
        extent={{-70,-12},{-50,8}})));
      Modelica.Blocks.Sources.Constant alphaWall(k=25.000000000000004*126.94805140788742)
        "Outdoor coefficient of heat transfer for walls"
        annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={30,-16})));
      Modelica.Blocks.Sources.Constant hConWin(k=25.0*17.771495621295802)
        "Outdoor coefficient of heat transfer for windows"
        annotation (Placement(
        transformation(
        extent={{4,-4},{-4,4}},
        rotation=90,
        origin={32,38})));
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
              "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportRC/Resources/Data/B5a7229e737f4de77124f946d/InternalGains_Meeting.mat"),
          columns={2,3,4})
          "Table with profiles for persons (radiative and convective) and machines (convective)"
          annotation (Placement(transformation(extent={{6,-60},{22,-44}})));
      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
        annotation (Placement(transformation(extent={{-10,90},{10,110}}), iconTransformation(extent={{-10,90},{10,110}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealOutput TAir(
        quantity="ThermodynamicTemperature", unit="K", displayUnit="degC")
        "Room air temperature"
        annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    equation
      connect(eqAirTemp.TEqAirWin, prescribedTemperature1.T)
        annotation (Line(
        points={{-3,-0.2},{0,-0.2},{0,20},{6.8,20}},   color={0,0,127}));
      connect(eqAirTemp.TEqAir, prescribedTemperature.T)
        annotation (Line(points={{-3,-4},{4,-4},{4,0},{6.8,0}},
        color={0,0,127}));
      connect(weaBus, weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,18},{-84,18},{-84,12},{-83,12},{-83,6}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
      connect(weaBus.TDryBul, eqAirTemp.TDryBul)
        annotation (Line(
        points={{-83,6},{-83,-2},{-38,-2},{-38,-10},{-26,-10}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
      connect(internalGains.y[1], personsRad.Q_flow)
        annotation (Line(points={{22.8,
        -52},{28,-52},{28,-32},{48,-32}}, color={0,0,127}));
      connect(internalGains.y[2], personsConv.Q_flow)
        annotation (Line(points={{22.8,-52},{36,-52},{48,-52}}, color={0,0,127}));
      connect(internalGains.y[3], machinesConv.Q_flow)
        annotation (Line(points={{22.8,
        -52},{28,-52},{28,-74},{48,-74}}, color={0,0,127}));
      connect(const.y, eqAirTemp.sunblind)
        annotation (Line(points={{-13.7,17},{-12,17},{-12,8},{-14,8},{-14,8}},
        color={0,0,127}));
      connect(HDifTil.HSkyDifTil, corGDoublePane.HSkyDifTil)
        annotation (Line(
        points={{-47,36},{-28,36},{-6,36},{-6,66},{4,66}}, color={0,0,127}));
      connect(HDirTil.H, corGDoublePane.HDirTil)
        annotation (Line(points={{-47,62},{-10,62},{-10,70},{4,70}},
        color={0,0,127}));
      connect(HDirTil.H,solRad. u1)
        annotation (Line(points={{-47,62},{-42,62},{-42,
        14},{-39,14}}, color={0,0,127}));
      connect(HDirTil.inc, corGDoublePane.inc)
        annotation (Line(points={{-47,58},{4,58},{4,58}}, color={0,0,127}));
      connect(HDifTil.H,solRad. u2)
        annotation (Line(points={{-47,30},{-44,30},{-44,
        8},{-39,8}}, color={0,0,127}));
      connect(HDifTil.HGroDifTil, corGDoublePane.HGroDifTil)
        annotation (Line(
        points={{-47,24},{-4,24},{-4,62},{4,62}}, color={0,0,127}));
      connect(solRad.y, eqAirTemp.HSol)
        annotation (Line(points={{-27.5,11},{-26,11},{-26,2},{-26,2}},
        color={0,0,127}));
        connect(weaBus, HDifTil[1].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[1].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[2].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[2].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[3].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[3].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[4].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[4].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[5].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[5].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[6].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[6].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
      connect(personsRad.port, thermalZoneTwoElements.intGainsRad)
        annotation (Line(
        points={{68,-32},{84,-32},{100,-32},{100,24},{92.2,24}},
        color={191,0,0}));
      connect(thermalConductorWin.solid, thermalZoneTwoElements.window)
        annotation (
         Line(points={{38,21},{40,21},{40,20},{43.8,20}}, color={191,0,0}));
      connect(prescribedTemperature1.port, thermalConductorWin.fluid)
        annotation (Line(points={{20,20},{28,20},{28,21}}, color={191,0,0}));
      connect(thermalZoneTwoElements.extWall, thermalConductorWall.solid)
        annotation (Line(points={{43.8,12},{40,12},{40,1},{36,1}},
        color={191,0,0}));
      connect(thermalConductorWall.fluid, prescribedTemperature.port)
        annotation (Line(points={{26,1},{24,1},{24,0},{20,0}}, color={191,0,0}));
      connect(alphaWall.y, thermalConductorWall.Gc)
        annotation (Line(points={{30,-11.6},{30,-4},{31,-4}}, color={0,0,127}));
      connect(hConWin.y, thermalConductorWin.Gc)
        annotation (Line(points={{32,33.6},{32,26},{33,26}}, color={0,0,127}));
      connect(weaBus.TBlaSky, eqAirTemp.TBlaSky)
        annotation (Line(
        points={{-83,6},{-58,6},{-58,2},{-32,2},{-32,-4},{-26,-4}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
      connect(machinesConv.port, thermalZoneTwoElements.intGainsConv)
        annotation (
        Line(points={{68,-74},{82,-74},{96,-74},{96,20},{92,20}}, color={191,
        0,0}));
      connect(personsConv.port, thermalZoneTwoElements.intGainsConv)
        annotation (
        Line(points={{68,-52},{96,-52},{96,20},{92,20}}, color={191,0,0}));
      connect(corGDoublePane.solarRadWinTrans, thermalZoneTwoElements.solRad)
        annotation (Line(points={{27,64},{34,64},{40,64},{40,31},{43,31}}, color={0,
        0,127}));
      connect(port_a, thermalZoneTwoElements.intGainsConv)
        annotation (Line(points={{0,100},{96,100},{96,20},{92,20}}, color={191,0,0}));
      connect(thermalZoneTwoElements.TAir, TAir)
        annotation (Line(points={{93,32},{98,32},{98,0},{110,0}}, color={0,0,127}));
      annotation (experiment(
      StopTime=31536000,
      Interval=3600,
      __Dymola_Algorithm="Cvode"),
      __Dymola_experimentSetupOutput(equidistant=true,
      events=false));
    end Meeting;

    model Restroom
      "This is the simulation model of Restroom within building B5a7229e737f4de77124f946d with traceable ID None"

      Buildings.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil[6](    each outSkyCon=true,
        each outGroCon=true,
        til={1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 0.0, 0.0},
        each lat = 0.88645272708792,
        azi = {3.141592653589793, 0.0, 1.5707963267948966, -1.5707963267948966, 0.0, 0.0})
        "Calculates diffuse solar radiation on titled surface for all directions"
        annotation (Placement(transformation(extent={{-68,20},{-48,40}})));
      Buildings.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil[6](    til={1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 0.0, 0.0},
        each lat =  0.88645272708792,
        azi={3.141592653589793, 0.0, 1.5707963267948966, -1.5707963267948966, 0.0, 0.0})
        "Calculates direct solar radiation on titled surface for all directions"
        annotation (Placement(transformation(extent={{-68,52},{-48,72}})));
      Buildings.ThermalZones.ReducedOrder.SolarGain.CorrectionGDoublePane corGDoublePane(n=6,  UWin=1.8936557576825384)
        "Correction factor for solar transmission"
        annotation (Placement(transformation(extent={{6,54},{26,74}})));
      Buildings.ThermalZones.ReducedOrder.RC.TwoElements
      thermalZoneTwoElements(
        redeclare package Medium = Modelica.Media.Air.DryAirNasa,
        VAir=468.38630552371217,
        hConExt=2.1199708957531502,
        hConWin=2.7,
        gWin=0.6700000000000002,
        ratioWinConRad=0.030000000000000002,
        nExt=1,
        RExt={0.0002516506587877377},
        CExt={38787808.93786824},
        hRad=5.0,
        AInt=582.4094809497601,
        hConInt=2.370184696569921,
        nInt=1,
        RInt={0.00011467531727540473},
        CInt={67339647.84555541},
        RWin=0.02015637641632336,
        RExtRem=0.013860609459663257,
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        extWallRC(thermCapExt(each der_T(fixed=true))),
        intWallRC(thermCapInt(each der_T(fixed=true))),
        nOrientations=6,
        AWin={7.5073152585368685, 7.5073152585368685, 1.3784325521110339, 1.3784325521110339, 0.0, 0.0},
        ATransparent={7.5073152585368685, 7.5073152585368685, 1.3784325521110339, 1.3784325521110339, 0.0, 0.0},
        AExt={22.521945775610607, 22.521945775610607, 4.135297656333102, 4.135297656333102, 36.816782272000005, 36.816782272000005})
        "Thermal zone"
        annotation (Placement(transformation(extent={{44,-2},{92,34}})));
      Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.VDI6007WithWindow eqAirTemp(
        n=6,
        wfGro=0.32402425378350974,
        wfWall={0.1735585434113848, 0.1735585434113848, 0.03186741700545756, 0.03186741700545756, 0.2651238253828056, 0.0},
        wfWin={0.42243575996725674, 0.42243575996725674, 0.07756424003274327, 0.07756424003274327, 0.0, 0.0},
        withLongwave=true,
        aExt=0.5,
        hConWallOut=20.000000000000004,
        hRad=5.0,
        hConWinOut=20.0,
        TGro=286.15) "Computes equivalent air temperature"
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
      Modelica.Blocks.Sources.Constant const[6](each k=0)
        "Sets sunblind signal to zero (open)"
        annotation (Placement(transformation(extent={{-20,14},{-14,20}})));
      Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
        annotation (Placement(
        transformation(extent={{-100,-10},{-66,22}}),iconTransformation(
        extent={{-70,-12},{-50,8}})));
      Modelica.Blocks.Sources.Constant alphaWall(k=25.000000000000004*126.94805140788742)
        "Outdoor coefficient of heat transfer for walls"
        annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={30,-16})));
      Modelica.Blocks.Sources.Constant hConWin(k=25.0*17.771495621295802)
        "Outdoor coefficient of heat transfer for windows"
        annotation (Placement(
        transformation(
        extent={{4,-4},{-4,4}},
        rotation=90,
        origin={32,38})));
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
              "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportRC/Resources/Data/B5a7229e737f4de77124f946d/InternalGains_Restroom.mat"),
          columns={2,3,4})
          "Table with profiles for persons (radiative and convective) and machines (convective)"
          annotation (Placement(transformation(extent={{6,-60},{22,-44}})));
      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
        annotation (Placement(transformation(extent={{-10,90},{10,110}}), iconTransformation(extent={{-10,90},{10,110}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealOutput TAir(
        quantity="ThermodynamicTemperature", unit="K", displayUnit="degC")
        "Room air temperature"
        annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    equation
      connect(eqAirTemp.TEqAirWin, prescribedTemperature1.T)
        annotation (Line(
        points={{-3,-0.2},{0,-0.2},{0,20},{6.8,20}},   color={0,0,127}));
      connect(eqAirTemp.TEqAir, prescribedTemperature.T)
        annotation (Line(points={{-3,-4},{4,-4},{4,0},{6.8,0}},
        color={0,0,127}));
      connect(weaBus, weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,18},{-84,18},{-84,12},{-83,12},{-83,6}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
      connect(weaBus.TDryBul, eqAirTemp.TDryBul)
        annotation (Line(
        points={{-83,6},{-83,-2},{-38,-2},{-38,-10},{-26,-10}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
      connect(internalGains.y[1], personsRad.Q_flow)
        annotation (Line(points={{22.8,
        -52},{28,-52},{28,-32},{48,-32}}, color={0,0,127}));
      connect(internalGains.y[2], personsConv.Q_flow)
        annotation (Line(points={{22.8,-52},{36,-52},{48,-52}}, color={0,0,127}));
      connect(internalGains.y[3], machinesConv.Q_flow)
        annotation (Line(points={{22.8,
        -52},{28,-52},{28,-74},{48,-74}}, color={0,0,127}));
      connect(const.y, eqAirTemp.sunblind)
        annotation (Line(points={{-13.7,17},{-12,17},{-12,8},{-14,8},{-14,8}},
        color={0,0,127}));
      connect(HDifTil.HSkyDifTil, corGDoublePane.HSkyDifTil)
        annotation (Line(
        points={{-47,36},{-28,36},{-6,36},{-6,66},{4,66}}, color={0,0,127}));
      connect(HDirTil.H, corGDoublePane.HDirTil)
        annotation (Line(points={{-47,62},{-10,62},{-10,70},{4,70}},
        color={0,0,127}));
      connect(HDirTil.H,solRad. u1)
        annotation (Line(points={{-47,62},{-42,62},{-42,
        14},{-39,14}}, color={0,0,127}));
      connect(HDirTil.inc, corGDoublePane.inc)
        annotation (Line(points={{-47,58},{4,58},{4,58}}, color={0,0,127}));
      connect(HDifTil.H,solRad. u2)
        annotation (Line(points={{-47,30},{-44,30},{-44,
        8},{-39,8}}, color={0,0,127}));
      connect(HDifTil.HGroDifTil, corGDoublePane.HGroDifTil)
        annotation (Line(
        points={{-47,24},{-4,24},{-4,62},{4,62}}, color={0,0,127}));
      connect(solRad.y, eqAirTemp.HSol)
        annotation (Line(points={{-27.5,11},{-26,11},{-26,2},{-26,2}},
        color={0,0,127}));
        connect(weaBus, HDifTil[1].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[1].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[2].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[2].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[3].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[3].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[4].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[4].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[5].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[5].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[6].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[6].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
      connect(personsRad.port, thermalZoneTwoElements.intGainsRad)
        annotation (Line(
        points={{68,-32},{84,-32},{100,-32},{100,24},{92.2,24}},
        color={191,0,0}));
      connect(thermalConductorWin.solid, thermalZoneTwoElements.window)
        annotation (
         Line(points={{38,21},{40,21},{40,20},{43.8,20}}, color={191,0,0}));
      connect(prescribedTemperature1.port, thermalConductorWin.fluid)
        annotation (Line(points={{20,20},{28,20},{28,21}}, color={191,0,0}));
      connect(thermalZoneTwoElements.extWall, thermalConductorWall.solid)
        annotation (Line(points={{43.8,12},{40,12},{40,1},{36,1}},
        color={191,0,0}));
      connect(thermalConductorWall.fluid, prescribedTemperature.port)
        annotation (Line(points={{26,1},{24,1},{24,0},{20,0}}, color={191,0,0}));
      connect(alphaWall.y, thermalConductorWall.Gc)
        annotation (Line(points={{30,-11.6},{30,-4},{31,-4}}, color={0,0,127}));
      connect(hConWin.y, thermalConductorWin.Gc)
        annotation (Line(points={{32,33.6},{32,26},{33,26}}, color={0,0,127}));
      connect(weaBus.TBlaSky, eqAirTemp.TBlaSky)
        annotation (Line(
        points={{-83,6},{-58,6},{-58,2},{-32,2},{-32,-4},{-26,-4}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
      connect(machinesConv.port, thermalZoneTwoElements.intGainsConv)
        annotation (
        Line(points={{68,-74},{82,-74},{96,-74},{96,20},{92,20}}, color={191,
        0,0}));
      connect(personsConv.port, thermalZoneTwoElements.intGainsConv)
        annotation (
        Line(points={{68,-52},{96,-52},{96,20},{92,20}}, color={191,0,0}));
      connect(corGDoublePane.solarRadWinTrans, thermalZoneTwoElements.solRad)
        annotation (Line(points={{27,64},{34,64},{40,64},{40,31},{43,31}}, color={0,
        0,127}));
      connect(port_a, thermalZoneTwoElements.intGainsConv)
        annotation (Line(points={{0,100},{96,100},{96,20},{92,20}}, color={191,0,0}));
      connect(thermalZoneTwoElements.TAir, TAir)
        annotation (Line(points={{93,32},{98,32},{98,0},{110,0}}, color={0,0,127}));
      annotation (experiment(
      StopTime=31536000,
      Interval=3600,
      __Dymola_Algorithm="Cvode"),
      __Dymola_experimentSetupOutput(equidistant=true,
      events=false));
    end Restroom;

    model ICT
      "This is the simulation model of ICT within building B5a7229e737f4de77124f946d with traceable ID None"

      Buildings.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil[6](    each outSkyCon=true,
        each outGroCon=true,
        til={1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 0.0, 0.0},
        each lat = 0.88645272708792,
        azi = {3.141592653589793, 0.0, 1.5707963267948966, -1.5707963267948966, 0.0, 0.0})
        "Calculates diffuse solar radiation on titled surface for all directions"
        annotation (Placement(transformation(extent={{-68,20},{-48,40}})));
      Buildings.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil[6](    til={1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 1.5707963267948966, 0.0, 0.0},
        each lat =  0.88645272708792,
        azi={3.141592653589793, 0.0, 1.5707963267948966, -1.5707963267948966, 0.0, 0.0})
        "Calculates direct solar radiation on titled surface for all directions"
        annotation (Placement(transformation(extent={{-68,52},{-48,72}})));
      Buildings.ThermalZones.ReducedOrder.SolarGain.CorrectionGDoublePane corGDoublePane(n=6,  UWin=1.8936557576825384)
        "Correction factor for solar transmission"
        annotation (Placement(transformation(extent={{6,54},{26,74}})));
      Buildings.ThermalZones.ReducedOrder.RC.TwoElements
      thermalZoneTwoElements(
        redeclare package Medium = Modelica.Media.Air.DryAirNasa,
        VAir=234.19315276185608,
        hConExt=2.1199708957531502,
        hConWin=2.7,
        gWin=0.6700000000000002,
        ratioWinConRad=0.030000000000000002,
        nExt=1,
        RExt={0.0005033013175754754},
        CExt={19393904.46893412},
        hRad=5.0,
        AInt=213.14035622092806,
        hConInt=2.2493871665465033,
        nInt=1,
        RInt={0.0002679115504867351},
        CInt={29162047.68738976},
        RWin=0.04031275283264672,
        RExtRem=0.027721218919326513,
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        extWallRC(thermCapExt(each der_T(fixed=true))),
        intWallRC(thermCapInt(each der_T(fixed=true))),
        nOrientations=6,
        AWin={3.7536576292684343, 3.7536576292684343, 0.6892162760555169, 0.6892162760555169, 0.0, 0.0},
        ATransparent={3.7536576292684343, 3.7536576292684343, 0.6892162760555169, 0.6892162760555169, 0.0, 0.0},
        AExt={11.260972887805304, 11.260972887805304, 2.067648828166551, 2.067648828166551, 18.408391136000002, 18.408391136000002})
        "Thermal zone"
        annotation (Placement(transformation(extent={{44,-2},{92,34}})));
      Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.VDI6007WithWindow eqAirTemp(
        n=6,
        wfGro=0.32402425378350974,
        wfWall={0.1735585434113848, 0.1735585434113848, 0.03186741700545756, 0.03186741700545756, 0.2651238253828056, 0.0},
        wfWin={0.42243575996725674, 0.42243575996725674, 0.07756424003274327, 0.07756424003274327, 0.0, 0.0},
        withLongwave=true,
        aExt=0.5,
        hConWallOut=20.000000000000004,
        hRad=5.0,
        hConWinOut=20.0,
        TGro=286.15) "Computes equivalent air temperature"
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
      Modelica.Blocks.Sources.Constant const[6](each k=0)
        "Sets sunblind signal to zero (open)"
        annotation (Placement(transformation(extent={{-20,14},{-14,20}})));
      Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
        annotation (Placement(
        transformation(extent={{-100,-10},{-66,22}}),iconTransformation(
        extent={{-70,-12},{-50,8}})));
      Modelica.Blocks.Sources.Constant alphaWall(k=25.000000000000004*63.47402570394371)
        "Outdoor coefficient of heat transfer for walls"
        annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={30,-16})));
      Modelica.Blocks.Sources.Constant hConWin(k=25.0*8.885747810647901)
        "Outdoor coefficient of heat transfer for windows"
        annotation (Placement(
        transformation(
        extent={{4,-4},{-4,4}},
        rotation=90,
        origin={32,38})));
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
              "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportRC/Resources/Data/B5a7229e737f4de77124f946d/InternalGains_ICT.mat"),
          columns={2,3,4})
          "Table with profiles for persons (radiative and convective) and machines (convective)"
          annotation (Placement(transformation(extent={{6,-60},{22,-44}})));
      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
        annotation (Placement(transformation(extent={{-10,90},{10,110}}), iconTransformation(extent={{-10,90},{10,110}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealOutput TAir(
        quantity="ThermodynamicTemperature", unit="K", displayUnit="degC")
        "Room air temperature"
        annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    equation
      connect(eqAirTemp.TEqAirWin, prescribedTemperature1.T)
        annotation (Line(
        points={{-3,-0.2},{0,-0.2},{0,20},{6.8,20}},   color={0,0,127}));
      connect(eqAirTemp.TEqAir, prescribedTemperature.T)
        annotation (Line(points={{-3,-4},{4,-4},{4,0},{6.8,0}},
        color={0,0,127}));
      connect(weaBus, weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,18},{-84,18},{-84,12},{-83,12},{-83,6}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
      connect(weaBus.TDryBul, eqAirTemp.TDryBul)
        annotation (Line(
        points={{-83,6},{-83,-2},{-38,-2},{-38,-10},{-26,-10}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
      connect(internalGains.y[1], personsRad.Q_flow)
        annotation (Line(points={{22.8,
        -52},{28,-52},{28,-32},{48,-32}}, color={0,0,127}));
      connect(internalGains.y[2], personsConv.Q_flow)
        annotation (Line(points={{22.8,-52},{36,-52},{48,-52}}, color={0,0,127}));
      connect(internalGains.y[3], machinesConv.Q_flow)
        annotation (Line(points={{22.8,
        -52},{28,-52},{28,-74},{48,-74}}, color={0,0,127}));
      connect(const.y, eqAirTemp.sunblind)
        annotation (Line(points={{-13.7,17},{-12,17},{-12,8},{-14,8},{-14,8}},
        color={0,0,127}));
      connect(HDifTil.HSkyDifTil, corGDoublePane.HSkyDifTil)
        annotation (Line(
        points={{-47,36},{-28,36},{-6,36},{-6,66},{4,66}}, color={0,0,127}));
      connect(HDirTil.H, corGDoublePane.HDirTil)
        annotation (Line(points={{-47,62},{-10,62},{-10,70},{4,70}},
        color={0,0,127}));
      connect(HDirTil.H,solRad. u1)
        annotation (Line(points={{-47,62},{-42,62},{-42,
        14},{-39,14}}, color={0,0,127}));
      connect(HDirTil.inc, corGDoublePane.inc)
        annotation (Line(points={{-47,58},{4,58},{4,58}}, color={0,0,127}));
      connect(HDifTil.H,solRad. u2)
        annotation (Line(points={{-47,30},{-44,30},{-44,
        8},{-39,8}}, color={0,0,127}));
      connect(HDifTil.HGroDifTil, corGDoublePane.HGroDifTil)
        annotation (Line(
        points={{-47,24},{-4,24},{-4,62},{4,62}}, color={0,0,127}));
      connect(solRad.y, eqAirTemp.HSol)
        annotation (Line(points={{-27.5,11},{-26,11},{-26,2},{-26,2}},
        color={0,0,127}));
        connect(weaBus, HDifTil[1].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[1].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[2].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[2].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[3].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[3].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[4].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[4].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[5].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[5].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDifTil[6].weaBus)
        annotation (Line(
        points={{-78,62},{-74,62},{-74,30},{-68,30}},
        color={255,204,51},
        thickness=0.5));
        connect(weaBus, HDirTil[6].weaBus)
        annotation (Line(
        points={{-78,62},{-73,62},{-68,62}},
        color={255,204,51},
        thickness=0.5));
      connect(personsRad.port, thermalZoneTwoElements.intGainsRad)
        annotation (Line(
        points={{68,-32},{84,-32},{100,-32},{100,24},{92.2,24}},
        color={191,0,0}));
      connect(thermalConductorWin.solid, thermalZoneTwoElements.window)
        annotation (
         Line(points={{38,21},{40,21},{40,20},{43.8,20}}, color={191,0,0}));
      connect(prescribedTemperature1.port, thermalConductorWin.fluid)
        annotation (Line(points={{20,20},{28,20},{28,21}}, color={191,0,0}));
      connect(thermalZoneTwoElements.extWall, thermalConductorWall.solid)
        annotation (Line(points={{43.8,12},{40,12},{40,1},{36,1}},
        color={191,0,0}));
      connect(thermalConductorWall.fluid, prescribedTemperature.port)
        annotation (Line(points={{26,1},{24,1},{24,0},{20,0}}, color={191,0,0}));
      connect(alphaWall.y, thermalConductorWall.Gc)
        annotation (Line(points={{30,-11.6},{30,-4},{31,-4}}, color={0,0,127}));
      connect(hConWin.y, thermalConductorWin.Gc)
        annotation (Line(points={{32,33.6},{32,26},{33,26}}, color={0,0,127}));
      connect(weaBus.TBlaSky, eqAirTemp.TBlaSky)
        annotation (Line(
        points={{-83,6},{-58,6},{-58,2},{-32,2},{-32,-4},{-26,-4}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
      connect(machinesConv.port, thermalZoneTwoElements.intGainsConv)
        annotation (
        Line(points={{68,-74},{82,-74},{96,-74},{96,20},{92,20}}, color={191,
        0,0}));
      connect(personsConv.port, thermalZoneTwoElements.intGainsConv)
        annotation (
        Line(points={{68,-52},{96,-52},{96,20},{92,20}}, color={191,0,0}));
      connect(corGDoublePane.solarRadWinTrans, thermalZoneTwoElements.solRad)
        annotation (Line(points={{27,64},{34,64},{40,64},{40,31},{43,31}}, color={0,
        0,127}));
      connect(port_a, thermalZoneTwoElements.intGainsConv)
        annotation (Line(points={{0,100},{96,100},{96,20},{92,20}}, color={191,0,0}));
      connect(thermalZoneTwoElements.TAir, TAir)
        annotation (Line(points={{93,32},{98,32},{98,0},{110,0}}, color={0,0,127}));
      annotation (experiment(
      StopTime=31536000,
      Interval=3600,
      __Dymola_Algorithm="Cvode"),
      __Dymola_experimentSetupOutput(equidistant=true,
      events=false));
    end ICT;
  end B5a7229e737f4de77124f946d;
end GeojsonExportRC;
