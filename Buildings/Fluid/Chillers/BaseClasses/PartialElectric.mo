within Buildings.Fluid.Chillers.BaseClasses;
partial model PartialElectric
  "Partial model for electric chiller based on the model in DOE-2, CoolTools and EnergyPlus"
  extends Buildings.Fluid.Interfaces.FourPortHeatMassExchanger(
   m1_flow_nominal = mCon_flow_nominal,
   m2_flow_nominal = mEva_flow_nominal,
   T1_start = 273.15+25,
   T2_start = 273.15+5,
   redeclare final Buildings.Fluid.MixingVolumes.MixingVolume vol2(
      V=m2_flow_nominal*tau2/rho2_nominal,
      nPorts=2,
      final prescribedHeatFlowRate=true),
    vol1(
      final prescribedHeatFlowRate=true));

  Modelica.Blocks.Interfaces.BooleanInput on
    "Set to true to enable compressor, or false to disable compressor"
    annotation (Placement(transformation(extent={{-140,10},{-100,50}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Modelica.Blocks.Interfaces.RealInput TSet(unit="K", displayUnit="degC")
    "Set point for leaving chilled water temperature"
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));

  Modelica.SIunits.Temperature TEvaEnt "Evaporator entering temperature";
  Modelica.SIunits.Temperature TEvaLvg "Evaporator leaving temperature";
  Modelica.SIunits.Temperature TConEnt "Condenser entering temperature";
  Modelica.SIunits.Temperature TConLvg "Condenser leaving temperature";

  Modelica.SIunits.Efficiency COP "Coefficient of performance";
  Modelica.SIunits.HeatFlowRate QCon_flow "Condenser heat input";
  Modelica.SIunits.HeatFlowRate QEva_flow "Evaporator heat input";
  Modelica.Blocks.Interfaces.RealOutput P(final quantity="Power", unit="W")
    "Electric power consumed by compressor"
    annotation (Placement(transformation(extent={{100,80},{120,100}}),
        iconTransformation(extent={{100,80},{120,100}})));

  Real capFunT(min=0, nominal=1, start=1, unit="1")
    "Cooling capacity factor function of temperature curve";
  Modelica.SIunits.Efficiency EIRFunT(nominal=1, start=1)
    "Power input to cooling capacity ratio function of temperature curve";
  Modelica.SIunits.Efficiency EIRFunPLR(nominal=1, start=1)
    "Power input to cooling capacity ratio function of part load ratio";
  Real PLR1(min=0, nominal=1, start=1, unit="1") "Part load ratio";
  Real PLR2(min=0, nominal=1, start=1, unit="1") "Part load ratio";
  Real CR(min=0, nominal=1,  start=1, unit="1") "Cycling ratio";

protected
  Modelica.SIunits.HeatFlowRate QEva_flow_ava(nominal=QEva_flow_nominal,start=QEva_flow_nominal)
    "Cooling capacity available at evaporator";
  Modelica.SIunits.HeatFlowRate QEva_flow_set(nominal=QEva_flow_nominal,start=QEva_flow_nominal)
    "Cooling capacity required to cool to set point temperature";
  Modelica.SIunits.SpecificEnthalpy hSet
    "Enthalpy setpoint for leaving chilled water";
  // Performance data
  parameter Modelica.SIunits.HeatFlowRate QEva_flow_nominal(max=0)
    "Reference capacity (negative number)";
  parameter Modelica.SIunits.Efficiency COP_nominal
    "Reference coefficient of performance";
  parameter Real PLRMax(min=0, unit="1") "Maximum part load ratio";
  parameter Real PLRMinUnl(min=0, unit="1") "Minimum part unload ratio";
  parameter Real PLRMin(min=0, unit="1") "Minimum part load ratio";
  parameter Modelica.SIunits.Efficiency etaMotor(max=1)
    "Fraction of compressor motor heat entering refrigerant";
  parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal
    "Nominal mass flow at evaporator";
  parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal
    "Nominal mass flow at condenser";
  parameter Modelica.SIunits.Temperature TEvaLvg_nominal
    "Temperature of fluid leaving evaporator at nominal condition";
  final parameter Modelica.SIunits.Conversions.NonSIunits.Temperature_degC
    TEvaLvg_nominal_degC=
    Modelica.SIunits.Conversions.to_degC(TEvaLvg_nominal)
    "Temperature of fluid leaving evaporator at nominal condition";
  Modelica.SIunits.Conversions.NonSIunits.Temperature_degC TEvaLvg_degC
    "Temperature of fluid leaving evaporator";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_small = QEva_flow_nominal*1E-9
    "Small value for heat flow rate or power, used to avoid division by zero";
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHeaFloEva
    "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{-39,-50},{-19,-30}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHeaFloCon
    "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{-39,30},{-19,50}})));
  Modelica.Blocks.Sources.RealExpression QEva_flow_in(y=QEva_flow)
    "Evaporator heat flow rate"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Modelica.Blocks.Sources.RealExpression QCon_flow_in(y=QCon_flow)
    "Condenser heat flow rate"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));

initial equation
  assert(QEva_flow_nominal < 0, "Parameter QEva_flow_nominal must be smaller than zero.");
  assert(Q_flow_small < 0, "Parameter Q_flow_small must be smaller than zero.");
  assert(PLRMinUnl >= PLRMin, "Parameter PLRMinUnl must be bigger or equal to PLRMin");
  assert(PLRMax > PLRMinUnl, "Parameter PLRMax must be bigger than PLRMinUnl");
