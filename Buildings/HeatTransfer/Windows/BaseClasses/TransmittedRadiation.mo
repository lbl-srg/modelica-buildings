within Buildings.HeatTransfer.Windows.BaseClasses;
block TransmittedRadiation "Transmitted radiation through window"
  extends Buildings.HeatTransfer.Windows.BaseClasses.PartialRadiation;
  Modelica.Blocks.Interfaces.RealOutput QTraDif_flow[NSta](
    each final quantity="Power",
    each final unit="W")
    "Transmitted exterior diffuse radiation through the window. (1: no shade; 2: shade)"
    annotation (Placement(transformation(extent={{100,10},{120,30}}),
        iconTransformation(extent={{100,10},{120,30}})));
  Modelica.Blocks.Interfaces.RealOutput QTraDir_flow[NSta](
    each final quantity="Power",
    each final unit="W")
    "Transmitted exterior direct radiation through the window. (1: no shade; 2: shade)"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}}),
        iconTransformation(extent={{100,-30},{120,-10}})));

  final parameter Real traCoeRoo[NSta](each fixed=false)
    "Transmitivity of the window glass for interior radiation without shading";

  output Modelica.Units.SI.Power QTraDifUns_flow[NSta]
    "Transmitted diffuse solar radiation through unshaded part of window";
  output Modelica.Units.SI.Power QTraDirUns_flow[NSta]
    "Transmitted direct solar radiation through unshaded part of window";
  output Modelica.Units.SI.Power QTraDifSha_flow[NSta]
    "Transmitted diffuse solar radiation through shaded part of window";
  output Modelica.Units.SI.Power QTraDirSha_flow[NSta]
    "Transmitted direct solar radiation through shaded part of window";

protected
  Real x "Intermediate variable";
  final parameter Integer NDIR=radDat.NDIR;
  final parameter Integer HEM=radDat.HEM;
  constant Integer NoShade=1;
  constant Integer Shade=2;
  constant Integer Interior=1;
  constant Integer Exterior=2;
  final parameter Real coeTraWinExtIrr[2, radDat.HEM + 2, NSta](each fixed=false);
  Real incAng2 "=min(incAng, 0.5*Modelica.Constants.pi)";

initial equation
  //**************************************************************
  // Assign coefficients.
  // Data dimension from Original ([1 : HEM]) to New ([2 : HEM+1])
  // with 2 dummy variable for interpolation.
  //**************************************************************
  // Glass
  for j in 1:HEM loop
    // Properties for glass without shading
    coeTraWinExtIrr[NoShade, j + 1, 1:NSta] =  radDat.traRef[1, 1, N, j, 1:NSta];
    // Properties for glass with shading
    if haveInteriorShade then
      coeTraWinExtIrr[Shade, j + 1, 1:NSta] =  radDat.winTraExtIrrIntSha[j, 1:NSta];
    elseif haveExteriorShade then
      coeTraWinExtIrr[Shade, j + 1, 1:NSta] =  radDat.winTraExtIrrExtSha[j, 1:NSta];
    else
      // No Shade
      coeTraWinExtIrr[Shade, j + 1, 1:NSta] =  zeros(NSta);
    end if;
  end for;
  // Dummy variables at 1 and HEM+2
  for k in NoShade:Shade loop
    coeTraWinExtIrr[k, 1, 1:NSta] =  coeTraWinExtIrr[k, 2, 1:NSta];
    coeTraWinExtIrr[k, HEM + 2, 1:NSta] =  coeTraWinExtIrr[k, HEM + 1, 1:NSta];
  end for;

  //**************************************************************
  // Glass: transmissivity for interior irradiation
  //**************************************************************
  traCoeRoo =  radDat.traRef[1, N, 1, HEM, 1:NSta];

equation
  //**************************************************************
  // Glass, Device: add absorbed radiation (angular part) from exterior sources
  //**************************************************************
  // Use min() instead of if() to avoid event
  incAng2 = min(incAng, 0.5*Modelica.Constants.pi);
  x = (2*(NDIR - 1)*abs(incAng2)/Modelica.Constants.pi)+2
    "x=(index-1)*incAng/(0.5pi)+2, 0<=x<=NDIR-1";

  // Window unshaded parts: add transmitted radiation for angular radiation
  for iSta in 1:NSta loop
    QTraDifUns_flow[iSta] = AWin*HDif*(1 - uSha_internal)*coeTraWinExtIrr[NoShade, HEM + 1, iSta];
    QTraDirUns_flow[iSta] = AWin*HDir*(1 - uSha_internal)*
                 Buildings.HeatTransfer.Windows.BaseClasses.smoothInterpolation({
                    coeTraWinExtIrr[NoShade, k, iSta] for k in 1:(HEM + 2)}, x);
  end for;

  // Window shaded parts: add transmitted radiation for angular radiation
  for iSta in 1:NSta loop
    QTraDifSha_flow[iSta] = AWin*HDif*uSha_internal*coeTraWinExtIrr[Shade, HEM + 1, iSta];
    QTraDirSha_flow[iSta] = AWin*HDir*uSha_internal*
               Buildings.HeatTransfer.Windows.BaseClasses.smoothInterpolation(
                 {coeTraWinExtIrr[Shade, k, iSta] for k in 1:(HEM + 2)}, x);
  end for;

  // Assign quantities to output connectors
  QTraDif_flow = QTraDifUns_flow + QTraDifSha_flow;
  QTraDir_flow = QTraDirUns_flow + QTraDirSha_flow;
  annotation (
    Documentation(info="<html>
<p>
The model calculates the solar radiation through the window.
The calculations follow the description in Wetter (2004), Appendix A.4.3.
</p>
<p>
The transmitted exterior radiation for window system includes:
</p>
<ol>
<li>
the transmitted diffusive radiation on unshaded part: <code>AWin*(1-uSha)*HDif*tau(HEM)</code>
</li>
<li>
the transmitted direct radiation on no shade part: <code>AWin*(1-uSha)*HDir*tau(IncAng)</code>
</li>
<li>
the transmitted diffusive radiation on shaded part: <code>AWin*uSha*HDif*tauSha(HEM)</code>
</li>
<li>
the transmitted direct radiation on shaded part: <code>AWin*uSha*HDir*tauSha(IncAng);</code>
</li>
</ol>
<p>
The outputs are <code>QTraDif_flow = Part1 + Part3</code> and
<code>QTraDir_flow = Part2 + Part4</code>.
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
June 7, 2016, by Michael Wetter:<br/>
Removed output <code>QTra_flow</code> and introduced instead
<code>QTraDif_flow</code> and <code>QTraDir_flow</code>.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/451\">issue 451</a>.
</li>
<li>
August 7, 2015, by Michael Wetter:<br/>
Revised model to allow modeling of electrochromic windows.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/445\">issue 445</a>.
</li>
<li>
March 13, 2015, by Michael Wetter:<br/>
Changed <code>initial algorithm</code>
to <code>initial equation</code> section
to avoid a translation error in OpenModelica.
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
Separate transmittance and absorbance models from the window radiation model.
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
    Icon(graphics={Text(
          extent={{-32,-80},{22,-96}},
          textColor={0,0,127},
          textString="uSha"), Text(
          extent={{56,28},{98,14}},
          textColor={0,0,127},
          textString="QTraDif"),
                              Text(
          extent={{54,-14},{96,-28}},
          textColor={0,0,127},
          textString="QTraDir")}));
end TransmittedRadiation;
