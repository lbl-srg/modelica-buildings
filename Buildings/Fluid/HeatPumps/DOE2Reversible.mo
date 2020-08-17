within Buildings.Fluid.HeatPumps;
model DOE2Reversible
  "Model for a reversible heat pump based on the DOE2 method"
  extends Buildings.Fluid.Interfaces.FourPortHeatMassExchanger(
    final dp1_nominal=per.dp1_nominal,
    final dp2_nominal=per.dp2_nominal,
    final m1_flow_nominal = per.m1_flow_nominal*scaling_factor,
    final m2_flow_nominal = per.m2_flow_nominal*scaling_factor,
    final massDynamics=energyDynamics,
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolume vol1(
      final V=per.m1_flow_nominal*scaling_factor*tau1/rho1_nominal,
      final nPorts=2,
      final prescribedHeatFlowRate=true),
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolume vol2(
      final V=per.m2_flow_nominal*scaling_factor*tau2/rho2_nominal,
      final nPorts=2,
      final prescribedHeatFlowRate=true));

  parameter Buildings.Fluid.HeatPumps.Data.DOE2Reversible.Generic per
   "Performance data"
    annotation (choicesAllMatching=true, Placement(transformation(extent={{46,66},
            {66,86}})));

  parameter Real scaling_factor = 1
   "Scaling factor for heat pump capacity";

  output Real PLR(
    min=0,
    nominal=1,
    unit="1") = thePer.PLR1 "Part load ratio";

  constant Modelica.SIunits.SpecificEnergy h1_default=
     Medium1.specificEnthalpy_pTX(
       Medium1.p_default,
       Medium1.T_default,
       Medium1.X_default)
  "Default enthalpy for Medium 1";
  Modelica.SIunits.SpecificEnthalpy hEvaSet=
    if uMod == 0 then h1_default
    elseif uMod == -1 then
      Medium1.specificEnthalpy_pTX(
        p=port_b1.p,
        T=TSetEva.y,
        X=cat(1, port_b1.Xi_outflow, {1 - sum(port_b1.Xi_outflow)}))
    else
      Medium2.specificEnthalpy_pTX(
      p=port_b2.p,
      T=TSetEva.y,
      X=cat(1, port_b2.Xi_outflow, {1 - sum(port_b2.Xi_outflow)}))
    "Enthalpy corresponding to set point for evaporator leaving temperature";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSet(
    final unit="K",
    displayUnit="degC")
    "Set point for leaving fluid temperature at port b1"
     annotation (Placement(transformation(extent={{-120,140},{-100,160}}),
          iconTransformation(extent={{-120,80},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSouMinLvg(
    final unit="K",
    displayUnit="degC")
    "Minimum leaving water temperature at the source side"
     annotation (Placement(transformation(extent={{-120,-30},{-100,-10}}),
        iconTransformation(extent={{-120,-40},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSouMaxLvg(
    final unit="K",
    displayUnit="degC") "Maximum source leaving water temperature"
    annotation (Placement(
        transformation(extent={{-120,-10},{-100,10}}),iconTransformation(extent={{-120,
            -10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uMod
   "Control input signal, cooling mode=-1, off=0, heating mode=+1"
     annotation (Placement(transformation(extent={{-120,120},{-100,140}}),
          iconTransformation(extent={{-120,20},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QLoa_flow(final unit="W")
   "Heat flow rate at the load heat exchanger"
     annotation (Placement(transformation(extent={{100,78},{120,98}}),
        iconTransformation(extent={{100,80},{120,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QSou_flow(final unit="W")
   "Heat flow rate at the source heat exchanger"
     annotation (Placement(transformation(extent={{100,-98},{120,-78}}),
        iconTransformation(extent={{100,-100},{120,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput P(final unit="W")
   "Compressor power "
     annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-12},{120,8}})));
  Modelica.SIunits.Efficiency COPCoo(final min=0) = thePer.COPCoo
    "Coefficient of performance for cooling. If cooling mode, useful heat is at medium 1, else at medium 2";
  Modelica.SIunits.Efficiency COPHea(final min=0) = thePer.COPHea
    "Coefficient of performance for heating. If heating mode, useful heat is at medium 2, else at medium 1";

  BaseClasses.EvaporatorSetpoint conHeaMod
    "Built-in controller to reset the cooling set point temperature in heating mode"
    annotation (Placement(transformation(extent={{-20,118},{0,138}})));

   BaseClasses.DOE2Reversible thePer(
     final per=per,
     final scaling_factor=scaling_factor) "Thermal performance"
    annotation (Placement(transformation(extent={{40,-14},{60,6}})));

protected
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TLoaLvg
    "Leaving water temperature form load heat exchanger"
    annotation (Placement(transformation(extent={{-20,20},{-40,40}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TSouLvg
    "Leaving water temperature form source heat exchanger"
    annotation (Placement(transformation(extent={{10,-42},{-10,-22}})));


  Controls.OBC.CDL.Integers.GreaterThreshold isHea(final threshold=0)
    "Output true if in heating mode"
    annotation (Placement(transformation(extent={{-80,120},{-60,140}})));
  Controls.OBC.CDL.Logical.Switch TConEnt(
    y(final unit = "K",
      displayUnit = "degC")) "Condenser entering temperature"
    annotation (Placement(transformation(extent={{40,180},{60,200}})));
  Controls.OBC.CDL.Logical.Switch TEvaLvg(
    y(final unit = "K",
      displayUnit = "degC")) "Evaporator leaving temperature"
    annotation (Placement(transformation(extent={{40,150},{60,170}})));
  Modelica.Blocks.Sources.RealExpression QEvaSet_flow(final y=if (uMod == 1)
         then min(0, m2_flow*(hEvaSet - inStream(port_a2.h_outflow))) elseif (
        uMod == -1) then min(0, m1_flow*(hEvaSet - inStream(port_a1.h_outflow)))
         else 0) "Required heat flow rate to meet set point"
    annotation (Placement(transformation(extent={{-8,4},{12,24}})));
  Modelica.Blocks.Sources.RealExpression T_a2(final y=Medium2.temperature(
        Medium2.setState_phX(
        port_a2.p,
        inStream(port_a2.h_outflow),
        inStream(port_a2.Xi_outflow)))) "Source side leaving fluid temperature"
    annotation (Placement(transformation(extent={{0,172},{20,192}})));
  Modelica.Blocks.Sources.RealExpression T_a1(final y=Medium1.temperature(
        Medium1.setState_phX(
        port_a1.p,
        inStream(port_a1.h_outflow),
        inStream(port_a1.Xi_outflow)))) "Load side entering fluid temperature"
    annotation (Placement(transformation(extent={{0,188},{20,208}})));
  HeatTransfer.Sources.PrescribedHeatFlow preHeaFloLoa
   "Prescribed load side heat flow rate"
    annotation (Placement(transformation(extent={{61,20},{41,40}})));
  HeatTransfer.Sources.PrescribedHeatFlow preHeaFloSou
   "Prescribed source side heat flow rate"
    annotation (Placement(transformation(extent={{61,-42},{41,-22}})));

  Controls.OBC.CDL.Logical.Switch TSetEva(y(final unit="K", displayUnit="degC"))
    "Set point for evaporator leaving temperature"
    annotation (Placement(transformation(extent={{20,100},{40,120}})));
equation
  connect(uMod, thePer.uMod) annotation (Line(points={{-110,130},{-88,130},{-88,
          10},{-20,10},{-20,0},{39,0}}, color={255,127,0}));
  connect(thePer.Q1_flow, QLoa_flow) annotation (Line(
      points={{61,4},{84,4},{84,88},{110,88}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(thePer.P, P) annotation (Line(
      points={{61,0},{86,0},{86,0},{110,0}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(thePer.Q2_flow, QSou_flow) annotation (Line(
      points={{61,-4},{82,-4},{82,-88},{110,-88}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(thePer.Q1_flow, preHeaFloLoa.Q_flow)
    annotation (Line(points={{61,4},{68,4},{68,30},{61,30}}, color={0,0,127}));
  connect(thePer.Q2_flow, preHeaFloSou.Q_flow) annotation (Line(points={{61,-4},
          {68,-4},{68,-32},{61,-32}}, color={0,0,127}));
  connect(TSet, conHeaMod.TSet) annotation (Line(points={{-110,150},{-48,150},{-48,
          130.8},{-21,130.8}}, color={0,0,127}));
  connect(preHeaFloSou.port, vol2.heatPort)
  annotation (Line(points={{41,-32},{26,-32},{26,-60},{12,-60}},
                                               color={191,0,0}));
  connect(TSouMinLvg, conHeaMod.TSouLvgMin) annotation (Line(points={{-110,-20},
          {-52,-20},{-52,137},{-21,137}}, color={0,0,127}));
  connect(TSouMaxLvg, conHeaMod.TSouLvgMax) annotation (Line(points={{-110,0},{-56,
          0},{-56,134},{-21,134}}, color={0,0,127}));
  connect(vol2.heatPort, TSouLvg.port)
  annotation (Line(points={{12,-60},{26,-60},{26,-32},{10,-32}},
                             color={191,0,0}));
  connect(vol1.heatPort, TLoaLvg.port)
  annotation (Line(points={{-10,60},{-20,60},{-20,30}},
                              color={191,0,0}));
  connect(TLoaLvg.T, conHeaMod.TLoaLvg) annotation (Line(points={{-40,30},{-46,30},
          {-46,128},{-21,128}}, color={0,0,127}));
  connect(uMod, isHea.u) annotation (Line(points={{-110,130},{-82,130}},
                     color={255,127,0}));
  connect(TConEnt.u2, isHea.y)
    annotation (Line(points={{38,190},{-54,190},{-54,130},{-58,130}},
                                                color={255,0,255}));
  connect(thePer.TConEnt, TConEnt.y) annotation (Line(points={{39,-8},{28,-8},{28,
          18},{82,18},{82,190},{62,190}}, color={0,0,127}));
  connect(thePer.TEvaLvg, TEvaLvg.y) annotation (Line(points={{39,-12},{26,-12},
          {26,20},{80,20},{80,160},{62,160}}, color={0,0,127}));
  connect(TEvaLvg.u1, TSouLvg.T) annotation (Line(points={{38,168},{4,168},{4,96},
          {-42,96},{-42,-32},{-10,-32}},
                           color={0,0,127}));
  connect(TEvaLvg.u3, TLoaLvg.T) annotation (Line(points={{38,152},{8,152},{8,88},
          {-46,88},{-46,30},{-40,30}},
                         color={0,0,127}));
  connect(TEvaLvg.u2, isHea.y) annotation (Line(points={{38,160},{-54,160},{-54,
          130},{-58,130}},
                     color={255,0,255}));
  connect(TConEnt.u3, T_a2.y) annotation (Line(points={{38,182},{21,182}},
                      color={0,0,127}));
  connect(TConEnt.u1, T_a1.y) annotation (Line(points={{38,198},{21,198}},
                      color={0,0,127}));
  connect(isHea.y, conHeaMod.isHea) annotation (Line(points={{-58,130},{-54,130},
          {-54,124},{-22,124}}, color={255,0,255}));
  connect(TSetEva.u2, isHea.y) annotation (Line(points={{18,110},{-54,110},{-54,
          130},{-58,130}}, color={255,0,255}));
  connect(TSetEva.u1, conHeaMod.TSetEvaLvg) annotation (Line(points={{18,118},{10,
          118},{10,128},{1,128}}, color={0,0,127}));
  connect(TSet, TSetEva.u3) annotation (Line(points={{-110,150},{-48,150},{-48,102},
          {18,102}}, color={0,0,127}));
  connect(preHeaFloLoa.port, TLoaLvg.port)
    annotation (Line(points={{41,30},{-20,30}}, color={191,0,0}));
  connect(QEvaSet_flow.y, thePer.QSet_flow)
    annotation (Line(points={{13,14},{20,14},{20,4},{39,4}}, color={0,0,127}));
annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),
     graphics={
        Ellipse(
          extent={{32,12},{68,-22}},
          lineColor={0,0,0},
          fillColor={135,135,135},
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
          lineColor={ERROR,
                          0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,-12},{-40,-52}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Line(points={{0,68},{0,90},{-100,90}},   color={0,0,255}),
        Line(points={{112,-6}}, color={28,108,200}),
        Line(points={{2,68},{2,90},{100,90},{102,86}}, color={28,108,200}),
        Line(points={{70,0},{108,0}}, color={28,108,200}),
        Line(points={{2,-90}}, color={28,108,200}),
        Line(points={{2,-70},{2,-90},{106,-90}}, color={28,108,200}),
        Line(points={{24,-18},{6,-18},{6,-52}}, color={238,46,47}),
        Line(points={{24,6},{6,6},{6,50}}, color={238,46,47}),
        Rectangle(
          extent={{24,18},{26,-24}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-1,12},{-17,-14},{13,-14},{-1,12}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={44,-3},
          rotation=90),
        Ellipse(extent={{22,2},{28,10}}, lineColor={255,0,0}),
        Ellipse(extent={{22,-22},{28,-14}}, lineColor={255,0,0}),
        Line(points={{32,-4},{26,-4},{26,-4}}, color={255,0,0}),
        Line(points={{70,-30},{108,-30}},color={28,108,200})}),
        Diagram(coordinateSystem(extent={{-100,-100},{100,220}},
                 preserveAspectRatio=false)),
        defaultComponentName="heaPum",
Documentation(info="<html>
<p>
Model for a reversible heat pump using the DOE2 method and that takes as an
input the set point for the leaving fluid temperature.
</p>
<p>
This reversible heat pump can be operated either in heating mode or in cooling mode.
It typically is used for a water to water heat pump, but if the performance data
<code>per</code> are set up for other media, such as glycol, it can also be used for
such applications.
The heat exchanger at medium 1 is to be connected to the building load,
and the other heat exchanger to the heat source or sink, such as
a geothermal loop.
If in heating mode, the heat exchanger at medium 1 operates as a condenser,
and in cooling mode it operates as an evaporator.
</p>
<p>
The model takes the following control signals:
</p>
<ul>
<li>
The integer input <code>uMod</code> which controls the heat pump operational mode.
The input is
<i>-1</i> for cooling mode,
<i>0</i> for off and
<i>+1</i> for heating mode.<br/>
If the performance record does not contain data for the mode selected by <code>uMod</code>,
the model stops with an error.
</li>
<li>
The input <code>TSet</code> is the set point for the leaving fluid temperature at port <code>port_b1</code>.
In cooling mode, this set point is directly used to control the heat pump because in this mode,
the fluid 1 transfers heat with the evaporator.
In heating mode, the fluid 1 transfers heat with the condenser, and hence
this set point is converted internally to a set point that will be used to control the
evaporator leaving water temperature, which is equal to the temperature of <code>port_b2</code>.
This set point conversion is done using
<a href=\"Buildings.Fluid.HeatPumps.BaseClasses.EvaporatorSetpoint\">
Buildings.Fluid.HeatPumps.BaseClasses.EvaporatorSetpoint</a>.
</li>
</ul>
<p>
The electric power only includes the power for the compressor, but not any power for pumps, as the pumps must be modeled outside
of this component.
</p>
<h4>Main equations</h4>
<p>
The model uses three performance curves to determine the heat pump capacity and efficiency as follows
</p>
<p>
Let <i>&alpha;</i> be the coefficients for the evaporator capacity function,
<i>&beta;</i> be the coefficients for the electrical input function for the temperature correction,
and <i>&gamma;</i> be the coefficients of the electrical input to thermal capacity function for the part load ratio correction.
</p>
<ul>
<li>
The thermal load function of temperature curve <code>capFun<sub>eva</sub></code> represents the fraction of
the evaporator thermal load as it varies by temperature, computed as
<p align=\"center\" style=\"font-style:italic;\">
capFun<sub>eva</sub> = &alpha;<sub>1</sub>
+&alpha;<sub>2</sub>T<sub>con,ent</sub>
+&alpha;<sub>3</sub>T<sup>2</sup><sub>con,ent</sub>
+&alpha;<sub>4</sub>T<sub>eva,lvg</sub>
+&alpha;<sub>5</sub>T<sup>2</sup><sub>eva,lvg</sub>
+&alpha;<sub>6</sub>T<sub>con,ent</sub>T<sub>eva,lvg</sub>
</p>
<p>
where <i>T<sub>con,ent</sub></i> is the condenser entering water temperature and
<i>T<sub>eva,lvg</sub></i> is the evaporator leaving water temperature.
</p>
</li>
<li>
The electric input to thermal load output ratio function of temperature <code>EIRFT</code>
curve represents the fraction of electricity to the heat pump capacity at full load as it varies
by temperature. It is computed as
<p align=\"center\" style=\"font-style:italic;\">
EIRFT = &beta;<sub>1</sub>
+&beta;<sub>2</sub>T<sub>con,ent</sub>
+&beta;<sub>3</sub>T<sup>2</sup><sub>con,ent</sub>
+&beta;<sub>4</sub>T<sub>eva,lvg</sub>
+&beta;<sub>5</sub>T<sup>2</sup><sub>eva,lvg</sub>
+&beta;<sub>6</sub>T<sub>con,ent</sub>T<sub>eva,lvg</sub>
</p>
</li>
<li>
The electric input to thermal load output ratio function of part load ratio <code>EIRFRLR</code>
curve represents the fraction of electricity to the heat pump load as the load varies
at a given set of operating temperatures. The curve is normalized so that at
full load the value of the curve should be 1.0. It is computed as
<p align=\"center\" style=\"font-style:italic;\">
EIRFPLR = &gamma;<sub>1</sub>+ &gamma;<sub>2</sub>PLR+&gamma;<sub>3</sub>PLR<sup>2</sup>
</li>
</ul>
<p>
The perfromance coeffcients and nominal data record <code>per</code> is specified at
<a href=\"Buildings.Fluid.HeatPumps.Data.DOE2Reversible.Generic\">
Buildings.Fluid.HeatPumps.Data.DOE2Reversible.Generic</a>.
Additional performance curves can be developed using
two available techniques Hydeman and Gillespie, (2002). The first technique is called the
Least-squares Linear Regression method and is used when sufficient performance data exist
to employ standard least-square linear regression techniques. The second technique is called
Reference Curve Method and is used when insufficient performance data exist to apply linear
regression techniques.
</p>
<p>
The model has the following three tests on the part load ratio and the cycling ratio:
</p>
<ol>
<li>
The test<pre>
  PLR1 =min(QEva_flow_set/QEva_flow_ava, PLRMax);
</pre>
ensures that the heatpump capacity does not exceed the heatpump capacity specified
by the parameter <code>PLRMax</code>.
</li>
<li>
The test <pre>
  CR = min(PLR1/per.PRLMin, 1.0);
</pre>
computes a cycling ratio. This ratio expresses the fraction of time
that a heatpump would run if it were to cycle because its load is smaller than the
minimal load at which it can operate.
Note that this model continuously operates even if the part load ratio is below the
minimum part load ratio.
Its leaving source and load temperature can therefore be considered as an
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
The performance of the heat pump is computed as follows:
<ul>
<li>
First, note that the DOE2 equations express the evaporator performance, and depending on the
mode of operation, the evaporator is at medium 1 (cooling mode) or medium 2 (heating mode).
</li>
<li>
<p>
If <code>uMod = -1</code>, the heat pump is in cooling mode and the evaporator is connected to medium 1.
Its available capacity is
</p>
<p align=\"center\" style=\"font-style:italic;\">
Q&#775;<sub>ava</sub> = capFun<sub>eva</sub> &nbsp; Q&#775;<sub>0</sub> &nbsp; s,
</p>
<p>
where <i>Q&#775;<sub>0</sub></i> is the design capacity as specified by the parameter
<code>per.coo.QEva_flow</code> and <i>s</i> is the scaling factor specified by the parameter <code>scaling_factor</code>.
</p>
<p>
If <code>uMod = +1</code>, the heat pump is in heating mode and the evaporator transfers heat with medium 2.
Its available capacity is as above
but with
<i>Q&#775;<sub>0</sub></i> being the design capacity as specified by the parameter
<code>per.hea.QEva_flow</code>.
</p>
<p>
The actual thermal capacity provided at the evaporator side is
<p align=\"center\" style=\"font-style:italic;\">
Q&#775; = min(Q&#775;<sub>ava</sub> , Q&#775;<sub>set</sub>),
</p>
<p>
where <i>Q&#775;<sub>set</sub></i> is the heat required to meet the set point for the leaving
water temperature at the evaporator.
For cooling mode (<code>uMod = -1</code>), this set point is equal to the input <code>TSet</code>.
For heating mode (<code>uMod = +1</code>), the input signal <code>TSet</code> is the set point for the condenser leaving
temperature. Hence, the model internally converts <code>TSet</code> to an auxiliary set point
for the evaporator leaving water temperature. This conversion is done using the model
<a href=\"Buildings.Fluid.HeatPumps.BaseClasses.EvaporatorSetpoint\">
Buildings.Fluid.HeatPumps.BaseClasses.EvaporatorSetpoint</a>.
</p>
<p>
The corresponding power consumption is
<p align=\"center\" style=\"font-style:italic;\">
P = Q&#775;<sub>ava</sub> &nbsp; &nbsp; EIRFT &nbsp; EIRFPLR &nbsp; CR &nbsp; P<sub>0</sub> &nbsp; s,
</p>
</li>
<li>
If <code>uMod = 0</code>, the model sets <i>Q&#775; = 0</i> and <i>P = 0</i>.
</li>
</ul>
<p>
The coefficient of performance COP is computed as
<p align=\"center\" style=\"font-style:italic;\">
COP = Q&#775; &frasl; P,
</p>
<p>
where <i>Q&#775;</i> is the heat exchanged with medium 1.
</p>
<h4>References</h4>
<p>
EnergyPlus-EngineeringReference-chapter16.6.3.
<i>
EIR Formulated Water To Water Heat Pump Model.
</i>
</p>
<p>
EnergyPlus-InputOutputReference-chapter1.22.26.
<i>
ChillerHeaterPerformance:Electric:EIR.
</i>
</p>
</html>", revisions="<html>
<ul>
<li>
November 27, 2019, by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end DOE2Reversible;
