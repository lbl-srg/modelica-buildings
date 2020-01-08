within Buildings.Fluid.Chillers.BaseClasses;
block AbsorptionIndirectRemovableRecords
  "Absorption indirect chiller performance curve method"
  extends Modelica.Blocks.Icons.Block;

  replaceable parameter Data.AbsorptionIndirect.AbsorptionIndirectHotWater
    per constrainedby Buildings.Fluid.Chillers.Data.BaseClasses.PartialGeneric
    "Record import parameter" annotation (choicesAllMatching=true);

  parameter Boolean hotWater=true
  "Get the prescribed heat flow rate from the input connector"
     annotation(Evaluate=true, HideResult=true);
  parameter Modelica.SIunits.HeatFlowRate Q_flow_small
    "Small value for heat flow rate or power, used to avoid division by zero"
    annotation(HideResult=true);

  Modelica.Blocks.Interfaces.RealInput TGenEnt(
  final unit="K",
  displayUnit="degC") if hotWater
  "Generator entering water temperature"
   annotation (Placement(transformation(
        extent={{-124,-12},{-100,12}}), iconTransformation(extent={{-120,20},{
          -100,40}})));
  Modelica.Blocks.Interfaces.BooleanInput on
    "Set to true to enable the absorption chiller"
    annotation (Placement(transformation(extent={{-124,48},{-100,72}}),
        iconTransformation(extent={{-120,60},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput TConEnt(
    final unit="K",
    displayUnit="degC") "Condenser entering water temperature"
     annotation (Placement(transformation(extent={{-124,16},{-100,40}}),iconTransformation(extent={{-120,
            -10},{-100,10}})));
  Modelica.Blocks.Interfaces.RealInput TEvaLvg(
    final unit="K",
    displayUnit="degC")
    "Evaporator leaving water temperature"
     annotation (Placement(transformation(extent={{-124,-84},{-100,-60}}),
                                    iconTransformation(extent={{-120,-80},{-100,
            -60}})));

  Modelica.Blocks.Interfaces.RealInput QEva_flow_set(final unit="W")
    "Evaporator setpoint heat flow rate" annotation (Placement(transformation(
          extent={{-124,-44},{-100,-20}}), iconTransformation(extent={{-120,-50},
            {-100,-30}})));

  Modelica.Blocks.Interfaces.RealOutput QCon_flow(final unit="W")
    "Condenser heat flow rate "
     annotation (Placement(transformation(extent={{100,70},{120,90}}),
                            iconTransformation(extent={{100,70},{120,90}})));

  Modelica.Blocks.Interfaces.RealOutput QEva_flow(final unit="W")
    "Evaporator heat flow rate"
     annotation (Placement(transformation(extent={{100,-30},{120,-10}}),
                              iconTransformation(extent={{100,-30},{120,-10}})));

  Modelica.Blocks.Interfaces.RealOutput QGen_flow(final unit="W")
    "Required generator heat flow rate"
     annotation (Placement(transformation(extent={{100,10},{120,30}}),
                              iconTransformation(extent={{100,10},{120,30}})));

  Modelica.Blocks.Interfaces.RealOutput P(final unit="W")
    "Pump power"
     annotation (Placement(transformation(extent={{100,40},{120,60}}), iconTransformation(extent={{100,40},
            {120,60}})));

  Modelica.Blocks.Interfaces.RealOutput PLR(min=0, final unit="1")
   "Part load ratio"
   annotation (Placement(transformation(extent={{100,-60},{120,-40}}),iconTransformation(extent={{100,-60},
            {120,-40}})));
  Modelica.Blocks.Interfaces.RealOutput CR(min=0, final unit="1")
   "Cycling ratio"
   annotation (Placement(transformation(extent={{100,-90},{120,-70}}), iconTransformation(extent={{100,-90},
            {120,-70}})));

  Modelica.SIunits.Efficiency genHIR
   "Ratio of the generator heat input to chiller operating capacity";
  Modelica.SIunits.Efficiency EIRP(min=0)
   "Ratio of the actual absorber pumping power to the nominal pumping power";
  Real capFunEva(min=0)
    "Evaporator capacity factor function of temperature curve";
  Real capFunCon(min=0)
   "Condenser capacity factor function of temperature curve";
  Real genConT(min=0)
   "Heat input modifier based on the generator input temperature";
  Real genEvaT(min=0)
   "Heat input modifier based on the evaporator outlet temperature";
  Real capFunGen(min=0)
    "Generator capacity factor function of temperature curve";

  Modelica.SIunits.HeatFlowRate QEva_flow_ava
   "Cooling capacity available at the evaporator";

protected
  Modelica.SIunits.Conversions.NonSIunits.Temperature_degC TConEnt_degC
   "Condenser entering water temperature in degC";
  Modelica.SIunits.Conversions.NonSIunits.Temperature_degC TEvaLvg_degC
   "Evaporator leaving water temperature in degC";
  Modelica.SIunits.Conversions.NonSIunits.Temperature_degC TGenEnt_degC
   "Generator entering water temperature in degC";
  Modelica.Blocks.Interfaces.RealInput TGenEnt_internal(final unit="K")
    "Needed to connect to conditional connector";

initial equation
  assert(per.QEva_flow_nominal < 0,
  "In " + getInstanceName() + ": Parameter QEva_flow_nominal must be smaller than zero.");
  assert(Q_flow_small > 0,
  "In " + getInstanceName() + ": Parameter Q_flow_small must be larger than zero.");

equation

  TConEnt_degC=Modelica.SIunits.Conversions.to_degC(TConEnt);
  TEvaLvg_degC=Modelica.SIunits.Conversions.to_degC(TEvaLvg);
  TGenEnt_degC=Modelica.SIunits.Conversions.to_degC(TGenEnt_internal);
  // TGenEnt removed conditionally when the heat source is steam.
  // In this case TGenEnt_internal will not be included in the simulation.
    if not hotWater then
      TGenEnt_internal =0;
    end if;

    if on then
    capFunEva = Buildings.Utilities.Math.Functions.smoothMax(
           x1 = 1E-6,
           x2 = Buildings.Utilities.Math.Functions.polynomial(x=TEvaLvg_degC, a=per.capFunEva),
       deltaX = Q_flow_small);

    capFunCon = Buildings.Utilities.Math.Functions.smoothMax(
           x1 = 1E-6,
           x2 = Buildings.Utilities.Math.Functions.polynomial(x=TConEnt_degC, a=per.capFunCon),
       deltaX = Q_flow_small);

    capFunGen = Buildings.Utilities.Math.Functions.smoothMax(
          x1 = 1E-6,
          x2 = Buildings.Utilities.Math.Functions.polynomial(x=TGenEnt_degC, a=per.capFunGen),
      deltaX = Q_flow_small);

    QEva_flow_ava = per.QEva_flow_nominal*capFunEva*capFunCon*capFunGen;

    QEva_flow = Buildings.Utilities.Math.Functions.smoothMax(
          x1 = QEva_flow_set,
          x2 = QEva_flow_ava,
          deltaX = Q_flow_small);
    PLR =Buildings.Utilities.Math.Functions.smoothMin(
      x1=QEva_flow_set/(QEva_flow_ava - Q_flow_small),
      x2=per.PLRMax,
      deltaX=per.PLRMax/100);

    genHIR = per.genHIR[1]+ per.genHIR[2]*PLR+per.genHIR[3]*PLR^2+per.genHIR[4]*PLR^3;

    genConT = Buildings.Utilities.Math.Functions.polynomial(x=TConEnt_degC, a=per.genConT);

    genEvaT = Buildings.Utilities.Math.Functions.polynomial(x=TEvaLvg_degC, a=per.genEvaT);

    EIRP = Buildings.Utilities.Math.Functions.polynomial(x=PLR, a=per.EIRP);

    CR = Buildings.Utilities.Math.Functions.smoothMin(
      x1 = PLR/per.PLRMin,
      x2 = 1,
      deltaX = 0.001);

    QGen_flow = -QEva_flow_ava * genHIR * genConT * genEvaT * CR;

    P = EIRP * per.P_nominal * CR;

    QCon_flow = -QEva_flow + QGen_flow + P;
  else
    capFunEva = 0;
    capFunCon = 0;
    capFunGen = 0;
    QEva_flow_ava = 0;
    QEva_flow = 0;
    PLR = 0;
    genHIR = per.genHIR[1];
    genConT = 1;
    genEvaT = 1;
    EIRP = 0;
    CR = 0;
    QGen_flow = 0;
    P = 0;
    QCon_flow = 0;
  end if;
  connect(TGenEnt,TGenEnt_internal);
annotation (
  defaultComponentName="perMod",
Documentation(info="<html>
<p>
Block that computes the performance of the indirect absorption chiller with the option of 
implementing either hot water or steam as a heat source for the generator .
The real input <code>TGenEnt</code> is provided via a conditional connector if the 
Boolean parameter <code>hotWater</code> is true.
For a description of the indirect steam absorption chiller see 
<a href=\"Buildings.Fluid.Chillers.AbsorptionIndirectSteamRemovableRecords\">
Buildings.Fluid.Chillers.AbsorptionIndirectSteamRemovableRecords</a>. and for indirect hot
water absorption chiller see
<a href=\"Buildings.Fluid.Chillers.AbsorptionIndirectHotWaterRemovableRecords\">
Buildings.Fluid.Chillers.AbsorptionIndirectHotWaterRemovableRecords</a>. 
</p>
</html>",
revisions="<html>
<ul>
<li>
January 6, 2020, by Hagar Elarga:<br/>
Added the equation of <code>capFunGen</code> the model to consider
the hot water as another heat source for the generator in addition to the steam.
and modified the model to operate in dual modes; the steam or the hot water mode.
</li>
<li>
December 13, 2019, by Michael Wetter:<br/>
Removed <code>TConLvg</code> which is not used by this model.
</li>
<li>
November 26, 2019, by Michael Wetter:<br/>
Revised implementation and documentation.
</li>
<li>
July 3, 2019, by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end AbsorptionIndirectRemovableRecords;
