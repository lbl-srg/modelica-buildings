within Buildings.Fluid.Chillers.BaseClasses;
partial model PartialElectricSteadyState
  "Partial model for electric chiller based on the model in DOE-2, CoolTools and EnergyPlus"
  extends Buildings.Fluid.Interfaces.PartialStaticFourPortHeatMassTransfer(
   m1_flow_nominal = mCon_flow_nominal,
   m2_flow_nominal = mEva_flow_nominal,
   final sensibleOnly1=true,
   final sensibleOnly2=true,
   show_T=true,
   h_outflow_b1_start=Medium1.specificEnthalpy_pTX(Medium1.p_default, 273.15+25, Medium1.X_default),
   h_outflow_b2_start=Medium2.specificEnthalpy_pTX(Medium2.p_default, 273.15+5, Medium2.X_default));

  Modelica.Blocks.Interfaces.RealInput TSet(unit="K", displayUnit="degC")
    "Set point for leaving chilled water temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Real COP(min=0) "Coefficient of performance";
  Modelica.SIunits.HeatFlowRate QCon_flow "Condenser heat input";
  Modelica.SIunits.HeatFlowRate QEva_flow "Evaporator heat input";
  Modelica.Blocks.Interfaces.RealOutput P(unit="W")
    "Electric power consumed by compressor"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Real capFunT(min=0, nominal=1, start=1)
    "Cooling capacity factor function of temperature curve";
  Real EIRFunT(min=0, nominal=1, start=1)
    "Power input to cooling capacity ratio function of temperature curve";
  Real EIRFunPLR(min=0, nominal=1, start=1)
    "Power input to cooling capacity ratio function of part load ratio";
  Real PLR1(min=0, nominal=1, start=1) "Part load ratio";
  Real PLR2(min=0, nominal=1, start=1) "Part load ratio";
  Real CR(min=0, nominal=1,  start=1) "Cycling ratio";

protected
  Modelica.SIunits.HeatFlowRate QEva_flow_ava(nominal=QEva_flow_nominal,start=QEva_flow_nominal)
    "Cooling capacity available at evaporator";
  Modelica.SIunits.HeatFlowRate QEva_flow_set(nominal=QEva_flow_nominal,start=QEva_flow_nominal)
    "Cooling capacity required to cool to set point temperature";
  Modelica.SIunits.SpecificEnthalpy hSet
    "enthalpy setpoint for leaving chilled water";
  // Performance data
  parameter Modelica.SIunits.HeatFlowRate QEva_flow_nominal(max=0)
    "Reference capacity (negative number)";
  parameter Real COP_nominal "Reference coefficient of performance";
  parameter Real PLRMax(min=0) "Maximum part load ratio";
  parameter Real PLRMinUnl(min=0) "Minimum part unload ratio";
  parameter Real PLRMin(min=0) "Minimum part load ratio";
  parameter Real etaMotor(min=0, max=1)
    "Fraction of compressor motor heat entering refrigerant";
  parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal
    "Nominal mass flow at evaporator";
  parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal
    "Nominal mass flow at condenser";
  parameter Modelica.SIunits.Temperature TEvaLvg_nominal
    "Temperature of fluid leaving evaporator at nominal condition";
//  parameter Buildings.Fluid.Chillers.Data.ElectricEIRCurves.Generic cur
//    "Performance data";

///////////////////////////
  final parameter Modelica.SIunits.Conversions.NonSIunits.Temperature_degC
    TEvaLvg_nominal_degC=
    Modelica.SIunits.Conversions.to_degC(TEvaLvg_nominal)
    "Temperature of fluid leaving evaporator at nominal condition";
  Modelica.SIunits.Conversions.NonSIunits.Temperature_degC TEvaLvg_degC
    "Temperature of fluid leaving evaporator";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_small = QEva_flow_nominal*1E-9
    "Small value for heat flow rate or power, used to avoid division by zero";
initial equation
  assert(QEva_flow_nominal < 0, "Parameter QEva_flow_nominal must be smaller than zero.");
  assert(PLRMinUnl >= PLRMin, "Parameter PLRMinUnl must be bigger or equal to PLRMin");
  assert(PLRMax > PLRMinUnl, "Parameter PLRMax must be bigger than PLRMinUnl");
