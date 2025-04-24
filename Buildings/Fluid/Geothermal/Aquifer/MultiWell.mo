within Buildings.Fluid.Geothermal.Aquifer;
model MultiWell "Model of a single well for aquifer thermal energy storage"
 replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Medium in the component" annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Water "Water")));
  parameter Integer nVol(min=1)=10 "Number of control volumes used in discretization" annotation (
      Dialog(group="Subsurface"));
  parameter Modelica.Units.SI.Height h "Aquifer thickness";
  parameter Modelica.Units.SI.Length d "Distance between wells";
  parameter Modelica.Units.SI.Height length
    "Length of one well, used to compute pressure drop";
  parameter Real nPai=1 "Number of paired wells";
  parameter Modelica.Units.SI.Radius rWB=0.1 "Wellbore radius" annotation (
      Dialog(group="Subsurface"));
  parameter Modelica.Units.SI.Radius rMax=d/2 "Domain radius" annotation (
      Dialog(group="Subsurface"));
  parameter Real griFac(min=1) = 1.15 "Grid factor for spacing" annotation (
      Dialog(group="Subsurface"));
  parameter Modelica.Units.SI.Temperature TCol_start=283.15
     "Initial temperature of cold well" annotation (
      Dialog(group="Subsurface"));
  parameter Modelica.Units.SI.Temperature THot_start=TCol_start
     "Initial temperature of warm well" annotation (
      Dialog(group="Subsurface"));
  parameter Modelica.Units.SI.Temperature TGroCol=285.15
     "Undisturbed ground temperature (cold well)" annotation (
      Dialog(group="Properties of ground"));
  parameter Modelica.Units.SI.Temperature TGroHot=TGroCol
     "Undisturbed ground temperature (warm well)" annotation (
      Dialog(group="Properties of ground"));
  parameter Buildings.Fluid.Geothermal.Aquifer.Data.Template aquDat
     "Aquifer thermal properties" annotation (choicesAllMatching=true);
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal "Nominal mass flow rate" annotation (
      Dialog(group="Hydraulic circuit"));
  parameter Modelica.Units.SI.PressureDifference dpAquifer_nominal(displayUnit= "Pa")=
    m_flow_nominal/nPai*Modelica.Constants.g_n/2/Modelica.Constants.pi/h/aquDat.K*log(d/rWB)
     "Pressure drop at nominal mass flow rate in the aquifer"  annotation (
      Dialog(group="Hydraulic circuit"));
  final parameter Modelica.Units.SI.PressureDifference dpWell_nominal(
      displayUnit="Pa") = 2*resWelCol.dp_nominal
    "Pressure drop at nominal mass flow rate in the well"
    annotation (Dialog(group="Hydraulic circuit"));
  parameter Modelica.Units.SI.PressureDifference dpExt_nominal(displayUnit="Pa")
    "Pressure drop at nominal mass flow rate in the above-surface system (used to size the head of the well pump)" annotation (
      Dialog(group="Hydraulic circuit"));

  final parameter Modelica.Units.SI.Radius rVol[nVol](
    each final fixed=false)
    "Radius to the center of the i-th domain";

  Modelica.Blocks.Interfaces.RealInput u(
      final min=-1,
      final max=1,
      final unit="1")
      "Pump control input (-1: extract from hot well, +1: extract from cold well, 0: off)"
    annotation (Placement(transformation(extent={{-220,-20},{-180,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput PTot(
    final unit="W")
  "Total power consumed by all circulation pumps in the wells"
    annotation (Placement(transformation(extent={{180,30},{200,50}}),
        iconTransformation(extent={{100,40},{120,60}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_Col(
    redeclare final package Medium = Medium) "Fluid connector" annotation (Placement(transformation(extent={{-130,
            130},{-110,150}}),    iconTransformation(extent={{-70,90},{-50,110}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_Hot(
    redeclare final package Medium = Medium) "Fluid connector" annotation (Placement(transformation(extent={{110,130},
            {130,150}}),        iconTransformation(extent={{50,90},{70,110}})));

  Modelica.Units.SI.Temperature TAquHot[nVol] = heaCapHot.T
    "Temperatures of the hot aquifer";
  Modelica.Units.SI.Temperature TAquCol[nVol] = heaCapCol.T
    "Temperatures of the cold aquifer";

  Movers.Preconfigured.SpeedControlled_y pumCol(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal/nPai,
    final dp_nominal=resAqu.dpMea_nominal + 2* resWelCol.dp_nominal + dpExt_nominal)
       "Pump to extract from cold well" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-120,0})));
  Movers.Preconfigured.SpeedControlled_y pumHot(
    redeclare final package Medium = Medium,
    final m_flow_nominal=pumCol.m_flow_nominal,
    final dp_nominal=pumCol.dp_nominal) "Pump to extract from hot well"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={120,0})));

  FixedResistances.PressureDrop resWelCol(
    redeclare final package Medium = Medium,
    m_flow_nominal=m_flow_nominal/nPai,
    final from_dp=false,
    dp_nominal=
        Modelica.Fluid.Pipes.BaseClasses.WallFriction.Detailed.pressureLoss_m_flow(
        m_flow=m_flow_nominal/nPai,
        rho_a=rhoWat,
        rho_b=rhoWat,
        mu_a=mu,
        mu_b=mu,
        length=length,
        diameter=rWB,
        roughness=2.5e-5)) "Pressure drop in the cold well" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-120,70})));

  // The resistances on the hot side are set to be the negative of the cold
  // side, as they have the same geometry and flow rate.
  // This reduces the size of the nonlinear system of equations,
  // and leads to fewer equations in the model.
  Movers.BaseClasses.IdealSource resWelHot(
    redeclare final package Medium = Medium,
    final allowFlowReversal=true,
    final control_m_flow=false,
    final control_dp=true,
    final m_flow_small=1E-4*abs(m_flow_nominal))
    "Pressure drop in the warm well" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={120,70})));

  BaseClasses.MassFlowRateMultiplier mulCol(
    redeclare final package Medium = Medium,
    k=nPai)
    "Mass flow multiplier for the cold well"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-120,110})));
  BaseClasses.MassFlowRateMultiplier mulHot(
    redeclare final package Medium = Medium,
    k=nPai)
    "Mass flow multiplier for the warm well"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={120,110})));

  Modelica.Blocks.Math.Add addPum(
    final k1=1,
    final k2=1)
    "Sum of pump electrical power"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));

  Sensors.RelativePressure dpWelCol(
    redeclare package Medium = Medium)
    "Pressure drop of cold well" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-100,70})));

  Airflow.Multizone.Point_m_flow resAqu(
    redeclare final package Medium = Medium,
    m=1,
    final dpMea_nominal=dpAquifer_nominal,
    final mMea_flow_nominal=m_flow_nominal/nPai)
    "Pressure drop in the cold and warm side of the aquifer" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={0,-70})));
