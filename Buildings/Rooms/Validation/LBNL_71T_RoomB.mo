within Buildings.Rooms.Validation;
model LBNL_71T_RoomB
  "Validation model for the correct implementation of Electrochromic Window"
  extends Modelica.Icons.Example;
  package MediumA = Buildings.Media.Air "Medium model";

  parameter Modelica.SIunits.Temperature T_start=273.15 - 15 "Initial value";

  parameter Integer nConExtWin=1 "Number of constructions with a window";
  parameter Integer nConExt=0 "Number of constructions without a window";
  parameter Integer nConBou=5
    "Number of surface that are connected to constructions that are modeled inside the room";
  parameter Integer nSurBou=0
    "Number of surface that are connected to the room air volume";
  parameter Integer nConPar=0 "Number of surface that are partitions";

  MixedAir roo(
    redeclare package Medium = MediumA,
    nConExt=nConExt,
    nConExtWin=nConExtWin,
    nConPar=nConPar,
    nConBou=nConBou,
    nSurBou=nSurBou,
    linearizeRadiation=false,
    nPorts=4,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=T_start,
    datConExtWin(
      layers={matExtWal},
      each A=10.22,
      glaSys={glaSys},
      each hWin=3.35,
      each wWin=3.04,
      each fFra=0.1477,
      each til=Buildings.Types.Tilt.Wall,
      azi={Buildings.Types.Azimuth.S}),
    datConBou(
      layers={matFlo,matCeil,matEWWal,matNWal,matEWWal},
      A={13.94,13.94,15.33,10.22,15.33},
      til={Buildings.Types.Tilt.Floor,Buildings.Types.Tilt.Ceiling,Buildings.Types.Tilt.Wall,
          Buildings.Types.Tilt.Wall,Buildings.Types.Tilt.Wall}),
    AFlo=13.94,
    hRoo=3.37,
    lat=0.65484753534827) "Room model"
    annotation (Placement(transformation(extent={{66,40},{106,80}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat1(
    calTSky=Buildings.BoundaryConditions.Types.SkyTemperatureCalculation.TemperaturesAndSkyCover,

    relHum=0,
    TDewPoi(displayUnit="K"),
    HInfHorSou=Buildings.BoundaryConditions.Types.DataSource.File,
    filNam=
        "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{144,160},{164,180}})));

  Modelica.Blocks.Sources.Constant uSha(k=0)
    "Control signal for the shading device"
    annotation (Placement(transformation(extent={{-48,92},{-28,112}})));
  Modelica.Blocks.Routing.Replicator replicator(nout=max(1, nConExtWin))
    annotation (Placement(transformation(extent={{6,92},{26,112}})));
  HeatTransfer.Sources.FixedTemperature TSoi(each T=T_start)
    "Boundary condition for construction" annotation (Placement(transformation(
          extent={{10,-10},{-10,10}}, origin={172,-34})));
  HeatTransfer.Sources.FixedTemperature TBou[1](each T=T_start)
    "Boundary condition for construction" annotation (Placement(transformation(
          extent={{10,-10},{-10,10}}, origin={174,-68})));
  constant Integer nStaRef=3 "Number of states in a reference material";
  // FIXME - Bug in Dymola 2016?: If the constant is defined
  // before it is used then the model will fail to translate.

  HeatTransfer.Conduction.SingleLayer soil(
    each steadyStateInitial=true,
    each A=13.94,
    material=Buildings.HeatTransfer.Data.Solids.Generic(
        x=2,
        k=1.3,
        c=0,
        d=0,
        nStaRef=nStaRef))
    "2m deep soil (per definition on p.4 of ASHRAE 140-2007)"
    annotation (Placement(transformation(extent={{122,-44},{142,-24}})));
  Fluid.Sources.Outside bou(redeclare package Medium = MediumA, nPorts=1)
    "Boundary condition"
    annotation (Placement(transformation(extent={{-42,42},{-22,62}})));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic matExtWal(
    nLay=3,
    absIR_a=0.9,
    absIR_b=0.9,
    absSol_a=0.6,
    absSol_b=0.6,
    material={Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.000701,
        k=45.345,
        c=502.416,
        d=7833.028,
        nStaRef=nStaRef),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.0127,
        k=0.12,
        c=1210,
        d=540,
        nStaRef=nStaRef),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.133,
        k=0.047,
        c=1006,
        d=93.84,
        nStaRef=nStaRef)}) "71T: South Wall"
    annotation (Placement(transformation(extent={{-16,162},{4,182}})));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic matCeil(
    nLay=3,
    absIR_a=0.9,
    absIR_b=0.9,
    absSol_a=0.6,
    absSol_b=0.6,
    material={Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.009525,
        k=0.12,
        c=1210,
        d=540,
        nStaRef=nStaRef),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.133,
        k=0.047,
        c=1006,
        d=93.84,
        nStaRef=nStaRef),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.015875,
        k=0.17,
        c=1090,
        d=800,
        nStaRef=nStaRef)}) "71T: Ceiling"
    annotation (Placement(transformation(extent={{40,162},{60,182}})));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic matFlo(
    final nLay=4,
    absIR_a=0.9,
    absIR_b=0.9,
    absSol_a=0.6,
    absSol_b=0.6,
    material={Buildings.HeatTransfer.Data.Solids.Generic(
        x=5.28,
        k=1,
        c=0,
        d=0,
        nStaRef=nStaRef),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.01905,
        k=0.15,
        c=1630,
        d=608,
        nStaRef=nStaRef),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.01905,
        k=0.12,
        c=1210,
        d=540,
        nStaRef=nStaRef),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.22,
        k=1,
        c=0,
        d=0,
        nStaRef=nStaRef)}) "71T: Floor"
    annotation (Placement(transformation(extent={{64,162},{84,182}})));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic matEWWal(
    final nLay=2,
    absIR_a=0.9,
    absIR_b=0.9,
    absSol_a=0.6,
    absSol_b=0.6,
    material={Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.133,
        k=0.047,
        c=1006,
        d=93.84,
        nStaRef=nStaRef),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.015875,
        k=0.17,
        c=1090,
        d=800,
        nStaRef=nStaRef)}) "71T: East West Wall"
    annotation (Placement(transformation(extent={{14,162},{34,182}})));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic matNWal(
    final nLay=4,
    absIR_a=0.9,
    absIR_b=0.9,
    absSol_a=0.6,
    absSol_b=0.6,
    material={Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.015875,
        k=0.17,
        c=1090,
        d=800,
        nStaRef=nStaRef),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.009525,
        k=0.12,
        c=1210,
        d=540,
        nStaRef=nStaRef),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.133,
        k=0.047,
        c=1006,
        d=93.84,
        nStaRef=nStaRef),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.015875,
        k=0.17,
        c=1090,
        d=800,
        nStaRef=nStaRef)}) "71T: North Wall"
    annotation (Placement(transformation(extent={{90,162},{110,182}})));
  // FIXME: The glass of the window system (glaSys) should be replaced
  // with electrochromic windows.
  parameter HeatTransfer.Data.GlazingSystems.DoubleClearAir13Clear glaSys(
    UFra=2,
    shade=Buildings.HeatTransfer.Data.Shades.Gray(),
    haveInteriorShade=false,
    haveExteriorShade=false) "Data record for the glazing system"
    annotation (Placement(transformation(extent={{-44,162},{-24,182}})));
  Fluid.Sources.MassFlowSource_T masSou(
    use_m_flow_in=true,
    nPorts=1,
    redeclare package Medium = MediumA) "infiltration mass flow source"
    annotation (Placement(transformation(extent={{16,-48},{36,-28}})));
  Modelica.Blocks.Sources.Constant inf(k=-13.94*3.35*0.07/3600)
    "Infiltration rate"
    annotation (Placement(transformation(extent={{-70,-34},{-50,-14}})));
  Modelica.Blocks.Math.Product pro
    annotation (Placement(transformation(extent={{-22,-40},{-2,-20}})));
  Fluid.Sensors.Density senDen(redeclare package Medium = MediumA)
    annotation (Placement(transformation(extent={{6,-78},{-14,-58}})));
  BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{134,66},{158,90}}), iconTransformation(extent={
            {-116,36},{-96,56}})));
  Fluid.FixedResistances.FixedResistanceDpM res(
    redeclare package Medium = MediumA,
    dp_nominal=1,
    m_flow_nominal=13.94*3.35*0.07/3600*1.2)
    annotation (Placement(transformation(extent={{6,40},{26,60}})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1
    annotation (Placement(transformation(extent={{-72,10},{-52,30}})));
  Modelica.Blocks.Sources.Constant qRadGai_flow(k=0) "Radiative heat gain"
    annotation (Placement(transformation(extent={{-112,50},{-92,70}})));
  Modelica.Blocks.Sources.Constant qConGai_flow(k=100) "Convective heat gain"
    annotation (Placement(transformation(extent={{-112,10},{-92,30}})));
  Modelica.Blocks.Sources.Constant qLatGai_flow(k=0) "Latent heat gain"
    annotation (Placement(transformation(extent={{-114,-28},{-94,-8}})));
  Controls.Continuous.LimPID conHea(
    k=0.1,
    Ti=300,
    controllerType=Modelica.Blocks.Types.SimpleController.PI)
    "Controller for heating"
    annotation (Placement(transformation(extent={{-80,-122},{-60,-102}})));
  Controls.Continuous.LimPID conCoo(
    k=0.1,
    Ti=300,
    controllerType=Modelica.Blocks.Types.SimpleController.PI)
    "Controller for cooling"
    annotation (Placement(transformation(extent={{-80,-166},{-60,-146}})));
  Modelica.Blocks.Sources.Constant THea(k=24 + 273.15) "Heating setpoint"
    annotation (Placement(transformation(extent={{-126,-122},{-106,-102}})));
  Modelica.Blocks.Sources.Constant TCoo(k=24.5 + 273.15) "Cooling setpoint"
    annotation (Placement(transformation(extent={{-122,-166},{-102,-146}})));
  Modelica.Blocks.Math.Gain gaiHea(k=1e6)
    annotation (Placement(transformation(extent={{-30,-122},{-10,-102}})));
  Modelica.Blocks.Math.Gain gaiCoo(k=-1e6)
    annotation (Placement(transformation(extent={{-28,-166},{-8,-146}})));
  Modelica.Blocks.Math.Sum sum(nin=2)
    annotation (Placement(transformation(extent={{50,-146},{70,-126}})));
  Modelica.Blocks.Routing.Multiplex2 mux
    annotation (Placement(transformation(extent={{12,-146},{32,-126}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
    annotation (Placement(transformation(extent={{92,-146},{112,-126}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen
    "Room air temperature sensor"
    annotation (Placement(transformation(extent={{114,-186},{94,-166}})));
equation
  for i in 2:nConBou loop
    connect(TBou[1].port, roo.surf_conBou[i]) annotation (Line(points={{164,-68},
            {114,-68},{114,44},{92,44}}, color={191,0,0}));
  end for;

  connect(uSha.y, replicator.u) annotation (Line(
      points={{-27,102},{4,102}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(roo.uSha, replicator.y) annotation (Line(
      points={{64,76},{64,102},{27,102}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(TSoi.port, soil.port_b)
    annotation (Line(points={{162,-34},{142,-34}}, color={191,0,0}));
  connect(soil.port_a, roo.surf_conBou[1]) annotation (Line(points={{122,-34},{
          122,-34},{92,-34},{92,44}}, color={191,0,0}));
  connect(inf.y, pro.u1)
    annotation (Line(points={{-49,-24},{-24,-24}}, color={0,0,127}));
  connect(senDen.port, roo.ports[1]) annotation (Line(points={{-4,-78},{-4,-78},
          {62,-78},{62,47},{71,47}}, color={0,127,255}));
  connect(senDen.d, pro.u2) annotation (Line(points={{-15,-68},{-24,-68},{-36,-68},
          {-36,-36},{-24,-36}}, color={0,0,127}));
  connect(pro.y, masSou.m_flow_in)
    annotation (Line(points={{-1,-30},{10,-30},{16,-30}}, color={0,0,127}));
  connect(masSou.ports[1], roo.ports[2]) annotation (Line(points={{36,-38},{66,
          -38},{66,49},{71,49}}, color={0,127,255}));
  connect(weaBus, roo.weaBus) annotation (Line(
      points={{146,78},{140,78},{140,77.9},{103.9,77.9}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus, weaDat1.weaBus) annotation (Line(
      points={{146,78},{146,76},{200,76},{200,170},{164,170}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(bou.weaBus, weaBus) annotation (Line(
      points={{-42,52.2},{-42,52.2},{-64,52.2},{-64,136},{176,136},{176,78},{
          146,78}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(res.port_a, bou.ports[1])
    annotation (Line(points={{6,50},{-22,50},{-22,52}}, color={0,127,255}));
  connect(res.port_b, roo.ports[3]) annotation (Line(points={{26,50},{26,50},{
          26,51},{71,51}}, color={0,127,255}));
  connect(qRadGai_flow.y, multiplex3_1.u1[1]) annotation (Line(points={{-91,60},
          {-84,60},{-84,62},{-84,27},{-74,27}}, color={0,0,127}));
  connect(qConGai_flow.y, multiplex3_1.u2[1])
    annotation (Line(points={{-91,20},{-82.5,20},{-74,20}}, color={0,0,127}));
  connect(qLatGai_flow.y, multiplex3_1.u3[1]) annotation (Line(points={{-93,-18},
          {-88,-18},{-88,10},{-74,10},{-74,13}}, color={0,0,127}));
  connect(multiplex3_1.y, roo.qGai_flow) annotation (Line(points={{-51,20},{-51,
          20},{38,20},{38,68},{64,68}}, color={0,0,127}));
  connect(THea.y, conHea.u_s) annotation (Line(points={{-105,-112},{-105,-112},
          {-82,-112}},color={0,0,127}));
  connect(TCoo.y, conCoo.u_s) annotation (Line(points={{-101,-156},{-101,-156},
          {-82,-156}}, color={0,0,127}));
  connect(gaiHea.u, conHea.y) annotation (Line(points={{-32,-112},{-44,-112},{-59,
          -112}}, color={0,0,127}));
  connect(gaiCoo.u, conCoo.y)
    annotation (Line(points={{-30,-156},{-59,-156}}, color={0,0,127}));
  connect(gaiHea.y, mux.u1[1]) annotation (Line(points={{-9,-112},{2,-112},{2,-130},
          {10,-130}}, color={0,0,127}));
  connect(sum.u, mux.y)
    annotation (Line(points={{48,-136},{33,-136}}, color={0,0,127}));
  connect(preHeaFlo.Q_flow, sum.y)
    annotation (Line(points={{92,-136},{71,-136}}, color={0,0,127}));
  connect(temSen.T, conCoo.u_m) annotation (Line(points={{94,-176},{14,-176},{-70,
          -176},{-70,-168}}, color={0,0,127}));
  connect(temSen.T, conHea.u_m) annotation (Line(points={{94,-176},{26,-176},{-46,
          -176},{-46,-132},{-70,-132},{-70,-124}}, color={0,0,127}));
  connect(roo.heaPorAir, preHeaFlo.port) annotation (Line(points={{85,60},{85,-110},
          {120,-110},{120,-136},{112,-136}}, color={191,0,0}));
  connect(temSen.port, preHeaFlo.port) annotation (Line(points={{114,-176},{120,
          -176},{120,-136},{112,-136}}, color={191,0,0}));
  connect(gaiCoo.y, mux.u2[1]) annotation (Line(points={{-7,-156},{0,-156},{0,
          -142},{10,-142}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-220},{
            220,200}})),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Rooms/Validation/LBNL_71T_RoomB.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>This model tests the correct implementation of electrochromic window. <span style=\"font-family: Sans Serif;\">This model represents the middle test cell (RoomB) of the window test facility 71T.</span></p>
</html>", revisions="<html>
<ul>
<li>
Augurst 07, 2015, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(StopTime=31536000));
end LBNL_71T_RoomB;
