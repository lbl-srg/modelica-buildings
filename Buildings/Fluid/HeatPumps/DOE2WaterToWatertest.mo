within Buildings.Fluid.HeatPumps;
model DOE2WaterToWatertest "Water source heat pump_Performance curve"
//testtesttest
 extends Buildings.Fluid.Interfaces.FourPortHeatMassExchanger(
   m2_flow_nominal = mEva_flow_nominal,
   T1_start = 273.15+25,
   T2_start = 273.15+5,
   redeclare final Buildings.Fluid.MixingVolumes.MixingVolume vol2(
      V=m2_flow_nominal*tau2/rho2_nominal,
      nPorts=2,
      final prescribedHeatFlowRate=true),
    vol1(
      final prescribedHeatFlowRate=true),
    dp1_nominal=200,
    dp2_nominal=200,
    m1_flow_nominal=mCon_flow_nominal);

 Modelica.Blocks.Interfaces.IntegerInput heaPumMod
    "Heating=+1, Off=0, Cooling=-1" annotation (Placement(transformation(extent={{-132,
            -114},{-100,-82}}),      iconTransformation(extent={{-126,-108},{-100,
            -82}})));
 Modelica.Blocks.Interfaces.RealOutput P(final quantity="Power", unit="W", max=P_nominal_H)
    "Electric power consumed by compressor"
    annotation (Placement(transformation(extent={{100,80},{120,100}}),
        iconTransformation(extent={{100,80},{120,100}})));
 Modelica.Blocks.Interfaces.RealInput TEvaSet(final unit="K", displayUnit="degC")
    "Set point for leaving chilled water temperature" annotation (Placement(
        transformation(extent={{-128,-14},{-100,14}}),iconTransformation(extent={{-126,
            -12},{-100,14}})));
 Modelica.Blocks.Interfaces.RealInput TConSet(final unit="K", displayUnit="degC")
    "Set point for leaving chilled water temperature" annotation (Placement(
        transformation(extent={{-126,88},{-102,112}}), iconTransformation(
          extent={{-118,78},{-94,102}})));
//--------------------------------------------------------------------------
parameter HeatPumps.Data.DOE2WaterToWater.Generic per annotation (
      choicesAllMatching=true, Placement(transformation(extent={{48,66},{68,86}})));

//--------------------------------------------------------------------------

 final parameter Real RatioNomCooCap=0.75;
 final parameter Real RatioNomCooPow=1.5;

 final parameter Modelica.SIunits.Power         P_nominal_C = -QEva_flow_nominal/COP_nominal_C
 "Reference coefficient of performance";
 final parameter Modelica.SIunits.HeatFlowRate  QEva_flow_nominal_H= RatioNomCooCap * QEva_flow_nominal;
 final parameter Modelica.SIunits.Power         P_nominal_H = P_nominal_C*RatioNomCooPow
 "Reference coefficient of performance";
 final parameter Modelica.SIunits.HeatFlowRate QCon_flow_nominal = - QEva_flow_nominal_H+P_nominal_H;
 final parameter Modelica.SIunits.Efficiency   COP_nominal_H= -QEva_flow_nominal_H/P_nominal_H;

 final parameter Modelica.SIunits.Efficiency   COP_nominal_C= per.COP_nominal
 "Reference coefficient of performance";

 final parameter Real PLRMax =    per.PLRMax               "Maximum part load ratio";
 final parameter Real PLRMinUnl = per.PLRMinUnl            "Minimum part unload ratio";
 final parameter Real PLRMin =    per. PLRMin              "Minimum part load ratio";
 final parameter Real etaMotor(min=0, max=1)= per.etaMotor "Fraction of compressor motor
  heat entering refrigerant";

 final parameter Modelica.SIunits.HeatFlowRate  QEva_flow_nominal= per.QEva_flow_nominal;

 final parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal= per.mCon_flow_nominal
    "Nominal mass flow at Condenser"
     annotation (Dialog(group="Nominal condition"));
 final parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal= per.mEva_flow_nominal
    "Nominal mass flow at Evaorator"
     annotation (Dialog(group="Nominal condition"));

 final parameter Modelica.SIunits.Temperature TConEnt_nominal= per.TConEnt_nominal
    "Nominal leaving Condenser temperature";
 final parameter Modelica.SIunits.Temperature TEvaLvg_nominal= per.TEvaLvg_nominal
    "Nominal leaving Evaporator temperature";

 final parameter Modelica.SIunits.Temperature TConEntMin = per.TConEntMin
    "Minimum value for entering Condenser temperature"
    annotation (Dialog(group="Performance curves"));
 final parameter Modelica.SIunits.Temperature TConEntMax = per.TConEntMax
    "Maximum value for entering Condenser temperature"
    annotation (Dialog(group="Performance curves"));
 final parameter Modelica.SIunits.Temperature TEvaLvgMin = per.TEvaLvgMin
    "Maximum value for entering Evaporator temperature"
    annotation (Dialog(group="Performance curves"));
 final parameter Modelica.SIunits.Temperature TEvaLvgMax = per.TEvaLvgMax
    "Maximum value for entering Evaporator temperature"
    annotation (Dialog(group="Performance curves"));

 final parameter Modelica.SIunits.HeatFlowRate Q_flow_small = QCon_flow_nominal*1E-9
    "Small value for heat flow rate or power, used to avoid division by zero";

  Modelica.SIunits.HeatFlowRate QCon_flow "Condenser heat input";
  Modelica.SIunits.HeatFlowRate QEva_flow "Evaorator heat input";

