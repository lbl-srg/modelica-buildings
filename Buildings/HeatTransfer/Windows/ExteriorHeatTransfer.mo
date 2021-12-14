within Buildings.HeatTransfer.Windows;
model ExteriorHeatTransfer
  "Model for heat convection and radiation at the exterior surface of a window that may have a shading device"
  extends BaseClasses.PartialWindowBoundaryCondition(final thisSideHasShade=haveExteriorShade);
  parameter Modelica.Units.SI.Emissivity absIRSha_air
    "Infrared absorptivity of shade surface that faces air"
    annotation (Dialog(group="Shading"));
  parameter Modelica.Units.SI.Emissivity absIRSha_glass
    "Infrared absorptivity of shade surface that faces glass"
    annotation (Dialog(group="Shading"));

  parameter Modelica.Units.SI.TransmissionCoefficient tauIRSha_air
    "Infrared transmissivity of shade for radiation coming from the exterior or the room"
    annotation (Dialog(group="Shading"));
  parameter Modelica.Units.SI.TransmissionCoefficient tauIRSha_glass
    "Infrared transmissivity of shade for radiation coming from the glass"
    annotation (Dialog(group="Shading"));

  parameter Boolean linearizeRadiation
    "Set to true to linearize emissive power";
  parameter Real vieFacSky(final min=0, final max=1, final unit="1")
    "View factor from receiving surface to sky";

  Modelica.Blocks.Interfaces.RealInput vWin(final unit="m/s") "Wind speed"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-116,32},{-100,48}})));
  Buildings.HeatTransfer.Windows.BaseClasses.ExteriorConvectionCoefficient
    conCoeGla(                                          final A=AGla)
    "Model for the outside convective heat transfer coefficient of the glass"
    annotation (Placement(transformation(extent={{-84,40},{-64,60}})));
  Buildings.HeatTransfer.Windows.BaseClasses.ExteriorConvectionCoefficient
    conCoeFra(                                          final A=AFra)
    "Model for the outside convective heat transfer coefficient of the frame"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
 Radiosity.OutdoorRadiosity radOut(
   final A=AGla, vieFacSky=vieFacSky,
    linearize=linearizeRadiation) "Outdoor radiosity"
    annotation (Placement(transformation(extent={{-72,-72},{-52,-52}})));

  Modelica.Blocks.Interfaces.RealInput TBlaSky(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min=0) "Black body sky temperature"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-120,-50},{-100,-30}})));
  Modelica.Blocks.Interfaces.RealInput TOut(final quantity="ThermodynamicTemperature",
                                            final unit = "K", min=0)
    "Outside temperature"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
        iconTransformation(extent={{-120,-92},{-100,-72}})));
  Interfaces.RadiosityOutflow JOutUns
    "Outgoing radiosity that connects to unshaded part of glass"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));
  Interfaces.RadiosityInflow JInUns
    "Incoming radiosity that connects to unshaded part of glass"
    annotation (Placement(transformation(extent={{120,50},{100,70}})));
  Interfaces.RadiosityOutflow JOutSha if haveShade
    "Outgoing radiosity that connects to shaded part of glass"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Interfaces.RadiosityInflow JInSha if haveShade
    "Incoming radiosity that connects to shaded part of glass"
    annotation (Placement(transformation(extent={{120,-90},{100,-70}})));
  Modelica.Blocks.Interfaces.RealInput QSolAbs_flow(unit="W", quantity="Power")
    if haveShade "Solar radiation absorbed by shade"
    annotation (Placement(transformation(
        origin={0,-120},
        extent={{-20,-20},{20,20}},
        rotation=90), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-110})));

  BaseClasses.ShadeRadiation shaRad(
    final thisSideHasShade=thisSideHasShade,
    final A=AGla,
    final linearize=linearizeRadiation,
    final absIR_air=if thisSideHasShade then absIRSha_air else 0,
    final absIR_glass=if thisSideHasShade then absIRSha_glass else 0,
    final tauIR_air=if thisSideHasShade then tauIRSha_air else 1,
    final tauIR_glass=if thisSideHasShade then tauIRSha_glass else 1)
    if haveShade "Radiative heat balance of shade"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
protected
  Radiosity.RadiositySplitter radShaOut "Radiosity that strikes shading device"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  BaseClasses.ShadeConvection shaCon(final thisSideHasShade=thisSideHasShade,
      final A=AGla)
    if haveShade "Convective heat balance of shade"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
public
  Modelica.Thermal.HeatTransfer.Components.Convection conFra
    "Convective heat transfer between air and frame"
    annotation (Placement(transformation(extent={{50,-98},{30,-78}})));
  Modelica.Thermal.HeatTransfer.Components.Convection conWinUns(
    dT(start=0))
    "Convection from unshaded part of window to outside or room air"
    annotation (Placement(transformation(extent={{60,0},{40,20}})));
protected
  Modelica.Blocks.Math.Product proUns "Product for unshaded part of window"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
