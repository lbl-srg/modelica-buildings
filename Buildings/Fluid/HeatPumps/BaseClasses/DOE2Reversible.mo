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

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConEnt(final unit="K",
      displayUnit="degC") "Condenser entering temperature" annotation (
      Placement(transformation(extent={{-124,-52},{-100,-28}}),
        iconTransformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TEvaLvg(final unit="K",
      displayUnit="degC") "Evaporator leaving temperature" annotation (
      Placement(transformation(extent={{-124,-92},{-100,-68}}),
        iconTransformation(extent={{-120,-90},{-100,-70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput QSet_flow(final unit="W")
    "Required heat to meet set point"
    annotation (Placement(transformation(
          extent={{-124,68},{-100,92}}), iconTransformation(extent={{-120,70},{
            -100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Q1_flow(final unit="W")
    "Load heat flow rate"
    annotation (Placement(transformation(extent={{100,70},{120,90}}),
        iconTransformation(extent={{100,70},{120,90}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Q2_flow(final unit="W")
    "Source heat flow rate"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));

  Modelica.SIunits.HeatFlowRate QFalLoa_flow
    "False loading of the compressor (e.g., hot gas bypass)";
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput P(final unit="W")
   "Compressor power"
    annotation (Placement(transformation(extent={{100,30},{120,50}}),
        iconTransformation(extent={{100,30},{120,50}})));

   Buildings.Controls.OBC.CDL.Interfaces.RealOutput COPCoo(final min=0, final
      unit="1") "Coefficient of performance for cooling" annotation (Placement(
        transformation(extent={{100,-50},{120,-30}}), iconTransformation(extent=
           {{100,-50},{120,-30}})));
   Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uMod
   "Control input signal, cooling mode= -1, off=0, heating mode=+1"
    annotation (Placement(transformation(extent={{-124,28},{-100,52}}),
        iconTransformation(extent={{-120,30},{-100,50}})));
  Modelica.SIunits.HeatFlowRate QAva_flow
   "Heating (or cooling) capacity available";
  Modelica.SIunits.HeatFlowRate QAct_flow
   "Actual heat transfer rate at evaporator";
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

  Controls.OBC.CDL.Interfaces.RealOutput COPHea(final min=0, final unit="1")
    "Coefficient of performance for heating" annotation (Placement(
        transformation(extent={{100,-90},{120,-70}}), iconTransformation(extent=
           {{100,-50},{120,-30}})));
protected
  parameter Modelica.SIunits.HeatFlowRate Q_flow_small=-per.coo.QEva_flow_nominal*1E-6*scaling_factor
    "Small value for heat flow rate or power, used to avoid division by zero";

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
    QAva_flow = 0;
    QAct_flow = 0;
    QFalLoa_flow = 0;
    P = 0;
    COPCoo = 0;
    COPHea = 0;
  else
    TConEnt_degC = Modelica.SIunits.Conversions.to_degC(TConEnt);
    TEvaLvg_degC = Modelica.SIunits.Conversions.to_degC(TEvaLvg);

    capFunT = Buildings.Utilities.Math.Functions.biquadratic(
        a=datPer.capFunT,
        x1=TEvaLvg_degC,
        x2=TConEnt_degC);
    EIRFT =Buildings.Utilities.Math.Functions.biquadratic(
      a=datPer.EIRFunT,
      x1=TEvaLvg_degC,
      x2=TConEnt_degC);

    QAva_flow = Buildings.Utilities.Math.Functions.smoothMin(
      x1 = datPer.QEva_flow_nominal*capFunT*scaling_factor,
      x2 = -Q_flow_small,
      deltaX = Q_flow_small/10);
    QAct_flow = Buildings.Utilities.Math.Functions.smoothMax(
      x1 = QSet_flow,
      x2 = QAva_flow,
      deltaX = Q_flow_small/10);

    // capFunT is strictly positive, hence QAva_flow is bounded away from zero.
    PLR1 = Buildings.Utilities.Math.Functions.smoothMin(
      x1 =  QSet_flow/QAva_flow,
      x2 =  datPer.PLRMax,
      deltaX = datPer.PLRMax/100);
    PLR2 = Buildings.Utilities.Math.Functions.smoothMax(
      x1 =  datPer.PLRMinUnl,
      x2 =  PLR1,
      deltaX = datPer.PLRMinUnl/100);
    CR = Buildings.Utilities.Math.Functions.smoothMin(
      x1 =  PLR1/datPer.PLRMin,
      x2 =  1,
      deltaX = 0.001);

    EIRFPLR = Buildings.Utilities.Math.Functions.polynomial(
      x = PLR2,
      a = datPer.EIRFunPLR);

    // QAva_flow is always at the evaporator, hence this is for COPCoo
    P = Buildings.Utilities.Math.Functions.smoothMax(
      x1 = (-QAva_flow*PLR1*CR/per.COPCoo_nominal) * EIRFT*EIRFPLR,
      x2 = Q_flow_small,
      deltaX = Q_flow_small/10);
    QFalLoa_flow = QAva_flow*PLR2*CR - QAct_flow;

    // P is always strictly positive
    COPCoo = -QAva_flow/P;
    COPHea = COPCoo + 1;
  end if;

  // Calculation of source and load side heat flow rates
  if (uMod == +1) then
    // Heating mode
    Q2_flow = QAct_flow;
    Q1_flow = -Q2_flow + P;
  elseif (uMod==-1) then
    // Cooling mode
    Q1_flow = QAct_flow;
    Q2_flow = -Q1_flow + P;
  else
    Q2_flow = 0;
    Q1_flow = 0;
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
