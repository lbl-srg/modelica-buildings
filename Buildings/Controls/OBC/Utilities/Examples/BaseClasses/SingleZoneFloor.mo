within Buildings.Controls.OBC.Utilities.Examples.BaseClasses;
model SingleZoneFloor "Model of a building floor as a single zone"
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium model for air" annotation (choicesAllMatching=true);
  parameter Boolean use_windPressure=true
    "Set to true to enable wind pressure";
  parameter HeatTransfer.Types.InteriorConvection intConMod=Buildings.HeatTransfer.Types.InteriorConvection.Temperature
    "Convective heat transfer model for room-facing surfaces of opaque constructions";
  parameter Modelica.SIunits.Angle lat "Latitude";
  parameter Modelica.SIunits.Volume VRoo = 568.77*2 + 360.0785*2 + 2698 "Room volum";
  parameter Modelica.SIunits.Height hRoo = 2.74 "Room height";
  parameter Modelica.SIunits.Length hWin = 1.5 "Height of windows";
  parameter Real winWalRat(min=0.01,max=0.99) = 0.33 "Window to wall ratio for exterior walls";

  parameter Buildings.HeatTransfer.Data.Solids.Plywood matWoo(
    x=0.01,
    k=0.11,
    d=544,
    nStaRef=1) "Wood for exterior construction"
    annotation (Placement(transformation(extent={{40,112},{60,132}})));
  parameter Buildings.HeatTransfer.Data.Solids.Concrete matCon(
    x=0.1,
    k=1.311,
    c=836,
    nStaRef=5) "Concrete"
    annotation (Placement(transformation(extent={{40,142},{60,162}})));
  parameter Buildings.HeatTransfer.Data.Solids.Generic matIns(
    x=0.087,
    k=0.049,
    c=836.8,
    d=265,
    nStaRef=5) "Steelframe construction with insulation"
    annotation (Placement(transformation(extent={{80,112},{100,132}})));
  parameter Buildings.HeatTransfer.Data.Solids.GypsumBoard matGyp(
    x=0.0127,
    k=0.16,
    c=830,
    d=784,
    nStaRef=2) "Gypsum board"
    annotation (Placement(transformation(extent={{40,84},{60,104}})));
  parameter Buildings.HeatTransfer.Data.Solids.GypsumBoard matGyp2(
    x=0.025,
    k=0.16,
    c=830,
    d=784,
    nStaRef=2) "Gypsum board"
    annotation (Placement(transformation(extent={{80,84},{100,104}})));
  parameter Buildings.HeatTransfer.Data.Solids.Plywood matFur(x=0.15, nStaRef=5)
    "Material for furniture"
    annotation (Placement(transformation(extent={{80,172},{100,192}})));
  parameter Buildings.HeatTransfer.Data.Solids.Plywood matCarTra(
    x=0.215/0.11,
    k=0.11,
    d=544,
    nStaRef=1) "Wood for floor"
    annotation (Placement(transformation(extent={{40,172},{60,192}})));
  parameter Buildings.HeatTransfer.Data.Resistances.Carpet matCar "Carpet"
    annotation (Placement(transformation(extent={{120,172},{140,192}})));
  parameter Buildings.HeatTransfer.Data.GlazingSystems.DoubleClearAir13Clear glaSys(
    UFra=2,
    shade=Buildings.HeatTransfer.Data.Shades.Gray(),
    haveInteriorShade=false,
    haveExteriorShade=false) "Data record for the glazing system"
    annotation (Placement(transformation(extent={{80,142},{100,162}})));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic conExtWal(
    final nLay=3,
    material={matWoo,matIns,matGyp}) "Exterior construction"
    annotation (Placement(transformation(extent={{120,142},{140,162}})));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic conIntWal(
    final nLay=1,
    material={matGyp2}) "Interior wall construction"
    annotation (Placement(transformation(extent={{160,142},{180,162}})));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic conFlo(
    final nLay=1,
    material={matCon}) "Floor construction (opa_a is carpet)"
    annotation (Placement(transformation(extent={{120,102},{140,122}})));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic conFur(
    final nLay=1,
    material={matFur}) "Construction for internal mass of furniture"
    annotation (Placement(transformation(extent={{160,102},{180,122}})));
  parameter Boolean sampleModel = false
    "Set to true to time-sample the model, which can give shorter simulation time if there is already time sampling in the system model"
    annotation (
      Evaluate=true,
      Dialog(tab="Experimental (may be changed in future releases)"));

  Buildings.ThermalZones.Detailed.MixedAir flo(
    redeclare package Medium = Medium,
    lat=lat,
    AFlo=AFlo,
    hRoo=hRoo,
    nConExt=0,
    nConExtWin=4,
    datConExtWin(
      layers={conExtWal,conExtWal,conExtWal,conExtWal},
      A={49.91*hRoo,49.91*hRoo,33.27*hRoo,33.27*hRoo},
      glaSys={glaSys,glaSys,glaSys,glaSys},
      wWin={winWalRat/hWin*49.91*hRoo,winWalRat/hWin*49.91*hRoo,winWalRat/hWin*33.27
          *hRoo,winWalRat/hWin*33.27*hRoo},
      each hWin=hWin,
      fFra={0.1,0.1,0.1,0.1},
      til={Z_,Z_,Z_,Z_},
      azi={N_,S_,W_,E_}),
    nConPar=3,
    datConPar(
      layers={conFlo,conFur,conIntWal},
      A={AFlo,AFlo*0.729,(6.47*2 + 40.76 + 24.13)*2*hRoo},
      til={F_,Z_,Z_}),
    nConBou=0,
    nSurBou=0,
    nPorts=7,
    intConMod=intConMod,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final sampleModel=sampleModel) "Floor"
    annotation (Placement(transformation(extent={{-16,-56},{24,-16}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temAir
    "Air temperature sensor"
    annotation (Placement(transformation(extent={{82,30},{102,50}})));
  Buildings.Fluid.Sensors.RelativePressure senRelPre(redeclare package Medium
      =                                                                         Medium)
    "Building pressure measurement"
    annotation (Placement(transformation(extent={{-60,-16},{-80,4}})));
  Buildings.Fluid.Sources.Outside out(nPorts=1, redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-120,-16},{-100,4}})));
  Modelica.Fluid.Interfaces.FluidPort_a supplyAir(redeclare final package
      Medium = Medium) "Supply air"
    annotation (Placement(transformation(extent={{-210,10},{-190,30}}),
        iconTransformation(extent={{-210,10},{-190,30}})));
  Modelica.Fluid.Interfaces.FluidPort_b returnAir(redeclare final package
      Medium = Medium) "Return air"
    annotation (Placement(transformation(extent={{-210,-30},{-190,-10}}),
        iconTransformation(extent={{-210,-30},{-190,-10}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    "Weather data bus"
    annotation (Placement(transformation(extent={{-174,78},{-158,94}}),
        iconTransformation(extent={{-148,172},{-132,188}})));
  Modelica.Blocks.Interfaces.RealOutput TRooAir "Room air temperature"
    annotation (Placement(transformation(extent={{200,50},{220,70}}),
        iconTransformation(extent={{200,50},{220,70}})));
  Buildings.Examples.VAVReheat.ThermalZones.RoomLeakage leaSou(
    redeclare package Medium = Medium,
    VRoo=568.77,
    s=49.91/33.27,
    azi=S_,
    final use_windPressure=use_windPressure)
    "Model for air infiltration through the envelope"
    annotation (Placement(transformation(extent={{-122,132},{-86,172}})));
  Buildings.Examples.VAVReheat.ThermalZones.RoomLeakage leaEas(
    redeclare package Medium = Medium,
    VRoo=360.0785,
    s=33.27/49.91,
    azi=E_,
    final use_windPressure=use_windPressure)
    "Model for air infiltration through the envelope"
    annotation (Placement(transformation(extent={{-122,92},{-86,132}})));
  Buildings.Examples.VAVReheat.ThermalZones.RoomLeakage leaNor(
    redeclare package Medium = Medium,
    VRoo=568.77,
    s=49.91/33.27,
    azi=N_,
    final use_windPressure=use_windPressure)
    "Model for air infiltration through the envelope"
    annotation (Placement(transformation(extent={{-122,50},{-86,90}})));
  Buildings.Examples.VAVReheat.ThermalZones.RoomLeakage leaWes(
    redeclare package Medium = Medium,
    VRoo=360.0785,
    s=33.27/49.91,
    azi=W_,
    final use_windPressure=use_windPressure)
    "Model for air infiltration through the envelope"
    annotation (Placement(transformation(extent={{-122,10},{-86,50}})));
  Modelica.Blocks.Interfaces.RealOutput p_rel
    "Relative pressure signal of building static pressure" annotation (
      Placement(transformation(extent={{200,-70},{220,-50}}),
        iconTransformation(extent={{200,-50},{220,-30}})));
  Modelica.Blocks.Sources.CombiTimeTable intGaiFra(
    table=[0,0.05; 8,0.05; 9,0.9; 12,0.9; 12,0.8; 13,0.8; 13,1; 17,1; 19,0.1;
        24,0.05],
    timeScale=3600,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Fraction of internal heat gain"
    annotation (Placement(transformation(extent={{-160,-150},{-140,-130}})));
  Modelica.Blocks.Math.MatrixGain gai(K=20*[0.4; 0.4; 0.2])
    "Matrix gain to split up heat gain in radiant, convective and latent gain"
    annotation (Placement(transformation(extent={{-120,-150},{-100,-130}})));
  Modelica.Blocks.Sources.Constant uSha(k=0)
    "Control signal for the shading device"
    annotation (Placement(transformation(extent={{-160,-100},{-140,-80}})));
  Modelica.Blocks.Routing.Replicator replicator(nout=1)
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
protected
  parameter Modelica.SIunits.Angle S_= Buildings.Types.Azimuth.S "Azimuth for south walls";
  parameter Modelica.SIunits.Angle E_= Buildings.Types.Azimuth.E "Azimuth for east walls";
  parameter Modelica.SIunits.Angle W_= Buildings.Types.Azimuth.W "Azimuth for west walls";
  parameter Modelica.SIunits.Angle N_= Buildings.Types.Azimuth.N "Azimuth for north walls";
  parameter Modelica.SIunits.Angle F_= Buildings.Types.Tilt.Floor "Tilt for floor";
  parameter Modelica.SIunits.Angle Z_= Buildings.Types.Tilt.Wall "Tilt for wall";
  parameter Modelica.SIunits.Area AFlo = VRoo/hRoo "Floor area";

equation
  connect(flo.weaBus, weaBus) annotation (Line(
      points={{21.9,-18.1},{21.9,184},{-166,184},{-166,86}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flo.heaPorAir, temAir.port) annotation (Line(
      points={{3,-36},{40,-36},{40,40},{82,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(out.weaBus, weaBus) annotation (Line(
      points={{-120,-5.8},{-166,-5.8},{-166,86}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(out.ports[1], senRelPre.port_b) annotation (Line(
      points={{-100,-6},{-80,-6}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(temAir.T, TRooAir) annotation (Line(points={{102,40},{160,40},{160,60},
          {210,60}},color={0,0,127}));
  connect(supplyAir, flo.ports[1]) annotation (Line(points={{-200,20},{-176,20},
          {-176,-44},{-44,-44},{-44,-49.4286},{-11,-49.4286}},
                               color={0,127,255}));
  connect(returnAir, flo.ports[2]) annotation (Line(points={{-200,-20},{-180,
          -20},{-180,-48.2857},{-11,-48.2857}},
                                         color={0,127,255}));
  connect(weaBus, leaSou.weaBus) annotation (Line(
      points={{-166,86},{-166,152},{-122,152}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus, leaEas.weaBus) annotation (Line(
      points={{-166,86},{-166,112},{-122,112}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(leaNor.weaBus, weaBus) annotation (Line(
      points={{-122,70},{-166,70},{-166,86}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(leaSou.port_b, flo.ports[3]) annotation (Line(points={{-86,152},{-44,
          152},{-44,-47.1429},{-11,-47.1429}},
                                          color={0,127,255}));
  connect(leaEas.port_b, flo.ports[4]) annotation (Line(points={{-86,112},{-44,
          112},{-44,-37.3333},{-11,-37.3333},{-11,-46}},
                                                    color={0,127,255}));
  connect(leaNor.port_b, flo.ports[5]) annotation (Line(points={{-86,70},{-44,
          70},{-44,-40},{-11,-40},{-11,-44.8571}},
                                               color={0,127,255}));
  connect(leaWes.port_b, flo.ports[6]) annotation (Line(points={{-86,30},{-44,
          30},{-44,-43.7143},{-11,-43.7143}},
                                          color={0,127,255}));
  connect(senRelPre.port_a, flo.ports[7]) annotation (Line(points={{-60,-6},{
          -44,-6},{-44,-44},{-11,-44},{-11,-42.5714}},       color={0,127,255}));
  connect(weaBus, leaWes.weaBus) annotation (Line(
      points={{-166,86},{-166,30},{-122,30}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(senRelPre.p_rel, p_rel)
    annotation (Line(points={{-70,-15},{-70,-60},{210,-60}}, color={0,0,127}));
  connect(intGaiFra.y, gai.u)
    annotation (Line(points={{-139,-140},{-122,-140}}, color={0,0,127}));
  connect(gai.y, flo.qGai_flow) annotation (Line(points={{-99,-140},{-26,-140},
          {-26,-28},{-17.6,-28}},
                                color={0,0,127}));
  connect(uSha.y, replicator.u)
    annotation (Line(points={{-139,-90},{-122,-90}}, color={0,0,127}));
  connect(replicator.y, flo.uSha) annotation (Line(points={{-99,-90},{-30,-90},
          {-30,-18},{-17.6,-18}},
                              color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-200,-200},
            {200,200}})),       Icon(coordinateSystem(
          preserveAspectRatio=true, extent={{-200,-200},{200,200}}), graphics={
        Rectangle(
          extent={{-160,-160},{160,160}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-140,140},{140,-140}},
          pattern=LinePattern.None,
          lineColor={117,148,176},
          fillColor={170,213,255},
          fillPattern=FillPattern.Sphere),
        Rectangle(
          extent={{140,70},{160,-70}},
          lineColor={95,95,95},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{146,70},{154,-70}},
          lineColor={95,95,95},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-160,72},{-140,-68}},
          lineColor={95,95,95},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-154,72},{-146,-68}},
          lineColor={95,95,95},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-10,70},{10,-70}},
          lineColor={95,95,95},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={2,-150},
          rotation=90),
        Rectangle(
          extent={{-4,70},{4,-70}},
          lineColor={95,95,95},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid,
          origin={2,-150},
          rotation=90),
        Rectangle(
          extent={{-10,70},{10,-70}},
          lineColor={95,95,95},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={2,150},
          rotation=90),
        Rectangle(
          extent={{-4,70},{4,-70}},
          lineColor={95,95,95},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid,
          origin={2,150},
          rotation=90)}),
    Documentation(revisions="<html>
<ul>
<li>December 3, 2019, by Kun Zhang:<br>The geometry, materials and constructions are consistent with . </li>
</ul>
</html>"));
end SingleZoneFloor;
