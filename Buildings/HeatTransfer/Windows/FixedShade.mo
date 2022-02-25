within Buildings.HeatTransfer.Windows;
model FixedShade "Model for exterior shade due to overhang and/or side fin"
  extends HeatTransfer.Windows.BaseClasses.ShadeInterface_weatherBus;
  parameter Buildings.ThermalZones.Detailed.BaseClasses.ParameterConstructionWithWindow conPar
    "Construction parameters";

  parameter Modelica.Units.SI.Angle azi(displayUnit="deg")
    "Surface azimuth; azi= -90 degree East; azi= 0 South";

  Modelica.Blocks.Routing.Multiplex4 mulFraSun(
    n1=1,
    n2=1,
    n3=1,
    n4=1) "Multiplex for fraction of shaded area"
    annotation (Placement(transformation(extent={{32,0},{52,20}})));

  Modelica.Blocks.Math.Add sumFraSun
    "Addition of sun exposed window area fractions"
    annotation (Placement(transformation(extent={{-40,-40},{-28,-28}})));

  Modelica.Blocks.Math.Add resFraSun(k2=1.0, k1=-1.0)
    "Calculates resultant sun exposed window area fraction"
    annotation (Placement(transformation(extent={{-40,-6},{-28,6}})));
  Modelica.Blocks.Sources.Constant overlap(k=1.0)
    "Overlap of sun exposed window area fraction"
    annotation (Placement(transformation(extent={{-40,20},{-28,32}})));
  Modelica.Blocks.Sources.Constant noSunCond(k=small)
    "Condition when the sun is not in front of window"
    annotation (Placement(transformation(extent={{-20,-40},{-8,-28}})));

