within Buildings.Fluid.HeatPumps.BaseClasses;
block DOE2Reversible
  "DOE2 method to compute the performance of the reversible heat pump"
  extends Modelica.Blocks.Icons.Block;

  parameter Buildings.Fluid.HeatPumps.Data.DOE2Reversible.Generic per
   "Performance data"
    annotation (choicesAllMatching = true,
    Placement(transformation(
         extent={{60,60},{80,80}})));
  parameter Real scaling_factor
   "Scaling factor for heat pump capacity";
  // fixme: loaRat and powRat should be removed as these are already in the performance data. No need to double count.
  parameter Modelica.SIunits.Efficiency loaRat=0.7
    "Evaporator capacity in heating mode to the reference cooling capacity";
  parameter Modelica.SIunits.Efficiency powRat=1.4
    "Compressor power in heating mode to the reference cooling power power";
  parameter Modelica.SIunits.HeatFlowRate QCoo_flow=per.coo.QEva_flow_nominal*
      scaling_factor "Nominal cooling capacity at the load side";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_small=-per.coo.QEva_flow_nominal
      *1E-9*scaling_factor
    "Small value for heat flow rate or power, used to avoid division by zero";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConEnt(final unit="K",
      displayUnit="degC") "Condenser entering temperature" annotation (
      Placement(transformation(extent={{-124,-52},{-100,-28}}),
        iconTransformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TEvaLvg(final unit="K",
      displayUnit="degC") "Evaporator leaving temperature" annotation (
      Placement(transformation(extent={{-124,-92},{-100,-68}}),
        iconTransformation(extent={{-120,-90},{-100,-70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput Q_flow_set(final unit="W")
    "Required heat to meet set point"
    annotation (Placement(transformation(
          extent={{-124,68},{-100,92}}), iconTransformation(extent={{-120,70},{
            -100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QLoa_flow(final unit="W")
    "Load heat flow rate"
    annotation (Placement(transformation(extent={{100,50},{120,70}}),
        iconTransformation(extent={{100,50},{120,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QSou_flow(final unit="W")
    "Source heat flow rate"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}}),
        iconTransformation(extent={{100,-70},{120,-50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput P(final unit="W")
   "Compressor power"
    annotation (Placement(transformation(extent={{100,10},{120,30}}),
        iconTransformation(extent={{100,10},{120,30}})));

   Buildings.Controls.OBC.CDL.Interfaces.RealOutput COP(
   final min=0,
   final unit="1")
   "Coefficient of performance, assuming useful heat is at the load side (at Medium 1)"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}}),
    iconTransformation(extent={{100,-30},{120,-10}})));
   Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uMod
   "Control input signal, cooling mode= -1, off=0, heating mode=+1"
    annotation (Placement(transformation(extent={{-124,28},{-100,52}}),
        iconTransformation(extent={{-120,30},{-100,50}})));
  Modelica.SIunits.HeatFlowRate Q_flow_ava
   "Heating (or cooling) capacity available";
  Modelica.SIunits.HeatFlowRate Q_flow_act
   "Actual heating (or cooling) capacity available";
  Modelica.SIunits.Efficiency EIRFT
   "Power input to load side capacity ratio function of temperature curve";
  Modelica.SIunits.Efficiency EIRFPLR
   "Power input to load side capacity ratio function of part load ratio";
  Real capFunT(
    min=0,
    final unit="1")
   "Load side capacity factor function of temperature curve";
  Real PLR1(
    min=0,
    unit="1")
   "Part load ratio";
  Real PLR2(
    min=0,
    unit="1")
   "Part load ratio";
  Real CR(
    min=0,
    unit="1")
   "Cycling ratio";

protected
  HeatingCoolingData datPer
    "Performance data for the current mode of operation";
  Modelica.SIunits.Conversions.NonSIunits.Temperature_degC TConEnt_degC
    "Condenser entering fluid temperature used to compute the performance in degC";
  Modelica.SIunits.Conversions.NonSIunits.Temperature_degC TEvaLvg_degC
    "Evaporator leaving fluid temperature used to compute the performance in degC";

  record HeatingCoolingData "Record for performance data that are used for heating and cooling"
    Modelica.SIunits.HeatFlowRate QEva_flow_nominal(max=0) "Nominal capacity at evaporator (negative number)"
      annotation (Dialog(group="Nominal conditions at evaporator"));
    Real capFunT[6]
     "Biquadratic coefficients for capFunT"
      annotation (Dialog(group="Performance coefficients"));
    Real EIRFunT[6]
     "Biquadratic coefficients for EIRFunT"
      annotation (Dialog(group="Performance coefficients"));
    Real EIRFunPLR[4]
     "Coefficients for EIRFunPLR";
    Real COPCoo_nominal
      "Reference coefficient of performance, using the evaporator heat flow rate as useful heat"
      annotation (Dialog(group="Nominal condition"));
    Real PLRMax(min=0) "
       Maximum part load ratio";
    Real PLRMinUnl(min=0)
     "Minimum part unload ratio";
    Real PLRMin(min=0)
      "Minimum part load ratio";
  end HeatingCoolingData;

initial equation
  assert(per.coo.QEva_flow_nominal < 0, "Parameter QCoo_flow must be lesser than zero.");
  assert(Q_flow_small > 0,
  "Parameter Q_flow_small must be larger than zero.");
  assert(per.coo.PLRMinUnl >= per.coo.PLRMin,
  "Parameter PLRMinUnl must be bigger or equal to PLRMin");
  assert(per.coo.PLRMax > per.coo.PLRMinUnl,
  "Parameter PLRMax must be bigger than PLRMinUnl");

equation
  if (uMod == 1) then
    // Heating mode
    assert(per.canHeat,
      "In " + getInstanceName() + ": Heat pump is operated in heating mode but no performance data are provided for that mode.");
    datPer = per.hea;
  else
    // Cooling mode
    assert(per.canCool,
      "In " + getInstanceName() + ": Heat pump is operated in cooling mode but no performance data are provided for that mode.");
    datPer = per.coo;
  end if;

  // Calculation of available heat and compressor power
  if (uMod==0) then
    TConEnt_degC = 0;
    TEvaLvg_degC = 0;
    capFunT=0;
    EIRFT=0;
    EIRFPLR=0;
    PLR1=0;
    PLR2=0;
    CR=0;
    Q_flow_ava = 0;
    Q_flow_act = 0;
    P = 0;
  else
    TConEnt_degC = Modelica.SIunits.Conversions.to_degC(TConEnt);
    TEvaLvg_degC = Modelica.SIunits.Conversions.to_degC(TEvaLvg);

    PLR1 = Buildings.Utilities.Math.Functions.smoothMax(
      x1 =  Q_flow_set/(Q_flow_ava + Q_flow_small),
      x2 =  datPer.PLRMax,
      deltaX =  datPer.PLRMax/100);
    PLR2 = Buildings.Utilities.Math.Functions.smoothMax(
      x1 =  datPer.PLRMinUnl,
      x2 =  PLR1,
      deltaX = datPer.PLRMinUnl/100);
    CR = Buildings.Utilities.Math.Functions.smoothMin(
      x1 =  PLR1/datPer.PLRMin,
      x2 =  1,
      deltaX =  0.001);

    capFunT =Buildings.Utilities.Math.Functions.smoothMax(
      x1=1E-7,
      x2=Buildings.Utilities.Math.Functions.biquadratic(
        a=datPer.capFunT,
        x1=TEvaLvg_degC,
        x2=TConEnt_degC),
      deltaX=1E-7);
    EIRFT =Buildings.Utilities.Math.Functions.biquadratic(
      a=datPer.EIRFunT,
      x1=TEvaLvg_degC,
      x2=TConEnt_degC);

    EIRFPLR = datPer.EIRFunPLR[1]+datPer.EIRFunPLR[2]*PLR2+datPer.EIRFunPLR[3]*PLR2^2+datPer.EIRFunPLR[4]*PLR2^3;


    Q_flow_ava =datPer.QEva_flow_nominal*capFunT*scaling_factor;
    Q_flow_act = Buildings.Utilities.Math.Functions.smoothMax(
      x1 = Q_flow_set,
      x2 = Q_flow_ava,
      deltaX = Q_flow_small/10);


    // fixme: The assignment below divides by per.coo.COP_nominal also in heating mode. Is this correct?
    P =(-Q_flow_ava/datPer.COPCoo_nominal)*PLR1*EIRFT*EIRFPLR*CR*scaling_factor;
  end if;

  // Calculation of source and load side heat flow rates
  if (uMod == +1) then
    // Heating mode
    QSou_flow = Q_flow_act;
    QLoa_flow = -QSou_flow + P;
    COP = -QSou_flow/(P + Q_flow_small);

  elseif (uMod==-1) then
    // Cooling mode
    QLoa_flow = Q_flow_act;

    QSou_flow = -QLoa_flow + P;
    COP = -QLoa_flow/(P + Q_flow_small);
  else
    QSou_flow = 0;
    QLoa_flow = 0;
    COP = 0;
  end if;


annotation (
defaultComponentName="doe2",
Documentation(info="<html>
<p>
Block that implements the DOE2 method for the reverse heat pump model
<a href=\"Buildings.Fluid.HeatPumps.DOE2Reversible\">
Buildings.Fluid.HeatPumps.DOE2Reversible</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 3, 2020, by Michael Wetter:<br/>
Revised implementation to only use those temperatures as input that are used in the calculations.
</li>
<li>
September 27, 2019, by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={Text(
          extent={{-62,-4},{60,-96}},
          lineColor={0,0,0},
          textString="DOE 2")}));
end DOE2Reversible;
