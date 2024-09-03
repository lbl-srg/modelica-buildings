within Buildings.HeatTransfer.Windows.BaseClasses;
block AbsorbedRadiation "Absorbed radiation by window"
  extends Buildings.HeatTransfer.Windows.BaseClasses.PartialRadiation;

  Modelica.Blocks.Interfaces.RealInput HRoo(
    quantity="RadiantEnergyFluenceRate",
    final unit="W/m2") "Diffussive radiation from room " annotation (Placement(
        transformation(extent={{-140,-100},{-100,-60}}),iconTransformation(
          extent={{-130,-91},{-100,-61}})));

  Modelica.Blocks.Interfaces.RealOutput QAbsExtSha_flow[NSta](
    each final quantity="Power",
    each final unit="W")
    "Absorbed interior and exterior radiation by exterior shading device"
    annotation (Placement(transformation(extent={{100,70},{120,90}}),
        iconTransformation(extent={{100,70},{120,90}})));
  Modelica.Blocks.Interfaces.RealOutput QAbsIntSha_flow[NSta](
    each final quantity="Power",
    each final unit="W")
    "Absorbed interior and exterior radiation by interior shading device"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}}),
        iconTransformation(extent={{100,-90},{120,-70}})));
  Modelica.Blocks.Interfaces.RealOutput QAbsGlaUns_flow[N, NSta](
    each quantity="Power",
    each final unit="W")
    "Absorbed interior and exterior radiation by unshaded part of glass"
    annotation (Placement(transformation(extent={{100,30},{120,50}}),
        iconTransformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput QAbsGlaSha_flow[N, NSta](
    each quantity="Power",
    each final unit="W")
    "Absorbed interior and exterior radiation by shaded part of glass"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}}),
        iconTransformation(extent={{100,-50},{120,-30}})));

  output Modelica.Units.SI.Power absRad[2,N + 2,NSta] "Absorbed interior and exterior radiation.
      (absRad[2,1,iSta]: exterior shading device,
      absRad[1,2 to N+1,iSta]: glass (unshaded part),
      absRad[2,2 to N+1,iSta]: glass (shaded part),
      absRad[2,N+2,iSta]: interior shading device)
      with iSta being the state of the (electrochromic) window";

protected
  final parameter Integer NDIR=radDat.NDIR "Number of incident angles";
  final parameter Integer HEM=radDat.HEM "Index of hemispherical integration";
  constant Integer NoShade=1 "Index for data for no shade";
  constant Integer Shade=2 "Index for data with shade";
  final parameter Real coeAbsEx[2, radDat.N, radDat.HEM + 2, NSta](each fixed=false);
  final parameter Real coeRefExtPan1[radDat.HEM + 2, NSta](each fixed=false)
    "Reflectivity of pane 1";
  final parameter Real coeAbsIn[2, radDat.N, NSta](each fixed=false);
  final parameter Real coeAbsDevExtIrrIntSha[radDat.HEM + 2, NSta](each fixed=false)
    "Absorptivity of interior shading device for exterior radiation";
  final parameter Real coeAbsDevExtIrrExtSha=1 - radDat.traRefShaDev[1, 1] -
      radDat.traRefShaDev[2, 1]
    "Absorptivity of exterior shading device for exterior radiation";
  final parameter Real coeAbsDevIntIrrIntSha[NSta]=radDat.devAbsIntIrrIntSha
    "Absorptivity of interior shading device for interior radiation";
  final parameter Real coeAbsDevIntIrrExtSha[NSta]=
    {1 - radDat.winTraRefIntIrrExtSha[1, iSta]
       - radDat.winTraRefIntIrrExtSha[2, iSta] for iSta in 1:NSta}
    "Absorptivity of exterior shading device for interior radiation";

  Real x "Intermediate variable, x=(index-1)*incAng/(0.5pi)+2, 0<=x<=NDIR";

  Real incAng2;

