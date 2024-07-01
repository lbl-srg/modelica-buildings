within Buildings.ThermalZones.ISO13790.Zone5R1C;
model Zone "Thermal zone based on 5R1C network"
  parameter Real airRat(unit="1/h") "Air change rate"
   annotation (Dialog(group="Ventilation"));
  parameter Modelica.Units.SI.Area AWin[nOrientations] "Area of windows"
   annotation (Dialog(group="Windows"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer UWin "U-value of windows"
   annotation (Dialog(group="Windows"));
  parameter Modelica.Units.SI.Area AWal[nOrientations] "Area of external walls (only opaque part)"
   annotation (Dialog(group="Opaque constructions"));
  parameter Modelica.Units.SI.Area ARoo "Area of roof"
   annotation (Dialog(group="Opaque constructions"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer UWal "U-value of external walls"
   annotation (Dialog(group="Opaque constructions"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer URoo "U-value of roof"
   annotation (Dialog(group="Opaque constructions"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer UFlo "U-value of floor"
   annotation (Dialog(group="Opaque constructions"));
  parameter Real b=0.5 "Adjustment factor for ground heat transfer"
   annotation (Dialog(group="Opaque constructions"));
  parameter Modelica.Units.SI.Area AFlo "Net conditioned floor area";
  parameter Modelica.Units.SI.Volume VRoo "Volume of room";
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hInt=3.45
    "Heat transfer coefficient between surface and air nodes";
  replaceable parameter ISO13790.Data.Generic buiMas "Building mass"
   annotation (
     choicesAllMatching=true,
     Placement(transformation(extent={{-100,-130},{-80,-110}})));
  parameter Integer nOrientations(min=1) = 4 "Number of orientations for vertical walls";
  parameter Modelica.Units.SI.Angle surTil[nOrientations] "Tilt angle of surfaces";
  parameter Modelica.Units.SI.Angle surAzi[nOrientations] "Azimuth angle of surfaces";
  parameter Real winFra(min=0, max=1)=0.001 "Frame fraction of windows"
   annotation(Dialog(group="Windows"));
  parameter Real gFac(min=0, max=1) "Energy transmittance of glazings"
   annotation(Dialog(group="Windows"));

  Modelica.Blocks.Interfaces.RealInput intSenGai(final unit="W") "Internal sensible heat gains"
    annotation (Placement(transformation(extent={{-180,80},{-140,120}}),
        iconTransformation(extent={{-180,80},{-140,120}})));

  Modelica.Blocks.Interfaces.RealOutput TAir(
    final unit="K",
    displayUnit="degC")
    "Room air temperature"
    annotation (Placement(
        transformation(extent={{140,70},{160,90}}),
        iconTransformation(extent={{
            140,70},{160,90}})));
  Modelica.Blocks.Interfaces.RealOutput TSur(
    final unit="K",
    displayUnit="degC")
    "Average inside surface temperature" annotation (Placement(
        transformation(extent={{140,50},{160,70}}),
        iconTransformation(extent={{
            140,-10},{160,10}})));

  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    "Weather data bus"
    annotation (Placement(
        transformation(extent={{100,100},{140,140}}),
        iconTransformation(extent={{68,78},{132,142}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorAir
    "Heat port to air node"
    annotation (Placement(transformation(extent={{30,70},{50,90}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorSur
    "Heat port to surface temperatures"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor HVen(
      G=airRat*VRoo*1005*1.2/3600) "Heat transfer due to ventilation"
   annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor HTra(
      G=1/(1/(UWal*sum(AWal) + b*UFlo*AFlo + URoo*ARoo) - 1/(hSur*buiMas.facMas*AFlo)))
      "Heat transfer through opaque elements"
   annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor HWin(
      G=UWin*sum(AWin)) "Heat transfer through glazed elements"
   annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor HThe(G=hInt*AFlo*ratSur)
    "Coupling conductance betwee air and surface nodes"
   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,40})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor HMas(G=hSur*buiMas.facMas*AFlo)
    "Coupling conductance between surface and mass nodes"
   annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,-40})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor capMas(
      C=buiMas.heaC*AFlo,
      T(displayUnit="degC",
      fixed=true,
      start=293.15)) "Zone thermal capacity" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={40,-100})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TExt
    "External air temperature"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Modelica.Blocks.Math.Add solGai "Total solar heat gains"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  BaseClasses.GlazedElements win(
    final n=nOrientations,
    final AWin=AWin,
    final surTil=surTil,
    final surAzi=surAzi,
    final gFac=gFac,
    final winFra=winFra) "Solar heat gains of glazed elements"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  BaseClasses.OpaqueElements opa(
    final n=nOrientations,
    final AWal=AWal,
    final ARoo=ARoo,
    final UWal=UWal,
    final URoo=URoo,
    final surTil=surTil,
    final surAzi=surAzi) "Solar heat gains of opaque elements"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  BaseClasses.GainSurface phiSur(
    ATot=AFlo*ratSur,
    facMas=buiMas.facMas,
    AFlo=AFlo,
    HWinGai=HWin.G) "Heat flow injected to surface node"
    annotation (Placement(transformation(extent={{120,-10},{100,10}})));
  Modelica.Blocks.Math.Gain phiAir(k=0.5) "Heat flow injected to air node"
    annotation (Placement(transformation(extent={{120,70},{100,90}})));
  BaseClasses.GainMass phiMas(
    ATot=AFlo*ratSur,
    facMas=buiMas.facMas,
    AFlo=AFlo) "Heat flow injected to mass node"
    annotation (Placement(transformation(extent={{120,-90},{100,-70}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TVen "Supply air temperature"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));

protected
  parameter Real ratSur=4.5 "Ratio between the internal surfaces area and the floor area";
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hSur=9.1 "Heat transfer coefficient between mass and surface nodes";

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTAir
    "Air temperature sensor"
    annotation (Placement(transformation(extent={{70,50},{90,70}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTSur
    "Surface temperature sensor"
    annotation (Placement(transformation(extent={{70,20},{90,40}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heaAir
    annotation (Placement(transformation(extent={{80,70},{60,90}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heaSur
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heaMas
    annotation (Placement(transformation(extent={{80,-90},{60,-70}})));
initial equation
  assert(size(AWin,1) == nOrientations, "The parameter AWin must have the same dimension of nOrientations.");
  assert(size(AWal,1) == nOrientations, "The parameter AWal must have the same dimension of nOrientations.");
  assert(size(surTil,1) == nOrientations, "The parameter surTil must have the same dimension of nOrientations.");
  assert(size(surAzi,1) == nOrientations, "The parameter surAzi must have the same dimension of nOrientations.");

equation

  connect(heaPorSur, HWin.port_b)
    annotation (Line(points={{40,0},{20,0}}, color={191,0,0}));
  connect(heaPorAir, HVen.port_b)
    annotation (Line(points={{40,80},{20,80}}, color={191,0,0}));
  connect(heaPorAir, HThe.port_b)
    annotation (Line(points={{40,80},{40,50}}, color={191,0,0}));
  connect(heaPorAir, heaAir.port)
    annotation (Line(points={{40,80},{60,80}}, color={191,0,0}));
  connect(heaSur.port, heaPorSur)
    annotation (Line(points={{60,0},{40,0}}, color={191,0,0}));
  connect(heaPorSur, HMas.port_b)
    annotation (Line(points={{40,0},{40,-30}}, color={191,0,0}));
  connect(weaBus.TDryBul,TExt. T) annotation (Line(
      points={{120,120},{-112,120},{-112,0},{-102,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(heaPorSur, HThe.port_a)
    annotation (Line(points={{40,0},{40,30}}, color={191,0,0}));
  connect(win.weaBus, weaBus) annotation (Line(
      points={{-100,-50},{-112,-50},{-112,120},{120,120}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(opa.weaBus, weaBus) annotation (Line(
      points={{-100,-90},{-112,-90},{-112,120},{120,120}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(HWin.port_a,TExt. port)
    annotation (Line(points={{0,0},{-80,0}}, color={191,0,0}));
  connect(HTra.port_a, TExt.port) annotation (Line(points={{0,-80},{-20,-80},{-20,
          0},{-80,0}}, color={191,0,0}));
  connect(heaMas.port, HTra.port_b)
    annotation (Line(points={{60,-80},{20,-80}}, color={191,0,0}));
  connect(capMas.port, HTra.port_b)
    annotation (Line(points={{40,-90},{40,-80},{20,-80}},  color={191,0,0}));
  connect(HMas.port_a, HTra.port_b)
    annotation (Line(points={{40,-50},{40,-80},{20,-80}}, color={191,0,0}));
  connect(TVen.port, HVen.port_a)
    annotation (Line(points={{-80,80},{0,80}}, color={191,0,0}));
  connect(weaBus.TDryBul,TVen. T) annotation (Line(
      points={{120,120},{-112,120},{-112,80},{-102,80}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(solGai.y, phiMas.solGai) annotation (Line(points={{-39,-70},{-30,-70},
          {-30,-120},{134,-120},{134,-88},{122,-88}}, color={0,0,127}));
  connect(phiSur.solGai, solGai.y) annotation (Line(points={{122,-8},{134,-8},{134,
          -120},{-30,-120},{-30,-70},{-39,-70}}, color={0,0,127}));
  connect(intSenGai, phiMas.intSenGai) annotation (Line(points={{-160,100},{130,
          100},{130,-84},{122,-84}},                        color={0,0,127}));
  connect(phiSur.intSenGai, intSenGai) annotation (Line(points={{122,-4},{130,-4},
          {130,100},{-160,100}},                         color={0,0,127}));
  connect(phiAir.u, intSenGai) annotation (Line(points={{122,80},{130,80},{130,100},
          {-160,100}},                        color={0,0,127}));
  connect(phiMas.masGai, heaMas.Q_flow)
    annotation (Line(points={{99,-80},{80,-80}}, color={0,0,127}));
  connect(phiAir.y, heaAir.Q_flow)
    annotation (Line(points={{99,80},{80,80}}, color={0,0,127}));
  connect(phiSur.surGai, heaSur.Q_flow)
    annotation (Line(points={{99,0},{80,0}}, color={0,0,127}));
  connect(win.solRadWin, solGai.u1) annotation (Line(points={{-79,-50},{-70,-50},
          {-70,-64},{-62,-64}}, color={0,0,127}));
  connect(opa.y, solGai.u2) annotation (Line(points={{-79,-90},{-70,-90},{-70,-76},
          {-62,-76}}, color={0,0,127}));
  connect(senTSur.port, heaPorSur)
    annotation (Line(points={{70,30},{52,30},{52,0},{40,0}}, color={191,0,0}));
  connect(senTAir.port, heaPorAir)
    annotation (Line(points={{70,60},{40,60},{40,80}}, color={191,0,0}));
  connect(senTAir.T, TAir) annotation (Line(points={{91,60},{134,60},{134,80},{150,
          80}}, color={0,0,127}));
  connect(senTSur.T, TSur) annotation (Line(points={{91,30},{136,30},{136,60},{150,
          60}}, color={0,0,127}));
  annotation (defaultComponentName="zon", Icon(
    coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -140},{140,140}}), graphics={Rectangle(
          extent={{-140,140},{140,-140}},
          lineThickness=1,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-120,122},{118,-122}},
          lineColor={117,148,176},
          fillPattern=FillPattern.Solid,
          fillColor=DynamicSelect({170,213,255},
            min(1, max(0, (1-(heaPorAir.T-295.15)/10)))*{28,108,200}+
            min(1, max(0, (heaPorAir.T-295.15)/10))*{255,0,0})),
        Text(
          extent={{-104,174},{118,142}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{60,-82},{118,-126}},
          textColor={0,0,0},
          textString="ISO"),
        Text(
          extent={{-180,156},{-116,110}},
          textColor={0,0,88},
          textString="intSenGai"),
        Text(
          extent={{88,94},{136,62}},
          textColor={0,0,88},
          textString="TAir"),
        Text(
          extent={{82,18},{130,-14}},
          textColor={0,0,88},
          textString="TSur"),
        Text(
          extent={{48,108},{-72,58}},
          textColor={255,255,255},
          textString=DynamicSelect("", String(heaPorAir.T-273.15, format=".1f")))}),
    Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-140,-140},{140,140}})),
    Documentation(info="<html>
<p>
This is a lumped-capacity simplified building model based  on the 5R1C
network presented in the ISO 13790:2008 Standard. The simplified 5R1C model uses
five thermal resistances and one thermal capacity to reproduce the
transient thermal behaviour of buildings. The thermal zone is modeled with three
temperature nodes, the indoor air temperature <code>TAir</code>, the envelope internal
surface temperature <code>TSur</code> and the zone's mass temperature <code>TMas</code>
(the heat port is not shown in the figure), and two boundary
condition nodes, supply air temperature <code>TSup</code> and the external air temperature
<code>TExt</code>. The five resistances are related to heat transfer by ventilation <code>HVen</code>,
windows <code>HWin</code>, opaque components (split between <code>HTra</code> and <code>HMas</code>) and heat
transfer between the internal surfaces of walls and the air temperature <code>HThe</code>.
The thermal capacity <code>Cm</code> includes the thermal capacity of the entire zone. The heating and/or
cooling demand is found by calculating the heating and/or cooling power &Phi;HC that
needs to be supplied to, or extracted from, the internal air node to maintain a
certain set-point. Internal, &Phi;int , and solar, &Phi;sol, heat gains are input values,
which are split in three components.
</p>
<br>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/ThermalZones/ISO13790/Zone/5R1CNetwork.png\" alt=\"image\"/>
</p>
<br>
The ventilation heat transfer coefficient <i>H<sub>ven</sub></i> is calculated using
<p align=\"center\" style=\"font-style:italic;\">
H<sub>ven</sub> = &rho;<sub>a</sub> c<sub>a</sub> &sum;<sub>k</sub>V&#775;<sub>k</sub>,
</p>
where <i>&rho;<sub>a</sub></i> is the density of air, <i>c<sub>a</sub></i> is the specific
heat capacity of air and <i>V&#775;<sub>k</sub></i> is the k-th volumetric external air
flow rate.
The coupling conductance <i>H<sub>the</sub></i> is given by
<p align=\"center\" style=\"font-style:italic;\">
H<sub>the</sub> = h<sub>as</sub> A<sub>tot</sub>,
</p>
where <i>h<sub>as</sub></i> is the heat transfer coefficient between the air
node the surface node, with a fixed value of <i>3.45 W/m<sup>2</sup>K</i>, and
<i>A<sub>tot</sub></i> is the area of all surfaces facing the building zone.
The thermal transmission coefficient of windows <i>H<sub>win</sub></i> is calculated using
<p align=\"center\" style=\"font-style:italic;\">
H<sub>win</sub> =
&sum;<sub>k</sub>U<sub>win,k</sub>A<sub>win,k</sub>,
</p>
where <i>U<sub>win,k</sub></i> is the thermal transmittance of window element
k of the building envelope and <i>A<sub>k</sub></i>  is the area of the window
element k of the building envelope. The coupling conductance <i>H<sub>mas</sub></i> is given by
<p align=\"center\" style=\"font-style:italic;\">
H<sub>mas</sub> =h<sub>ms</sub> f<sub>ms</sub> A<sub>f</sub>,
</p>
where <i>h<sub>ms</sub></i> is the heat transfer coefficient between the mass
node and the surface node, with fixed value of <i>9.1 W/m<sup>2</sup>K</i>,
<i>f<sub>ms</sub></i> is a correction factor, and <i>A<sub>f</sub></i>
is the floor area. The correction factor <i>f<sub>ms</sub></i> can be assumed as
<i>2.5</i> for light and medium building constructions, and <i>3</i> for heavy constructions.
The coupling conductance <i>H<sub>tra</sub></i> is calculated using
<p align=\"center\" style=\"font-style:italic;\">
H<sub>tra</sub> =
1 &frasl; (1 &frasl; H<sub>op</sub> - 1 &frasl; H<sub>mas</sub>),
</p>
where <i>H<sub>op</sub></i> is the thermal transmission coefficient of opaque elements.
The three heat gains components are calculated using
<p align=\"center\" style=\"font-style:italic;\">
&Phi;<sub>air</sub> = 0.5 &Phi;<sub>int</sub>,
</p>
<p align=\"center\" style=\"font-style:italic;\">
&Phi;<sub>sur</sub> = (1-f<sub>ms</sub> A<sub>f</sub> &frasl; A<sub>tot</sub>
-H<sub>win</sub> &frasl; h<sub>ms</sub> A<sub>tot</sub>)(0.5 &Phi;<sub>int</sub>+
&Phi;<sub>sol</sub>),
</p>
<p align=\"center\" style=\"font-style:italic;\">
&Phi;<sub>mas</sub> = f<sub>ms</sub> A<sub>f</sub> &frasl; A<sub>tot</sub> (0.5&Phi;<sub>int</sub> +
&Phi;<sub>sol</sub>).
</p>
<h4>Tips for parametrization</h4>
<ul>
<li>
The parameters <code>AWin</code>, <code>AWal</code>, <code>surTil</code> and <code>surAzi</code>
must have the same dimension of <code>nOrientations</code> .
</li>
<li>
The areas in <code>AWal</code> must account only for the opaque parts of the walls (excluding windows).
The floor and roof area is entered through <code>AFlo</code> and <code>ARoo</code>
and must not be entered as part of <code>AWal</code>.
</li>
<li>
If a wall contains only opaque parts, the corresponding window area must be set to <i>0</i>.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
May 8, 2024, by Michael Wetter:<br/>
Removed connection to itself.
</li>
<li>
Mar 16, 2022, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul>
</html>"));
end Zone;
