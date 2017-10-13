within Buildings.Examples.ScalableBenchmarks.BuildingVAV.ThermalZones;
model ThermalZone "Thermal zone model"

  replaceable package MediumA = Modelica.Media.Interfaces.PartialMedium
    "Medium model";

  parameter Modelica.SIunits.Angle lat "Latitude";
  parameter Real gainFactor(start=1) "IHG fluctuating amplitude factor";
  parameter Real VInf_flow=(roo.AFlo*roo.hRoo)*0.5/3600 "Infiltration volume flow rate";

  final parameter Modelica.SIunits.Angle S_=
    Buildings.Types.Azimuth.S "Azimuth for south walls";
  final parameter Modelica.SIunits.Angle E_=
    Buildings.Types.Azimuth.E "Azimuth for east walls";
  final parameter Modelica.SIunits.Angle W_=
    Buildings.Types.Azimuth.W "Azimuth for west walls";
  final parameter Modelica.SIunits.Angle N_=
    Buildings.Types.Azimuth.N "Azimuth for north walls";
  final parameter Modelica.SIunits.Angle C_=
    Buildings.Types.Tilt.Ceiling "Tilt for ceiling";
  final parameter Modelica.SIunits.Angle F_=
    Buildings.Types.Tilt.Floor "Tilt for floor";
  final parameter Modelica.SIunits.Angle Z_=
    Buildings.Types.Tilt.Wall "Tilt for wall";
  final parameter HeatTransfer.Data.Solids.Plywood matFur(x=0.15, nStaRef=5)
    "Material for furniture"
    annotation (Placement(transformation(extent={{160,120},{180,140}})));
  final parameter HeatTransfer.Data.Solids.Concrete matCon(
    x=0.1,
    k=1.311,
    c=836,
    nStaRef=5) "Concrete"
    annotation (Placement(transformation(extent={{160,98},{180,118}})));
  final parameter HeatTransfer.Data.Solids.Plywood matWoo(
    x=0.01,
    k=0.11,
    d=544,
    nStaRef=1) "Wood for exterior construction"
    annotation (Placement(transformation(extent={{160,78},{180,98}})));
  final parameter HeatTransfer.Data.Solids.Generic matIns(
    x=0.087,
    k=0.049,
    c=836.8,
    d=265,
    nStaRef=5) "Steelframe construction with insulation"
    annotation (Placement(transformation(extent={{200,120},{220,140}})));
  final parameter HeatTransfer.Data.Solids.GypsumBoard matGyp(
    x=0.0127,
    k=0.16,
    c=830,
    d=784,
    nStaRef=2) "Gypsum board"
    annotation (Placement(transformation(extent={{160,58},{180,78}})));
  final parameter HeatTransfer.Data.Solids.GypsumBoard matGyp2(
    x=0.025,
    k=0.16,
    c=830,
    d=784,
    nStaRef=2) "Gypsum board"
    annotation (Placement(transformation(extent={{160,38},{180,58}})));
  final parameter HeatTransfer.Data.OpaqueConstructions.Generic conExtWal(
    final nLay=3,
    material={matWoo,matIns,matGyp}) "Exterior construction"
    annotation (Placement(transformation(extent={{240,140},{260,160}})));
  final parameter HeatTransfer.Data.OpaqueConstructions.Generic conIntWal(
    final nLay=1,
    material={matGyp2}) "Interior wall construction"
    annotation (Placement(transformation(extent={{240,112},{260,132}})));
  final parameter HeatTransfer.Data.OpaqueConstructions.Generic conFlo(
    final nLay=1,
    material={matCon}) "Floor construction (opa_a is carpet)"
    annotation (Placement(transformation(extent={{240,86},{260,106}})));
  final parameter HeatTransfer.Data.Solids.Plywood matCarTra(
    k=0.11,
    d=544,
    nStaRef=1,
    x=0.215/0.11) "Wood for floor"
    annotation (Placement(transformation(extent={{160,140},{180,160}})));
  final parameter HeatTransfer.Data.GlazingSystems.DoubleClearAir13Clear glaSys(
    UFra=2,
    shade=Buildings.HeatTransfer.Data.Shades.Gray(),
    haveInteriorShade=false,
    haveExteriorShade=false) "Data record for the glazing system"
    annotation (Placement(transformation(extent={{200,140},{220,160}})));

  Modelica.Blocks.Interfaces.RealOutput TRooAir "Room air temperatures"
    annotation (Placement(transformation(extent={{92,26},{112,46}}),
        iconTransformation(extent={{92,30},{112,50}})));
  Modelica.Blocks.Interfaces.RealOutput heaCooPow "HVAC power"
    annotation (Placement(transformation(extent={{92,46},{112,66}}),
        iconTransformation(extent={{92,70},{112,90}})));
  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b portsInOut[2](
    redeclare package Medium = MediumA) "Fluid inlets and outlets"
    annotation (Placement(transformation(extent={{-88,16},{-48,32}}),
        iconTransformation(extent={{-94,32},{-54,48}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort supAirTem(
    redeclare package Medium = MediumA,
    m_flow_nominal=1,
    tau=0)
    "Supply air temperature sensor"
    annotation (Placement(transformation(extent={{-24,9}, {-12,21}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort retAirTem(
    redeclare package Medium = MediumA,
    m_flow_nominal=1,
    tau=0)
    "Return air temperature sensor"
    annotation (Placement(transformation(extent={{-12,26}, {-24,38}})));
  Buildings.Fluid.Sensors.MassFlowRate supplyAirFlow(
    redeclare package Medium = MediumA) "Supply air flow rate"
    annotation (Placement(transformation(extent={{-44,10},{-34,20}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorWal1
    "Heat port connected to common wall"
    annotation (Placement(transformation(extent={{-110,-26},{-90,-6}}),
      iconTransformation(extent={{-110,-10},{-90,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorFlo
    "Heat port connected to floor"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}}),
      iconTransformation(extent={{-10,-112},{10,-92}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heaPorCei
    "Heat port connected to ceiling"
    annotation (Placement(transformation(extent={{-10,90},{10,110}}),
      iconTransformation(extent={{-10,90},{10,110}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heaPorWal2
    "Heat port connected to common wall"
    annotation (Placement(transformation(extent={{110,-10},{130,10}}),
      iconTransformation(extent={{90,-10},{110,10}})));

  Buildings.ThermalZones.Detailed.MixedAir roo(
    redeclare package Medium = MediumA,
    hRoo=2.7,
    nPorts=4,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    AFlo=6*8,
    datConExtWin(
      layers={conExtWal},
      A={8*2.7},
      glaSys={glaSys},
      wWin={2*3},
      hWin={2},
      fFra={0.001},
      til={Z_},
      azi={S_}),
    datConBou(
      layers={conFlo, conIntWal},
      A={6*8, 6*2.7},
      til={F_, Z_}),
    surBou(
      A={6*8, 6*2.7},
      til={C_, Z_},
      absIR = {conFlo.absIR_a, conIntWal.absIR_a},
      absSol = {conFlo.absSol_a, conIntWal.absSol_a}),
    datConPar(
      layers={conIntWal},
      A={8*2.7/2},
      til={Buildings.Types.Tilt.Wall}),
    nConExt=0,
    nConPar=1,
    nSurBou=2,
    nConBou=2,
    nConExtWin=1,
    lat=lat)
    "Room model, adapted from BESTEST Case 600 and VAVReheat model (for constructions)"
    annotation (Placement(transformation(extent={{36,-16},{66,14}})));
  Modelica.Blocks.Sources.Constant qConGai_flow(k=579/48) "Convective heat gain"
    annotation (Placement(transformation(extent={{-88,66},{-76,78}})));
  Modelica.Blocks.Sources.Constant qRadGai_flow(k=689/48) "Radiative heat gain"
    annotation (Placement(transformation(extent={{-88,92},{-76,104}})));
  Modelica.Blocks.Sources.Constant qLatGai_flow(k=146.5/48) "Latent heat gain"
    annotation (Placement(transformation(extent={{-88,40},{-76,52}})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1 "Sum of heat gain"
    annotation (Placement(transformation(extent={{-16,64},{-8,72}})));
  Modelica.Blocks.Sources.Constant uSha(k=0)
    "Control signal for the shading device"
    annotation (Placement(transformation(extent={{-16,80},{-8,88}})));
  Buildings.Fluid.Sources.Outside sinInf(
    redeclare package Medium = MediumA,
    nPorts=1) "Sink model for air infiltration"
    annotation (Placement(transformation(extent={{-22,-34},{-10,-22}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    "Weather data bus"
    annotation (Placement(transformation(extent={{-82,-88},{-66,-72}}),
      iconTransformation(extent={{-82,-88},{-66,-72}})));
  Modelica.Blocks.Math.Product product1 "Scheduled radiative heat gain"
    annotation (Placement(transformation(extent={{-56,90},{-46,100}})));
  Modelica.Blocks.Math.Gain gain(k=gainFactor) "Factorized radiative heat gain"
    annotation (Placement(transformation(extent={{-40,90},{-30,100}})));
  Modelica.Blocks.Math.Product product2 "Scheduled convective heat gain"
    annotation (Placement(transformation(extent={{-56,63},{-46,73}})));
  Modelica.Blocks.Math.Gain gain1(k=gainFactor)
    "Factorized convective heat gain"
    annotation (Placement(transformation(extent={{-40,63},{-30,73}})));
  Modelica.Blocks.Math.Product product3 "Scheduled latent heat gain"
    annotation (Placement(transformation(extent={{-56,38},{-46,48}})));
  Modelica.Blocks.Math.Gain gain2(k=gainFactor) "Factorized latent heat gain"
    annotation (Placement(transformation(extent={{-40,38},{-30,48}})));
  Modelica.Blocks.Sources.RealExpression powCal(y=supplyAirFlow.m_flow*1005*(
        supAirTem.T - TRooAir))
    "Power calculation, with cooling negative and heating positive"
    annotation (Placement(transformation(extent={{54,46},{74,66}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor rooAirTem
    "Air temperature sensor"
    annotation (Placement(transformation(extent={{66,30}, {78,42}})));
  Buildings.Examples.ScalableBenchmarks.BuildingVAV.BaseClasses.IntLoad intLoad(
    table=[0,0.1;
           ((gainFactor - 0.5) + 8)*3600,1.0;
           ((gainFactor - 0.5) + 18)*3600,0.1;
           24*3600,0.1]) "Internal load schedule"
    annotation (Placement(transformation(extent={{-90,114},{-76,128}})));
  Fluid.Sources.MassFlowSource_T  souInf(
    redeclare package Medium = MediumA,
    nPorts=1,
    use_m_flow_in=false,
    m_flow=-VInf_flow*1.2)  "Source model for air infiltration"
    annotation (Placement(transformation(extent={{-20,-58},{-8,-46}})));
  Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium = MediumA,
    m_flow_nominal=VInf_flow*1.2,
    dp_nominal=20,
    linearized=true) "Pressure drop for infiltration"
    annotation (Placement(transformation(extent={{2,-38},{22,-18}})));

equation
  connect(multiplex3_1.y, roo.qGai_flow)
    annotation (Line(points={{-7.6,68},{20,68},{20,5},{34.8,5}},
      color={0,0,127}, smooth=Smooth.None));
  connect(roo.surf_conBou[1], heaPorFlo)
    annotation (Line(points={{55.5,-13.375},{55.5,-86},{0,-86},{0,-100}},
      color={191,0,0}));
  connect(roo.surf_conBou[2], heaPorWal1)
    annotation (Line(points={{55.5,-12.625},{55.5,-16},{-100,-16}},
      color={191,0,0}));
  connect(roo.surf_surBou[1], heaPorCei)
    annotation (Line(points={{48.15,-11.875},{48.15,-20},{0,-20},{0,100}},
      color={191,0,0}));
  connect(roo.surf_surBou[1], heaPorWal2)
    annotation (Line(points={{48.15,-11.875},{48.15,-20},{120,-20},{120,0}},
      color={191,0,0}));
  connect(uSha.y, roo.uSha[1])
    annotation (Line(points={{-7.6,84},{26,84},{26,12.5},{34.8,12.5}},
      color={0,0,127}));
  connect(weaBus, roo.weaBus)
    annotation (Line(points={{-74,-80},{-74,-80},{72,-80},{72,12.425},
      {64.425,12.425}},  color={255,204,51},   thickness=0.5));
  connect(sinInf.weaBus, weaBus)
    annotation (Line(points={{-22,-27.88},{-30,-27.88},{-30,-80},{-74,-80}},
      color={255,204,51}, thickness=0.5));
  connect(qLatGai_flow.y, product3.u1)
    annotation (Line(points={{-75.4,46},{-75.4,46},{-57,46}},
      color={0,0,127}));
  connect(product3.y, gain2.u)
    annotation (Line(points={{-45.5,43},{-45.5,43},{-41,43}},
      color={0,0,127}));
  connect(product2.y, gain1.u)
    annotation (Line(points={{-45.5,68},{-45.5,68},{-41,68}},
      color={0,0,127}));
  connect(product1.y, gain.u)
    annotation (Line(points={{-45.5,95},{-45.5,95},{-41,95}},
      color={0,0,127}));
  connect(gain1.y, multiplex3_1.u2[1])
    annotation (Line(points={{-29.5,68},{-26,68},{-16.8,68}},
      color={0,0,127}));
  connect(qConGai_flow.y, product2.u1)
    annotation (Line(points={{-75.4,72},{-57,72},{-57,71}},
      color={0,0,127}));
  connect(qRadGai_flow.y, product1.u1)
    annotation (Line(points={{-75.4,98},{-66,98},{-57,98}},
      color={0,0,127}));
  connect(gain.y, multiplex3_1.u1[1])
    annotation (Line(points={{-29.5,95},{-22,95},{-22,70.8},{-16.8,70.8}},
      color={0,0,127}));
  connect(gain2.y, multiplex3_1.u3[1])
    annotation (Line(points={{-29.5,43},{-22,43},{-22,65.2},{-16.8,65.2}},
      color={0,0,127}));
  connect(intLoad.y[1], product1.u2)
    annotation (Line(points={{-75.3,121},{-68,121},{-68,92},{-57,92}},
      color={0,0,127}));
  connect(product1.u2, product2.u2)
    annotation (Line(points={{-57,92},{-62,92},{-68,92},{-68,65},{-57,65}},
      color={0,0,127}));
  connect(product1.u2, product3.u2)
    annotation (Line(points={{-57,92},{-68,92},{-68,40},{-57,40}},
      color={0,0,127}));
  connect(souInf.ports[1], roo.ports[1])
    annotation (Line(points={{-8,-52},{32,-52},{32,-10.75},{39.75,-10.75}},
      color={0,127,255}));
  connect(sinInf.ports[1], res.port_a)
    annotation (Line(points={{-10,-28},{2,-28}}, color={0,127,255}));
  connect(res.port_b, roo.ports[2])
    annotation (Line(points={{22,-28},{22,-28},{28,-28},{28,-9.25},{39.75,-9.25}},
      color={0,127,255}));
  connect(supAirTem.port_a,supplyAirFlow.port_b)
    annotation (Line(points={{-24,15},{-34,15}}, color={0,127,255}, smooth=Smooth.None));
  connect(portsInOut[1],supplyAirFlow.port_a)
    annotation (Line(points={{-78,24},{-50,24},{-50,15},{-44,15}},
      color={0,127,255}, smooth=Smooth.None));
  connect(portsInOut[2],retAirTem.port_b)
    annotation (Line(points={{-58,24},{-50,24},{-50,32},{-24,32}},color={0,127,255},
      smooth=Smooth.None));
  connect(rooAirTem.T, TRooAir)
    annotation (Line(points={{78,36},{84,36},{102,36}}, color={0,0,127}));
  connect(powCal.y, heaCooPow)
    annotation (Line(points={{75,56},{102,56}}, color={0,0,127}));
  connect(supAirTem.port_b, roo.ports[3])
    annotation (Line(points={{-12,15},{14,15},{14,-7.75},{39.75,-7.75}},
      color={0,127,255}));
  connect(retAirTem.port_a, roo.ports[4])
    annotation (Line(points={{-12,32},{14,32},{14,-6.25},{39.75,-6.25}},
      color={0,127,255}));
  connect(roo.heaPorAir, rooAirTem.port)
    annotation (Line(points={{50.25,-1},{50.25,36},{66,36}}, color={191,0,0}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100, 100}}), graphics={
        Rectangle(
          extent={{-50,-50},{50,50}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          rotation=90),
        Text(
          extent={{-84,8},{-64,-6}},
          lineColor={0,0,255},
          textString="Wall"),
        Text(
          extent={{64,8},{84,-6}},
          lineColor={0,0,255},
          textString="Wall"),
        Text(
          extent={{-8,-74},{12,-88}},
          lineColor={0,0,255},
          textString="Floor"),
        Text(
          extent={{-10,88},{10,74}},
          lineColor={0,0,255},
          textString="Ceiling"),
        Rectangle(
          extent={{-42,42},{42,-42}},
          pattern=LinePattern.None,
          lineColor={117,148,176},
          fillColor={170,213,255},
          fillPattern=FillPattern.Sphere)}),
      Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{280,180}})),
      Documentation(info="<html>
<p>
This model consist a building envelope model which is extented from
<a href=\"modelica://Buildings.ThermalZones.Detailed.MixedAir\">
Buildings.ThermalZones.Detailed.MixedAir</a>.
</p>
<p>
Internal heat gain which includes radiative heat gain <code>qRadGai_flow</code>,
convective heat gain <code>qConGai_flow</code>, and latent heat gain
<code>qLatGai_flow</code> are referenced from ASHRAE Handbook fundamental.
The factor <code>gainFactor</code> is used to scale up/down the heat gain.
The gain schdule is specified by <code>intLoad</code>.
A constant air infiltration from outside is assumed.
</p>
</html>", revisions="<html>
<ul>
<li>
April 10, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ThermalZone;
