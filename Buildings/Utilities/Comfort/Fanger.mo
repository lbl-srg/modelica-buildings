within Buildings.Utilities.Comfort;
model Fanger "Thermal comfort model according to Fanger"
extends Buildings.BaseClasses.BaseIcon;

  Modelica.Blocks.Interfaces.RealOutput PMV "PMV"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput PPD "PPD [0.05...1]"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));

  parameter Modelica.SIunits.HeatFlux W(max=0)=0
    "Rate of mechanical work accomplished (must be non-positive, typically equal to 0)";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer hRad(
    min=0,
    max=10)=0.8*4.7 "Radiative heat transfer coefficient";

  parameter Boolean use_vAir_in=false
    "Get the air velocity from the input connector"
    annotation(Evaluate=true, HideResult=true,
    Dialog(group="Conditional inputs"));
  parameter Boolean use_M_in= false
    "Get the metabolic rate from the input connector"
    annotation(Evaluate=true, HideResult=true,
    Dialog(group="Conditional inputs"));
  parameter Boolean use_ICl_in= true
    "Get the clothing insulation from the input connector"
    annotation(Evaluate=true, HideResult=true,
    Dialog(group="Conditional inputs"));
  parameter Boolean use_pAir_in= false
    "Get the air pressure from the input connector"
    annotation(Evaluate=true, HideResult=true,
    Dialog(group="Conditional inputs"));

  parameter Modelica.SIunits.Velocity vAir= 0.05 "Fixed value for air velocity"
     annotation (Evaluate = true,
                Dialog(enable = not use_vAir_in, group="Conditional inputs"));
  parameter Modelica.SIunits.HeatFlux M = 60 "Fixed value for metabolic rate"
     annotation (Evaluate = true,
                Dialog(enable = not use_M_in, group="Conditional inputs"));
  parameter Real ICl
    "Fixed value for clothing insulation in units of clo (summer=0.5; winter=0.9)"
     annotation (Evaluate = true,
                Dialog(enable = not use_ICl_in, group="Conditional inputs"));
  parameter Modelica.SIunits.Pressure pAir = 101325
    "Fixed value for air pressure"
     annotation (Evaluate = true,
                Dialog(enable = not use_pAir_in, group="Conditional inputs"));

  Modelica.Blocks.Interfaces.RealInput TAir(final quantity="ThermodynamicTemperature",
                                          final unit = "K", displayUnit = "degC")
    "Air temperature"
    annotation (Placement(
        transformation(extent={{-120,90},{-100,110}})));
  Modelica.Blocks.Interfaces.RealInput TRad(final quantity="ThermodynamicTemperature",
                                          final unit = "K", displayUnit = "degC")
    "Radiation temperature"
    annotation (
      Placement(transformation(extent={{-120,50},{-100,70}}),
        iconTransformation(extent={{-120,50},{-100,70}})));

  Modelica.SIunits.Temperature TOpe "Operative temperature";
  Modelica.SIunits.Temperature TClo "Surface temperature of clothing";
  Modelica.SIunits.Temperature TSki(
    min=273.15+10,
    max=273.15+42) "Skin temperature";

  Modelica.Blocks.Interfaces.RealInput phi(min=0, max=1) "Relative humidity"
    annotation (
      Placement(transformation(extent={{-120,10},{-100,30}}),
        iconTransformation(extent={{-120,10},{-100,30}})));
  Modelica.Blocks.Interfaces.RealInput pAir_in(
    final quantity="Pressure",
    final unit="Pa",
    min=0) if use_pAir_in "Air pressure"
    annotation (Placement(transformation(extent={{-120,
            -110},{-100,-90}}), iconTransformation(extent={{-120,-110},{-100,-90}})));
  Modelica.Blocks.Interfaces.RealInput ICl_in if use_ICl_in
    "Clothing thermal resistance in clo"
    annotation (Placement(transformation(extent={{
            -120,-80},{-100,-60}}), iconTransformation(extent={{-120,-80},{-100,
            -60}})));
  Modelica.Blocks.Interfaces.RealInput vAir_in if
       use_vAir_in "Air velocity" annotation (
      Placement(transformation(extent={{-120,-20},{-100,0}}),
        iconTransformation(extent={{-120,-20},{-100,0}})));
  Modelica.Blocks.Interfaces.RealInput M_in(
    min=40,
    max=600,
    final quantity="HeatFlux",
    final unit="W/m2") if use_M_in
    "Metabolic heat generation in W/m2 (not in met)" annotation (
      Placement(transformation(extent={{-120,-50},{-100,-30}}),
        iconTransformation(extent={{-120,-50},{-100,-30}})));

  Modelica.SIunits.CoefficientOfHeatTransfer hCom(
    min=0,
    max=10) "Combined heat transfer coefficient";

  Modelica.SIunits.CoefficientOfHeatTransfer hCon(
    min=0,
    max=10) "Convective heat transfer coefficient";

  Modelica.SIunits.Pressure pSte(
    min=0,
    max=3000) "Partial pressure of water vapor in ambient air";

  Modelica.SIunits.HeatFlux L "Thermal load of the body";
  Real fCl(min=0) "Clothing area factor (61)";
  Modelica.SIunits.ThermalInsulance RCl "Thermal resistance of clothing (10)";

