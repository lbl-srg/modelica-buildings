within Buildings.Fluid.HeatExchangers.HeatPumps.AirToAir.BaseClasses;
model Evaporation
  "Model that computes evaporation of water that accumulated on the coil surface"
  extends Modelica.Blocks.Interfaces.BlockIcon;
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialCondensingGases "Medium model"
     annotation (choicesAllMatching=true);

//  replaceable
parameter Buildings.Fluid.HeatExchangers.HeatPumps.AirToAir.Data.HPData                 datHP
    "Performance data";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal air mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Real SHR_nominal "Nominal sensible heat ratio"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal(max=0)
    "Nominal capacity"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature TIn_nominal=273.15+19.4
    "Entering air dry-bulb temperature at rating condition"
      annotation(Dialog(tab="General",group="Nominal condition"));
  parameter Modelica.SIunits.Time tWet = 1400
    "Time until moisture drips from coil when a dry coil is switched on"
     annotation(Dialog(tab="General",group="Re-evaporation data"));
  parameter Real gamma(min=0) = 1.5
    "Ratio of evaporation heat transfer divided by latent heat transfer at nominal conditions"
     annotation(Dialog(tab="General",group="Re-evaporation data"));
  parameter Modelica.SIunits.Pressure p_nominal=101325
    "Inlet air nominal pressure"
    annotation(Dialog(tab="General",group="Nominal condition"));
  parameter Real phiIn_nominal= 0.5
    "Relative humidity of entering air at nominal condition"
      annotation(Dialog(tab="General",group="Nominal condition"));

    parameter Medium.MassFlowRate mAir_flow_small(min=0)=
      0.1*abs(m_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));

  final parameter Modelica.SIunits.Mass mMax(min=0, fixed=false)
    "Maximum mass of water that can accumulate on the coil";

  parameter Boolean computeReevaporation=true
    "Set to true to compute reevaporation of water that accumulated on coil";

  ////////////////////////////////////////////////////////////////////////////////
  // Input and output signals
  Modelica.Blocks.Interfaces.BooleanInput on
    "Control signal, true if compressor is on"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));

  Modelica.Blocks.Interfaces.RealInput mWat_flow(final quantity="MassFlowRate",
                                                 final unit = "kg/s")
    "Water flow rate added into the medium"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}, rotation=0)));

  Modelica.Blocks.Interfaces.RealInput TWat(final quantity="ThermodynamicTemperature",
                                            final unit = "K",
                                            displayUnit = "degC")
    "Temperature of liquid that is drained from or injected into volume"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}},  rotation=0)));

  Modelica.Blocks.Interfaces.RealInput mAir_flow(final quantity="MassFlowRate",
                                                 final unit = "kg/s")
    "Air mass flow rate"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));

  Modelica.Blocks.Interfaces.RealInput XOut(
    min=0,
    max=1,
    unit="1") "Water mass fraction"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90, origin={-60,-120})));

  Modelica.Blocks.Interfaces.RealInput TOut(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Air temperature"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={60,-120})));

  Modelica.Blocks.Interfaces.RealOutput mTotWat_flow(final quantity="MassFlowRate",
                                                     final unit = "kg/s")
    "Total moisture mass flow rate into the air stream"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  output Modelica.SIunits.Mass m(start=0, nominal=-5000*1400/2257E3)
    "Mass of water that accumulated on the coil";

  output Modelica.SIunits.MassFlowRate m_flow(max=0)
    "Moisture mass flow rate that evaporates into air stream";
  ////////////////////////////////////////////////////////////////////////////////
  // Protected parameters and variables
protected
  final parameter Modelica.SIunits.HeatFlowRate QSen_flow_nominal(max=0, fixed=false)
    "Nominal sensible heat flow rate (negative number)";
  final parameter Modelica.SIunits.HeatFlowRate QLat_flow_nominal(max=0, fixed=false)
    "Nominal latent heat flow rate (negative number)";
  final parameter Modelica.SIunits.MassFraction XIn_nominal(fixed=false)
    "Mass fraction at nominal inlet conditions";
  final parameter Modelica.SIunits.MassFraction XOut_nominal(fixed=false)
    "Mass fraction at nominal outlet conditions";
  final parameter Modelica.SIunits.Temperature TOut_nominal(fixed=false)
    "Dry bulb temperature at nominal outlet conditions";
  final parameter Modelica.SIunits.Temperature TWetBulOut_nominal(fixed=false)
    "Wet bulb temperature at nominal outlet conditions";
  final parameter Modelica.SIunits.MassFraction XWetBulOut_nominal(fixed=false)
    "Water vapor mass fraction at nominal outlet wet bulb condition";
  final parameter Modelica.SIunits.MassFraction dX_nominal(max=0, fixed=false)
    "Driving potential for mass transfer";

  final parameter Modelica.SIunits.SpecificEnthalpy h_fg(fixed=false)
    "Latent heat of vaporization";
  final parameter Real gammaMax(min=0, fixed=false) "Maximum value for gamma";
  final parameter Real logArg(min=0, fixed=false)
    "Argument for the log function";
  final parameter Real K(min=0, fixed=false)
    "Coefficient used for convective mass transfer";
  final parameter Real K2(min=0, fixed=false)
    "Coefficient used for convective mass transfer";

  Modelica.SIunits.MassFraction XWetBulOut
    "Water vapor mass fraction at wet bulb conditions at air inlet";

   // off = not on is required because Dymola 2013 fails during model
   // check if on, which is an input connector, is used in the edge() function
  Boolean off=not on "Signal, true when component is off";

  Modelica.SIunits.Temperature TWetBulOut "Wet bulb temperature at coil";
  Modelica.SIunits.MassFraction dX
    "Difference in water vapor concentration that drives mass transfer";

  constant Modelica.SIunits.SpecificHeatCapacity cpAir_nominal=
     Buildings.Media.PerfectGases.Common.SingleGasData.Air.cp
    "Specific heat capacity of air";
  constant Modelica.SIunits.SpecificHeatCapacity cpSte_nominal=
     Buildings.Media.PerfectGases.Common.SingleGasData.H2O.cp
    "Specific heat capacity of water vapor";
initial equation
  QSen_flow_nominal=SHR_nominal * Q_flow_nominal;
  QLat_flow_nominal= Q_flow_nominal-QSen_flow_nominal;
  h_fg = Medium.enthalpyOfVaporization( TIn_nominal);

  mMax = -QLat_flow_nominal *  tWet/h_fg;

  XIn_nominal=Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi(
     pSat=Medium.saturationPressure(TIn_nominal),
     p=p_nominal,
     phi=phiIn_nominal);
  XOut_nominal = XIn_nominal + QLat_flow_nominal/m_flow_nominal/h_fg;

  // Compute outlet air temperature
  TOut_nominal =
  (TIn_nominal*Medium.specificHeatCapacityCp(
      Medium.setState_pTX(p=p_nominal,
                          T=TIn_nominal,
                          X=cat(1, {XIn_nominal, 1-sum(XIn_nominal)})))
     + QSen_flow_nominal/m_flow_nominal)
     / Medium.specificHeatCapacityCp(
      Medium.setState_pTX(p=p_nominal,
                          T=TIn_nominal,
                          X=cat(1, {XOut_nominal, 1-sum(XOut_nominal)})));
  // Compute wet bulb temperature.
  // The computation of the wet bulb temperature requires an iterative
  // solution. It therefore cannot be done in a function.
  // The block Buildings.Utilities.Psychrometrics.WetBul_pTX
  // implements the equation below, but it cannot
  // be used here because blocks cannot be used to assign parameter
  // values.
  XWetBulOut_nominal   = Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi(
      pSat=  Medium.saturationPressureLiquid(Tsat=TWetBulOut_nominal),
      p=     p_nominal,
      phi=   1);
  TWetBulOut_nominal = (TOut_nominal
       * ((1-XOut_nominal) * cpAir_nominal + XOut_nominal * cpSte_nominal)
       + (XOut_nominal-XWetBulOut_nominal) * h_fg)/
            ( (1-XWetBulOut_nominal)*cpAir_nominal + XWetBulOut_nominal * cpSte_nominal);

  // Potential difference in moisture concentration that drives mass transfer at nominal condition
  dX_nominal = XOut_nominal-XWetBulOut_nominal;
    if (dX_nominal > 1E-10) then
      Modelica.Utilities.Streams.print("Warning: In the model, dX_nominal = " + String(dX_nominal) + "
        This means that there is no dehumidification of air at the nominal conditions.
        Check nominal parameters.");
    end if;

  gammaMax = 0.8 * m_flow_nominal * dX_nominal * h_fg / QLat_flow_nominal;

  // If gamma is bigger than a maximum value, write a warning and then
  // use the smaller value.

   if ( gamma > gammaMax) then
//                               Modelica.Utilities.Streams.print("Show Error");
      Modelica.Utilities.Streams.print("Warning: In the model, gamma is too large for these conditions.
   Instead of gamma = " + String( gamma) + ", a value of " + String(gammaMax) + ", which 
   corresponds to a mass transfer effectiveness of 0.8, will be used.
   Coil nominal performance data are:
     m_flow_nominal = " + String(m_flow_nominal) + "
    dX_nominal = XOut_nominal-XWetBulOut_nominal = " + String(XOut_nominal) + " - " +
       String(XWetBulOut_nominal) + " = " + String(dX_nominal) + "
    QLat_flow_nominal  = " + String(QLat_flow_nominal) + "\n");
   end if;

  logArg = 1-min( gamma, gammaMax)*QLat_flow_nominal/m_flow_nominal/h_fg/dX_nominal;

  K = -Modelica.Math.log(logArg);
  K2 = K/mMax*m_flow_nominal^(-0.2);

  assert(QLat_flow_nominal < 0, "QLat_nominal must be a negative number. Check parameters.");

   assert(K > 0, "Require K>0 but received " + String(K) + "
     The parameter are:
     QSen_flow_nominal     = " + String(QSen_flow_nominal) + "
     QLat_flow_nominal     = " + String(QLat_flow_nominal) + "
     XOut_nominal        = " + String(XOut_nominal) + "
   Check nominal parameters. Maybe the sensible heat ratio is too big, or the mass flow rate too small.");

equation
  // When the coil switches off, set accumulated water to
  // lower value of actual accumulated water or maximum water content
  if computeReevaporation then
    when edge(off) then
      reinit(m, min(m, mMax));
    end when;

    if on then
      dX = 0;
      m_flow = 0;
      mTotWat_flow = mWat_flow;
      der(m) = -mWat_flow;
      TWetBulOut = 293.15;
      XWetBulOut = 0;
    else
      // Compute wet bulb temperature.
      // The computation of the wet bulb temperature requires an iterative
      // solution. It therefore cannot be done in a function.
      // The block Buildings.Utilities.Psychrometrics.WetBul_pTX
      // implements the equation below, but it is not used here
      // because otherwise, in each branch of the if-then construct,
      // an iteration would be done. This would be inefficient because
      // the wet bulb conditions are only needed in this branch.
      XWetBulOut = Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi(
        pSat=  Medium.saturationPressureLiquid(Tsat=TWetBulOut),
        p=     p_nominal,
        phi=   1);
      TWetBulOut = (TOut * ((1-XOut) * cpAir_nominal + XOut * cpSte_nominal)
         + (XOut-XWetBulOut) * h_fg)/
              ( (1-XWetBulOut)*cpAir_nominal + XWetBulOut * cpSte_nominal);

      dX = smooth(1, noEvent(
         Buildings.Utilities.Math.Functions.spliceFunction(
         pos=XOut,
         neg=XWetBulOut,
         x=abs(mAir_flow)-m_flow_nominal/2,
         deltax=m_flow_nominal/3)))
        - XWetBulOut;
      m_flow = -smooth(1, noEvent(dX *
        Buildings.Utilities.Math.Functions.spliceFunction(
         pos=if abs(mAir_flow) > mAir_flow_small/3 then
            abs(mAir_flow) * (1-Modelica.Math.exp(-K2*m*abs(mAir_flow)^(-0.2))) else 0,
         neg=K2*mAir_flow_small^(-0.2)*m*mAir_flow^2,
         x=abs(mAir_flow)- 2*mAir_flow_small/3,
         deltax=2*mAir_flow_small/6)));
      der(m) = -m_flow;
      mTotWat_flow = mWat_flow + m_flow;
    end if;

  else // The model is configured to not compute reevaporation
    dX = 0;
    m_flow = 0;
    mTotWat_flow = mWat_flow;
    m = 0;
    TWetBulOut = 293.15;
    XWetBulOut = 0;
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
  m&#775;<sub>max</sub> = m&#775;<sub>a</sub> (x<sub>wb</sub>(t) - x(t)),
</p>
<p>
where
<i>x<sub>wb</sub>(t)</i> is the moisture content of air
at the wet bulb state and
<i>x(t)</i> is the actual moisture content of the air.
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
  (x<sub>wb,nom</sub>-x<sub>nom</sub>)
),
</p>
<p>
where
<i>x<sub>nom</sub></i> is the humidity ratio at the coil at nominal condition and
<i>x<sub>wb,nom</sub></i> is the humidity ratio at the wet bulb condition. 
Note that the <i>ln(&middot;)</i> in the above equation requires that the argument
is positive. See the implementation section below for how this is implemented.
</p>
<h4>Implementation</h4>
<h5>Potential for moisture transfer</h5>
<p>
For the potential that causes the moisture transfer,
the difference in mass fraction between the current 
coil air and the coil air at the wet bulb conditions is used, provided that
the air mass flow rate is within <i>1&frasl;3</i> of the nominal mass flow rate.
For smaller air mass flow rates, the outlet conditions are used to ensure that
the outlet conditions are not supersaturated air.
The transition between these two driving potential is continuously differentiable 
in the mass flow rate.
</p>
<h5>Computation of mass transfer effectiveness</h5>
<p>
To evaluate
</p>
<p align=\"center\" style=\"font-style:italic;\">
  K = -ln(    
  1 + &gamma;<sub>nom</sub> Q&#775;<sub>L,nom</sub> &frasl;
  m&#775;<sub>a,nom</sub> &frasl; h<sub>fg</sub> &frasl;
  (x<sub>wb,nom</sub>-x<sub>nom</sub>)
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
  0 &lt; &gamma;<sub>nom</sub> &lt; m&#775;<sub>a,nom</sub> (x<sub>wb,nom</sub>-x<sub>nom</sub>)
  h<sub>fg</sub>
  &frasl; (-Q&#775;<sub>L,nom</sub>)
</p>
<p>
If <i>&gamma;<sub>nom</sub></i> were equal to the right hand side, then the
mass transfer effectiveness would be one. Hence, we set the maximum value of
&gamma;<sub>nom,max</sub> to 
</p>
<p align=\"center\" style=\"font-style:italic;\">
  &gamma;<sub>nom,max</sub> = 0.8  m&#775;<sub>a,nom</sub> (x<sub>wb,nom</sub>-x<sub>nom</sub>)
  h<sub>fg</sub>
  &frasl; Q&#775;<sub>L,nom</sub>,
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
 (x<sub>wb,nom</sub>-x<sub>nom</sub>),
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
</html>"), Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},
            {100,100}}),
                   graphics),
    Icon(graphics={
        Rectangle(
          extent={{-96,94},{96,-98}},
          fillPattern=FillPattern.Sphere,
          pattern=LinePattern.None,
          lineColor={255,255,255},
          fillColor={170,213,255})}));
end Evaporation;
