within Buildings.HeatTransfer.Windows;
model InteriorHeatTransferConvective
  "Model for heat convection at the interior surface of a window that may have a shading device"
  extends BaseClasses.PartialWindowBoundaryCondition(final thisSideHasShade=haveInteriorShade);

  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hFixed=4
    "Constant convection coefficient";
  parameter Types.InteriorConvection conMod=Buildings.HeatTransfer.Types.InteriorConvection.Fixed
    "Convective heat transfer model";
  parameter Modelica.Units.SI.Angle til "Surface tilt";

 Modelica.Blocks.Interfaces.RealInput QRadAbs_flow(final unit="W")
    if haveShade
    "Total net radiation that is absorbed by the shade (positive if absorbed)"
     annotation (Placement(transformation(extent={{10,-10},{-10,10}},
                       rotation=270,
        origin={-60,-110}),         iconTransformation(extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-60,-110})));
  Modelica.Blocks.Interfaces.RealOutput TSha(
   final unit="K",
   final quantity="ThermodynamicTemperature")
   if haveShade "Shade temperature"
                       annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-110})));

  Buildings.HeatTransfer.Windows.BaseClasses.InteriorConvectionCoefficient
    conCoeGla(final A=AGla)
    "Model for the inside convective heat transfer coefficient of the glass"
    annotation (Placement(transformation(extent={{-92,26},{-72,46}})));

  BaseClasses.ShadeConvection conSha(
    final A=AGla,
    final thisSideHasShade=thisSideHasShade)
    if haveShade "Convection model for shade"
    annotation (Placement(transformation(extent={{-8,-20},{12,0}})));
  BaseClasses.InteriorConvection conFra(
    final A=AFra,
    final til=til,
    final conMod=conMod,
    hFixed=hFixed) "Convective heat transfer between air and frame"
    annotation (Placement(transformation(extent={{50,-98},{30,-78}})));
  BaseClasses.InteriorConvection conWinUns(
    final A=AGla,
    final til=til,
    final conMod=conMod,
    hFixed=hFixed)
    "Convection from unshaded part of window to outside or room air"
    annotation (Placement(transformation(extent={{60,0},{40,20}})));
equation
  connect(conCoeGla.GCon, proSha.u1) annotation (Line(
      points={{-71,36},{-52,36}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(conSha.glass, glaSha) annotation (Line(
      points={{11.4,-10},{54,-10},{54,-20},{100,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(proSha.y, conSha.Gc) annotation (Line(
      points={{-29,30},{-20,30},{-20,-6},{-9,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conSha.TSha, TSha) annotation (Line(
      points={{8,-21},{8,-96},{0,-96},{0,-110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QRadAbs_flow, conSha.QRadAbs_flow) annotation (Line(
      points={{-60,-110},{-60,-40},{-4,-40},{-4,-21}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(conFra.fluid, air) annotation (Line(
      points={{30,-88},{-80,-88},{-80,5.55112e-16},{-100,5.55112e-16},{-100,0}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(air, conSha.air) annotation (Line(
      points={{-100,0},{-80,0},{-80,-10},{-8,-10}},
      color={191,0,0},
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
  connect(conFra.solid, frame) annotation (Line(
      points={{50,-88},{70,-88},{70,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(shaSig.yCom, conWinUns.u) annotation (Line(
      points={{-69,74},{70,74},{70,18},{61,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaSig.yCom, conFra.u) annotation (Line(
      points={{-69,74},{70,74},{70,-80},{51,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (defaultComponentName="intConSha",
Documentation(info="<html>
<p>
Model for the convective heat transfer between a window shade, a window surface
and the room air.
This model is applicable for the room-facing surface of a window system and
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
July 11, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
         graphics={
        Text(
          extent={{-94,-82},{-28,-100}},
          textColor={0,0,127},
          textString="QRadAbs"),
        Text(
          extent={{-28,-84},{34,-100}},
          textColor={0,0,127},
          textString="TSha")}));
end InteriorHeatTransferConvective;
