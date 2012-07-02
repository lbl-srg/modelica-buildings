within Buildings.Rooms.Examples.BESTEST;
model Case620
  "Basic test with light-weight construction and dual-setpoint for heating and cooling with windows on East and West side walls. Fixme: Make object-oriented"
  extends Modelica.Icons.Example;
  package MediumA = Buildings.Media.GasesConstantDensity.SimpleAir
    "Medium model";
  parameter Integer nStaRef = 6 "Number of states in a reference material";
  parameter Real S_ = Buildings.HeatTransfer.Types.Azimuth.S;
  parameter Real E_ = Buildings.HeatTransfer.Types.Azimuth.E;
  parameter Real W_ = Buildings.HeatTransfer.Types.Azimuth.W;
  parameter Real N_ = Buildings.HeatTransfer.Types.Azimuth.N;
  parameter Real C_ = Buildings.HeatTransfer.Types.Tilt.Ceiling;
  parameter Real F_ = Buildings.HeatTransfer.Types.Tilt.Floor;
  parameter Real Z_ = Buildings.HeatTransfer.Types.Tilt.Wall;
  parameter Integer nConExtWin = 1 "Number of constructions with a window";
  parameter Integer nConBou = 1
    "Number of surface that are connected to constructions that are modeled inside the room";
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-98,82},{-82,98}})));
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
        nStaRef=nStaRef),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.066,
        k=0.040,
        c=840,
        d=12,
        nStaRef=nStaRef),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.012,
        k=0.160,
        c=840,
        d=950,
        nStaRef=nStaRef)}) "Lightweight Case: Exterior Wall"
    annotation (Placement(transformation(extent={{20,80},{34,94}})));
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
        nStaRef=nStaRef),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.025,
        k=0.140,
        c=1200,
        d=650,
        nStaRef=nStaRef)}) "Lightweight Case: Floor"
    annotation (Placement(transformation(extent={{80,80},{94,94}})));
  Buildings.Rooms.MixedAir roo(
    redeclare package Medium = MediumA,
    hRoo=2.7,
    nConBou=1,
    nPorts=3,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    AFlo=48,
    datConBou(
      layers={matFlo},
      each A=48,
      each til=F_),
    nConPar=0,
    nSurBou=0,
    intConMod=Buildings.HeatTransfer.Types.InteriorConvection.Temperature,
    extConMod=Buildings.HeatTransfer.Types.ExteriorConvection.TemperatureWind,
    linearizeRadiation=false,
    lat=weaDat.lat,
    nConExtWin=2,
    datConExtWin(
      layers={matExtWal,matExtWal},
      A={6*2.7,6*2.7},
      glaSys={window600,window600},
      wWin={3,3},
      hWin={2,2},
      fFra={0.001,0.001},
      til={Z_,Z_},
      azi={W_,E_}),
    nConExt=3,
    datConExt(
      layers={roofCase600,matExtWal,matExtWal},
      A={48,8*2.7,8*2.7},
      til={C_,Z_,Z_},
      azi={S_,S_,N_})) "Room model for Case 600"
    annotation (Placement(transformation(extent={{34,-32},{64,-2}})));
  Modelica.Blocks.Sources.Constant qConGai_flow(k=80/48) "Convective heat gain"
    annotation (Placement(transformation(extent={{-56,58},{-48,66}})));
  Modelica.Blocks.Sources.Constant qRadGai_flow(k=120/48) "Radiative heat gain"
    annotation (Placement(transformation(extent={{-44,66},{-36,74}})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1
    annotation (Placement(transformation(extent={{-18,58},{-10,66}})));
  Modelica.Blocks.Sources.Constant qLatGai_flow(k=0) "Latent heat gain"
    annotation (Placement(transformation(extent={{-44,50},{-36,58}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "Resources/weatherdata/DRYCOLD.mos")
    annotation (Placement(transformation(extent={{98,-94},{86,-82}})));
  Modelica.Blocks.Sources.Constant uSha(k=0)
    "Control signal for the shading device"
    annotation (Placement(transformation(extent={{-28,70},{-20,78}})));
  Modelica.Blocks.Routing.Replicator replicator(nout=max(1,nConExtWin))
    annotation (Placement(transformation(extent={{-12,70},{-4,78}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TSoi[nConBou](each T=
        283.15) "Boundary condition for construction"
                                          annotation (Placement(transformation(
        extent={{0,0},{-8,8}},
        rotation=0,
        origin={72,-52})));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic roofCase600(nLay=3,
    absIR_a=0.9,
    absIR_b=0.9,
    absSol_a=0.6,
    absSol_b=0.6,
    material={Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.019,
        k=0.140,
        c=900,
        d=530,
        nStaRef=nStaRef),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.1118,
        k=0.040,
        c=840,
        d=12,
        nStaRef=nStaRef),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.010,
        k=0.160,
        c=840,
        d=950,
        nStaRef=nStaRef)}) "Lightweight Case: Roof"
    annotation (Placement(transformation(extent={{60,80},{74,94}})));
  Win600 window600(
    UFra=3,
    haveExteriorShade=false,
    haveInteriorShade=false) "Window for Case 600"
    annotation (Placement(transformation(extent={{40,80},{54,94}})));
  Buildings.HeatTransfer.Conduction.SingleLayer soil(
    A=48,
    material(
      x=2,
      k=1.3,
      c=800,
      d=1500,
      R=0),
    steadyStateInitial=true,
    T_a_start=283.15,
    T_b_start=283.75) "2m deep soil (per definition on p.4 of ASHRAE 140-2007)"
    annotation (Placement(transformation(extent={{5,-5},{-3,3}},
        rotation=-90,
        origin={57,-35})));
  Buildings.Fluid.Sources.MassFlowSource_T Infiltration(
    redeclare package Medium = MediumA,
    m_flow=1,
    use_m_flow_in=true,
    use_T_in=false,
    use_X_in=false,
    use_C_in=false,
    nPorts=1)
    annotation (Placement(transformation(extent={{4,-58},{16,-46}})));
  Buildings.Fluid.Sources.Outside          Infiltration1(
    redeclare package Medium = MediumA, nPorts=1)
           annotation (Placement(transformation(extent={{-24,-34},{-12,-22}})));
  Modelica.Blocks.Sources.Constant InfiltrationRate(k=-48*2.7*0.5/3600)
    "0.41 ACH adjusted for the altitude (0.5 at sea level)"
    annotation (Placement(transformation(extent={{-70,-48},{-62,-40}})));
  Modelica.Blocks.Math.Product product
    annotation (Placement(transformation(extent={{-50,-52},{-40,-42}})));
  Buildings.Fluid.Sensors.Density density(redeclare package Medium = MediumA)
    "Air density inside the building"
    annotation (Placement(transformation(extent={{-40,-76},{-50,-66}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    annotation (Placement(transformation(extent={{-4,-96},{12,-80}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TRooAir
    "Room air temperature"
    annotation (Placement(transformation(extent={{-84,-12},{-76,-4}})));
  Buildings.Controls.Continuous.LimPID conHea(
    Td=60,
    initType=Modelica.Blocks.Types.InitPID.InitialState,
    Ti=300,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.1) "Controller for heating"
    annotation (Placement(transformation(extent={{-64,30},{-56,38}})));
  Modelica.Blocks.Sources.Constant TSetHea(k=273.15 + 20)
    "Setpoint for heating"
    annotation (Placement(transformation(extent={{-84,30},{-76,38}})));
  Modelica.Blocks.Sources.Constant TSetCoo(k=273.15 + 27)
    "Setpoint for cooling"
    annotation (Placement(transformation(extent={{-84,8},{-76,16}})));
  Buildings.Controls.Continuous.LimPID conCoo(
    Td=60,
    reverseAction=true,
    initType=Modelica.Blocks.Types.InitPID.InitialState,
    Ti=300,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.1) "Controller for cooling"
    annotation (Placement(transformation(extent={{-64,8},{-56,16}})));
  Modelica.Blocks.Math.Gain gaiHea(k=1E6) "Gain for heating"
    annotation (Placement(transformation(extent={{-50,30},{-42,38}})));
  Modelica.Blocks.Math.Gain gaiCoo(k=-1E6) "Gain for cooling"
    annotation (Placement(transformation(extent={{-50,8},{-42,16}})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM   heaCoo(
    redeclare package Medium = MediumA,
    allowFlowReversal=false,
    m_flow_nominal=48*2.7*0.41/3600*1.2,
    dp_nominal=1,
    linearized=true,
    from_dp=true) "Heater and cooler"
    annotation (Placement(transformation(extent={{6,-34},{18,-22}})));
  Modelica.Blocks.Math.Sum sum1(nin=2)
    annotation (Placement(transformation(extent={{-12,20},{-4,28}})));
  Modelica.Blocks.Routing.Multiplex2 multiplex2
    annotation (Placement(transformation(extent={{-28,20},{-20,28}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea
    "Prescribed heat flow for heating and cooling"
    annotation (Placement(transformation(extent={{2,18},{14,30}})));
  Modelica.Blocks.Continuous.Integrator EHea(
    k=1/1E6/3600,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0) "Heating energy in MWh"
    annotation (Placement(transformation(extent={{-12,36},{-4,44}})));
  Modelica.Blocks.Continuous.Integrator ECoo(
    k=1/1E6/3600,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0) "Cooling energy in MWh"
    annotation (Placement(transformation(extent={{-12,6},{-4,14}})));
equation
  connect(qRadGai_flow.y,multiplex3_1. u1[1])  annotation (Line(
      points={{-35.6,70},{-34,70},{-34,64.8},{-18.8,64.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(qLatGai_flow.y,multiplex3_1. u3[1])  annotation (Line(
      points={{-35.6,54},{-28,54},{-28,59.2},{-18.8,59.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiplex3_1.y, roo.qGai_flow) annotation (Line(
      points={{-9.6,62},{20,62},{20,-9.5},{32.5,-9.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(roo.uSha, replicator.y) annotation (Line(
      points={{32.5,-5},{24,-5},{24,74},{-3.6,74}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(qConGai_flow.y, multiplex3_1.u2[1]) annotation (Line(
      points={{-47.6,62},{-18.8,62}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaDat.weaBus, roo.weaBus)  annotation (Line(
      points={{86,-88},{80.07,-88},{80.07,-3.575},{62.425,-3.575}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(uSha.y, replicator.u) annotation (Line(
      points={{-19.6,74},{-12.8,74}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product.y, Infiltration.m_flow_in) annotation (Line(
      points={{-39.5,-47},{-36,-47},{-36,-47.2},{4,-47.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(density.port, roo.ports[1])  annotation (Line(
      points={{-45,-76},{32,-76},{32,-24.5},{35.75,-24.5}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(density.d, product.u2) annotation (Line(
      points={{-50.5,-71},{-56,-71},{-56,-50},{-51,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{86,-88},{4,-88}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(InfiltrationRate.y, product.u1) annotation (Line(
      points={{-61.6,-44},{-51,-44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSoi[1].port, soil.port_a) annotation (Line(
      points={{64,-48},{56,-48},{56,-40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(soil.port_b, roo.surf_conBou[1])  annotation (Line(
      points={{56,-32},{56,-29},{53.5,-29}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TRooAir.T, conHea.u_m) annotation (Line(
      points={{-76,-8},{-68,-8},{-68,24},{-60,24},{-60,29.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSetHea.y, conHea.u_s) annotation (Line(
      points={{-75.6,34},{-64.8,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSetCoo.y, conCoo.u_s)  annotation (Line(
      points={{-75.6,12},{-64.8,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conCoo.u_m, TRooAir.T)  annotation (Line(
      points={{-60,7.2},{-60,-8},{-76,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conHea.y, gaiHea.u) annotation (Line(
      points={{-55.6,34},{-50.8,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conCoo.y, gaiCoo.u)  annotation (Line(
      points={{-55.6,12},{-50.8,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaBus, Infiltration1.weaBus) annotation (Line(
      points={{4,-88},{-30,-88},{-30,-27.88},{-24,-27.88}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(roo.heaPorAir, TRooAir.port)  annotation (Line(
      points={{48.25,-17},{-90,-17},{-90,-8},{-84,-8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Infiltration1.ports[1], heaCoo.port_a) annotation (Line(
      points={{-12,-28},{6,-28}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heaCoo.port_b, roo.ports[2])  annotation (Line(
      points={{18,-28},{26,-28},{26,-24.5},{37.75,-24.5}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(Infiltration.ports[1], roo.ports[3])  annotation (Line(
      points={{16,-52},{28,-52},{28,-24.5},{39.75,-24.5}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(gaiHea.y, multiplex2.u1[1]) annotation (Line(
      points={{-41.6,34},{-34,34},{-34,26.4},{-28.8,26.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gaiCoo.y, multiplex2.u2[1]) annotation (Line(
      points={{-41.6,12},{-34,12},{-34,21.6},{-28.8,21.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiplex2.y, sum1.u) annotation (Line(
      points={{-19.6,24},{-12.8,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sum1.y, preHea.Q_flow) annotation (Line(
      points={{-3.6,24},{2,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preHea.port, roo.heaPorAir) annotation (Line(
      points={{14,24},{16,24},{16,-17},{48.25,-17}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(EHea.u, gaiHea.y) annotation (Line(
      points={{-12.8,40},{-24,40},{-24,34},{-41.6,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ECoo.u, gaiCoo.y) annotation (Line(
      points={{-12.8,10},{-26,10},{-26,12},{-41.6,12}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Rooms/Examples/BESTEST/Case620.mos"
        "Simulate and plot"),
        experiment(
      StopTime=3.1536e+007,
      Interval=3600,
      Tolerance=1e-006,
      Algorithm="Radau"),                  Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics),
    experimentSetupOutput,
    Documentation(info="<html>
<p>
This model is the case 620 of the BESTEST validation suite.
Case 620 differs from case 600 in that the west and east facing walls
have a window, but there is no window in the south facing wall.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 12, 2012, by Kaustubh Phalak:<br>
Modified the Case 600 for implementation of Case 620.
</li>
<li>
October 6, 2011, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end Case620;
