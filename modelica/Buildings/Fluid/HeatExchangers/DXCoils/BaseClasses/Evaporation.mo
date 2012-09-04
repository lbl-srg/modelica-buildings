within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
model Evaporation
  "Model that computes evaporation of water that accumulated on the coil surface"
  extends Modelica.Blocks.Interfaces.BlockIcon;
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialCondensingGases "Medium model"
     annotation (choicesAllMatching=true);

  parameter
    Buildings.Fluid.HeatExchangers.DXCoils.Data.BaseClasses.NominalValues
     nomVal "Nominal values"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

    parameter Medium.MassFlowRate mAir_flow_small(min=0) = 0.1*abs(nomVal.m_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));

  final parameter Modelica.SIunits.Mass mMax(min=0, fixed=false)
    "Maximum mass of water that can accumulate on the coil";

  Modelica.SIunits.Mass m(start=0, nominal=-5000*1400/2257E3)
    "Mass of water that accumulated on the coil";

  ////////////////////////////////////////////////////////////////////////////////
  // Input and output signals
  Modelica.Blocks.Interfaces.BooleanInput on
    "Control signal, true if compressor is on"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}})));
  Modelica.Blocks.Interfaces.RealInput mWat_flow(final quantity="MassFlowRate",
                                                 final unit = "kg/s")
    "Water flow rate added into the medium"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}, rotation=
           0)));
  Modelica.Blocks.Interfaces.RealInput TWat(final quantity="Temperature",
                                            final unit = "K",
                                            displayUnit = "degC")
    "Temperature of liquid that is drained from or injected into volume"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}},
          rotation=0)));
  Modelica.Blocks.Interfaces.RealInput mAir_flow(final quantity="MassFlowRate",
                                                 final unit = "kg/s")
    "Air mass flow rate"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}})));
  Modelica.Blocks.Interfaces.RealInput XOut(min=0, max=1, unit="1")
    "Water mass fraction at coil outlet"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));

  Modelica.Blocks.Interfaces.RealInput TOut(final quantity="Temperature",
                                            final unit="K",
                                            displayUnit="degC")
    "Coil outlet temperature"
    annotation (Placement(transformation(extent={{-140,-120},{-100,-80}})));

  Modelica.Blocks.Interfaces.RealOutput mEva_flow(final quantity="MassFlowRate",
                                                  final unit = "kg/s",
                                                  max=0)
    "Moisture mass flow rate that evaporates into air stream"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  ////////////////////////////////////////////////////////////////////////////////
  // Protected parameters and variables
protected
  final parameter Modelica.SIunits.HeatFlowRate QSen_flow_nominal(max=0, fixed=false)
    "Nominal sensible heat flow rate (negative number)";
  final parameter Modelica.SIunits.HeatFlowRate QLat_flow_nominal(max=0, fixed=false)
    "Nominal latent heat flow rate (negative number)";

  final parameter Modelica.SIunits.MassFraction XIn_nominal(fixed=false)
    "Mass fraction at nominal inlet conditions";

   final parameter Modelica.SIunits.Temperature TOut_nominal(fixed=false)
    "Nominal outlet temperature";

   final parameter Modelica.SIunits.MassFraction XOut_nominal(fixed=false)
    "Mass fraction at nominal outlet conditions";

  final parameter Modelica.SIunits.MassFraction XOutSat_nominal(fixed=false)
    "Saturated mass fraction at nominal outlet temperature";

  final parameter Medium.ThermodynamicState stateIn_nominal=
    if Medium.nX == 1 then
      Medium.ThermodynamicState(p=nomVal.p_nominal,
                                T=nomVal.TIn_nominal,
                                X={XIn_nominal}) else
      Medium.ThermodynamicState(p=nomVal.p_nominal,
                                T=nomVal.TIn_nominal,
                                X={XIn_nominal,1-XIn_nominal})
    "Thermodynamic state at the nominal inlet condition";

  parameter Modelica.SIunits.SpecificEnthalpy h_fg(fixed=false)
    "Latent heat of vaporization";
  parameter Real gammaMax(min=0, fixed=false) "Maximum value for gamma";
  parameter Real logArg(min=0, fixed=false) "Argument for the log function";
  parameter Real K(min=0, fixed=false)
    "Coefficient used for convective mass transfer";
  parameter Real K2(min=0, fixed=false)
    "Coefficient used for convective mass transfer";

  Modelica.SIunits.MassFraction XOutSat
    "Saturated mass fraction at outlet temperature";

   // off = not on is required because Dymola 2013 fails during model
   // check if the on, which is an input connector, is used in the edge() function
  Boolean off=not on "Signal, true when component is off";

