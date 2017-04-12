within Buildings.Experimental.ScalableModels.ThermalZones.BaseClasses;
model ThermalZoneFluctuatingIHG "Thermal zone model"

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
    nPorts=3,
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
    annotation (Placement(transformation(extent={{-96,72},{-88,80}})));
  Modelica.Blocks.Sources.Constant qRadGai_flow(k=689/48) "Radiative heat gain"
    annotation (Placement(transformation(extent={{-96,116},{-88,124}})));
  Modelica.Blocks.Sources.Constant qLatGai_flow(k=146.5/48) "Latent heat gain"
    annotation (Placement(transformation(extent={{-96,28},{-88,36}})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1
    annotation (Placement(transformation(extent={{-14,64},{-6,72}})));

  Modelica.Blocks.Sources.Constant uSha(k=0)
    "Control signal for the shading device"
    annotation (Placement(transformation(extent={{-14,80},{-6,88}})));
  Buildings.Fluid.Sources.MassFlowSource_T sinInf(
    redeclare package Medium = MediumA,
    m_flow=1,
    use_m_flow_in=true,
    use_T_in=false,
    use_X_in=false,
    use_C_in=false,
    nPorts=1) "Sink model for air infiltration"
    annotation (Placement(transformation(extent={{4,-66},{16,-54}})));
  Buildings.Fluid.Sources.Outside souInf(redeclare package Medium = MediumA,
      nPorts=1) "Source model for air infiltration"
           annotation (Placement(transformation(extent={{-24,-34},{-12,-22}})));
  Modelica.Blocks.Sources.Constant InfiltrationRate(k=-48*2.7*0.5/3600)
    "0.41 ACH adjusted for the altitude (0.5 at sea level)"
    annotation (Placement(transformation(extent={{-96,-78},{-88,-70}})));
  Modelica.Blocks.Math.Product product
    annotation (Placement(transformation(extent={{-50,-60},{-40,-50}})));
  Buildings.Fluid.Sensors.Density density(redeclare package Medium = MediumA)
    "Air density inside the building"
    annotation (Placement(transformation(extent={{-40,-76},{-50,-66}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    "Weather data bus"
    annotation (Placement(transformation(extent={{-68,-88},{-52,-72}}),
        iconTransformation(extent={{-68,-88},{-52,-72}})));
  Modelica.Blocks.Math.MultiSum multiSum(nu=1)
    annotation (Placement(transformation(extent={{-78,-80},{-66,-68}})));

  final parameter HeatTransfer.Data.Solids.Plywood matFur(x=0.15, nStaRef=5)
    "Material for furniture"
    annotation (Placement(transformation(extent={{54,138},{74,158}})));

  final parameter HeatTransfer.Data.Solids.Concrete matCon(
    x=0.1,
    k=1.311,
    c=836,
    nStaRef=5) "Concrete"
    annotation (Placement(transformation(extent={{54,108},{74,128}})));
  final parameter HeatTransfer.Data.Solids.Plywood matWoo(
    x=0.01,
    k=0.11,
    d=544,
    nStaRef=1) "Wood for exterior construction"
    annotation (Placement(transformation(extent={{54,78},{74,98}})));
  final parameter HeatTransfer.Data.Solids.Generic matIns(
    x=0.087,
    k=0.049,
    c=836.8,
    d=265,
    nStaRef=5) "Steelframe construction with insulation"
    annotation (Placement(transformation(extent={{94,78},{114,98}})));
  final parameter HeatTransfer.Data.Solids.GypsumBoard matGyp(
    x=0.0127,
    k=0.16,
    c=830,
    d=784,
    nStaRef=2) "Gypsum board"
    annotation (Placement(transformation(extent={{52,50},{72,70}})));
  final parameter HeatTransfer.Data.Solids.GypsumBoard matGyp2(
    x=0.025,
    k=0.16,
    c=830,
    d=784,
    nStaRef=2) "Gypsum board"
    annotation (Placement(transformation(extent={{92,50},{112,70}})));
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
    annotation (Placement(transformation(extent={{16,138},{36,158}})));
  final parameter HeatTransfer.Data.GlazingSystems.DoubleClearAir13Clear glaSys(
    UFra=2,
    shade=Buildings.HeatTransfer.Data.Shades.Gray(),
    haveInteriorShade=false,
    haveExteriorShade=false) "Data record for the glazing system"
    annotation (Placement(transformation(extent={{154,138},{174,158}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorWal1
    "Heat port connected to common wall" annotation (Placement(transformation(
          extent={{-110,-26},{-90,-6}}), iconTransformation(extent={{-110,-26},{
            -90,-6}})));
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
    annotation (Placement(transformation(extent={{-96,102},{-88,110}})));
  Modelica.Blocks.Sources.Sine sine1(freqHz=1/86400, startTime=7*3600)
    annotation (Placement(transformation(extent={{-96,58},{-88,66}})));
  Modelica.Blocks.Sources.Sine sine2(freqHz=1/86400, startTime=7*3600)
    annotation (Placement(transformation(extent={{-96,14},{-88,22}})));
  Modelica.Blocks.Math.Product product1
    annotation (Placement(transformation(extent={{-56,108},{-46,118}})));
  Modelica.Blocks.Math.Gain gain(k=gainFactor)
    annotation (Placement(transformation(extent={{-40,108},{-30,118}})));
  Modelica.Blocks.Math.Product product2
    annotation (Placement(transformation(extent={{-56,63},{-46,73}})));
  Modelica.Blocks.Math.Gain gain1(k=gainFactor)
    annotation (Placement(transformation(extent={{-40,63},{-30,73}})));
  Modelica.Blocks.Math.Product product3
    annotation (Placement(transformation(extent={{-56,20},{-46,30}})));
  Modelica.Blocks.Math.Gain gain2(k=gainFactor)
    annotation (Placement(transformation(extent={{-40,20},{-30,30}})));
  Modelica.Blocks.Sources.Constant constant1(k=0) "threshold value"
    annotation (Placement(transformation(extent={{-96,88},{-88,96}})));
  Modelica.Blocks.Sources.Constant constant2(k=0) "threshold value"
    annotation (Placement(transformation(extent={{-96,44},{-88,52}})));
  Modelica.Blocks.Sources.Constant constant3(k=0) "threshold value"
    annotation (Placement(transformation(extent={{-96,0},{-88,8}})));
  Modelica.Blocks.Math.Max max
    annotation (Placement(transformation(extent={{-76,96},{-68,104}})));
  Modelica.Blocks.Math.Max max1
    annotation (Placement(transformation(extent={{-76,50},{-68,58}})));
  Modelica.Blocks.Math.Max max2
    annotation (Placement(transformation(extent={{-76,6},{-68,14}})));
equation
  connect(multiplex3_1.y, roo.qGai_flow) annotation (Line(
      points={{-5.6,68},{20,68},{20,5},{34.8,5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product.y, sinInf.m_flow_in)       annotation (Line(
      points={{-39.5,-55},{-36,-55},{-36,-55.2},{4,-55.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(density.port, roo.ports[1])  annotation (Line(
      points={{-45,-76},{32,-76},{32,-10.5},{39.75,-10.5}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(density.d, product.u2) annotation (Line(
      points={{-50.5,-71},{-56,-71},{-56,-58},{-51,-58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sinInf.ports[1], roo.ports[2])        annotation (Line(
      points={{16,-60},{30,-60},{30,-8.5},{39.75,-8.5}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(multiSum.y, product.u1) annotation (Line(
      points={{-64.98,-74},{-54,-74},{-54,-52},{-51,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(InfiltrationRate.y, multiSum.u[1]) annotation (Line(
      points={{-87.6,-74},{-78,-74}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(souInf.ports[1], roo.ports[3]) annotation (Line(points={{-12,-28},{14,
          -28},{14,-6.5},{39.75,-6.5}},   color={0,127,255}));
  connect(roo.surf_conBou[1], heaPorFlo) annotation (Line(points={{55.5,-13.375},
          {55.5,-86},{0,-86},{0,-100}}, color={191,0,0}));
  connect(roo.surf_conBou[2], heaPorWal1) annotation (Line(points={{55.5,-12.625},
          {55.5,-16},{-80,-16},{-100,-16}},       color={191,0,0}));
  connect(roo.surf_surBou[1], heaPorCei) annotation (Line(points={{48.15,-11.875},
          {48.15,-20},{0,-20},{0,100}}, color={191,0,0}));
  connect(roo.surf_surBou[1], heaPorWal2) annotation (Line(points={{48.15,-11.875},
          {48.15,-20},{120,-20},{120,0}}, color={191,0,0}));
  connect(uSha.y, roo.uSha[1]) annotation (Line(points={{-5.6,84},{26,84},{26,12.5},
          {34.8,12.5}},       color={0,0,127}));
  connect(weaBus, roo.weaBus) annotation (Line(
      points={{-60,-80},{4,-80},{72,-80},{72,12.425},{64.425,12.425}},
      color={255,204,51},
      thickness=0.5));
  connect(souInf.weaBus, weaBus) annotation (Line(
      points={{-24,-27.88},{-30,-27.88},{-30,-80},{-60,-80}},
      color={255,204,51},
      thickness=0.5));
  connect(qRadGai_flow.y, product1.u1) annotation (Line(points={{-87.6,120},{-80,
          120},{-80,116},{-57,116}},     color={0,0,127}));
  connect(qConGai_flow.y, product2.u1) annotation (Line(points={{-87.6,76},{-80,
          76},{-80,71},{-57,71}}, color={0,0,127}));
  connect(qLatGai_flow.y, product3.u1) annotation (Line(points={{-87.6,32},{-80,
          32},{-80,28},{-57,28}}, color={0,0,127}));
  connect(product3.y, gain2.u) annotation (Line(points={{-45.5,25},{-45.5,25},{-41,
          25}},      color={0,0,127}));
  connect(product2.y, gain1.u) annotation (Line(points={{-45.5,68},{-45.5,68},{-41,
          68}},      color={0,0,127}));
  connect(product1.y, gain.u) annotation (Line(points={{-45.5,113},{-45.5,113},{
          -41,113}},color={0,0,127}));
  connect(gain.y, multiplex3_1.u1[1]) annotation (Line(points={{-29.5,113},{-29.5,
          98},{-28,98},{-28,72},{-14.8,72},{-14.8,70.8}}, color={0,0,127}));
  connect(gain1.y, multiplex3_1.u2[1]) annotation (Line(points={{-29.5,68},{-14.8,
          68}},            color={0,0,127}));
  connect(gain2.y, multiplex3_1.u3[1]) annotation (Line(points={{-29.5,25},{-29.5,
          40},{-28,40},{-28,64},{-20,64},{-14.8,64},{-14.8,65.2}},
        color={0,0,127}));
  connect(sine.y, max.u1) annotation (Line(points={{-87.6,106},{-80,106},{-80,102.4},
          {-76.8,102.4}}, color={0,0,127}));
  connect(constant1.y, max.u2) annotation (Line(points={{-87.6,92},{-80,92},{-80,
          97.6},{-76.8,97.6}}, color={0,0,127}));
  connect(max.y, product1.u2) annotation (Line(points={{-67.6,100},{-62,100},{-62,
          110},{-57,110}}, color={0,0,127}));
  connect(sine1.y, max1.u1) annotation (Line(points={{-87.6,62},{-80,62},{-80,56.4},
          {-76.8,56.4}}, color={0,0,127}));
  connect(constant2.y, max1.u2) annotation (Line(points={{-87.6,48},{-80,48},{-80,
          51.6},{-76.8,51.6}}, color={0,0,127}));
  connect(sine2.y, max2.u1) annotation (Line(points={{-87.6,18},{-80,18},{-80,12.4},
          {-76.8,12.4}}, color={0,0,127}));
  connect(constant3.y, max2.u2) annotation (Line(points={{-87.6,4},{-80,4},{-80,
          7.6},{-76.8,7.6}}, color={0,0,127}));
  connect(max2.y, product3.u2) annotation (Line(points={{-67.6,10},{-62,10},{-62,
          22},{-57,22}}, color={0,0,127}));
  connect(max1.y, product2.u2) annotation (Line(points={{-67.6,54},{-62,54},{-62,
          65},{-57,65}}, color={0,0,127}));
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
end ThermalZoneFluctuatingIHG;
