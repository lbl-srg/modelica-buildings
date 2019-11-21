within Buildings.Fluid.Chillers.BaseClasses;
block AbsorptionIndirect
  "Absorption indirect chiller performance curve method"
  extends Modelica.Blocks.Icons.Block;

  parameter  Buildings.Fluid.Chillers.Data.AbsorptionIndirect.Generic per
    "Performance data"
     annotation (choicesAllMatching = true,Placement(transformation(extent={{56,74},{76,94}})));
  parameter Modelica.SIunits.HeatFlowRate Q_flow_small = - per.QEva_flow_nominal*1E-9
    "Small value for heat flow rate or power, used to avoid division by zero";
  parameter Modelica.SIunits.SpecificEnthalpy hfg = 2201
    "Latent heat of steam at 2 bar absolute pressure";
  parameter Modelica.SIunits.TemperatureDifference DelTSubCoo= 2
    "Sub cooling temperature difference";
  parameter Modelica.SIunits.SpecificHeatCapacity cpWat=4187
    "Specific heat of water(j/kg.K)";

  Modelica.Blocks.Interfaces.RealInput TConEnt(final unit="K", displayUnit="degC")
    "Condenser entering water temperature"
     annotation (Placement(transformation(extent={{-124,28},{-100,52}}),iconTransformation(extent={{-120,24},
            {-100,44}})));
  Modelica.Blocks.Interfaces.RealInput TEvaLvg(final unit="K", displayUnit="degC")
    "Evaporator leaving water temperature in degC"
     annotation (Placement(transformation(extent={{-124,
            -92},{-100,-68}}),      iconTransformation(extent={{-120,-84},{-100,
            -64}})));
  Modelica.Blocks.Interfaces.RealInput TConLvg(final unit="K", displayUnit="degC")
    "Condenser leaving water temperature in degC"
     annotation (Placement(transformation(
          extent={{-124,68},{-100,92}}), iconTransformation(extent={{-120,62},{
            -100,82}})));
  Modelica.Blocks.Interfaces.RealInput QEvaFloSet(final unit="W")
    "Evaporator setpoint heat flow rate"
     annotation (Placement(transformation(
          extent={{-124,-52},{-100,-28}}), iconTransformation(extent={{-120,-44},
            {-100,-24}})));
  Modelica.Blocks.Interfaces.RealOutput QCon_flow(final unit="W")
    "Condenser heat flow rate "
     annotation (Placement(transformation(extent={{100,
            50},{120,70}}), iconTransformation(extent={{100,70},{120,90}})));
  Modelica.Blocks.Interfaces.RealOutput QEva_flow(final unit="W")
    "Evaporator heat flow rate"
     annotation (Placement(transformation(extent={{100,
            -70},{120,-50}}), iconTransformation(extent={{100,-84},{120,-64}})));
  Modelica.Blocks.Interfaces.RealOutput QGen_flow(final unit="J/s")
    "Generator heat flow rate"
     annotation (Placement(transformation(extent={{100,-10},
            {120,10}}),       iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput P(final unit="W")
    "Chiller pumping power"
     annotation (Placement(transformation(extent={{100,22},{120,42}}), iconTransformation(extent={{100,28},
            {120,48}})));
  Modelica.Blocks.Interfaces.RealOutput mSte(final unit="kg/s")
    "Generator steam mass flow rate"
    annotation (Placement(transformation(
          extent={{100,-38},{120,-18}}), iconTransformation(extent={{100,-40},{
            120,-20}})));
  Modelica.SIunits.Efficiency genHIR(nominal=1)
   "Ratio of the generator heat input to chiller operating capacity";
  Modelica.SIunits.Efficiency EIRP(min=0,nominal=1)
   "Ratio of the actual absorber pumping power to the nominal pumping power";
  Real capFunEva(min=0,nominal=1)
    "Evaporator capacity factor function of temperature curve";
  Real capFunCon(min=0,nominal=1)
   "Condenser capacity factor function of temperature curve";
  Real genConT( min=0,nominal=1)
   "Heat input modifier based on the generator input temperature";
  Real genEvaT(min=0,nominal=1)
   "Heat input modifier based on the evaporator outlet temperature";
  Real PLR(min=0, nominal=1, unit="1")
   "Part load ratio";
  Real CR(min=0, nominal=1, unit="1")
   "Cycling ratio";
  Modelica.SIunits.HeatFlowRate QEva_flow_ava
   "Cooling capacity available at the Evaporator";
  Modelica.SIunits.Conversions.NonSIunits.Temperature_degC TConEnt_degC
   "Condenser entering water temperature in degC";
  Modelica.SIunits.Conversions.NonSIunits.Temperature_degC TEvaLvg_degC
   "Evaporator leaving water temperature in degC";
  Modelica.SIunits.Conversions.NonSIunits.Temperature_degC DelTSubCoo_degC
    "Sub cooling temperature difference";
  Modelica.Blocks.Interfaces.BooleanInput on
    "Set to true to enable the circulating pump, or false to disable the circulating pump"
    annotation (Placement(transformation(extent={{-124,-12},{-100,12}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));
initial equation
  assert(per.QEva_flow_nominal < 0,
  "In " + getInstanceName() + ": Parameter QEva_flow_nominal must be lesser than zero.");
  assert(Q_flow_small > 0,
  "In " + getInstanceName() + ":Parameter Q_flow_small must be larger than zero.");

equation
  TConEnt_degC=Modelica.SIunits.Conversions.to_degC(TConEnt);
  TEvaLvg_degC=Modelica.SIunits.Conversions.to_degC(TEvaLvg);
  DelTSubCoo_degC=Modelica.SIunits.Conversions.to_degC(DelTSubCoo);
    if on then

    capFunEva = Buildings.Utilities.Math.Functions.smoothMax(
           x1 =  1E-7,
           x2 =  per.capFunEva[1]+ per.capFunEva[2]*(TEvaLvg_degC)+
                 per.capFunEva[3]*(TEvaLvg_degC)^2+ per.capFunEva[4]*(TEvaLvg_degC)^3,
       deltaX =  Q_flow_small/100);

    capFunCon = Buildings.Utilities.Math.Functions.smoothMax(
           x1 =  1E-7,
           x2 =  per.capFunCon[1]+ per.capFunCon[2]*(TConEnt_degC)+
                 per.capFunCon[3]*(TConEnt_degC)^2+ per.capFunCon[4]*(TConEnt_degC)^3,
       deltaX = Q_flow_small/100);

    QEva_flow_ava = per.QEva_flow_nominal*capFunEva*capFunCon;

    QEva_flow = Buildings.Utilities.Math.Functions.smoothMax(
          x1 = QEvaFloSet,
          x2 = QEva_flow_ava,
          deltaX = Q_flow_small/100);
    PLR = Buildings.Utilities.Math.Functions.smoothMin(
                                  x1 =  QEvaFloSet/(QEva_flow_ava - Q_flow_small),
                                  x2 =  per.PLRMax,
                              deltaX =  per.PLRMax/100);

    genHIR = per.genHIR[1]+ per.genHIR[2]*PLR+per.genHIR[3]*PLR^2+per.genHIR[4]*PLR^3;

    genConT= per.genConT[1]+ per.genConT[2]*(TConEnt_degC)+
             per.genConT[3]*(TConEnt_degC)^2+ per.genConT[4]*(TConEnt_degC)^3;

    genEvaT= per.genEvaT[1]+ per.genEvaT[2]*(TEvaLvg_degC)+
             per.genEvaT[3]*(TEvaLvg_degC)^2+ per.genEvaT[4]*(TEvaLvg_degC)^3;

    EIRP = per.EIRP[1]+ per.EIRP[2]*PLR+per.EIRP[3]*PLR^2;

    CR =  Buildings.Utilities.Math.Functions.smoothMin(
      x1 =  PLR/per.PLRMin,
      x2 =  1,
      deltaX =  0.001);

    QGen_flow = genHIR*(-QEva_flow_ava)*genConT*genEvaT;

    P =  EIRP*(per.P_nominal)*CR;

    QCon_flow = -QEva_flow + QGen_flow + P;

    mSte= QGen_flow/(hfg+ (cpWat *DelTSubCoo_degC));

  else

   capFunEva =0;
   capFunCon =0;
   QEva_flow_ava=0;
   QEva_flow = 0;
   PLR =0;
   genHIR =0;
   genConT =0;
   genEvaT =0;
   EIRP=0;
   CR =0;
   QGen_flow = 0;
   P=0;
   QCon_flow = 0;
   mSte  =0;

  end if;

annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
                                Diagram(coordinateSystem(preserveAspectRatio=false)),
  defaultComponentName="absInd",
  Documentation(info="<html>
<p>
The Block includes the description of the performance curves method dedicated for<a href=\"Buildings.Fluid.Chillers.AbsorptionIndirectChiller\">
Buildings.Fluid.Chillers.AbsorptionIndirectChiller</a>.
</p>
<p>
The block uses six functions to predict the chiller cooling capacity, power consumption for
the chillerpump, the generator heat flow and the condenser heat flow:
</p>
<ol>
<li>
The chiller capacity function of the evaporator leaving water temperature cubic curve
<p align=\"center\" style=\"font-style:italic;\">
CAPFunEva = A<sub>1</sub>+ A<sub>2</sub>T<sub>Eva,Lvg</sub>+
A<sub>3</sub>T<sup>2</sup><sub>Eva,Lvg</sub>+ A<sub>4</sub>T<sup>3</sup><sub>Eva,Lvg</sub>
</li>
<li>
The chiller capacity function of the condenser entering water temperature cubic curve:
<p align=\"center\" style=\"font-style:italic;\">
CAPFunCon = B<sub>1</sub>+ B<sub>2</sub>T<sub>Con,Ent</sub>+
B<sub>3</sub>T<sup>2</sup><sub>Con,Ent</sub>+ B<sub>4</sub>T<sup>3</sup><sub>Con,Ent</sub>
</li>
<li>
The chiller pump electric input to cooling capacity output ratio function of part load ratio quadratic curve:
<p align=\"center\" style=\"font-style:italic;\">
EIRFP = C<sub>1</sub>+ C<sub>2</sub>PLR+C<sub>3</sub>PLR<sup>2</sup>
</li>
<li>
The generator heat input to cooling capacity output ratio function of part load ratio cubic curve:
<p align=\"center\" style=\"font-style:italic;\">
genHIR = D<sub>1</sub>+ D<sub>2</sub>PLR+D<sub>3</sub>PLR<sup>2</sup>++D<sub>4</sub>PLR<sup>3</sup>
</li>
</ol>
<p>
Two additional curves are available to modifiy the heat input requirment based on the condenser inlet water temperature
and the evaporator outlet water temperature.
</p>
<ol>
<li>
The heat input modifier based on the condenser inlet water temperature cubic curve:
<p align=\"center\" style=\"font-style:italic;\">
genConT = E<sub>1</sub>+ E<sub>2</sub>T<sub>Con,Ent</sub>+
E<sub>3</sub>T<sup>2</sup><sub>Con,Ent</sub>+ E<sub>4</sub>T<sup>3</sup><sub>Con,Ent</sub>
</li>
<li>
The heat input modifier based on the evaporator inlet water temperature cubic curve:
<p align=\"center\" style=\"font-style:italic;\">
genEvaT= F<sub>1</sub>+ F<sub>2</sub>T<sub>Eva,Lvg</sub>+
F<sub>3</sub>T<sup>2</sup><sub>Eva,Lvg</sub>+ F<sub>4</sub>T<sup>3</sup><sub>Eva,Lvg</sub>
</li>
</ol>
<p>
where all the performance curve coefficients  are stored in the data record <code>per</code>.
</p>
<p>
The data record <code>per</code> is available at
<a href=\"Buildings.Fluid.Chillers.Data.AbsorptionIndirect\">
Buildings.Fluid.Chillers.Data.AbsorptionIndirect</a>.
Additional performance curves can be developed using
two available techniques (Hydeman and Gillespie, 2002). The first technique is called the
Least-squares Linear Regression method and is used when sufficient performance data exist
to employ standard least-square linear regression techniques. The second technique is called
Reference Curve Method and is used when insufficient performance data exist to apply linear
regression techniques. A detailed description of both techniques can be found in
Hydeman and Gillespie (2002).
</p>
<p>
The model has two tests on the part load ratio and the cycling ratio:
</p>
<ol>
<li>
The test<pre>
  PLR =min(QEva_flow_set/QEva_flow_ava, per.PLRMax);
</pre>
ensures that the chiller capacity does not exceed the chiller capacity specified
by the parameter <code>per.PLRMax</code>.
</li>
<li>
The test <pre>
  CR = min(PLR/per.PRLMin, 1.0);
</pre>
computes a cycling ratio. This ratio expresses the fraction of time
that a chiller would run if it were to cycle because its load is smaller than the
minimal load at which it can operate.
Note that this model continuously operates even if the part load ratio is below the
minimum part load ratio.
Its leaving evaporator and condenser temperature can therefore be considered as an
average temperature between the modes where the compressor is off and on.
</li>
</ol>
<p>
The electric power only contains only the power for the chiller pump.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 3, 2019, by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end AbsorptionIndirect;
