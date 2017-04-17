within Buildings.Experimental.ScalableModels.ThermalZones.BaseClasses;
model ThermalZoneFluctuatingIHG_North
  "Thermal zone model: North exterior wall"

replaceable package MediumA = Modelica.Media.Interfaces.PartialMedium
    "Medium model";

  parameter Modelica.SIunits.Angle lat "Latitude";
  parameter Real gainFactor(start=1) "IHG fluctuating amplitude factor";

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

  Buildings.ThermalZones.Detailed.MixedAir roo(
    redeclare package Medium = MediumA,
    hRoo=2.7,
    nPorts=2,
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
      azi={N_}),
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
    annotation (Placement(transformation(extent={{-96,80},{-88,88}})));
  Modelica.Blocks.Sources.Constant qRadGai_flow(k=689/48) "Radiative heat gain"
    annotation (Placement(transformation(extent={{-96,110},{-88,118}})));
  Modelica.Blocks.Sources.Constant qLatGai_flow(k=146.5/48) "Latent heat gain"
    annotation (Placement(transformation(extent={{-96,50},{-88,58}})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1
    annotation (Placement(transformation(extent={{-16,72},{-8,80}})));

  Modelica.Blocks.Sources.Constant uSha(k=0)
    "Control signal for the shading device"
    annotation (Placement(transformation(extent={{-16,88},{-8,96}})));
  Buildings.Fluid.Sources.MassFlowSource_T souInf(
    redeclare package Medium = MediumA,
    m_flow=1,
    use_m_flow_in=true,
    use_T_in=false,
    use_X_in=false,
    use_C_in=false,
    nPorts=1) "Source model for air infiltration"
    annotation (Placement(transformation(extent={{4,-66},{16,-54}})));
  Buildings.Fluid.Sources.Outside sinInf(redeclare package Medium = MediumA,
      nPorts=1) "Sink model for air infiltration"
           annotation (Placement(transformation(extent={{-24,-34},{-12,-22}})));
  Modelica.Blocks.Sources.Constant InfiltrationRate(k=48*2.7*0.5/3600)
    "0.41 ACH adjusted for the altitude (0.5 at sea level)"
    annotation (Placement(transformation(extent={{-96,-56},{-88,-48}})));
  Modelica.Blocks.Math.Product product
    annotation (Placement(transformation(extent={{-50,-60},{-40,-50}})));
  Buildings.Fluid.Sensors.Density density(redeclare package Medium = MediumA)
    "Air density inside the building"
    annotation (Placement(transformation(extent={{-40,-76},{-50,-66}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    "Weather data bus"
    annotation (Placement(transformation(extent={{-80,-88},{-64,-72}}),
        iconTransformation(extent={{-80,-88},{-64,-72}})));
  Modelica.Blocks.Math.MultiSum multiSum(nu=1)
    annotation (Placement(transformation(extent={{-78,-58},{-66,-46}})));

  final parameter HeatTransfer.Data.Solids.Plywood matFur(x=0.15, nStaRef=5)
    "Material for furniture"
    annotation (Placement(transformation(extent={{122,138},{142,158}})));

  final parameter HeatTransfer.Data.Solids.Concrete matCon(
    x=0.1,
    k=1.311,
    c=836,
    nStaRef=5) "Concrete"
    annotation (Placement(transformation(extent={{122,108},{142,128}})));
  final parameter HeatTransfer.Data.Solids.Plywood matWoo(
    x=0.01,
    k=0.11,
    d=544,
    nStaRef=1) "Wood for exterior construction"
    annotation (Placement(transformation(extent={{122,78},{142,98}})));
  final parameter HeatTransfer.Data.Solids.Generic matIns(
    x=0.087,
    k=0.049,
    c=836.8,
    d=265,
    nStaRef=5) "Steelframe construction with insulation"
    annotation (Placement(transformation(extent={{162,78},{182,98}})));
  final parameter HeatTransfer.Data.Solids.GypsumBoard matGyp(
    x=0.0127,
    k=0.16,
    c=830,
    d=784,
    nStaRef=2) "Gypsum board"
    annotation (Placement(transformation(extent={{120,50},{140,70}})));
  final parameter HeatTransfer.Data.Solids.GypsumBoard matGyp2(
    x=0.025,
    k=0.16,
    c=830,
    d=784,
    nStaRef=2) "Gypsum board"
    annotation (Placement(transformation(extent={{160,50},{180,70}})));
  final parameter HeatTransfer.Data.OpaqueConstructions.Generic conExtWal(final nLay=3,
      material={matWoo,matIns,matGyp}) "Exterior construction"
    annotation (Placement(transformation(extent={{194,138},{214,158}})));
  final parameter HeatTransfer.Data.OpaqueConstructions.Generic conIntWal(final nLay=1,
      material={matGyp2}) "Interior wall construction"
    annotation (Placement(transformation(extent={{234,138},{254,158}})));
  final parameter HeatTransfer.Data.OpaqueConstructions.Generic conFlo(final nLay=1, material={
        matCon}) "Floor construction (opa_a is carpet)"
    annotation (Placement(transformation(extent={{196,98},{216,118}})));
  final parameter HeatTransfer.Data.Solids.Plywood matCarTra(
    k=0.11,
    d=544,
    nStaRef=1,
    x=0.215/0.11) "Wood for floor"
    annotation (Placement(transformation(extent={{84,138},{104,158}})));
  final parameter HeatTransfer.Data.GlazingSystems.DoubleClearAir13Clear glaSys(
    UFra=2,
    shade=Buildings.HeatTransfer.Data.Shades.Gray(),
    haveInteriorShade=false,
    haveExteriorShade=false) "Data record for the glazing system"
    annotation (Placement(transformation(extent={{154,138},{174,158}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorWal1
    "Heat port connected to common wall" annotation (Placement(transformation(
          extent={{-110,-10},{-90,10}}), iconTransformation(extent={{-110,-10},
            {-90,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorFlo
    "Heat port connected to floor" annotation (Placement(transformation(extent={
            {-10,-110},{10,-90}}), iconTransformation(extent={{-10,-112},{10,-92}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heaPorCei
    "Heat port connected to ceiling" annotation (Placement(transformation(
          extent={{-10,90},{10,110}}), iconTransformation(extent={{-10,90},{10,110}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heaPorWal2
    "Heat port connected to common wall" annotation (Placement(transformation(
          extent={{110,-10},{130,10}}), iconTransformation(extent={{92,-10},{112,
            10}})));
  Modelica.Blocks.Sources.Sine sine(freqHz=1/86400, startTime=7*3600)
    annotation (Placement(transformation(extent={{-96,96},{-88,104}})));
  Modelica.Blocks.Sources.Sine sine1(freqHz=1/86400, startTime=7*3600)
    annotation (Placement(transformation(extent={{-96,66},{-88,74}})));
  Modelica.Blocks.Sources.Sine sine2(freqHz=1/86400, startTime=7*3600)
    annotation (Placement(transformation(extent={{-96,36},{-88,44}})));
  Modelica.Blocks.Math.Product product1
    annotation (Placement(transformation(extent={{-56,102},{-46,112}})));
  Modelica.Blocks.Math.Gain gain(k=gainFactor)
    annotation (Placement(transformation(extent={{-40,102},{-30,112}})));
  Modelica.Blocks.Math.Product product2
    annotation (Placement(transformation(extent={{-56,71},{-46,81}})));
  Modelica.Blocks.Math.Gain gain1(k=gainFactor)
    annotation (Placement(transformation(extent={{-40,71},{-30,81}})));
  Modelica.Blocks.Math.Product product3
    annotation (Placement(transformation(extent={{-56,42},{-46,52}})));
  Modelica.Blocks.Math.Gain gain2(k=gainFactor)
    annotation (Placement(transformation(extent={{-40,42},{-30,52}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold
    annotation (Placement(transformation(extent={{-84,96},{-76,104}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal
    annotation (Placement(transformation(extent={{-72,96},{-64,104}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold1
    annotation (Placement(transformation(extent={{-84,66},{-76,74}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal1
    annotation (Placement(transformation(extent={{-72,66},{-64,74}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold2
    annotation (Placement(transformation(extent={{-84,36},{-76,44}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal2
    annotation (Placement(transformation(extent={{-72,36},{-64,44}})));
equation
  connect(multiplex3_1.y, roo.qGai_flow) annotation (Line(
      points={{-7.6,76},{20,76},{20,5},{34.8,5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product.y, souInf.m_flow_in) annotation (Line(
      points={{-39.5,-55},{-36,-55},{-36,-55.2},{4,-55.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(density.port, roo.ports[1])  annotation (Line(
      points={{-45,-76},{32,-76},{32,-10},{39.75,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(density.d, product.u2) annotation (Line(
      points={{-50.5,-71},{-56,-71},{-56,-58},{-51,-58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(souInf.ports[1], roo.ports[1]) annotation (Line(
      points={{16,-60},{30,-60},{30,-10},{39.75,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(multiSum.y, product.u1) annotation (Line(
      points={{-64.98,-52},{-51,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(InfiltrationRate.y, multiSum.u[1]) annotation (Line(
      points={{-87.6,-52},{-78,-52}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(sinInf.ports[1], roo.ports[2]) annotation (Line(points={{-12,-28},{14,
          -28},{14,-7},{39.75,-7}},       color={0,127,255}));
  connect(roo.surf_conBou[1], heaPorFlo) annotation (Line(points={{55.5,-13.375},
          {55.5,-86},{0,-86},{0,-100}}, color={191,0,0}));
  connect(roo.surf_conBou[2], heaPorWal1) annotation (Line(points={{55.5,
          -12.625},{55.5,-16},{-100,-16},{-100,0}},
                                                  color={191,0,0}));
  connect(roo.surf_surBou[1], heaPorCei) annotation (Line(points={{48.15,-11.875},
          {48.15,-20},{0,-20},{0,100}}, color={191,0,0}));
  connect(roo.surf_surBou[1], heaPorWal2) annotation (Line(points={{48.15,-11.875},
          {48.15,-20},{120,-20},{120,0}}, color={191,0,0}));
  connect(uSha.y, roo.uSha[1]) annotation (Line(points={{-7.6,92},{26,92},{26,
          12.5},{34.8,12.5}}, color={0,0,127}));
  connect(weaBus, roo.weaBus) annotation (Line(
      points={{-72,-80},{-72,-80},{72,-80},{72,12.425},{64.425,12.425}},
      color={255,204,51},
      thickness=0.5));
  connect(sinInf.weaBus, weaBus) annotation (Line(
      points={{-24,-27.88},{-30,-27.88},{-30,-80},{-72,-80}},
      color={255,204,51},
      thickness=0.5));
  connect(qRadGai_flow.y, product1.u1) annotation (Line(points={{-87.6,114},{
          -80,114},{-80,110},{-57,110}}, color={0,0,127}));
  connect(qConGai_flow.y, product2.u1) annotation (Line(points={{-87.6,84},{-80,
          84},{-80,79},{-57,79}}, color={0,0,127}));
  connect(qLatGai_flow.y, product3.u1) annotation (Line(points={{-87.6,54},{-80,
          54},{-80,50},{-57,50}}, color={0,0,127}));
  connect(product3.y, gain2.u) annotation (Line(points={{-45.5,47},{-45.5,47},{
          -41,47}},  color={0,0,127}));
  connect(product2.y, gain1.u) annotation (Line(points={{-45.5,76},{-45.5,76},{
          -41,76}},  color={0,0,127}));
  connect(product1.y, gain.u) annotation (Line(points={{-45.5,107},{-45.5,107},
          {-41,107}},
                    color={0,0,127}));
  connect(gain.y, multiplex3_1.u1[1]) annotation (Line(points={{-29.5,107},{
          -29.5,106},{-28,106},{-28,80},{-16.8,80},{-16.8,78.8}},
                                                          color={0,0,127}));
  connect(gain1.y, multiplex3_1.u2[1]) annotation (Line(points={{-29.5,76},{
          -16.8,76}},      color={0,0,127}));
  connect(gain2.y, multiplex3_1.u3[1]) annotation (Line(points={{-29.5,47},{
          -29.5,48},{-28,48},{-28,72},{-20,72},{-16.8,72},{-16.8,73.2}},
        color={0,0,127}));
  connect(sine.y, greaterThreshold.u)
    annotation (Line(points={{-87.6,100},{-86,100},{-84.8,100}},
                                                       color={0,0,127}));
  connect(greaterThreshold.y, booleanToReal.u)
    annotation (Line(points={{-75.6,100},{-74,100},{-72.8,100}},
                                                       color={255,0,255}));
  connect(booleanToReal.y, product1.u2) annotation (Line(points={{-63.6,100},{
          -60,100},{-60,104},{-57,104}},
                                     color={0,0,127}));
  connect(sine1.y, greaterThreshold1.u) annotation (Line(points={{-87.6,70},{
          -84.8,70}},      color={0,0,127}));
  connect(greaterThreshold1.y, booleanToReal1.u) annotation (Line(points={{-75.6,
          70},{-72.8,70}},            color={255,0,255}));
  connect(booleanToReal1.y, product2.u2) annotation (Line(points={{-63.6,70},{
          -60,70},{-60,73},{-57,73}},
                                  color={0,0,127}));
  connect(sine2.y, greaterThreshold2.u) annotation (Line(points={{-87.6,40},{
          -84.8,40}},      color={0,0,127}));
  connect(greaterThreshold2.y, booleanToReal2.u) annotation (Line(points={{-75.6,
          40},{-74,40},{-72.8,40}},   color={255,0,255}));
  connect(booleanToReal2.y, product3.u2) annotation (Line(points={{-63.6,40},{
          -60,40},{-60,44},{-57,44}},
                                  color={0,0,127}));


  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100, 100}}), graphics={
        Rectangle(
          extent={{-46,-46},{46,46}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          origin={0,0},
          rotation=90),
        Text(
          extent={{-84,8},{-64,-6}},
          lineColor={0,0,255},
          textString="Wall"),
        Text(
          extent={{66,8},{86,-6}},
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
          extent={{-40,40},{40,-40}},
          pattern=LinePattern.None,
          lineColor={117,148,176},
          fillColor={170,213,255},
          fillPattern=FillPattern.Sphere)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{280,180}})));
end ThermalZoneFluctuatingIHG_North;
