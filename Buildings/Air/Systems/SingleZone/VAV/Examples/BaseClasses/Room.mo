within Buildings.Air.Systems.SingleZone.VAV.Examples.BaseClasses;
model Room
  "BESTest Case 600 with fluid ports for air HVAC and internal load"

  replaceable package MediumA = Buildings.Media.Air "Medium model";
  parameter Modelica.SIunits.MassFlowRate mAir_flow_nominal
    "Design airflow rate of system";
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
    material={
      Buildings.HeatTransfer.Data.Solids.Generic(
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
    annotation (Placement(transformation(extent={{100,80},{114,94}})));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic matFlo(
    final nLay= 2,
    absIR_a=0.9,
    absIR_b=0.9,
    absSol_a=0.6,
    absSol_b=0.6,
    material={
      Buildings.HeatTransfer.Data.Solids.Generic(
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
    annotation (Placement(transformation(extent={{160,80},{174,94}})));
  parameter Buildings.HeatTransfer.Data.Solids.Generic soil(
    x=2,
    k=1.3,
    c=800,
    d=1500) "Soil properties"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic roof(
    nLay=3,
    absIR_a=0.9,
    absIR_b=0.9,
    absSol_a=0.6,
    absSol_b=0.6,
    material={
      Buildings.HeatTransfer.Data.Solids.Generic(
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
    annotation (Placement(transformation(extent={{140,80},{154,94}})));
  parameter Buildings.ThermalZones.Detailed.Validation.BESTEST.Data.Win600 window600(
    UFra=3,
    haveExteriorShade=false,
    haveInteriorShade=false) "Window"
    annotation (Placement(transformation(extent={{120,80},{134,94}})));

  Buildings.HeatTransfer.Conduction.SingleLayer soi(
    A=48,
    material=soil,
    steadyStateInitial=true,
    stateAtSurface_a=false,
    stateAtSurface_b=true,
    T_a_start=283.15,
    T_b_start=283.75)
    "2 m deep soil (per definition on p.4 of ASHRAE 140-2007)"
    annotation (Placement(transformation(
        extent={{12.5,-12.5},{-7.5,7.5}},
        rotation=-90,
        origin={70.5,-47.5})));
  Modelica.Fluid.Interfaces.FluidPort_a supplyAir(redeclare final package
      Medium = MediumA)
    "Supply air"
    annotation (Placement(transformation(extent={{-210,10},{-190,30}}),
        iconTransformation(extent={{-210,10},{-190,30}})));
  Modelica.Fluid.Interfaces.FluidPort_b returnAir(redeclare final package
      Medium = MediumA)
    "Return air"
    annotation (Placement(transformation(extent={{-210,-30},{-190,-10}}),
        iconTransformation(extent={{-210,-30},{-190,-10}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    "Weather data bus"
    annotation (Placement(transformation(extent={{-148,172},{-132,188}}),
        iconTransformation(extent={{-148,172},{-132,188}})));
  Modelica.Blocks.Interfaces.RealOutput TRooAir
    "Room air temperature"
    annotation (Placement(transformation(extent={{200,-10},{220,10}}),
        iconTransformation(extent={{200,-10},{220,10}})));
  Buildings.ThermalZones.Detailed.MixedAir roo(
    redeclare package Medium = MediumA,
    use_C_flow=true,
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
    annotation (Placement(transformation(extent={{34,-26},{86,26}})));
  Modelica.Blocks.Sources.Constant qConGai_flow(k=192/48)
    "Convective heat gain"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Modelica.Blocks.Sources.Constant qRadGai_flow(k=288/48)
    "Radiative heat gain"
    annotation (Placement(transformation(extent={{-120,120},{-100,140}})));
  Modelica.Blocks.Routing.Multiplex3 mul
    "Multiplex"
    annotation (Placement(transformation(extent={{0,80},{22,102}})));
  Modelica.Blocks.Sources.Constant qLatGai_flow(k=96/48)
    "Latent heat gain"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TSoi[nConBou](
    each T= 283.15)
    "Boundary condition for construction"
    annotation (Placement(transformation(
        extent={{0,0},{-20,20}},
        origin={140,-80})));
  Fluid.Sources.MassFlowSource_WeatherData sinInf(
    redeclare package Medium = MediumA,
    C=fill(0.0004, 1),
    nPorts=1,
    use_m_flow_in=true)
    "Sink model for air infiltration"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Modelica.Blocks.Sources.Constant InfiltrationRate(k=48*2.7*0.5/3600)
    "0.41 ACH adjusted for the altitude (0.5 at sea level)"
    annotation (Placement(transformation(extent={{-180,-94},{-160,-74}})));
  Modelica.Blocks.Math.Product product
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Fluid.Sensors.Density density(redeclare package Medium = MediumA)
    "Air density inside the building"
    annotation (Placement(transformation(extent={{0,-100},{-20,-80}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTZon
    "Zone air temperature sensor"
    annotation (Placement(transformation(extent={{160,-10},{180,10}})));
  Fluid.Sources.MassFlowSource_WeatherData souInf(
    redeclare package Medium = MediumA,
    use_m_flow_in=true,
    C=fill(0.0004, 1),
    nPorts=1)
    "Source model for air infiltration"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable intLoad(table=[0,
        0.1; 8*3600,0.1; 8*3600,1.0; 18*3600,1.0; 18*3600,0.1; 24*3600,0.1])
    "Internal loads"
    annotation (Placement(transformation(extent={{-120,150},{-100,170}})));
  Modelica.Blocks.Sources.Constant CO2_flow_per(k=1.023e-5)
    "Latent heat gain"
    annotation (Placement(transformation(extent={{-40,14},{-20,34}})));
  Modelica.Blocks.Logical.GreaterThreshold greThr(threshold=0.1)
    "Greater than"
    annotation (Placement(transformation(extent={{-60,150},{-40,170}})));
  Modelica.Blocks.Sources.Constant desOcc(k=2)
    "Design number of occupants"
    annotation (Placement(transformation(extent={{-120,180},{-100,200}})));
  Modelica.Blocks.Math.Product numOcc
    "Number of occupants in the zone"
    annotation (Placement(transformation(extent={{10,150},{30,170}})));
  Modelica.Blocks.Math.BooleanToReal booToRea
    "Convert Boolean to Real signal"
    annotation (Placement(transformation(extent={{-30,150},{-10,170}})));

protected
  Modelica.Blocks.Math.Product pro1
    "Product for internal gain"
    annotation (Placement(transformation(extent={{-40,120},{-20,140}})));
  Modelica.Blocks.Math.Product pro2
    "Product for internal gain"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Modelica.Blocks.Math.Product pro3
    "Product for internal gain"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Modelica.Blocks.Math.Gain gaiInf(final k=-1)
    "Gain for infiltration"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  Modelica.Blocks.Math.Product pro4
    "Product for internal gain"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));

equation
  connect(mul.y, roo.qGai_flow) annotation (Line(
      points={{23.1,91},{28,91},{28,10.4},{31.92,10.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(density.port, roo.ports[1])  annotation (Line(
      points={{-10,-100},{2,-100},{2,-17.16},{40.5,-17.16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(density.d, product.u2) annotation (Line(
      points={{-21,-90},{-40,-90},{-40,-114},{-132,-114},{-132,-96},{-122,-96}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSoi[1].port, soi.port_a) annotation (Line(
      points={{120,-70},{68,-70},{68,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(soi.port_b, roo.surf_conBou[1]) annotation (Line(
      points={{68,-40},{68,-20.8},{67.8,-20.8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sinInf.ports[1], roo.ports[2]) annotation (Line(points={{-20,-10},{14,
          -10},{14,-15.08},{40.5,-15.08}},color={0,127,255}));
  connect(weaBus,sinInf. weaBus) annotation (Line(
      points={{-140,180},{-140,-10},{-40,-10},{-40,-9.8}},
      color={255,204,51},
      thickness=0.5), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus, roo.weaBus) annotation (Line(
      points={{-140,180},{82,180},{82,112},{83.27,112},{83.27,23.27}},
      color={255,204,51},
      thickness=0.5), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(senTZon.T, TRooAir) annotation (Line(points={{180,0},{210,0}},
                    color={0,0,127}));
  connect(senTZon.port, roo.heaPorAir) annotation (Line(points={{160,0},{58.7,0}},
                             color={191,0,0}));
  connect(qRadGai_flow.y, pro1.u1) annotation (Line(points={{-99,130},{-80,130},
          {-80,136},{-42,136}}, color={0,0,127}));
  connect(qLatGai_flow.y, pro2.u1) annotation (Line(points={{-99,70},{-70,70},{
          -70,76},{-42,76}}, color={0,0,127}));
  connect(qConGai_flow.y, pro3.u1) annotation (Line(points={{-99,100},{-94,100},
          {-94,96},{-82,96}}, color={0,0,127}));
  connect(intLoad.y[1], pro2.u2) annotation (Line(points={{-98,160},{-90,160},{-90,
          64},{-42,64}},     color={0,0,127}));
  connect(pro1.y, mul.u1[1]) annotation (Line(points={{-19,130},{-12,130},{-12,
          98.7},{-2.2,98.7}}, color={0,0,127}));
  connect(pro3.y, mul.u2[1]) annotation (Line(points={{-59,90},{-58,90},{-58,91},
          {-2.2,91}}, color={0,0,127}));
  connect(pro2.y, mul.u3[1]) annotation (Line(points={{-19,70},{-12,70},{-12,
          83.3},{-2.2,83.3}}, color={0,0,127}));
  connect(souInf.weaBus, weaBus) annotation (Line(
      points={{-40,-49.8},{-56,-49.8},{-56,-42},{-140,-42},{-140,180}},
      color={255,204,51},
      thickness=0.5));
  connect(souInf.ports[1], roo.ports[3]) annotation (Line(points={{-20,-50},{-6,
          -50},{-6,-13},{40.5,-13}},      color={0,127,255}));
  connect(product.y, gaiInf.u)    annotation (Line(points={{-99,-90},{-82,-90}},     color={0,0,127}));
  connect(gaiInf.y, souInf.m_flow_in) annotation (Line(points={{-59,-90},{-46,-90},
          {-46,-42},{-40,-42}},          color={0,0,127}));
  connect(product.y, sinInf.m_flow_in) annotation (Line(points={{-99,-90},{-92,-90},
          {-92,-2},{-40,-2}},                color={0,0,127}));
  connect(supplyAir, roo.ports[4]) annotation (Line(points={{-200,20},{-120,20},
          {-120,48},{0,48},{0,-10.92},{40.5,-10.92}},color={0,127,255}));
  connect(returnAir, roo.ports[5]) annotation (Line(points={{-200,-20},{-114,-20},
          {-114,42},{-2,42},{-2,-8.84},{40.5,-8.84}},
        color={0,127,255}));
  connect(InfiltrationRate.y, product.u1)   annotation (Line(points={{-159,-84},{-122,-84}}, color={0,0,127}));
  connect(intLoad.y[1], pro1.u2) annotation (Line(points={{-98,160},{-90,160},{-90,
          124},{-42,124}},     color={0,0,127}));
  connect(pro3.u2, intLoad.y[1]) annotation (Line(points={{-82,84},{-90,84},{-90,
          160},{-98,160}}, color={0,0,127}));
  connect(CO2_flow_per.y, pro4.u2)    annotation (Line(points={{-19,24},{-2,24}}, color={0,0,127}));
  connect(desOcc.y, numOcc.u1) annotation (Line(points={{-99,190},{0,190},{0,
          166},{8,166}}, color={0,0,127}));
  connect(greThr.y, booToRea.u)    annotation (Line(points={{-39,160},{-32,160}}, color={255,0,255}));
  connect(booToRea.y, numOcc.u2) annotation (Line(points={{-9,160},{0,160},{0,
          154},{8,154}}, color={0,0,127}));
  connect(greThr.u, pro2.u2) annotation (Line(points={{-62,160},{-90,160},{-90,
          64},{-42,64}}, color={0,0,127}));
  connect(numOcc.y, pro4.u1) annotation (Line(points={{31,160},{40,160},{40,54},
          {-12,54},{-12,36},{-2,36}}, color={0,0,127}));
  connect(pro4.y, roo.C_flow[1]) annotation (Line(points={{21,30},{26,30},{26,
          3.64},{31.92,3.64}}, color={0,0,127}));

  annotation (
defaultComponentName="roo",
Documentation(info="<html>
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
</html>", revisions="<html>
<ul>
<li>
July 21, 2020, by Kun Zhang:<br/>
Replaced the internal gain block from BaseClasses by directly using the block 
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable\">
Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable</a>.
</li>
<li>
June 21, 2017, by Michael Wetter:<br/>
Refactored implementation.
</li>
<li>
June 1, 2017, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-200,-200},{200,200}})),
    Icon(coordinateSystem(extent={{-200,-200},{200,200}}),
        graphics={
        Rectangle(
          extent={{-158,-160},{162,160}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-138,138},{142,-140}},
          pattern=LinePattern.None,
          lineColor={117,148,176},
          fillColor={170,213,255},
          fillPattern=FillPattern.Sphere),
        Rectangle(
          extent={{142,70},{162,-70}},
          lineColor={95,95,95},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{148,70},{156,-70}},
          lineColor={95,95,95},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
                                        Text(
        extent={{-156,234},{160,172}},
        textString="%name",
        lineColor={0,0,255})}));
end Room;
