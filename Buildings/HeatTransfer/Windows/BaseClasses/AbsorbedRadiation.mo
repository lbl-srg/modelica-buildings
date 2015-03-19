within Buildings.HeatTransfer.Windows.BaseClasses;
block AbsorbedRadiation "Absorbed radiation by window"
  extends Buildings.HeatTransfer.Windows.BaseClasses.PartialRadiation;

  Modelica.Blocks.Interfaces.RealInput HRoo(quantity="RadiantEnergyFluenceRate",
      unit="W/m2") "Diffussive radiation from room " annotation (Placement(
        transformation(extent={{-140,-100},{-100,-60}}),iconTransformation(
          extent={{-130,-91},{-100,-61}})));

  Modelica.Blocks.Interfaces.RealOutput QAbsExtSha_flow(final quantity="Power",
      final unit="W")
    "Absorbed interior and exterior radiation by exterior shading device"
    annotation (Placement(transformation(extent={{100,70},{120,90}}),
        iconTransformation(extent={{100,70},{120,90}})));
  Modelica.Blocks.Interfaces.RealOutput QAbsIntSha_flow(final quantity="Power",
      final unit="W")
    "Absorbed interior and exterior radiation by interior shading device"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}}),
        iconTransformation(extent={{100,-90},{120,-70}})));
  Modelica.Blocks.Interfaces.RealOutput QAbsGlaUns_flow[N](each quantity=
        "Power", each final unit="W")
    "Absorbed interior and exterior radiation by unshaded part of glass"
    annotation (Placement(transformation(extent={{100,30},{120,50}}),
        iconTransformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput QAbsGlaSha_flow[N](each quantity=
        "Power", each final unit="W")
    "Absorbed interior and exterior radiation by shaded part of glass"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}}),
        iconTransformation(extent={{100,-50},{120,-30}})));

  output Modelica.SIunits.Power absRad[2, N + 2] "Absorbed interior and exterior radiation.
      (absRad[2,1]: exterior shading device,
      absRad[1,2 to N+1]: glass (unshaded part),
      absRad[2,2 to N+1]: glass (shaded part),
      absRad[2,N+2]: interior shading device)";

protected
  constant Integer k=1;
  Real x;
  final parameter Integer NDIR=radDat.NDIR;
  final parameter Integer HEM=radDat.HEM;
  constant Integer NoShade=1;
  constant Integer Shade=2;
  constant Integer Interior=1;
  constant Integer Exterior=2;
  final parameter Real coeAbsEx[2, radDat.N, radDat.HEM + 2](each fixed=false);
  final parameter Real coeRefExtPan1[radDat.HEM + 2](each fixed=false)
    "Reflectivity of pane 1";
  final parameter Real coeAbsIn[2, radDat.N](each fixed=false);
  final parameter Real coeAbsDevExtIrrIntSha[radDat.HEM + 2](each fixed=false)
    "Absorptivity of interior shading device for exterior radiation";
  final parameter Real coeAbsDevExtIrrExtSha=1 - radDat.traRefShaDev[1, 1] -
      radDat.traRefShaDev[2, 1]
    "Absorptivity of exterior shading device for exterior radiation";
  final parameter Real coeAbsDevIntIrrIntSha=radDat.devAbsIntIrrIntSha
    "Absorptivity of interior shading device for interior radiation";
  final parameter Real coeAbsDevIntIrrExtSha=1 - radDat.winTraRefIntIrrExtSha[1]
       - radDat.winTraRefIntIrrExtSha[2]
    "Absorptivity of exterior shading device for interior radiation";
  Real tmpNoSha;
  Real tmpSha;
  Real incAng2;

initial equation
  //**************************************************************
  // Assign coefficients.
  // Data dimension changes from Original ([1 : HEM]) to New ([2 : HEM+1])
  // with 2 dummy variable for interpolation.
  //**************************************************************
  // Glass
  for i in 1:N loop
    coeAbsIn[NoShade, i] =  radDat.absIntIrrNoSha[i];
    // Properties for glass with shading
    if haveInteriorShade then
      coeAbsIn[Shade, i] =  radDat.absIntIrrIntSha[i];
    elseif haveExteriorShade then
      coeAbsIn[Shade, i] =  radDat.absIntIrrExtSha[i];
    else
      // No Shade
      coeAbsIn[Shade, i] =  0.0;
    end if;

    for j in 1:HEM loop
      // Properties for glass without shading
      coeAbsEx[NoShade, i, j + 1] =  radDat.absExtIrrNoSha[i, j];
      // Properties for glass with shading
      if haveInteriorShade then
        coeAbsEx[Shade, i, j + 1] =  radDat.absExtIrrIntSha[i, j];
      elseif haveExteriorShade then
        coeAbsEx[Shade, i, j + 1] =  radDat.absExtIrrExtSha[i, j];
      else
        // No Shade
        coeAbsEx[Shade, i, j + 1] =  0.0;
      end if;
    end for;
    // Dummy variables at 1 and HEM+2
    for k in NoShade:Shade loop
      coeAbsEx[k, i, 1] =  coeAbsEx[k, i, 2];
      coeAbsEx[k, i, HEM + 2] =  coeAbsEx[k, i, HEM + 1];
    end for;
  end for;

  // Glass Pane 1: Reflectivity
  for j in 1:HEM loop
    coeRefExtPan1[j + 1] =  radDat.traRef[2, 1, N, j];
  end for;

  // Interior shades
  for j in 1:HEM loop
    coeAbsDevExtIrrIntSha[j + 1] =  radDat.devAbsExtIrrIntShaDev[j];
  end for;

  // Dummy variables at 1 and HEM+2
  coeRefExtPan1[1] =  coeRefExtPan1[2];
  coeRefExtPan1[HEM + 2] =  coeRefExtPan1[HEM + 1];
  coeAbsDevExtIrrIntSha[1] =  coeAbsDevExtIrrIntSha[2];
  coeAbsDevExtIrrIntSha[HEM + 2] =  coeAbsDevExtIrrIntSha[HEM + 1];

