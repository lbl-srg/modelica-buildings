within Buildings.Applications.DHC.Loads.Validation;
package BaseClasses "BaseClasses - Package with base classes for Examples"
  extends Modelica.Icons.BasesPackage;

  model BuildingTimeSeries
    "Building model where heating and cooling loads are provided by time series and time functions"
    import Buildings;
    extends Buildings.Applications.DHC.Loads.BaseClasses.PartialBuilding(
      have_fan=false,
      have_pum=false,
      have_eleHea=false,
      have_eleCoo=false,
      have_weaBus=false,
      nPorts1=2);
    Modelica.Blocks.Sources.CombiTimeTable loa(
      tableOnFile=true,
      columns={2,3},
      tableName="csv",
      fileName=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Applications/DHC/Loads/Examples/Resources/Loads.csv"),
      smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments) "Reader for test.csv"
      annotation (Placement(transformation(extent={{0,-10},{20,10}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTSet(k=20)
      "Minimum temperature setpoint"
      annotation (Placement(transformation(extent={{-298,250},{-278,270}})));
    Buildings.Controls.OBC.UnitConversions.From_degC from_degC1
      annotation (Placement(transformation(extent={{-258,250},{-238,270}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTSet(k=24)
      "Minimum temperature setpoint"
      annotation (Placement(transformation(extent={{-298,210},{-278,230}})));
    Buildings.Controls.OBC.UnitConversions.From_degC from_degC2
      annotation (Placement(transformation(extent={{-258,210},{-238,230}})));
    Buildings.Applications.DHC.Loads.Validation.BaseClasses.Terminal4PipesHeatReq
      terUni(
      QHea_flow_nominal=500,
      QCoo_flow_nominal=2000,
      T_a1Hea_nominal=313.15,
      T_a1Coo_nominal=280.15,
      T_b1Hea_nominal=308.15,
      T_b1Coo_nominal=285.15,
      T_a2Hea_nominal=293.15,
      T_a2Coo_nominal=297.15) "Terminal unit"
      annotation (Placement(transformation(extent={{80,-24},{100,-4}})));
    Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloHea(
        m_flow_nominal=terUni.m1Hea_flow_nominal,
        dp_nominal=100000)
      "Heating water distribution system"
      annotation (Placement(transformation(extent={{120,-80},{140,-60}})));
    Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloCoo(
      m_flow_nominal=terUni.m1Coo_flow_nominal,
      disTyp=Buildings.Applications.DHC.Loads.Types.DistributionType.ChilledWater,
      dp_nominal=100000) "Chilled water distribution system" annotation (
        Placement(transformation(extent={{120,-120},{140,-100}})));

  equation
    connect(minTSet.y,from_degC1. u)
      annotation (Line(points={{-276,260},{-260,260}}, color={0,0,127}));
    connect(maxTSet.y,from_degC2. u)
      annotation (Line(points={{-276,220},{-260,220}}, color={0,0,127}));
    connect(ports_a1[1], disFloHea.port_a) annotation (Line(points={{-300,-20},{-280,
            -20},{-280,-70},{120,-70}}, color={0,127,255}));
    connect(disFloHea.port_b, ports_b1[1]) annotation (Line(points={{140,-70},{280,
            -70},{280,-20},{300,-20}}, color={0,127,255}));
    connect(ports_a1[2], disFloCoo.port_a) annotation (Line(points={{-300,20},{-280,
            20},{-280,-110},{120,-110}}, color={0,127,255}));
    connect(disFloCoo.port_b, ports_b1[2]) annotation (Line(points={{140,-110},{280,
            -110},{280,20},{300,20}}, color={0,127,255}));
    connect(from_degC1.y, terUni.TSetHea) annotation (Line(points={{-236,260},{60,
            260},{60,-7.33333},{79.1667,-7.33333}}, color={0,0,127}));
    connect(from_degC2.y, terUni.TSetCoo) annotation (Line(points={{-236,220},{60,
            220},{60,-10.6667},{79.1667,-10.6667}}, color={0,0,127}));
    connect(terUni.port_b1Hea, disFloHea.ports_a1[1]) annotation (Line(points={{100,
            -23.1667},{100,-23.5833},{140,-23.5833},{140,-64}},     color={0,127,
            255}));
    connect(terUni.port_b1Coo, disFloCoo.ports_a1[1]) annotation (Line(points={{100,
            -20.6667},{160,-20.6667},{160,-104},{140,-104}},     color={0,127,255}));
    connect(disFloCoo.ports_b1[1], terUni.port_a1Coo) annotation (Line(points={{120,
            -104},{40,-104},{40,-20.6667},{80,-20.6667}},     color={0,127,255}));
    connect(disFloHea.ports_b1[1], terUni.port_a1Hea) annotation (Line(points={{120,-64},
            {60,-64},{60,-23.1667},{80,-23.1667}},          color={0,127,255}));
    connect(loa.y[1], terUni.QReqHea_flow) annotation (Line(points={{21,0},{50,0},
            {50,-14},{79.1667,-14}}, color={0,0,127}));
    connect(loa.y[2], terUni.QReqCoo_flow) annotation (Line(points={{21,0},{50,0},
            {50,-17.3333},{79.1667,-17.3333}}, color={0,0,127}));
    connect(terUni.m1ReqHea_flow, disFloHea.m1Req_flow[1]) annotation (Line(
          points={{100.833,-16.5},{100.833,-46},{100,-46},{100,-76},{119,-76},{
            119,-74}}, color={0,0,127}));
    connect(terUni.m1ReqCoo_flow, disFloCoo.m1Req_flow[1]) annotation (Line(
          points={{100.833,-18.1667},{100.833,-115.083},{119,-115.083},{119,-114}},
          color={0,0,127}));
    connect(terUni.QActHea_flow, QHea_flow) annotation (Line(points={{100.833,
            -6.5},{100.833,-6},{240,-6},{240,280},{320,280}},
                                                        color={0,0,127}));
    connect(terUni.QActCoo_flow, QCoo_flow) annotation (Line(points={{100.833,
            -8.16667},{100,-8.16667},{100,-8},{260,-8},{260,220},{320,220}},
                                                                   color={0,0,127}));
    annotation (
    Documentation(info="<html>
  <p>
  This is a simplified building model with:
  </p>
  <ul>
  <li> one heating load which temperature is computed with
  <a href=\"modelica://Buildings.DistrictEnergySystem.Loads.BaseClasses.FirstOrderODE\">
  Buildings.DistrictEnergySystem.Loads.BaseClasses.FirstOrderODE</a>
  and the required heating heat flow rate is provided by a time series;
  </li>
  <li>
  one additional heating load which temperature is prescribed with a time function
  and the required heating heat flow rate is also provided by a time function;
  </li>
  <li>
  one cooling load which temperature is computed with
  <a href=\"modelica://Buildings.DistrictEnergySystem.Loads.BaseClasses.FirstOrderODE\">
  Buildings.DistrictEnergySystem.Loads.BaseClasses.FirstOrderODE</a>
  and the required cooling heat flow rate is provided by a time series.
  </li>
  </ul>
  <p>
  </p>
  </html>"),
    Diagram(coordinateSystem(extent={{-300,-300},{300,300}})), Icon(
          coordinateSystem(extent={{-100,-100},{100,100}})));
  end BuildingTimeSeries;

  model BuildingRCZ1 "RC building model (1 zone)"
    extends Buildings.Applications.DHC.Loads.BaseClasses.PartialBuilding(
      have_pum=false,
      have_eleHea=false,
      have_eleCoo=false,
      have_weaBus=true,
      nPorts1=2);
    package Medium2 = Buildings.Media.Air
      "Load side medium";
    parameter Integer nZon = 1
      "Number of thermal zones";
    Buildings.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil[2](
      each outSkyCon=true,
      each outGroCon=true,
      each til=1.5707963267949,
      each lat=0.87266462599716,
      azi={3.1415926535898,4.7123889803847})
      "Calculates diffuse solar radiation on titled surface for both directions"
      annotation (Placement(transformation(extent={{-68,20},{-48,40}})));
    Buildings.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil[2](
      each til=1.5707963267949,
      each lat=0.87266462599716,
      azi={3.1415926535898,4.7123889803847})
      "Calculates direct solar radiation on titled surface for both directions"
      annotation (Placement(transformation(extent={{-68,52},{-48,72}})));
    Buildings.ThermalZones.ReducedOrder.SolarGain.CorrectionGDoublePane corGDouPan(n=2, UWin=2.1)
      "Correction factor for solar transmission"
      annotation (Placement(transformation(extent={{6,54},{26,74}})));
    Buildings.ThermalZones.ReducedOrder.RC.OneElement thermalZoneOneElement(
      VAir=52.5,
      hRad=4.999999999999999,
      hConWin=2.7000000000000006,
      gWin=1,
      ratioWinConRad=0.09,
      hConExt=2.0490178828959134,
      nExt=1,
      RExt={0.00331421908725},
      CExt={5259932.23},
      RWin=0.01642857143,
      RExtRem=0.1265217391,
      nOrientations=2,
      AWin={7,7},
      ATransparent={7,7},
      AExt={3.5,8},
      redeclare package Medium = Medium2,
      extWallRC(thermCapExt(each der_T(fixed=true))),
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      T_start=295.15,
      nPorts=2)       "Thermal zone"
      annotation (Placement(transformation(extent={{44,-10},{92,26}})));
    Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.VDI6007WithWindow
      eqAirTemp(
      n=2,
      wfGro=0,
      wfWall={0.3043478260869566,0.6956521739130435},
      wfWin={0.5,0.5},
      withLongwave=true,
      aExt=0.7,
      hConWallOut=20.0,
      hRad=5.0,
      hConWinOut=20.0,
      TGro=285.15) "Computes equivalent air temperature"
      annotation (Placement(transformation(extent={{-24,-14},{-4,6}})));
    Modelica.Blocks.Math.Add solRad[2]
      "Sums up solar radiation of both directions"
      annotation (Placement(transformation(extent={{-38,6},{-28,16}})));
    Buildings.HeatTransfer.Sources.PrescribedTemperature preTem
      "Prescribed temperature for exterior walls outdoor surface temperature"
      annotation (Placement(transformation(extent={{8,-6},{20,6}})));
    Buildings.HeatTransfer.Sources.PrescribedTemperature preTem1
      "Prescribed temperature for windows outdoor surface temperature"
      annotation (Placement(transformation(extent={{8,14},{20,26}})));
    Modelica.Thermal.HeatTransfer.Components.Convection theConWin
      "Outdoor convective heat transfer of windows"
      annotation (Placement(transformation(extent={{38,16},{28,26}})));
    Modelica.Thermal.HeatTransfer.Components.Convection theConWall
      "Outdoor convective heat transfer of walls"
      annotation (Placement(transformation(extent={{36,6},{26,-4}})));
    Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow perRad
      "Radiative heat flow of persons"
      annotation (Placement(transformation(extent={{48,-42},{68,-22}})));
    Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow perCon
      "Convective heat flow of persons"
      annotation (Placement(transformation(extent={{48,-58},{68,-38}})));
    Modelica.Blocks.Sources.CombiTimeTable intGai(
      table=[0,0,0,0; 3600,0,0,0; 7200,0,0,0; 10800,0,0,0; 14400,0,0,0;
          18000,0,0,0; 21600,0,0,0; 25200,0,0,0; 25200,80,80,200; 28800,80,
          80,200; 32400,80,80,200; 36000,80,80,200; 39600,80,80,200; 43200,
          80,80,200; 46800,80,80,200; 50400,80,80,200; 54000,80,80,200;
          57600,80,80,200; 61200,80,80,200; 61200,0,0,0; 64800,0,0,0; 72000,
          0,0,0; 75600,0,0,0; 79200,0,0,0; 82800,0,0,0; 86400,0,0,0],
      columns={2,3,4},
      extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic) "Table with profiles for persons (radiative and convective) and machines
    (convective)"
      annotation (Placement(transformation(extent={{-2,-40},{14,-24}})));
    Modelica.Blocks.Sources.Constant const[2](each k=0)
      "Sets sunblind signal to zero (open)"
      annotation (Placement(transformation(extent={{-20,14},{-14,20}})));
    Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow macConv
      "Convective heat flow of machines"
      annotation (Placement(transformation(extent={{48,-76},{68,-56}})));
    Modelica.Blocks.Sources.Constant alphaWall(k=25*11.5)
      "Outdoor coefficient of heat transfer for walls"
      annotation (Placement(
      transformation(
      extent={{-4,-4},{4,4}},
      rotation=90,
      origin={30,-16})));
    Modelica.Blocks.Sources.Constant alphaWin(k=20*14)
      "Outdoor coefficient of heat transfer for windows"
      annotation (Placement(
      transformation(
      extent={{4,-4},{-4,4}},
      rotation=90,
      origin={32,38})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTSet(k=20) "Minimum temperature setpoint"
      annotation (Placement(transformation(extent={{-300,250},{-280,270}})));
    Buildings.Controls.OBC.UnitConversions.From_degC from_degC1
      annotation (Placement(transformation(extent={{-260,250},{-240,270}})));
    Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloHea(
      nUni=nZon,
      m_flow_nominal=terUni.m1Hea_flow_nominal,
      dp_nominal=100000)
      annotation (Placement(transformation(extent={{-100,-120},{-80,-100}})));
    Buildings.Applications.DHC.Loads.Validation.BaseClasses.Terminal4PipesFluidPorts
      terUni(
      QHea_flow_nominal=500,
      QCoo_flow_nominal=2000,
      T_a2Hea_nominal=293.15,
      T_a2Coo_nominal=297.15,
      T_b1Hea_nominal=308.15,
      T_b1Coo_nominal=285.15,
      T_a1Hea_nominal=313.15,
      T_a1Coo_nominal=280.15,
      m2Hea_flow_nominal=1,
      m2Coo_flow_nominal=1,
      show_TSou=true)
      annotation (Placement(transformation(extent={{-160,-60},{-140,-40}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTSet(k=24)
      "Minimum temperature setpoint"
      annotation (Placement(transformation(extent={{-300,210},{-280,230}})));
    Buildings.Controls.OBC.UnitConversions.From_degC from_degC2
      annotation (Placement(transformation(extent={{-260,210},{-240,230}})));
    Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloCoo(
      nUni=nZon,
      m_flow_nominal=terUni.m1Coo_flow_nominal,
      disTyp=Buildings.Applications.DHC.Loads.Types.DistributionType.ChilledWater,
      dp_nominal=100000)
      annotation (Placement(transformation(extent={{-100, -160},{-80,-140}})));
  equation
    connect(eqAirTemp.TEqAirWin,preTem1. T)
      annotation (Line(
      points={{-3,-0.2},{0,-0.2},{0,20},{6.8,20}},   color={0,0,127}));
    connect(eqAirTemp.TEqAir,preTem. T)
      annotation (Line(points={{-3,-4},{4,-4},{4,0},{6.8,0}},
      color={0,0,127}));
    connect(intGai.y[1],perRad. Q_flow)
      annotation (Line(points={{14.8,-32},{48,-32}},
                                        color={0,0,127}));
    connect(intGai.y[2],perCon. Q_flow)
      annotation (Line(points={{14.8,-32},{14.8,-48},{48,-48}},
                                                              color={0,0,127}));
    connect(intGai.y[3],macConv. Q_flow)
      annotation (Line(points={{14.8,-32},{28,-32},{28,-66},{48,-66}},
                                        color={0,0,127}));
    connect(const.y,eqAirTemp. sunblind)
      annotation (Line(points={{-13.7,17},{-12,17},{-12,8},{-14,8}},
      color={0,0,127}));
    connect(HDifTil.HSkyDifTil,corGDouPan. HSkyDifTil)
      annotation (Line(
      points={{-47,36},{-28,36},{-6,36},{-6,66},{4,66}}, color={0,0,127}));
    connect(HDirTil.H,corGDouPan. HDirTil)
      annotation (Line(points={{-47,62},{-10,62},{-10,70},{4,70}},
      color={0,0,127}));
    connect(HDirTil.H,solRad. u1)
      annotation (Line(points={{-47,62},{-42,62},{-42,
      14},{-39,14}}, color={0,0,127}));
    connect(HDirTil.inc,corGDouPan. inc)
      annotation (Line(points={{-47,58},{4,58}}, color={0,0,127}));
    connect(HDifTil.H,solRad. u2)
      annotation (Line(points={{-47,30},{-44,30},{-44,
      8},{-39,8}}, color={0,0,127}));
    connect(HDifTil.HGroDifTil,corGDouPan. HGroDifTil)
      annotation (Line(
      points={{-47,24},{-4,24},{-4,62},{4,62}}, color={0,0,127}));
    connect(solRad.y,eqAirTemp. HSol)
      annotation (Line(points={{-27.5,11},{-26,11},{-26,2}},
      color={0,0,127}));
    connect(perRad.port,thermalZoneOneElement. intGainsRad)
      annotation (Line(
      points={{68,-32},{104,-32},{104,16},{92,16}},
      color={191,0,0}));
    connect(theConWin.solid,thermalZoneOneElement. window)
      annotation (
      Line(points={{38,21},{40,21},{40,12},{44,12}},   color={191,0,0}));
    connect(preTem1.port,theConWin. fluid)
      annotation (Line(points={{20,20},{28,20},{28,21}}, color={191,0,0}));
    connect(thermalZoneOneElement.extWall,theConWall. solid)
      annotation (Line(points={{44,4},{40,4},{40,1},{36,1}},
      color={191,0,0}));
    connect(theConWall.fluid,preTem. port)
      annotation (Line(points={{26,1},{24,1},{24,0},{20,0}}, color={191,0,0}));
    connect(alphaWall.y,theConWall. Gc)
      annotation (Line(points={{30,-11.6},{30,-4},{31,-4}}, color={0,0,127}));
    connect(alphaWin.y,theConWin. Gc)
      annotation (Line(points={{32,33.6},{32,26},{33,26}}, color={0,0,127}));
    connect(macConv.port,thermalZoneOneElement. intGainsConv)
      annotation (
      Line(points={{68,-66},{98,-66},{98,12},{92,12}},          color={191,
      0,0}));
    connect(perCon.port,thermalZoneOneElement. intGainsConv)
      annotation (
      Line(points={{68,-48},{98,-48},{98,12},{92,12}}, color={191,0,0}));
    connect(corGDouPan.solarRadWinTrans,thermalZoneOneElement. solRad)
      annotation (Line(points={{27,64},{40,64},{40,23},{43,23}},         color={0,
      0,127}));
    connect(weaBus.TBlaSky, eqAirTemp.TBlaSky) annotation (Line(
        points={{1,300},{-160,300},{-160,-4},{-26,-4}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(weaBus.TDryBul, eqAirTemp.TDryBul) annotation (Line(
        points={{1,300},{-160,300},{-160,-10},{-26,-10}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(weaBus, HDifTil[2].weaBus) annotation (Line(
        points={{1,300},{-160,300},{-160,30},{-68,30}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(weaBus, HDirTil[1].weaBus) annotation (Line(
        points={{1,300},{-160,300},{-160,62},{-68,62}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(weaBus, HDirTil[2].weaBus) annotation (Line(
        points={{1,300},{-160,300},{-160,62},{-68,62}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(weaBus, HDifTil[1].weaBus) annotation (Line(
        points={{1,300},{-160,300},{-160,30},{-68,30}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(minTSet.y, from_degC1.u) annotation (Line(points={{-278,260},{-262,
            260}},                                                                  color={0,0,127}));
    connect(thermalZoneOneElement.ports[1], terUni.port_a2)
      annotation (Line(points={{81.475,-9.95},{86.5,-9.95},{86.5,-40.8333},{-140,
            -40.8333}},                                                            color={0,127,255}));
    connect(terUni.port_b2, thermalZoneOneElement.ports[2])
      annotation (Line(points={{-160,-40.8333},{-180,-40.8333},{-180,-22},{84.525,
            -22},{84.525,-9.95}},                                                             color={0,127,255}));
    connect(ports_a1[1], disFloHea.port_a) annotation (Line(points={{-300,-20},{
            -280,-20},{-280,-110},{-100,-110}},
                                         color={0,127,255}));
    connect(disFloHea.port_b, ports_b1[1]) annotation (Line(points={{-80,-110},{
            280,-110},{280,-20},{300,-20}},
                                    color={0,127,255}));
    connect(maxTSet.y, from_degC2.u) annotation (Line(points={{-278,220},{-262,
            220}},                                                                  color={0,0,127}));
    connect(ports_a1[2], disFloCoo.port_a) annotation (Line(points={{-300,20},{
            -280,20},{-280,-150},{-100,-150}},
                                         color={0,127,255}));
    connect(disFloCoo.port_b, ports_b1[2]) annotation (Line(points={{-80,-150},{
            280,-150},{280,20},{300,20}},
                                    color={0,127,255}));
    connect(from_degC1.y, terUni.TSetHea) annotation (Line(points={{-238,260},{
            -200,260},{-200,-43.3333},{-160.833,-43.3333}},
                                                       color={0,0,127}));
    connect(from_degC2.y, terUni.TSetCoo) annotation (Line(points={{-238,220},{
            -200,220},{-200,-46},{-160.833,-46},{-160.833,-46.6667}},
                                                                 color={0,0,127}));
    connect(terUni.port_b1Coo, disFloCoo.ports_a1[1]) annotation (Line(points={{-140,
            -56.6667},{-90,-56.6667},{-90,-56},{-40,-56},{-40,-144},{-80,-144}},
          color={0,127,255}));
    connect(terUni.port_b1Hea, disFloHea.ports_a1[1]) annotation (Line(points={{-140,
            -59.1667},{-100,-59.1667},{-100,-60},{-60,-60},{-60,-104},{-80,-104}},
          color={0,127,255}));
    connect(disFloHea.ports_b1[1], terUni.port_a1Hea) annotation (Line(points={{-100,
            -104},{-180,-104},{-180,-59.1667},{-160,-59.1667}}, color={0,127,255}));
    connect(disFloCoo.ports_b1[1], terUni.port_a1Coo) annotation (Line(points={{-100,
            -144},{-200,-144},{-200,-56.6667},{-160,-56.6667}},
                                                          color={0,127,255}));
    connect(terUni.QActCoo_flow, QCoo_flow) annotation (Line(points={{-139.167,
            -44.1667},{50,-44.1667},{50,-44},{240,-44},{240,220},{320,220}},
                                                         color={0,0,127}));
    connect(terUni.PFan, PFan) annotation (Line(points={{-139.167,-49.1667},{60,
            -49.1667},{60,-50},{260,-50},{260,100},{320,100}},
                                  color={0,0,127}));
    connect(terUni.m1ReqHea_flow, disFloHea.m1Req_flow[1]) annotation (Line(
          points={{-139.167,-52.5},{-139.167,-84},{-140,-84},{-140,-116},{-101,
            -116},{-101,-114}}, color={0,0,127}));
    connect(terUni.m1ReqCoo_flow, disFloCoo.m1Req_flow[1]) annotation (Line(
          points={{-139.167,-54.1667},{-139.167,-104},{-140,-104},{-140,-154},{
            -101,-154},{-101,-154}}, color={0,0,127}));
    connect(terUni.QActHea_flow, QHea_flow) annotation (Line(points={{-139.167,
            -42.5},{40,-42.5},{40,-42},{220,-42},{220,280},{320,280}},
                                                                color={0,0,127}));
    annotation (
    Documentation(info="<html>
  <p>
  This is a simplified building model with:
  </p>
  <ul>
  <li> one instance of
  <a href=\"modelica://Buildings.ThermalZones.ReducedOrder.RC.OneElement\">
  Buildings.ThermalZones.ReducedOrder.RC.OneElement</a> providing the temperature of one cooling load and one
  heating load. The required cooling and heating heat flow rates to maintain the maximum and minimum
  temperature setpoints are computed by means of a PI controller;
  </li>
  <li>
  one additional heating load which temperature is computed with
  <a href=\"modelica://Buildings.DistrictEnergySystem.Loads.BaseClasses.FirstOrderODE\">
  Buildings.DistrictEnergySystem.Loads.BaseClasses.FirstOrderODE</a>
  and the required heating heat flow rate is provided by a time function.
  </li>
  </ul>
  <p>
  </p>
  </html>"),
    Diagram(coordinateSystem(extent={{-300,-300},{300,300}})), Icon(
          coordinateSystem(extent={{-100,-100},{100,100}})));
  end BuildingRCZ1;

  model BuildingRCZ1Pump "RC building model with distribution pumps (1 zone)"
    extends Buildings.Applications.DHC.Loads.BaseClasses.PartialBuilding(
      have_eleHea=false,
      have_eleCoo=false,
      have_weaBus=true,
      nPorts1=2);
    package Medium2 = Buildings.Media.Air
      "Load side medium";
    parameter Integer nZon = 1
      "Number of thermal zones";
    Buildings.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil[2](
      each outSkyCon=true,
      each outGroCon=true,
      each til=1.5707963267949,
      each lat=0.87266462599716,
      azi={3.1415926535898,4.7123889803847})
      "Calculates diffuse solar radiation on titled surface for both directions"
      annotation (Placement(transformation(extent={{-68,20},{-48,40}})));
    Buildings.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil[2](
      each til=1.5707963267949,
      each lat=0.87266462599716,
      azi={3.1415926535898,4.7123889803847})
      "Calculates direct solar radiation on titled surface for both directions"
      annotation (Placement(transformation(extent={{-68,52},{-48,72}})));
    Buildings.ThermalZones.ReducedOrder.SolarGain.CorrectionGDoublePane corGDouPan(n=2, UWin=2.1)
      "Correction factor for solar transmission"
      annotation (Placement(transformation(extent={{6,54},{26,74}})));
    Buildings.ThermalZones.ReducedOrder.RC.OneElement thermalZoneOneElement(
      VAir=52.5,
      hRad=4.999999999999999,
      hConWin=2.7000000000000006,
      gWin=1,
      ratioWinConRad=0.09,
      hConExt=2.0490178828959134,
      nExt=1,
      RExt={0.00331421908725},
      CExt={5259932.23},
      RWin=0.01642857143,
      RExtRem=0.1265217391,
      nOrientations=2,
      AWin={7,7},
      ATransparent={7,7},
      AExt={3.5,8},
      redeclare package Medium = Medium2,
      extWallRC(thermCapExt(each der_T(fixed=true))),
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      T_start=295.15,
      nPorts=2)       "Thermal zone"
      annotation (Placement(transformation(extent={{44,-10},{92,26}})));
    Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.VDI6007WithWindow
      eqAirTemp(
      n=2,
      wfGro=0,
      wfWall={0.3043478260869566,0.6956521739130435},
      wfWin={0.5,0.5},
      withLongwave=true,
      aExt=0.7,
      hConWallOut=20.0,
      hRad=5.0,
      hConWinOut=20.0,
      TGro=285.15) "Computes equivalent air temperature"
      annotation (Placement(transformation(extent={{-24,-14},{-4,6}})));
    Modelica.Blocks.Math.Add solRad[2]
      "Sums up solar radiation of both directions"
      annotation (Placement(transformation(extent={{-38,6},{-28,16}})));
    Buildings.HeatTransfer.Sources.PrescribedTemperature preTem
      "Prescribed temperature for exterior walls outdoor surface temperature"
      annotation (Placement(transformation(extent={{8,-6},{20,6}})));
    Buildings.HeatTransfer.Sources.PrescribedTemperature preTem1
      "Prescribed temperature for windows outdoor surface temperature"
      annotation (Placement(transformation(extent={{8,14},{20,26}})));
    Modelica.Thermal.HeatTransfer.Components.Convection theConWin
      "Outdoor convective heat transfer of windows"
      annotation (Placement(transformation(extent={{38,16},{28,26}})));
    Modelica.Thermal.HeatTransfer.Components.Convection theConWall
      "Outdoor convective heat transfer of walls"
      annotation (Placement(transformation(extent={{36,6},{26,-4}})));
    Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow perRad
      "Radiative heat flow of persons"
      annotation (Placement(transformation(extent={{48,-42},{68,-22}})));
    Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow perCon
      "Convective heat flow of persons"
      annotation (Placement(transformation(extent={{48,-58},{68,-38}})));
    Modelica.Blocks.Sources.CombiTimeTable intGai(
      table=[0,0,0,0; 3600,0,0,0; 7200,0,0,0; 10800,0,0,0; 14400,0,0,0;
          18000,0,0,0; 21600,0,0,0; 25200,0,0,0; 25200,80,80,200; 28800,80,
          80,200; 32400,80,80,200; 36000,80,80,200; 39600,80,80,200; 43200,
          80,80,200; 46800,80,80,200; 50400,80,80,200; 54000,80,80,200;
          57600,80,80,200; 61200,80,80,200; 61200,0,0,0; 64800,0,0,0; 72000,
          0,0,0; 75600,0,0,0; 79200,0,0,0; 82800,0,0,0; 86400,0,0,0],
      columns={2,3,4},
      extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic) "Table with profiles for persons (radiative and convective) and machines
    (convective)"
      annotation (Placement(transformation(extent={{-2,-40},{14,-24}})));
    Modelica.Blocks.Sources.Constant const[2](each k=0)
      "Sets sunblind signal to zero (open)"
      annotation (Placement(transformation(extent={{-20,14},{-14,20}})));
    Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow macConv
      "Convective heat flow of machines"
      annotation (Placement(transformation(extent={{48,-76},{68,-56}})));
    Modelica.Blocks.Sources.Constant alphaWall(k=25*11.5)
      "Outdoor coefficient of heat transfer for walls"
      annotation (Placement(
      transformation(
      extent={{-4,-4},{4,4}},
      rotation=90,
      origin={30,-16})));
    Modelica.Blocks.Sources.Constant alphaWin(k=20*14)
      "Outdoor coefficient of heat transfer for windows"
      annotation (Placement(
      transformation(
      extent={{4,-4},{-4,4}},
      rotation=90,
      origin={32,38})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTSet(k=20) "Minimum temperature setpoint"
      annotation (Placement(transformation(extent={{-300,250},{-280,270}})));
    Buildings.Controls.OBC.UnitConversions.From_degC from_degC1
      annotation (Placement(transformation(extent={{-260,250},{-240,270}})));
    Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloHea(
      redeclare package Medium=Medium1,
      nUni=nZon,
      m_flow_nominal=terUni.m1Hea_flow_nominal,
      have_pum=true,
      have_val=true,
      dp_nominal=100000)
      annotation (Placement(transformation(extent={{-100, -120},{-80,-100}})));
    Buildings.Applications.DHC.Loads.Validation.BaseClasses.Terminal4PipesFluidPorts
      terUni(
      QHea_flow_nominal=500,
      QCoo_flow_nominal=2000,
      T_a2Hea_nominal=293.15,
      T_a2Coo_nominal=297.15,
      T_b1Hea_nominal=308.15,
      T_b1Coo_nominal=285.15,
      T_a1Hea_nominal=313.15,
      T_a1Coo_nominal=280.15,
      m2Hea_flow_nominal=1,
      m2Coo_flow_nominal=1)
      annotation (Placement(transformation(extent={{-162,-60},{-142,-40}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTSet(k=24)
      "Minimum temperature setpoint"
      annotation (Placement(transformation(extent={{-300,210},{-280,230}})));
    Buildings.Controls.OBC.UnitConversions.From_degC from_degC2
      annotation (Placement(transformation(extent={{-260,210},{-240,230}})));
    Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloCoo(
      redeclare package Medium = Medium1,
      nUni=nZon,
      m_flow_nominal=terUni.m1Coo_flow_nominal,
      disTyp=Buildings.Applications.DHC.Loads.Types.DistributionType.ChilledWater,
      have_pum=true,
      have_val=true,
      dp_nominal=100000)
      annotation (Placement(transformation(extent={{-100, -160},{-80,-140}})));
    Modelica.Blocks.Sources.RealExpression realExpression(y=273 + 35)
      annotation (Placement(transformation(extent={{-180,-130},{-160,-110}})));
    Modelica.Blocks.Sources.RealExpression realExpression1(y=273 + 12)
      annotation (Placement(transformation(extent={{-178,-170},{-158,-150}})));
    Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(nin=2)
      annotation (Placement(transformation(extent={{260,70},{280,90}})));
  equation
    connect(eqAirTemp.TEqAirWin,preTem1. T)
      annotation (Line(
      points={{-3,-0.2},{0,-0.2},{0,20},{6.8,20}},   color={0,0,127}));
    connect(eqAirTemp.TEqAir,preTem. T)
      annotation (Line(points={{-3,-4},{4,-4},{4,0},{6.8,0}},
      color={0,0,127}));
    connect(intGai.y[1],perRad. Q_flow)
      annotation (Line(points={{14.8,-32},{48,-32}},
                                        color={0,0,127}));
    connect(intGai.y[2],perCon. Q_flow)
      annotation (Line(points={{14.8,-32},{14.8,-48},{48,-48}},
                                                              color={0,0,127}));
    connect(intGai.y[3],macConv. Q_flow)
      annotation (Line(points={{14.8,-32},{28,-32},{28,-66},{48,-66}},
                                        color={0,0,127}));
    connect(const.y,eqAirTemp. sunblind)
      annotation (Line(points={{-13.7,17},{-12,17},{-12,8},{-14,8}},
      color={0,0,127}));
    connect(HDifTil.HSkyDifTil,corGDouPan. HSkyDifTil)
      annotation (Line(
      points={{-47,36},{-28,36},{-6,36},{-6,66},{4,66}}, color={0,0,127}));
    connect(HDirTil.H,corGDouPan. HDirTil)
      annotation (Line(points={{-47,62},{-10,62},{-10,70},{4,70}},
      color={0,0,127}));
    connect(HDirTil.H,solRad. u1)
      annotation (Line(points={{-47,62},{-42,62},{-42,
      14},{-39,14}}, color={0,0,127}));
    connect(HDirTil.inc,corGDouPan. inc)
      annotation (Line(points={{-47,58},{4,58}}, color={0,0,127}));
    connect(HDifTil.H,solRad. u2)
      annotation (Line(points={{-47,30},{-44,30},{-44,
      8},{-39,8}}, color={0,0,127}));
    connect(HDifTil.HGroDifTil,corGDouPan. HGroDifTil)
      annotation (Line(
      points={{-47,24},{-4,24},{-4,62},{4,62}}, color={0,0,127}));
    connect(solRad.y,eqAirTemp. HSol)
      annotation (Line(points={{-27.5,11},{-26,11},{-26,2}},
      color={0,0,127}));
    connect(perRad.port,thermalZoneOneElement. intGainsRad)
      annotation (Line(
      points={{68,-32},{104,-32},{104,16},{92,16}},
      color={191,0,0}));
    connect(theConWin.solid,thermalZoneOneElement. window)
      annotation (
      Line(points={{38,21},{40,21},{40,12},{44,12}},   color={191,0,0}));
    connect(preTem1.port,theConWin. fluid)
      annotation (Line(points={{20,20},{28,20},{28,21}}, color={191,0,0}));
    connect(thermalZoneOneElement.extWall,theConWall. solid)
      annotation (Line(points={{44,4},{40,4},{40,1},{36,1}},
      color={191,0,0}));
    connect(theConWall.fluid,preTem. port)
      annotation (Line(points={{26,1},{24,1},{24,0},{20,0}}, color={191,0,0}));
    connect(alphaWall.y,theConWall. Gc)
      annotation (Line(points={{30,-11.6},{30,-4},{31,-4}}, color={0,0,127}));
    connect(alphaWin.y,theConWin. Gc)
      annotation (Line(points={{32,33.6},{32,26},{33,26}}, color={0,0,127}));
    connect(macConv.port,thermalZoneOneElement. intGainsConv)
      annotation (
      Line(points={{68,-66},{98,-66},{98,12},{92,12}},          color={191,
      0,0}));
    connect(perCon.port,thermalZoneOneElement. intGainsConv)
      annotation (
      Line(points={{68,-48},{98,-48},{98,12},{92,12}}, color={191,0,0}));
    connect(corGDouPan.solarRadWinTrans,thermalZoneOneElement. solRad)
      annotation (Line(points={{27,64},{40,64},{40,23},{43,23}},         color={0,
      0,127}));
    connect(weaBus.TBlaSky, eqAirTemp.TBlaSky) annotation (Line(
        points={{1,300},{-160,300},{-160,-4},{-26,-4}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(weaBus.TDryBul, eqAirTemp.TDryBul) annotation (Line(
        points={{1,300},{-160,300},{-160,-10},{-26,-10}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(weaBus, HDifTil[2].weaBus) annotation (Line(
        points={{1,300},{-160,300},{-160,30},{-68,30}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(weaBus, HDirTil[1].weaBus) annotation (Line(
        points={{1,300},{-160,300},{-160,62},{-68,62}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(weaBus, HDirTil[2].weaBus) annotation (Line(
        points={{1,300},{-160,300},{-160,62},{-68,62}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(weaBus, HDifTil[1].weaBus) annotation (Line(
        points={{1,300},{-160,300},{-160,30},{-68,30}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(minTSet.y, from_degC1.u) annotation (Line(points={{-278,260},{-262,
            260}},                                                                  color={0,0,127}));
    connect(thermalZoneOneElement.ports[1], terUni.port_a2)
      annotation (Line(points={{81.475,-9.95},{86.5,-9.95},{86.5,-40.8333},{-142,
            -40.8333}},                                                            color={0,127,255}));
    connect(terUni.port_b2, thermalZoneOneElement.ports[2])
      annotation (Line(points={{-162,-40.8333},{-180,-40.8333},{-180,-22},{84.525,
            -22},{84.525,-9.95}},                                                             color={0,127,255}));
    connect(ports_a1[1], disFloHea.port_a) annotation (Line(points={{-300,-20},{
            -280,-20},{-280,-110},{-100,-110}},
                                         color={0,127,255}));
    connect(disFloHea.port_b, ports_b1[1]) annotation (Line(points={{-80,-110},{
            280,-110},{280,-20},{300,-20}},
                                    color={0,127,255}));
    connect(maxTSet.y, from_degC2.u) annotation (Line(points={{-278,220},{-262,
            220}},                                                                  color={0,0,127}));
    connect(ports_a1[2], disFloCoo.port_a) annotation (Line(points={{-300,20},{
            -280,20},{-280,-150},{-100,-150}},
                                         color={0,127,255}));
    connect(disFloCoo.port_b, ports_b1[2]) annotation (Line(points={{-80,-150},{
            280,-150},{280,20},{300,20}},
                                    color={0,127,255}));
    connect(from_degC1.y, terUni.TSetHea) annotation (Line(points={{-238,260},{
            -200,260},{-200,-43.3333},{-162.833,-43.3333}},
                                                       color={0,0,127}));
    connect(from_degC2.y, terUni.TSetCoo) annotation (Line(points={{-238,220},{
            -200,220},{-200,-46},{-162.833,-46},{-162.833,-46.6667}},
                                                                 color={0,0,127}));
    connect(terUni.port_b1Coo, disFloCoo.ports_a1[1]) annotation (Line(points={{-142,
            -56.6667},{-90,-56.6667},{-90,-56},{-40,-56},{-40,-144},{-80,-144}},
          color={0,127,255}));
    connect(terUni.port_b1Hea, disFloHea.ports_a1[1]) annotation (Line(points={{-142,
            -59.1667},{-100,-59.1667},{-100,-60},{-60,-60},{-60,-104},{-80,-104}},
          color={0,127,255}));
    connect(disFloHea.ports_b1[1], terUni.port_a1Hea) annotation (Line(points={{-100,
            -104},{-180,-104},{-180,-59.1667},{-162,-59.1667}}, color={0,127,255}));
    connect(disFloCoo.ports_b1[1], terUni.port_a1Coo) annotation (Line(points={{-100,
            -144},{-200,-144},{-200,-56.6667},{-162,-56.6667}},
                                                          color={0,127,255}));
    connect(terUni.QActHea_flow, QHea_flow) annotation (Line(points={{-141.167,
            -42.5},{82,-42.5},{82,280},{320,280}},
                                            color={0,127,255}));
    connect(terUni.QActCoo_flow, QCoo_flow) annotation (Line(points={{-141.167,
            -44.1667},{83.4165,-44.1667},{83.4165,220},{320,220}},
                                                         color={0,0,127}));
    connect(terUni.PFan, PFan) annotation (Line(points={{-141.167,-49.1667},{40,
            -49.1667},{40,-50},{220,-50},{220,100},{320,100}},
                                  color={0,0,127}));
    connect(realExpression.y, disFloHea.TSupSet) annotation (Line(points={{-159,-120},
            {-130,-120},{-130,-118},{-101,-118}},       color={0,0,127}));
    connect(terUni.m1ReqHea_flow, disFloHea.m1Req_flow[1]) annotation (Line(
          points={{-141.167,-52.5},{-141.167,-115.25},{-101,-115.25},{-101,-114}},
          color={0,0,127}));
    connect(terUni.m1ReqCoo_flow, disFloCoo.m1Req_flow[1]) annotation (Line(
          points={{-141.167,-54.1667},{-141.167,-154},{-101,-154}}, color={0,0,127}));
    connect(realExpression1.y, disFloCoo.TSupSet) annotation (Line(points={{-157,-160},
            {-130,-160},{-130,-158},{-101,-158}},       color={0,0,127}));
    connect(disFloHea.PPum, mulSum.u[1]) annotation (Line(points={{-79,-118},{240,
            -118},{240,81},{258,81}}, color={0,0,127}));
    connect(disFloCoo.PPum, mulSum.u[2]) annotation (Line(points={{-79,-158},{244,
            -158},{244,80},{258,80},{258,79}}, color={0,0,127}));
    connect(mulSum.y, PPum) annotation (Line(points={{282,80},{298,80},{298,60},{320,
            60}},     color={0,0,127}));
    annotation (
    Documentation(info="<html>
  <p>
  This is a simplified building model with:
  </p>
  <ul>
  <li> one instance of
  <a href=\"modelica://Buildings.ThermalZones.ReducedOrder.RC.OneElement\">
  Buildings.ThermalZones.ReducedOrder.RC.OneElement</a> providing the temperature of one cooling load and one
  heating load. The required cooling and heating heat flow rates to maintain the maximum and minimum
  temperature setpoints are computed by means of a PI controller;
  </li>
  <li>
  one additional heating load which temperature is computed with
  <a href=\"modelica://Buildings.DistrictEnergySystem.Loads.BaseClasses.FirstOrderODE\">
  Buildings.DistrictEnergySystem.Loads.BaseClasses.FirstOrderODE</a>
  and the required heating heat flow rate is provided by a time function.
  </li>
  </ul>
  <p>
  </p>
  </html>"),
    Diagram(coordinateSystem(extent={{-300,-300},{300,300}})), Icon(
          coordinateSystem(extent={{-100,-100},{100,100}})));
  end BuildingRCZ1Pump;

  model BuildingRCZ1HeatPort "RC building model (1 zone) with heat ports"
    extends Buildings.Applications.DHC.Loads.BaseClasses.PartialBuilding(
      have_fan=false,
      have_pum=false,
      have_eleHea=false,
      have_eleCoo=false,
      nPorts1=2);
    package Medium2 = Buildings.Media.Air
      "Load side medium";
    parameter Integer nZon = 1
      "Number of thermal zones";
    Buildings.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil[2](
      each outSkyCon=true,
      each outGroCon=true,
      each til=1.5707963267949,
      each lat=0.87266462599716,
      azi={3.1415926535898,4.7123889803847})
      "Calculates diffuse solar radiation on titled surface for both directions"
      annotation (Placement(transformation(extent={{-68,20},{-48,40}})));
    Buildings.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil[2](
      each til=1.5707963267949,
      each lat=0.87266462599716,
      azi={3.1415926535898,4.7123889803847})
      "Calculates direct solar radiation on titled surface for both directions"
      annotation (Placement(transformation(extent={{-68,52},{-48,72}})));
    Buildings.ThermalZones.ReducedOrder.SolarGain.CorrectionGDoublePane corGDouPan(n=2, UWin=2.1)
      "Correction factor for solar transmission"
      annotation (Placement(transformation(extent={{6,54},{26,74}})));
    Buildings.ThermalZones.ReducedOrder.RC.OneElement thermalZoneOneElement(
      VAir=52.5,
      hRad=4.999999999999999,
      hConWin=2.7000000000000006,
      gWin=1,
      ratioWinConRad=0.09,
      hConExt=2.0490178828959134,
      nExt=1,
      RExt={0.00331421908725},
      CExt={5259932.23},
      RWin=0.01642857143,
      RExtRem=0.1265217391,
      nOrientations=2,
      AWin={7,7},
      ATransparent={7,7},
      AExt={3.5,8},
      redeclare package Medium = Medium2,
      extWallRC(thermCapExt(each der_T(fixed=true))),
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      T_start=295.15)       "Thermal zone"
      annotation (Placement(transformation(extent={{44,-10},{92,26}})));
    Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.VDI6007WithWindow
      eqAirTemp(
      n=2,
      wfGro=0,
      wfWall={0.3043478260869566,0.6956521739130435},
      wfWin={0.5,0.5},
      withLongwave=true,
      aExt=0.7,
      hConWallOut=20.0,
      hRad=5.0,
      hConWinOut=20.0,
      TGro=285.15) "Computes equivalent air temperature"
      annotation (Placement(transformation(extent={{-24,-14},{-4,6}})));
    Modelica.Blocks.Math.Add solRad[2]
      "Sums up solar radiation of both directions"
      annotation (Placement(transformation(extent={{-38,6},{-28,16}})));
    Buildings.HeatTransfer.Sources.PrescribedTemperature preTem
      "Prescribed temperature for exterior walls outdoor surface temperature"
      annotation (Placement(transformation(extent={{8,-6},{20,6}})));
    Buildings.HeatTransfer.Sources.PrescribedTemperature preTem1
      "Prescribed temperature for windows outdoor surface temperature"
      annotation (Placement(transformation(extent={{8,14},{20,26}})));
    Modelica.Thermal.HeatTransfer.Components.Convection theConWin
      "Outdoor convective heat transfer of windows"
      annotation (Placement(transformation(extent={{38,16},{28,26}})));
    Modelica.Thermal.HeatTransfer.Components.Convection theConWall
      "Outdoor convective heat transfer of walls"
      annotation (Placement(transformation(extent={{36,6},{26,-4}})));
    Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow perRad
      "Radiative heat flow of persons"
      annotation (Placement(transformation(extent={{48,-42},{68,-22}})));
    Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow perCon
      "Convective heat flow of persons"
      annotation (Placement(transformation(extent={{48,-58},{68,-38}})));
    Modelica.Blocks.Sources.CombiTimeTable intGai(
      table=[0,0,0,0; 3600,0,0,0; 7200,0,0,0; 10800,0,0,0; 14400,0,0,0;
          18000,0,0,0; 21600,0,0,0; 25200,0,0,0; 25200,80,80,200; 28800,80,
          80,200; 32400,80,80,200; 36000,80,80,200; 39600,80,80,200; 43200,
          80,80,200; 46800,80,80,200; 50400,80,80,200; 54000,80,80,200;
          57600,80,80,200; 61200,80,80,200; 61200,0,0,0; 64800,0,0,0; 72000,
          0,0,0; 75600,0,0,0; 79200,0,0,0; 82800,0,0,0; 86400,0,0,0],
      columns={2,3,4},
      extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic) "Table with profiles for persons (radiative and convective) and machines
    (convective)"
      annotation (Placement(transformation(extent={{-2,-40},{14,-24}})));
    Modelica.Blocks.Sources.Constant const[2](each k=0)
      "Sets sunblind signal to zero (open)"
      annotation (Placement(transformation(extent={{-20,14},{-14,20}})));
    Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow macConv
      "Convective heat flow of machines"
      annotation (Placement(transformation(extent={{48,-76},{68,-56}})));
    Modelica.Blocks.Sources.Constant alphaWall(k=25*11.5)
      "Outdoor coefficient of heat transfer for walls"
      annotation (Placement(
      transformation(
      extent={{-4,-4},{4,4}},
      rotation=90,
      origin={30,-16})));
    Modelica.Blocks.Sources.Constant alphaWin(k=20*14)
      "Outdoor coefficient of heat transfer for windows"
      annotation (Placement(
      transformation(
      extent={{4,-4},{-4,4}},
      rotation=90,
      origin={32,38})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTSet(k=20) "Minimum temperature setpoint"
      annotation (Placement(transformation(extent={{-300,250},{-280,270}})));
    Buildings.Controls.OBC.UnitConversions.From_degC from_degC1
      annotation (Placement(transformation(extent={{-260,250},{-240,270}})));
    Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloHea(
      nUni=nZon,
      m_flow_nominal=terUni.m1Hea_flow_nominal,
      dp_nominal=100000)
      annotation (Placement(transformation(extent={{-120,-120},{-100,-100}})));
    Terminal4PipesHeatPorts terUni(
      QHea_flow_nominal=500,
      QCoo_flow_nominal=2000,
      T_a2Hea_nominal=293.15,
      T_a2Coo_nominal=297.15,
      T_b1Hea_nominal=308.15,
      T_b1Coo_nominal=285.15,
      T_a1Hea_nominal=313.15,
      T_a1Coo_nominal=280.15,
      m2Hea_flow_nominal=1,
      m2Coo_flow_nominal=1)
      annotation (Placement(transformation(extent={{-160,-60},{-140,-40}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTSet(k=24)
      "Minimum temperature setpoint"
      annotation (Placement(transformation(extent={{-300,210},{-280,230}})));
    Buildings.Controls.OBC.UnitConversions.From_degC from_degC2
      annotation (Placement(transformation(extent={{-260,210},{-240,230}})));
    Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloCoo(
      nUni=nZon,
      m_flow_nominal=terUni.m1Coo_flow_nominal,
      disTyp=Buildings.Applications.DHC.Loads.Types.DistributionType.ChilledWater,
      dp_nominal=100000)
      annotation (Placement(transformation(extent={{-120, -160},{-100,-140}})));
  equation
    connect(eqAirTemp.TEqAirWin,preTem1. T)
      annotation (Line(
      points={{-3,-0.2},{0,-0.2},{0,20},{6.8,20}},   color={0,0,127}));
    connect(eqAirTemp.TEqAir,preTem. T)
      annotation (Line(points={{-3,-4},{4,-4},{4,0},{6.8,0}},
      color={0,0,127}));
    connect(intGai.y[1],perRad. Q_flow)
      annotation (Line(points={{14.8,-32},{48,-32}},
                                        color={0,0,127}));
    connect(intGai.y[2],perCon. Q_flow)
      annotation (Line(points={{14.8,-32},{14.8,-48},{48,-48}},
                                                              color={0,0,127}));
    connect(intGai.y[3],macConv. Q_flow)
      annotation (Line(points={{14.8,-32},{28,-32},{28,-66},{48,-66}},
                                        color={0,0,127}));
    connect(const.y,eqAirTemp. sunblind)
      annotation (Line(points={{-13.7,17},{-12,17},{-12,8},{-14,8}},
      color={0,0,127}));
    connect(HDifTil.HSkyDifTil,corGDouPan. HSkyDifTil)
      annotation (Line(
      points={{-47,36},{-28,36},{-6,36},{-6,66},{4,66}}, color={0,0,127}));
    connect(HDirTil.H,corGDouPan. HDirTil)
      annotation (Line(points={{-47,62},{-10,62},{-10,70},{4,70}},
      color={0,0,127}));
    connect(HDirTil.H,solRad. u1)
      annotation (Line(points={{-47,62},{-42,62},{-42,
      14},{-39,14}}, color={0,0,127}));
    connect(HDirTil.inc,corGDouPan. inc)
      annotation (Line(points={{-47,58},{4,58}}, color={0,0,127}));
    connect(HDifTil.H,solRad. u2)
      annotation (Line(points={{-47,30},{-44,30},{-44,
      8},{-39,8}}, color={0,0,127}));
    connect(HDifTil.HGroDifTil,corGDouPan. HGroDifTil)
      annotation (Line(
      points={{-47,24},{-4,24},{-4,62},{4,62}}, color={0,0,127}));
    connect(solRad.y,eqAirTemp. HSol)
      annotation (Line(points={{-27.5,11},{-26,11},{-26,2}},
      color={0,0,127}));
    connect(perRad.port,thermalZoneOneElement. intGainsRad)
      annotation (Line(
      points={{68,-32},{104,-32},{104,16},{92,16}},
      color={191,0,0}));
    connect(theConWin.solid,thermalZoneOneElement. window)
      annotation (
      Line(points={{38,21},{40,21},{40,12},{44,12}},   color={191,0,0}));
    connect(preTem1.port,theConWin. fluid)
      annotation (Line(points={{20,20},{28,20},{28,21}}, color={191,0,0}));
    connect(thermalZoneOneElement.extWall,theConWall. solid)
      annotation (Line(points={{44,4},{40,4},{40,1},{36,1}},
      color={191,0,0}));
    connect(theConWall.fluid,preTem. port)
      annotation (Line(points={{26,1},{24,1},{24,0},{20,0}}, color={191,0,0}));
    connect(alphaWall.y,theConWall. Gc)
      annotation (Line(points={{30,-11.6},{30,-4},{31,-4}}, color={0,0,127}));
    connect(alphaWin.y,theConWin. Gc)
      annotation (Line(points={{32,33.6},{32,26},{33,26}}, color={0,0,127}));
    connect(macConv.port,thermalZoneOneElement. intGainsConv)
      annotation (
      Line(points={{68,-66},{98,-66},{98,12},{92,12}},          color={191,
      0,0}));
    connect(perCon.port,thermalZoneOneElement. intGainsConv)
      annotation (
      Line(points={{68,-48},{98,-48},{98,12},{92,12}}, color={191,0,0}));
    connect(corGDouPan.solarRadWinTrans,thermalZoneOneElement. solRad)
      annotation (Line(points={{27,64},{40,64},{40,23},{43,23}},         color={0,
      0,127}));
    connect(weaBus.TBlaSky, eqAirTemp.TBlaSky) annotation (Line(
        points={{1,300},{-160,300},{-160,-4},{-26,-4}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(weaBus.TDryBul, eqAirTemp.TDryBul) annotation (Line(
        points={{1,300},{-160,300},{-160,-10},{-26,-10}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(weaBus, HDifTil[2].weaBus) annotation (Line(
        points={{1,300},{-160,300},{-160,30},{-68,30}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(weaBus, HDirTil[1].weaBus) annotation (Line(
        points={{1,300},{-160,300},{-160,62},{-68,62}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(weaBus, HDirTil[2].weaBus) annotation (Line(
        points={{1,300},{-160,300},{-160,62},{-68,62}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(weaBus, HDifTil[1].weaBus) annotation (Line(
        points={{1,300},{-160,300},{-160,30},{-68,30}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(minTSet.y, from_degC1.u) annotation (Line(points={{-278,260},{-262,
            260}},                                                                  color={0,0,127}));
    connect(ports_a1[1], disFloHea.port_a) annotation (Line(points={{-300,-20},{
            -280,-20},{-280,-110},{-120,-110}},
                                         color={0,127,255}));
    connect(disFloHea.port_b, ports_b1[1]) annotation (Line(points={{-100,-110},{
            280,-110},{280,-20},{300,-20}},
                                    color={0,127,255}));
    connect(maxTSet.y, from_degC2.u) annotation (Line(points={{-278,220},{-262,
            220}},                                                                  color={0,0,127}));
    connect(ports_a1[2], disFloCoo.port_a) annotation (Line(points={{-300,20},{
            -280,20},{-280,-150},{-120,-150}},
                                         color={0,127,255}));
    connect(disFloCoo.port_b, ports_b1[2]) annotation (Line(points={{-100,-150},{
            280,-150},{280,20},{300,20}},
                                    color={0,127,255}));
    connect(terUni.heaPorRad, thermalZoneOneElement.intGainsRad) annotation (Line(
          points={{-146.667,-50},{-26,-50},{-26,16},{92,16}},
                                                            color={191,0,0}));
    connect(terUni.heaPorCon, thermalZoneOneElement.intGainsConv) annotation (
        Line(points={{-153.333,-50},{-30,-50},{-30,12},{92,12}},
                                                               color={191,0,0}));
    connect(terUni.port_b1Hea, disFloHea.ports_a1[1]) annotation (Line(points={{-140,
            -59.1667},{-80,-59.1667},{-80,-104},{-100,-104}}, color={0,127,255}));
    connect(terUni.port_b1Coo, disFloCoo.ports_a1[1]) annotation (Line(points={{-140,
            -56.6667},{-60,-56.6667},{-60,-144},{-100,-144}}, color={0,127,255}));
    connect(disFloHea.ports_b1[1], terUni.port_a1Hea) annotation (Line(points={{-120,
            -104},{-180,-104},{-180,-59.1667},{-160,-59.1667}}, color={0,127,255}));
    connect(disFloCoo.ports_b1[1], terUni.port_a1Coo) annotation (Line(points={{-120,
            -144},{-200,-144},{-200,-56.6667},{-160,-56.6667}}, color={0,127,255}));
    connect(from_degC2.y, terUni.TSetCoo) annotation (Line(points={{-238,220},{
            -200,220},{-200,-46.6667},{-160.833,-46.6667}},
                                                       color={0,0,127}));
    connect(from_degC1.y, terUni.TSetHea) annotation (Line(points={{-238,260},{
            -200,260},{-200,-43.3333},{-160.833,-43.3333}},
                                                       color={0,0,127}));
    connect(terUni.QActHea_flow, QHea_flow) annotation (Line(points={{-139.167,
            -42.5},{80.4165,-42.5},{80.4165,280},{320,280}},
                                                      color={0,0,127}));
    connect(terUni.QActCoo_flow, QCoo_flow) annotation (Line(points={{-139.167,
            -44.1667},{81.4165,-44.1667},{81.4165,220},{320,220}},
                                                         color={0,0,127}));
    connect(terUni.m1ReqHea_flow, disFloHea.m1Req_flow[1]) annotation (Line(
          points={{-139.167,-52.5},{-139.167,-84},{-140,-84},{-140,-114},{-121,
            -114},{-121,-114}}, color={0,0,127}));
    connect(terUni.m1ReqCoo_flow, disFloCoo.m1Req_flow[1]) annotation (Line(
          points={{-139.167,-54.1667},{-139.167,-106},{-140,-106},{-140,-156},{
            -121,-156},{-121,-154}}, color={0,0,127}));
    annotation (
    Documentation(info="<html>
  <p>
  This is a simplified building model with:
  </p>
  <ul>
  <li> one instance of
  <a href=\"modelica://Buildings.ThermalZones.ReducedOrder.RC.OneElement\">
  Buildings.ThermalZones.ReducedOrder.RC.OneElement</a> providing the temperature of one cooling load and one
  heating load. The required cooling and heating heat flow rates to maintain the maximum and minimum
  temperature setpoints are computed by means of a PI controller;
  </li>
  <li>
  one additional heating load which temperature is computed with
  <a href=\"modelica://Buildings.DistrictEnergySystem.Loads.BaseClasses.FirstOrderODE\">
  Buildings.DistrictEnergySystem.Loads.BaseClasses.FirstOrderODE</a>
  and the required heating heat flow rate is provided by a time function.
  </li>
  </ul>
  <p>
  </p>
  </html>"),
    Diagram(coordinateSystem(extent={{-300,-300},{300,300}})), Icon(
          coordinateSystem(extent={{-100,-100},{100,100}})));
  end BuildingRCZ1HeatPort;

  model BuildingRCZ6Geojson
    "RC building model (6 zones) based on URBANopt GeoJSON export"
    extends Buildings.Applications.DHC.Loads.BaseClasses.PartialBuilding(
      final have_eleHea=false,
      final have_eleCoo=false,
      final have_fan=false,
      final have_pum=false,
      nPorts1=2);
    parameter Integer nZon = 6
      "Number of thermal zones";
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTSet[nZon](k=fill(20, nZon))
      "Minimum temperature setpoint" annotation (Placement(transformation(extent={{-300,
              240},{-280,260}})));
    Buildings.Controls.OBC.UnitConversions.From_degC from_degC1[nZon]
      annotation (Placement(transformation(extent={{-260,240},{-240,260}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTSet[nZon](k=fill(24, nZon))
      "Maximum temperature setpoint" annotation (Placement(transformation(extent={{-300,
              200},{-280,220}})));
    Buildings.Controls.OBC.UnitConversions.From_degC from_degC2[nZon]
      annotation (Placement(transformation(extent={{-260,200},{-240,220}})));
    Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloHea(
      m_flow_nominal=sum(terUni.m1Hea_flow_nominal),
      nUni=nZon,
      dp_nominal=100000)
      annotation (Placement(transformation(extent={{-140, -100},{-120,-80}})));
    Buildings.Applications.DHC.Loads.Validation.BaseClasses.Terminal4PipesHeatPorts
      terUni[nZon](
      QHea_flow_nominal={10000,10000,10000,10000,10000,10000},
      QCoo_flow_nominal={10000,10000,10000,10000,10000,50000},
      each T_a2Hea_nominal=293.15,
      each T_a2Coo_nominal=297.15,
      each T_b1Hea_nominal=35 + 273.15,
      each T_b1Coo_nominal=12 + 273.15,
      each T_a1Hea_nominal=40 + 273.15,
      each T_a1Coo_nominal=7 + 273.15,
      each m2Hea_flow_nominal=1,
      each m2Coo_flow_nominal=1,
      each final fraCon={1,1})
      annotation (Placement(transformation(extent={{-200,-60},{-180,-40}})));
    Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloCoo(
      m_flow_nominal=sum(terUni.m1Coo_flow_nominal),
      nUni=nZon,
      disTyp=Buildings.Applications.DHC.Loads.Types.DistributionType.ChilledWater,
      dp_nominal=100000) annotation (Placement(transformation(extent={{-140,
              -160},{-120,-140}})));

    Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum1(nin=nZon)
      annotation (Placement(transformation(extent={{240,270},{260,290}})));
    Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum2(nin=nZon)
      annotation (Placement(transformation(extent={{240,230},{260,250}})));
    GeojsonExportRC.B5a6b99ec37f4de7f94020090.Office office
      annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
    GeojsonExportRC.B5a6b99ec37f4de7f94020090.Floor floor
      annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
    GeojsonExportRC.B5a6b99ec37f4de7f94020090.Storage storage
      annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
    GeojsonExportRC.B5a6b99ec37f4de7f94020090.Meeting meeting
      annotation (Placement(transformation(extent={{20,-20},{40,0}})));
    GeojsonExportRC.B5a6b99ec37f4de7f94020090.Restroom restroom
      annotation (Placement(transformation(extent={{60,-20},{80,0}})));
    GeojsonExportRC.B5a6b99ec37f4de7f94020090.ICT iCT
      annotation (Placement(transformation(extent={{100,-20},{120,0}})));
  equation
    connect(maxTSet.y,from_degC2. u) annotation (Line(points={{-278,210},{-262,210}},   color={0,0,127}));
    connect(minTSet.y, from_degC1.u)
      annotation (Line(points={{-278,250},{-262,250}},                       color={0,0,127}));
    connect(ports_a1[1],disFloHea. port_a) annotation (Line(points={{-300,-20},{-252,
            -20},{-252,-90},{-140,-90}}, color={0,127,255}));
    connect(disFloHea.port_b, ports_b1[1]) annotation (Line(points={{-120,-90},{308,
            -90},{308,-20},{300,-20}},
                                    color={0,127,255}));
    connect(ports_a1[2],disFloCoo. port_a) annotation (Line(points={{-300,20},{-252,
            20},{-252,-150},{-140,-150}},color={0,127,255}));
    connect(disFloCoo.port_b, ports_b1[2]) annotation (Line(points={{-120,-150},{308,
            -150},{308,20},{300,20}},
                                    color={0,127,255}));
    connect(from_degC1.y, terUni.TSetHea) annotation (Line(points={{-238,250},{
            -220,250},{-220,-43.3333},{-200.833,-43.3333}},
                                                       color={0,0,127}));
    connect(from_degC2.y, terUni.TSetCoo) annotation (Line(points={{-238,210},{
            -220,210},{-220,-46.6667},{-200.833,-46.6667}},
                                                       color={0,0,127}));
    connect(terUni.port_b1Hea, disFloHea.ports_a1) annotation (Line(points={{-180,
            -59.1667},{-100,-59.1667},{-100,-84},{-120,-84}}, color={0,127,255}));
    connect(terUni.port_b1Coo, disFloCoo.ports_a1) annotation (Line(points={{-180,
            -56.6667},{-80,-56.6667},{-80,-144},{-120,-144}}, color={0,127,255}));
    connect(disFloHea.ports_b1, terUni.port_a1Hea) annotation (Line(points={{-140,
            -84},{-220,-84},{-220,-59.1667},{-200,-59.1667}}, color={0,127,255}));
    connect(disFloCoo.ports_b1, terUni.port_a1Coo) annotation (Line(points={{-140,
            -144},{-240,-144},{-240,-56.6667},{-200,-56.6667}}, color={0,127,255}));
    connect(terUni.QActHea_flow, mulSum1.u) annotation (Line(points={{-179.167,
            -42.5},{-160.584,-42.5},{-160.584,280},{238,280}},
                                                        color={0,0,127}));
    connect(terUni.QActCoo_flow, mulSum2.u) annotation (Line(points={{-179.167,
            -44.1667},{-160.584,-44.1667},{-160.584,240},{238,240}},
                                                           color={0,0,127}));
    connect(mulSum1.y, QHea_flow) annotation (Line(points={{262,280},{286,280},{
            286,280},{320,280}}, color={0,0,127}));
    connect(mulSum2.y, QCoo_flow) annotation (Line(points={{262,240},{284,240},{284,
            220},{320,220}},     color={0,0,127}));
    connect(weaBus, office.weaBus) annotation (Line(
        points={{1,300},{0,300},{0,20},{-66,20},{-66,-10.2},{-96,-10.2}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(weaBus, floor.weaBus) annotation (Line(
        points={{1,300},{1,160},{0,20},{-56,20},{-56,-10.2}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-3,6},{-3,6}},
        horizontalAlignment=TextAlignment.Right));
    connect(weaBus, storage.weaBus) annotation (Line(
        points={{1,300},{0,300},{0,-10.2},{-16,-10.2}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(weaBus, meeting.weaBus) annotation (Line(
        points={{1,300},{1,20},{24,20},{24,-10.2}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-3,6},{-3,6}},
        horizontalAlignment=TextAlignment.Right));
    connect(weaBus, restroom.weaBus) annotation (Line(
        points={{1,300},{2,300},{2,20},{68,20},{68,-10.2},{64,-10.2}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(weaBus, iCT.weaBus) annotation (Line(
        points={{1,300},{0,300},{0,19.8},{104,19.8},{104,-10.2}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(terUni[1].heaPorCon, office.port_a) annotation (Line(points={{
            -193.333,-50},{-192,-50},{-192,0},{-90,0}}, color={191,0,0}));
    connect(terUni[2].heaPorCon, floor.port_a) annotation (Line(points={{-193.333,
            -50},{-192,-50},{-192,0},{-50,0}}, color={191,0,0}));
    connect(terUni[3].heaPorCon, storage.port_a) annotation (Line(points={{
            -193.333,-50},{-192,-50},{-192,0},{-10,0}}, color={191,0,0}));
    connect(terUni[4].heaPorCon, meeting.port_a) annotation (Line(points={{
            -193.333,-50},{-192,-50},{-192,0},{30,0}}, color={191,0,0}));
    connect(terUni[5].heaPorCon, restroom.port_a) annotation (Line(points={{
            -193.333,-50},{-192,-50},{-192,0},{70,0}}, color={191,0,0}));
    connect(terUni[6].heaPorCon, iCT.port_a) annotation (Line(points={{-193.333,
            -50},{-192,-50},{-192,0},{110,0}}, color={191,0,0}));
    connect(terUni[1].heaPorRad, office.port_a) annotation (Line(points={{
            -186.667,-50},{-90,-50},{-90,0}}, color={191,0,0}));
    connect(terUni[2].heaPorRad, floor.port_a) annotation (Line(points={{-186.667,
            -50},{-50,-50},{-50,0}}, color={191,0,0}));
    connect(terUni[3].heaPorRad, storage.port_a) annotation (Line(points={{
            -186.667,-50},{-10,-50},{-10,0}}, color={191,0,0}));
    connect(terUni[4].heaPorRad, meeting.port_a) annotation (Line(points={{
            -186.667,-50},{30,-50},{30,0}}, color={191,0,0}));
    connect(terUni[5].heaPorRad, restroom.port_a) annotation (Line(points={{
            -186.667,-50},{70,-50},{70,0}}, color={191,0,0}));
    connect(terUni[6].heaPorRad, iCT.port_a) annotation (Line(points={{-186.667,
            -50},{110,-50},{110,0}}, color={191,0,0}));
    connect(terUni.m1ReqHea_flow, disFloHea.m1Req_flow) annotation (Line(points={{
            -179.167,-52.5},{-179.167,-74},{-180,-74},{-180,-94},{-141,-94},{-141,
            -94}}, color={0,0,127}));
    connect(terUni.m1ReqCoo_flow, disFloCoo.m1Req_flow) annotation (Line(points={{
            -179.167,-54.1667},{-179.167,-155.083},{-141,-155.083},{-141,-154}},
          color={0,0,127}));
    annotation (
    Documentation(info="
  <html>
  <p>
  This is a simplified multizone RC model resulting from the translation of a GeoJSON model specified
  within Urbanopt UI. It is composed of 6 thermal zones corresponding to the different load patterns.
  </p>
  </html>"),
    Diagram(coordinateSystem(extent={{-300,-300},{300,300}})), Icon(
          coordinateSystem(extent={{-100,-100},{100,100}})));
  end BuildingRCZ6Geojson;

  model BuildingRCZ6GeojsonPump
    "RC building model (6 zones) based on URBANopt GeoJSON export, with distribution pumps"
    extends Buildings.Applications.DHC.Loads.BaseClasses.PartialBuilding(
      final have_eleHea=false,
      final have_eleCoo=false,
      final have_fan=false,
      final have_pum=true,
      nPorts1=2);
    parameter Integer nZon = 6
      "Number of thermal zones";
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTSet[nZon](k=fill(20, nZon))
      "Minimum temperature setpoint" annotation (Placement(transformation(extent={{-300,
              240},{-280,260}})));
    Buildings.Controls.OBC.UnitConversions.From_degC from_degC1[nZon]
      annotation (Placement(transformation(extent={{-260,240},{-240,260}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTSet[nZon](k=fill(24, nZon))
      "Maximum temperature setpoint" annotation (Placement(transformation(extent={{-300,
              200},{-280,220}})));
    Buildings.Controls.OBC.UnitConversions.From_degC from_degC2[nZon]
      annotation (Placement(transformation(extent={{-260,200},{-240,220}})));
    Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloHea(
      m_flow_nominal=sum(terUni.m1Hea_flow_nominal),
      nUni=nZon,
      have_pum=true,
      dp_nominal=100000)
      annotation (Placement(transformation(extent={{-140, -100},{-120,-80}})));
    Buildings.Applications.DHC.Loads.Validation.BaseClasses.Terminal4PipesHeatPorts
      terUni[nZon](
      QHea_flow_nominal={10000,10000,10000,10000,10000,10000},
      QCoo_flow_nominal={10000,10000,10000,10000,10000,50000},
      each T_a2Hea_nominal=293.15,
      each T_a2Coo_nominal=297.15,
      each T_b1Hea_nominal=35 + 273.15,
      each T_b1Coo_nominal=12 + 273.15,
      each T_a1Hea_nominal=40 + 273.15,
      each T_a1Coo_nominal=7 + 273.15,
      each m2Hea_flow_nominal=1,
      each m2Coo_flow_nominal=1,
      each final fraCon={1,1})
      annotation (Placement(transformation(extent={{-200,-60},{-180,-40}})));
    Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloCoo(
      m_flow_nominal=sum(terUni.m1Coo_flow_nominal),
      nUni=nZon,
      disTyp=Buildings.Applications.DHC.Loads.Types.DistributionType.ChilledWater,
      have_pum=true,
      dp_nominal=100000) annotation (Placement(transformation(extent={{-140,
              -160},{-120,-140}})));
    Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum1(nin=nZon)
      annotation (Placement(transformation(extent={{240,270},{260,290}})));
    Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum2(nin=nZon)
      annotation (Placement(transformation(extent={{240,230},{260,250}})));
    GeojsonExportRC.B5a6b99ec37f4de7f94020090.Office office
      annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
    GeojsonExportRC.B5a6b99ec37f4de7f94020090.Floor floor
      annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
    GeojsonExportRC.B5a6b99ec37f4de7f94020090.Storage storage
      annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
    GeojsonExportRC.B5a6b99ec37f4de7f94020090.Meeting meeting
      annotation (Placement(transformation(extent={{20,-20},{40,0}})));
    GeojsonExportRC.B5a6b99ec37f4de7f94020090.Restroom restroom
      annotation (Placement(transformation(extent={{60,-20},{80,0}})));
    GeojsonExportRC.B5a6b99ec37f4de7f94020090.ICT iCT
      annotation (Placement(transformation(extent={{100,-20},{120,0}})));
    Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(nin=2)
      annotation (Placement(transformation(extent={{260,50},{280,70}})));
  equation
    connect(maxTSet.y,from_degC2. u) annotation (Line(points={{-278,210},{-262,210}},   color={0,0,127}));
    connect(minTSet.y, from_degC1.u)
      annotation (Line(points={{-278,250},{-262,250}},                       color={0,0,127}));
    connect(ports_a1[1],disFloHea. port_a) annotation (Line(points={{-300,-20},{-252,
            -20},{-252,-90},{-140,-90}}, color={0,127,255}));
    connect(disFloHea.port_b, ports_b1[1]) annotation (Line(points={{-120,-90},{308,
            -90},{308,-20},{300,-20}},
                                    color={0,127,255}));
    connect(ports_a1[2],disFloCoo. port_a) annotation (Line(points={{-300,20},{-252,
            20},{-252,-150},{-140,-150}},color={0,127,255}));
    connect(disFloCoo.port_b, ports_b1[2]) annotation (Line(points={{-120,-150},{308,
            -150},{308,20},{300,20}},
                                    color={0,127,255}));
    connect(from_degC1.y, terUni.TSetHea) annotation (Line(points={{-238,250},{
            -220,250},{-220,-43.3333},{-200.833,-43.3333}},
                                                       color={0,0,127}));
    connect(from_degC2.y, terUni.TSetCoo) annotation (Line(points={{-238,210},{
            -220,210},{-220,-46.6667},{-200.833,-46.6667}},
                                                       color={0,0,127}));
    connect(terUni.port_b1Hea, disFloHea.ports_a1) annotation (Line(points={{-180,
            -59.1667},{-100,-59.1667},{-100,-84},{-120,-84}}, color={0,127,255}));
    connect(terUni.port_b1Coo, disFloCoo.ports_a1) annotation (Line(points={{-180,
            -56.6667},{-80,-56.6667},{-80,-144},{-120,-144}}, color={0,127,255}));
    connect(disFloHea.ports_b1, terUni.port_a1Hea) annotation (Line(points={{-140,
            -84},{-220,-84},{-220,-59.1667},{-200,-59.1667}}, color={0,127,255}));
    connect(disFloCoo.ports_b1, terUni.port_a1Coo) annotation (Line(points={{-140,
            -144},{-240,-144},{-240,-56.6667},{-200,-56.6667}}, color={0,127,255}));
    connect(terUni.QActHea_flow, mulSum1.u) annotation (Line(points={{-179.167,
            -42.5},{-160.584,-42.5},{-160.584,280},{238,280}},
                                                        color={0,0,127}));
    connect(terUni.QActCoo_flow, mulSum2.u) annotation (Line(points={{-179.167,
            -44.1667},{-160.584,-44.1667},{-160.584,240},{238,240}},
                                                           color={0,0,127}));
    connect(mulSum1.y, QHea_flow) annotation (Line(points={{262,280},{286,280},{
            286,280},{320,280}}, color={0,0,127}));
    connect(mulSum2.y, QCoo_flow) annotation (Line(points={{262,240},{284,240},{284,
            220},{320,220}},     color={0,0,127}));
    connect(weaBus, office.weaBus) annotation (Line(
        points={{1,300},{0,300},{0,20},{-66,20},{-66,-10.2},{-96,-10.2}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(weaBus, floor.weaBus) annotation (Line(
        points={{1,300},{1,160},{0,20},{-56,20},{-56,-10.2}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-3,6},{-3,6}},
        horizontalAlignment=TextAlignment.Right));
    connect(weaBus, storage.weaBus) annotation (Line(
        points={{1,300},{0,300},{0,-10.2},{-16,-10.2}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(weaBus, meeting.weaBus) annotation (Line(
        points={{1,300},{1,20},{24,20},{24,-10.2}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-3,6},{-3,6}},
        horizontalAlignment=TextAlignment.Right));
    connect(weaBus, restroom.weaBus) annotation (Line(
        points={{1,300},{2,300},{2,20},{68,20},{68,-10.2},{64,-10.2}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(weaBus, iCT.weaBus) annotation (Line(
        points={{1,300},{0,300},{0,19.8},{104,19.8},{104,-10.2}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(terUni[1].heaPorCon, office.port_a) annotation (Line(points={{
            -193.333,-50},{-192,-50},{-192,0},{-90,0}}, color={191,0,0}));
    connect(terUni[2].heaPorCon, floor.port_a) annotation (Line(points={{-193.333,
            -50},{-192,-50},{-192,0},{-50,0}}, color={191,0,0}));
    connect(terUni[3].heaPorCon, storage.port_a) annotation (Line(points={{
            -193.333,-50},{-192,-50},{-192,0},{-10,0}}, color={191,0,0}));
    connect(terUni[4].heaPorCon, meeting.port_a) annotation (Line(points={{
            -193.333,-50},{-192,-50},{-192,0},{30,0}}, color={191,0,0}));
    connect(terUni[5].heaPorCon, restroom.port_a) annotation (Line(points={{
            -193.333,-50},{-192,-50},{-192,0},{70,0}}, color={191,0,0}));
    connect(terUni[6].heaPorCon, iCT.port_a) annotation (Line(points={{-193.333,
            -50},{-192,-50},{-192,0},{110,0}}, color={191,0,0}));
    connect(terUni[1].heaPorRad, office.port_a) annotation (Line(points={{
            -186.667,-50},{-90,-50},{-90,0}}, color={191,0,0}));
    connect(terUni[2].heaPorRad, floor.port_a) annotation (Line(points={{-186.667,
            -50},{-50,-50},{-50,0}}, color={191,0,0}));
    connect(terUni[3].heaPorRad, storage.port_a) annotation (Line(points={{
            -186.667,-50},{-10,-50},{-10,0}}, color={191,0,0}));
    connect(terUni[4].heaPorRad, meeting.port_a) annotation (Line(points={{
            -186.667,-50},{30,-50},{30,0}}, color={191,0,0}));
    connect(terUni[5].heaPorRad, restroom.port_a) annotation (Line(points={{
            -186.667,-50},{70,-50},{70,0}}, color={191,0,0}));
    connect(terUni[6].heaPorRad, iCT.port_a) annotation (Line(points={{-186.667,
            -50},{110,-50},{110,0}}, color={191,0,0}));
    connect(terUni.m1ReqHea_flow, disFloHea.m1Req_flow) annotation (Line(points={{
            -179.167,-52.5},{-179.167,-74},{-180,-74},{-180,-94},{-141,-94},{-141,
            -94}}, color={0,0,127}));
    connect(terUni.m1ReqCoo_flow, disFloCoo.m1Req_flow) annotation (Line(points={{
            -179.167,-54.1667},{-179.167,-155.083},{-141,-155.083},{-141,-154}},
          color={0,0,127}));
    connect(mulSum.y, PPum)
      annotation (Line(points={{282,60},{320,60}}, color={0,0,127}));
    connect(disFloHea.PPum, mulSum.u[1]) annotation (Line(points={{-119,-98},{240,
            -98},{240,61},{258,61}}, color={0,0,127}));
    connect(disFloCoo.PPum, mulSum.u[2]) annotation (Line(points={{-119,-158},{
            240,-158},{240,59},{258,59}}, color={0,0,127}));
    annotation (
    Documentation(info="
  <html>
  <p>
  This is a simplified multizone RC model resulting from the translation of a GeoJSON model specified
  within Urbanopt UI. It is composed of 6 thermal zones corresponding to the different load patterns.
  </p>
  </html>"),
    Diagram(coordinateSystem(extent={{-300,-300},{300,300}})), Icon(
          coordinateSystem(extent={{-100,-100},{100,100}})));
  end BuildingRCZ6GeojsonPump;

  model BuildingSpawnZ1 "Spawn building model (1 zone)"
    import Buildings;
    extends Buildings.Applications.DHC.Loads.BaseClasses.PartialBuilding(
      have_pum=false,
      have_eleHea=false,
      have_eleCoo=false,
      nPorts1=2);
    package Medium2 = Buildings.Media.Air
      "Load side medium";
    parameter Integer nZon = 1
      "Number of thermal zones";
    parameter String idfPat=
      "modelica://Buildings/Resources/Data/Experimental/EnergyPlus/Validation/RefBldgSmallOfficeNew2004_Chicago.idf"
      "Path of the IDF file";
    parameter String weaPat=
      "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"
      "Path of the weather file";
    Buildings.Applications.DHC.Loads.Validation.BaseClasses.Terminal4PipesFluidPorts
      terUni(
      QHea_flow_nominal=10000,
      QCoo_flow_nominal=10000,
      T_a2Hea_nominal=293.15,
      T_a2Coo_nominal=297.15,
      T_b1Hea_nominal=308.15,
      T_b1Coo_nominal=285.15,
      T_a1Hea_nominal=313.15,
      T_a1Coo_nominal=280.15,
      m2Hea_flow_nominal=5,
      m2Coo_flow_nominal=5)
      annotation (Placement(transformation(extent={{-160,-60},{-140,-40}})));
    Modelica.Blocks.Sources.Constant qConGai_flow(k=0) "Convective heat gain"
      annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
    Modelica.Blocks.Sources.Constant qRadGai_flow(k=0) "Radiative heat gain"
      annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
    Modelica.Blocks.Routing.Multiplex3 multiplex3_1
      annotation (Placement(transformation(extent={{-34,60},{-14,80}})));
    Modelica.Blocks.Sources.Constant qLatGai_flow(k=0) "Latent heat gain"
      annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
    Buildings.Experimental.EnergyPlus.ThermalZone zon(
      redeclare package Medium = Medium2,
      zoneName="Core_ZN",
      nPorts=2)
      "Thermal zone"
      annotation (Placement(transformation(extent={{40,-20},{80,20}})));
    inner Buildings.Experimental.EnergyPlus.Building building(
      idfName=Modelica.Utilities.Files.loadResource(idfPat),
      weaName=Modelica.Utilities.Files.loadResource(weaPat),
      fmuName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/src/EnergyPlus/FMUs/Zones1.fmu"),
      showWeatherData=false)
      "Building model"
      annotation (Placement(transformation(extent={{40,60},{60,80}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTSet(k=20) "Minimum temperature setpoint"
      annotation (Placement(transformation(extent={{-300,250},{-280,270}})));
    Buildings.Controls.OBC.UnitConversions.From_degC from_degC1
      annotation (Placement(transformation(extent={{-260,250},{-240,270}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTSet(k=24) "Minimum temperature setpoint"
      annotation (Placement(transformation(extent={{-300,210},{-280,230}})));
    Buildings.Controls.OBC.UnitConversions.From_degC from_degC2
      annotation (Placement(transformation(extent={{-260,210},{-240,230}})));
    Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloHea(
      nUni=nZon,
      m_flow_nominal=terUni.m1Hea_flow_nominal,
      dp_nominal=100000)
      annotation (Placement(transformation(extent={{-120,-120},{-100,-100}})));
    Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloCoo(
      nUni=nZon,
      m_flow_nominal=terUni.m1Coo_flow_nominal,
      disTyp=Buildings.Applications.DHC.Loads.Types.DistributionType.ChilledWater,
      dp_nominal=100000)
      annotation (Placement(transformation(extent={{-120, -160},{-100,-140}})));
  equation
    connect(qRadGai_flow.y,multiplex3_1.u1[1])  annotation (Line(
        points={{-59,110},{-40,110},{-40,77},{-36,77}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(qConGai_flow.y,multiplex3_1.u2[1]) annotation (Line(
        points={{-59,70},{-48,70},{-42,70},{-36,70}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(multiplex3_1.u3[1],qLatGai_flow.y)
      annotation (Line(points={{-36,63},{-40,63},{-40,30},{-59,30}},  color={0,0,127}));
    connect(multiplex3_1.y, zon.qGai_flow) annotation (Line(points={{-13,70},{16,70},
            {16,10},{38,10}},                                                                       color={0,0,127}));
    connect(minTSet.y,from_degC1. u) annotation (Line(points={{-278,260},{-262,
            260}},                                                                  color={0,0,127}));
    connect(maxTSet.y,from_degC2. u) annotation (Line(points={{-278,220},{-262,
            220}},                                                                  color={0,0,127}));
    connect(ports_a1[1], disFloHea.port_a) annotation (Line(points={{-300,-20},{-280,
            -20},{-280,-110},{-120,-110}}, color={0,127,255}));
    connect(disFloHea.port_b, ports_b1[1]) annotation (Line(points={{-100,-110},{280,
            -110},{280,-20},{300,-20}}, color={0,127,255}));
    connect(ports_a1[2], disFloCoo.port_a) annotation (Line(points={{-300,20},{-280,
            20},{-280,-150},{-120,-150}}, color={0,127,255}));
    connect(disFloCoo.port_b, ports_b1[2]) annotation (Line(points={{-100,-150},{280,
            -150},{280,20},{300,20}}, color={0,127,255}));
    connect(zon.ports[1], terUni.port_a2) annotation (Line(points={{58,-19.2},{62,
            -19.2},{62,-40.8333},{-140,-40.8333}},
                                         color={0,127,255}));
    connect(terUni.port_b1Hea, disFloHea.ports_a1[1]) annotation (Line(points={{-140,
            -59.1667},{-140,-59.5833},{-100,-59.5833},{-100,-104}}, color={0,127,255}));
    connect(terUni.port_b1Coo, disFloCoo.ports_a1[1]) annotation (Line(points={{-140,
            -56.6667},{-80,-56.6667},{-80,-144},{-100,-144}}, color={0,127,255}));
    connect(disFloHea.ports_b1[1], terUni.port_a1Hea) annotation (Line(points={{-120,
            -104},{-180,-104},{-180,-59.1667},{-160,-59.1667}}, color={0,127,255}));
    connect(disFloCoo.ports_b1[1], terUni.port_a1Coo) annotation (Line(points={{-120,
            -144},{-200,-144},{-200,-56.6667},{-160,-56.6667}}, color={0,127,255}));
    connect(from_degC2.y, terUni.TSetCoo) annotation (Line(points={{-238,220},{
            -200,220},{-200,-46.6667},{-160.833,-46.6667}},
                                                       color={0,0,127}));
    connect(from_degC1.y, terUni.TSetHea) annotation (Line(points={{-238,260},{
            -200,260},{-200,-43.3333},{-160.833,-43.3333}},
                                                       color={0,0,127}));
    connect(terUni.QActHea_flow, QHea_flow) annotation (Line(points={{-139.167,
            -42.5},{-130,-42.5},{-130,-42},{-120,-42},{-120,280},{320,280}},
                                                                      color={0,0,127}));
    connect(terUni.QActCoo_flow, QCoo_flow) annotation (Line(points={{-139.167,
            -44.1667},{-139.167,-46},{-120,-46},{-120,220},{320,220}},
                                                             color={0,0,127}));
    connect(terUni.PFan, PFan) annotation (Line(points={{-139.167,-49.1667},{260,
            -49.1667},{260,100},{320,100}},
                                  color={0,0,127}));
    connect(terUni.m1ReqHea_flow, disFloHea.m1Req_flow[1]) annotation (Line(
          points={{-139.167,-52.5},{-139.167,-115.083},{-121,-115.083},{-121,-114}},
          color={0,0,127}));
    connect(terUni.m1ReqCoo_flow, disFloCoo.m1Req_flow[1]) annotation (Line(
          points={{-139.167,-54.1667},{-139.167,-104},{-140,-104},{-140,-154},{
            -121,-154},{-121,-154}}, color={0,0,127}));
    connect(terUni.port_b2, zon.ports[2]) annotation (Line(points={{-160,-40.8333},
            {-172,-40.8333},{-172,-40},{-180,-40},{-180,-19.2},{62,-19.2}}, color=
           {0,127,255}));
    annotation (
    Documentation(info="
  <html>
  <p>
  This is a simplified multizone RC model resulting from the translation of a GeoJSON model specified
  within Urbanopt UI. It is composed of 6 thermal zones corresponding to the different load patterns.
  </p>
  </html>"),
    Diagram(coordinateSystem(extent={{-300,-300},{300,300}})), Icon(
          coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
            Bitmap(extent={{-108,-100},{92,100}},  fileName="modelica://Buildings/Resources/Images/Experimental/EnergyPlus/EnergyPlusLogo.png")}));
  end BuildingSpawnZ1;

  model BuildingSpawnZ6Geojson
    "Spawn building model (6 zones) based on URBANopt GeoJSON export"
    extends Buildings.Applications.DHC.Loads.BaseClasses.PartialBuilding(
      final have_eleHea=false,
      final have_eleCoo=false,
      final have_pum=false,
      final have_weaBus=false,
      nPorts1=2);
    package Medium2 = Buildings.Media.Air "Medium model";
    parameter Integer nZon = 6
      "Number of thermal zones";
    parameter String idfPat=
      "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportSpawn/Resources/Data/B5a6b99ec37f4de7f94020090/RefBldgSmallOfficeNew2004_Chicago.idf"
      "Path of the IDF file";
    parameter String weaPat=
      "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportSpawn/Resources/Data/B5a6b99ec37f4de7f94020090/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"
      "Path of the weather file";
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTSet[nZon](k=fill(20,
          nZon))        "Minimum temperature setpoint"
      annotation (Placement(transformation(extent={{-300,250},{-280,270}})));
    Buildings.Controls.OBC.UnitConversions.From_degC from_degC1[nZon]
      annotation (Placement(transformation(extent={{-260,250},{-240,270}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTSet[nZon](k=fill(24,
          nZon))        "Maximum temperature setpoint"
      annotation (Placement(transformation(extent={{-300,210},{-280,230}})));
    Buildings.Controls.OBC.UnitConversions.From_degC from_degC2[nZon]
      annotation (Placement(transformation(extent={{-260,210},{-240,230}})));
    Modelica.Blocks.Sources.Constant qConGai_flow(k=0) "Convective heat gain"
      annotation (Placement(transformation(extent={{-60,180},{-40,200}})));
    Modelica.Blocks.Sources.Constant qRadGai_flow(k=0) "Radiative heat gain"
      annotation (Placement(transformation(extent={{-60,220},{-40,240}})));
    Modelica.Blocks.Routing.Multiplex3 multiplex3_1
      annotation (Placement(transformation(extent={{-14,180},{6,200}})));
    Modelica.Blocks.Sources.Constant qLatGai_flow(k=0) "Latent heat gain"
      annotation (Placement(transformation(extent={{-60,140},{-40,160}})));
    Buildings.Experimental.EnergyPlus.ThermalZone znAttic(
      redeclare package Medium = Medium2,
      zoneName="Attic",
      nPorts=2)        "Thermal zone"
      annotation (Placement(transformation(extent={{24,84},{64,124}})));
    Buildings.Experimental.EnergyPlus.ThermalZone znCore_ZN(
      redeclare package Medium = Medium2,
      zoneName="Core_ZN",
      nPorts=2)          "Thermal zone"
      annotation (Placement(transformation(extent={{24,42},{64,82}})));
    Buildings.Experimental.EnergyPlus.ThermalZone znPerimeter_ZN_1(
      redeclare package Medium = Medium2,
      zoneName="Perimeter_ZN_1",
      nPorts=2)                 "Thermal zone"
      annotation (Placement(transformation(extent={{24,0},{64,40}})));
    Buildings.Experimental.EnergyPlus.ThermalZone znPerimeter_ZN_2(
      redeclare package Medium = Medium2,
      zoneName="Perimeter_ZN_2",
      nPorts=2)                 "Thermal zone"
      annotation (Placement(transformation(extent={{24,-40},{64,0}})));
    Buildings.Experimental.EnergyPlus.ThermalZone znPerimeter_ZN_3(
      redeclare package Medium = Medium2,
      zoneName="Perimeter_ZN_3",
      nPorts=2)                 "Thermal zone"
      annotation (Placement(transformation(extent={{24,-80},{64,-40}})));
    Buildings.Experimental.EnergyPlus.ThermalZone znPerimeter_ZN_4(
      redeclare package Medium = Medium2,
      zoneName="Perimeter_ZN_4",
      nPorts=2)                 "Thermal zone"
      annotation (Placement(transformation(extent={{24,-120},{64,-80}})));
    inner Buildings.Experimental.EnergyPlus.Building building(
      idfName=Modelica.Utilities.Files.loadResource(idfPat),
      weaName=Modelica.Utilities.Files.loadResource(weaPat))
      "Building outer component"
      annotation (Placement(transformation(extent={{30,198},{52,218}})));
    Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloHea(
      m_flow_nominal=sum(terUni.m1Hea_flow_nominal),
      dp_nominal=100000,
      nUni=nZon) annotation (Placement(transformation(extent={{-238,-190},{
              -218,-170}})));
    Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloCoo(
      m_flow_nominal=sum(terUni.m1Coo_flow_nominal),
      disTyp=Buildings.Applications.DHC.Loads.Types.DistributionType.ChilledWater,
      nUni=nZon,
      dp_nominal=100000) annotation (Placement(transformation(extent={{-180,
              -230},{-160,-210}})));

    Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(nin=6)
      annotation (Placement(transformation(extent={{220,110},{240,130}})));
    Buildings.Applications.DHC.Loads.Validation.BaseClasses.Terminal4PipesFluidPorts
      terUni[nZon](
      QHea_flow_nominal={50000,10000,10000,10000,10000,10000},
      QCoo_flow_nominal={10000,10000,10000,10000,10000,10000},
      each T_a2Hea_nominal=293.15,
      each T_a2Coo_nominal=297.15,
      each T_b1Hea_nominal=308.15,
      each T_b1Coo_nominal=285.15,
      each T_a1Hea_nominal=313.15,
      each T_a1Coo_nominal=280.15,
      each m2Hea_flow_nominal=5,
      each m2Coo_flow_nominal=5)
      annotation (Placement(transformation(extent={{-86,-2},{-62,22}})));
    Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum1(nin=nZon)
      annotation (Placement(transformation(extent={{220,270},{240,290}})));
    Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum2(nin=nZon)
      annotation (Placement(transformation(extent={{220,230},{240,250}})));
  equation
    connect(maxTSet.y,from_degC2.u)
      annotation (Line(points={{-278,220},{-262,220}}, color={0,0,127}));
    connect(minTSet.y, from_degC1.u)
      annotation (Line(points={{-278,260},{-262,260}}, color={0,0,127}));
    connect(qRadGai_flow.y,multiplex3_1.u1[1])  annotation (Line(
        points={{-39,230},{-20,230},{-20,197},{-16,197}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(qConGai_flow.y,multiplex3_1.u2[1])
      annotation (Line(
        points={{-39,190},{-50,190},{-44,190},{-16,190}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(multiplex3_1.u3[1],qLatGai_flow.y)
      annotation (Line(points={{-16,183},{-20,183},{-20,150},{-39,150}}, color={0,0,127}));
    connect(multiplex3_1.y,znAttic.qGai_flow)
      annotation (Line(points={{7,190},{20,190},{20,114},{22,114}}, color={0,0,127}));
    connect(multiplex3_1.y,znCore_ZN.qGai_flow)
      annotation (Line(points={{7,190},{20,190},{20,72},{22,72}}, color={0,0,127}));
    connect(multiplex3_1.y,znPerimeter_ZN_1.qGai_flow)
      annotation (Line(points={{7,190},{20,190},{20,30},{22,30}}, color={0,0,127}));
    connect(multiplex3_1.y,znPerimeter_ZN_2.qGai_flow)
        annotation (Line(points={{7,190},{20,190},{20,-10},{22,-10}}, color={0,0,127}));
    connect(multiplex3_1.y,znPerimeter_ZN_3.qGai_flow)
      annotation (Line(points={{7,190},{20,190},{20,-50},{22,-50}}, color={0,0,127}));
    connect(multiplex3_1.y,znPerimeter_ZN_4.qGai_flow)
      annotation (Line(points={{7,190},{20,190},{20,-90},{22,-90}}, color={0,0,127}));
    connect(ports_a1[1], disFloHea.port_a)
      annotation (Line(points={{-300,-20},{-280,-20},{-280,-180},{-238,-180}},
                                           color={0,127,255}));
    connect(disFloHea.port_b, ports_b1[1])
      annotation (Line(points={{-218,-180},{260,-180},{260,-20},{300,-20}},
                                        color={0,127,255}));
    connect(ports_a1[2], disFloCoo.port_a) annotation (Line(points={{-300,20},{-280,
            20},{-280,-220},{-180,-220}}, color={0,127,255}));
    connect(disFloCoo.port_b, ports_b1[2]) annotation (Line(points={{-160,-220},{280,
            -220},{280,20},{300,20}}, color={0,127,255}));
    connect(from_degC1.y, terUni.TSetHea) annotation (Line(points={{-238,260},{-162,
            260},{-162,18},{-87,18}}, color={0,0,127}));
    connect(from_degC2.y, terUni.TSetCoo) annotation (Line(points={{-238,220},{-162,
            220},{-162,14},{-87,14}}, color={0,0,127}));
    connect(znAttic.ports[1], terUni[1].port_a2) annotation (Line(points={{42,84.8},
            {-8,84.8},{-8,21},{-62,21}},       color={0,127,255}));
    connect(terUni[1].port_b2, znAttic.ports[2]) annotation (Line(points={{-86,21},
            {-20,21},{-20,84.8},{46,84.8}},      color={0,127,255}));
    connect(znCore_ZN.ports[1], terUni[2].port_a2) annotation (Line(points={{42,42.8},
            {-8,42.8},{-8,21},{-62,21}},       color={0,127,255}));
    connect(terUni[2].port_b2, znCore_ZN.ports[2]) annotation (Line(points={{-86,21},
            {-20,21},{-20,42.8},{46,42.8}},      color={0,127,255}));
    connect(znPerimeter_ZN_1.ports[1], terUni[3].port_a2) annotation (Line(points={{42,0.8},
            {-8,0.8},{-8,21},{-62,21}},               color={0,127,255}));
    connect(terUni[3].port_b2, znPerimeter_ZN_1.ports[2]) annotation (Line(points={{-86,21},
            {-20,21},{-20,0.8},{46,0.8}},               color={0,127,255}));
    connect(znPerimeter_ZN_2.ports[1], terUni[4].port_a2) annotation (Line(points={{42,
            -39.2},{-8,-39.2},{-8,21},{-62,21}},          color={0,127,255}));
    connect(terUni[4].port_b2, znPerimeter_ZN_2.ports[2]) annotation (Line(points={{-86,21},
            {-20,21},{-20,-39.2},{46,-39.2}},               color={0,127,255}));
    connect(znPerimeter_ZN_3.ports[1], terUni[5].port_a2) annotation (Line(points={{42,
            -79.2},{-8,-79.2},{-8,21},{-62,21}},          color={0,127,255}));
    connect(terUni[5].port_b2, znPerimeter_ZN_3.ports[2]) annotation (Line(points={{-86,21},
            {-20,21},{-20,-79.2},{46,-79.2}},               color={0,127,255}));
    connect(znPerimeter_ZN_4.ports[1], terUni[6].port_a2) annotation (Line(points={{42,
            -119.2},{-8,-119.2},{-8,21},{-62,21}},          color={0,127,255}));
    connect(terUni[6].port_b2, znPerimeter_ZN_4.ports[2]) annotation (Line(points={{-86,21},
            {-20,21},{-20,-119.2},{46,-119.2}},               color={0,127,255}));
    connect(terUni.port_b1Hea, disFloHea.ports_a1) annotation (Line(points={{-62,-1},
            {-40,-1},{-40,-174},{-218,-174}}, color={0,127,255}));
    connect(disFloHea.ports_b1, terUni.port_a1Hea) annotation (Line(points={{-238,
            -174},{-260,-174},{-260,-1},{-86,-1}}, color={0,127,255}));
    connect(disFloCoo.ports_b1, terUni.port_a1Coo) annotation (Line(points={{-180,
            -214},{-260,-214},{-260,2},{-86,2}}, color={0,127,255}));
    connect(terUni.port_b1Coo, disFloCoo.ports_a1) annotation (Line(points={{-62,2},
            {-38,2},{-38,-214},{-160,-214}}, color={0,127,255}));
    connect(mulSum1.y, QHea_flow)
      annotation (Line(points={{242,280},{320,280}}, color={0,0,127}));
    connect(mulSum2.y, QCoo_flow)
      annotation (Line(points={{242,240},{282,240},{282,220},{320,220}},
                                                     color={0,0,127}));
    connect(terUni.QActHea_flow, mulSum1.u[1:6]) annotation (Line(points={{-61,19},
            {79.5,19},{79.5,280},{218,280}},         color={0,0,127}));
    connect(terUni.QActCoo_flow, mulSum2.u) annotation (Line(points={{-61,17},{78.5,
            17},{78.5,240},{218,240}}, color={0,0,127}));
    connect(terUni.m1ReqCoo_flow, disFloCoo.m1Req_flow) annotation (Line(points={{-61,5},
            {-61,-110.5},{-181,-110.5},{-181,-224}},        color={0,0,127}));
    connect(terUni.m1ReqHea_flow, disFloHea.m1Req_flow) annotation (Line(points={{-61,7},
            {-61,-88.5},{-239,-88.5},{-239,-184}},        color={0,0,127}));
    connect(terUni.PFan, mulSum.u[1:6]) annotation (Line(points={{-61,11},{200.5,
            11},{200.5,118.333},{218,118.333}}, color={0,0,127}));
    connect(mulSum.y, PFan) annotation (Line(points={{242,120},{278,120},{278,100},
            {320,100}}, color={0,0,127}));
    annotation (
    Documentation(info="
  <html>
  <p>
  This is a simplified multizone RC model resulting from the translation of a GeoJSON model specified
  within Urbanopt UI. It is composed of 6 thermal zones corresponding to the different load patterns.
  </p>
  </html>"),
    Diagram(coordinateSystem(extent={{-300,-300},{300,300}})), Icon(
          coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
            Bitmap(extent={{-108,-100},{92,100}},  fileName="modelica://Buildings/Resources/Images/Experimental/EnergyPlus/EnergyPlusLogo.png")}));
  end BuildingSpawnZ6Geojson;

  model BuildingSpawnZ6GeojsonPump
    "Spawn building model (6 zones) based on URBANopt GeoJSON export, with distribution pumps"
    extends Buildings.Applications.DHC.Loads.BaseClasses.PartialBuilding(
      final have_eleHea=false,
      final have_eleCoo=false,
      final have_pum=true,
      final have_weaBus=false,
      nPorts1=2);
    package Medium2 = Buildings.Media.Air "Medium model";
    parameter Integer nZon = 6
      "Number of thermal zones";
    parameter String idfPat=
      "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportSpawn/Resources/Data/B5a6b99ec37f4de7f94020090/RefBldgSmallOfficeNew2004_Chicago.idf"
      "Path of the IDF file";
    parameter String weaPat=
      "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportSpawn/Resources/Data/B5a6b99ec37f4de7f94020090/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"
      "Path of the weather file";
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTSet[nZon](k=fill(20,
          nZon))        "Minimum temperature setpoint"
      annotation (Placement(transformation(extent={{-300,250},{-280,270}})));
    Buildings.Controls.OBC.UnitConversions.From_degC from_degC1[nZon]
      annotation (Placement(transformation(extent={{-260,250},{-240,270}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTSet[nZon](k=fill(24,
          nZon))        "Maximum temperature setpoint"
      annotation (Placement(transformation(extent={{-300,210},{-280,230}})));
    Buildings.Controls.OBC.UnitConversions.From_degC from_degC2[nZon]
      annotation (Placement(transformation(extent={{-260,210},{-240,230}})));
    Modelica.Blocks.Sources.Constant qConGai_flow(k=0) "Convective heat gain"
      annotation (Placement(transformation(extent={{-60,180},{-40,200}})));
    Modelica.Blocks.Sources.Constant qRadGai_flow(k=0) "Radiative heat gain"
      annotation (Placement(transformation(extent={{-60,220},{-40,240}})));
    Modelica.Blocks.Routing.Multiplex3 multiplex3_1
      annotation (Placement(transformation(extent={{-14,180},{6,200}})));
    Modelica.Blocks.Sources.Constant qLatGai_flow(k=0) "Latent heat gain"
      annotation (Placement(transformation(extent={{-60,140},{-40,160}})));
    Buildings.Experimental.EnergyPlus.ThermalZone znAttic(
      redeclare package Medium = Medium2,
      zoneName="Attic",
      nPorts=2)        "Thermal zone"
      annotation (Placement(transformation(extent={{24,84},{64,124}})));
    Buildings.Experimental.EnergyPlus.ThermalZone znCore_ZN(
      redeclare package Medium = Medium2,
      zoneName="Core_ZN",
      nPorts=2)          "Thermal zone"
      annotation (Placement(transformation(extent={{24,42},{64,82}})));
    Buildings.Experimental.EnergyPlus.ThermalZone znPerimeter_ZN_1(
      redeclare package Medium = Medium2,
      zoneName="Perimeter_ZN_1",
      nPorts=2)                 "Thermal zone"
      annotation (Placement(transformation(extent={{24,0},{64,40}})));
    Buildings.Experimental.EnergyPlus.ThermalZone znPerimeter_ZN_2(
      redeclare package Medium = Medium2,
      zoneName="Perimeter_ZN_2",
      nPorts=2)                 "Thermal zone"
      annotation (Placement(transformation(extent={{24,-40},{64,0}})));
    Buildings.Experimental.EnergyPlus.ThermalZone znPerimeter_ZN_3(
      redeclare package Medium = Medium2,
      zoneName="Perimeter_ZN_3",
      nPorts=2)                 "Thermal zone"
      annotation (Placement(transformation(extent={{24,-80},{64,-40}})));
    Buildings.Experimental.EnergyPlus.ThermalZone znPerimeter_ZN_4(
      redeclare package Medium = Medium2,
      zoneName="Perimeter_ZN_4",
      nPorts=2)                 "Thermal zone"
      annotation (Placement(transformation(extent={{24,-120},{64,-80}})));
    inner Buildings.Experimental.EnergyPlus.Building building(
      idfName=Modelica.Utilities.Files.loadResource(idfPat),
      weaName=Modelica.Utilities.Files.loadResource(weaPat))
      "Building outer component"
      annotation (Placement(transformation(extent={{30,198},{52,218}})));
    Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloHea(
      m_flow_nominal=sum(terUni.m1Hea_flow_nominal),
      have_pum=true,
      dp_nominal=100000,
      nUni=nZon)
      annotation (Placement(transformation(extent={{-238,-190},{
              -218,-170}})));
    Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloCoo(
      m_flow_nominal=sum(terUni.m1Coo_flow_nominal),
      disTyp=Buildings.Applications.DHC.Loads.Types.DistributionType.ChilledWater,
      nUni=nZon,
      have_pum=true,
      dp_nominal=100000) annotation (Placement(transformation(extent={{-180,
              -230},{-160,-210}})));

    Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(nin=6)
      annotation (Placement(transformation(extent={{260,110},{280,130}})));
    Buildings.Applications.DHC.Loads.Validation.BaseClasses.Terminal4PipesFluidPorts
      terUni[nZon](
      QHea_flow_nominal={50000,10000,10000,10000,10000,10000},
      QCoo_flow_nominal={10000,10000,10000,10000,10000,10000},
      each T_a2Hea_nominal=293.15,
      each T_a2Coo_nominal=297.15,
      each T_b1Hea_nominal=308.15,
      each T_b1Coo_nominal=285.15,
      each T_a1Hea_nominal=313.15,
      each T_a1Coo_nominal=280.15,
      each m2Hea_flow_nominal=5,
      each m2Coo_flow_nominal=5)
      annotation (Placement(transformation(extent={{-86,-2},{-62,22}})));
    Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum1(nin=nZon)
      annotation (Placement(transformation(extent={{260,270},{280,290}})));
    Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum2(nin=nZon)
      annotation (Placement(transformation(extent={{260,230},{280,250}})));
    Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum3(nin=2)
      annotation (Placement(transformation(extent={{260,70},{280,90}})));
  equation
    connect(maxTSet.y,from_degC2.u)
      annotation (Line(points={{-278,220},{-262,220}}, color={0,0,127}));
    connect(minTSet.y, from_degC1.u)
      annotation (Line(points={{-278,260},{-262,260}}, color={0,0,127}));
    connect(qRadGai_flow.y,multiplex3_1.u1[1])  annotation (Line(
        points={{-39,230},{-20,230},{-20,197},{-16,197}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(qConGai_flow.y,multiplex3_1.u2[1])
      annotation (Line(
        points={{-39,190},{-50,190},{-44,190},{-16,190}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(multiplex3_1.u3[1],qLatGai_flow.y)
      annotation (Line(points={{-16,183},{-20,183},{-20,150},{-39,150}}, color={0,0,127}));
    connect(multiplex3_1.y,znAttic.qGai_flow)
      annotation (Line(points={{7,190},{20,190},{20,114},{22,114}}, color={0,0,127}));
    connect(multiplex3_1.y,znCore_ZN.qGai_flow)
      annotation (Line(points={{7,190},{20,190},{20,72},{22,72}}, color={0,0,127}));
    connect(multiplex3_1.y,znPerimeter_ZN_1.qGai_flow)
      annotation (Line(points={{7,190},{20,190},{20,30},{22,30}}, color={0,0,127}));
    connect(multiplex3_1.y,znPerimeter_ZN_2.qGai_flow)
        annotation (Line(points={{7,190},{20,190},{20,-10},{22,-10}}, color={0,0,127}));
    connect(multiplex3_1.y,znPerimeter_ZN_3.qGai_flow)
      annotation (Line(points={{7,190},{20,190},{20,-50},{22,-50}}, color={0,0,127}));
    connect(multiplex3_1.y,znPerimeter_ZN_4.qGai_flow)
      annotation (Line(points={{7,190},{20,190},{20,-90},{22,-90}}, color={0,0,127}));
    connect(ports_a1[1], disFloHea.port_a)
      annotation (Line(points={{-300,-20},{-280,-20},{-280,-180},{-238,-180}},
                                           color={0,127,255}));
    connect(disFloHea.port_b, ports_b1[1])
      annotation (Line(points={{-218,-180},{260,-180},{260,-20},{300,-20}},
                                        color={0,127,255}));
    connect(ports_a1[2], disFloCoo.port_a) annotation (Line(points={{-300,20},{-280,
            20},{-280,-220},{-180,-220}}, color={0,127,255}));
    connect(disFloCoo.port_b, ports_b1[2]) annotation (Line(points={{-160,-220},{280,
            -220},{280,20},{300,20}}, color={0,127,255}));
    connect(from_degC1.y, terUni.TSetHea) annotation (Line(points={{-238,260},{-162,
            260},{-162,18},{-87,18}}, color={0,0,127}));
    connect(from_degC2.y, terUni.TSetCoo) annotation (Line(points={{-238,220},{-162,
            220},{-162,14},{-87,14}}, color={0,0,127}));
    connect(znAttic.ports[1], terUni[1].port_a2) annotation (Line(points={{42,84.8},
            {-8,84.8},{-8,21},{-62,21}},       color={0,127,255}));
    connect(terUni[1].port_b2, znAttic.ports[2]) annotation (Line(points={{-86,21},
            {-20,21},{-20,84.8},{46,84.8}},      color={0,127,255}));
    connect(znCore_ZN.ports[1], terUni[2].port_a2) annotation (Line(points={{42,42.8},
            {-8,42.8},{-8,21},{-62,21}},       color={0,127,255}));
    connect(terUni[2].port_b2, znCore_ZN.ports[2]) annotation (Line(points={{-86,21},
            {-20,21},{-20,42.8},{46,42.8}},      color={0,127,255}));
    connect(znPerimeter_ZN_1.ports[1], terUni[3].port_a2) annotation (Line(points={{42,0.8},
            {-8,0.8},{-8,21},{-62,21}},               color={0,127,255}));
    connect(terUni[3].port_b2, znPerimeter_ZN_1.ports[2]) annotation (Line(points={{-86,21},
            {-20,21},{-20,0.8},{46,0.8}},               color={0,127,255}));
    connect(znPerimeter_ZN_2.ports[1], terUni[4].port_a2) annotation (Line(points={{42,
            -39.2},{-8,-39.2},{-8,21},{-62,21}},          color={0,127,255}));
    connect(terUni[4].port_b2, znPerimeter_ZN_2.ports[2]) annotation (Line(points={{-86,21},
            {-20,21},{-20,-39.2},{46,-39.2}},               color={0,127,255}));
    connect(znPerimeter_ZN_3.ports[1], terUni[5].port_a2) annotation (Line(points={{42,
            -79.2},{-8,-79.2},{-8,21},{-62,21}},          color={0,127,255}));
    connect(terUni[5].port_b2, znPerimeter_ZN_3.ports[2]) annotation (Line(points={{-86,21},
            {-20,21},{-20,-79.2},{46,-79.2}},               color={0,127,255}));
    connect(znPerimeter_ZN_4.ports[1], terUni[6].port_a2) annotation (Line(points={{42,
            -119.2},{-8,-119.2},{-8,21},{-62,21}},          color={0,127,255}));
    connect(terUni[6].port_b2, znPerimeter_ZN_4.ports[2]) annotation (Line(points={{-86,21},
            {-20,21},{-20,-119.2},{46,-119.2}},               color={0,127,255}));
    connect(terUni.port_b1Hea, disFloHea.ports_a1) annotation (Line(points={{-62,-1},
            {-40,-1},{-40,-174},{-218,-174}}, color={0,127,255}));
    connect(disFloHea.ports_b1, terUni.port_a1Hea) annotation (Line(points={{-238,
            -174},{-260,-174},{-260,-1},{-86,-1}}, color={0,127,255}));
    connect(disFloCoo.ports_b1, terUni.port_a1Coo) annotation (Line(points={{-180,
            -214},{-260,-214},{-260,2},{-86,2}}, color={0,127,255}));
    connect(terUni.port_b1Coo, disFloCoo.ports_a1) annotation (Line(points={{-62,2},
            {-38,2},{-38,-214},{-160,-214}}, color={0,127,255}));
    connect(mulSum1.y, QHea_flow)
      annotation (Line(points={{282,280},{320,280}}, color={0,0,127}));
    connect(mulSum2.y, QCoo_flow)
      annotation (Line(points={{282,240},{302,240},{302,220},{320,220}},
                                                     color={0,0,127}));
    connect(terUni.QActHea_flow, mulSum1.u[1:6]) annotation (Line(points={{-61,19},
            {79.5,19},{79.5,280},{258,280}},         color={0,0,127}));
    connect(terUni.QActCoo_flow, mulSum2.u) annotation (Line(points={{-61,17},{
            78.5,17},{78.5,240},{258,240}},
                                       color={0,0,127}));
    connect(terUni.m1ReqCoo_flow, disFloCoo.m1Req_flow) annotation (Line(points={{-61,5},
            {-61,-110.5},{-181,-110.5},{-181,-224}},        color={0,0,127}));
    connect(terUni.m1ReqHea_flow, disFloHea.m1Req_flow) annotation (Line(points={{-61,7},
            {-61,-88.5},{-239,-88.5},{-239,-184}},        color={0,0,127}));
    connect(terUni.PFan, mulSum.u[1:6]) annotation (Line(points={{-61,11},{200.5,
            11},{200.5,118.333},{258,118.333}}, color={0,0,127}));
    connect(mulSum.y, PFan) annotation (Line(points={{282,120},{302,120},{302,100},
            {320,100}}, color={0,0,127}));
    connect(PPum, mulSum3.y)
      annotation (Line(points={{320,60},{302,60},{302,80},{282,80}},
                                                   color={0,0,127}));
    connect(disFloHea.PPum, mulSum3.u[1]) annotation (Line(points={{-217,-188},{
            220.5,-188},{220.5,81},{258,81}}, color={0,0,127}));
    connect(disFloCoo.PPum, mulSum3.u[2]) annotation (Line(points={{-159,-228},{
            224,-228},{224,79},{258,79}}, color={0,0,127}));
    annotation (
    Documentation(info="
  <html>
  <p>
  This is a simplified multizone RC model resulting from the translation of a GeoJSON model specified
  within Urbanopt UI. It is composed of 6 thermal zones corresponding to the different load patterns.
  </p>
  </html>"),
    Diagram(coordinateSystem(extent={{-300,-300},{300,300}})), Icon(
          coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
            Bitmap(extent={{-108,-100},{92,100}},  fileName="modelica://Buildings/Resources/Images/Experimental/EnergyPlus/EnergyPlusLogo.png")}));
  end BuildingSpawnZ6GeojsonPump;

  model Terminal4PipesFluidPorts
    extends Buildings.Applications.DHC.Loads.BaseClasses.PartialTerminalUnit(
      final heaFunSpe=Buildings.Applications.DHC.Loads.Types.TerminalFunctionSpec.Water,
      final cooFunSpe=Buildings.Applications.DHC.Loads.Types.TerminalFunctionSpec.Water,
      final have_heaPor=false,
      final have_fluPor=true,
      final have_weaBus=false,
      final have_fan=true,
      final have_pum=false,
      final m1Hea_flow_nominal=abs(QHea_flow_nominal/cp1Hea_nominal/(
          T_a1Hea_nominal - T_b1Hea_nominal)),
      final m1Coo_flow_nominal=abs(QCoo_flow_nominal/cp1Coo_nominal/(
          T_a1Coo_nominal - T_b1Coo_nominal)));

    Buildings.Controls.OBC.CDL.Continuous.LimPID conTMin(
      each Ti=120,
      each yMax=1,
      each controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
      reverseAction=false,
      each yMin=0) "PI controller for minimum indoor temperature"
      annotation (Placement(transformation(extent={{-10,210},{10,230}})));
    Buildings.Fluid.Movers.FlowControlled_m_flow fan(
      redeclare each final package Medium=Medium2,
      energyDynamics=energyDynamics,
      m_flow_nominal=max({m2Hea_flow_nominal, m2Coo_flow_nominal}),
      redeclare Fluid.Movers.Data.Generic per,
      nominalValuesDefineDefaultPressureCurve=true,
      dp_nominal=200,
      final allowFlowReversal=allowFlowReversal)
      annotation (Placement(transformation(extent={{90,-10},{70,10}})));
    Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU hexHea(
      redeclare final package Medium1=Medium1,
      redeclare final package Medium2=Medium2,
      final configuration=hexConHea,
      final m1_flow_nominal=m1Hea_flow_nominal,
      final m2_flow_nominal=m2Hea_flow_nominal,
      final dp1_nominal=0,
      dp2_nominal=100,
      final Q_flow_nominal=QHea_flow_nominal,
      final T_a1_nominal=T_a1Hea_nominal,
      final T_a2_nominal=T_a2Hea_nominal,
      final allowFlowReversal1=allowFlowReversal,
      final allowFlowReversal2=allowFlowReversal)
      annotation (Placement(transformation(extent={{-80,4}, {-60,-16}})));
    Buildings.Controls.OBC.CDL.Continuous.Gain gaiHeaFloNom(k=m1Hea_flow_nominal)
      annotation (Placement(transformation(extent={{20,210},{40,230}})));
    Modelica.Blocks.Sources.RealExpression Q_flowHea(y=hexHea.Q2_flow)
      annotation (Placement(transformation(extent={{160,210},{180,230}})));
    Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU hexCoo(
      redeclare final package Medium1=Medium1,
      redeclare final package Medium2=Medium2,
      final configuration=hexConCoo,
      final m1_flow_nominal=m1Coo_flow_nominal,
      final m2_flow_nominal=m2Coo_flow_nominal,
      final dp1_nominal=0,
      dp2_nominal=100,
      final Q_flow_nominal=QCoo_flow_nominal,
      final T_a1_nominal=T_a1Coo_nominal,
      final T_a2_nominal=T_a2Coo_nominal,
      final allowFlowReversal1=allowFlowReversal,
      final allowFlowReversal2=allowFlowReversal)
      annotation (Placement(transformation(extent={{0,4},{20,-16}})));
    Modelica.Blocks.Sources.RealExpression Q_flowCoo(y=hexCoo.Q2_flow)
      annotation (Placement(transformation(extent={{160,190},{180,210}})));
    Buildings.Controls.OBC.CDL.Continuous.Gain gaiFloNom2(k=max({
      m2Hea_flow_nominal,m2Coo_flow_nominal}))
      annotation (Placement(transformation(extent={{20,90},{40,110}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant sigFlo2(k=1)
      annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
    Buildings.Controls.OBC.CDL.Continuous.LimPID conTMax(
      each Ti=120,
      each yMax=1,
      each controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
      reverseAction=true,
      each yMin=0) "PI controller for maximum indoor temperature"
      annotation (Placement(transformation(extent={{-10,170},{10,190}})));
    Buildings.Controls.OBC.CDL.Continuous.Gain gaiCooFloNom(k=m1Coo_flow_nominal)
      annotation (Placement(transformation(extent={{20,170},{40,190}})));
    Buildings.Fluid.Sensors.TemperatureTwoPort senTem(
      redeclare final package Medium=Medium2,
      final m_flow_nominal=max(m2Hea_flow_nominal, m2Coo_flow_nominal),
      final tau=0,
      final allowFlowReversal=allowFlowReversal)
      "Return air temperature (sensed, steady-state)"
      annotation (Placement(transformation(extent={{130,-10},{110,10}})));
  equation
    connect(hexCoo.port_b2, hexHea.port_a2)
      annotation (Line(points={{0,0},{-60,0}},     color={0,127,255}));
    connect(hexHea.port_b2, port_b2)
      annotation (Line(points={{-80,0},{-90,0},{-90,0},{-200,0}},       color={0,127,255}));
    connect(fan.port_b, hexCoo.port_a2)
      annotation (Line(points={{70,0},{20,0}}, color={0,127,255}));
    connect(gaiFloNom2.u, sigFlo2.y)
      annotation (Line(points={{18,100},{-58,100}},
                                                  color={0,0,127}));
    connect(gaiFloNom2.y, fan.m_flow_in)
      annotation (Line(points={{42,100},{80,100},{80,12}},
                                                         color={0,0,127}));
    connect(port_a1Coo, hexCoo.port_a1) annotation (Line(points={{-200,-180},{-20,
            -180},{-20,-12},{0,-12}}, color={0,127,255}));
    connect(hexCoo.port_b1, port_b1Coo) annotation (Line(points={{20,-12},{40,-12},
            {40,-180},{200,-180}}, color={0,127,255}));
    connect(port_a1Hea, hexHea.port_a1) annotation (Line(points={{-200,-220},{
            -100,-220},{-100,-12},{-80,-12}},
                                         color={0,127,255}));
    connect(hexHea.port_b1, port_b1Hea) annotation (Line(points={{-60,-12},{-40,
            -12},{-40,-220},{200,-220}},
                                    color={0,127,255}));
    connect(TSetHea, conTMin.u_s)
      annotation (Line(points={{-220,220},{-12,220}}, color={0,0,127}));
    connect(conTMin.y, gaiHeaFloNom.u)
      annotation (Line(points={{12,220},{18,220}}, color={0,0,127}));
    connect(gaiHeaFloNom.y, m1ReqHea_flow) annotation (Line(points={{42,220},{122,
            220},{122,100},{220,100}}, color={0,0,127}));
    connect(conTMax.y, gaiCooFloNom.u)
      annotation (Line(points={{12,180},{18,180}}, color={0,0,127}));
    connect(TSetCoo, conTMax.u_s)
      annotation (Line(points={{-220,180},{-12,180}}, color={0,0,127}));
    connect(gaiCooFloNom.y, m1ReqCoo_flow) annotation (Line(points={{42,180},{140,
            180},{140,80},{220,80}},   color={0,0,127}));
    connect(Q_flowHea.y, QActHea_flow)
      annotation (Line(points={{181,220},{220,220}}, color={0,0,127}));
    connect(Q_flowCoo.y, QActCoo_flow)
      annotation (Line(points={{181,200},{220,200}}, color={0,0,127}));
    connect(fan.P, PFan) annotation (Line(points={{69,9},{60,9},{60,140},{220,140}},
          color={0,0,127}));
    connect(port_a2, senTem.port_a)
      annotation (Line(points={{200,0},{130,0}}, color={0,127,255}));
    connect(senTem.port_b, fan.port_a)
      annotation (Line(points={{110,0},{90,0}}, color={0,127,255}));
    connect(senTem.T, conTMax.u_m) annotation (Line(points={{120,11},{120,40},{0,40},
            {0,168}}, color={0,0,127}));
    connect(senTem.T, conTMin.u_m) annotation (Line(points={{120,11},{120,40},{-20,
            40},{-20,200},{0,200},{0,208}}, color={0,0,127}));
  end Terminal4PipesFluidPorts;

  model Terminal4PipesHeatPorts
    extends Buildings.Applications.DHC.Loads.BaseClasses.PartialTerminalUnit(
      final heaFunSpe=Buildings.Applications.DHC.Loads.Types.TerminalFunctionSpec.Water,
      final cooFunSpe=Buildings.Applications.DHC.Loads.Types.TerminalFunctionSpec.Water,
      final have_heaPor=true,
      final have_fluPor=false,
      final have_QReq_flow=false,
      final have_weaBus=false,
      final have_fan=false,
      final have_pum=false,
      final hexConHea=Buildings.Fluid.Types.HeatExchangerConfiguration.ConstantTemperaturePhaseChange,
      final hexConCoo=Buildings.Fluid.Types.HeatExchangerConfiguration.ConstantTemperaturePhaseChange,
      final m1Hea_flow_nominal=abs(QHea_flow_nominal/cp1Hea_nominal/(
          T_a1Hea_nominal - T_b1Hea_nominal)),
      final m1Coo_flow_nominal=abs(QCoo_flow_nominal/cp1Coo_nominal/(
          T_a1Coo_nominal - T_b1Coo_nominal)));

    parameter Integer nPorts1 = 2
      "Number of inlet (or outlet) fluid ports on the source side";
    // TODO: assign HX flow regime based on HX configuration.
    parameter Buildings.Fluid.Types.HeatExchangerFlowRegime hexReg[nPorts1]=
      fill(Buildings.Fluid.Types.HeatExchangerFlowRegime.ConstantTemperaturePhaseChange,
        nPorts1);
    parameter Real fraCon[nPorts1] = fill(0.7, nPorts1)
      "Convective fraction of heat transfer (constant)"
      annotation(Dialog(tab="Advanced"));
    parameter Real ratUAIntToUAExt[nPorts1](each min=1) = fill(2, nPorts1)
      "Ratio of UA internal to UA external values at nominal conditions"
      annotation(Dialog(tab="Advanced", group="Nominal condition"));
    parameter Real expUA[nPorts1] = fill(4/5, nPorts1)
      "Exponent of Reynolds number in the flow correlation used for computing UA internal value"
      annotation(Dialog(tab="Advanced"));
    // TODO: Update for all HX configurations.
    final parameter Modelica.SIunits.ThermalConductance CMin_nominal[nPorts1]=
      {m1Hea_flow_nominal,m1Coo_flow_nominal} .* {cp1Hea_nominal,cp1Coo_nominal}
      "Minimum capacity flow rate at nominal conditions";
      // min(m1_flow_nominal * cp1_nominal, m2_flow_nominal * cp2_nominal)
    final parameter Modelica.SIunits.ThermalConductance CMax_nominal[nPorts1]=
      fill(Modelica.Constants.inf, nPorts1)
      "Maximum capacity flow rate at nominal conditions";
    final parameter Real Z = 0
      "Ratio of capacity flow rates (CMin/CMax) at nominal conditions";
      // CMin_nominal / CMax_nominal
    final parameter Modelica.SIunits.ThermalConductance UA_nominal[nPorts1]=
      Buildings.Fluid.HeatExchangers.BaseClasses.ntu_epsilonZ(
        eps={QHea_flow_nominal, QCoo_flow_nominal} ./ abs(CMin_nominal .*
          ({T_a1Hea_nominal, T_a1Coo_nominal} .- {T_a2Hea_nominal, T_a2Coo_nominal})),
        Z=0,
        flowRegime=Integer(hexReg)) .* CMin_nominal
      "Thermal conductance at nominal conditions";
    final parameter Modelica.SIunits.ThermalConductance UAExt_nominal[nPorts1]=
      (1 .+ ratUAIntToUAExt) ./ ratUAIntToUAExt .* UA_nominal
      "External thermal conductance at nominal conditions";
    final parameter Modelica.SIunits.ThermalConductance UAInt_nominal[nPorts1]=
      ratUAIntToUAExt .* UAExt_nominal
      "Internal thermal conductance at nominal conditions";
    Buildings.Controls.OBC.CDL.Continuous.LimPID conTInd[nPorts1](
      each Ti=120,
      each yMax=1,
      each controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
      reverseAction={false,true},
      each yMin=0) "PI controller for indoor temperature"
      annotation (Placement(transformation(extent={{-10,90},{10,110}})));
    Buildings.Controls.OBC.CDL.Continuous.Gain gaiFloNom1[nPorts1](
      k={m1Hea_flow_nominal,m1Coo_flow_nominal})
      annotation (Placement(transformation(extent={{160,90},{180,110}})));
    Buildings.Applications.DHC.Loads.BaseClasses.HeatFlowEffectiveness hexHeaCoo[nPorts1](
      final flowRegime=hexReg,
      final m1_flow_nominal={m1Hea_flow_nominal,m1Coo_flow_nominal},
      final m2_flow_nominal=fill(0, nPorts1),
      final cp1_nominal={cp1Hea_nominal,cp1Coo_nominal},
      final cp2_nominal={cp2Hea_nominal,cp2Coo_nominal})
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor T2Mes
      "Load side temperature sensor"
      annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          rotation=0,
          origin={150,0})));
    Buildings.HeatTransfer.Sources.PrescribedHeatFlow heaFloHeaCon
      "Convective heat flow rate to load"
      annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={152,60})));
    Buildings.HeatTransfer.Sources.PrescribedHeatFlow heaFloCooCon
      "Convective heat flow rate to load"
      annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={152,40})));
    Modelica.Blocks.Sources.RealExpression UAAct[nPorts1](y=1 ./ (1 ./ (
          UAInt_nominal .* Buildings.Utilities.Math.Functions.regNonZeroPower(
          senMasFlo.m_flow ./ {m1Hea_flow_nominal,m1Coo_flow_nominal}, expUA)) .+ 1 ./ UAExt_nominal))
      annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
    Buildings.Fluid.Sensors.MassFlowRate senMasFlo[nPorts1](
      redeclare each final package Medium=Medium1)
      annotation (Placement(transformation(extent={{-150,-210},{-130,-190}})));
    Buildings.Controls.OBC.CDL.Routing.RealReplicator T2InlVec(nout=nPorts1)
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=180,
          origin={120,0})));
    Modelica.Blocks.Sources.RealExpression m2Act_flow[nPorts1](y=fill(0, nPorts1))
      annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
    Buildings.Fluid.HeatExchangers.HeaterCooler_u heaCoo[nPorts1](
      redeclare each final package Medium = Medium1,
      each final dp_nominal=0,
      final m_flow_nominal={m1Hea_flow_nominal,m1Coo_flow_nominal},
      each energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      each final Q_flow_nominal=-1) "Heat exchange with water stream"
      annotation (Placement(transformation(extent={{60,-210},{80,-190}})));
    Buildings.HeatTransfer.Sources.PrescribedHeatFlow heaFloCooRad
      "Radiative heat flow rate to load"
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={152,-60})));
    Buildings.HeatTransfer.Sources.PrescribedHeatFlow heaFloHeaRad
      "Radiative heat flow rate to load"
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={152,-40})));
    Buildings.Controls.OBC.CDL.Continuous.Gain gaiConHea[nPorts1](k=fraCon)
      annotation (Placement(transformation(extent={{60,30},{80,50}})));
    Buildings.Controls.OBC.CDL.Continuous.Gain gaiRadHea[nPorts1](k=1 .- fraCon)
      annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
    Buildings.Fluid.Sensors.TemperatureTwoPort T1HeaInl(
      redeclare final package Medium=Medium1,
      final m_flow_nominal=m1Hea_flow_nominal,
      final tau=0,
      final allowFlowReversal=allowFlowReversal)
      "Heating water inlet temperature (sensed, steady-state)"
      annotation (Placement(transformation(extent={{-190,-230},{-170,-210}})));
    Buildings.Fluid.Sensors.TemperatureTwoPort T1CooInl(
      redeclare final package Medium=Medium1,
      final m_flow_nominal=m1Coo_flow_nominal,
      final tau=0,
      final allowFlowReversal=allowFlowReversal)
      "Chilled water inlet temperature (sensed, steady-state)"
      annotation (Placement(transformation(extent={{-190,-190},{-170,-170}})));
  equation
    connect(hexHeaCoo.UA, UAAct.y)
      annotation (Line(points={{-12,8},{-20,8},{-20,20}, {-39,20}}, color={0,0,127}));
    connect(senMasFlo.m_flow, hexHeaCoo.m1_flow)
      annotation (Line(points={{-140,-189},{-140,4},{-12,4}}, color={0,0,127}));
    connect(T2Mes.T, T2InlVec.u)
      annotation (Line(points={{140,0},{134,0},{134,-1.33227e-15},{132,-1.33227e-15}},
                                                    color={0,0,127}));
    connect(T2InlVec.y, hexHeaCoo.T2Inl)
      annotation (Line(points={{108,1.55431e-15},{60,1.55431e-15},{60,-20},{-20,-20},
            {-20,-8},{-12,-8}}, color={0,0,127}));
    connect(m2Act_flow.y, hexHeaCoo.m2_flow) annotation (Line(points={{-39,-20},{-26,
            -20},{-26,-4},{-12,-4}}, color={0,0,127}));
    connect(hexHeaCoo.Q_flow, heaCoo.u) annotation (Line(points={{12,0},{20,0},{
            20,-194},{58,-194}},
                              color={0,0,127}));
    connect(heaFloHeaRad.port, heaPorRad) annotation (Line(points={{162,-40},{200,
            -40}},                     color={191,0,0}));
    connect(heaFloCooRad.port, heaPorRad) annotation (Line(points={{162,-60},{180,
            -60},{180,-40},{200,-40}}, color={191,0,0}));
    connect(heaFloHeaCon.port, heaPorCon) annotation (Line(points={{162,60},{180,60},
            {180,40},{200,40}},     color={191,0,0}));
    connect(heaFloCooCon.port, heaPorCon) annotation (Line(points={{162,40},{200,40}},
                                    color={191,0,0}));
    connect(heaPorCon, T2Mes.port) annotation (Line(points={{200,40},{180,40},{180,
            0},{160,0}},     color={191,0,0}));
    connect(hexHeaCoo.Q_flow, gaiConHea.u)
      annotation (Line(points={{12,0},{40,0},{40,40},{58,40}}, color={0,0,127}));
    connect(gaiConHea[1].y, heaFloHeaCon.Q_flow) annotation (Line(points={{82,40},
            {120,40},{120,60},{142,60}}, color={0,0,127}));
    connect(gaiConHea[2].y, heaFloCooCon.Q_flow)
      annotation (Line(points={{82,40},{142,40}}, color={0,0,127}));
    connect(gaiRadHea[1].y, heaFloHeaRad.Q_flow)
      annotation (Line(points={{82,-40},{142,-40}}, color={0,0,127}));
    connect(gaiRadHea[2].y, heaFloCooRad.Q_flow) annotation (Line(points={{82,-40},
            {120,-40},{120,-60},{142,-60}}, color={0,0,127}));
    connect(hexHeaCoo.Q_flow, gaiRadHea.u) annotation (Line(points={{12,0},{40,0},
            {40,-40},{58,-40}}, color={0,0,127}));
    connect(T2InlVec.y, conTInd.u_m) annotation (Line(points={{108,1.55431e-15},{100,
            1.55431e-15},{100,80},{0,80},{0,88}},
                                       color={0,0,127}));
    connect(conTInd.y, gaiFloNom1.u)
      annotation (Line(points={{12,100},{158,100}}, color={0,0,127}));
    connect(senMasFlo.port_b, heaCoo.port_a)
      annotation (Line(points={{-130,-200},{60,-200}}, color={0,127,255}));
    connect(heaCoo[1].port_b, port_b1Hea) annotation (Line(points={{80,-200},{140,
            -200},{140,-220},{200,-220}}, color={0,127,255}));
    connect(heaCoo[2].port_b, port_b1Coo) annotation (Line(points={{80,-200},{140,
            -200},{140,-180},{200,-180}}, color={0,127,255}));
    connect(TSetHea, conTInd[1].u_s) annotation (Line(points={{-220,220},{-116,220},
            {-116,100},{-12,100}}, color={0,0,127}));
    connect(TSetCoo, conTInd[2].u_s) annotation (Line(points={{-220,180},{-116,180},
            {-116,100},{-12,100}}, color={0,0,127}));
    connect(gaiFloNom1[1].y, m1ReqHea_flow)
      annotation (Line(points={{182,100},{220,100}}, color={0,0,127}));
    connect(gaiFloNom1[2].y, m1ReqCoo_flow) annotation (Line(points={{182,100},{192,
            100},{192,80},{220,80}}, color={0,0,127}));
    connect(hexHeaCoo[1].Q_flow, QActHea_flow) annotation (Line(points={{12,0},{20,
            0},{20,220},{220,220}}, color={0,0,127}));
    connect(hexHeaCoo[2].Q_flow, QActCoo_flow) annotation (Line(points={{12,0},{20,
            0},{20,200},{220,200}}, color={0,0,127}));
    connect(port_a1Hea, T1HeaInl.port_a)
      annotation (Line(points={{-200,-220},{-190,-220}}, color={0,127,255}));
    connect(T1HeaInl.T, hexHeaCoo[1].T1Inl)
      annotation (Line(points={{-180,-209},{-180,0},{-12,0}}, color={0,0,127}));
    connect(T1HeaInl.port_b, senMasFlo[1].port_a) annotation (Line(points={{-170,-220},
            {-160,-220},{-160,-200},{-150,-200}}, color={0,127,255}));
    connect(port_a1Coo, T1CooInl.port_a)
      annotation (Line(points={{-200,-180},{-190,-180}}, color={0,127,255}));
    connect(T1CooInl.port_b, senMasFlo[2].port_a) annotation (Line(points={{-170,-180},
            {-160,-180},{-160,-200},{-150,-200}}, color={0,127,255}));
    connect(T1CooInl.T, hexHeaCoo[2].T1Inl)
      annotation (Line(points={{-180,-169},{-180,0},{-12,0}}, color={0,0,127}));
  end Terminal4PipesHeatPorts;

  model Terminal4PipesHeatReq
    extends Buildings.Applications.DHC.Loads.BaseClasses.PartialTerminalUnit(
      final heaFunSpe=Buildings.Applications.DHC.Loads.Types.TerminalFunctionSpec.Water,
      final cooFunSpe=Buildings.Applications.DHC.Loads.Types.TerminalFunctionSpec.Water,
      final have_QReq_flow=true,
      final have_heaPor=false,
      final have_fluPor=false,
      final have_weaBus=false,
      final have_fan=false,
      final have_pum=false,
      final hexConHea=Buildings.Fluid.Types.HeatExchangerConfiguration.ConstantTemperaturePhaseChange,
      final hexConCoo=Buildings.Fluid.Types.HeatExchangerConfiguration.ConstantTemperaturePhaseChange,
      final m1Hea_flow_nominal=abs(QHea_flow_nominal/cp1Hea_nominal/(
          T_a1Hea_nominal - T_b1Hea_nominal)),
      final m1Coo_flow_nominal=abs(QCoo_flow_nominal/cp1Coo_nominal/(
          T_a1Coo_nominal - T_b1Coo_nominal)));
    parameter Integer nPorts1 = 2
      "Number of inlet (or outlet) fluid ports on the source side";
    // TODO: assign HX flow regime based on HX configuration.
    parameter Buildings.Fluid.Types.HeatExchangerFlowRegime hexReg[nPorts1]=
      fill(Buildings.Fluid.Types.HeatExchangerFlowRegime.ConstantTemperaturePhaseChange,
        nPorts1);
    parameter Real ratUAIntToUAExt[nPorts1](each min=1) = fill(2, nPorts1)
      "Ratio of UA internal to UA external values at nominal conditions"
      annotation(Dialog(tab="Advanced", group="Nominal condition"));
    parameter Real expUA[nPorts1] = fill(4/5, nPorts1)
      "Exponent of Reynolds number in the flow correlation used for computing UA internal value"
      annotation(Dialog(tab="Advanced"));
    // TODO: Update for all HX configurations.
    final parameter Modelica.SIunits.ThermalConductance CMin_nominal[nPorts1]=
      {m1Hea_flow_nominal,m1Coo_flow_nominal} .* {cp1Hea_nominal,cp1Coo_nominal}
      "Minimum capacity flow rate at nominal conditions";
      // min(m1_flow_nominal * cp1_nominal, m2_flow_nominal * cp2_nominal)
    final parameter Modelica.SIunits.ThermalConductance CMax_nominal[nPorts1]=
      fill(Modelica.Constants.inf, nPorts1)
      "Maximum capacity flow rate at nominal conditions";
    final parameter Real Z = 0
      "Ratio of capacity flow rates (CMin/CMax) at nominal conditions";
      // CMin_nominal / CMax_nominal
    final parameter Modelica.SIunits.ThermalConductance UA_nominal[nPorts1]=
      Buildings.Fluid.HeatExchangers.BaseClasses.ntu_epsilonZ(
        eps={QHea_flow_nominal,QCoo_flow_nominal} ./ abs(CMin_nominal .*
          ({T_a1Hea_nominal,T_a1Coo_nominal} .- {T_a2Hea_nominal,T_a2Coo_nominal})),
        Z=0,
        flowRegime=Integer(hexReg)) .* CMin_nominal
      "Thermal conductance at nominal conditions";
    final parameter Modelica.SIunits.ThermalConductance UAExt_nominal[nPorts1]=
      (1 .+ ratUAIntToUAExt) ./ ratUAIntToUAExt .* UA_nominal
      "External thermal conductance at nominal conditions";
    final parameter Modelica.SIunits.ThermalConductance UAInt_nominal[nPorts1]=
      ratUAIntToUAExt .* UAExt_nominal
      "Internal thermal conductance at nominal conditions";
    Buildings.Controls.OBC.CDL.Continuous.LimPID conQ_flowReq[nPorts1](
      each yMax=1,
      each controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
      reverseAction={false,true},
      each yMin=0) "PI controller tracking the required heat flow rate"
      annotation (Placement(transformation(extent={{10,210},{30,230}})));
    Buildings.Controls.OBC.CDL.Continuous.Gain gaiFloNom[nPorts1](k={
          m1Hea_flow_nominal,m1Coo_flow_nominal})
      annotation (Placement(transformation(extent={{60,210},{80,230}})));
    Buildings.Applications.DHC.Loads.BaseClasses.HeatFlowEffectiveness hexHeaCoo[nPorts1](
      final flowRegime=hexReg,
      final m1_flow_nominal={m1Hea_flow_nominal,m1Coo_flow_nominal},
      final m2_flow_nominal=fill(0, nPorts1),
      final cp1_nominal={cp1Hea_nominal,cp1Coo_nominal},
      final cp2_nominal={cp2Hea_nominal,cp2Coo_nominal})
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    Modelica.Blocks.Sources.RealExpression UAAct[nPorts1](y=1 ./ (1 ./ (
          UAInt_nominal .* Buildings.Utilities.Math.Functions.regNonZeroPower(
          senMasFlo.m_flow ./ {m1Hea_flow_nominal,m1Coo_flow_nominal}, expUA)) .+ 1 ./ UAExt_nominal))
      annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
    Buildings.Fluid.Sensors.MassFlowRate senMasFlo[nPorts1](
      redeclare each final package Medium=Medium1)
      annotation (Placement(transformation(extent={{-150,-210},{-130,-190}})));
    Modelica.Blocks.Sources.RealExpression m2Act_flow[nPorts1](y=fill(0, nPorts1))
      annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
    Buildings.Fluid.HeatExchangers.HeaterCooler_u heaCoo[nPorts1](
      redeclare each final package Medium = Medium1,
      final m_flow_nominal={m1Hea_flow_nominal,m1Coo_flow_nominal},
      each final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      each final dp_nominal=0,
      each final Q_flow_nominal=-1) "Heat exchange with water stream"
      annotation (Placement(transformation(extent={{60,-210},{80,-190}})));
    Buildings.Applications.DHC.Loads.BaseClasses.FirstOrderODE TLoaODE[nPorts1](
      each TOutHea_nominal=268.15,
      TIndHea_nominal={293.15,297.15},
      each QHea_flow_nominal=500,
      Q_flow_nominal={500,-2000})
      annotation (Placement(transformation(extent={{-60,170},{-40,190}})));
    Buildings.Fluid.Sensors.TemperatureTwoPort T1CooInl(
      redeclare final package Medium = Medium1,
      final m_flow_nominal=m1Coo_flow_nominal,
      final tau=0,
      final allowFlowReversal=allowFlowReversal)
      "Chilled water inlet temperature (sensed, steady-state)"
      annotation (Placement(transformation(extent={{-190,-190},{-170,-170}})));
    Buildings.Fluid.Sensors.TemperatureTwoPort T1HeaInl(
      redeclare final package Medium = Medium1,
      final m_flow_nominal=m1Hea_flow_nominal,
      final tau=0,
      final allowFlowReversal=allowFlowReversal)
      "Heating water inlet temperature (sensed, steady-state)"
      annotation (Placement(transformation(extent={{-190,-230},{-170,-210}})));
  equation
    connect(hexHeaCoo.UA, UAAct.y) annotation (Line(points={{-12,8},{-26,8},{-26,20},
            {-39,20}}, color={0,0,127}));
    connect(senMasFlo.m_flow, hexHeaCoo.m1_flow)
      annotation (Line(points={{-140,-189},{-140,4},{-12,4}}, color={0,0,127}));
    connect(m2Act_flow.y, hexHeaCoo.m2_flow) annotation (Line(points={{-39,-20},{-26,
            -20},{-26,-4},{-12,-4}}, color={0,0,127}));
    connect(hexHeaCoo.Q_flow, heaCoo.u) annotation (Line(points={{12,0},{20,0},{
            20,-194},{58,-194}},
                              color={0,0,127}));
    connect(conQ_flowReq.y, gaiFloNom.u) annotation (Line(points={{32,220},{58,220}},
                               color={0,0,127}));
    connect(TLoaODE.TInd, hexHeaCoo.T2Inl) annotation (Line(points={{-38,180},{-20,
            180},{-20,-8},{-12,-8}}, color={0,0,127}));
    connect(hexHeaCoo.Q_flow, TLoaODE.QAct_flow) annotation (Line(points={{12,0},
            {20,0},{20,160},{-80,160},{-80,172},{-62,172}}, color={0,0,127}));
    connect(hexHeaCoo.Q_flow, conQ_flowReq.u_m) annotation (Line(points={{12,0},{20,
            0},{20,208}},                    color={0,0,127}));
    connect(heaCoo[1].port_b, port_b1Hea) annotation (Line(points={{80,-200},{140,
            -200},{140,-220},{200,-220}}, color={0,127,255}));
    connect(heaCoo[2].port_b, port_b1Coo) annotation (Line(points={{80,-200},{140,
            -200},{140,-180},{200,-180}}, color={0,127,255}));
    connect(senMasFlo.port_b, heaCoo.port_a)
      annotation (Line(points={{-130,-200},{60,-200}}, color={0,127,255}));
    connect(TSetHea, TLoaODE[1].TSet) annotation (Line(points={{-220,220},{-180,220},
            {-180,188},{-62,188}}, color={0,0,127}));
    connect(TSetCoo, TLoaODE[2].TSet) annotation (Line(points={{-220,180},{-180,180},
            {-180,188},{-62,188}}, color={0,0,127}));
    connect(QReqHea_flow, TLoaODE[1].QReq_flow) annotation (Line(points={{-220,140},
            {-160,140},{-160,180},{-62,180}}, color={0,0,127}));
    connect(QReqCoo_flow, TLoaODE[2].QReq_flow) annotation (Line(points={{-220,100},
            {-160,100},{-160,180},{-62,180}}, color={0,0,127}));
    connect(gaiFloNom[1].y, m1ReqHea_flow) annotation (Line(points={{82,220},{140,
            220},{140,100},{220,100}},color={0,0,127}));
    connect(gaiFloNom[2].y, m1ReqCoo_flow)
      annotation (Line(points={{82,220},{140,220},{140,80},{220,80}},
                                                   color={0,0,127}));
    connect(QReqHea_flow, conQ_flowReq[1].u_s) annotation (Line(points={{-220,140},
            {-160,140},{-160,220},{8,220}},   color={0,0,127}));
    connect(QReqCoo_flow, conQ_flowReq[2].u_s) annotation (Line(points={{-220,100},
            {-160,100},{-160,220},{8,220}},   color={0,0,127}));
    connect(hexHeaCoo[1].Q_flow, QActHea_flow) annotation (Line(points={{12,0},{160,
            0},{160,220},{220,220}}, color={0,0,127}));
    connect(hexHeaCoo[2].Q_flow, QActCoo_flow) annotation (Line(points={{12,0},{160,
            0},{160,200},{220,200}}, color={0,0,127}));
    connect(port_a1Coo, T1CooInl.port_a)
      annotation (Line(points={{-200,-180},{-190,-180}}, color={0,127,255}));
    connect(port_a1Hea, T1HeaInl.port_a)
      annotation (Line(points={{-200,-220},{-190,-220}}, color={0,127,255}));
    connect(T1CooInl.port_b, senMasFlo[2].port_a) annotation (Line(points={{-170,-180},
            {-160,-180},{-160,-200},{-150,-200}}, color={0,127,255}));
    connect(T1HeaInl.port_b, senMasFlo[1].port_a) annotation (Line(points={{-170,-220},
            {-160,-220},{-160,-200},{-150,-200}}, color={0,127,255}));
    connect(T1HeaInl.T, hexHeaCoo[1].T1Inl)
      annotation (Line(points={{-180,-209},{-180,0},{-12,0}}, color={0,0,127}));
    connect(T1CooInl.T, hexHeaCoo[2].T1Inl)
      annotation (Line(points={{-180,-169},{-180,0},{-12,0}}, color={0,0,127}));
  end Terminal4PipesHeatReq;

  package GeojsonExportSpawn
    extends Modelica.Icons.Package;

    package B5a6b99ec37f4de7f94020090
      extends Modelica.Icons.Package;

      model building
        "FMU Template for Spawn"
        extends Modelica.Icons.Example;
        package Medium = Buildings.Media.Air "Medium model";

        parameter String idfName=Modelica.Utilities.Files.loadResource(
          "modelica://spawn_two_building/Loads/Resources/Data/B5a6b99ec37f4de7f94020090/RefBldgSmallOfficeNew2004_Chicago.idf")
          "Name of the IDF file";
        parameter String weaName = Modelica.Utilities.Files.loadResource(
          "modelica://spawn_two_building/Loads/Resources/Data/B5a6b99ec37f4de7f94020090/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw")
          "Name of the weather file";

        Modelica.Blocks.Sources.Constant qConGai_flow(k=0) "Convective heat gain"
          annotation (Placement(transformation(extent={{-74,-10},{-54,10}})));
        Modelica.Blocks.Sources.Constant qRadGai_flow(k=0) "Radiative heat gain"
          annotation (Placement(transformation(extent={{-74,30},{-54,50}})));
        Modelica.Blocks.Routing.Multiplex3 multiplex3_1
          annotation (Placement(transformation(extent={{-28,-10},{-8,10}})));
        Modelica.Blocks.Sources.Constant qLatGai_flow(k=0) "Latent heat gain"
          annotation (Placement(transformation(extent={{-74,-50},{-54,-30}})));

        Buildings.Experimental.EnergyPlus.ThermalZone znAttic(
          redeclare package Medium = Medium,
          idfName=idfName,
          weaName=weaName,
          energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
          usePrecompiledFMU=false,
          fmuName = Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/src/EnergyPlus/FMUs/Zones1.fmu"),
          zoneName="Attic") "Thermal zone"
           annotation (Placement(transformation(extent={{20,40},{60,80}})));

        Buildings.Experimental.EnergyPlus.ThermalZone znCore_ZN(
          redeclare package Medium = Medium,
          idfName=idfName,
          weaName=weaName,
          energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
          usePrecompiledFMU=false,
          fmuName = Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/src/EnergyPlus/FMUs/Zones1.fmu"),
          zoneName="Core_ZN") "Thermal zone"
           annotation (Placement(transformation(extent={{20,40},{60,80}})));

        Buildings.Experimental.EnergyPlus.ThermalZone znPerimeter_ZN_1(
          redeclare package Medium = Medium,
          idfName=idfName,
          weaName=weaName,
          energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
          usePrecompiledFMU=false,
          fmuName = Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/src/EnergyPlus/FMUs/Zones1.fmu"),
          zoneName="Perimeter_ZN_1") "Thermal zone"
           annotation (Placement(transformation(extent={{20,40},{60,80}})));

        Buildings.Experimental.EnergyPlus.ThermalZone znPerimeter_ZN_2(
          redeclare package Medium = Medium,
          idfName=idfName,
          weaName=weaName,
          energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
          usePrecompiledFMU=false,
          fmuName = Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/src/EnergyPlus/FMUs/Zones1.fmu"),
          zoneName="Perimeter_ZN_2") "Thermal zone"
           annotation (Placement(transformation(extent={{20,40},{60,80}})));

        Buildings.Experimental.EnergyPlus.ThermalZone znPerimeter_ZN_3(
          redeclare package Medium = Medium,
          idfName=idfName,
          weaName=weaName,
          energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
          usePrecompiledFMU=false,
          fmuName = Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/src/EnergyPlus/FMUs/Zones1.fmu"),
          zoneName="Perimeter_ZN_3") "Thermal zone"
           annotation (Placement(transformation(extent={{20,40},{60,80}})));

        Buildings.Experimental.EnergyPlus.ThermalZone znPerimeter_ZN_4(
          redeclare package Medium = Medium,
          idfName=idfName,
          weaName=weaName,
          energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
          usePrecompiledFMU=false,
          fmuName = Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/src/EnergyPlus/FMUs/Zones1.fmu"),
          zoneName="Perimeter_ZN_4") "Thermal zone"
           annotation (Placement(transformation(extent={{20,40},{60,80}})));

      equation
        connect(qRadGai_flow.y,multiplex3_1. u1[1])  annotation (Line(
            points={{-53,40},{-40,40},{-40,7},{-30,7}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(qConGai_flow.y,multiplex3_1. u2[1]) annotation (Line(
            points={{-53,0},{-30,0}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(multiplex3_1.u3[1],qLatGai_flow. y)
          annotation (Line(points={{-30,-7},{-40,-7},{-40,-40},{-53,-40}},color={0,0,127}));

        connect(multiplex3_1.y, znAttic.qGai_flow)
            annotation (Line(points={{-7,0},{20,0},{20,12},{38,12}}, color={0,0,127}));

        connect(multiplex3_1.y, znCore_ZN.qGai_flow)
            annotation (Line(points={{-7,0},{20,0},{20,12},{38,12}}, color={0,0,127}));

        connect(multiplex3_1.y, znPerimeter_ZN_1.qGai_flow)
            annotation (Line(points={{-7,0},{20,0},{20,12},{38,12}}, color={0,0,127}));

        connect(multiplex3_1.y, znPerimeter_ZN_2.qGai_flow)
            annotation (Line(points={{-7,0},{20,0},{20,12},{38,12}}, color={0,0,127}));

        connect(multiplex3_1.y, znPerimeter_ZN_3.qGai_flow)
            annotation (Line(points={{-7,0},{20,0},{20,12},{38,12}}, color={0,0,127}));

        connect(multiplex3_1.y, znPerimeter_ZN_4.qGai_flow)
            annotation (Line(points={{-7,0},{20,0},{20,12},{38,12}}, color={0,0,127}));

        // TODO: determine how to handle the "lines"

        annotation (Documentation(info="<html>
<p>
Template to connect n-thermal zones using GeoJSON to Modelica Translator
</p>
</html>",       revisions="<html>
<ul><li>
March 24, 2019: Nicholas Long<br/>
First implementation.
</li>
</ul>
</html>"),
       __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/EnergyPlus/Validation/RefBldgSmallOffice.mos"
              "Simulate and plot"),
      experiment(
            StopTime=604800,
            Tolerance=1e-06),
          Diagram(coordinateSystem(extent={{-100,-160},{160,120}})),
          Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
      end building;
    end B5a6b99ec37f4de7f94020090;

    package B5a6b99ec37f4de7f94021950
      extends Modelica.Icons.Package;

      model building
        "FMU Template for Spawn"
        extends Modelica.Icons.Example;
        package Medium = Buildings.Media.Air "Medium model";

        parameter String idfName=Modelica.Utilities.Files.loadResource(
          "modelica://spawn_two_building/Loads/Resources/Data/B5a6b99ec37f4de7f94021950/RefBldgSmallOfficeNew2004_Chicago.idf")
          "Name of the IDF file";
        parameter String weaName = Modelica.Utilities.Files.loadResource(
          "modelica://spawn_two_building/Loads/Resources/Data/B5a6b99ec37f4de7f94021950/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw")
          "Name of the weather file";

        Modelica.Blocks.Sources.Constant qConGai_flow(k=0) "Convective heat gain"
          annotation (Placement(transformation(extent={{-74,-10},{-54,10}})));
        Modelica.Blocks.Sources.Constant qRadGai_flow(k=0) "Radiative heat gain"
          annotation (Placement(transformation(extent={{-74,30},{-54,50}})));
        Modelica.Blocks.Routing.Multiplex3 multiplex3_1
          annotation (Placement(transformation(extent={{-28,-10},{-8,10}})));
        Modelica.Blocks.Sources.Constant qLatGai_flow(k=0) "Latent heat gain"
          annotation (Placement(transformation(extent={{-74,-50},{-54,-30}})));

        Buildings.Experimental.EnergyPlus.ThermalZone znAttic(
          redeclare package Medium = Medium,
          idfName=idfName,
          weaName=weaName,
          energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
          usePrecompiledFMU=false,
          fmuName = Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/src/EnergyPlus/FMUs/Zones1.fmu"),
          zoneName="Attic") "Thermal zone"
           annotation (Placement(transformation(extent={{20,40},{60,80}})));

        Buildings.Experimental.EnergyPlus.ThermalZone znCore_ZN(
          redeclare package Medium = Medium,
          idfName=idfName,
          weaName=weaName,
          energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
          usePrecompiledFMU=false,
          fmuName = Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/src/EnergyPlus/FMUs/Zones1.fmu"),
          zoneName="Core_ZN") "Thermal zone"
           annotation (Placement(transformation(extent={{20,40},{60,80}})));

        Buildings.Experimental.EnergyPlus.ThermalZone znPerimeter_ZN_1(
          redeclare package Medium = Medium,
          idfName=idfName,
          weaName=weaName,
          energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
          usePrecompiledFMU=false,
          fmuName = Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/src/EnergyPlus/FMUs/Zones1.fmu"),
          zoneName="Perimeter_ZN_1") "Thermal zone"
           annotation (Placement(transformation(extent={{20,40},{60,80}})));

        Buildings.Experimental.EnergyPlus.ThermalZone znPerimeter_ZN_2(
          redeclare package Medium = Medium,
          idfName=idfName,
          weaName=weaName,
          energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
          usePrecompiledFMU=false,
          fmuName = Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/src/EnergyPlus/FMUs/Zones1.fmu"),
          zoneName="Perimeter_ZN_2") "Thermal zone"
           annotation (Placement(transformation(extent={{20,40},{60,80}})));

        Buildings.Experimental.EnergyPlus.ThermalZone znPerimeter_ZN_3(
          redeclare package Medium = Medium,
          idfName=idfName,
          weaName=weaName,
          energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
          usePrecompiledFMU=false,
          fmuName = Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/src/EnergyPlus/FMUs/Zones1.fmu"),
          zoneName="Perimeter_ZN_3") "Thermal zone"
           annotation (Placement(transformation(extent={{20,40},{60,80}})));

        Buildings.Experimental.EnergyPlus.ThermalZone znPerimeter_ZN_4(
          redeclare package Medium = Medium,
          idfName=idfName,
          weaName=weaName,
          energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
          usePrecompiledFMU=false,
          fmuName = Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/src/EnergyPlus/FMUs/Zones1.fmu"),
          zoneName="Perimeter_ZN_4") "Thermal zone"
           annotation (Placement(transformation(extent={{20,40},{60,80}})));

      equation
        connect(qRadGai_flow.y,multiplex3_1. u1[1])  annotation (Line(
            points={{-53,40},{-40,40},{-40,7},{-30,7}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(qConGai_flow.y,multiplex3_1. u2[1]) annotation (Line(
            points={{-53,0},{-30,0}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(multiplex3_1.u3[1],qLatGai_flow. y)
          annotation (Line(points={{-30,-7},{-40,-7},{-40,-40},{-53,-40}},color={0,0,127}));

        connect(multiplex3_1.y, znAttic.qGai_flow)
            annotation (Line(points={{-7,0},{20,0},{20,12},{38,12}}, color={0,0,127}));

        connect(multiplex3_1.y, znCore_ZN.qGai_flow)
            annotation (Line(points={{-7,0},{20,0},{20,12},{38,12}}, color={0,0,127}));

        connect(multiplex3_1.y, znPerimeter_ZN_1.qGai_flow)
            annotation (Line(points={{-7,0},{20,0},{20,12},{38,12}}, color={0,0,127}));

        connect(multiplex3_1.y, znPerimeter_ZN_2.qGai_flow)
            annotation (Line(points={{-7,0},{20,0},{20,12},{38,12}}, color={0,0,127}));

        connect(multiplex3_1.y, znPerimeter_ZN_3.qGai_flow)
            annotation (Line(points={{-7,0},{20,0},{20,12},{38,12}}, color={0,0,127}));

        connect(multiplex3_1.y, znPerimeter_ZN_4.qGai_flow)
            annotation (Line(points={{-7,0},{20,0},{20,12},{38,12}}, color={0,0,127}));

        // TODO: determine how to handle the "lines"

        annotation (Documentation(info="<html>
<p>
Template to connect n-thermal zones using GeoJSON to Modelica Translator
</p>
</html>",       revisions="<html>
<ul><li>
March 24, 2019: Nicholas Long<br/>
First implementation.
</li>
</ul>
</html>"),
       __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/EnergyPlus/Validation/RefBldgSmallOffice.mos"
              "Simulate and plot"),
      experiment(
            StopTime=604800,
            Tolerance=1e-06),
          Diagram(coordinateSystem(extent={{-100,-160},{160,120}})),
          Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
      end building;
    end B5a6b99ec37f4de7f94021950;
  end GeojsonExportSpawn;

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
          transformation(extent={{-100,-10},{-66,22}}),iconTransformation(
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
end BaseClasses;
