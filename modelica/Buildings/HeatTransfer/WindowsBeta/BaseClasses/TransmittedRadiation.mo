within Buildings.HeatTransfer.WindowsBeta.BaseClasses;
block TransmittedRadiation "Transmitted radiation through window"
  extends Buildings.HeatTransfer.WindowsBeta.BaseClasses.PartialRadiation;
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
  Integer k1;
  Integer k2;
  Real x;
  final parameter Integer NDIR=radDat.NDIR;
  final parameter Integer HEM=radDat.HEM;
  constant Integer NoShade=1;
  constant Integer Shade=2;
  constant Integer Interior=1;
  constant Integer Exterior=2;
  final parameter Real coeTraWinExtIrr[2, radDat.HEM + 2](fixed=false);
  Real tmpNoSha;
  Real tmpSha;
  Real y1d;
  Real y2d;
initial algorithm
  //**************************************************************
  // Assign coefficients.
  // Data dimension from Orginal ([1 : HEM]) to New ([2 : HEM+1])
  // with 2 dummy variable for interpolation.
  //**************************************************************
  // Glass
  for i in 1:N loop
    for j in 1:HEM loop
      // Properties for glass without shading
      coeTraWinExtIrr[NoShade, j + 1] := radDat.traRef[1, 1, N, j];
      // Properties for glass with shading
      if haveInteriorShade then
        coeTraWinExtIrr[Shade, j + 1] := radDat.winTraExtIrrIntSha[j];
      elseif haveExteriorShade then
        coeTraWinExtIrr[Shade, j + 1] := radDat.winTraExtIrrExtSha[j];
      else
        // No Shade
        coeTraWinExtIrr[Shade, j + 1] := 0.0;
      end if;
    end for;
    // Dummy variables at 1 and HEM+2
    for k in NoShade:Shade loop
      coeTraWinExtIrr[k, 1] := coeTraWinExtIrr[k, 2];
      coeTraWinExtIrr[k, HEM + 2] := coeTraWinExtIrr[k, HEM + 1];
    end for;
  end for;

  //**************************************************************
  // Glass: transmissivity for interior irradiation
  //**************************************************************
  traCoeRoo := radDat.traRef[1, N, 1, HEM];

equation

  //**************************************************************
  // Window: transmitted radiation for diffusive radiation from exterior sources
  //**************************************************************
algorithm
  QTraUns_flow := AWin*HDif*(1 - uSha)*coeTraWinExtIrr[NoShade, HEM + 1];
  QTraSha_flow := AWin*HDif*uSha*coeTraWinExtIrr[Shade, HEM + 1];

  //**************************************************************
  // Glass, Device: add absorbed radiation (angular part) from exterior sources
  //**************************************************************
  if incAng < 0.5*Modelica.Constants.pi then
    x := 2*(NDIR - 1)*abs(incAng)/Modelica.Constants.pi
      "x=(index-1)*incAng/(0.5pi), 0<=x<=NDIR";
    x := x + 2;
    k1 := integer(x) "2<=k<=NDIR+2=HEM+1";
    k2 := k1 + 1 "3<=k2<=NDIR+3=HEM+2";

    // Window unshaded parts: add transmitted radiation for angular radiation
    y1d := (coeTraWinExtIrr[NoShade, k1 + 1] - coeTraWinExtIrr[NoShade, k1 - 1])
      /2;
    y2d := (coeTraWinExtIrr[NoShade, k2 + 1] - coeTraWinExtIrr[NoShade, k2 - 1])
      /2;
    tmpNoSha := Modelica.Fluid.Utilities.cubicHermite(
      x,
      k1,
      k2,
      coeTraWinExtIrr[NoShade, k1],
      coeTraWinExtIrr[NoShade, k2],
      y1d,
      y2d);
    QTraUns_flow := QTraUns_flow + AWin*HDir*(1 - uSha)*tmpNoSha;

    // Window shaded parts: add transmitted radiation for angular radiation
    y1d := (coeTraWinExtIrr[Shade, k1 + 1] - coeTraWinExtIrr[Shade, k1 - 1])/2;
    y2d := (coeTraWinExtIrr[Shade, k2 + 1] - coeTraWinExtIrr[Shade, k2 - 1])/2;
    tmpSha := Modelica.Fluid.Utilities.cubicHermite(
      x,
      k1,
      k2,
      coeTraWinExtIrr[Shade, k1],
      coeTraWinExtIrr[Shade, k2],
      y1d,
      y2d);
    QTraSha_flow := QTraSha_flow + AWin*HDir*uSha*tmpSha;
  end if;

  // Assign quantities to output connectors
  QTra_flow := QTraUns_flow + QTraSha_flow;
  annotation (
    Documentation(info="<html>
The model calculates short-wave radiation through the window. 
The calculations follow the description in Wetter (2004), Appendix A.4.3.
</p>
<p>
The transmitted exterior radiation for window system includes:</p>
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
</p>

<h4>References</h4>
<ul>
<li>
Michael Wetter.<br>
<a href=\"http://simulationresearch.lbl.gov/wetter/download/mwdiss.pdf\">
Simulation-based Building Energy Optimization</a>.<br>
Dissertation. University of California at Berkeley. 2004.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
December 15, 2010, by Wangda Zuo:<br>
Separate transmittance and absorbance models from the window radiation model.
</li>
<li>
December 12, 2010, by Michael Wetter:<br>
Replaced record 
<a href=\"modelica://Buildings.HeatTransfer.Data.GlazingSystems\">
Buildings.HeatTransfer.Data.GlazingSystems</a> with the
parameters used by this model.
This was needed to integrate the radiation model into the room model.
</li>
<li>
December 10, 2010, by Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"),
    Diagram(graphics),
    Icon(graphics={Text(
          extent={{-32,-80},{22,-96}},
          lineColor={0,0,127},
          textString="uSha"), Text(
          extent={{36,10},{110,-6}},
          lineColor={0,0,127},
          textString="QTra")}));
end TransmittedRadiation;