equation
  TEvaLvg_degC=Modelica.SIunits.Conversions.to_degC(Medium2.temperature(
               Medium2.setState_phX(port_b2.p, port_b2.h_outflow, port_b2.Xi_outflow)));

  // Available cooling capacity
  QEva_flow_ava = QEva_flow_nominal*capFunT;
  // Enthalpy of temperature setpoint
  hSet = Medium2.specificEnthalpy_pTX(port_b2.p, TSet, port_b2.Xi_outflow);
  // Cooling capacity required to chill water to setpoint
  QEva_flow_set = min(m2_flow*(hSet-inStream(port_a2.h_outflow)),0);

  // Part load ratio
  PLR1 = min(QEva_flow_set/(QEva_flow_ava+Q_flow_small), PLRMax);
  // PLR2 is the compressor part load ratio. The lower bound PLRMinUnl is
  // since for PLR1<PLRMinUnl, the chiller uses hot gas bypass, under which
  // condition the compressor power is assumed to be the same as if the chiller
  // were to operate at PLRMinUnl
  PLR2 = max(PLRMinUnl, PLR1);
  // Cycling ratio
  CR = min(PLR1/PLRMin,1.0);

  // Compressor power.
  P = -QEva_flow_ava/COP_nominal*EIRFunT*EIRFunPLR*CR;
  // Heat flow rates into evaporator and condenser
  QEva_flow = max(QEva_flow_set, QEva_flow_ava);
  QCon_flow = -Q2_flow + P*etaMotor;
  // Coefficient of performance
  COP = -QEva_flow/(P-Q_flow_small);

  // Interface with base class
  Q1_flow = QCon_flow;
  Q2_flow = QEva_flow;
  mXi1_flow = zeros(Medium1.nXi);
  mXi2_flow = zeros(Medium2.nXi);

  annotation (Icon(graphics={
        Text(extent={{64,4},{114,-10}},   textString="P",
          lineColor={0,0,127}),
        Text(extent={{-122,28},{-76,16}},   textString="T_CHWS",
          lineColor={0,0,127}),
        Rectangle(
          extent={{-99,-54},{102,-66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-66},{0,-54}},
          lineColor={0,0,127},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-104,66},{98,54}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,54},{98,66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,52},{-40,12}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,70},{58,52}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,2},{-52,12},{-32,12},{-42,2}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,2},{-52,-10},{-32,-10},{-42,2}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,-10},{-40,-50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{38,52},{42,-50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,-50},{58,-68}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{18,24},{62,-18}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,24},{22,-8},{58,-8},{40,24}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
Documentation(info="<html>
<p>
Base class for model of an electric chiller, based on the DOE-2.1 chiller model and the
CoolTools chiller model that are implemented in EnergyPlus as the models
<code>Chiller:Electric:EIR</code> and <code>Chiller:Electric:ReformulatedEIR</code>.
</p>
<p>Models that extend from this base class need to provide
three functions to predict capacity and power consumption:
<ul>
<li>
A function to predict cooling capacity. The function value needs
to be assigned to <code>capFunT</code>.
</li>
<li>
A functions to predict power input as a function of temperature.
The function value needs to be assigned to <code>EIRFunT</code>.
</li>
<li>
A functions to predict power input as a function of part load ratio.
The function value needs to be assigned to <code>EIRFunPLR</code>.
</li>
</ul>
</p>
<p>
The model takes as an input the set point for the leaving chilled water temperature, which is met if the chiller has sufficient capacity.
Thus, the model has a built-in, ideal temperature control.
The model has three tests on the part load ratio and the cycling ratio:
<ol>
<li>
The test<pre>
  PLR1 =min(QEva_flow_set/QEva_flow_ava, PLRMax);
</pre>
ensures that the chiller capacity does not exceed the chiller capacity specified
by the parameter <code>PLRMax</code>.
</li>
<li>
The test <pre>
  CR = min(PLR1/per.PRLMin, 1.0);
</pre>
computes a cycling ratio. This ratio expresses the fraction of time
that a chiller would run if it were to cycle because its load is smaller than the minimal load at which it can operature. Notice that this model does continuously operature even if the part load ratio is below the minimum part load ratio. Its leaving evaporator and condenser temperature can therefore be considered as an 
average temperature between the modes where the compressor is off and on.
</li>
<li>
The test <pre>
  PLR2 = max(PLRMinUnl, PLR1);
</pre>
computes the part load ratio of the compressor. 
The assumption is that for a part load ratio below <code>PLRMinUnl</code>,
the chiller uses hot gas bypass to reduce the capacity, while the compressor
power draw does not change. 
</li></ol>
</p>
<p>
The electric power only contains the power for the compressor, but not any power for pumps or fans.
</html>",
revisions="<html>
<ul>
<li>
Sep. 8, 2010, by Michael Wetter:<br>
Revised model and included it in the Buildings library.
</li>
<li>
October 13, 2008, by Brandon Hencey:<br>
First implementation.
</li>
</ul>
</html>"),
    Diagram(graphics));
end PartialElectricSteadyState;