protected
  parameter Modelica.Units.SI.Radius r[nVol + 1](each fixed=false)
    "Radius to the boundary of the i-th domain";
  parameter Modelica.Units.SI.HeatCapacity C[nVol](each fixed=false)
    "Heat capacity of segment";
  parameter Modelica.Units.SI.Volume VWat[nVol](each fixed=false)
    "Volumes of water";
  parameter Modelica.Units.SI.ThermalResistance R[nVol](each fixed=false)
    "Thermal resistances between nodes";
  parameter Real cAqu(fixed=false)
    "Heat capacity normalized with volume for aquifer";
  parameter Real kVol(fixed=false)
    "Heat conductivity normalized with volume";
  parameter Modelica.Units.SI.DynamicViscosity mu=Medium.dynamicViscosity(Medium.setState_pTX(
    Medium.p_default,
    Medium.T_default,
    Medium.X_default)) "Water dynamic viscosity";
  parameter Modelica.Units.SI.SpecificHeatCapacity cpWat=Medium.specificHeatCapacityCp(Medium.setState_pTX(
    Medium.p_default,
    Medium.T_default,
    Medium.X_default)) "Water specific heat capacity";
  parameter Modelica.Units.SI.Density rhoWat=Medium.density(Medium.setState_pTX(
    Medium.p_default,
    Medium.T_default,
    Medium.X_default)) "Water density";
  parameter Modelica.Units.SI.ThermalConductivity kWat=Medium.thermalConductivity(Medium.setState_pTX(
    Medium.p_default,
    Medium.T_default,
    Medium.X_default)) "Water thermal conductivity";

  Buildings.Fluid.MixingVolumes.MixingVolume volCol[nVol](
    redeclare final package Medium = Medium,
    each final T_start=TCol_start,
    each final m_flow_nominal=m_flow_nominal,
    final V=VWat,
    each nPorts=2)
    "Array of fluid volumes representing the fluid flow in the cold side of the aquifer"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-100}})));

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCapCol[nVol](C=C,
      each T(start=TCol_start, fixed=true))
    "Array of thermal capacitor in the cold side of the aquifer"
    annotation (Placement(transformation(extent={{-60,-128},{-40,-108}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor theResCol[nVol](R=R)
    "Array of thermal resistances in the cold side of the aquifer"
    annotation (Placement(transformation(extent={{-80,-140},{-100,-120}})));

  MixingVolumes.MixingVolume volHot[nVol](
    redeclare final package Medium = Medium,
    each T_start=THot_start,
    each m_flow_nominal=m_flow_nominal,
    V=VWat,
    each nPorts=2)
    "Array of fluid volumes representing the fluid flow in the warm side of the aquifer"
    annotation (Placement(transformation(extent={{50,-80},{30,-100}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCapHot[nVol](C=C,
    each T(start=THot_start, fixed=true))
    "Array of thermal capacitor in the warm side of the aquifer"
    annotation (Placement(transformation(extent={{50,-128},{30,-108}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor theResHot[nVol](R=R)
    "Array of thermal resistances in the warm side of the aquifer"
    annotation (Placement(transformation(extent={{80,-140},{100,-120}})));

  Buildings.HeatTransfer.Sources.FixedTemperature groTemCol(
    final T=TGroCol)
    "Boundary condition ground temperature in the cold side of the aquifer"
    annotation (Placement(transformation(extent={{-140,-140},{-120,-120}})));
  Buildings.HeatTransfer.Sources.FixedTemperature groTemHot(
    final T=TGroHot)
    "Boundary condition ground temperature in the warm side of the aquifer"
    annotation (Placement(transformation(extent={{140,-140},{120,-120}})));

  Modelica.Blocks.Nonlinear.Limiter limCol(final uMax=1, final uMin=0) "Limiter for pump signal"
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));
  Modelica.Blocks.Math.Gain gaiCon(final k=-1) "Inversion of control signal"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Nonlinear.Limiter limHot(final uMax=1, final uMin=0) "Limiter for pump signal"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));

  Modelica.Blocks.Math.Gain gaiPum(final k=nPai) "Gain used to scale the pump electrical power"
    annotation (Placement(transformation(extent={{80,30},{100,50}})));
initial equation
  assert(rWB < rMax, "In " + getInstanceName() + ": Require rWB < rMax");
  assert(0 < rWB, "In " + getInstanceName() + ": Require 0 < rWB");
  assert(rMax <= d/2, "In " + getInstanceName() + ": Require rMax <= d/2");

  cAqu=aquDat.dSoi*aquDat.cSoi*(1-aquDat.phi);
  kVol=kWat*aquDat.phi+aquDat.kSoi*(1-aquDat.phi);

  r[1] = rWB;
  for i in 2:nVol+1 loop
    r[i]= r[i-1] + (rMax - rWB)  * (1-griFac)/(1-griFac^(nVol)) * griFac^(i-2);
  end for;
  for i in 1:nVol loop
    rVol[i] = (r[i]+r[i+1])/2;
  end for;
  for i in 1:nVol loop
    C[i] = cAqu*h*3.14*(r[i+1]^2-r[i]^2);
  end for;
  for i in 1:nVol loop
    VWat[i] = aquDat.phi*h*3.14*(r[i+1]^2-r[i]^2);
  end for;

  R[nVol]=Modelica.Math.log(rMax/rVol[nVol])/(2*Modelica.Constants.pi*kVol*h);
  for i in 1:nVol-1 loop
    R[i] = Modelica.Math.log(rVol[i+1]/rVol[i])/(2*Modelica.Constants.pi*kVol*h);
  end for;

equation
  if nVol > 1 then
    for i in 1:(nVol - 1) loop
      connect(volCol[i].ports[2], volCol[i + 1].ports[1]);
    end for;
  end if;
  connect(resAqu.port_b, volCol[nVol].ports[2]) annotation (Line(points={{-10,-70},
          {-49,-70},{-49,-80}}, color={0,127,255}));
  connect(resAqu.port_a, volHot[nVol].ports[2])
    annotation (Line(points={{10,-70},{39,-70},{39,-80}},color={0,127,255}));
  connect(pumCol.port_a, volCol[1].ports[1]) annotation (Line(points={{-120,-10},
          {-120,-70},{-51,-70},{-51,-80}}, color={0,127,255}));
  connect(pumHot.port_a, volHot[1].ports[1]) annotation (Line(points={{120,-10},
          {120,-70},{41,-70},{41,-80}}, color={0,127,255}));

  if nVol > 1 then
    for i in 1:(nVol - 1) loop
      connect(volHot[i].ports[2], volHot[i + 1].ports[1]);
    end for;
  end if;

  if nVol > 1 then
    for i in 1:(nVol - 1) loop
      connect(heaCapCol[i + 1].port, theResCol[i].port_b);
    end for;
  end if;

  if nVol > 1 then
    for i in 1:(nVol - 1) loop
      connect(heaCapHot[i + 1].port, theResHot[i].port_b);
    end for;
  end if;

  connect(groTemCol.port, theResCol[nVol].port_b)
    annotation (Line(points={{-120,-130},{-100,-130}},
                                                   color={191,0,0}));

  connect(volCol.heatPort, heaCapCol.port) annotation (Line(points={{-60,-90},{-70,
          -90},{-70,-130},{-50,-130},{-50,-128}},
                                    color={191,0,0}));
  connect(theResCol.port_a, volCol.heatPort) annotation (Line(points={{-80,-130},
          {-70,-130},{-70,-90},{-60,-90}},
                                        color={191,0,0}));
  connect(groTemHot.port, theResHot[nVol].port_b)
    annotation (Line(points={{120,-130},{100,-130}},
                                                 color={191,0,0}));
  connect(volHot.heatPort, heaCapHot.port) annotation (Line(points={{50,-90},{60,
          -90},{60,-130},{40,-130},{40,-128}},
                                  color={191,0,0}));
  connect(theResHot.port_a, volHot.heatPort) annotation (Line(points={{80,-130},
          {60,-130},{60,-90},{50,-90}},
                                    color={191,0,0}));
  connect(pumCol.port_b, resWelCol.port_a)
    annotation (Line(points={{-120,10},{-120,60}},
                                                 color={0,127,255}));
  connect(resWelHot.port_a, pumHot.port_b)
    annotation (Line(points={{120,60},{120,10}},
                                               color={0,127,255}));
  connect(limCol.y, pumCol.y) annotation (Line(points={{-139,0},{-138,0},{-138,6.66134e-16},
          {-132,6.66134e-16}},                                                             color={0,0,127}));
  connect(gaiCon.y, limHot.u) annotation (Line(points={{61,0},{78,0}},   color={0,0,127}));
  connect(limHot.y, pumHot.y) annotation (Line(points={{101,0},{100,0},{100,6.66134e-16},
          {108,6.66134e-16}},                                                          color={0,0,127}));
  connect(gaiCon.u, u) annotation (Line(points={{38,0},{0,0},{0,20},{-170,20},{-170,
          0},{-200,0}},                                                                color={0,0,127}));
  connect(limCol.u, u) annotation (Line(points={{-162,0},{-200,0}},                    color={0,0,127}));
  connect(resWelCol.port_b, mulCol.port_a)
    annotation (Line(points={{-120,80},{-120,100}},
                                                 color={0,127,255}));
  connect(mulCol.port_b, port_Col) annotation (Line(points={{-120,120},{-120,140}},                color={0,127,255}));
  connect(mulHot.port_b, port_Hot) annotation (Line(points={{120,120},{120,140}},              color={0,127,255}));
  connect(resWelHot.port_b, mulHot.port_a)
    annotation (Line(points={{120,80},{120,100}},
                                               color={0,127,255}));
  connect(pumCol.P, addPum.u1)
    annotation (Line(points={{-129,11},{-129,46},{38,46}},                  color={0,0,127}));
  connect(addPum.y, gaiPum.u) annotation (Line(points={{61,40},{78,40}},  color={0,0,127}));
  connect(pumHot.P, addPum.u2) annotation (Line(points={{111,11},{111,20},{20,20},
          {20,34},{38,34}}, color={0,0,127}));
  connect(gaiPum.y, PTot) annotation (Line(points={{101,40},{190,40}}, color={0,0,127}));
  connect(dpWelCol.port_a, resWelCol.port_b) annotation (Line(points={{-100,80},
          {-100,90},{-120,90},{-120,80}},
                                      color={0,127,255}));
  connect(dpWelCol.port_b, resWelCol.port_a) annotation (Line(points={{-100,60},
          {-100,52},{-120,52},{-120,60}},
                                      color={0,127,255}));
  connect(dpWelCol.p_rel, resWelHot.dp_in) annotation (Line(points={{-91,70},{
          100,70},{100,76},{112,76}}, color={0,0,127}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-100,-100},
            {100,100}}),
    graphics={
        Rectangle(
          extent={{-20,100},{20,-2}},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{20,2},{-20,-6}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={211,168,137},
          fillPattern=FillPattern.Forward),
        Rectangle(
          extent={{-100,20},{100,-48}},
          fillColor={241,241,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-100,100},{100,82}},
          lineColor={0,0,0},
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-84,100},{-36,-14}},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-36,-6},{-84,-22}},
          lineColor={0,0,0},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-147,-108},{153,-148}},
          textColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{36,100},{84,-14}},
          fillColor={238,22,26},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{84,-6},{36,-22}},
          lineColor={0,0,0},
          fillColor={182,12,18},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-140,46},{-110,22}},
          textColor={0,0,127},
          textString="uPum"),
        Text(
          extent={{106,84},{136,60}},
          textColor={0,0,127},
          textString="PTot"),
        Text(
         extent={{-52,144},{-172,94}},
          textColor={0,0,100},
          textString=DynamicSelect("", String(pumCol.heatPort.T-273.15, format=".1f"))),
        Text(
         extent={{170,144},{50,94}},
          textColor={0,0,100},
          textString=DynamicSelect("", String(pumHot.heatPort.T-273.15, format=".1f")))}),
        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-160},{180,140}})),
        defaultComponentName="aquWel",
        Documentation(info="<html>
<p>
This model simulates aquifer thermal energy storage, using one or multiple pairs of cold and hot wells.
</p>
<p>
To calculate aquifer temperature at different locations over time, the model applies
physical principles of water flow and heat transfer phenomena. The model is based on
the partial differential equation (PDE) for 1D conductive-convective transient
radial heat transport in porous media
</p>
<p align=\"center\" style=\"font-style:italic;\">
&rho; c (&part; T(r,t) &frasl; &part;t) =
k (&part;&sup2; T(r,t) &frasl; &part;r&sup2;) - &rho;<sub>w</sub> c<sub>w</sub> u(&part; T(r,t) &frasl; &part;t),
</p>
<p>
where
<i>&rho;</i>
is the mass density,
<i>c</i>
is the specific heat capacity per unit mass,
<i>T</i>
is the temperature at location <i>r</i> and time <i>t</i>,
<i>u</i> is water velocity and
<i>k</i> is the heat conductivity. The subscript <i>w</i> indicates water.
The first term on the right hand side of the equation describes the effect of conduction, while
the second term describes the fluid flow.
</p>
<p>
The pressure losses in the aquifer are calculated using the Darcy's law
<p align=\"center\" style=\"font-style:italic;\">
&#916;p = &#7745; g &frasl; (2 &#960; K h ln(rMax &frasl; rWB)),
</p>
<p>
where <i>&#7745;</i> is the water mass flow rate, <i>g</i> is the gravitational acceleration,
<i>K</i> is the hydraulic conductivity, <i>h</i> is the thickness of the aquifer, 
<i>rMax</i> is the domain radius and <i>rWB</i> is the well radius.
The pressure losses in the wells are calculated using
<a href=\"modelica://Modelica.Fluid.Pipes.BaseClasses.WallFriction.Detailed.pressureLoss_m_flow\">
Modelica.Fluid.Pipes.BaseClasses.WallFriction.Detailed.pressureLoss_m_flow</a>.
</p>
<h4>Spatial discretization</h4>
<p>
To discretize the conductive-convective equation, the domain is divided into a series
of thermal capacitances and thermal resistances along the radial direction. The
implementation uses an array of
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Components.HeatCapacitor\">
Modelica.Thermal.HeatTransfer.Components.HeatCapacitor</a>
and <a href=\"modelica://Modelica.Thermal.HeatTransfer.Components.ThermalResistor\">
Modelica.Thermal.HeatTransfer.Components.ThermalResistor</a>.
Fluid flow was modelled by adding a series of fluid volumes, which are connected
to the thermal capacitances via heat ports. The fluid stream was developed using
the model <a href=\"modelica://Buildings.Fluid.MixingVolumes.MixingVolume\">Buildings.Fluid.MixingVolumes.MixingVolume</a>.
The geometric representation of the model is illustrated in the figure below.
</p>
<p align=\"center\">
<img  alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/Aquifer/Geometry.png\">
</p>
<h4>Typical use and important parameters</h4>
<p>
By default, the component consists of a single pair of wells: one cold well and one warm well.
The number of paired wells can be increased by modifing the parameters <code>nPai</code>.
The effect is a proportional increase of thermal capacity, and the mass flow rate at <code>port_a</code>
and <code>port_b</code> is equally distributed to the pairs of well, thus
all pairs have the same mass flow rates and temperatures, and the quantities
at the fluid ports is for all well combined, as is the electricity consumption <code>PTot</code>
for the well pumps.
</p>
<p>
To ensure conservation of energy, the wells are connected via fluid ports.
To avoid thermal interferences, make sure that the aquifer domain radius
<code>rMax</code> is large enough for your specific use case.
</p>
<p>
Circulation pumps are included in the model and they can be controlled by acting on the input connector.
The input must vary between <i>[1, -1]</i>.
A positive value will circulate water
clockwise (from <code>port_Hot</code> to <code>port_Col</code>, thus 
extraction from the cold well and injection into the warm well).
A negative value will circulate water anticlockwise.
</p>
<p>
The temperature values in the warm and cold aquifers can be accessed using
<code>TAquHot</code> and <code>TAquCol</code>.
These temperatures correspond to the temperatures of each thermal capacitance
in the discretized domain. The location of the thermal capacitance is expressed by <code>rVol</code>.
</p>
<h4>Implementation</h4>
<p>
The model computes the flow resistance of the cold well and the cold acquifer.
Because of symmetry, the warm side has the same flow resistances.
To reduce the number of equations in the model, the flow resistance of the warm
side is set to the same flow resistance as on the cold side, but with the
sign reversed.
</p>
</html>", revisions="<html>
<ul>
<li>
September 22 2023, by Alessandro Maccarini and Michael Wetter:<br/>
First Implementation.
</li>
</ul>
</html>"));
end MultiWell;
