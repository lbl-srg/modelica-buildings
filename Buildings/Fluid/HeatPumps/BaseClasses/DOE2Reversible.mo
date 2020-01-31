within Buildings.Fluid.HeatPumps.BaseClasses;
block DOE2Reversible
  "DOE2 method to compute the performance of the reversible heat pump"
  extends Modelica.Blocks.Icons.Block;

  parameter Buildings.Fluid.HeatPumps.Data.DOE2Reversible.Generic per
   "Performance data"
    annotation (choicesAllMatching = true,Placement(transformation(
         extent={{80,80},{100,100}})));
  parameter Real scaling_factor
   "Scaling factor for heat pump capacity";
  parameter Modelica.SIunits.Efficiency LoaRat = 0.7
   "Evaporator capacity in heating mode to the reference cooling capacity";
  parameter Modelica.SIunits.Efficiency PowRat = 1.4
   "Compressor power in heating mode to the reference cooling power power";
  parameter Modelica.SIunits.HeatFlowRate QCoo_flow = per.coo.Q_flow*scaling_factor
    "Nominal cooling capacity at the load side";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_small = - per.coo.Q_flow * 1E-9 *scaling_factor
   "Small value for heat flow rate or power, used to avoid division by zero";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TLoaLvg(
    final unit="K",
    displayUnit="degC")
   "Load entering fluid temperature"
    annotation (Placement(transformation(extent={{-124,-52},{-100,-28}}),
        iconTransformation(extent={{-120,74},{-100,94}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSouLvg(final unit="K", displayUnit="degC")
    "Source leaving fluid temperature"
    annotation (Placement(transformation(
          extent={{-124,48},{-100,72}}), iconTransformation(extent={{-120,-108},
            {-100,-88}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSouEnt(
    final unit="K",
    displayUnit="degC") "Source entering fluid temperature"
    annotation (Placement(transformation(extent={{-124,28},{-100,52}}),
        iconTransformation(extent={{-120,-36},{-100,-16}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TLoaEnt(
    final unit="K",
    displayUnit="degC")
    "Load entering fluid temperature"
    annotation (Placement(transformation(extent={{-124,-92},{-100,-68}}),
                          iconTransformation(extent={{-120,-74},{-100,-54}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput Q_flow_set(final unit="W")
    "Required heat to meet set point"
    annotation (Placement(transformation(
          extent={{-124,68},{-100,92}}), iconTransformation(extent={{-120,44},{
            -100,64}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QLoa_flow(final unit="W")
    "Load heat flow rate"
    annotation (Placement(transformation(extent={{100,50},{120,70}}),
        iconTransformation(extent={{100,20},{120,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QSou_flow(final unit="W")
    "Source heat flow rate"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}}),
        iconTransformation(extent={{100,-70},{120,-50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput P(final unit="W")
   "Compressor power"
    annotation (Placement(transformation(extent={{100,10},{120,30}}),
        iconTransformation(extent={{100,-10},{120,10}})));

   Buildings.Controls.OBC.CDL.Interfaces.RealOutput COP(
   final min=0,
   final unit="1")
   "Coefficient of performance, assuming useful heat is at the load side (at Medium 1)"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}}),
    iconTransformation(extent={{100,-40},{120,-20}})));
   Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uMod
   "Control input signal, cooling mode= -1, off=0, heating mode=+1"
    annotation (Placement(transformation(extent={{-124,-12},{-100,12}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));
  Modelica.SIunits.HeatFlowRate Q_flow_ava
   "Heating (or cooling) capacity available";
  Modelica.SIunits.Efficiency EIRFT(nominal=1)
   "Power input to load side capacity ratio function of temperature curve";
  Modelica.SIunits.Efficiency EIRFPLR(nominal=1)
   "Power input to load side capacity ratio function of part load ratio";
  Real CapFT(min=0,nominal=1)
   "Load side capacity factor function of temperature curve";
  Real PLR1(min=0, nominal=1, unit="1")
   "Part load ratio";
  Real PLR2(min=0, nominal=1, unit="1")
   "Part load ratio";
  Real CR(min=0, nominal=1, unit="1")
   "Cycling ratio";

  Modelica.SIunits.Conversions.NonSIunits.Temperature_degC TLoaEnt_degC
   "Load side entering water temperature in degC";
  Modelica.SIunits.Conversions.NonSIunits.Temperature_degC TLoaLvg_degC
   "Load side leaving water temperature in degC";
  Modelica.SIunits.Conversions.NonSIunits.Temperature_degC TSouEnt_degC
   "Source side entering water temperature in degC";
  Modelica.SIunits.Conversions.NonSIunits.Temperature_degC TSouLvg_degC
   "Source side leaving water temperature in degC";

initial equation
  assert(per.coo.Q_flow < 0,
  "Parameter QCoo_flow must be lesser than zero.");
  assert(Q_flow_small > 0,
  "Parameter Q_flow_small must be larger than zero.");
  assert(per.coo.PLRMinUnl >= per.coo.PLRMin,
  "Parameter PLRMinUnl must be bigger or equal to PLRMin");
  assert(per.coo.PLRMax > per.coo.PLRMinUnl,
  "Parameter PLRMax must be bigger than PLRMinUnl");

equation

  TLoaEnt_degC=Modelica.SIunits.Conversions.to_degC(TLoaEnt);
  TLoaLvg_degC=Modelica.SIunits.Conversions.to_degC(TLoaLvg);
  TSouEnt_degC=Modelica.SIunits.Conversions.to_degC(TSouEnt);
  TSouLvg_degC = Modelica.SIunits.Conversions.to_degC(TSouLvg);

 if (uMod==1) then
     PLR1 = Buildings.Utilities.Math.Functions.smoothMax(
        x1 =  Q_flow_set/(Q_flow_ava + Q_flow_small),
        x2 =  per.hea.PLRMax,
        deltaX = per.hea.PLRMax/100);
     PLR2 = Buildings.Utilities.Math.Functions.smoothMax(
        x1 =  per.hea.PLRMinUnl,
        x2 =  PLR1,
        deltaX = per.hea.PLRMinUnl/100);
     CR = Buildings.Utilities.Math.Functions.smoothMin(
        x1 =  PLR1/per.hea.PLRMin,
        x2 =  1,
        deltaX =  0.001);

     CapFT = Buildings.Utilities.Math.Functions.smoothMax(
        x1 = 1E-7,
        x2 = Buildings.Utilities.Math.Functions.biquadratic(
           a =  per.hea.CapFunT,
            x1 = TSouLvg_degC,
            x2 = TLoaEnt_degC),
           deltaX = 1E-7);

     EIRFT = Buildings.Utilities.Math.Functions.biquadratic(
             a =  per.hea.EIRFunT,
            x1 = TSouLvg_degC,
            x2 = TLoaEnt_degC);

     EIRFPLR = per.hea.EIRFunPLR[1]+per.hea.EIRFunPLR[2]*PLR2+per.hea.EIRFunPLR[3]*PLR2^2+per.hea.EIRFunPLR[4]*PLR2^3;

     Q_flow_ava = per.coo.Q_flow*CapFT*LoaRat*scaling_factor;

     P = (-Q_flow_ava/per.coo.COP_nominal)*PowRat*PLR1*EIRFT*EIRFPLR*CR*scaling_factor;

     QSou_flow = Buildings.Utilities.Math.Functions.smoothMax(
        x1 = Q_flow_set,
        x2 = Q_flow_ava,
        deltaX = Q_flow_small/10);

     QLoa_flow = -QSou_flow + P; // QLoa_flow is computed from QSou
     COP = -QSou_flow/(P + Q_flow_small);

 elseif (uMod==-1) then
     PLR1 = Buildings.Utilities.Math.Functions.smoothMax(
      x1 =  Q_flow_set/(Q_flow_ava + Q_flow_small),
      x2 =  per.coo.PLRMax,
      deltaX =  per.coo.PLRMax/100);
    PLR2 = Buildings.Utilities.Math.Functions.smoothMax(
      x1 =  per.coo.PLRMinUnl,
      x2 =  PLR1,
      deltaX = per.coo.PLRMinUnl/100);
    CR = Buildings.Utilities.Math.Functions.smoothMin(
      x1 =  PLR1/per.coo.PLRMin,
      x2 =  1,
      deltaX =  0.001);

    CapFT = Buildings.Utilities.Math.Functions.smoothMax(
          x1 = 1E-7,
          x2 = Buildings.Utilities.Math.Functions.biquadratic(
             a =  per.coo.CapFunT,
             x1 = TLoaLvg_degC,
             x2 = TSouEnt_degC),
             deltaX = 1E-7);
    EIRFT = Buildings.Utilities.Math.Functions.biquadratic(
             a =  per.coo.EIRFunT,
             x1 = TLoaLvg_degC,
             x2 = TSouEnt_degC);
    EIRFPLR = per.coo.EIRFunPLR[1]+per.coo.EIRFunPLR[2]*PLR2+per.coo.EIRFunPLR[3]*PLR2^2+per.coo.EIRFunPLR[4]*PLR2^3;

    Q_flow_ava = per.coo.Q_flow*CapFT*scaling_factor;

    P = (-Q_flow_ava/per.coo.COP_nominal)*PLR1*EIRFT*EIRFPLR*CR*scaling_factor;

    QLoa_flow = Buildings.Utilities.Math.Functions.smoothMax(
       x1 = Q_flow_set,
       x2 = Q_flow_ava,
       deltaX = Q_flow_small/10);

    QSou_flow = -QLoa_flow + P;
    COP = -QLoa_flow/(P + Q_flow_small);

  else
    CapFT=0;
    EIRFT=0;
    EIRFPLR=0;
    PLR1=0;
    PLR2=0;
    CR=0;
    Q_flow_ava = 0;
    QLoa_flow = 0;
    QSou_flow = 0;
    P = 0;
    COP = 0;
  end if;

annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
Diagram(coordinateSystem(preserveAspectRatio=false)),
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
September 27, 2019, by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end DOE2Reversible;
