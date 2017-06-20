within Buildings.Air.Systems.SingleZone.VAV.Examples.BaseClasses;
model Room
  "BESTest Case 600 with fluid ports for air HVAC and internal load"

  package MediumA = Buildings.Media.Air "Medium model";
  parameter Modelica.SIunits.Angle lat "Building latitude";
  parameter Modelica.SIunits.Angle S_=
    Buildings.Types.Azimuth.S "Azimuth for south walls";
  parameter Modelica.SIunits.Angle E_=
    Buildings.Types.Azimuth.E "Azimuth for east walls";
  parameter Modelica.SIunits.Angle W_=
    Buildings.Types.Azimuth.W "Azimuth for west walls";
  parameter Modelica.SIunits.Angle N_=
    Buildings.Types.Azimuth.N "Azimuth for north walls";
  parameter Modelica.SIunits.Angle C_=
    Buildings.Types.Tilt.Ceiling "Tilt for ceiling";
  parameter Modelica.SIunits.Angle F_=
    Buildings.Types.Tilt.Floor "Tilt for floor";
  parameter Modelica.SIunits.Angle Z_=
    Buildings.Types.Tilt.Wall "Tilt for wall";
  parameter Integer nConExtWin = 1 "Number of constructions with a window";
  parameter Integer nConBou = 1
    "Number of surface that are connected to constructions that are modeled inside the room";
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic matExtWal(
    nLay=3,
    absIR_a=0.9,
    absIR_b=0.9,
    absSol_a=0.6,
    absSol_b=0.6,
    material={Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.009,
        k=0.140,
        c=900,
        d=530,
        nStaRef=Buildings.ThermalZones.Detailed.Validation.BESTEST.nStaRef),
                         Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.066,
        k=0.040,
        c=840,
        d=12,
        nStaRef=Buildings.ThermalZones.Detailed.Validation.BESTEST.nStaRef),
                         Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.012,
        k=0.160,
        c=840,
        d=950,
        nStaRef=Buildings.ThermalZones.Detailed.Validation.BESTEST.nStaRef)})
                           "Exterior wall"
    annotation (Placement(transformation(extent={{20,84},{34,98}})));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic
                                                          matFlo(final nLay=
           2,
    absIR_a=0.9,
    absIR_b=0.9,
    absSol_a=0.6,
    absSol_b=0.6,
    material={Buildings.HeatTransfer.Data.Solids.Generic(
        x=1.003,
        k=0.040,
        c=0,
        d=0,
        nStaRef=Buildings.ThermalZones.Detailed.Validation.BESTEST.nStaRef),
                         Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.025,
        k=0.140,
        c=1200,
        d=650,
        nStaRef=Buildings.ThermalZones.Detailed.Validation.BESTEST.nStaRef)})
                           "Floor"
    annotation (Placement(transformation(extent={{80,84},{94,98}})));
   parameter Buildings.HeatTransfer.Data.Solids.Generic soil(
    x=2,
    k=1.3,
    c=800,
    d=1500) "Soil properties"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));

  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic roof(nLay=3,
    absIR_a=0.9,
    absIR_b=0.9,
    absSol_a=0.6,
    absSol_b=0.6,
    material={Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.019,
        k=0.140,
        c=900,
        d=530,
        nStaRef=Buildings.ThermalZones.Detailed.Validation.BESTEST.nStaRef),
                         Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.1118,
        k=0.040,
        c=840,
        d=12,
        nStaRef=Buildings.ThermalZones.Detailed.Validation.BESTEST.nStaRef),
                         Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.010,
        k=0.160,
        c=840,
        d=950,
        nStaRef=Buildings.ThermalZones.Detailed.Validation.BESTEST.nStaRef)})
                           "Roof"
    annotation (Placement(transformation(extent={{60,84},{74,98}})));
  Buildings.ThermalZones.Detailed.Validation.BESTEST.Data.Win600
         window600(
    UFra=3,
    haveExteriorShade=false,
    haveInteriorShade=false) "Window"
    annotation (Placement(transformation(extent={{40,84},{54,98}})));
  Buildings.HeatTransfer.Conduction.SingleLayer soi(
    A=48,
    material=soil,
    steadyStateInitial=true,
    stateAtSurface_a=false,
    stateAtSurface_b=true,
    T_a_start=283.15,
    T_b_start=283.75) "2m deep soil (per definition on p.4 of ASHRAE 140-2007)"
    annotation (Placement(transformation(
        extent={{5,-5},{-3,3}},
        rotation=-90,
        origin={33,-35})));

  parameter Modelica.SIunits.MassFlowRate mAir_flow_nominal "Design airflow rate of system";

  Buildings.ThermalZones.Detailed.MixedAir roo(
    redeclare package Medium = MediumA,
    nPorts=5,
    hRoo=2.7,
    nConExtWin=nConExtWin,
    nConBou=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    AFlo=48,
    datConBou(
      layers={matFlo},
      each A=48,
      each til=F_),
    datConExt(
      layers={roof,matExtWal,matExtWal,matExtWal},
      A={48,6*2.7,6*2.7,8*2.7},
      til={C_,Z_,Z_,Z_},
      azi={S_,W_,E_,N_}),
    nConExt=4,
    nConPar=0,
    nSurBou=0,
    datConExtWin(
      layers={matExtWal},
      A={8*2.7},
      glaSys={window600},
      wWin={2*3},
      hWin={2},
      fFra={0.001},
      til={Z_},
      azi={S_}),
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    lat=lat,
    intConMod=Buildings.HeatTransfer.Types.InteriorConvection.Temperature,
    extConMod=Buildings.HeatTransfer.Types.ExteriorConvection.TemperatureWind,
    steadyStateWindow=false)
    "Room model for Case 600"
    annotation (Placement(transformation(extent={{12,-30},{42,0}})));
  Modelica.Blocks.Sources.Constant qConGai_flow(k=192/48)
                                                         "Convective heat gain"
    annotation (Placement(transformation(extent={{-78,-6},{-70,2}})));
  Modelica.Blocks.Sources.Constant qRadGai_flow(k=288/48) "Radiative heat gain"
    annotation (Placement(transformation(extent={{-66,6},{-58,14}})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1
    annotation (Placement(transformation(extent={{-32,-6},{-24,2}})));
  Modelica.Blocks.Sources.Constant qLatGai_flow(k=96/48)
                                                     "Latent heat gain"
    annotation (Placement(transformation(extent={{-66,-16},{-58,-8}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TSoi[nConBou](each T=
        283.15) "Boundary condition for construction"
                                          annotation (Placement(transformation(
        extent={{0,0},{-8,8}},
        origin={48,-52})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorAir
    "Heat port to air volume"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));

  Fluid.Sources.MassFlowSource_WeatherData
                                  sinInf(redeclare package Medium = MediumA,
      nPorts=1,
    use_m_flow_in=true)
                "Sink model for air infiltration"
           annotation (Placement(transformation(extent={{-24,-32},{-12,-20}})));
  Modelica.Blocks.Sources.Constant InfiltrationRate(k=48*2.7*0.5/3600)
    "0.41 ACH adjusted for the altitude (0.5 at sea level)"
    annotation (Placement(transformation(extent={{-96,-90},{-88,-82}})));
  Modelica.Blocks.Math.Product product
    annotation (Placement(transformation(extent={{-78,-66},{-66,-54}})));
  Buildings.Fluid.Sensors.Density density(redeclare package Medium = MediumA)
    "Air density inside the building"
    annotation (Placement(transformation(extent={{-8,-74},{-18,-64}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    annotation (Placement(transformation(extent={{-108,72},{-92,88}})));
  Modelica.Blocks.Math.MultiSum multiSum(nu=1)
    annotation (Placement(transformation(extent={{-78,-92},{-66,-80}})));

  Modelica.Blocks.Interfaces.RealOutput TRooAir "Room air temperature"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTZon
    "Zone air temperature sensor"
    annotation (Placement(transformation(extent={{50,-26},{70,-6}})));
  Fluid.Sources.MassFlowSource_WeatherData
                                  souInf(redeclare package Medium = MediumA,
    use_m_flow_in=true,
    nPorts=1)   "Source model for air infiltration"
    annotation (Placement(transformation(extent={{-24,-48},{-12,-36}})));
  Buildings.Air.Systems.SingleZone.VAV.Examples.BaseClasses.InternalLoads intLoad
    annotation (Placement(transformation(extent={{-80,12},{-72,20}})));
  Modelica.Blocks.Math.Product product1
    annotation (Placement(transformation(extent={{-52,4},{-44,12}})));
  Modelica.Blocks.Math.Product product2
    annotation (Placement(transformation(extent={{-52,-18},{-44,-10}})));
  Modelica.Blocks.Math.Product product3
    annotation (Placement(transformation(extent={{-52,-6},{-44,2}})));

  Modelica.Blocks.Math.Gain gaiInf(final k=-1) "Gain for infiltration"
    annotation (Placement(transformation(extent={{-50,-66},{-38,-54}})));
  Modelica.Fluid.Interfaces.FluidPort_a supplyAir(redeclare final package
      Medium = MediumA) "Supply air"
    annotation (Placement(transformation(extent={{-150,10},{-130,30}})));
  Modelica.Fluid.Interfaces.FluidPort_b returnAir(redeclare final package
      Medium = MediumA) "Return air"
    annotation (Placement(transformation(extent={{-150,-30},{-130,-10}})));
equation
  connect(multiplex3_1.y, roo.qGai_flow) annotation (Line(
      points={{-23.6,-2},{-22,-2},{-22,-9},{10.8,-9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(density.port, roo.ports[1])  annotation (Line(
      points={{-13,-74},{2,-74},{2,-24.9},{15.75,-24.9}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(density.d, product.u2) annotation (Line(
      points={{-18.5,-69},{-86,-69},{-86,-64},{-84,-64},{-84,-63.6},{-79.2,
          -63.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSoi[1].port, soi.port_a) annotation (Line(
      points={{40,-48},{32,-48},{32,-40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(soi.port_b, roo.surf_conBou[1]) annotation (Line(
      points={{32,-32},{32,-27},{31.5,-27}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(multiSum.y, product.u1) annotation (Line(
      points={{-64.98,-86},{-60,-86},{-60,-72},{-88,-72},{-88,-56.4},{-79.2,
          -56.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(InfiltrationRate.y, multiSum.u[1]) annotation (Line(
      points={{-87.6,-86},{-78,-86}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(sinInf.ports[1], roo.ports[2]) annotation (Line(points={{-12,-26},{14,
          -26},{14,-23.7},{15.75,-23.7}}, color={0,127,255}));
  connect(weaBus,sinInf. weaBus) annotation (Line(
      points={{-100,80},{-100,-26},{-24,-26},{-24,-25.88}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus, roo.weaBus) annotation (Line(
      points={{-100,80},{-100,24},{40,24},{40,2},{40.425,2},{40.425,-1.575}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));

  connect(senTZon.T, TRooAir) annotation (Line(points={{70,-16},{88,-16},{88,0},
          {110,0}}, color={0,0,127}));
  connect(senTZon.port, roo.heaPorAir) annotation (Line(points={{50,-16},{26.25,
          -16},{26.25,-15}}, color={191,0,0}));
  connect(qRadGai_flow.y, product1.u1) annotation (Line(points={{-57.6,10},
          {-52.8,10},{-52.8,10.4}}, color={0,0,127}));
  connect(qLatGai_flow.y, product2.u1) annotation (Line(points={{-57.6,-12},
          {-52.8,-12},{-52.8,-11.6}}, color={0,0,127}));
  connect(qConGai_flow.y, product3.u1) annotation (Line(points={{-69.6,-2},
          {-62,-2},{-62,0.4},{-52.8,0.4}}, color={0,0,127}));
  connect(intLoad.y[1], product2.u2) annotation (Line(points={{-71.6,16},{
          -56,16},{-56,-16.4},{-52.8,-16.4}}, color={0,0,127}));
  connect(product3.u2, product2.u2) annotation (Line(points={{-52.8,-4.4},{
          -56,-4.4},{-56,-16.4},{-52.8,-16.4}}, color={0,0,127}));
  connect(product1.u2, product2.u2) annotation (Line(points={{-52.8,5.6},{
          -56,5.6},{-56,-16.4},{-52.8,-16.4}}, color={0,0,127}));
  connect(product1.y, multiplex3_1.u1[1]) annotation (Line(points={{-43.6,8},
          {-36,8},{-36,0.8},{-32.8,0.8}}, color={0,0,127}));
  connect(product3.y, multiplex3_1.u2[1]) annotation (Line(points={{-43.6,
          -2},{-32.8,-2},{-32.8,-2}}, color={0,0,127}));
  connect(product2.y, multiplex3_1.u3[1]) annotation (Line(points={{-43.6,
          -14},{-36,-14},{-36,-4.8},{-32.8,-4.8}}, color={0,0,127}));
  connect(roo.heaPorAir, heaPorAir) annotation (Line(points={{26.25,-15},{
          38.125,-15},{38.125,10},{70,10}}, color={191,0,0}));
  connect(souInf.weaBus, weaBus) annotation (Line(
      points={{-24,-41.88},{-56,-41.88},{-56,-42},{-100,-42},{-100,80}},
      color={255,204,51},
      thickness=0.5));
  connect(souInf.ports[1], roo.ports[3]) annotation (Line(points={{-12,-42},{-6,
          -42},{-6,-22.5},{15.75,-22.5}}, color={0,127,255}));
  connect(product.y, gaiInf.u)
    annotation (Line(points={{-65.4,-60},{-51.2,-60}}, color={0,0,127}));
  connect(gaiInf.y, souInf.m_flow_in) annotation (Line(points={{-37.4,-60},{-30,
          -60},{-30,-37.2},{-24,-37.2}}, color={0,0,127}));
  connect(product.y, sinInf.m_flow_in) annotation (Line(points={{-65.4,-60},{
          -58,-60},{-58,-21.2},{-24,-21.2}}, color={0,0,127}));
  connect(supplyAir, roo.ports[4]) annotation (Line(points={{-140,20},{-120,20},
          {-120,48},{0,48},{0,-21.3},{15.75,-21.3}}, color={0,127,255}));
  connect(returnAir, roo.ports[5]) annotation (Line(points={{-140,-20},{-128,
          -20},{-128,-20},{-114,-20},{-114,42},{-2,42},{-2,-20.1},{15.75,-20.1}},
        color={0,127,255}));
annotation (Documentation(info="<html>
<p>
This is a single zone model based on the envelope of the BESTEST Case 600 
building, though it has some modifications.  Supply and return air ports are
included for simulation with air-based HVAC systems.  Heating and cooling 
setpoints and internal loads are time-varying according to an assumed 
occupancy schedule.
</p>
<p>
This zone model utilizes schedules and constructions from
the <code>Schedules</code> and <code>Constructions</code> packages.  
</p>
</html>"),
    Diagram(coordinateSystem(extent={{-140,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-140,-100},{100,100}})));
end Room;
