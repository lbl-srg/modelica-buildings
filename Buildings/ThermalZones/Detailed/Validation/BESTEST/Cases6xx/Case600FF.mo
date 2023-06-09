within Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx;
model Case600FF
  "Basic test with light-weight construction and free floating temperature"
  extends Modelica.Icons.Example;

  package MediumA = Buildings.Media.Air "Medium model";
  parameter Modelica.Units.SI.Angle S_=Buildings.Types.Azimuth.S
    "Azimuth for south walls";
  parameter Modelica.Units.SI.Angle E_=Buildings.Types.Azimuth.E
    "Azimuth for east walls";
  parameter Modelica.Units.SI.Angle W_=Buildings.Types.Azimuth.W
    "Azimuth for west walls";
  parameter Modelica.Units.SI.Angle N_=Buildings.Types.Azimuth.N
    "Azimuth for north walls";
  parameter Modelica.Units.SI.Angle C_=Buildings.Types.Tilt.Ceiling
    "Tilt for ceiling";
  parameter Modelica.Units.SI.Angle F_=Buildings.Types.Tilt.Floor
    "Tilt for floor";
  parameter Modelica.Units.SI.Angle Z_=Buildings.Types.Tilt.Wall
    "Tilt for wall";
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
        nStaRef=nStaRef)},
    roughness_a=Buildings.HeatTransfer.Types.SurfaceRoughness.Rough) "Exterior wall"
    annotation (Placement(transformation(extent={{20,84},{34,98}})));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic
    matFlo(
      final nLay=2,
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
        nStaRef=nStaRef)},
    roughness_a=Buildings.HeatTransfer.Types.SurfaceRoughness.Rough)
    "Floor"
    annotation (Placement(transformation(extent={{80,84},{94,98}})));

  Buildings.ThermalZones.Detailed.MixedAir roo(
    redeclare package Medium = MediumA,
    hRoo=2.7,
    nConExtWin=nConExtWin,
    nConBou=1,
    linearizeRadiation=false,
    nPorts=3,
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
      fFra={1e-10},
      til={Z_},
      azi={S_})) "Room model"
    annotation (Placement(transformation(extent={{36,-30},{66,0}})));
  Modelica.Blocks.Sources.Constant qConGai_flow(k=80/48) "Convective heat gain"
    annotation (Placement(transformation(extent={{-56,64},{-48,72}})));
  Modelica.Blocks.Sources.Constant qRadGai_flow(k=120/48) "Radiative heat gain"
    annotation (Placement(transformation(extent={{-44,72},{-36,80}})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1
    "Multiplex for internal gains"
    annotation (Placement(transformation(extent={{-18,64},{-10,72}})));
  Modelica.Blocks.Sources.Constant qLatGai_flow(k=0) "Latent heat gain"
    annotation (Placement(transformation(extent={{-44,56},{-36,64}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CO_Denver.Intl.AP.725650_TMY3.mos"),
      computeWetBulbTemperature=false,
    pAtmSou=Buildings.BoundaryConditions.Types.DataSource.File)
    annotation (Placement(transformation(extent={{98,-98},{86,-86}})));
  Modelica.Blocks.Sources.Constant uSha(k=0)
    "Control signal for the shading device"
    annotation (Placement(transformation(extent={{-28,76},{-20,84}})));
  Modelica.Blocks.Routing.Replicator replicator(nout=max(1,nConExtWin))
    annotation (Placement(transformation(extent={{-12,76},{-4,84}})));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic roof(
    nLay=3,
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
        nStaRef=nStaRef)},
    roughness_a=Buildings.HeatTransfer.Types.SurfaceRoughness.Rough) "Roof"
    annotation (Placement(transformation(extent={{60,84},{74,98}})));
  replaceable parameter Buildings.ThermalZones.Detailed.Validation.BESTEST.Data.Win600 window600(
    haveExteriorShade=false,
    haveInteriorShade=false) "Window"
    annotation (Placement(transformation(extent={{40,84},{54,98}})));
  Buildings.Fluid.Sources.MassFlowSource_T sinInf(
    redeclare package Medium = MediumA,
    use_m_flow_in=true,
    nPorts=1) "Sink model for air infiltration"
    annotation (Placement(transformation(extent={{4,-66},{16,-54}})));
  Buildings.Fluid.Sources.Outside souInf(redeclare package Medium = MediumA,
      nPorts=1) "Source model for air infiltration"
           annotation (Placement(transformation(extent={{-24,-34},{-12,-22}})));
  Modelica.Blocks.Sources.Constant InfiltrationRate(k=-48*2.7*0.414/3600)
    "0.414 ACH adjusted for the altitude (0.5 at sea level)"
    annotation (Placement(transformation(extent={{-96,-78},{-88,-70}})));
  Modelica.Blocks.Math.Product product
    "Product to compute infiltration mass flow rate"
    annotation (Placement(transformation(extent={{-50,-60},{-40,-50}})));
  Buildings.Fluid.Sensors.Density density(
    redeclare package Medium = MediumA,
    warnAboutOnePortConnection=false)
    "Air density inside the building"
    annotation (Placement(transformation(extent={{-40,-76},{-50,-66}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus
   "Weather data bus"
    annotation (Placement(transformation(extent={{-4,-100},{12,-84}}),
        iconTransformation(extent={{-4,-96},{12,-80}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TRooAir
    "Room air temperature"
    annotation (Placement(transformation(extent={{5,-5},{-5,5}},
        rotation=0,
        origin={7,-15})));
  replaceable parameter
    Buildings.ThermalZones.Detailed.Validation.BESTEST.Data.StandardResultsFreeFloating
      staRes(
        minT( Min=-13.8+273.15, Max=-9.9+273.15, Mean=-12.7+273.15),
        maxT( Min=62.4+273.15,  Max=68.4+273.15,  Mean=64.6+273.15),
        meanT(Min=24.3+273.15,  Max=26.1+273.15,  Mean=25.2+273.15))
          constrainedby Modelica.Icons.Record
    "Reference results from ASHRAE/ANSI Standard 140"
    annotation (Placement(transformation(extent={{42,44},{56,58}})));
  Modelica.Blocks.Math.MultiSum multiSum(nu=1)
    "Multi sum for infiltration air flow rate"
    annotation (Placement(transformation(extent={{-78,-80},{-66,-68}})));
  Controls.OBC.CDL.Continuous.MovingAverage TRooHou(
    delta=3600,
    y(final unit="K",
      displayUnit="degC"))
    "Hourly averaged room air temperature"
    annotation (Placement(transformation(extent={{-68,-28},{-60,-20}})));
  Controls.OBC.CDL.Continuous.MovingAverage TRooAnn(
    delta=86400*365,
    y(final unit="K",
      displayUnit="degC"))
    "Annual averaged room air temperature"
    annotation (Placement(transformation(extent={{-68,-40},{-60,-32}})));

  HeatTransfer.Convection.Exterior conOpa(
    A=48,
    roughness=Buildings.HeatTransfer.Types.SurfaceRoughness.Rough,
    final til=Buildings.Types.Tilt.Floor,
    final azi=0,
    conMod=Buildings.HeatTransfer.Types.ExteriorConvection.TemperatureWind)
    "Convection model for opaque part of the wall"
    annotation (Placement(transformation(extent={{44,-80},{54,-70}})));
  Modelica.Blocks.Sources.Constant zerWin(k=0) "Zero wind speed"
    annotation (Placement(transformation(extent={{20,-74},{28,-66}})));
  Modelica.Blocks.Sources.Constant zerDir(k=0) "Zero wind direction"
    annotation (Placement(transformation(extent={{20,-88},{28,-80}})));
  Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium = MediumA,
    m_flow_nominal=0.0147,
    from_dp=true,
    dp_nominal=5)
    "Flow resistance to decouple pressure from weather file from room pressure"
    annotation (Placement(transformation(extent={{0,-38},{20,-18}})));
protected
  HeatTransfer.Sources.PrescribedTemperature TAirConExt
    "Outside air temperature for exterior constructions"
    annotation (Placement(transformation(extent={{74,-80},{64,-70}})));
equation
  connect(qRadGai_flow.y,multiplex3_1. u1[1])  annotation (Line(
      points={{-35.6,76},{-34,76},{-34,70.8},{-18.8,70.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(qLatGai_flow.y,multiplex3_1. u3[1])  annotation (Line(
      points={{-35.6,60},{-28,60},{-28,65.2},{-18.8,65.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiplex3_1.y, roo.qGai_flow) annotation (Line(
      points={{-9.6,68},{20,68},{20,-9},{34.8,-9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(roo.uSha, replicator.y) annotation (Line(
      points={{34.8,-1.5},{24,-1.5},{24,80},{-3.6,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(qConGai_flow.y, multiplex3_1.u2[1]) annotation (Line(
      points={{-47.6,68},{-18.8,68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaDat.weaBus, roo.weaBus)  annotation (Line(
      points={{86,-92},{80.07,-92},{80.07,-1.575},{64.425,-1.575}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(uSha.y, replicator.u) annotation (Line(
      points={{-19.6,80},{-12.8,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product.y, sinInf.m_flow_in)       annotation (Line(
      points={{-39.5,-55},{-36,-55},{-36,-55.2},{2.8,-55.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(density.port, roo.ports[1])  annotation (Line(
      points={{-45,-76},{32,-76},{32,-23.5},{39.75,-23.5}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{86,-92},{4,-92}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus, souInf.weaBus)        annotation (Line(
      points={{4,-92},{-30,-92},{-30,-27.88},{-24,-27.88}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(roo.heaPorAir, TRooAir.port)  annotation (Line(
      points={{50.25,-15},{12,-15}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sinInf.ports[1], roo.ports[2])        annotation (Line(
      points={{16,-60},{30,-60},{30,-22.5},{39.75,-22.5}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(multiSum.y, product.u1) annotation (Line(
      points={{-64.98,-74},{-58,-74},{-58,-52},{-51,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(InfiltrationRate.y, multiSum.u[1]) annotation (Line(
      points={{-87.6,-74},{-78,-74}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRooAir.T, TRooHou.u) annotation (Line(
      points={{1.5,-15},{-80,-15},{-80,-24},{-68.8,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRooAir.T, TRooAnn.u) annotation (Line(
      points={{1.5,-15},{-80,-15},{-80,-36},{-68.8,-36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conOpa.fluid, TAirConExt.port)
    annotation (Line(points={{54,-75},{64,-75}}, color={191,0,0}));
  connect(weaBus.TDryBul, TAirConExt.T) annotation (Line(
      points={{4,-92},{4,-96},{78,-96},{78,-75},{75,-75}},
      color={255,204,51},
      thickness=0.5));
  connect(conOpa.solid, roo.surf_conBou[1]) annotation (Line(points={{44,-75},{
          34,-75},{34,-34},{55.5,-34},{55.5,-27}}, color={191,0,0}));
  connect(zerWin.y, conOpa.v)
    annotation (Line(points={{28.4,-70},{43,-70}}, color={0,0,127}));
  connect(zerDir.y, conOpa.dir) annotation (Line(points={{28.4,-84},{40,-84},{
          40,-72.5},{43,-72.5}}, color={0,0,127}));
  connect(density.d, product.u2) annotation (Line(points={{-50.5,-71},{-56,-71},
          {-56,-58},{-51,-58}}, color={0,0,127}));
  connect(souInf.ports[1], res.port_a)
    annotation (Line(points={{-12,-28},{0,-28}}, color={0,127,255}));
  connect(res.port_b, roo.ports[3]) annotation (Line(points={{20,-28},{28,-28},
          {28,-21.5},{39.75,-21.5}},color={0,127,255}));
  annotation (
experiment(Tolerance=1e-06, StopTime=3.1536e+07),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Validation/BESTEST/Cases6xx/Case600FF.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model is used for the test case 600FF of the BESTEST validation suite.
Case 600FF is a light-weight building.
The room temperature is free floating.
</p>
</html>", revisions="<html>
<ul>
<li>
May 24, 2022, by Michael Wetter:<br/>
Set air pressure to be the same pressure as is recorded in the weather data file.
This changes the annual cooling energy for Case 900 by about 4%.</br>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3005\">#3005</a>.
</li>
<li>
May 12, 2022, by Jianjun Hu:<br/>
Changed the floor to be raised floor, disabled linearize the emissive power,
changed weather data and adjusted infiltration rate from 0.5 ACH to 0.414 ACH for the altitude.</br>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3005\">#3005</a>.
</li>
<li>
January 21, 2020, by Michael Wetter:<br/>
Changed calculation of time averaged values to use
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.MovingMean\">
Buildings.Controls.OBC.CDL.Continuous.MovingMean</a>
because this does not trigger a time event every hour.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1714\">issue 1714</a>.
</li>
<li>
October 29, 2016, by Michael Wetter:<br/>
Placed a capacity at the room-facing surface
to reduce the dimension of the nonlinear system of equations,
which generally decreases computing time.<br/>
Removed the pressure drop element which is not needed.<br/>
Linearized the radiative heat transfer, which is the default in
the library, and avoids a large nonlinear system of equations.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/565\">issue 565</a>.
</li>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
October 9, 2013, by Michael Wetter:<br/>
Implemented soil properties using a record so that <code>TSol</code> and
<code>TLiq</code> are assigned.
This avoids an error when the model is checked in the pedantic mode.
</li>
<li>
July 15, 2012, by Michael Wetter:<br/>
Added reference results.
Changed implementation to make this model the base class
for all BESTEST cases.
Added computation of hourly and annual averaged room air temperature.
</li>
<li>
October 6, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Case600FF;