initial equation
  //**************************************************************
  // Assign coefficients.
  // Data dimension changes from Original ([1 : HEM]) to New ([2 : HEM+1])
  // with 2 dummy variable for interpolation.
  //**************************************************************
  // Glass
  for i in 1:N loop
    coeAbsIn[NoShade, i, 1:NSta] =  radDat.absIntIrrNoSha[i, 1:NSta];
    // Properties for glass with shading
    if haveInteriorShade then
      coeAbsIn[Shade, i, 1:NSta] =  radDat.absIntIrrIntSha[i, 1:NSta];
    elseif haveExteriorShade then
      coeAbsIn[Shade, i, 1:NSta] =  radDat.absIntIrrExtSha[i, 1:NSta];
    else
      // No Shade
      coeAbsIn[Shade, i, 1:NSta] =  zeros(NSta);
    end if;

    for j in 1:HEM loop
      // Properties for glass without shading
      coeAbsEx[NoShade, i, j + 1, 1:NSta] =  radDat.absExtIrrNoSha[i, j, 1:NSta];
      // Properties for glass with shading
      if haveInteriorShade then
        coeAbsEx[Shade, i, j + 1, 1:NSta] =  radDat.absExtIrrIntSha[i, j, 1:NSta];
      elseif haveExteriorShade then
        coeAbsEx[Shade, i, j + 1, 1:NSta] =  radDat.absExtIrrExtSha[i, j, 1:NSta];
      else
        // No Shade
        coeAbsEx[Shade, i, j + 1, 1:NSta] =  zeros(NSta);
      end if;
    end for;
    // Dummy variables at 1 and HEM+2
    for k in NoShade:Shade loop
      coeAbsEx[k, i, 1, 1:NSta] =  coeAbsEx[k, i, 2, 1:NSta];
      coeAbsEx[k, i, HEM + 2, 1:NSta] =  coeAbsEx[k, i, HEM + 1, 1:NSta];
    end for;
  end for;

  // Glass Pane 1: Reflectivity
  for j in 1:HEM loop
    coeRefExtPan1[j + 1, 1:NSta] =  radDat.traRef[2, 1, N, j, 1:NSta];
  end for;

  // Interior shades
  for j in 1:HEM loop
    coeAbsDevExtIrrIntSha[j + 1, 1:NSta] =  radDat.devAbsExtIrrIntShaDev[j, 1:NSta];
  end for;

  // Dummy variables at 1 and HEM+2
  coeRefExtPan1[1, 1:NSta] =  coeRefExtPan1[2, 1:NSta];
  coeRefExtPan1[HEM + 2, 1:NSta] =  coeRefExtPan1[HEM + 1, 1:NSta];
  coeAbsDevExtIrrIntSha[1, 1:NSta] =  coeAbsDevExtIrrIntSha[2, 1:NSta];
  coeAbsDevExtIrrIntSha[HEM + 2, 1:NSta] =  coeAbsDevExtIrrIntSha[HEM + 1, 1:NSta];

