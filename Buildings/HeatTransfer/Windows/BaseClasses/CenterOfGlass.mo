within Buildings.HeatTransfer.Windows.BaseClasses;
model CenterOfGlass "Model for center of glass of a window construction"
  extends Buildings.HeatTransfer.Radiosity.BaseClasses.RadiosityTwoSurfaces;

  constant Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(HideResult=true);

  parameter Modelica.Units.SI.Angle til(displayUnit="deg")
    "Surface tilt (only 90 degrees=vertical is implemented)";

  parameter Buildings.HeatTransfer.Data.GlazingSystems.Generic glaSys
    "Glazing system"
    annotation (HideResult=true, choicesAllMatching=true, Placement(transformation(extent={{60,60},
            {80,80}})));

  parameter Boolean linearize=false "Set to true to linearize emissive power"
    annotation(Evaluate=true);

  Modelica.Blocks.Interfaces.RealInput u
    "Input connector, used to scale the surface area to take into account an operable shading device"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-120,70},{-100,90}})));

  Buildings.HeatTransfer.Windows.BaseClasses.GlassLayer[nGlaLay] glass(
    each final A=A,
    final x=glaSys.glass.x,
    final k=glaSys.glass.k,
    final absIR_a=glaSys.glass.absIR_a,
    final absIR_b=glaSys.glass.absIR_b,
    final tauIR=glaSys.glass.tauIR,
    each final linearize=linearize,
    each final homotopyInitialization=homotopyInitialization)
    "Window glass layer"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.HeatTransfer.Windows.BaseClasses.GasConvection gas[nGlaLay-1](
    each final A=A,
    final gas=glaSys.gas,
    each final til=til,
    each linearize=linearize,
    each final homotopyInitialization=homotopyInitialization) if have_GasLay
    "Window gas layer"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));

  // Note that the interior shade is flipped horizontally. Hence, surfaces a and b are exchanged,
  // i.e., surface a faces the room, while surface b faces the window

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a glass_a
    "Heat port connected to the outside facing surface of the glass"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b glass_b
    "Heat port connected to the room-facing surface of the glass"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  Modelica.Blocks.Interfaces.RealInput QAbs_flow[nGlaLay](
    each unit="W",
    each quantity = "Power") "Solar radiation absorbed by glass"
                                        annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-110})));
protected
  final parameter Integer nGlaLay = size(glaSys.glass, 1)
    "Number of glass layers";
  final parameter Boolean have_GasLay = nGlaLay > 1
    "True if it has gas layer";

initial equation
  assert(homotopyInitialization, "In " + getInstanceName() +
    ": The constant homotopyInitialization has been modified from its default value. This constant will be removed in future releases.",
    level = AssertionLevel.warning);

