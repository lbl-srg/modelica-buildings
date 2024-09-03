within Buildings.ThermalZones.Detailed.Constructions;
model ConstructionWithWindow
  "Model for an opaque construction that has one window embedded in the construction"
  extends Buildings.ThermalZones.Detailed.Constructions.BaseClasses.PartialConstruction(
    final AOpa=A-AWin);

  constant Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(HideResult=true);

  parameter Modelica.Units.SI.Area AWin "Heat transfer area of window"
    annotation (Dialog(group="Glazing system"));
  parameter Real fFra(
    min=0,
    max=1) = 0.1 "Fraction of window frame divided by total window area"
    annotation (Dialog(group="Glazing system"));
  final parameter Modelica.Units.SI.Area AFra=fFra*AWin "Frame area"
    annotation (Dialog(group="Glazing system"));
  final parameter Modelica.Units.SI.Area AGla=AWin - AFra "Glass area"
    annotation (Dialog(group="Glazing system"));
  parameter Boolean linearizeRadiation = true
    "Set to true to linearize emissive power"
    annotation (Dialog(group="Glazing system"));

  parameter Boolean steadyStateWindow = false
    "Set to false to add thermal capacity at window, which generally leads to faster simulation"
    annotation (Dialog(group="Glazing system"));

 replaceable parameter HeatTransfer.Data.GlazingSystems.Generic glaSys
    "Material properties of glazing system"
    annotation (Dialog(group="Glazing system"), choicesAllMatching=true, Placement(transformation(extent={{140,80},
            {160,100}})));

  HeatTransfer.Windows.Window win(
    final glaSys=glaSys,
    final A=AWin,
    final fFra=fFra,
    final linearize = linearizeRadiation,
    final steadyState = steadyStateWindow,
    final til=til,
    final homotopyInitialization=homotopyInitialization) "Window model"
    annotation (Placement(transformation(extent={{-114,-184},{112,42}})));

  HeatTransfer.Interfaces.RadiosityOutflow JOutUns_a
    "Outgoing radiosity that connects to unshaded part of glass at exterior side"
    annotation (Placement(transformation(extent={{-300,-30},{-320,-10}}),
        iconTransformation(extent={{-300,-30},{-320,-10}})));
  HeatTransfer.Interfaces.RadiosityInflow JInUns_a
    "Incoming radiosity that connects to unshaded part of glass at exterior side"
    annotation (Placement(transformation(extent={{-320,10},{-300,30}}),
        iconTransformation(extent={{-320,10},{-300,30}})));
  HeatTransfer.Interfaces.RadiosityOutflow JOutSha_a if haveShade
    "Outgoing radiosity that connects to shaded part of glass at exterior side"
    annotation (Placement(transformation(extent={{-300,-210},{-320,-190}}),
        iconTransformation(extent={{-300,-210},{-320,-190}})));
  HeatTransfer.Interfaces.RadiosityInflow JInSha_a if haveShade
    "Incoming radiosity that connects to shaded part of glass at exterior side"
    annotation (Placement(transformation(extent={{-320,-170},{-300,-150}}),
        iconTransformation(extent={{-320,-170},{-300,-150}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a glaUns_a
    "Heat port at unshaded glass of exterior-facing surface"
                                                    annotation (Placement(transformation(extent={{-310,
            -90},{-290,-70}}), iconTransformation(extent={{-310,-90},{-290,
            -70}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a glaSha_a if haveShade
    "Heat port at shaded glass of exterior-facing surface"
    annotation (Placement(transformation(extent={{-310,-130},{-290,-110}}),
        iconTransformation(extent={{-310,-130},{-290,-110}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a fra_a
    "Heat port at frame of exterior-facing surface"
     annotation (Placement(transformation(extent={{-310,
            -270},{-290,-250}}), iconTransformation(extent={{-310,-270},{-290,
            -250}})));
  Modelica.Blocks.Interfaces.RealInput uSha(min=0, max=1)
    if haveShade
    "Control signal for the shading device, 0: unshaded; 1: fully shaded (removed if no shade is present)"
    annotation (Placement(transformation(extent={{-340,40},{-300,80}}),
        iconTransformation(extent={{-340,40},{-300,80}})));
  HeatTransfer.Interfaces.RadiosityOutflow JOutUns_b
    "Outgoing radiosity that connects to unshaded part of glass at room-side"
    annotation (Placement(transformation(extent={{300,10},{320,30}}),
        iconTransformation(extent={{300,10},{320,30}})));
  HeatTransfer.Interfaces.RadiosityInflow JInUns_b
    "Incoming radiosity that connects to unshaded part of glass at room-side"
    annotation (Placement(transformation(extent={{320,-30},{300,-10}}),
        iconTransformation(extent={{320,-30},{300,-10}})));
  HeatTransfer.Interfaces.RadiosityOutflow JOutSha_b if haveShade
    "Outgoing radiosity that connects to shaded part of glass at room-side"
    annotation (Placement(transformation(extent={{300,-170},{320,-150}}),
        iconTransformation(extent={{300,-170},{320,-150}})));
  HeatTransfer.Interfaces.RadiosityInflow JInSha_b if haveShade
    "Incoming radiosity that connects to shaded part of glass at room-side"
    annotation (Placement(transformation(extent={{320,-210},{300,-190}}),
        iconTransformation(extent={{320,-210},{300,-190}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b glaUns_b
    "Heat port at unshaded glass of room-facing surface"
    annotation (Placement(transformation(extent={{290,-90},
            {310,-70}}), iconTransformation(extent={{290,-90},{310,-70}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b glaSha_b if haveShade
    "Heat port at shaded glass of room-facing surface"
  annotation (Placement(transformation(extent={{290,-130},{310,-110}}),
        iconTransformation(extent={{290,-130},{310,-110}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b fra_b
    "Heat port at frame of room-facing surface"
    annotation (Placement(transformation(extent={{292,-270},{312,-250}}), iconTransformation(extent={{292,-270},{312,-250}})));

  Modelica.Blocks.Interfaces.RealInput QAbsUns_flow[size(glaSys.glass, 1)](
    each unit="W",
    each quantity="Power") "Solar radiation absorbed by unshaded part of glass"
                                                       annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-40,-320}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-80,-320})));
  Modelica.Blocks.Interfaces.RealInput QAbsSha_flow[size(glaSys.glass, 1)](
    each unit="W",
    each quantity="Power") if haveShade
    "Solar radiation absorbed by shaded part of glass"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={100,-320}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={80,-320})));

protected
  final parameter Boolean haveShade = glaSys.haveExteriorShade or glaSys.haveInteriorShade
    "Parameter, equal to true if the window has a shade"
    annotation(Evaluate=true);

initial equation
  assert(homotopyInitialization, "In " + getInstanceName() +
    ": The constant homotopyInitialization has been modified from its default value. This constant will be removed in future releases.",
    level = AssertionLevel.warning);

equation
  connect(win.uSha, uSha) annotation (Line(
      points={{-125.3,19.4},{-178.75,19.4},{-178.75,60},{-320,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(JInUns_a, win.JInUns_a) annotation (Line(
      points={{-310,20},{-200,20},{-200,-3.2},{-119.65,-3.2}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(JOutUns_a, win.JOutUns_a) annotation (Line(
      points={{-310,-20},{-220,-20},{-220,-25.8},{-119.65,-25.8}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(win.glaUns_a, glaUns_a) annotation (Line(
      points={{-114,-59.7},{-200,-59.7},{-200,-80},{-300,-80}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(win.glaSha_a, glaSha_a) annotation (Line(
      points={{-114,-82.3},{-180,-82.3},{-180,-120},{-300,-120}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(win.JInSha_a, JInSha_a) annotation (Line(
      points={{-119.65,-104.9},{-162,-104.9},{-162,-160},{-310,-160}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(win.JOutSha_a, JOutSha_a) annotation (Line(
      points={{-119.65,-127.5},{-139.375,-127.5},{-139.375,-200},{-310,-200}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(win.fra_a, fra_a) annotation (Line(
      points={{-114,-161.4},{-128,-161.4},{-128,-260},{-300,-260}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(win.JOutUns_b, JOutUns_b) annotation (Line(
      points={{117.65,-3.2},{225.375,-3.2},{225.375,20},{310,20}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(win.JInUns_b, JInUns_b) annotation (Line(
      points={{117.65,-25.8},{233.375,-25.8},{233.375,-20},{310,-20}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(win.glaUns_b, glaUns_b) annotation (Line(
      points={{112,-59.7},{239,-59.7},{239,-80},{300,-80}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(win.glaSha_b, glaSha_b) annotation (Line(
      points={{112,-82.3},{220,-82.3},{220,-120},{300,-120}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(win.JOutSha_b, JOutSha_b) annotation (Line(
      points={{117.65,-104.9},{201.375,-104.9},{201.375,-160},{310,-160}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(win.JInSha_b, JInSha_b) annotation (Line(
      points={{117.65,-127.5},{178.375,-127.5},{178.375,-200},{310,-200}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(win.fra_b, fra_b) annotation (Line(
      points={{113.13,-161.4},{159.675,-161.4},{159.675,-260},{302,-260}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(opa.port_a, opa_a)                 annotation (Line(
      points={{-52,200},{-300,200}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(opa.port_b, opa_b)                 annotation (Line(
      points={{52,200},{302,200}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(win.QAbsUns_flow, QAbsUns_flow) annotation (Line(
      points={{-46.2,-195.3},{-46.2,-280},{-40,-280},{-40,-320}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(win.QAbsSha_flow, QAbsSha_flow) annotation (Line(
      points={{44.2,-195.3},{44.2,-280},{100,-280},{100,-320}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-300,
            -300},{300,300}})),
                          Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-300,-300},{300,300}}), graphics={
        Rectangle(
          extent={{-290,202},{298,198}},
          lineColor={0,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          visible = glaSys.haveInteriorShade,
          points={{48,60},{48,-40},{116,-104},{116,-4},{48,60}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.CrossDiag,
          fillColor={215,215,215}),
        Line(
          points={{-74,-188},{28,-188}},
          color={0,0,0},
          smooth=Smooth.None),
        Polygon(
          points={{28,60},{28,-188},{90,-252},{90,-4},{28,60}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{38,38},{38,-184},{78,-224},{78,-4},{38,38}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-102,60},{48,60}},
          color={0,0,0},
          smooth=Smooth.None),
        Polygon(
          points={{-20,60},{-20,-188},{42,-252},{42,-4},{-20,60}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-10,38},{-10,-184},{30,-224},{30,-4},{-10,38}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-74,60},{-74,-188},{-12,-252},{-12,-4},{-74,60}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-64,36},{-64,-186},{-24,-226},{-24,-6},{-64,36}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          visible = glaSys.haveExteriorShade,
          points={{-102,60},{-102,-40},{-34,-104},{-34,-4},{-102,60}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.CrossDiag,
          fillColor={215,215,215}),
        Line(
          points={{-34,-4},{116,-4}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          visible = glaSys.haveExteriorShade,
          points={{56,-80},{290,-80}},
          color={160,0,0},
          smooth=Smooth.None),
        Line(
          visible = glaSys.haveExteriorShade,
          points={{-290,-80},{-56,-80}},
          color={160,0,0},
          smooth=Smooth.None),
        Line(
          visible = glaSys.haveExteriorShade,
          points={{-294,-120},{-44,-120}},
          color={160,0,0},
          smooth=Smooth.None),
        Line(
          visible = glaSys.haveExteriorShade,
          points={{60,-120},{296,-120}},
          color={160,0,0},
          smooth=Smooth.None),
        Line(
          visible = glaSys.haveExteriorShade,
          points={{-60,-200},{-60,-260}},
          color={160,0,0},
          smooth=Smooth.None),
        Line(
          visible = glaSys.haveExteriorShade,
          points={{84,-218},{84,-260}},
          color={160,0,0},
          smooth=Smooth.None),
        Line(
          visible = glaSys.haveExteriorShade,
          points={{84,-260},{302,-260}},
          color={160,0,0},
          smooth=Smooth.None),
        Line(
          visible = glaSys.haveExteriorShade,
          points={{-292,-260},{-60,-260}},
          color={160,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{-62,270},{-44,156}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{42,270},{60,156}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{8,276},{68,76}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-48,276},{8,76}},
          lineColor={0,0,0},
          fillColor={183,183,121},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-72,276},{-48,76}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-48,276},{-62,290},{-10,290},{8,276},{-48,276}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={183,183,121},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-72,276},{-80,290},{-62,290},{-48,276},{-72,276}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{8,276},{-10,290},{48,290},{68,276},{8,276}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-80,290},{-80,98},{-72,76},{-72,276},{-80,290}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
                               Ellipse(
          extent={{-222,68},{-160,4}},
          lineColor={255,255,0},
          fillColor={255,213,170},
          fillPattern=FillPattern.Sphere)}),
defaultComponentName="conWin",
Documentation(revisions="<html>
<ul>
<li>
April 14, 2020, by Michael Wetter:<br/>
Changed <code>homotopyInitialization</code> to a constant.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1341\">IBPSA, #1341</a>.
</li>
<li>
October 29, 2016, by Michael Wetter:<br/>
Added optional capacity at the room-facing surface
to reduce the dimension of the nonlinear system of equations,
which generally decreases computing time.<br/>
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
December 6 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model is used to compute heat transfer through constructions with windows inside the
room model.
</p>
<p>
The model consists of the following two main submodels:
</p>
<ul>
<li>
The instance <code>opa</code>, which uses the model
<a href=\"modelica://Buildings.HeatTransfer.Conduction.MultiLayer\">
Buildings.HeatTransfer.Conduction.MultiLayer</a> to compute
the heat transfer through the opaque part of the construction.
This model uses the record <code>layers</code> to access the material properties
of the opaque construction.
</li>
<li>
The instance <code>win</code>, which uses the model
<a href=\"modelica://Buildings.HeatTransfer.Windows.Window\">
Buildings.HeatTransfer.Windows.Window</a> to compute
the heat transfer through the glazing system.
This model uses the record <code>glaSys</code> to access the material properties
of the glazing system.
</li>
</ul>
<p>
The parameter <code>A</code> is the area of the opaque construction plus the window.
The parameter <code>AWin</code> is the area of the glazing system, including the frame.
The area of the opaque construction is assigned internally as <code>AOpa=A-AWin</code>.
</p>
</html>"));
end ConstructionWithWindow;