protected
  constant Real small = 0.001
    "Small number, used to avoid that sun-exposed fraction of window is negative";

  final parameter Boolean haveOverhang = conPar.ove.haveOverhang
    "Flag for overhang" annotation (Evaluate=true);

  final parameter Boolean haveSideFins = conPar.sidFin.haveSideFins
    "Flag for sidefins" annotation (Evaluate=true);
  final parameter Boolean haveOverhangAndSideFins= (haveOverhang
       and haveSideFins) "Flag for overhang and sidefins";

  final parameter Integer idx = if haveOverhangAndSideFins then 2 elseif haveOverhang then 1 elseif haveSideFins then 3 else 4
    "Integer used to pick the appropriate output signal";

  HeatTransfer.Windows.BaseClasses.Overhang ove(
    final azi=conPar.azi,
    final hWin=conPar.hWin,
    final wWin=conPar.wWin,
    final dep=conPar.ove.dep,
    final gap=conPar.ove.gap,
    final wR=conPar.ove.wR,
    final wL=conPar.ove.wL) "Model for overhang"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

  HeatTransfer.Windows.BaseClasses.SideFins sidFin(
    final hWin=conPar.hWin,
    final wWin=conPar.wWin,
    final h=conPar.sidFin.h,
    final dep=conPar.sidFin.dep,
    final gap=conPar.sidFin.gap) "Model for side fins"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

  BoundaryConditions.SolarGeometry.BaseClasses.WallSolarAzimuth walSolAzi
    "Angle measured in horizontal plane between projection of sun's rays and normal to vertical surface"
     annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Modelica.Blocks.Math.Product mulHDir
    "Multiplication to obtain direct solar irradiation on shaded window"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));

  Modelica.Blocks.Routing.Extractor extFraSun(final allowOutOfRange=false, final
      nin=4,
    index(start=idx, fixed=true))
    "Extractor to pick the appropriate output signal"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Modelica.Blocks.Sources.IntegerConstant idxSou(final k=idx)
    "Source term to pick output signal"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  Modelica.Blocks.Sources.Constant const(k=1)
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));

  Utilities.Math.SmoothMax smoMax(deltaX=small/2)
    "Limiter to avoid that the fraction of sun-exposed window is below zero"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(weaBus.solAlt, walSolAzi.alt) annotation (Line(
      points={{-100,5.55112e-16},{-92,5.55112e-16},{-92,-76},{-82,-76},{-82,
          -75.2}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));

  connect(incAng, walSolAzi.incAng) annotation (Line(
      points={{-120,-60},{-96,-60},{-96,-84.8},{-82,-84.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(walSolAzi.verAzi, ove.verAzi) annotation (Line(
      points={{-59,-80},{-54,-80},{-54,54},{-42,54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(walSolAzi.verAzi, sidFin.verAzi) annotation (Line(
      points={{-59,-80},{-54,-80},{-54,-56},{-42,-56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaBus.solAlt, sidFin.alt) annotation (Line(
      points={{-100,5.55112e-16},{-92,5.55112e-16},{-92,-64},{-42,-64}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(mulHDir.y, HDirTil) annotation (Line(
      points={{81,60},{110,60}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(mulHDir.u1, HDirTilUns) annotation (Line(
      points={{58,66},{40,66},{40,80},{-60,80},{-60,60},{-120,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaBus, ove.weaBus) annotation (Line(
      points={{-100,5.55112e-16},{-92,5.55112e-16},{-92,50},{-40.2,50}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(extFraSun.y, fraSun) annotation (Line(
      points={{81,10},{90,10},{90,5.55112e-16},{110,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(extFraSun.y, mulHDir.u2) annotation (Line(
      points={{81,10},{90,10},{90,40},{40,40},{40,54},{58,54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mulFraSun.y, extFraSun.u)    annotation (Line(
      points={{53,10},{58,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ove.fraSun, mulFraSun.u1[1])    annotation (Line(
      points={{-19,50},{24,50},{24,19},{30,19}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sidFin.fraSun, mulFraSun.u3[1])    annotation (Line(
      points={{-19,-60},{22,-60},{22,7},{30,7}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, mulFraSun.u4[1])    annotation (Line(
      points={{21,-80},{26,-80},{26,1},{30,1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaBus.solAlt, ove.alt) annotation (Line(
      points={{-100,5.55112e-16},{-92,5.55112e-16},{-92,46},{-42,46}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(ove.fraSun, sumFraSun.u1)
                              annotation (Line(
      points={{-19,50},{-14,50},{-14,36},{-48,36},{-48,-30.4},{-41.2,-30.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sumFraSun.y, resFraSun.u2)
                          annotation (Line(
      points={{-27.4,-34},{-22,-34},{-22,-22},{-44,-22},{-44,-3.6},{-41.2,-3.6}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(overlap.y, resFraSun.u1)
                              annotation (Line(
      points={{-27.4,26},{-22,26},{-22,10},{-44,10},{-44,3.6},{-41.2,3.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sidFin.fraSun, sumFraSun.u2)
                                 annotation (Line(
      points={{-19,-60},{-12,-60},{-12,-44},{-48,-44},{-48,-37.6},{-41.2,-37.6}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(idxSou.y, extFraSun.index) annotation (Line(
      points={{61,-70},{70,-70},{70,-2}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(resFraSun.y, smoMax.u1) annotation (Line(
      points={{-27.4,-1.88738e-16},{-19.7,-1.88738e-16},{-19.7,6},{-12,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(noSunCond.y, smoMax.u2) annotation (Line(
      points={{-7.4,-34},{0,-34},{0,-14},{-20,-14},{-20,-6},{-12,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(smoMax.y, mulFraSun.u2[1]) annotation (Line(
      points={{11,6.10623e-16},{18,6.10623e-16},{18,13},{30,13}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation ( Icon(graphics={Bitmap(extent={{-92,92},{92,-92}},
            fileName="modelica://Buildings/Resources/Images/HeatTransfer/Windows/BaseClasses/Overhang.png")}),
defaultComponentName="sha",
Documentation(info="<html>
<p>
This model outputs the fraction of the window area that is sun exposed
for a window that may have an overhang and sidefins.
Depending on the record with construction data <code>conPar</code>,
an overhang, side fins or no external shade is modeled.
The model allows having an overhang and side fins at the same time.
In such a case, the overhang width should be
measured from the window edge to the sidefin,
because the overhang width beyond the sidefin will
cast a shadow on the side fin and not on the window.
Similarly, the side fin height should be measured
from the upper window edge to the overhang,
because the side fin height above the
overhang will not cast a shadow on the window.
The parameters for the dimensions of the overhang and side fins are as
described in the models
<a href=\"modelica://Buildings.HeatTransfer.Windows.Overhang\">
Buildings.HeatTransfer.Windows.Overhang</a>
and
<a href=\"modelica://Buildings.HeatTransfer.Windows.SideFins\">
Buildings.HeatTransfer.Windows.SideFins</a>.
</p>

<h4>Limitations</h4>
<p>
For overhangs, the model assumes that
</p>
<ul>
<li>
the overhang is at least as wide as the window, i.e.,
<i>w<sub>L</sub> &ge; 0</i> and
<i>w<sub>R</sub> &ge; 0</i>, and
</li>
<li>
the overhang is horizontal.
</li>
</ul>

<p>
For side fins, the model assumes that
</p>
<ul>
<li>
the side fins are placed symmetrically to the left and right of the window,
</li>
<li>
the top of the side fins must be at an equal or greater height than the window, and
</li>
<li>
the side fins extends at least to the lower edge of the window.
</li>
</ul>

<h4>Implementation</h4>
<p>
The detailed calculation method is explained in
<a href=\"modelica://Buildings.HeatTransfer.Windows.BaseClasses.SideFins\">
Buildings.HeatTransfer.Windows.BaseClasses.SideFins</a>
and in
<a href=\"modelica://Buildings.HeatTransfer.Windows.BaseClasses.Overhang\">
Buildings.HeatTransfer.Windows.BaseClasses.Overhang</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 16, 2021, by Michael Wetter:<br/>
Removed parameter <code>lat</code> because the latitude is now obtained from the weather data bus.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
</li>
<li>
May 30, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
July 7, 2012, by Michael Wetter:<br/>
Renamed model from <code>Shade</code> to <code>FixedShade</code> because
shade is already used for window interior and exterior shades.
</li><li>
July 5, 2012, by Michael Wetter:<br/>
Moved model from package <code>Buildings.ThermalZones.Detailed.BaseClasses</code> to
<code>Buildings.HeatTransfer.Windows</code>, because the overhang and side fin
models are also in this package.
</li>
<li>
May 21, 2012, by Kaustubh Phalak:<br/>
Enabled the model to use overhang and side at the same time.
</li>
<li>
March 5, 2012, by Michael Wetter:<br/>
First implementation.
</li>

</ul>
</html>"));
end FixedShade;
