within Buildings.Fluid.HeatPumps;
model WaterSourceHeatPump2 "Water source heat pump_Equation Fit"
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

 Modelica.Blocks.Interfaces.BooleanInput on
    "Set to true to enable compressor, or false to disable compressor"
    annotation (Placement(transformation(extent={{-140,10},{-100,50}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
 Modelica.Blocks.Interfaces.RealInput TSet(final unit="K", displayUnit="degC")
    "Set point for leaving chilled water temperature"
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
 Modelica.Blocks.Interfaces.RealOutput P(final quantity="Power", unit="W")
    "Electric power consumed by compressor"
    annotation (Placement(transformation(extent={{100,80},{120,100}}),
        iconTransformation(extent={{100,80},{120,100}})));

//--------------------------------------------------------------------------

  Modelica.Blocks.Sources.RealExpression QCon_flow_in(final y=QCon_flow)
    "Condenser heat flow rate"
    annotation (Placement(transformation(extent={{-78,24},{-58,44}})));
  HeatTransfer.Sources.PrescribedHeatFlow preHeaFloCon
    "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{-41,24},{-21,44}})));
  Modelica.Blocks.Sources.RealExpression QEva_flow_in(y=QEva_flow)
    "Evaorator heat flow rate"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  HeatTransfer.Sources.PrescribedHeatFlow preHeaFloEva "Prescribed heat flow rate" annotation (Placement(transformation(extent={{-37,-50},{-17,-30}})));

 //--------------------------------------------------------------------------

// Variables definition
  Modelica.SIunits.Temperature TEvaEnt "Evaorator entering temperature";
  Modelica.SIunits.Temperature TEvaLvg "Evaorator leaving temperature";
  Modelica.SIunits.Temperature TConEnt "Condenser entering temperature";
  Modelica.SIunits.Temperature TConLvg "Condenser leaving temperature";
  Modelica.SIunits.Efficiency   COP "Coefficient of performance";
  Modelica.SIunits.HeatFlowRate QCon_flow "Condenser heat input";
  Modelica.SIunits.HeatFlowRate QEva_flow "Evaorator heat input";

//--------------------------------------------------------------------------

// data from the catalog and nominal perfromance parameters

  Modelica.SIunits.HeatFlowRate QCon_flow_ava(
    nominal=QCon_flow_nominal,
    start=QCon_flow_nominal)
    "Heating capacity available at Condenser";
  Modelica.SIunits.HeatFlowRate QCon_flow_set(nominal=QCon_flow_nominal,start=QCon_flow_nominal)
    "Heating capacity required to heat to set point temperature";
  Modelica.SIunits.SpecificEnthalpy hSet
    "Enthalpy setpoint for heating water";

//perfromance curve functions-variables defintion
  Real capFunT(min=0,nominal=1, unit="1")    "Heating capacity factor function of temperature curve";

  Modelica.SIunits.Efficiency EIRFunT(nominal=1)
    "Power input to heating capacity ratio function of temperature curve";

  Modelica.SIunits.Efficiency EIRFunPLR(nominal=1)
    "Power input to heating capacity ratio function of part load ratio";

 parameter Buildings.Fluid.HeatPumps.Data.WSHP.Generic per
    annotation (Placement(transformation(extent={{34,64},{66,96}})));

// Part load variables

protected
  Real PLR1(min=0, nominal=1, unit="1") "Part load ratio";
  Real PLR2(min=0, nominal=1, unit="1") "Part load ratio";
  Real CR(min=0, nominal=1, unit="1") "Cycling ratio";

 final parameter Modelica.SIunits.HeatFlowRate QCon_flow_nominal= per.QCon_flow_nominal "Reference capacity";
 final parameter Modelica.SIunits.Efficiency   COP_nominal = per.COP_nominal
    "Reference coefficient of performance";
 final parameter Real PLRMax =    per.PLRMax               "Maximum part load ratio";
 final parameter Real PLRMinUnl = per.PLRMinUnl           "Minimum part unload ratio";
 final parameter Real PLRMin =    per. PLRMin              "Minimum part load ratio";
 final parameter Real etaMotor(min=0, max=1)= per.etaMotor "Fraction of compressor motor heat entering refrigerant";

 final parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal= per.mCon_flow_nominal
    "Nominal mass flow at Condenser"
     annotation (Dialog(group="Nominal condition"));
 final parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal= per.mEva_flow_nominal
    "Nominal mass flow at Evaorator"
     annotation (Dialog(group="Nominal condition"));

 final parameter Modelica.SIunits.Temperature TConLvg_nominal= per.TConLvg_nominal
    "Nominal leaving Condenser temperature";

 final parameter Modelica.SIunits.Temperature TConEntMin = per.TConEntMin
    "Minimum value for entering Condenser temperature"
    annotation (Dialog(group="Performance curves"));

 final parameter Modelica.SIunits.Temperature TConEntMax = per.TConEntMax
    "Maximum value for entering Condenser temperature"
    annotation (Dialog(group="Performance curves"));
//  final parameter Modelica.SIunits.Temperature TEvaLvgMin = per.TEvaLvgMin
//     "Minimum value for leaving Evaorator temperature"
//     annotation (Dialog(group="Performance curves"));
//  final parameter  Modelica.SIunits.Temperature TEvaLvgMax= per.TEvaLvgMax
//     "Maximum value for leaving Evaorator temperature"
//     annotation (Dialog(group="Performance curves"));
 final parameter Modelica.SIunits.Temperature TConEnt_nominal=per.TConEnt_nominal
    "Temperature of fluid entering Condenser at nominal condition"
     annotation (Dialog(group="Nominal condition"));

 final parameter Modelica.SIunits.Conversions.NonSIunits.Temperature_degC
    TConLvg_nominal_degC=
  Modelica.SIunits.Conversions.to_degC(TConLvg_nominal)
    "Temperature of fluid leaving Condenser at nominal condition";

//    final parameter Modelica.SIunits.Conversions.NonSIunits.Temperature_degC
//     TEvaEnt_nominal_degC=
//     Modelica.SIunits.Conversions.to_degC(TEvaEnt_nominal)
//     "Temperature of fluid entering Evaorator at nominal condition";

parameter Modelica.SIunits.HeatFlowRate Q_flow_small = QCon_flow_nominal*1E-9
    "Small value for heat flow rate or power, used to avoid division by zero";

 //--------------------------------------------------------------------------

 // setpoint variables for Evaporator and Condenser

Modelica.SIunits.Conversions.NonSIunits.Temperature_degC TEvaLvg_degC=
    Modelica.SIunits.Conversions.to_degC(TEvaLvg);

Modelica.SIunits.Conversions.NonSIunits.Temperature_degC TConEnt_degC=
    Modelica.SIunits.Conversions.to_degC(TConEnt);

 //--------------------------------------------------------------------------

// number of coeffcients

//   constant Integer nCapFunT=6 "Number of coefficients for capFunT";
//   constant Integer nEIRFunT=6 "Number of coefficients for EIRFunT";
//   constant Integer nEIRFunPLR=6 "Number of coefficients for EIRFunPLR";

//--------------------------------------------------------------------------

initial equation
  assert(QCon_flow_nominal > 0, "Parameter QCon_flow_nominal must be greater than zero.");
  assert(Q_flow_small > 0, "Parameter Q_flow_small must be larger than zero.");
  assert(PLRMinUnl >= PLRMin, "Parameter PLRMinUnl must be bigger or equal to PLRMin");
  assert(PLRMax > PLRMinUnl, "Parameter PLRMax must be bigger than PLRMinUnl");

equation
  // Condenser temperatures at set point
  TConEnt = Medium1.temperature(Medium1.setState_phX(port_a1.p,
  inStream(port_a1.h_outflow),inStream(port_a1.Xi_outflow)));
  TConLvg =vol1.heatPort.T;

  // Evaorator temperatures at set point
  TEvaEnt = Medium2.temperature(Medium2.setState_phX(port_a2.p,
  inStream(port_a2.h_outflow),inStream(port_a2.Xi_outflow)));
  TEvaLvg = vol2.heatPort.T;

//  TEvaEnt_degC = Modelica.SIunits.Conversions.to_degC(TEvaEnt);
//  TConLvg_degC = Modelica.SIunits.Conversions.to_degC(TConLvg);

  // Enthalpy of temperature setpoint (Condenser)
  hSet = Medium1.specificEnthalpy_pTX(
           p=port_b1.p,
           T=TSet,
           X=cat(1, port_b1.Xi_outflow, {1-sum(port_b1.Xi_outflow)}));

      if on then

/* Compute the chiller capacity fraction, using a biquadratic curve.
   Since the regression for capacity can have negative values
    (for unreasonable temperatures),we constrain its return value to be non-negative. 
   This prevents the solver to pick the unrealistic solution.
  */
    capFunT = Buildings.Utilities.Math.Functions.smoothMax(
       x1 = 1E-6,
       x2 = Buildings.Utilities.Math.Functions.biquadratic(
         a=per.capFunT,
         x1=TConEnt_degC,
         x2=TEvaLvg_degC),
       deltaX = 1E-7);

/*    assert(capFunT < 0.1, "Error: Received capFunT = " + String(capFunT)  + ".\n"
           + "Coefficient for polynomial seem to be not valid for the encountered temperature range.\n"
           + "Temperatures are TConEnt_degC = " + String(TConEnt_degC) + " degC\n"
           + "                 TEvaLvg_degC = " + String(TEvaLvg_degC) + " degC");
*/

    // Heatpump energy input ratio biquadratic curve.
    EIRFunT = Buildings.Utilities.Math.Functions.biquadratic(
     a=per.EIRFunT,
     x1=TConEnt_degC,
     x2=TEvaLvg_degC);

    // HeatPump energy input ratio quadratic curve
    EIRFunPLR= per.EIRFunPLR[1]+per.EIRFunPLR[2]*PLR2+per.EIRFunPLR[3]*PLR2^2;
    // Available Heating capacity
    QCon_flow_ava = QCon_flow_nominal*capFunT;
    // Cooling capacity required to chill water to setpoint

    QCon_flow_set = Buildings.Utilities.Math.Functions.smoothMin(
      x1 = m1_flow*(hSet-inStream(port_a1.h_outflow)),
      x2= Q_flow_small,
      deltaX=-Q_flow_small/100);

    // Part load ratio
    PLR1 = Buildings.Utilities.Math.Functions.smoothMin(
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
    P = QCon_flow_ava/COP_nominal*EIRFunT*EIRFunPLR*CR;
    // Heat flow rates into Evaorator and condenser
    // Q_flow_small is a negative number.
    QCon_flow = Buildings.Utilities.Math.Functions.smoothMax(
      x1 = QCon_flow_set,
      x2 = QCon_flow_ava,
      deltaX= -Q_flow_small/10);

  //QCon_flow = max(QCon_flow_set, QCon_flow_ava);
    QCon_flow = QEva_flow + P*etaMotor;
    // Coefficient of performance
    COP = QCon_flow/(P-Q_flow_small);

  else
    capFunT = 0;
    EIRFunT = 0;
    EIRFunPLR= 0;
    QCon_flow_ava = 0;
    QCon_flow_set = 0;
    PLR1 = 0;
    PLR2 = 0;
    CR   = 0;
    P    = 0;
    QCon_flow = 0;
    QEva_flow = 0;
    COP  = 0;

   end if;

//--------------------------------------------------------------------------

  connect(QEva_flow_in.y, preHeaFloEva.Q_flow) annotation (Line(points={{-59,-40},{-37,-40}}, color={0,0,127}));
  connect(QCon_flow_in.y, preHeaFloCon.Q_flow) annotation (Line(points={{-57,34},
          {-48,34},{-48,34},{-41,34}}, color={0,0,127}));

  connect(preHeaFloCon.port,vol1.heatPort)
  annotation (Line(points={{-21,34},{-16,34},{-16,60},{-10,60}}, color={191,0,0}));

  connect(preHeaFloEva.port,vol2.heatPort)
  annotation (Line(points={{-17,-40},{-2,-40},{-2,-60},{12,-60}},
                                       color={191,0,0}));

annotation (  Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},
            {100,100}}),       graphics={
        Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Rectangle(
          extent={{-56,68},{58,50}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,-52},{58,-70}},
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
                                                 color={0,0,255}),
        Line(points={{0,-70},{0,-90},{100,-90}}, color={0,0,255}),
        Line(points={{62,0},{100,0}},                 color={0,0,255})}),
    defaultComponentName="heaPum",
    Documentation(info="<html>
<p>
Model for a water to water heat pump with a scroll compressor, as described
in Jin (2002). The thermodynamic heat pump cycle is represented below.
</p>
<p align=\"center\">
<img  alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/HeatPumps/WaterToWater_Cycle.png\" border=\"1\"/>
</p>
<p>
The rate of heat transferred to the evaporator is given by:
</p>
<p align=\"center\" style=\"font-style:italic;\">
Q&#775;<sub>Eva</sub> = m&#775;<sub>ref</sub> ( h<sub>Vap</sub>(T<sub>Eva</sub>) - h<sub>Liq</sub>(T<sub>Con</sub>) ).
</p>
<p>
The power consumed by the compressor is given by a linear efficiency relation:
</p>
<p align=\"center\" style=\"font-style:italic;\">
P = P<sub>Theoretical</sub> / &eta; + P<sub>Loss,constant</sub>.
</p>
<p>
Heat transfer in the evaporator and condenser is calculated using an
&epsilon;-NTU method, assuming constant refrigerant temperature and constant heat
transfer coefficient between fluid and refrigerant.
</p>
<p>
Variable speed is achieved by multiplying the full load suction volume flow rate
by the normalized compressor speed. The power and heat transfer rates are forced
to zero if the resulting heat pump state has higher evaporating pressure than
condensing pressure.
</p>
<p>
The model parameters are obtained by calibration of the heat pump model to
manufacturer performance data. Calibrated model parameters for various heat
pumps from different manufacturers are found in
<a href=\"modelica://Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater\">
Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater</a>. The calibrated model is
located in
<a href=\"modelica://Buildings.Fluid.HeatPumps.Calibration.ScrollWaterToWater\">
Buildings.Fluid.HeatPumps.Calibration.ScrollWaterToWater</a>.
</p>
<h4>Options</h4>
<p>
Parameters <code>TConMax</code> and <code>TEvaMin</code>
may be used to set an upper or lower bound for the
condenser and evaporator.
The compressor is disabled when these conditions
are not satisfied, or when the
evaporator temperature is larger
than the condenser temperature.
This mimics the temperature protection
of heat pumps and moreover it avoids
non-converging algebraic loops of equations,
or freezing of evaporator medium.
This option can be disabled by setting
<code>enable_temperature_protection = false</code>.
</p>
<h4>Assumptions and limitations</h4>
<p>
The compression process is assumed isentropic. The thermal energy
of superheating is ignored in the evaluation of the heat transferred to the refrigerant
in the evaporator. There is no supercooling.
</p>
<h4>References</h4>
<p>
H. Jin.
<i>
Parameter estimation based models of water source heat pumps.
</i>
PhD Thesis. Oklahoma State University. Stillwater, Oklahoma, USA. 2012.
</p>
</html>", revisions="<html>
<ul>
<li>
May 30, 2017, by Filip Jorissen:<br/>
Revised documentation for temperature protection.
See <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/769\">#769</a>.
</li>
<li>
November 11, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end WaterSourceHeatPump2;