protected
  Buildings.Utilities.Psychrometrics.X_pTphi steRat
    "Model to compute the steam mass fraction";
  Real fCl1 "work variable for fCl";
  Real fCl2 "work variable for fCl";
  Real aux "Auxiliary variable used to eliminate common subexpressions";

  Modelica.Blocks.Interfaces.RealInput vAir_in_internal
    "Needed to connect to conditional connector";
    Modelica.Blocks.Interfaces.RealInput M_in_internal(
    min=40,
    max=600,
    final quantity="HeatFlux",
    final unit="W/m2") "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput ICl_in_internal
    "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput pAir_in_internal(
    final quantity="Pressure",
    final unit="Pa",
    min=0) "Needed to connect to conditional connector";

initial equation
 assert(W <= 0, "Parameter W must be equal to zero or negative.");
equation
  // Conditional connectors
  connect(vAir_in, vAir_in_internal);
  if not use_vAir_in then
    vAir_in_internal = vAir;
  end if;
  connect(M_in, M_in_internal);
  if not use_M_in then
    M_in_internal = M;
  end if;
  connect(ICl_in, ICl_in_internal);
  if not use_ICl_in then
    ICl_in_internal = ICl;
  end if;
  connect(pAir_in, pAir_in_internal);
  if not use_pAir_in then
    pAir_in_internal = pAir;
  end if;

  TSki = 308.85 - 0.0275*(M_in_internal - W);

  // partial pressure of steam
  connect(steRat.p_in, pAir_in_internal);
  connect(steRat.T, TAir);
  connect(steRat.phi, phi);
  pSte = Psychrometrics.Functions.pW_X(X_w=steRat.X[1], p=pAir_in_internal);

  // clothing insulation value
  RCl = 0.155 * ICl_in_internal;
  // clothing area factor
  fCl1 = 1.00 + 0.2*ICl_in_internal;
  fCl2 = 1.05 + 0.1*ICl_in_internal;

  // fcl eq (61)
  fCl = fCl1 + (fCl2 - fCl1)*Buildings.Utilities.Math.Functions.smoothHeaviside(
                                 x=(ICl_in_internal - 0.5), delta=0.01);
  // hCon, table 6, Mitchell
  hCon = 8.3*Buildings.Utilities.Math.Functions.smoothMax(x1=vAir_in_internal*vAir_in_internal,
                                                          x2=0.0375213,
                                                          deltaX=0.01)^0.3;
  hCom = hRad + hCon;

  // operative temperature (8)
  TOpe = (hRad*TRad + hCon*TAir)/hCom;

  // Clothing temperature (59)
  aux = - 3.05*(5.73 - 0.007*(M_in_internal - W) - pSte*1E-3)
        - 0.42*((M_in_internal - W) - 58.15)
        - 0.0173*M_in_internal*(5.87 - pSte*1E-3)
        - 0.0014*M_in_internal*(307.15 - TAir);

  TClo = Modelica.SIunits.Conversions.from_degC(35.7 - 0.0275 * (M_in_internal-W)
                 - RCl * (  (M_in_internal-W)
                 + aux));
  // heat load on body, see (58)
  L = (M_in_internal - W)
      - 3.96*1e-8*fCl*(TClo^4 - TRad^4)
      - fCl*hCon*(TClo - TAir)
      + aux;

  // PMV (62)
  PMV = (0.303*Modelica.Math.exp(-0.036*M) + 0.028)*L;
  // PPD (64)
  PPD = 1 - 0.95*Modelica.Math.exp(-(0.03353*PMV^4 + 0.2179*PMV^2));
  annotation (
defaultComponentName="com",
    Documentation(info="<html>
<p>
Thermal comfort model according to Fanger, as described in
the ASHRAE Fundamentals (1997).
</p>
<p>
The thermal sensation of a human being is mainly related to the thermal balance of its
body as a whole. This balance is influenced by two groups of factors, personal and
physical. The activity level and clothing thermal insulation of the subject form the
group of personal factors, while the environmental parameters: air temperature, mean
radiant temperature, air velocity, and air humidity compose the group of physical
factors. When the personal factors have been estimated and the physical factors have
been measured the thermal sensation for the body as a whole (general thermal
comfort) can be predicted by calculating the PMV index. The PPD index, obtained
from the PMV index, provides information on thermal discomfort (thermal
dissatisfaction) by predicting the percentage of people likely to feel too hot or too
cold in the given thermal environment.
</p>
<p>
The Predicted Mean Vote (PMV) model combines four physical variables 
(air temperature, air velocity, mean radiant temperature, and relative humidity), 
and two personal variables (clothing insulation and activity level) 
into an index that can be used to predict the average thermal sensation 
of a large group of people. 
</p>
<p>
To determine appropriate thermal conditions, practitioners refer to standards such 
as ASHRAE Standard 55 (ASHRAE, 1992) and ISO Standard 7730 (ISO, 1994). 
These standards define temperature ranges that should result in thermal satisfaction 
for at least 80% of occupants in a space.
</p>
<h4> PMV thermal sensation scale</h4>
<p>
The PMV index predicts the mean value of the votes of a large group of
people on the following 7-point thermal sensation scale:
</p>
<table summary=\"summary\" border=\"1\">
<TR><TD>Cold  </TD><TD>  Cool  </TD><TD>  Slightly cool  </TD><TD>  Neutral  </TD><TD>  Slightly warm  </TD><TD>  Warm   </TD><TD>  Hot </TD></TR> 
<TR><TD>-3 </TD><TD> -2 </TD><TD> -1 </TD><TD> 0 </TD><TD> +1 </TD><TD> +2 </TD><TD> +3 </TD></TR> 
</table>

<h4>Operative temperature</h4>
<p>
For a given space there exists an optimum operative temperature corresponding to PMV=0 (neutral).
The operative temperature is defined as: The uniform temperature of an imaginary black enclosure 
in which an occupant would exchange the same amount of heat by radiation plus convection 
as in the actual nonuniform environment.
The operative temperature is computed as the average of the air temperature 
and the mean radiant temperature, weighted by their respective heat transfer coefficients
(see ASHRAE Fundamentals, 1997, page 8.3, eq (8)).
</p>

<h4>Optimum operative temperatures</h4>
<p>
<B>Winter:</B>
activity <i>1.2</i> met,<br/>
clothing = <i>0.9</i> clo (sweater, long sleeve shirt, heavy pants),<br/>
air flow = <i>30</i> fpm (<i>0.15</i> m/sec),<br/>
mean radiant temperature equal to air temperature,<br/>
Optimum Operative Temperature (top) = <i>22.7</i>&#176; C (<i>71</i>&#176; F)
</p>
<p>
<B>Summer:</B>
clothing = <i>0.5</i> clo,<br/>
air flow = <i>50</i> fpm (<i>0.25</i> m/sec),<br/>
Optimum Operative Temperature (top) = <i>24.4</i>&#176; C (<i>76</i>&#176; F).
</p>
<p>
All equation numbers in the model refer to the ASHRAE Handbook Fundamentals,
Chapter 8, Thermal Comfort, 1997.</p>

<h4>Usual ranges of variables (ISO)</h4>
<p>
M = <i>46</i> to <i>232</i> W/m^2 (<i>0.8</i> to <i>4</i> met)<br/>
ICl = <i>0</i> to <i>2</i> clo (<i>0</i> to <i>0.310</i> m^2*K/W)<br/>
TAir_degC = <i>10</i> to <i>30</i>&#176; C<br/>
TRad_degC = <i>10</i> to <i>40</i>&#176; C<br/>
vAir = <i>0</i> to <i>1</i> m/s<br/>
pSte = <i>0</i> to <i>2700</i> Pa
</p>

<h4>Insulation for clothing ensembles</h4>
<p>
Clothing is defined in terms of clo units.  Clo is a unit used to express the thermal insulation provided by garments and clothing ensembles, 
where <i>1</i> clo = <i>0.155</i> (m^2*K/W) (ASHRAE 55-92).
</p>
<p>
The following table is obtained from ASHRAE page 8.8
</p>
<TABLE  summary=\"summary\" border=\"1\">
<TR><TH>Clothing ensemble</TH><TH>clo</TH></TR>
<TR><TD>ASHRAE Standard 55 Winter</TD><TD>0.90</TD></TR>
<TR><TD>ASHRAE Standard 55 Summer</TD><TD>0.50</TD></TR>
<TR><TD>Walking shorts, short-sleeve shirt</TD><TD>  0.36</TD></TR>
<TR><TD>Trousers, long-sleeve shirt</TD><TD> 0.61</TD></TR>
<TR><TD>Trousers, long-sleeve shirt, suit jacket</TD><TD> 0.96</TD></TR>
<TR><TD>Trousers, long-sleeve shirt, suit jacket, T-shirt</TD><TD> 1.14</TD></TR>
<TR><TD>Trousers, long-sleeve shirt, long-sleeve sweater, T-shirt</TD><TD> 1.01</TD></TR>
<TR><TD>Same as above + suit jacket, long underwear bottoms</TD><TD> 1.30</TD></TR>
<TR><TD>Sweat pants, sweat shirt</TD><TD> 0.74</TD></TR>
<TR><TD>Knee-length skirt, short-sleeve shirt, panty hose, sandals</TD><TD> 0.54</TD></TR>
<TR><TD>Knee-length skirt, long-sleeve shirt, full slip, panty hose</TD><TD> 0.67</TD></TR>
<TR><TD>Knee-length skirt, long-sleeve shirt, half slip, panty hose, long sleeve sweater</TD><TD> 1.10</TD></TR>
<TR><TD>Long-sleeve coveralls, T-shirt</TD><TD>   0.72</TD></TR>
<TR><TD>Insulated coveralls, long-sleeve, thermal underwear, long underwear bottoms</TD><TD> 1.37</TD></TR>
</TABLE>
<br/>

<h4> Metabolic rates</h4>
<p>
One met is defined as <i>58.2</i> Watts per square meter which is equal to the energy produced 
per unit surface area of a seated person at rest.</p>
<p>The following table is obtained from ASHRAE page 8.6.</p>
<TABLE summary=\"summary\" border=\"1\">
<TR><TH>Activity</TH><TH>W/m2 body surface area</TH></TR>
<TR><TD>ASHRAE Standard 55</TD><TD>58.2</TD></TR>
<TR><TD> reclining  </TD><TD>45</TD></TR>
<TR><TD> seated and quiet </TD><TD>60</TD></TR>
<TR><TD> sedentary activity (reading, writing) </TD><TD>60</TD></TR>
<TR><TD> standing, relaxed </TD><TD>70</TD></TR>
<TR><TD> office (filling while standing)</TD><TD>80</TD></TR>
<TR><TD> office (walking)</TD><TD>100</TD></TR>
<TR><TD>Sleeping</TD><TD>         40     </TD></TR>
<TR><TD>Seated quiet</TD><TD>   60 </TD></TR>
<TR><TD>Standing Relaxed</TD><TD>  70  </TD></TR>
<TR><TD>Walking 3.2 - 6.4km/h</TD><TD> 115-220   </TD></TR>
<TR><TD>Reading</TD><TD> 55</TD></TR>
<TR><TD>Writing</TD><TD> 60</TD></TR>
<TR><TD>Typing</TD><TD> 65</TD></TR>
<TR><TD>Lifting/packing</TD><TD>  120</TD></TR>
<TR><TD>Driving Car</TD><TD> 60-115</TD></TR>
<TR><TD>Driving Heavy vehicle</TD><TD> 185</TD></TR>
<TR><TD>Cooking</TD><TD> 95-115</TD></TR>
<TR><TD>Housecleaning</TD><TD> 115-200</TD></TR>
<TR><TD>Machine work</TD><TD> 105-235</TD></TR>
<TR><TD>Pick and shovel work</TD><TD> 235-280</TD></TR>
<TR><TD>Dancing-Social</TD><TD> 140-225</TD></TR>
<TR><TD>Calisthenics</TD><TD>  175-235</TD></TR>
<TR><TD>Basketball</TD><TD>  290-440</TD></TR>
<TR><TD>Wrestling</TD><TD>  410-505</TD></TR>
</TABLE> 
<br/>
<h4>References</h4>

<ul><li>
ASHRAE Handbook, Fundamentals (SI Edition).
 American Society of Heating, Refrigerating and Air-Conditioning Engineers,
Chapter 8, Thermal Comfort; pages 8.1-8.26; Atlanta, USA, 1997.
</li>
<li>
International Standards Organization (ISO). 
Moderate Thermal Environments: Determination of the PMV and PPD Indices 
and Specification of the Conditions for Thermal Comfort (ISO 7730). 
Geneva, Switzerland: ISO. 1994.
</li>
<li>
Charles, K.E. Fanger Thermal Comfort and Draught Models. Institute for Research in Construction
National Research Council of Canada, Ottawa, K1A 0R6, Canada.
IRC Research Report RR-162. October 2003.
<a href=\"http://irc.nrc-cnrc.gc.ca/ircpubs\">http://irc.nrc-cnrc.gc.ca/ircpubs</a>.
</li>
<li>
Data, References and Links at: Thermal Comfort; Dr. Sam C M Hui
Department of Mechanical Engineering
The University of Hong Kong MEBS6006 Environmental Services I;
<a href=\"http://me.hku.hk/msc-courses/MEBS6006/index.html\">
http://me.hku.hk/msc-courses/MEBS6006/index.html</a>
</li>
</ul>
</html>", revisions="<html>
<ul>
<li><i>October 9, 2013</i>, by Michael Wetter:<br/>
Corrected use of conditional connector.
</li>
<li><i>July 14, 2010</i>, by Michael Wetter:<br/>
Merged models into <code>Buildings</code> library.
Fixed bug in computation of lower value for <code>hCon</code>.
The original implementation lead to too high a lower value.
</li>
<li><i>August 2, 2005</i>
Revised model, fixed bug in computing clothing surface temperature, changed various
other computations, changed parameter and input to model, set clothing insulation value as input
rather than computing it in model, added model to UTC library.
</li>
<li><i>June, 2005</i>
       Michael Wetter and Sorin Costiner:<br/>
       Improved version, added PPDDraft, TOpe, performed studies
</li>
<li><i>March 03, 2005</i>
       Michael Wetter and Sorin Costiner:<br/>
       First implementation.
</li>
</ul>
</html>"), Icon(graphics={
        Rectangle(
          extent={{100,100},{-100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-108,100},{-46,80}},
          lineColor={0,0,255},
          textString="TAir"),
        Text(
          extent={{-100,68},{-38,48}},
          lineColor={0,0,255},
          textString="TRad"),
        Text(
          visible=use_vAir_in,
          extent={{-106,0},{-44,-20}},
          lineColor={0,0,255},
          textString="vAir"),
        Text(
          visible=use_M_in,
          extent={{-114,-30},{-52,-50}},
          lineColor={0,0,255},
          textString="M"),
        Text(
          extent={{-100,32},{-50,10}},
          lineColor={0,0,255},
          textString="phi"),
        Text(
          visible=use_pAir_in,
          extent={{-104,-84},{-48,-100}},
          lineColor={0,0,255},
          textString="pAir"),
        Text(
          visible=use_ICl_in,
          extent={{-108,-62},{-52,-78}},
          lineColor={0,0,255},
          textString="ICl"),
        Text(
          extent={{40,48},{102,28}},
          lineColor={0,0,255},
          textString="PMV"),
        Text(
          extent={{44,-34},{106,-54}},
          lineColor={0,0,255},
          textString="PPD"),
        Line(
          points={{-50,42},{-50,-38}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{50,-38},{-50,-38}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-44,30},{-30,24},{-22,10},{-18,-14},{-6,-20},{2,-20},{8,-16},
              {12,-12},{16,6},{24,24},{38,30}},
          color={255,0,0},
          smooth=Smooth.None)}),
    Diagram(graphics));
end Fanger;