equation
  // Condenser temperatures
  TConEnt = Medium1.temperature(Medium1.setState_phX(port_a1.p, inStream(port_a1.h_outflow)));
  TConLvg = vol1.heatPort.T;
  // Evaporator temperatures
  TEvaEnt = Medium2.temperature(Medium2.setState_phX(port_a2.p, inStream(port_a2.h_outflow)));
  TEvaLvg = vol2.heatPort.T;
  TEvaLvg_degC=Modelica.SIunits.Conversions.to_degC(TEvaLvg);

  // Enthalpy of temperature setpoint
  hSet = Medium2.specificEnthalpy_pTX(
           p=port_b2.p,
           T=TSet,
           X=cat(1, port_b2.Xi_outflow, {1-sum(port_b2.Xi_outflow)}));

  if on then
    // Available cooling capacity
    QEva_flow_ava = QEva_flow_nominal*capFunT;
    // Cooling capacity required to chill water to setpoint
    QEva_flow_set = Buildings.Utilities.Math.Functions.smoothMin(
      x1=  m2_flow*(hSet-inStream(port_a2.h_outflow)),
      x2= Q_flow_small,
      deltaX=-Q_flow_small/100);

    // Part load ratio
    PLR1 = Buildings.Utilities.Math.Functions.smoothMin(
      x1=  QEva_flow_set/(QEva_flow_ava+Q_flow_small),
      x2=  PLRMax,
      deltaX=PLRMax/100);
    // PLR2 is the compressor part load ratio. The lower bound PLRMinUnl is
    // since for PLR1<PLRMinUnl, the chiller uses hot gas bypass, under which
    // condition the compressor power is assumed to be the same as if the chiller
    // were to operate at PLRMinUnl
    PLR2 = Buildings.Utilities.Math.Functions.smoothMax(
      x1=  PLRMinUnl,
      x2=  PLR1,
      deltaX=  PLRMinUnl/100);

    // Cycling ratio.
    // Due to smoothing, this can be about deltaX/10 above 1.0
    CR = Buildings.Utilities.Math.Functions.smoothMin(
      x1=  PLR1/PLRMin,
      x2=  1,
      deltaX=0.001);

    // Compressor power.
    P = -QEva_flow_ava/COP_nominal*EIRFunT*EIRFunPLR*CR;
    // Heat flow rates into evaporator and condenser
    // Q_flow_small is a negative number.
    QEva_flow = Buildings.Utilities.Math.Functions.smoothMax(
      x1=  QEva_flow_set,
      x2=  QEva_flow_ava,
      deltaX= -Q_flow_small/10);

  //QEva_flow = max(QEva_flow_set, QEva_flow_ava);
    QCon_flow = -QEva_flow + P*etaMotor;
    // Coefficient of performance
    COP = -QEva_flow/(P-Q_flow_small);
  else
    QEva_flow_ava = 0;
    QEva_flow_set = 0;
    PLR1 = 0;
    PLR2 = 0;
    CR   = 0;
    P    = 0;
    QEva_flow = 0;
    QCon_flow = 0;
    COP  = 0;
  end if;

  connect(QCon_flow_in.y, preHeaFloCon.Q_flow) annotation (Line(
      points={{-59,40},{-39,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preHeaFloCon.port, vol1.heatPort) annotation (Line(
      points={{-19,40},{-10,40},{-10,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(QEva_flow_in.y, preHeaFloEva.Q_flow) annotation (Line(
      points={{-59,-40},{-39,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preHeaFloEva.port, vol2.heatPort) annotation (Line(
      points={{-19,-40},{12,-40},{12,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),
                   graphics={
        Text(extent={{62,96},{112,82}},   textString="P",
          lineColor={0,0,127}),
        Text(extent={{-94,-24},{-48,-36}},  textString="T_CHWS",
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
          fillPattern=FillPattern.Solid),
        Text(extent={{-108,36},{-62,24}},
          lineColor={0,0,127},
          textString="on")}),
Documentation(info="<html>
<p>
Base class for model of an electric chiller, based on the DOE-2.1 chiller model and the
CoolTools chiller model that are implemented in EnergyPlus as the models
<code>Chiller:Electric:EIR</code> and <code>Chiller:Electric:ReformulatedEIR</code>.
</p>
<p>
The model takes as an input the set point for the leaving chilled water temperature,
which is met if the chiller has sufficient capacity.
Thus, the model has a built-in, ideal temperature control.
The model has three tests on the part load ratio and the cycling ratio:
</p>
<ol>
<li>
The test
<pre>
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
that a chiller would run if it were to cycle because its load is smaller than
the minimal load at which it can operature. Notice that this model does continuously operature even if
the part load ratio is below the minimum part load ratio. Its leaving evaporator and condenser temperature
can therefore be considered as an
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
</li>
</ol>
<p>
The electric power only contains the power for the compressor, but not any power for pumps or fans.
</p>
<h4>Implementation</h4>
<p>
Models that extend from this base class need to provide
three functions to predict capacity and power consumption:
</p>
<ul>
<li>
A function to predict cooling capacity. The function value needs
to be assigned to <code>capFunT</code>.
</li>
<li>
A function to predict the power input as a function of temperature.
The function value needs to be assigned to <code>EIRFunT</code>.
</li>
<li>
A function to predict the power input as a function of the part load ratio.
The function value needs to be assigned to <code>EIRFunPLR</code>.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
March 12, 2015, by Michael Wetter:<br/>
Refactored model to make it once continuously differentiable.
This is for issue <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/373\">373</a>.
</li>
<li>
Jan. 10, 2011, by Michael Wetter:<br/>
Added input signal to switch chiller off, and changed base class to use a dynamic model.
The change of the base class was required to improve the robustness of the model when the control
is switched on again.
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
end PartialElectric;
