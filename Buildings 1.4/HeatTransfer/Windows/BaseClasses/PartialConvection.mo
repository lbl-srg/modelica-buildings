within Buildings.HeatTransfer.Windows.BaseClasses;
partial model PartialConvection
  "Partial model for heat convection between a possibly shaded window that can be outside or inside the room"
  parameter Modelica.SIunits.Area A "Heat transfer area of frame and window";
  parameter Real fFra "Fraction of window frame divided by total window area";
  final parameter Modelica.SIunits.Area AFra = fFra * A "Frame area";
  final parameter Modelica.SIunits.Area AGla = A-AFra "Glass area";

  parameter Modelica.SIunits.Emissivity absIRSha_air
    "Infrared absorptivity of shade surface that faces air"
        annotation (Dialog(group="Shading"));
  parameter Modelica.SIunits.Emissivity absIRSha_glass
    "Infrared absorptivity of shade surface that faces glass"
    annotation (Dialog(group="Shading"));

  parameter Modelica.SIunits.TransmissionCoefficient tauIRSha_air
    "Infrared transmissivity of shade for radiation coming from the exterior or the room"
    annotation (Dialog(group="Shading"));
  parameter Modelica.SIunits.TransmissionCoefficient tauIRSha_glass
    "Infrared transmissivity of shade for radiation coming from the glass"
    annotation (Dialog(group="Shading"));

  parameter Boolean linearizeRadiation
    "Set to true to linearize emissive power";

  parameter Boolean haveExteriorShade
    "Set to true if window has exterior shade (at surface a)"
    annotation (Dialog(group="Shading"));
  parameter Boolean haveInteriorShade
    "Set to true if window has interior shade (at surface b)"
    annotation (Dialog(group="Shading"));

  final parameter Boolean windowHasShade = haveExteriorShade or haveInteriorShade
    "Set to true if window system has a shade"
    annotation (Dialog(group="Shading"), Evaluate=true);
  parameter Boolean thisSideHasShade
    "Set to true if this side of the model has a shade"
    annotation (Dialog(group="Shading"), Evaluate=true);

  Modelica.Blocks.Interfaces.RealInput uSha if windowHasShade
    "Input connector, used to scale the surface area to take into account an operable shading device, 0: unshaded; 1: fully shaded"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-116,72},{-100,88}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a air
    "Port that connects to the air (room or outside)"        annotation (Placement(transformation(extent={{-110,-10},
            {-90,10}}, rotation=0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b glaUns
    "Heat port that connects to unshaded part of glass"
      annotation (Placement(transformation(extent={{90,10},{110,30}},  rotation=0)));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b glaSha if windowHasShade
    "Heat port that connects to shaded part of glass"
    annotation (Placement(transformation(extent={{90,-30},{110,-10}},      rotation=0)));

  Modelica.Thermal.HeatTransfer.Components.Convection conWinUns
    "Convection from unshaded part of window to outside or room air"
    annotation (Placement(transformation(extent={{60,0},{40,20}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a frame
    "Heat port at window frame"  annotation (Placement(transformation(extent={{60,-110},
            {80,-90}}, rotation=0)));
  Modelica.Thermal.HeatTransfer.Components.Convection conFra
    "Convective heat transfer between air and frame"
    annotation (Placement(transformation(extent={{50,-98},{30,-78}})));

protected
  Modelica.Blocks.Math.Product proUns "Product for unshaded part of window"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));

  Modelica.Blocks.Math.Product proSha if windowHasShade
    "Product for shaded part of window"
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));

public
  ShadingSignal shaSig(haveShade=windowHasShade)
    "Conversion for shading signal"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
  Shade shade(
    final thisSideHasShade = thisSideHasShade,
    final A=AGla,
    final linearize=linearizeRadiation,
    final absIR_air=if thisSideHasShade then absIRSha_air else 0,
    final absIR_glass=if thisSideHasShade then absIRSha_glass else 0,
    final tauIR_air=if thisSideHasShade then tauIRSha_air else 1,
    final tauIR_glass=if thisSideHasShade then tauIRSha_glass else 1) if
       windowHasShade "Heat balance of shade"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Interfaces.RadiosityOutflow JOutUns
    "Outgoing radiosity that connects to unshaded part of glass"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));
  Interfaces.RadiosityInflow JInUns
    "Incoming radiosity that connects to unshaded part of glass"
    annotation (Placement(transformation(extent={{120,50},{100,70}})));
public
  Interfaces.RadiosityOutflow JOutSha if windowHasShade
    "Outgoing radiosity that connects to shaded part of glass"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Interfaces.RadiosityInflow JInSha if windowHasShade
    "Incoming radiosity that connects to shaded part of glass"
    annotation (Placement(transformation(extent={{120,-90},{100,-70}})));
protected
  Radiosity.RadiositySplitter radShaOut "Radiosity that strikes shading device"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));

