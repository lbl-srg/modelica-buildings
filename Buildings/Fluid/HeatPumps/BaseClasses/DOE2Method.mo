within Buildings.Fluid.HeatPumps.BaseClasses;
block DOE2Method

  extends ModelicaReference.Icons.Package;

  parameter  Buildings.Fluid.Chillers.Data.ElectricEIR.Generic per
    "Performance data"
     annotation (choicesAllMatching = true,Placement(transformation(extent={{56,74},{76,94}})));
  final parameter Modelica.SIunits.HeatFlowRate QCon_heatflow_nominal = -QEva_heatflow_nominal + P_nominal
    "Nominal heat flow at the condenser"
     annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.SIunits.HeatFlowRate QEva_heatflow_nominal= per.QEva_flow_nominal
    "Reference capacity"
     annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.SIunits.Power         P_nominal = -QEva_heatflow_nominal/COP_nominal
    "Nominal power of the compressor";
  final parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal=per.mCon_flow_nominal
    "Nominal mass flow at Condenser"
     annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal=per.mEva_flow_nominal
    "Nominal mass flow at Evaorator"
     annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.SIunits.Temperature TConEnt_nominal=per.TConEnt_nominal
    "Temperature of fluid entering condenser at nominal condition"
     annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.SIunits.Temperature TEvaLvg_nominal=per.TEvaLvg_nominal
    "Temperature of fluid leaving condenser at nominal condition"
     annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.SIunits.Temperature TConEntMin=per.TConEntMin
    "Minimum temperature of fluid entering condenser at nominal condition"
     annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.SIunits.Temperature TConEntMax=per.TConEntMax
    "Maximum temperature of fluid entering condenser at nominal condition"
     annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.SIunits.Temperature TEvaLvgMax= per.TEvaLvgMax
    "Maximum temperature of fluid leaving evaporator  at nominal condition"
     annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.SIunits.Temperature TEvaLvgMin=per.TEvaLvgMin
    "Minimum temperature of fluid leaving evaporator  at nominal condition"
     annotation (Dialog(group="Nominal condition"));
  final parameter  Modelica.SIunits.Efficiency   COP_nominal=per.COP_nominal
    "Nominal coefficient of performance"
     annotation (Dialog(group="Nominal condition"));
  final parameter Real PLRMax =    per.PLRMax
    "Maximum part load ratio"
     annotation (Dialog(group="Nominal condition"));
  final parameter Real PLRMinUnl = per.PLRMinUnl
    "Minimum part unload ratio"
     annotation (Dialog(group="Nominal condition"));
  final parameter Real PLRMin =    per. PLRMin
    "Minimum part load ratio"
     annotation (Dialog(group="Nominal condition"));
  final parameter Real etaMotor(min=0, max=1)= per.etaMotor
    "Fraction of compressor motor heat entering refrigerant"
     annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.SIunits.HeatFlowRate Q_flow_small = QCon_heatflow_nominal*1E-9
    "Small value for heat flow rate or power, used to avoid division by zero";

  Real capFunT(min=0,nominal=1)
  "CooTConEntMaxling capacity factor function of temperature curve";
  Modelica.SIunits.Efficiency EIRFunT(nominal=1)
    "Power input to ccoling capacity ratio function of temperature curve";
  Modelica.SIunits.Efficiency EIRFunPLR(nominal=1)
    "Power input to cooling capacity ratio function of part load ratio";

  Real PLR1(min=0, nominal=1, unit="1") "Part load ratio";
  Real PLR2(min=0, nominal=1, unit="1") "Part load ratio";
  Real CR(min=0, nominal=1, unit="1")   "Cycling ratio";

  Modelica.SIunits.HeatFlowRate QCon_flow_ava
   "Heating capacity available at the condender";
  Modelica.SIunits.HeatFlowRate QEva_flow_ava
    "Cooling capacity available at the Evaporator";
  Modelica.SIunits.Efficiency   COP
   "Coefficient of performance";

  Modelica.Blocks.Interfaces.RealInput TEvaSet(final unit="K", displayUnit="degC")
   "Set point for leaving chilled water temperature"
    annotation (Placement(
        transformation(extent={{-124,-112},{-100,-88}}), iconTransformation(
          extent={{-118,-108},{-100,-90}})));
  Modelica.Blocks.Interfaces.RealInput TConSet(final unit="K", displayUnit="degC")
   "Set point for leaving heating water temperature"
    annotation (Placement(
        transformation(extent={{-122,88},{-100,110}}), iconTransformation(
          extent={{-120,90},{-100,110}})));
  Modelica.Blocks.Interfaces.IntegerInput uMod
   "HeatPump control input signal, Heating mode= 1, Off=0, Cooling mode=-1" annotation (Placement(transformation(extent={{-124,
            -12},{-100,12}}),
        iconTransformation(extent={{-118,-10},{-100,8}})));
  Modelica.Blocks.Interfaces.RealInput TConEnt(final unit="K", displayUnit="degC")
   "Condenser entering water temperature"
    annotation (Placement(transformation(extent={{-124,48},{-100,72}}),iconTransformation(extent={{-120,56},
            {-100,76}})));
  Modelica.Blocks.Interfaces.RealInput TEvaLvg(final unit="K", displayUnit="degC")
   "Evaporator leaving water temperature"
    annotation (Placement(transformation(extent={{-124,-72},{-100,-48}}), iconTransformation(extent={{-118,
            -58},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealInput QConFloSet(final unit="W", displayUnit="W")
   "Condenser setpoint heat flow rate"
    annotation (Placement(transformation(
          extent={{-124,28},{-100,52}}), iconTransformation(extent={{-120,10},{-100,
            30}})));
  Modelica.Blocks.Interfaces.RealInput QEvaFloSet(final unit="W", displayUnit="W")
   "Evaporator setpoint heat flow rate"
    annotation (Placement(transformation(
          extent={{-124,-52},{-100,-28}}), iconTransformation(extent={{-118,-36},
            {-100,-18}})));
  Modelica.Blocks.Interfaces.RealInput TConLvg(final unit="K", displayUnit="degC")
   "Condenser leaving water temperature"
    annotation (Placement(transformation(
          extent={{-124,66},{-100,90}}), iconTransformation(extent={{-120,32},{-100,
            52}})));
  Modelica.Blocks.Interfaces.RealInput TEvaEnt(final unit="K", displayUnit="degC")
   "Evaporatorenetering water temperature"
    annotation (Placement(
        transformation(extent={{-124,-92},{-100,-68}}), iconTransformation(
          extent={{-118,-84},{-100,-66}})));
  Modelica.Blocks.Interfaces.RealOutput QCon(final unit="W", displayUnit="W")
    "Condenser heat flow rate "
    annotation (Placement(transformation(extent={{
            100,30},{120,50}}), iconTransformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput QEva(final unit="W", displayUnit="W")
    "Evaporator heat flow rate"
    annotation (Placement(transformation(extent={{
            100,-48},{120,-28}}), iconTransformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.RealOutput P(        final unit="W", displayUnit="W")
   "Compressor power"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),iconTransformation(extent={{100,-10},
            {120,10}})));

  Modelica.SIunits.Conversions.NonSIunits.Temperature_degC TConEnt_degC;
  Modelica.SIunits.Conversions.NonSIunits.Temperature_degC TEvaLvg_degC;

initial equation
  assert(QCon_heatflow_nominal > 0,
  "Parameter QCon_flow_nominal must be larger than zero.");
  assert(QEva_heatflow_nominal < 0,
  "Parameter QEva_heatflow_nominal must be lesser than zero.");
  assert(Q_flow_small > 0,
  "Parameter Q_flow_small must be larger than zero.");
  assert(PLRMinUnl >= PLRMin,
  "Parameter PLRMinUnl must be bigger or equal to PLRMin");
  assert(PLRMax > PLRMinUnl,
  "Parameter PLRMax must be bigger than PLRMinUnl");

equation
  TConEnt_degC=Modelica.SIunits.Conversions.to_degC(TConEnt);
  TEvaLvg_degC=Modelica.SIunits.Conversions.to_degC( TEvaLvg);

  if (uMod==1) then

    capFunT = Buildings.Utilities.Math.Functions.smoothMax(
       x1 = 1E-7,
       x2 = Buildings.Utilities.Math.Functions.biquadratic(
         a= per.capFunT,
         x1=TEvaLvg_degC,
         x2=TConEnt_degC),
       deltaX = 1E-7);

    EIRFunT = Buildings.Utilities.Math.Functions.biquadratic(
     a=per.EIRFunT,
     x1=TEvaLvg_degC,
     x2=TConEnt_degC);

    EIRFunPLR= per.EIRFunPLR[1]+per.EIRFunPLR[2]*PLR2+per.EIRFunPLR[3]*PLR2^2;

    QCon_flow_ava = QCon_heatflow_nominal*capFunT;
    QEva_flow_ava = 0;

    // Part load ratio
    PLR1 =Buildings.Utilities.Math.Functions.smoothMax(
      x1=QConFloSet/(QCon_flow_ava - Q_flow_small),
      x2=PLRMax,
      deltaX=PLRMax/100);

    PLR2 = Buildings.Utilities.Math.Functions.smoothMax(
      x1 = PLRMinUnl,
      x2 = PLR1,
      deltaX = PLRMinUnl/100);

    // Cycling ratio.
    CR = Buildings.Utilities.Math.Functions.smoothMin(
      x1 = PLR1/PLRMin,
      x2 = 1,
      deltaX=0.001);

    //Compressor power.
    P =  (QCon_flow_ava/COP_nominal)*EIRFunT*EIRFunPLR*CR;

    QCon = Buildings.Utilities.Math.Functions.smoothMin(
      x1=QConFloSet,
      x2=QCon_flow_ava,
      deltaX=Q_flow_small/10);

    QEva = -(QCon - P*etaMotor);

    COP =QCon/(P + Q_flow_small);

    elseif (uMod==-1) then

     capFunT = Buildings.Utilities.Math.Functions.smoothMax(
       x1 = 1E-6,
       x2 = Buildings.Utilities.Math.Functions.biquadratic(
         a=per.capFunT,
         x1=TEvaLvg_degC,
         x2=TConEnt_degC),
       deltaX = 1E-7);
    // Heatpump energy input ratio biquadratic curve.
      EIRFunT = Buildings.Utilities.Math.Functions.biquadratic(
         a=per.EIRFunT,
         x1=TEvaLvg_degC,
         x2=TConEnt_degC);
    // HeatPump energy input ratio quadratic curve
      EIRFunPLR= per.EIRFunPLR[1]+per.EIRFunPLR[2]*PLR2+per.EIRFunPLR[3]*PLR2^2;
      QEva_flow_ava = QEva_heatflow_nominal*capFunT;
      QCon_flow_ava = 0;

      PLR1 =Buildings.Utilities.Math.Functions.smoothMin(
        x1=QEvaFloSet/(QEva_flow_ava - Q_flow_small),
        x2=PLRMax,
        deltaX=PLRMax/100);
      PLR2 = Buildings.Utilities.Math.Functions.smoothMax(
        x1 = PLRMinUnl,
        x2 = PLR1,
        deltaX = PLRMinUnl/100);
      CR = Buildings.Utilities.Math.Functions.smoothMin(
        x1 = PLR1/PLRMin,
        x2 = 1,
        deltaX=0.001);

      P = (-QEva_flow_ava)/COP_nominal*EIRFunT*EIRFunPLR*CR;
      QEva = Buildings.Utilities.Math.Functions.smoothMax(
        x1=QEvaFloSet,
        x2=QEva_flow_ava,
        deltaX=Q_flow_small/10);
      QCon = -QEva + P*etaMotor;
      COP =-QEva/(P + Q_flow_small);

      else
          capFunT = 0;
          EIRFunT = 0;
          EIRFunPLR= 0;
          QEva_flow_ava = 0;
          QCon_flow_ava = 0;
          PLR1 = 0;
          PLR2 = 0;
          CR   = 0;
          QCon = 0;
          QEva = 0;
          P    = 0;
          COP = 0;
  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={ Text(
          extent={{-152,100},{148,140}},
          lineColor={0,0,255},
          textString="%name")}),Diagram(coordinateSystem(preserveAspectRatio=false)),
  defaultComponentName="doe2",
  Documentation(info="<html>
<p>
The Block includes the description of the DOE2 method dedicated for<a href=\"Buildings.Fluid.HeatPumps.DOE2WaterToWater\">
Buildings.Fluid.HeatPumps.DOE2WaterToWater</a>.
</p>

<h4>Implementation</h4>
<p>
The block uses three functions to predict the thermal capacity and power consumption for
either the heating mode-uMod=+1 or the cooling mode uMod=-1:
</p>

<ul>
<li>
<p>
The capacity function of temperature bi-quadratic curve:
</p>
<p align=\"left\" style=\"font-style:italic;\">
CAPFT = A<sub>1</sub>+ A<sub>2</sub>T<sub>Eva,Lvg</sub>+
A<sub>3</sub>T<sup>2</sup><sub>Eva,Lvg</sub>+ A<sub>4</sub>T<sub>Con,Ent</sub>+A<sub>5</sub>T<sup>2</sup><sub>Con,Ent</sub>
+A<sub>6</sub>T<sub>Con,Ent</sub>T<sub>Eva,Lvg</sub>
</li>
</ul>

<ul>
<li>
<p>
The electric input to capacity output ratio function of temperature bi-quadratic curve:
</p>
<p align=\"left\" style=\"font-style:italic;\">
EIRFT = A<sub>7</sub>+ A<sub>8</sub>T<sub>Eva,Lvg</sub>+
A<sub>9</sub>T<sup>2</sup><sub>Eva,Lvg</sub>+ A<sub>10</sub>T<sub>Con,Ent</sub>+A<sub>11</sub>T<sup>2</sup><sub>Con,Ent</sub>
+A<sub>12</sub>T<sub>Con,Ent</sub>T<sub>Eva,Lvg</sub>
</li>
</ul>

<ul>
<li>
<p>
The electric input to capacity output ratio function of part load ratio bi-cubic curve:
</p>
<p align=\"left\" style=\"font-style:italic;\">
EIRFPLR = A<sub>13</sub>+ A<sub>14</sub>PLR+A<sub>15</sub>PLR<sup>2</sup>
</li>
</ul>
<p>
These curves are stored in the data record <code>per</code> and are available from
<a href=\"Buildings.Fluid.Chillers.Data.ElectricEIR\">
Buildings.Fluid.Chillers.Data.ElectricEIR</a>.
Additional performance curves can be developed using
two available techniques (Hydeman and Gillespie, 2002). The first technique is called the
Least-squares Linear Regression method and is used when sufficient performance data exist
to employ standard least-square linear regression techniques. The second technique is called
Reference Curve Method and is used when insufficient performance data exist to apply linear
regression techniques. A detailed description of both techniques can be found in
Hydeman and Gillespie (2002).
</p>
<p>
The model has three tests on the part load ratio and the cycling ratio:
</p>
<ol>
<li>
The test<pre>
  PLR1 =min(QEva_flow_set/QEva_flow_ava, per.PLRMax);
</pre>
ensures that the heatpump capacity does not exceed the heatpump capacity specified
by the parameter <code>per.PLRMax</code>.
</li>
<li>
The test <pre>
  CR = min(PLR1/per.PRLMin, 1.0);
</pre>
computes a cycling ratio. This ratio expresses the fraction of time
that a heatpump would run if it were to cycle because its load is smaller than the
minimal load at which it can operate.
Note that this model continuously operates even if the part load ratio is below the minimum part load ratio.
Its leaving evaporator and condenser temperature can therefore be considered as an
average temperature between the modes where the compressor is off and on.
</li>
<li>
The test <pre>
  PLR2 = max(per.PLRMinUnl, PLR1);
</pre>
computes the part load ratio of the compressor.
The assumption is that for a part load ratio below <code>per.PLRMinUnl</code>,
the heatpump uses hot gas bypass to reduce the capacity, while the compressor
power draw does not change.
</li>
</ol>
<p>
The electric power only contains the power for the compressor, but not any power for pumps or fans.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 19, 2019, by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end DOE2Method;