// Variables definition
  Modelica.SIunits.Temperature  TEvaEnt "Evaorator entering temperature";
  Modelica.SIunits.Temperature  TEvaLvg "Evaorator leaving temperature";
  Modelica.SIunits.Temperature  TConEnt "Condenser entering temperature";
  Modelica.SIunits.Temperature  TConLvg "Condenser leaving temperature";
  Modelica.SIunits.Efficiency   COP "Coefficient of performance";

   Modelica.SIunits.HeatFlowRate QCon_flow_ava
    "Heating capacity available at Condenser";
  Modelica.SIunits.HeatFlowRate QCon_flow_set
     "Heating capacity setpoint at Condenser";
  Modelica.SIunits.HeatFlowRate QEva_flow_ava
    "Cooling capacity available at Evaporator";
  Modelica.SIunits.HeatFlowRate QEva_flow_set
    "Heating capacity required to heat to set point temperature";

  Modelica.SIunits.SpecificEnthalpy hConSet
    "Enthalpy setpoint for heating water";
  Modelica.SIunits.SpecificEnthalpy hEvaSet
    "Enthalpy setpoint for cooling water";
  Modelica.SIunits.SpecificEnthalpy hEva
    "Enthalpy setpoint for heating water";
  Modelica.SIunits.SpecificEnthalpy hCon
    "Enthalpy setpoint for heating water";

  Real capFunT(min=0,nominal=1)
  "CooTConEntMaxling capacity factor function of temperature curve";

  Modelica.SIunits.Efficiency EIRFunT(nominal=1)
    "Power input to ccoling capacity ratio function of temperature curve";

  Modelica.SIunits.Efficiency EIRFunPLR(nominal=1)
    "Power input to cooling capacity ratio function of part load ratio";

// Part load variables
  Real PLR1(min=0, nominal=1, unit="1") "Part load ratio";
  Real PLR2(min=0, nominal=1, unit="1") "Part load ratio";
  Real CR(min=0, nominal=1, unit="1")   "Cycling ratio";