algorithm
  absRad[NoShade, 1,     1:NSta] := zeros(NSta);
  absRad[NoShade, N + 2, 1:NSta] := zeros(NSta);
  absRad[Shade,   1,     1:NSta] := zeros(NSta);
  absRad[Shade,   N + 2, 1:NSta] := zeros(NSta);

  // **************************************************************
  // Glass: absorbed diffusive radiation from exterior and interior sources
  // **************************************************************
  for i in 1:N loop
    absRad[NoShade, i + 1, 1:NSta] := AWin*(1 - uSha_internal)*
       (HDif*coeAbsEx[NoShade, i, HEM + 1, 1:NSta] + HRoo*coeAbsIn[NoShade, i, 1:NSta]);
    absRad[Shade, i + 1, 1:NSta] := AWin*uSha_internal*(HDif*coeAbsEx[Shade, i, HEM + 1, 1:NSta]
       + HRoo*coeAbsIn[Shade, i, 1:NSta]);
  end for;

  // **************************************************************
  // Shading device: absorbed radiation from exterior source
  // **************************************************************
  // Exterior Shading Device:
  // direct radiation: 1. direct absorption;
  // diffusive radiation: 1. direct absorption 2. absorption from back reflection
  for iSta in 1:NSta loop
    if haveExteriorShade then
      absRad[Shade, 1, iSta] := AWin*uSha_internal*coeAbsDevExtIrrExtSha*
        (HDif + HDir + HDif*radDat.traRefShaDev[1, 1]*radDat.traRef[2, 1, N, HEM, iSta]);
    // Interior Shading Device: diffusive radiation from both interior and exterior
     elseif haveInteriorShade then
     absRad[Shade, N + 2, iSta] := AWin*uSha_internal*
        (HDif*radDat.devAbsExtIrrIntShaDev[HEM, iSta] + HRoo*coeAbsDevIntIrrIntSha[iSta]);
    end if;
  end for;

  // **************************************************************
  // Glass, Device: add absorbed direct radiation from exterior sources
  // **************************************************************
  // Use min() instead of if() to avoid event
  incAng2 := min(incAng, 0.5*Modelica.Constants.pi);

  x := 2*(NDIR - 1)*abs(incAng2)/Modelica.Constants.pi + 2
    "x=(index-1)*incAng/(0.5pi)+2, 0<=x<=NDIR";

  for i in 1:N loop
    // Glass without shading: Add absorbed direct radiation
    for iSta in 1:NSta loop
      absRad[NoShade, i + 1, iSta] := absRad[NoShade, i + 1, iSta] +
        AWin*HDir*(1 - uSha_internal)*
          Buildings.HeatTransfer.Windows.BaseClasses.smoothInterpolation(
          {coeAbsEx[NoShade, i, k, iSta] for k in 1:(HEM + 2)}, x);

      // Glass with shading: add absorbed direct radiation
      absRad[Shade, i + 1, iSta] := absRad[Shade, i + 1, iSta]
                                 + AWin*HDir*uSha_internal
        *Buildings.HeatTransfer.Windows.BaseClasses.smoothInterpolation(
           {coeAbsEx[Shade, i, k, iSta] for k in 1:(HEM + 2)}, x);
    end for;
  end for;

  // Interior shading device: add absorbed direct radiation
  if haveInteriorShade then
    for iSta in 1:NSta loop
      absRad[Shade, N + 2, iSta] := absRad[Shade, N + 2, iSta]
                                  + AWin*HDir*uSha_internal
          *Buildings.HeatTransfer.Windows.BaseClasses.smoothInterpolation(
              {coeAbsDevExtIrrIntSha[k, iSta] for k in 1:(HEM + 2)}, x);
    end for;
  end if;

  // Exterior shading device: add absorbed reflection of direct radiation from exterior source
  if haveExteriorShade then
    for iSta in 1:NSta loop
      absRad[Shade, 1, iSta] := absRad[Shade, 1, iSta]
                              + AWin*HDir*uSha_internal*coeAbsDevExtIrrExtSha
                              *Buildings.HeatTransfer.Windows.BaseClasses.smoothInterpolation(
          {coeRefExtPan1[k, iSta] for k in 1:(HEM + 2)}, x);
    end for;
  end if;

  // Assign quantities to output connectors
  QAbsExtSha_flow[1:NSta]    := absRad[2, 1,       1:NSta];
  QAbsIntSha_flow[1:NSta]    := absRad[2, N + 2,   1:NSta];
  QAbsGlaUns_flow[:, 1:NSta] := absRad[1, 2:N + 1, 1:NSta];
  QAbsGlaSha_flow[:, 1:NSta] := absRad[2, 2:N + 1, 1:NSta];
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
October 22, 2016, by Michael Wetter:<br/>
Added range for loop variable for JModelica.<br/>
Made units of <code>HRoo</code> final.<br/>
Removed unused protected constants <code>k</code>,
<code>Interior</code> and <code>Exterior</code>.
</li>
<li>
August 7, 2015, by Michael Wetter:<br/>
Revised model to allow modeling of electrochromic windows.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/445\">issue 445</a>.
</li>
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
Removed the if-statement and integer function that can trigger events.
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
          textColor={0,0,127},
          textString="QAbsExtSha"),
        Text(
          extent={{-101,-73},{-54,-82}},
          textColor={0,0,127},
          textString="HRoo"),
        Text(
          extent={{24,-68},{102,-80}},
          textColor={0,0,127},
          textString="QAbsIntSha"),
        Text(
          extent={{34,46},{94,32}},
          textColor={0,0,127},
          textString="QAbsGlaUns"),
        Text(
          extent={{30,-32},{104,-44}},
          textColor={0,0,127},
          textString="QAbsGlaSha")}));
end AbsorbedRadiation;
