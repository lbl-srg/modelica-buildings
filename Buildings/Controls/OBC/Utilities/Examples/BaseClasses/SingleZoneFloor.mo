within Buildings.Controls.OBC.Utilities.Examples.BaseClasses;
model SingleZoneFloor "Model of a building floor as a single zone"
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium model for air" annotation (choicesAllMatching=true);

  parameter Boolean use_windPressure=true
    "Set to true to enable wind pressure";

  parameter HeatTransfer.Types.InteriorConvection intConMod=Buildings.HeatTransfer.Types.InteriorConvection.Temperature
    "Convective heat transfer model for room-facing surfaces of opaque constructions";
  parameter Modelica.SIunits.Angle lat "Latitude";
  parameter Real winWalRat(
    min=0.01,
    max=0.99) = 0.33 "Window to wall ratio for exterior walls";
  parameter Modelica.SIunits.Length hWin = 1.5 "Height of windows";
  parameter Modelica.SIunits.Height hRoo=2.74 "Room height";
  parameter Modelica.SIunits.Area AFlo "Floor area";
  parameter HeatTransfer.Data.Solids.Plywood matFur(x=0.15, nStaRef=5)
    "Material for furniture"
    annotation (Placement(transformation(extent={{80,172},{100,192}})));
  parameter HeatTransfer.Data.Resistances.Carpet matCar "Carpet"
    annotation (Placement(transformation(extent={{120,172},{140,192}})));
  parameter HeatTransfer.Data.Solids.Concrete matCon(
    x=0.1,
    k=1.311,
    c=836,
    nStaRef=5) "Concrete"
    annotation (Placement(transformation(extent={{40,142},{60,162}})));
  parameter HeatTransfer.Data.Solids.Plywood matWoo(
    x=0.01,
    k=0.11,
    d=544,
    nStaRef=1) "Wood for exterior construction"
    annotation (Placement(transformation(extent={{40,112},{60,132}})));
  parameter HeatTransfer.Data.Solids.Generic matIns(
    x=0.087,
    k=0.049,
    c=836.8,
    d=265,
    nStaRef=5) "Steelframe construction with insulation"
    annotation (Placement(transformation(extent={{80,112},{100,132}})));
  parameter HeatTransfer.Data.Solids.GypsumBoard matGyp(
    x=0.0127,
    k=0.16,
    c=830,
    d=784,
    nStaRef=2) "Gypsum board"
    annotation (Placement(transformation(extent={{40,84},{60,104}})));
  parameter HeatTransfer.Data.Solids.GypsumBoard matGyp2(
    x=0.025,
    k=0.16,
    c=830,
    d=784,
    nStaRef=2) "Gypsum board"
    annotation (Placement(transformation(extent={{80,84},{100,104}})));
  parameter HeatTransfer.Data.OpaqueConstructions.Generic conExtWal(final nLay=3,
      material={matWoo,matIns,matGyp}) "Exterior construction"
    annotation (Placement(transformation(extent={{120,142},{140,162}})));
  parameter HeatTransfer.Data.OpaqueConstructions.Generic conIntWal(final nLay=1,
      material={matGyp2}) "Interior wall construction"
    annotation (Placement(transformation(extent={{160,142},{180,162}})));
  parameter HeatTransfer.Data.OpaqueConstructions.Generic conFlo(final nLay=1, material={
        matCon}) "Floor construction (opa_a is carpet)"
    annotation (Placement(transformation(extent={{120,102},{140,122}})));
  parameter HeatTransfer.Data.OpaqueConstructions.Generic conFur(final nLay=1, material={
        matFur}) "Construction for internal mass of furniture"
    annotation (Placement(transformation(extent={{160,102},{180,122}})));
  parameter HeatTransfer.Data.Solids.Plywood matCarTra(
    k=0.11,
    d=544,
    nStaRef=1,
    x=0.215/0.11) "Wood for floor"
    annotation (Placement(transformation(extent={{40,170},{60,190}})));
  parameter HeatTransfer.Data.GlazingSystems.DoubleClearAir13Clear glaSys(
    UFra=2,
    shade=Buildings.HeatTransfer.Data.Shades.Gray(),
    haveInteriorShade=false,
    haveExteriorShade=false) "Data record for the glazing system"
    annotation (Placement(transformation(extent={{80,142},{100,162}})));
  parameter HeatTransfer.Data.Solids.Generic soil(
    x=2,
    k=1.3,
    c=800,
    d=1500) "Soil properties"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));

  parameter Boolean sampleModel = false
    "Set to true to time-sample the model, which can give shorter simulation time if there is already time sampling in the system model"
    annotation (
      Evaluate=true,
      Dialog(tab="Experimental (may be changed in future releases)"));

  Buildings.ThermalZones.Detailed.MixedAir flo(
    redeclare package Medium = Medium,
    lat=lat,
    AFlo=360.0785/hRoo,
    hRoo=hRoo,
    nConExt=0,
    nConExtWin=1,
    datConExtWin(
      layers={conExtWal},
      A={33.27*hRoo},
      glaSys={glaSys},
      wWin={winWalRat/hWin*33.27*hRoo},
      each hWin=hWin,
      fFra={0.1},
      til={Buildings.Types.Tilt.Wall},
      azi={Buildings.Types.Azimuth.W}),
    nConPar=2,
    datConPar(
      layers={conFlo,conFur},
      A={360.0785/hRoo,262.52},
      til={Buildings.Types.Tilt.Floor,Buildings.Types.Tilt.Wall}),
    nConBou=1,
    datConBou(
      layers={conIntWal},
      A={24.13}*hRoo,
      til={Buildings.Types.Tilt.Wall}),
    nSurBou=2,
    surBou(
      each A=6.47*hRoo,
      each absIR=0.9,
      each absSol=0.9,
      til={Buildings.Types.Tilt.Wall, Buildings.Types.Tilt.Wall}),
    nPorts=3,
    intConMod=intConMod,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final sampleModel=sampleModel) "Floor"
    annotation (Placement(transformation(extent={{4,-64},{44,-24}})));
  Buildings.Examples.VAVReheat.ThermalZones.RoomLeakage lea(
    redeclare package Medium = Medium,
    VRoo=360.0785,
    s=33.27/49.91,
    azi=Buildings.Types.Azimuth.W,
    final use_windPressure=use_windPressure)
    "Model for air infiltration through the envelope"
    annotation (Placement(transformation(extent={{-80,-108},{-44,-68}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temAirWes
    "Air temperature sensor"
    annotation (Placement(transformation(extent={{80,-54},{100,-34}})));
  Buildings.Fluid.Sensors.RelativePressure senRelPre(redeclare package Medium
      =                                                                         Medium)
    "Building pressure measurement"
    annotation (Placement(transformation(extent={{2,-130},{-18,-110}})));
  Buildings.Fluid.Sources.Outside out(nPorts=1, redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));

  Modelica.Fluid.Interfaces.FluidPort_a supplyAir(redeclare final package
      Medium = MediumA) "Supply air"
    annotation (Placement(transformation(extent={{-210,10},{-190,30}}),
        iconTransformation(extent={{-210,10},{-190,30}})));
  Modelica.Fluid.Interfaces.FluidPort_b returnAir(redeclare final package
      Medium = MediumA) "Return air"
    annotation (Placement(transformation(extent={{-210,-30},{-190,-10}}),
        iconTransformation(extent={{-210,-30},{-190,-10}})));
  BoundaryConditions.WeatherData.Bus           weaBus
    "Weather data bus"
    annotation (Placement(transformation(extent={{-148,-88},{-132,-72}}),
        iconTransformation(extent={{-148,172},{-132,188}})));
  Modelica.Blocks.Interfaces.RealOutput TRooAir "Room air temperature"
    annotation (Placement(transformation(extent={{200,-10},{220,10}}),
        iconTransformation(extent={{200,-10},{220,10}})));
  HeatTransfer.Conduction.SingleLayer lay(material=soil)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={30,-90})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TSoi[nConBou](each T=
        283.15)     "Boundary condition for construction"
    annotation (Placement(transformation(
        extent={{0,0},{-20,20}},
        origin={80,-140})));
equation
  connect(flo.weaBus, weaBus) annotation (Line(
      points={{41.9,-26.1},{41.9,-14},{-140,-14},{-140,-80}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaBus, lea.weaBus) annotation (Line(
      points={{-140,-80},{-112,-80},{-112,-88},{-80,-88}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flo.heaPorAir, temAirWes.port) annotation (Line(
      points={{23,-44},{80,-44}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(lea.port_b, flo.ports[1]) annotation (Line(
      points={{-44,-88},{-6,-88},{-6,-56.6667},{9,-56.6667}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(out.weaBus, weaBus) annotation (Line(
      points={{-80,-119.8},{-112,-119.8},{-112,-80},{-140,-80}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(out.ports[1], senRelPre.port_b) annotation (Line(
      points={{-60,-120},{-18,-120}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(temAirWes.T, TRooAir) annotation (Line(points={{100,-44},{160,-44},{160,
          0},{210,0}}, color={0,0,127}));
  connect(supplyAir, flo.ports[2]) annotation (Line(points={{-200,20},{-160,20},
          {-160,-54},{9,-54}}, color={0,127,255}));
  connect(returnAir, flo.ports[3]) annotation (Line(points={{-200,-20},{-166,
          -20},{-166,-51.3333},{9,-51.3333}},
                                         color={0,127,255}));
  connect(lay.port_a, TSoi[1].port)
    annotation (Line(points={{30,-100},{30,-130},{60,-130}}, color={191,0,0}));
  connect(flo.surf_conBou[1], lay.port_b)
    annotation (Line(points={{30,-60},{30,-80}}, color={191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-200,-200},
            {200,200}}), graphics={Text(
          extent={{-62,186},{16,172}},
          lineColor={28,108,200},
          textString="Add roof material or an attic zone
Add heat transfer with soil ")}),
                                Icon(coordinateSystem(
          preserveAspectRatio=true, extent={{-200,-200},{200,200}}), graphics={
        Rectangle(
          extent={{-160,-160},{160,160}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-140,138},{140,-140}},
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
          fillPattern=FillPattern.Solid)}),
    Documentation(revisions="<html>
<ul>
<li>
May 1, 2013, by Michael Wetter:<br/>
Declared the parameter record to be a parameter, as declaring its elements
to be parameters does not imply that the whole record has the variability of a parameter.
</li>
</ul>
</html>"));
end SingleZoneFloor;