initial equation
  QSen_flow_nominal=nomVal.SHR_nominal * nomVal.Q_flow_nominal;
  QLat_flow_nominal=nomVal.Q_flow_nominal-QSen_flow_nominal;
  h_fg = Medium.enthalpyOfVaporization(nomVal.TIn_nominal);

  mMax = -QLat_flow_nominal * nomVal.tWet/h_fg;

  XIn_nominal=Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi(
     pSat=Medium.saturationPressure(nomVal.TIn_nominal),
     p=nomVal.p_nominal,
     phi=nomVal.phiIn_nominal);

  // Nominal outlet conditions
  TOut_nominal = nomVal.TIn_nominal + QSen_flow_nominal/nomVal.m_flow_nominal/
     Medium.specificHeatCapacityCp(stateIn_nominal);
  XOut_nominal =
      (XIn_nominal * h_fg + QLat_flow_nominal/nomVal.m_flow_nominal)/h_fg;

  XOutSat_nominal= Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi(
       pSat=Medium.saturationPressure(TOut_nominal),
       p=nomVal.p_nominal,
       phi=1);
  gammaMax = 0.8 * nomVal.m_flow_nominal * (XOutSat_nominal-XOut_nominal) * h_fg / (-QLat_flow_nominal);
  if (nomVal.gamma > gammaMax) then
     Modelica.Utilities.Streams.print("Warning: In DX coil model, gamma is too large for these coil conditions.
  Instead of gamma = " + String(nomVal.gamma) + ", a value of " + String(gammaMax) + ", which 
  corresponds to a mass transfer effectiveness of 0.8, will be used.\n");
  end if;
  logArg = 1+min(nomVal.gamma, gammaMax)*QLat_flow_nominal/nomVal.m_flow_nominal/h_fg/
          (XOutSat_nominal-XOut_nominal);

  K = -Modelica.Math.log(logArg);
  K2 = K/mMax*nomVal.m_flow_nominal^(-0.2);

  assert(QLat_flow_nominal < 0, "QLat_nominal must be a negative number. Check parameters.");
  assert(XOut_nominal < XOutSat_nominal, "Require xOut_nominal < xOutSat_nominal, but obtained more than 100% relative humidity at outlet at nominal conditions.
    nomVal.m_flow_nominal = " + String(nomVal.m_flow_nominal) + "
    SHR_nominal           = " + String(nomVal.SHR_nominal) + "
    QLat_flow_nominal     = " + String(QLat_flow_nominal) + "
    XIn_nominal           = " + String(XIn_nominal) + "
    XOut_nominal          = " + String(XOut_nominal) + "
    XOutSat_nominal       = " + String(XOutSat_nominal) + "
    TOut_nominal          = " + String(TOut_nominal) + "
  Check parameters. Maybe the sensible heat ratio is too big, or the mass flow rate too small.");
  assert(logArg > 0, "Require '1+nomVal.gamma*QLat_flow_nominal/nomVal.m_flow_nominal/h_fg/(XOutSat_nominal-XOut_nominal)>0' at nominal conditions.
    but received " + String(logArg) + "
    The parameter are:
    nomVal.m_flow_nominal = " + String(nomVal.m_flow_nominal) + "
    SHR_nominal           = " + String(nomVal.SHR_nominal) + "
    QLat_flow_nominal     = " + String(QLat_flow_nominal) + "
    XIn_nominal           = " + String(XIn_nominal) + "
    XOut_nominal          = " + String(XOut_nominal) + "
    XOutSat_nominal       = " + String(XOutSat_nominal) + "
    TOut_nominal          = " + String(TOut_nominal) + "
  Check parameters. Maybe the sensible heat ratio is too big, or the mass flow rate too small.");
  assert(K > 0, "Require K>0 but received " + String(K) + "
    The parameter are:
    nomVal.m_flow_nominal = " + String(nomVal.m_flow_nominal) + "
    SHR_nominal           = " + String(nomVal.SHR_nominal) + "
    QLat_flow_nominal     = " + String(QLat_flow_nominal) + "
    XIn_nominal           = " + String(XIn_nominal) + "
    XOut_nominal          = " + String(XOut_nominal) + "
    XOutSat_nominal       = " + String(XOutSat_nominal) + "
    TOut_nominal          = " + String(TOut_nominal) + "
  Check parameters. Maybe the sensible heat ratio is too big, or the mass flow rate too small.");
equation
  // When the coil switches off, set accumulated water to
  // lower value of actual accumulated water or maximum water content
  when edge(off) then
    reinit(m, min(m, mMax));
  end when;

  if on then
    XOutSat = 0;
    mEva_flow = 0;
    der(m) = -mWat_flow;
  else
    XOutSat = Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi(
      pSat=Medium.saturationPressure(TOut),
      p=nomVal.p_nominal,
      phi=1);
    mEva_flow = smooth(1, noEvent(-(XOutSat-XOut) *
      Buildings.Utilities.Math.Functions.spliceFunction(
       pos=if abs(mAir_flow) > mAir_flow_small/3 then
          abs(mAir_flow) * (1-Modelica.Math.exp(-K2*m*abs(mAir_flow)^(-0.2))) else 0,
       neg=K2*mAir_flow_small^(-0.2)*m*mAir_flow^2,
       x=abs(mAir_flow)- 2*mAir_flow_small/3,
       deltax=2*mAir_flow_small/6)));
    der(m) = mEva_flow;
  end if;

  annotation (defaultComponentName="eva",
  Documentation(info="<html>
<p>
This model computes the water accumulation on the surface of a cooling coil.
When the cooling coil operates, water is accumulated on the coil surface
up to a maximum amount of water before water starts to drain away
from the coil.
When the coil is off, the accumulated water evaporates into
the air stream.
</p>
<h4>Physical description</h4>
<p>
The calculations are based on Shirey et al. (2006).
</p>
<h5>Parameters</h5>
<p>
The maximum amount of water that can be accumulated is computed
based on the following model, where we used the convention that latent heat
removed from the air is negative:
The parameter <i>t<sub>wet</sub></i>
defines how long it takes for condensate to drip of the coil, assuming the
coil starts completely dry and operates at the nominal operating point.
Henderson et al. (2003) measured values for 
<i>t<sub>wet</sub></i>
from <i>16.5</i> minutes (<i>990</i> seconds) to 
<i>29</i> minutes (<i>1740</i> seconds). 
Thus, we use a default value of <i>t<sub>wet</sub>=1400</i> seconds.
The maximum amount of water that can accumulate on the coil is
<p align=\"center\" style=\"font-style:italic;\">
  m<sub>max</sub> = -Q&#775;<sub>L,nom</sub> &nbsp; t<sub>wet</sub> &frasl; h<sub>fg</sub> 
</p>
where
<i>Q&#775;<sub>L,nom</sub>&lt;0</i> is the latent capacity at the nominal conditions and
<i>h<sub>fg</sub></i> is the latent heat of evaporation.
</p>
<p>
When the coil is off, the water that has been accumulated on the coil 
evaporates into the air. The rate of water vapor evaporation at nominal operating
conditions is defined by the parameter <i>&gamma;<sub>nom</sub></i>. The definition of
<i>&gamma;<sub>nom</sub></i> is
<p align=\"center\" style=\"font-style:italic;\">
  &gamma;<sub>nom</sub> = Q&#775;<sub>e,nom</sub> &frasl; Q&#775;<sub>L,nom</sub>,
</p>
where 
<i>Q&#775;<sub>e,nom</sub>&lt;0</i> is the rate of evaporation from the coil surface into 
the air stream right after the coil is switched off.
The default value is <i>&gamma;<sub>nom</sub> = 1.5</i>.
</p>
<h5>Time dependent calculations</h5>
<p>
First, we discuss the accumulation of water on the coil.
The rate of water accumulation is computed as
<p align=\"center\" style=\"font-style:italic;\">
  dm(t)&frasl;dt = -m&#775;<sub>wat</sub>(t)
</p>
where
<i>m&#775;<sub>wat</sub>(t) &le; 0</i> is the water vapor mass flow rate that is extracted
from the air at the current operating conditions.
The actual water vapor mass flow rate that is removed 
from the air stream is as computed by the steady-state 
cooling coil performance model
because for the coil outlet conditions, it does not matter whether the water
accumulates on the coil or drips away from the coil.
The initial value for the water accumulation is zero at the start of the simulation, and
set to whatever water remains after the coil has been switched off and 
the water partially or completely evaporated into the air stream.
</p>
<p>
Now, we discuss the evaporation of the water on the coil surface into the air
when the coil is off.
The model in Shirey et al. (2006) is based on the assumption that the wet coil acts
as an evaporative cooler.
The change of water on the coil is
</p>
<p align=\"center\" style=\"font-style:italic;\">
  dm(t)&frasl;dt = -m&#775;<sub>max</sub>(t) &eta;(t),
</p>
<p>
where
<i>m&#775;<sub>max</sub>(t) &gt; 0</i> is 
the maximum water mass flow rate from the coil to the air and
<i>&eta;(t) &isin; [0, 1]</i> is the mass transfer effectiveness.
For an evaporative cooler, 
</p>
<p align=\"center\" style=\"font-style:italic;\">
  &eta;(t) = 1-exp(-NTU(t)),
</p>
where
<i>NTU(t)=(hA)<sub>m</sub>/C&#775;<sub>a</sub></i> are the number of mass transfer units and 
<i>C&#775;<sub>a</sub></i> is the air capacity flow rate.
The mass transfer coefficient <i>(hA)<sub>m</sub></i>
is assumed to be proportional to the wet coil area, which
is assumed to be equal to the ratio <i>m(t) &frasl; m<sub>max</sub>(t)</i>.
Hence,
</p>
<p align=\"center\" style=\"font-style:italic;\">
  (hA)<sub>m</sub>(t) &prop; m(t) &frasl; m<sub>max</sub>(t).
</p>
<p>
Furthermore, the mass transfer coefficient depends on the velocity, and 
hence mass flow rate, as
</p>
<p align=\"center\" style=\"font-style:italic;\">
  (hA)<sub>m</sub>(t) &prop; m&#775;<sub>a</sub>(t)<sup>0.8</sup>,
</p>
<p>
where
<i>m&#775;<sub>a</sub>(t)</i> is the current air mass flow rate,
from which follows that
</p>
<p align=\"center\" style=\"font-style:italic;\">
  NTU(t) &prop; m&#775;<sub>a</sub>(t)<sup>-0.2</sup>.
</p>
<p>
Therefore, the water mass flow rate from the coil into the
air stream is
</p>
<p align=\"center\" style=\"font-style:italic;\">
  m&#775;<sub>wat</sub>(t) = m&#775;<sub>max</sub>(t) 
  (1-exp(-K  
          (m(t) &frasl; m<sub>tot</sub>)
          (m&#775;<sub>a</sub>(t) &frasl; m&#775;<sub>a,nom</sub>)<sup>-0.2</sup>

  )),
</p>
<p>
where
<i>K &gt; 0</i> is a constant to be determined below
and the rate of change of water on the coil surface is as before
</p>
<p align=\"center\" style=\"font-style:italic;\">
  dm(t)&frasl;dt = -m&#775;<sub>wat</sub>(t).
</p>
<p>
The maximum mass transfer is
</p>
<p align=\"center\" style=\"font-style:italic;\">
  m&#775;<sub>max</sub> = m&#775;<sub>a</sub> (x<sub>sat</sub>(T<sub>a</sub>(t)) - x<sub>a</sub>(t)),
</p>
<p>
where
<i>x<sub>sat</sub>(T<sub>a</sub>(t))</i> is the moisture content of saturated air
at the current air outlet temperature and
<i>x<sub>a</sub>(t)</i> is the moisture content of the air outlet.
</p>
<p>
The constant <i>K</i> is determined from the nominal conditions as follows:
At the nominal condition, we have
<i>m(t) &frasl; m<sub>tot</sub>=1</i> and
<i>m&#775;<sub>a</sub>(t) &frasl; m&#775;<sub>a,nom</sub>=1</i>,
and, hence,
</p>
<p align=\"center\" style=\"font-style:italic;\">
  m&#775;<sub>nom</sub> = m&#775;<sub>max,nom</sub> (1-e<sup>-K</sup>).
</p>
<p>
Because 
</p>
<p align=\"center\" style=\"font-style:italic;\">
  m&#775;<sub>nom</sub> = - &gamma; Q&#775;<sub>L,nom</sub> &frasl; h<sub>fg</sub>,
</p>
<p>
it follows that
</p>
<p align=\"center\" style=\"font-style:italic;\">
  K = -ln(    
  1 + &gamma;<sub>nom</sub> Q&#775;<sub>L,nom</sub> &frasl;
  m&#775;<sub>a,nom</sub> &frasl; h<sub>fg</sub> &frasl;
  (x<sub>sat</sub>(T<sub>a,nom</sub>)-x<sub>a,nom</sub>)
),
</p>
<p>
where
<i>x<sub>a,nom</sub></i> is the humidity ratio at the coil outlet at nominal condition and
<i>x<sub>sat</sub>(T<sub>a,nom</sub>)</i> is the humidity ratio at saturation at the coil 
outlet condition. Note that the <i>ln(&middot;)</i> in the above equation requires that the argument
is positive. See the implementation section below for how this is implemented. fixme: add section
</p>
<h4>Implementation</h4>
<h5>Potential for moisture transfer</h5>
<p>
For the potential that causes the moisture transfer, the outlet conditions have been used.
If the inlet conditions were used, then the mass transfer does not decay to zero fast enough
as the air flow rate approaches zero, which can cause supersaturated air.
</p>
<h5>Computation of mass transfer effectiveness</h5>
<p>
To evaluate
</p>
<p align=\"center\" style=\"font-style:italic;\">
  K = -ln(    
  1 + &gamma;<sub>nom</sub> Q&#775;<sub>L,nom</sub> &frasl;
  m&#775;<sub>a,nom</sub> &frasl; h<sub>fg</sub> &frasl;
  (x<sub>sat</sub>(T<sub>a,nom</sub>)-x<sub>a,nom</sub>)
),
</p>
<p>
the argument of the <i>ln(&middot;)</i> function must be positive. 
However, often the parameter <i>&gamma;<sub>nom</sub></i> is not known, and the default
value of 
<i>&gamma;<sub>nom</sub> = 1.5</i> may yield negative arguments for 
the function <i>ln(&middot;)</i>.
We therefore set a lower bound on <i>&gamma;<sub>nom</sub></i> as follows:
Note that <i>&gamma;<sub>nom</sub></i> must be such that
<i>0 &lt; m&#775;<sub>wat,nom</sub> &lt; m&#775;<sub>max,nom</sub></i>.
This condition is equivalent to
</p>
<p align=\"center\" style=\"font-style:italic;\">
  0 &lt; &gamma;<sub>nom</sub> &lt; m&#775;<sub>a,nom</sub> (x<sub>sat</sub>(T<sub>a,nom</sub>)-x<sub>a,nom</sub>)
  h<sub>fg</sub>
  &frasl; (-Q&#775;<sub>L,nom</sub>)
</p>
<p>
If <i>&gamma;<sub>nom</sub></i> were equal to the right hand side, then the
mass transfer effectiveness would be one. Hence, we set the maximum value of
&gamma;<sub>nom,max</sub> to 
</p>
<p align=\"center\" style=\"font-style:italic;\">
  &gamma;<sub>nom,max</sub> = 0.8  m&#775;<sub>a,nom</sub> (x<sub>sat</sub>(T<sub>a,nom</sub>)-x<sub>a,nom</sub>)
  h<sub>fg</sub>
  &frasl; (-Q&#775;<sub>L,nom</sub>),
</p>
<p>
which corresponds to a mass transfer effectiveness of <i>0.8</i>. If 
<i>&gamma;<sub>nom</sub> &gt; &gamma;<sub>nom,max</sub></i>, the model sets
<i>&gamma;<sub>nom</sub>=&gamma;<sub>nom,max</sub></i> and writes a warning message.
</p>
<h5>Regularization near zero air mass flow rate</h5>
<p>
To regularize the equations near zero air mass flow rate and zero humidity on the coil, the
following conditions have been imposed in such a way that the model
is once continuously differentiable with bounded derivatives on compact sets:
<ul>
<li>
We impose that 
<i>m&#775;<sub>wat</sub>(t) &rarr; 0</i> as <i>m &rarr; 0</i> 
to ensure that there is no evaporation if no water remains on the coil.
</li>
<li>
We impose that 
<i>m&#775;<sub>wat</sub>(t) &frasl; m&#775;<sub>a</sub>(t) &rarr; 0</i> 
as <i>m&#775;<sub>a</sub>(t) &rarr; 0</i> 
to ensure that the evaporation mass flow rate remains bounded at zero air flow rate
and that it is symmetric near zero without having to trigger an event.
</li>
</ul>
This is implemented by replacing for <i>|m&#775;<sub>a</sub>(t)| &lt; &delta;</i>
the equation for the evaporation mass flow rate by
</p>
<p align=\"center\" style=\"font-style:italic;\">
 m&#775;<sub>wat</sub>(t) = C m m&#775;<sub>a</sub><sup>2</sup>(t) 
 (x<sub>sat</sub>(T<sub>a,nom</sub>)-x<sub>a,nom</sub>),
</p>
<p>
where
<i>C=K &delta;<sup>-0.2</sup></i> which approximates continuity at 
<i>|m&#775;<sub>a</sub>|=&delta;</i>. Note that differentiability is ensured
because the two equations are combined using the function
<a href=\"modelica://Buildings.Utilities.Math.Functions.spliceFunction\">
Buildings.Utilities.Math.Functions.spliceFunction</a>.
Also note that based on physics, we would not have to square
<i>m&#775;<sub>a</sub></i>, but this was done to avoid an event
that would be triggered if <i>|m&#775;<sub>a</sub>|</i> would have been used.
Since the equation is active only at very small air flow rates when the fan is off,
the error is negligible for typical applications.
</p>
<h4>References</h4>
<p>
Hugh I. Henderson, Jr., Don B. Shirey III and Richard A. Raustad.
Understanding the Dehumidification Performance of Air-Conditioning Equipment at Part-Load Conditions.
<i>CIBSE/ASHRAE Conference</i>, Edinburgh, Scotland, September 2003.
</p>
<p>
Don B. Shirey III, Hugh I. Henderson, Jr. and Richard A. Raustad.
<a href=\"http://www.fsec.ucf.edu/en/publications/pdf/FSEC-CR-1537-05.pdf\">
Understanding the Dehumidification Performance of Air-Conditioning Equipment at Part-Load Conditions.</a>
Florida Solar Energy Center, Technical Report FSEC-CR-1537-05, January 2006.
</p>
</html>", revisions="<html>
<ul>
<li>
August 21, 2012 by Michael Wetter:<br>
First implementation. 
</li>
</ul>
</html>"), Diagram(graphics),
    Icon(graphics={
        Rectangle(
          extent={{-96,94},{96,-98}},
          fillPattern=FillPattern.Sphere,
          pattern=LinePattern.None,
          lineColor={255,255,255},
          fillColor={170,213,255})}));
end Evaporation;