algorithm
  absRad[NoShade, 1] := 0.0;
  absRad[NoShade, N + 2] := 0.0;
  absRad[Shade, 1] := 0.0;
  absRad[Shade, N + 2] := 0.0;

  //**************************************************************
  // Glass: absorbed diffusive radiation from exterior and interior sources
  //**************************************************************
  for i in 1:N loop
    absRad[NoShade, i + 1] := AWin*(1 - uSha_internal)*(HDif*coeAbsEx[NoShade,
      i, HEM + 1] + HRoo*coeAbsIn[NoShade, i]);
    absRad[Shade, i + 1] := AWin*uSha_internal*(HDif*coeAbsEx[Shade, i, HEM + 1]
       + HRoo*coeAbsIn[Shade, i]);
  end for;

  //**************************************************************
  // Shading device: absorbed radiation from exterior source
  //**************************************************************
  // Exterior Shading Device:
  // direct radiation: 1. direct absorption;
  // diffusive radiation: 1. direct absorption 2. absorption from back reflection
  if haveExteriorShade then
    absRad[Shade, 1] := AWin*uSha_internal*coeAbsDevExtIrrExtSha*(HDif + HDir
       + HDif*radDat.traRefShaDev[1, 1]*radDat.traRef[2, 1, N, HEM]);
    // Interior Shading Device: diffusive radiation from both interior and exterior
  elseif haveInteriorShade then
    absRad[Shade, N + 2] := AWin*uSha_internal*(HDif*radDat.devAbsExtIrrIntShaDev[
      HEM] + HRoo*coeAbsDevIntIrrIntSha);
  end if;

  //**************************************************************
  // Glass, Device: add absorbed direct radiation from exterior sources
  //**************************************************************
  // Use min() instead of if() to avoid event
  incAng2 := min(incAng, 0.5*Modelica.Constants.pi);

  x := 2*(NDIR - 1)*abs(incAng2)/Modelica.Constants.pi
    "x=(index-1)*incAng/(0.5pi), 0<=x<=NDIR";
  x := x + 2;

  for i in 1:N loop
    // Glass without shading: Add absorbed direct radiation
    tmpNoSha :=
      Buildings.HeatTransfer.Windows.BaseClasses.smoothInterpolation({
      coeAbsEx[NoShade, i, k] for k in 1:(HEM + 2)}, x);
    absRad[NoShade, i + 1] := absRad[NoShade, i + 1] + AWin*HDir*(1 -
      uSha_internal)*tmpNoSha;

    // Glass with shading: add absorbed direct radiation
    tmpSha :=
      Buildings.HeatTransfer.Windows.BaseClasses.smoothInterpolation({
      coeAbsEx[Shade, i, k] for k in 1:(HEM + 2)}, x);
    absRad[Shade, i + 1] := absRad[Shade, i + 1] + AWin*HDir*uSha_internal*
      tmpSha;
  end for;

  // Interior shading device: add absorbed direct radiation
  if haveInteriorShade then
    tmpSha :=
      Buildings.HeatTransfer.Windows.BaseClasses.smoothInterpolation({
      coeAbsDevExtIrrIntSha[k] for k in 1:(HEM + 2)}, x);
    absRad[Shade, N + 2] := absRad[Shade, N + 2] + AWin*HDir*uSha_internal*
      tmpSha;
  end if;

  // Exterior shading device: add absorbed reflection of direct radiation from exterior source
  if haveExteriorShade then
    tmpNoSha :=
      Buildings.HeatTransfer.Windows.BaseClasses.smoothInterpolation({
      coeRefExtPan1[k] for k in 1:(HEM + 2)}, x);
    absRad[Shade, 1] := absRad[Shade, 1] + AWin*HDir*uSha_internal*
      coeAbsDevExtIrrExtSha*tmpNoSha;
  end if;

  // Assign quantities to output connectors
  QAbsExtSha_flow := absRad[2, 1];
  QAbsIntSha_flow := absRad[2, N + 2];
  QAbsGlaUns_flow[:] := absRad[1, 2:N + 1];
  QAbsGlaSha_flow[:] := absRad[2, 2:N + 1];
  annotation (
    Documentation(info="<html>
<p>
The model calculates absorbed solar radiation on the window.
The calculations follow the description in Wetter (2004), Appendix A.4.3.
</p>
<p>
The absorbed radiation by exterior shades includes:
</p>
<ol>
<li>
the directly absorbed exterior radiation: <code>AWin*uSha*(HDir+HDif)*(1-tau-rho)</code>
</li>
<li>
the indirectly absorbed exterior radiantion from reflection (angular part): <code>AWin*uSha*HDir*tau*rho(IncAng)*(1-tau-rho)</code>
</li>
<li>
the indirectly absorbed of exterior irradiantion from reflection (diffusive part): <code>AWin*uSha*HDif*tau*rho(HEM)*(1-tau-rho)</code>
</li>
<li>
the absorbed interior radiation is neglected.
</li>
</ol>
<p>
The output is <code>absRad[2, 1]</code>
</p>

<p>
The absorbed radiation by interior shades includes:
</p>
<ol>
<li>
the absorbed exterior radiation (angular part): <code>AWin*uSha*HDir*alpha(IncAng)</code>
</li>
<li>
the absorbed exterior radiation (diffusive part): <code>AWin*uSha*HDif*alpha(HEM)</code>
</li>
<li>
the absorbed interior radiation (diffusive part): <code>AWin*uSha*HRoo*(1-tau-rho)</code>
</li>
</ol>
<p>
The output is <code>absRad[2, N+2]</code>
</p>

<p>
The absorbed radiation by glass includes:
</p>
<ol>
<li>
the absorbed radiation by unshaded part (diffusive part): <code>AWin*(1-uSha)*(HDif*alphaEx(HEM)+HRoo*alphaIn(HEM))</code>
</li>
<li>
the absorbed radiation by unshaded part (angular part from exterior source): <code>AWin*(1-uSha)*HDir*alphaEx(IncAng)</code>
</li>
<li>
the absorbed radiaiton by shaded part (diffusive part): <code>AWin*uSha*(HDif*alphaExSha(HEM)+HRoo*alphaInSha(HEM))</code>
</li>
<li>
the absorbed radiation by shaded part (angular part from exterior source): <code>AWin*uSha*HDir*alphaExSha(IncAng)</code>
</li>
</ol>
<p>
The output is <code>absRad[1, 2:N+1] = Part1 + Part2; absRad[2, 2:N+1] = Part3 + Part4</code>
</p>

<h4>References</h4>
<ul>
<li>
Michael Wetter.<br/>
<a href=\"http://simulationresearch.lbl.gov/wetter/download/mwdiss.pdf\">
Simulation-based Building Energy Optimization</a>.<br/>
Dissertation. University of California at Berkeley. 2004.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
January 21, 2015, by Michael Wetter:<br/>
Changed <code>initial algorithm</code> to
<code>initial equation</code> section and removed
dublicate assignments.
This is required for OpenModelica.
</li>
<li>
October 17, 2014, by Michael Wetter:<br/>
Added missing <code>each</code> keywords in parameter declarations.
</li>
<li>
March 4, 2011, by Wangda Zuo:<br/>
Remove the if-statement and integer function that can trigger events.
</li>
<li>
February 2, 2010, by Michael Wetter:<br/>
Made connector <code>uSha</code> a conditional connector.
</li>
<li>
December 15, 2010, by Wangda Zuo:<br/>
Separate transmittance and absorbance.
</li>
<li>
December 12, 2010, by Michael Wetter:<br/>
Replaced record
<a href=\"modelica://Buildings.HeatTransfer.Data.GlazingSystems\">
Buildings.HeatTransfer.Data.GlazingSystems</a> with the
parameters used by this model.
This was needed to integrate the radiation model into the room model.
</li>
<li>
December 10, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Text(
          extent={{26,86},{102,74}},
          lineColor={0,0,127},
          textString="QAbsExtSha"),
        Text(
          extent={{-101,-73},{-54,-82}},
          lineColor={0,0,127},
          textString="HRoo"),
        Text(
          extent={{24,-68},{102,-80}},
          lineColor={0,0,127},
          textString="QAbsIntSha"),
        Text(
          extent={{34,46},{94,32}},
          lineColor={0,0,127},
          textString="QAbsGlaUns"),
        Text(
          extent={{30,-32},{104,-44}},
          lineColor={0,0,127},
          textString="QAbsGlaSha")}));
end AbsorbedRadiation;