public
  Modelica.Blocks.Interfaces.RealInput QAbs_flow(unit="W", quantity="Power") if windowHasShade
    "Solar radiation absorbed by shade"
    annotation (Placement(transformation(
        origin={0,-120},
        extent={{-20,-20},{20,20}},
        rotation=90), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-110})));
initial equation
  assert(( thisSideHasShade and windowHasShade)  or (not thisSideHasShade),
    "Parameters \"thisSideHasShade\" and \"windowHasShade\" are not consistent. Check parameters");

equation
  connect(conWinUns.fluid, air)
                             annotation (Line(
      points={{40,10},{-80,10},{-80,5.55112e-16},{-100,5.55112e-16}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(conFra.fluid, air) annotation (Line(
      points={{30,-88},{-80,-88},{-80,5.55112e-16},{-100,5.55112e-16}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(conFra.solid, frame) annotation (Line(
      points={{50,-88},{70,-88},{70,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(glaUns, conWinUns.solid) annotation (Line(
      points={{100,20},{76,20},{76,10},{60,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(proUns.y, conWinUns.Gc) annotation (Line(
      points={{41,80},{50,80},{50,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(uSha, shaSig.u)
                       annotation (Line(
      points={{-120,80},{-92,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(proSha.u2, shaSig.y) annotation (Line(
      points={{-52,24},{-60,24},{-60,80},{-69,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaSig.yCom, proUns.u1) annotation (Line(
      points={{-69,74},{-50,74},{-50,86},{18,86}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shade.Gc, proSha.y) annotation (Line(
      points={{-1,-16},{-20,-16},{-20,30},{-29,30}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(shade.air, air) annotation (Line(
      points={{-5.55112e-16,-20},{-70,-20},{-70,5.55112e-16},{-100,5.55112e-16}},
      color={191,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(shade.glass, glaSha) annotation (Line(
      points={{19.4,-20},{100,-20}},
      color={191,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(radShaOut.JOut_2,JOutUns)  annotation (Line(
      points={{-19,-46},{90,-46},{90,80},{110,80}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(shade.JOut_glass,JOutSha)  annotation (Line(
      points={{21,-24},{80,-24},{80,-60},{110,-60}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(shade.JIn_glass,JInSha)  annotation (Line(
      points={{21,-28},{70,-28},{70,-80},{110,-80}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(shaSig.y,radShaOut. u) annotation (Line(
      points={{-69,80},{-60,80},{-60,-46},{-42,-46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radShaOut.JOut_1, shade.JIn_air) annotation (Line(
      points={{-19,-34},{-12,-34},{-12,-24},{-1,-24}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(shade.u, shaSig.y) annotation (Line(
      points={{-1,-12},{-60,-12},{-60,80},{-69,80}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(shade.QAbs_flow, QAbs_flow) annotation (Line(
      points={{10,-31},{10,-94},{0,-94},{0,-120},{1.11022e-15,-120}},
      color={0,0,127},
      smooth=Smooth.None));
    annotation (Dialog(group="Shading"),
    Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-90,2},{84,-2}},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-94,88},{-86,74}},
          lineColor={0,0,127},
          textString="u"),              Text(
        extent={{-160,144},{140,104}},
        textString="%name",
        lineColor={0,0,255}),
        Polygon(
          points={{-20,48},{-20,40},{20,52},{20,60},{-20,48}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-20,8},{-20,0},{20,12},{20,20},{-20,8}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-20,28},{-20,20},{20,32},{20,40},{-20,28}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-20,-32},{-20,-40},{20,-28},{20,-20},{-20,-32}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-20,-12},{-20,-20},{20,-8},{20,0},{-20,-12}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-20,-72},{-20,-80},{20,-68},{20,-60},{-20,-72}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-20,-52},{-20,-60},{20,-48},{20,-40},{-20,-52}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,94},{2,-86}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{56,72},{84,-74}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.Dash),
        Rectangle(
          extent={{56,-74},{84,-90}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,86},{84,72}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-72,-82},{-6,-100}},
          lineColor={0,0,127},
          textString="QAbsSha")}),
    Documentation(info="<html>
<p>
Partial model for heat convection of a window surface with or without shade,
that is outside or inside the room. 
</p>
<p>
Convective heat transfer is modeled between the heat port <code>air</code> 
and the shade, if present, the glass and the frame.
If the parameter <code>haveShade</code> is set to <code>true</code>, then a shade 
is present and the input port <code>QAbs_flow</code> needs to be connected to 
a model that computes the solar radiation that is absorbed by the shade.
If <code>haveShade=true</code>, then the model <code>shade</code> and the 
connectors <code>QAbs_flow</code>, <code>glaSha</code>, 
<code>JInSha</code> and <code>JOutSha</code> are removed.
This allows using the model as a base class for windows with inside shade, outside shade, or no shade.</p>
</html>", revisions="<html>
<ul>
<li>
August 25 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end PartialConvection;