equation
  assert(-1E-10<vieFacSky and 1.00001 > vieFacSky,
         "View factor to sky is out of range. vieFacSky = " + String(vieFacSky)
         + "\n   Check parameters.");

  connect(vWin, conCoeGla.v)
                           annotation (Line(
      points={{-120,40},{-90,40},{-90,50},{-86,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vWin, conCoeFra.v) annotation (Line(
      points={{-120,40},{-90,40},{-90,-70},{-22,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conCoeFra.GCon, conFra.Gc) annotation (Line(
      points={{1,-70},{40,-70},{40,-78}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conCoeGla.GCon, proSha.u1) annotation (Line(
      points={{-63,50},{-56,50},{-56,36},{-52,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conCoeGla.GCon, proUns.u2) annotation (Line(
      points={{-63,50},{-40,50},{-40,74},{18,74}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radOut.JOut, radShaOut.JIn) annotation (Line(
      points={{-51,-62},{-46,-62},{-46,-24},{-41,-24}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(radOut.TBlaSky, TBlaSky) annotation (Line(
      points={{-74,-58},{-86,-58},{-86,-40},{-120,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radOut.TOut, TOut) annotation (Line(
      points={{-74,-66},{-86,-66},{-86,-80},{-120,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radShaOut.JOut_2,JOutUns)  annotation (Line(
      points={{-19,-36},{90,-36},{90,80},{110,80}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(shaRad.JOut_glass, JOutSha)
   annotation (Line(
      points={{21,-14},{80,-14},{80,-60},{110,-60}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(shaRad.JIn_glass, JInSha)
    annotation (Line(
      points={{21,-18},{70,-18},{70,-80},{110,-80}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(radShaOut.JOut_1, shaRad.JIn_air)
                                           annotation (Line(
      points={{-19,-24},{-12,-24},{-12,-14},{-1,-14}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(shaRad.u, shaSig.y)
                             annotation (Line(
      points={{-1,-2},{-60,-2},{-60,80},{-69,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(glaSha, shaCon.glass) annotation (Line(
      points={{100,-20},{30,-20},{30,30},{19.4,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(shaCon.air, air) annotation (Line(
      points={{0,30},{-20,30},{-20,10},{-80,10},{-80,5.55112e-16},{-100,
          5.55112e-16},{-100,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(shaCon.Gc, proSha.y) annotation (Line(
      points={{-1,34},{-24,34},{-24,30},{-29,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaCon.TSha, shaRad.TSha) annotation (Line(
      points={{16,19},{16,6},{26,6},{26,-26},{15,-26},{15,-21}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaRad.QRadAbs_flow, shaCon.QRadAbs_flow) annotation (Line(
      points={{5,-21},{5,-26},{-6,-26},{-6,12},{4,12},{4,19}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radShaOut.u, shaSig.y) annotation (Line(
      points={{-42,-36},{-60,-36},{-60,80},{-69,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaRad.QSolAbs_flow, QSolAbs_flow) annotation (Line(
      points={{10,-21},{10,-84},{8.88178e-16,-84},{8.88178e-16,-120}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conFra.fluid, air) annotation (Line(
      points={{30,-88},{-80,-88},{-80,0},{-100,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conWinUns.fluid, air)
                             annotation (Line(
      points={{40,10},{-80,10},{-80,0},{-100,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(glaUns,conWinUns. solid) annotation (Line(
      points={{100,20},{76,20},{76,10},{60,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(proUns.y,conWinUns. Gc) annotation (Line(
      points={{41,80},{50,80},{50,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conFra.solid, frame) annotation (Line(
      points={{50,-88},{70,-88},{70,-100},{70,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(shaSig.yCom,proUns. u1) annotation (Line(
      points={{-69,74},{-50,74},{-50,86},{18,86}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation ( Icon(graphics={
        Text(
          extent={{-94,48},{-52,32}},
          textColor={0,0,127},
          textString="vWind"), Ellipse(
          extent={{-110,110},{-90,90}},
          lineColor={255,255,0},
          fillColor={255,213,170},
          fillPattern=FillPattern.Sphere),
        Text(
          extent={{-96,-76},{-66,-88}},
          textColor={0,0,127},
          textString="TOut"),
        Text(
          extent={{-94,-34},{-54,-46}},
          textColor={0,0,127},
          textString="TBlaSky"),
        Text(
          extent={{-38,-84},{28,-102}},
          textColor={0,0,127},
          textString="QSolAbs")}),
defaultComponentName="extHeaTra",
           Documentation(info="<html>
<p>
Model for the convective heat transfer between a window shade, a window surface
and the room air.
This model is applicable for the outside-facing surface of a window system and
can be used with the model
<a href=\"modelica://Buildings.HeatTransfer.Windows.Window\">
Buildings.HeatTransfer.Windows.Window</a>.
</p>
<p>
This model adds the convective heat transfer coefficient to its base model.
</p>
</html>", revisions="<html>
<ul>
<li>
March 2, 2015, by Michael Wetter:<br/>
Refactored model to allow a temperature dependent convective heat transfer
on the room side.
This is for issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/52\">52</a>.
</li>
<li>
February 8 2012, by Michael Wetter:<br/>
Changed model to use new implementation of
<a href=\"modelica://Buildings.HeatTransfer.Radiosity.OutdoorRadiosity\">
Buildings.HeatTransfer.Radiosity.OutdoorRadiosity</a>.
This change leads to the use of the same equations for the radiative
heat transfer between window and ambient as is used for
the opaque constructions.
</li>
<li>
October 25 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ExteriorHeatTransfer;