protected
  Modelica.Blocks.Sources.RealExpression QCon_flow_in(final y=QCon_flow)
    "Condenser heat flow rate"
    annotation (Placement(transformation(extent={{-78,24},{-58,44}})));
  HeatTransfer.Sources.PrescribedHeatFlow preHeaFloCon
    "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{-41,24},{-21,44}})));
  Modelica.Blocks.Sources.RealExpression QEva_flow_in(y=QEva_flow)
    "Evaorator heat flow rate"
    annotation (Placement(transformation(extent={{84,-50},{64,-30}})));
  HeatTransfer.Sources.PrescribedHeatFlow preHeaFloEva "Prescribed heat flow rate"
  annotation (Placement(transformation(extent={{51,-50},{31,-30}})));

 //--------------------------------------------------------------------------

//--------------------------------------------------------------------------

//perfromance curve functions-variables defintion

 //--------------------------------------------------------------------------

 // setpoint variables for Evaporator and Condenser

Modelica.SIunits.Conversions.NonSIunits.Temperature_degC TEvaLvg_degC=
    Modelica.SIunits.Conversions.to_degC(TEvaLvg);

Modelica.SIunits.Conversions.NonSIunits.Temperature_degC TConEnt_degC=
    Modelica.SIunits.Conversions.to_degC(TEvaEnt);

initial equation
  assert(QCon_flow_nominal > 0, "Parameter QCon_flow_nominal must be greater than zero.");
  assert(QEva_flow_nominal < 0, "Parameter QEva_flow_nominal must be lesser than zero.");
  assert(Q_flow_small > 0, "Parameter Q_flow_small must be larger than zero.");
  assert(PLRMinUnl >= PLRMin, "Parameter PLRMinUnl must be bigger or equal to PLRMin");
  assert(PLRMax > PLRMinUnl, "Parameter PLRMax must be bigger than PLRMinUnl");

equation

  TConEnt = Medium1.temperature(Medium1.setState_phX(port_a1.p,
  inStream(port_a1.h_outflow),inStream(port_a1.Xi_outflow)));
  TConLvg =vol1.heatPort.T;

  // Evaorator temperatures
  TEvaEnt = Medium2.temperature(Medium2.setState_phX(port_a2.p,
  inStream(port_a2.h_outflow),inStream(port_a2.Xi_outflow)));
  TEvaLvg = vol2.heatPort.T;

 // TEvaEnt_degC = Modelica.SIunits.Conversions.to_degC(TEvaEnt);
  //TConLvg_degC = Modelica.SIunits.Conversions.to_degC(TConLvg);

  if (heaPumMod==1) then

