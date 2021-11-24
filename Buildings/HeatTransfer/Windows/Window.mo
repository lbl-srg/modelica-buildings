within Buildings.HeatTransfer.Windows;
model Window "Model for a window"

  constant Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(HideResult=true);

  parameter Buildings.HeatTransfer.Data.GlazingSystems.Generic glaSys
    "Glazing system"
    annotation (choicesAllMatching=true, Placement(transformation(extent={{150,174},
            {170,194}})));
  parameter Modelica.SIunits.Area A "Heat transfer area";
  parameter Real fFra(min=0, max=1)=0.1 "Fraction of frame";
  final parameter Modelica.SIunits.Area AFra = fFra*A "Frame area";
  final parameter Modelica.SIunits.Area AGla = A-AFra "Glass area";
  parameter Boolean linearize=false "Set to true to linearize emissive power";
  parameter Modelica.SIunits.Angle til(displayUnit="deg") "Surface tilt";

  parameter Boolean steadyState = true
    "Flag, if true, then window is steady-state, else capacity is added at room-side"
    annotation(Evaluate=true, Dialog(tab="Dynamics"));

  Interfaces.RadiosityOutflow JOutUns_a
    "Outgoing radiosity that connects to unshaded part of glass at exterior side"
    annotation (Placement(transformation(extent={{-200,70},{-220,90}})));
  Interfaces.RadiosityInflow JInUns_a
    "Incoming radiosity that connects to unshaded part of glass at exterior side"
    annotation (Placement(transformation(extent={{-220,110},{-200,130}})));
  Interfaces.RadiosityOutflow JOutSha_a if haveShade
    "Outgoing radiosity that connects to shaded part of glass at exterior side"
    annotation (Placement(transformation(extent={{-200,-110},{-220,-90}})));
  Interfaces.RadiosityInflow JInSha_a if haveShade
    "Incoming radiosity that connects to shaded part of glass at exterior side"
    annotation (Placement(transformation(extent={{-220,-70},{-200,-50}})));

  Interfaces.RadiosityOutflow JOutUns_b
    "Outgoing radiosity that connects to unshaded part of glass at room-side"
    annotation (Placement(transformation(extent={{200,110},{220,130}})));
  Interfaces.RadiosityInflow JInUns_b
    "Incoming radiosity that connects to unshaded part of glass at room-side"
    annotation (Placement(transformation(extent={{220,70},{200,90}})));
  Interfaces.RadiosityOutflow JOutSha_b if haveShade
    "Outgoing radiosity that connects to shaded part of glass at room-side"
    annotation (Placement(transformation(extent={{200,-70},{220,-50}})));
  Interfaces.RadiosityInflow JInSha_b if haveShade
    "Incoming radiosity that connects to shaded part of glass at room-side"
    annotation (Placement(transformation(extent={{220,-110},{200,-90}})));

  Buildings.HeatTransfer.Windows.BaseClasses.CenterOfGlass glaUns(
    final glaSys=glaSys,
    final A=AGla,
    final til=til,
    final linearize=linearize,
    final homotopyInitialization=homotopyInitialization)
    "Model for unshaded center of glass"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));

  Buildings.HeatTransfer.Windows.BaseClasses.CenterOfGlass glaSha(
    final glaSys=glaSys,
    final A=AGla,
    final til=til,
    final linearize=linearize,
    final homotopyInitialization=homotopyInitialization)
    if haveShade "Model for shaded center of glass"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor frame(
    G=AFra*glaSys.UFra,
    dT(start=0)) "Thermal conductance of frame"
    annotation (Placement(transformation(extent={{-10,-170},{10,-150}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a glaUns_a
    "Heat port at unshaded glass of exterior-facing surface"
    annotation (Placement(transformation(extent={{-210,10},{-190,30}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b glaUns_b
    "Heat port at unshaded glass of room-facing surface"
    annotation (Placement(transformation(extent={{190,10},{210,30}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a glaSha_a if haveShade
    "Heat port at shaded glass of exterior-facing surface"
    annotation (Placement(transformation(extent={{-210, -30}, {-190,-10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b glaSha_b if haveShade
    "Heat port at shaded glass of room-facing surface"
  annotation (Placement(transformation(extent={{190,-30}, {210,-10}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a fra_a
    "Heat port at frame of exterior-facing surface"
    annotation (Placement(transformation(extent={{-210,-170},{-190,-150}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b fra_b
    "Heat port at frame of room-facing surface"
     annotation (Placement(transformation(extent={{192,-170},{212,-150}})));
  Modelica.Blocks.Interfaces.RealInput uSha(min=0, max=1)
    if haveShade
    "Control signal for the shading device. 0: unshaded; 1: fully shaded (removed if no shade is present)"
    annotation (Placement(transformation(extent={{-240,140},{-200,180}})));

  Modelica.Blocks.Interfaces.RealInput QAbsUns_flow[size(glaSys.glass, 1)](
    each unit="W",
    each quantity="Power")
    "Solar radiation absorbed by unshaded part of glass"
     annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-80,-220}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-80,-220})));
  Modelica.Blocks.Interfaces.RealInput QAbsSha_flow[size(glaSys.glass, 1)](
     each unit="W",
     each quantity="Power") if haveShade
    "Solar radiation absorbed by shaded part of glass"
   annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={60,-220}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={80,-220})));

  Buildings.HeatTransfer.Windows.BaseClasses.HeatCapacity capGla(
    final haveShade=glaSys.haveExteriorShade or glaSys.haveInteriorShade,
    C=AGla*glaSys.glass[1].x*matGla.d*matGla.c,
    der_TUns(fixed=true),
    der_TSha(fixed=glaSys.haveExteriorShade or glaSys.haveInteriorShade))
      if not steadyState
    "Heat capacity of glass on room-side, used to reduce nonlinear system of equations"
    annotation (Placement(transformation(extent={{130,38},{150,58}})));
  // We assume the frame is made of wood. Data are used for Plywood, as
  // this is an order of magnitude estimate for the heat capacity of the frame,
  // which is only used to avoid algebraic loops in the room model.
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor capFra(
    der_T(fixed=true),
    C=AFra*matFra.x*matFra.d*matFra.c)
      if not steadyState
    "Heat capacity of frame on room-side, used to reduce nonlinear system of equations"
    annotation (Placement(transformation(extent={{130,-142},{150,-122}})));

protected
  final parameter Boolean haveShade = glaSys.haveExteriorShade or glaSys.haveInteriorShade
    "Parameter, equal to true if the window has a shade"
    annotation(Evaluate=true);

  BaseClasses.ShadingSignal shaSig(final haveShade=glaSys.haveExteriorShade or glaSys.haveInteriorShade)
    "Block to constrain the shading control signal to be strictly within (0, 1) if a shade is present"
    annotation (Placement(transformation(extent={{-60,150},{-40,170}})));

  parameter Data.Solids.Plywood matFra(x=0.03)
    "Thermal properties of frame (used to avoid algebraic loops in room model)"
    annotation (Placement(transformation(extent={{108,174},{128,194}})));
  parameter Data.Solids.Glass matGla(
    x=glaSys.glass[end].x,
    nSta=1,
    nStaReal=1)
    "Material properties for thermal capacity of room-facing glass (used to avoid algebraic loops in room model)"
    annotation (Placement(transformation(extent={{108,150},{128,170}})));

initial equation
  assert(homotopyInitialization, "In " + getInstanceName() +
    ": The constant homotopyInitialization has been modified from its default value. This constant will be removed in future releases.",
    level = AssertionLevel.warning);

equation
  connect(frame.port_a, fra_a) annotation (Line(
      points={{-10,-160},{-200,-160}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(frame.port_b, fra_b)  annotation (Line(
      points={{10,-160},{202,-160}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(glaUns.glass_a, glaUns_a)
                                  annotation (Line(
      points={{-10,20},{-200,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(glaUns.glass_b, glaUns_b)
                                  annotation (Line(
      points={{10,20},{200,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(shaSig.yCom, glaUns.u) annotation (Line(
      points={{-39,154},{-20,154},{-20,28},{-11,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaSig.y, glaSha.u) annotation (Line(
      points={{-39,160},{-24,160},{-24,-12},{-11,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaSig.u, uSha) annotation (Line(
      points={{-62,160},{-220,160}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(glaSha.glass_a, glaSha_a) annotation (Line(
      points={{-10,-20},{-200,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(glaSha.glass_b, glaSha_b) annotation (Line(
      points={{10,-20},{200,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(JInUns_a, glaUns.JIn_a) annotation (Line(
      points={{-210,120},{-40,120},{-40,24},{-11,24}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(glaUns.JOut_a, JOutUns_a) annotation (Line(
      points={{-11,16},{-46,16},{-46,80},{-210,80}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(glaUns.JOut_b, JOutUns_b) annotation (Line(
      points={{11,24},{170,24},{170,120},{210,120}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(JInUns_b, glaUns.JIn_b) annotation (Line(
      points={{210,80},{176,80},{176,16},{11,16}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(JInSha_a, glaSha.JIn_a) annotation (Line(
      points={{-210,-60},{-46,-60},{-46,-16},{-11,-16}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(glaSha.JOut_a, JOutSha_a) annotation (Line(
      points={{-11,-24},{-42,-24},{-42,-100},{-210,-100}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(glaSha.JOut_b, JOutSha_b) annotation (Line(
      points={{11,-16},{176,-16},{176,-60},{210,-60}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(JInSha_b, glaSha.JIn_b) annotation (Line(
      points={{210,-100},{172,-100},{172,-24},{11,-24}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(glaUns.QAbs_flow, QAbsUns_flow) annotation (Line(
      points={{6.10623e-16,9},{6.10623e-16,4},{-80,4},{-80,-220}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(glaSha.QAbs_flow,QAbsSha_flow)  annotation (Line(
      points={{6.10623e-16,-31},{6.10623e-16,-60},{60,-60},{60,-220}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(capFra.port, fra_b) annotation (Line(points={{140,-142},{140,-160},{
          202,-160}}, color={191,0,0}));
  connect(capGla.ySha, shaSig.y) annotation (Line(points={{128,52},{80,52},{-24,
          52},{-24,160},{-39,160}}, color={0,0,127}));
  connect(capGla.yCom, shaSig.yCom) annotation (Line(points={{128,44},{60,44},{-20,
          44},{-20,154},{-39,154}}, color={0,0,127}));
  connect(capGla.portSha, glaSha_b) annotation (Line(points={{150,52},{160,52},{
          160,-20},{200,-20}}, color={191,0,0}));
  connect(capGla.portUns, glaUns_b) annotation (Line(points={{150,44},{156,44},{
          156,20},{200,20}}, color={191,0,0}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-200,-200},{200,200}})),
    Icon(coordinateSystem(
          preserveAspectRatio=true, extent={{-200,-200},{200,200}}),
      graphics={
        Polygon(
          visible = glaSys.haveInteriorShade,
          points={{48,160},{48,60},{116,-4},{116,96},{48,160}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.CrossDiag,
          fillColor={215,215,215}),
        Line(
          points={{-74,-88},{28,-88}},
          color={0,0,0},
          smooth=Smooth.None),
        Polygon(
          points={{28,160},{28,-88},{90,-152},{90,96},{28,160}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-184,176},{-134,140}},
          lineColor={0,0,127},
          textString="uSha"),            Text(
          extent={{-60,238},{38,190}},
          lineColor={0,0,255},
          textString="%name"),
        Polygon(
          points={{38,138},{38,-84},{78,-124},{78,96},{38,138}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-102,160},{48,160}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-12,-152},{90,-152}},
          color={0,0,0},
          smooth=Smooth.None),
        Polygon(
          points={{-20,160},{-20,-88},{42,-152},{42,96},{-20,160}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-10,138},{-10,-84},{30,-124},{30,96},{-10,138}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-74,160},{-74,-88},{-12,-152},{-12,96},{-74,160}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-64,136},{-64,-86},{-24,-126},{-24,94},{-64,136}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          visible = glaSys.haveExteriorShade,
          points={{-102,160},{-102,60},{-34,-4},{-34,96},{-102,160}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.CrossDiag,
          fillColor={215,215,215}),
        Line(
          points={{-34,96},{116,96}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          visible = glaSys.haveExteriorShade,
          points={{-198,-160},{-60,-160}},
          color={160,0,0},
          smooth=Smooth.None),
        Line(
          visible = glaSys.haveExteriorShade,
          points={{84,-160},{200,-160}},
          color={160,0,0},
          smooth=Smooth.None),
        Line(
          visible = glaSys.haveExteriorShade,
          points={{56,20},{198,20}},
          color={160,0,0},
          smooth=Smooth.None),
        Line(
          visible = glaSys.haveExteriorShade,
          points={{-200,20},{-56,20}},
          color={160,0,0},
          smooth=Smooth.None), Ellipse(
          extent={{-226,234},{-164,170}},
          lineColor={255,255,0},
          fillColor={255,213,170},
          fillPattern=FillPattern.Sphere),
        Line(
          visible = glaSys.haveExteriorShade,
          points={{-198,-20},{-44,-20}},
          color={160,0,0},
          smooth=Smooth.None),
        Line(
          visible = glaSys.haveExteriorShade,
          points={{56,-20},{198,-20}},
          color={160,0,0},
          smooth=Smooth.None),
        Line(
          visible = glaSys.haveExteriorShade,
          points={{-60,-100},{-60,-160}},
          color={160,0,0},
          smooth=Smooth.None),
        Line(
          visible = glaSys.haveExteriorShade,
          points={{84,-118},{84,-160}},
          color={160,0,0},
          smooth=Smooth.None),
        Text(
          extent={{36,-162},{126,-202}},
          lineColor={0,0,127},
          textString="QAbsSha"),
        Text(
          visible = haveShade,
          extent={{-124,-164},{-34,-204}},
          lineColor={0,0,127},
          textString="QAbsUns")}),
    defaultComponentName="win",
    Documentation(info="<html>
<h4>Overview</h4>
<p>
This is a model for a window system. The equations are similar to the
equations used in the Window 5 model and described in TARCOG 2006.
The model computes
the heat balance from the exterior surface to
the room-facing surface for a window system.
The window system can have
an exterior or an interior shade, but not both, or it can
have no shade.
The convective heat transfer between the window system and the outside air
or the room is <em>not</em> computed by this model.
They can be computed using the models
<a href=\"modelica://Buildings.HeatTransfer.Windows.ExteriorHeatTransfer\">
Buildings.HeatTransfer.Windows.ExteriorHeatTransfer</a>,
<a href=\"modelica://Buildings.HeatTransfer.Windows.InteriorHeatTransferConvective\">
Buildings.HeatTransfer.Windows.InteriorHeatTransferConvective</a>
and
<a href=\"modelica://Buildings.HeatTransfer.Windows.BaseClasses.ShadeRadiation\">
Buildings.HeatTransfer.Windows.BaseClasses.ShadeRadiation</a>.
</p>

<h4>Limitations</h4>
<p>
To calculate the angular transmittance, reflectance and absorptance of a glazing system, Window 5 model first calculates the value for each wave length, then calculate the weighted value over entire wave lengths.
Current window model in Buildings library only uses the weighted value of each glass.
As a result, there are some differences in prediciton between the current Modelica window model and WINDOW 5.
The difference is small for single layer window or multi-layer window with the same glasses.
But it can be large for multi-layer window with different glasses.
</p>

<h4>Parameters</h4>
<p>
This model takes as the parameter <code>glaSys</code> a data record
from the package
<a href=\"modelica://Buildings.HeatTransfer.Data.GlazingSystems\">
Buildings.HeatTransfer.Data.GlazingSystems</a>.
This data record specifies the properties of the glasses,
the gas fills, the frame and of
the shades, if any shade is present.
Whether a shade is present or not is determined by the parameters
<code>glaSys.haveExteriorShade</code> and
<code>glaSys.haveInteriorShade</code>.
</p>
<p>
The parameter <code>linearize</code> can be used
to linearize the model equations.
</p>
<p>
If the parameter <code>steadyState</code> is set to <code>false</code>
then state variables are added at the heat ports that face
the room side.
For simulation of
<a href=\"modelica://Buildings.ThermalZones.Detailed.MixedAir\">
Buildings.ThermalZones.Detailed.MixedAir</a>, adding states
avoids large nonlinear system of equations, and generally
leads to faster simulation. Default values are used
for the states.
</p>
<h4>Ports</h4>
<p>
If a shade is present, then the input port <code>u</code> is used
to determine the
shade position. Set <code>u=0</code> to have the window in the
unshaded mode,
and set <code>u=1</code> to have the window shade completely deployed.
Any intermediate value is possible.
If no shade is present, then this port will be removed.
</p>
<p>
For the heat ports, the suffix <code>_a</code> is used for the exterior, outside-facing side
of the window, and the suffix <code>_b</code> is used for the interior, room-facing surface
of the window.
Each side has heat ports that connect to the glass, to the frame, and, optionally, to the
shade. If no shade is present, then the heat port to the shade will be removed.
</p>

<h4>Description of the Physics</h4>
<p>
The model has three main submodels that implement the relevant
heat balances:</p>
<ol>
<li>
The model <code>frame</code> computes heat conduction
through the frame.
</li>
<li>
The model <code>glaUns</code> computes the heat balance of the part of the
window that is unshaded. For example, if <code>u=0.2</code>, then this model accounts for
the 80% of the window that is not behind the shade or blind.
</li>
<li>
The model <code>glaSha</code> computes the heat balance of the part of the
window that is shaded. For example, if <code>u=0.2</code>, then this model accounts for
the 20% of the window that is behind the shade or blind.
If the parameter <code>glaSys</code> specifies that the window has no exterior
and no interior shade, then the model <code>glaSha</code> will be removed.
</li>
</ol>

<p>
The models <code>glaUns</code> and <code>glaSha</code>
compute the solar radiation that is absorbed by each
glass pane and the solar radiation that is transitted
through the window as a function of the solar incidence angle.
They then compute a heat balance that takes into account heat conduction through the glass,
heat convection through the gas layer,
and infrared radiation from the exterior and the room through the glass and gas layers.
The infrared radiative heat exchange is computed using a radiosity balance.
Heat conduction through the frame is computed using a heat flow path that is parallel to the
glazing system, i.e., there is no heat exchange between the frame
and the glazing layer.
</p>

<h4>Validation</h4>
<p>
The window model has been validated by using measurement data at LBNL's Test Cell 71T and by using
a comparative model validation with the WINDOW 6 program. These validations are described in Nouidui et al. (2012).
The window model has also been validated as part of the BESTEST validations that are implemented in
<a href=\"modelica://Buildings.ThermalZones.Detailed.Validation.BESTEST\">
Buildings.ThermalZones.Detailed.Examples.BESTEST</a>.
</p>

<h4>References</h4>
<p>
TARCOG 2006: Carli, Inc., TARCOG: Mathematical models for calculation
of thermal performance of glazing systems with or without
shading devices, Technical Report, Oct. 17, 2006.
</p>

<p>
Thierry Stephane Nouidui, Michael Wetter, and Wangda Zuo.
<a href=\"modelica://Buildings/Resources/Images/HeatTransfer/Windows/2012-simBuild-windowValidation.pdf\">
Validation of the window model of the Modelica Buildings library.</a>
<i>Proc. of the 5th SimBuild Conference</i>, Madison, WI, USA, August 2012.
</p>
</html>", revisions="<html>
<ul>
<li>
August 11, 2021, by Michael Wetter:<br/>
Added start value for <code>frame.dT</code> to avoid a warning about missing start value in OCT
when translating <code>Buildings.Examples.VAVReheat.Guideline36</code>.
</li>
<li>
April 14, 2020, by Michael Wetter:<br/>
Changed <code>homotopyInitialization</code> to a constant.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1341\">IBPSA, #1341</a>.
</li>
<li>
October 29, 2016, by Michael Wetter:<br/>
Added option to place a state at the surface.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/565\">issue 565</a>.
</li>
<li>
March 13, 2015, by Michael Wetter:<br/>
Changed model to avoid a translation error
in OpenModelica.
</li>
<li>
July 25, 2014, by Michael Wetter:<br/>
Propagated parameter <code>homotopyInitialization</code>.
</li>
<li>
May 30, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
December 19, 2011, by Wangda Zuo:<br/>
Add a warning note to remind users that the model does not count wave length dependence for calculation.
</li>
<li>
March 10 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Window;
