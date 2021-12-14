within Buildings.Utilities.Comfort;
model Fanger "Thermal comfort model according to Fanger"
extends Buildings.BaseClasses.BaseIcon;

  Modelica.Blocks.Interfaces.RealOutput PMV "PMV"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput PPD "PPD [0.05...1]"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));

  parameter Modelica.Units.SI.HeatFlux W(max=0) = 0
    "Rate of mechanical work accomplished (must be non-positive, typically equal to 0)";
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hRad(
    min=0,
    max=10) = 0.8*4.7 "Radiative heat transfer coefficient";

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

  parameter Modelica.Units.SI.Velocity vAir=0.05 "Fixed value for air velocity"
    annotation (Dialog(enable=not use_vAir_in, group="Conditional inputs"));
  parameter Modelica.Units.SI.HeatFlux M=60 "Fixed value for metabolic rate"
    annotation (Dialog(enable=not use_M_in, group="Conditional inputs"));
  parameter Real ICl = 0.7
    "Fixed value for clothing insulation in units of clo (summer=0.5; winter=0.9)"
     annotation (Dialog(enable = not use_ICl_in, group="Conditional inputs"));
  parameter Modelica.Units.SI.Pressure pAir=101325
    "Fixed value for air pressure"
    annotation (Dialog(enable=not use_pAir_in, group="Conditional inputs"));

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

  Modelica.Units.SI.Temperature TOpe "Operative temperature";
  Modelica.Units.SI.Temperature TClo(start=273.15 + 40)
    "Surface temperature of clothing";
  Modelica.Units.SI.Temperature TSki(min=273.15 + 10, max=273.15 + 42)
    "Skin temperature";

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
  Modelica.Blocks.Interfaces.RealInput vAir_in
    if use_vAir_in "Air velocity" annotation (
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

  Modelica.Units.SI.CoefficientOfHeatTransfer hCom(min=0, max=10)
    "Combined heat transfer coefficient";

  Modelica.Units.SI.CoefficientOfHeatTransfer hCon(min=0, max=10)
    "Convective heat transfer coefficient";

  Modelica.Units.SI.Pressure pSte(min=0, max=3000)
    "Partial pressure of water vapor in ambient air";

  Modelica.Units.SI.HeatFlux L "Thermal load of the body";
  Real fCl(min=0) "Clothing area factor (61)";
  Modelica.Units.SI.ThermalInsulance RCl "Thermal resistance of clothing (10)";

protected
  Buildings.Utilities.Psychrometrics.X_pTphi steRat
    "Model to compute the steam mass fraction";
  Real fCl1 "work variable for fCl";
  Real fCl2 "work variable for fCl";

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
    x=(ICl_in_internal - 0.5),
    delta=0.01);


  hCon = Buildings.Utilities.Math.Functions.smoothMax(
    x1=12.1*sqrt(abs(vAir_in_internal)),
    x2=2.38*abs(TClo - TAir)^0.25,
    deltaX=0.0001);

  hCom = hRad + hCon;

  // operative temperature (8)
  TOpe = (hRad*TRad + hCon*TAir)/hCom;

  // Clothing temperature (59)
  TClo = 35.7 - 0.028 * (M_in_internal-W) - RCl*((3.96E-8*fCl*((TClo)^4 - (TRad)^4))+ fCl*hCon*(TClo - TAir)) + 273.15;


  L = (M_in_internal - W)
       - 3.05E-3*(5733 - 6.99*(M_in_internal - W) - pSte)
        - 0.42*((M_in_internal - W) - 58.15)
        - 1.7E-5*M_in_internal*(5867 - pSte)
        - 0.0014*M_in_internal*(307.15 - TAir)
        - 3.96E-8*fCl*(TClo^4 - TRad^4)
        - fCl*hCon*(TClo - TAir);

  PMV = (0.303*Modelica.Math.exp(-0.036*M_in_internal) + 0.028)*L;
  PPD = 1 - 0.95*Modelica.Math.exp(-(0.03353*PMV^4 + 0.2179*PMV^2));

  annotation (
defaultComponentName="com",
    Documentation(info="<html>
<p>
Thermal comfort model according to Fanger, as described in
the ASHRAE Fundamentals (2017).
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
as ASHRAE Standard 55 (ASHRAE, 2017) and ISO Standard 7730 (ISO, 1994).
These standards define temperature ranges that should result in thermal satisfaction
for at least 80% of occupants in a space.
</p>
<h4> PMV thermal sensation scale</h4>
<p>
The PMV index predicts the mean value of the votes of a large group of
people on the following 7-point thermal sensation scale:
</p>
<table summary=\"summary\" border=\"1\">
<tr><td>Cold  </td><td>  Cool  </td><td>  Slightly cool  </td><td>  Neutral  </td><td>  Slightly warm  </td><td>  Warm   </td><td>  Hot </td></tr>
<tr><td>-3 </td><td> -2 </td><td> -1 </td><td> 0 </td><td> +1 </td><td> +2 </td><td> +3 </td></tr>
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
<b>Winter:</b>
activity <i>1.2</i> met,<br/>
clothing = <i>0.9</i> clo (sweater, long sleeve shirt, heavy pants),<br/>
air flow = <i>30</i> fpm (<i>0.15</i> m/sec),<br/>
mean radiant temperature equal to air temperature,<br/>
Optimum Operative Temperature (top) = <i>22.7</i>&#176; C (<i>71</i>&#176; F)
</p>
<p>
<b>Summer:</b>
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
<table summary=\"summary\" border=\"1\">
<tr><th>Clothing ensemble</th><th>clo</th></tr>
<tr><td>ASHRAE Standard 55 Winter</td><td>0.90</td></tr>
<tr><td>ASHRAE Standard 55 Summer</td><td>0.50</td></tr>
<tr><td>Walking shorts, short-sleeve shirt</td><td>  0.36</td></tr>
<tr><td>Trousers, long-sleeve shirt</td><td> 0.61</td></tr>
<tr><td>Trousers, long-sleeve shirt, suit jacket</td><td> 0.96</td></tr>
<tr><td>Trousers, long-sleeve shirt, suit jacket, T-shirt</td><td> 1.14</td></tr>
<tr><td>Trousers, long-sleeve shirt, long-sleeve sweater, T-shirt</td><td> 1.01</td></tr>
<tr><td>Same as above + suit jacket, long underwear bottoms</td><td> 1.30</td></tr>
<tr><td>Sweat pants, sweat shirt</td><td> 0.74</td></tr>
<tr><td>Knee-length skirt, short-sleeve shirt, panty hose, sandals</td><td> 0.54</td></tr>
<tr><td>Knee-length skirt, long-sleeve shirt, full slip, panty hose</td><td> 0.67</td></tr>
<tr><td>Knee-length skirt, long-sleeve shirt, half slip, panty hose, long sleeve sweater</td><td> 1.10</td></tr>
<tr><td>Long-sleeve coveralls, T-shirt</td><td>   0.72</td></tr>
<tr><td>Insulated coveralls, long-sleeve, thermal underwear, long underwear bottoms</td><td> 1.37</td></tr>
</table>
<br/>

<h4> Metabolic rates</h4>
<p>
One met is defined as <i>58.2</i> Watts per square meter which is equal to the energy produced
per unit surface area of a seated person at rest.</p>
<p>The following table is obtained from ASHRAE page 8.6.</p>
<table summary=\"summary\" border=\"1\">
<tr><th>Activity</th><th>W/m2 body surface area</th></tr>
<tr><td>ASHRAE Standard 55</td><td>58.2</td></tr>
<tr><td> reclining  </td><td>45</td></tr>
<tr><td> seated and quiet </td><td>60</td></tr>
<tr><td> sedentary activity (reading, writing) </td><td>60</td></tr>
<tr><td> standing, relaxed </td><td>70</td></tr>
<tr><td> office (filling while standing)</td><td>80</td></tr>
<tr><td> office (walking)</td><td>100</td></tr>
<tr><td>Sleeping</td><td>         40     </td></tr>
<tr><td>Seated quiet</td><td>   60 </td></tr>
<tr><td>Standing Relaxed</td><td>  70  </td></tr>
<tr><td>Walking 3.2 - 6.4km/h</td><td> 115-220   </td></tr>
<tr><td>Reading</td><td> 55</td></tr>
<tr><td>Writing</td><td> 60</td></tr>
<tr><td>Typing</td><td> 65</td></tr>
<tr><td>Lifting/packing</td><td>  120</td></tr>
<tr><td>Driving Car</td><td> 60-115</td></tr>
<tr><td>Driving Heavy vehicle</td><td> 185</td></tr>
<tr><td>Cooking</td><td> 95-115</td></tr>
<tr><td>Housecleaning</td><td> 115-200</td></tr>
<tr><td>Machine work</td><td> 105-235</td></tr>
<tr><td>Pick and shovel work</td><td> 235-280</td></tr>
<tr><td>Dancing-Social</td><td> 140-225</td></tr>
<tr><td>Calisthenics</td><td>  175-235</td></tr>
<tr><td>Basketball</td><td>  290-440</td></tr>
<tr><td>Wrestling</td><td>  410-505</td></tr>
</table>
<br/>
<h4>References</h4>

<ul><li>
ANSI/ASHRAE Standard 55-2017:Thermal Environmental Conditions for Human Occupancy.
 American Society of Heating, Refrigerating and Air-Conditioning Engineers,2017.
</li>
<li>
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
</ul>

</html>", revisions="<html>
<ul>
<li>
May 27, 2020, by Donghun Kim and Michael Wetter:<br/>
Updated model equations to ANSI/ASHRAE Standard 55-2017.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1936\">#1936</a>.
</li>
<li>
May 30, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
Added default value for <code>ICl</code>.
</li>
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
          textColor={0,0,255},
          textString="TAir"),
        Text(
          extent={{-100,68},{-38,48}},
          textColor={0,0,255},
          textString="TRad"),
        Text(
          visible=use_vAir_in,
          extent={{-106,0},{-44,-20}},
          textColor={0,0,255},
          textString="vAir"),
        Text(
          visible=use_M_in,
          extent={{-114,-30},{-52,-50}},
          textColor={0,0,255},
          textString="M"),
        Text(
          extent={{-100,32},{-50,10}},
          textColor={0,0,255},
          textString="phi"),
        Text(
          visible=use_pAir_in,
          extent={{-104,-84},{-48,-100}},
          textColor={0,0,255},
          textString="pAir"),
        Text(
          visible=use_ICl_in,
          extent={{-108,-62},{-52,-78}},
          textColor={0,0,255},
          textString="ICl"),
        Text(
          extent={{40,48},{102,28}},
          textColor={0,0,255},
          textString="PMV"),
        Text(
          extent={{44,-34},{106,-54}},
          textColor={0,0,255},
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
          smooth=Smooth.None)}));
end Fanger;