/* Compute the chiller capacity fraction, using a biquadratic curve.
   Since the regression for capacity can have negative values
    (for unreasonable temperatures),we constrain its return value to be non-negative. 
   This prevents the solver to pick the unrealistic solution.
  */
      // Enthalpy of temperature setpoint (Evaporator)
  hConSet=Medium1.specificEnthalpy_pTX(
      p=port_b1.p,
      T=TConSet,
      X=cat(
        1,
        port_b1.Xi_outflow,
        {1 - sum(port_b1.Xi_outflow)}));

  hEvaSet=0;

  hEva=Medium2.specificEnthalpy_pTX(
      p=port_b2.p,
      T=TEvaLvg,
      X=cat(
        1,
        port_b2.Xi_outflow,
        {1 - sum(port_b2.Xi_outflow)}));
  hCon=0;

  capFunT = Buildings.Utilities.Math.Functions.smoothMax(
       x1 = 1E-7,
       x2 = Buildings.Utilities.Math.Functions.biquadratic(
         a=per.capFunT,
         x1=TConEnt_degC,
         x2=TEvaLvg_degC),
       deltaX = 1E-7);

    // Heatpump energy input ratio biquadratic curve.
  EIRFunT = Buildings.Utilities.Math.Functions.biquadratic(
     a=per.EIRFunT,
     x1=TConEnt_degC,
     x2=TEvaLvg_degC);

    // HeatPump energy input ratio quadratic curve
  EIRFunPLR= per.EIRFunPLR[1]+per.EIRFunPLR[2]*PLR2+per.EIRFunPLR[3]*PLR2^2;

    // Available Heating capacity
  QEva_flow_ava = QEva_flow_nominal_H*capFunT;

  QCon_flow_ava = (-QEva_flow_ava) + P;

    // Part load ratio
  PLR1 = Buildings.Utilities.Math.Functions.smoothMax(
      x1 = QCon_flow_set/(QCon_flow_ava+Q_flow_small),
      x2 = PLRMax,
      deltaX=PLRMax/100);
    // PLR2 is the compressor part load ratio. The lower bound PLRMinUnl is
    // since for PLR1<PLRMinUnl, the heatpump uses hot gas bypass, under which
    // condition the compressor power is assumed to be the same as if the Heatpump
    // were to operate at PLRMinUnl

  PLR2 = Buildings.Utilities.Math.Functions.smoothMax(
      x1 = PLRMinUnl,
      x2 = PLR1,
      deltaX = PLRMinUnl/100);

    // Cycling ratio.
    // Due to smoothing, this can be about deltaX/10 above 1.0
  CR = Buildings.Utilities.Math.Functions.smoothMin(
      x1 = PLR1/PLRMin,
      x2 = 1,
      deltaX=0.001);

    // Compressor power.
  P =  (-QEva_flow_ava/COP_nominal_H)*EIRFunT*EIRFunPLR*CR;
    // Heat flow rates into Evaorator and condenser

    // Cooling capacity required to chill water to setpoint
  QCon_flow_set = Buildings.Utilities.Math.Functions.smoothMax(
      x1 = m1_flow*(hConSet-inStream(port_a1.h_outflow)),
      x2= Q_flow_small,
      deltaX= Q_flow_small/10);
  QEva_flow_set=0;

  QCon_flow = Buildings.Utilities.Math.Functions.smoothMin(
      x1 = QCon_flow_set,
      x2 = QCon_flow_ava,
      deltaX= Q_flow_small/10);

  //QCon_flow = max(QCon_flow_set, QCon_flow_ava);
  QEva_flow = - (QCon_flow - P*etaMotor);
    // Coefficient of performance
  COP = QCon_flow/(P+Q_flow_small);

  elseif (heaPumMod==-1) then

     // Enthalpy of temperature setpoint (Evaporator)
  hEvaSet=Medium2.specificEnthalpy_pTX(
      p=port_b2.p,
      T=TEvaSet,
      X=cat(
        1,
        port_b2.Xi_outflow,
        {1 - sum(port_b2.Xi_outflow)}));
  hConSet=0;

  hCon=Medium1.specificEnthalpy_pTX(
      p=port_b1.p,
      T=TConLvg,
      X=cat(
        1,
        port_b1.Xi_outflow,
        {1 - sum(port_b1.Xi_outflow)}));
   hEva=0;

   capFunT = Buildings.Utilities.Math.Functions.smoothMax(
       x1 = 1E-6,
       x2 = Buildings.Utilities.Math.Functions.biquadratic(
         a=per.capFunT,
         x1=TConEnt_degC,
         x2=TEvaLvg_degC),
       deltaX = 1E-7);

    // Heatpump energy input ratio biquadratic curve.
    EIRFunT = Buildings.Utilities.Math.Functions.biquadratic(
     a=per.EIRFunT,
     x1=TConEnt_degC,
     x2=TEvaLvg_degC);

    // HeatPump energy input ratio quadratic curve
    EIRFunPLR= per.EIRFunPLR[1]+per.EIRFunPLR[2]*PLR2+per.EIRFunPLR[3]*PLR2^2;

    // Available Heating capacity
    QEva_flow_ava = QEva_flow_nominal*capFunT;
    QCon_flow_ava  =0;

    // Cooling capacity required to chill water to setpoint
    QEva_flow_set = Buildings.Utilities.Math.Functions.smoothMin(
      x1 = m2_flow*(hEvaSet-inStream(port_a2.h_outflow)),
      x2= -Q_flow_small,
      deltaX= Q_flow_small/10);
    QCon_flow_set=0;

    // Part load ratio
    PLR1 = Buildings.Utilities.Math.Functions.smoothMin(
      x1 = QEva_flow_set/(QEva_flow_ava-Q_flow_small),
      x2 = PLRMax,
      deltaX=PLRMax/100);
    // PLR2 is the compressor part load ratio. The lower bound PLRMinUnl is
    // since for PLR1<PLRMinUnl, the heatpump uses hot gas bypass, under which
    // condition the compressor power is assumed to be the same as if the Heatpump
    // were to operate at PLRMinUnl

    PLR2 = Buildings.Utilities.Math.Functions.smoothMax(
      x1 = PLRMinUnl,
      x2 = PLR1,
      deltaX = PLRMinUnl/100);

    // Cycling ratio.
    // Due to smoothing, this can be about deltaX/10 above 1.0
    CR = Buildings.Utilities.Math.Functions.smoothMin(
      x1 = PLR1/PLRMin,
      x2 = 1,
      deltaX=0.001);

    // Compressor power.
    P = (-QEva_flow_ava)/COP_nominal_C*EIRFunT*EIRFunPLR*CR;
    // Heat flow rates into Evaorator and condenser

    QEva_flow = Buildings.Utilities.Math.Functions.smoothMax(
      x1 = QEva_flow_set,
      x2 = QEva_flow_ava,
      deltaX= Q_flow_small/10);

  //QCon_flow = max(QCon_flow_set, QCon_flow_ava);
    QCon_flow = - QEva_flow+ P*etaMotor;
    // Coefficient of performance
    COP = -QEva_flow/(P+Q_flow_small);

    else
    hEvaSet =0;
    hConSet =0;
    hCon=0;
    hEva=0;

    capFunT = 0;
    EIRFunT = 0;
    EIRFunPLR= 0;

    QEva_flow_ava = 0;
    QCon_flow_ava = 0;

    QEva_flow_set = 0;
    QCon_flow_set = 0;

    PLR1 = 0;
    PLR2 = 0;
    CR   = 0;

    QCon_flow = 0;
    QEva_flow = 0;
    P    = 0;
    COP = 0;

   end if;