equation
  for i in 1:nGlaLay-1 loop
    connect(glass[i].port_b, gas[i].port_a)                        annotation (Line(
      points={{5.55112e-16,6.10623e-16},{0,0},{10,0},{10,20},{20,20}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(gas[i].port_b, glass[i+1].port_a)                         annotation (Line(
      points={{40,20},{52,20},{52,36},{-40,36},{-40,0},{-20,0},{-20,6.10623e-16}},
      color={191,0,0},
      smooth=Smooth.None));

    connect(glass[i].JOut_b, glass[i+1].JIn_a)
    annotation (Line(
      points={{1,4},{8,4},{8,-24},{-30,-24},{-30,4},{-21,4}},
      color={0,127,0},
      smooth=Smooth.None));
    connect(glass[i].JIn_b, glass[i+1].JOut_a)
    annotation (Line(
      points={{1,-4},{6,-4},{6,-20},{-28,-20},{-28,-4},{-21,-4}},
      color={0,0,0},
      smooth=Smooth.None));

    connect(u, gas[i].u)   annotation (Line(
      points={{-120,80},{-86,80},{-86,44},{-8,44},{-8,28},{19,28}},
      color={0,0,127},
      smooth=Smooth.None));

  end for;

  for i in 1:nGlaLay loop
    connect(u, glass[i].u)  annotation (Line(
      points={{-120,80},{-86,80},{-86,44},{-48,44},{-48,8},{-21,8}},
      color={0,0,127},
      smooth=Smooth.None));
  end for;

  connect(glass_b, glass[nGlaLay].port_b) annotation (Line(
      points={{100,5.55112e-16},{100,5.55112e-16},{0,0}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(glass_a, glass[1].port_a) annotation (Line(
      points={{-100,5.55112e-16},{-71,5.55112e-16},{-71,6.10623e-16},{-20,
          6.10623e-16}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(JIn_a, glass[1].JIn_a) annotation (Line(
      points={{-110,40},{-60,40},{-60,4},{-21,4}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(glass[1].JOut_a, JOut_a) annotation (Line(
      points={{-21,-4},{-60,-4},{-60,-40},{-110,-40}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(glass[nGlaLay].JOut_b, JOut_b) annotation (Line(
      points={{1,4},{80,4},{80,40},{110,40}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(JIn_b, glass[nGlaLay].JIn_b) annotation (Line(
      points={{110,-40},{80,-40},{80,-4},{1,-4}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(glass.QAbs_flow, QAbs_flow) annotation (Line(
      points={{-10,-11},{-10,-60},{1.11022e-15,-60},{1.11022e-15,-120}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}),       graphics={Text(
          extent={{-82,100},{-32,86}},
          textColor={0,0,255},
          textString="outside"),
                               Ellipse(
          extent={{-108,110},{-88,90}},
          lineColor={255,255,0},
          fillColor={255,213,170},
          fillPattern=FillPattern.Sphere),
                                         Text(
          extent={{44,98},{94,84}},
          textColor={0,0,255},
          textString="room-side")}),      Icon(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-90,2},{92,-4}},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-56,50},{-44,-52}},
          lineColor={0,0,0},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-8,50},{4,-52}},
          lineColor={0,0,0},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{42,50},{54,-52}},
          lineColor={0,0,0},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),       Text(
          extent={{-90,86},{-78,74}},
          textColor={0,0,127},
          textString="u")}),
    Documentation(info="<html>
This is a model for the heat transfer through the center of the glass.
The properties of the glazing system is defined by the parameter
<code>glaSys</code>.
The model contains these main component models:
<ul>
<li>
an array of models <code>glass</code> for the heat conduction and the
infrared radiative heat balance of the glass layers.
There can be an arbitrary number of glass layers, which are all modeled using
instances of
<a href=\"modelica://Buildings.HeatTransfer.Windows.BaseClasses.GlassLayer\">
Buildings.HeatTransfer.Windows.BaseClasses.GlassLayer</a>.
</li>
<li>
an array of models <code>gas</code> for the gas layers. There is one model of a
gas layer between each window panes. The gas layers are modeled using instances of
<a href=\"modelica://Buildings.HeatTransfer.Windows.BaseClasses.GasConvection\">
Buildings.HeatTransfer.Windows.BaseClasses.GasConvection</a>.
</li>
</ul>
Note that this model does <em>not</em> compute heat conduction through the frame and
it does <em>not</em> model the convective heat transfer at the exterior and interior
surface. These models are implemented in
<a href=\"modelica://Buildings.HeatTransfer.Windows.Window\">
Buildings.HeatTransfer.Windows.Window</a>,
<a href=\"modelica://Buildings.HeatTransfer.Windows.ExteriorHeatTransfer\">
Buildings.HeatTransfer.Windows.ExteriorHeatTransfer</a>, and
<a href=\"modelica://Buildings.HeatTransfer.Windows.InteriorHeatTransferConvective\">
Buildings.HeatTransfer.Windows.InteriorHeatTransferConvective</a>.
</html>",
revisions="<html>
<ul>
<li>
May 24, 2022, by Jianjun Hu:<br/>
Changed the gas layer to be conditional.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3026\">#3026</a>.
</li>
<li>
April 14, 2020, by Michael Wetter:<br/>
Changed <code>homotopyInitialization</code> to a constant.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1341\">IBPSA, #1341</a>.
</li>
<li>
March 13, 2015, by Michael Wetter:<br/>
Changed assignment of <code>nLay</code> to avoid a translation error
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
July 9 2012, by Wangda Zuo:<br/>
Fixed a bug in the parameter assignment of the instance <code>glass</code>.
Previously, the infrared emissivity of surface a was assigned to the surface b.
</li>
<li>
Sep. 3 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end CenterOfGlass;
