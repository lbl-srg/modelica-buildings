within Buildings.Rooms.BaseClasses;
model Shade "Model for exterior shade due to overhang or side fin"
  extends HeatTransfer.Windows.BaseClasses.ShadeInterface_weatherBus;
  parameter ParameterConstructionWithWindow conPar "Construction parameters"
    annotation (Evaluate=true);
protected
  final parameter Boolean haveOverhang = conPar.ove.haveOverhang
    "Flag for overhang" annotation (Evaluate=true);

  final parameter Boolean haveSideFins = conPar.sidFin.haveSideFins
    "Flag for sideFins" annotation (Evaluate=true);
  final parameter Boolean haveOverhangAndSideFins=not (haveOverhang
       and haveSideFins) "Parameter used for error control";

  final parameter Integer idx = if haveOverhang then 1 elseif haveSideFins then 2 else 3
    "Integer used to pick the appropriate output signal";

  HeatTransfer.Windows.BaseClasses.Overhang ove(
    final hWin=conPar.hWin,
    final wWin=conPar.wWin,
    final dep=conPar.ove.dep,
    final gap=conPar.ove.gap,
    final w=conPar.ove.w) "Model for overhang"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

  HeatTransfer.Windows.BaseClasses.SideFins sidFin(
    final hWin=conPar.hWin,
    final wWin=conPar.wWin,
    final h=conPar.sidFin.h,
    final dep=conPar.sidFin.dep,
    final gap=conPar.sidFin.gap) "Model for side fins"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Modelica.Blocks.Routing.Extractor extFraSun(final nin=3, final allowOutOfRange=false)
    "Extractor to pick the appropriate output signal"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Routing.Multiplex3 mulFraSun(
    final n1=1,
    final n2=1,
    final n3=1) "Multiplex for fraction of shaded area"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Sources.IntegerConstant idxSou(final k=idx)
    "Source term to pick output signal"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  BoundaryConditions.SolarGeometry.BaseClasses.WallSolarAzimuth walSolAzi
    "Angle measured in horizontal plane between projection of sun's rays and normal to vertical surface"
     annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Modelica.Blocks.Math.Product mulHDir
    "Multiplication to obtain direct solar irradiation on shaded window"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
protected
  Modelica.Blocks.Sources.Constant const(k=1)
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
initial algorithm
  assert(haveOverhangAndSideFins,
  "A window cannot have an overhang and side fins at the same time.");

equation

  connect(ove.fraSun, mulFraSun.u1[1])   annotation (Line(
      points={{-19,50},{0,50},{0,7},{18,7}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sidFin.fraSun, mulFraSun.u2[1])   annotation (Line(
      points={{-19,6.10623e-16},{0,6.10623e-16},{0,6.66134e-16},{18,6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(mulFraSun.y, extFraSun.u)    annotation (Line(
      points={{41,6.10623e-16},{48.5,6.10623e-16},{48.5,6.66134e-16},{58,
          6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(extFraSun.y, fraSun)  annotation (Line(
      points={{81,6.10623e-16},{90.5,6.10623e-16},{90.5,5.55112e-16},{110,
          5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(idxSou.y, extFraSun.index) annotation (Line(
      points={{41,-50},{70,-50},{70,-12}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(weaBus.sol.alt, walSolAzi.alt) annotation (Line(
      points={{-100,5.55112e-16},{-92,5.55112e-16},{-92,-76},{-82,-76},{-82,
          -75.2}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
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
      points={{-59,-80},{-54,-80},{-54,4},{-42,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaBus.sol.alt, sidFin.alt) annotation (Line(
      points={{-100,5.55112e-16},{-68,5.55112e-16},{-68,-4},{-42,-4}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.sol.alt, ove.alt) annotation (Line(
      points={{-100,5.55112e-16},{-96,0},{-92,0},{-92,46},{-42,46}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(mulHDir.y, HDirTil) annotation (Line(
      points={{81,60},{110,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(extFraSun.y, mulHDir.u2) annotation (Line(
      points={{81,6.10623e-16},{90,6.10623e-16},{90,40},{40,40},{40,54},{58,54}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(mulHDir.u1, HDirTilUns) annotation (Line(
      points={{58,66},{40,66},{40,80},{-60,80},{-60,60},{-120,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, mulFraSun.u3[1]) annotation (Line(
      points={{-19,-50},{0,-50},{0,-7},{18,-7}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Icon(graphics={Bitmap(extent={{-92,92},{92,-92}},
            fileName="modelica://Buildings/Resources/Images/HeatTransfer/Windows/BaseClasses/Overhang.png")}),
defaultComponentName="ove",
Documentation(info="<html>
<p>
This block outputs the fraction of the window area that is sun exposed.
Depending on the record with construction data <code>conPar</code>, 
an overhang, side fins or no external shade is modeled.
The model does not allow having an overhang or side fins at the same time.
</p>
<h4>Limitations</h4>
<p>
For overhangs, the model assumes that 
<ul>
<li>the overhang is placed symmetrically about the 
window vertical center-line,
</li>
<li> 
the overhang length is greater than or equal to the window width, and
</li>
<li>
the overhang is horizontal.
</li>
</ul>
</p>
<p>
For side fins, the model assumes that 
<ul>
<li>
the side fins are placed symmetrically to the left and right of the window,
</li>
<li> 
the top of the side fins must be at an equal or greater height than the window, and
</li>
<li>
the bottom of the side fins must be at an equal or lower height than the 
bottom of the window.
</li>
</ul> 
</p>
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
March 5, 2012, by Michael Wetter:<br>
First implementation. 
</li>
</ul>
</html>"));
end Shade;
