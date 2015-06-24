within Buildings.HeatTransfer.Windows.BaseClasses;
block TransmittedRadiation "Transmitted radiation through window"
  extends Buildings.HeatTransfer.Windows.BaseClasses.PartialRadiation;
  Modelica.Blocks.Interfaces.RealOutput QTra_flow(final quantity="Power",
      final unit="W")
    "Transmitted exterior radiation through the window. (1: no shade; 2: shade)"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
  final parameter Real traCoeRoo(fixed=false)
    "Transmitivity of the window glass for interior radiation without shading";

  output Modelica.SIunits.Power QTraUns_flow
    "Transmitted solar radiation through unshaded part of window";
  output Modelica.SIunits.Power QTraSha_flow
    "Transmitted solar radiation through shaded part of window";

protected
  Real x "Intermediate variable";
  final parameter Integer NDIR=radDat.NDIR;
  final parameter Integer HEM=radDat.HEM;
  constant Integer NoShade=1;
  constant Integer Shade=2;
  constant Integer Interior=1;
  constant Integer Exterior=2;
  final parameter Real coeTraWinExtIrr[2, radDat.HEM + 2](each fixed=false);
  Real tmpNoSha;
  Real tmpSha;
  Real incAng2;

initial equation
  //**************************************************************
  // Assign coefficients.
  // Data dimension from Original ([1 : HEM]) to New ([2 : HEM+1])
  // with 2 dummy variable for interpolation.
  //**************************************************************
  // Glass
  for j in 1:HEM loop
    // Properties for glass without shading
    coeTraWinExtIrr[NoShade, j + 1] =  radDat.traRef[1, 1, N, j];
    // Properties for glass with shading
    if haveInteriorShade then
      coeTraWinExtIrr[Shade, j + 1] =  radDat.winTraExtIrrIntSha[j];
    elseif haveExteriorShade then
      coeTraWinExtIrr[Shade, j + 1] =  radDat.winTraExtIrrExtSha[j];
    else
      // No Shade
      coeTraWinExtIrr[Shade, j + 1] =  0.0;
    end if;
  end for;
  // Dummy variables at 1 and HEM+2
  for k in NoShade:Shade loop
    coeTraWinExtIrr[k, 1] =  coeTraWinExtIrr[k, 2];
    coeTraWinExtIrr[k, HEM + 2] =  coeTraWinExtIrr[k, HEM + 1];
  end for;

  //**************************************************************
  // Glass: transmissivity for interior irradiation
  //**************************************************************
  traCoeRoo =  radDat.traRef[1, N, 1, HEM];

algorithm
  QTraUns_flow := AWin*HDif*(1 - uSha_internal)*coeTraWinExtIrr[NoShade, HEM +
    1];
  QTraSha_flow := AWin*HDif*uSha_internal*coeTraWinExtIrr[Shade, HEM + 1];

  //**************************************************************
  // Glass, Device: add absorbed radiation (angular part) from exterior sources
  //**************************************************************
  // Use min() instead of if() to avoid event
  incAng2 := min(incAng, 0.5*Modelica.Constants.pi);
  x := 2*(NDIR - 1)*abs(incAng2)/Modelica.Constants.pi
    "x=(index-1)*incAng/(0.5pi), 0<=x<=NDIR-1";
  x := x + 2;

  // Window unshaded parts: add transmitted radiation for angular radiation
  tmpNoSha :=
    Buildings.HeatTransfer.Windows.BaseClasses.smoothInterpolation({
    coeTraWinExtIrr[NoShade, k] for k in 1:(HEM + 2)}, x);
  QTraUns_flow := QTraUns_flow + AWin*HDir*(1 - uSha_internal)*tmpNoSha;

  // Window shaded parts: add transmitted radiation for angular radiation
  tmpSha := Buildings.HeatTransfer.Windows.BaseClasses.smoothInterpolation(
    {coeTraWinExtIrr[Shade, k] for k in 1:(HEM + 2)}, x);
  QTraSha_flow := QTraSha_flow + AWin*HDir*uSha_internal*tmpSha;

  // Assign quantities to output connectors
  QTra_flow := QTraUns_flow + QTraSha_flow;
  annotation (
    Documentation(info="<html>
The model calculates solar radiation through the window.
The calculations follow the description in Wetter (2004), Appendix A.4.3.
<br/>

The transmitted exterior radiation for window system includes:<br/>
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
The output is <code>QTra_flow = Part1 + Part2 + Part3 + Part4</code>

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
          lineColor={0,0,127},
          textString="uSha"), Text(
          extent={{44,8},{110,-6}},
          lineColor={0,0,127},
          textString="QTra")}));
end TransmittedRadiation;