//--------------------------------------------------------------------------

  connect(QEva_flow_in.y, preHeaFloEva.Q_flow) annotation (Line(points={{63,-40},
          {51,-40}},
   color={0,0,127}));
  connect(QCon_flow_in.y, preHeaFloCon.Q_flow) annotation (Line(points={{-57,34},
          {-48,34},{-48,34},{-41,34}}, color={0,0,127}));

  connect(preHeaFloCon.port,vol1.heatPort)
  annotation (Line(points={{-21,34},{-16,34},{-16,60},{-10,60}}, color={191,0,0}));

  connect(preHeaFloEva.port,vol2.heatPort)
  annotation (Line(points={{31,-40},{12,-40},{12,-60}},
                                       color={191,0,0}));

  connect(port_a2, port_a2) annotation (Line(points={{100,-60},{105,-60},{105,-60},
          {100,-60}}, color={0,127,255}));
    annotation (choicesAllMatching=true,Placement(transformation(extent={{48,66},{68,86}})),
                choicesAllMatching=true,Placement(transformation(extent={{48,66},{68,86}})),
                choicesAllMatching=true,Placement(transformation(extent={{48,66},{68,86}})),
              Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},
            {100,100}}),       graphics={
        Rectangle(
          extent={{-92,96},{94,-94}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Rectangle(
          extent={{-66,78},{70,50}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,-46},{70,-74}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-103,64},{98,54}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,54},{98,64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-101,-56},{100,-66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-66},{0,-56}},
          lineColor={0,0,127},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,0},{-52,-12},{-32,-12},{-42,0}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Polygon(
          points={{-42,0},{-52,10},{-32,10},{-42,0}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Rectangle(
          extent={{-44,50},{-40,10}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,-12},{-40,-52}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{38,50},{42,-52}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{18,22},{62,-20}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Polygon(
          points={{40,22},{22,-10},{58,-10},{40,22}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{0,68},{0,90},{90,90},{100,90}},
                                                 color={0,0,255})}),
    defaultComponentName="heaPum",
    Documentation(info="<html>
<p>

Model of water to water heatpump which predicts thermal performance of cooling,
heating and simultaneous heating and cooling modes based on the DOE-2.1 chiller model and
the Energy Plus chiller model
 <code>Chiller:Electric:EIR</code>.
</p>
<p> This model uses three functions to predict capacity and power consumption:
</p>
<ul>
<li>
A biquadratic function is used to predict cooling capacity as a function of
condenser entering and evaporator leaving fluid temperature.
</li>
<li>
A quadratic functions is used to predict power input to cooling capacity ratio with respect to the part load ratio.
</li>
<li>
A biquadratic functions is used to predict power input to cooling capacity ratio as a function of
condenser entering and evaporator leaving fluid temperature.
</li>
</ul>
<p>
These curves are stored in the data record <code>per</code> and are available from
<a href=\"Buildings.Fluid.HeatPumps.Data.DOE2WaterToWater\">
Buildings.Fluid.HeatPumps.Data.DOE2WaterToWater</a>.

Additional performance curves can be developed using
two available techniques (Hydeman and Gillespie, 2002). The first technique is called the
Least-squares Linear Regression method and is used when sufficient performance data exist
to employ standard least-square linear regression techniques. The second technique is called
Reference Curve Method and is used when insufficient performance data exist to apply linear
regression techniques. A detailed description of both techniques can be found in
Hydeman and Gillespie (2002).
</p>
<p>
The model takes as an input the set point for the leaving chilled water temperature,
which is met if the chiller has sufficient cooling capacity or the leaving heating water
temperature which is met if the chiller has sufficient heating capacity
Thus, the model has a built-in, ideal temperature control.
The model has three tests on the part load ratio and the cycling ratio:
</p>
<ol>
<li>
The test<pre>
  PLR1 =min(QEva_flow_set/QEva_flow_ava, per.PLRMax);
</pre>
ensures that the chiller capacity does not exceed the chiller capacity specified
by the parameter <code>per.PLRMax</code>.
</li>
<li>
The test <pre>
  CR = min(PLR1/per.PRLMin, 1.0);
</pre>
computes a cycling ratio. This ratio expresses the fraction of time
that a chiller would run if it were to cycle because its load is smaller than the
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
the chiller uses hot gas bypass to reduce the capacity, while the compressor
power draw does not change.
</li>
</ol>
<p>
The electric power only contains the power for the compressor, but not any power for pumps or fans.
</p>
<p>
The model can be parametrized to compute a transient
or steady-state response.
The transient response of the chiller is computed using a first
order differential equation for the evaporator and condenser fluid volumes.
The chiller outlet temperatures are equal to the temperatures of these lumped volumes.
</p>
<h4>References</h4>
<ul>
<li>
Hydeman, M. and K.L. Gillespie. 2002. Tools and Techniques to Calibrate Electric Chiller
Component Models. <i>ASHRAE Transactions</i>, AC-02-9-1.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
June 10, 2019, by Hagar Elarga:<br/>
Refactored model to include heating and simultaneous heating and cooling modes

</li>
<li>
March 12, 2015, by Michael Wetter:<br/>
Refactored model to make it once continuously differentiable.
This is for issue <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/373\">373</a>.
</li>
<li>
Jan. 9, 2011, by Michael Wetter:<br/>
Added input signal to switch chiller off.
</li>
<li>
Sep. 8, 2010, by Michael Wetter:<br/>
Revised model and included it in the Buildings library.
</li>
<li>
October 13, 2008, by Brandon Hencey:<br/>
First implementation.
</li>
</ul>
</html>"));
end DOE2WaterToWatertest;
