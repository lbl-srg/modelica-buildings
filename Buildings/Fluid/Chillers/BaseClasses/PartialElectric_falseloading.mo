within Buildings.Fluid.Chillers.BaseClasses;
partial model PartialElectric_falseloading
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

  parameter Boolean have_switchover=false
    "Set to true for heat recovery chiller with built-in switchover"
    annotation(Evaluate=true);

  Modelica.Blocks.Interfaces.BooleanInput on
    "Set to true to enable compressor, or false to disable compressor"
    annotation (Placement(transformation(extent={{-140,10},{-100,50}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Modelica.Blocks.Interfaces.RealInput TSet(unit="K", displayUnit="degC")
    "Set point for leaving chilled water temperature (condenser water if have_switchover=true and coo=false)"
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Modelica.Blocks.Interfaces.RealOutput P(final quantity="Power", unit="W")
    "Electric power consumed by compressor"
    annotation (Placement(transformation(extent={{100,80},{120,100}}),
        iconTransformation(extent={{100,80},{120,100}})));
  Modelica.Blocks.Interfaces.RealOutput COP_h(final unit="1") if have_switchover
    "Coefficient of performance of heating";

  Modelica.Units.SI.Temperature TEvaEnt "Evaporator entering temperature";
  Modelica.Units.SI.Temperature TEvaLvg "Evaporator leaving temperature";
  Modelica.Units.SI.Temperature TConEnt "Condenser entering temperature";
  Modelica.Units.SI.Temperature TConLvg "Condenser leaving temperature";

  Modelica.Units.SI.Efficiency COP "Coefficient of performance";
  Modelica.Units.SI.HeatFlowRate QCon_flow "Condenser heat input";
  Modelica.Units.SI.HeatFlowRate QEva_flow "Evaporator heat input";
  Modelica.Units.SI.HeatFlowRate Q_falseloading;

  Real capFunT(min=0, unit="1")
    "Cooling capacity factor function of temperature curve";
  Modelica.Units.SI.Efficiency EIRFunT
    "Power input to cooling capacity ratio function of temperature curve";
  Modelica.Units.SI.Efficiency EIRFunPLR
    "Power input to cooling capacity ratio function of part load ratio";
  Real PLR1(min=0, unit="1", start=0) "Part load ratio";
  Real PLR2(min=0, unit="1") "Part load ratio";
  Real CR(min=0, unit="1") "Cycling ratio";

  Controls.OBC.CDL.Interfaces.BooleanInput coo if have_switchover
    "Switchover signal: true for cooling, false for heating" annotation (
      Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(
        extent={{-40,-40},{40,40}},
        rotation=-90,
        origin={-80,140})));
  Controls.OBC.CDL.Logical.Sources.Constant tru(
    final k=true) if not have_switchover
    "Constant true signal"
    annotation (Placement(transformation(extent={{-20,-10},{-40,10}})));
protected
  Controls.OBC.CDL.Interfaces.BooleanInput coo_internal
    "Internal switchover signal: true for cooling, false for heating"
    annotation (Placement(transformation(extent={{-100,-20},{-60,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Modelica.Units.SI.HeatFlowRate QEva_flow_ava(nominal=QEva_flow_nominal, start
      =QEva_flow_nominal) "Cooling capacity available at evaporator";
  Modelica.Units.SI.HeatFlowRate QEva_flow_set(nominal=QEva_flow_nominal, start
      =QEva_flow_nominal)
    "Cooling capacity required to cool to set point temperature";
  Modelica.Units.SI.HeatFlowRate QCon_flow_set(
    nominal=-QEva_flow_nominal * (1 + 1 / COP_nominal * etaMotor),
    start=-QEva_flow_nominal * (1 + 1 / COP_nominal * etaMotor))
    "Heating capacity required to heat up condenser water to setpoint";
  Modelica.Units.SI.SpecificEnthalpy hSet
    "Enthalpy setpoint for leaving chilled water";
  // Performance data
  parameter Modelica.Units.SI.HeatFlowRate QEva_flow_nominal(max=0)
    "Reference capacity (negative number)";
  parameter Modelica.Units.SI.Efficiency COP_nominal
    "Reference coefficient of performance";
  parameter Real PLRMax(min=0, unit="1") "Maximum part load ratio";
  parameter Real PLRMinUnl(min=0, unit="1") "Minimum part unload ratio";
  parameter Real PLRMin(min=0, unit="1") "Minimum part load ratio";
  parameter Modelica.Units.SI.Efficiency etaMotor(max=1)
    "Fraction of compressor motor heat entering refrigerant";
  parameter Modelica.Units.SI.MassFlowRate mEva_flow_nominal
    "Nominal mass flow at evaporator";
  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal
    "Nominal mass flow at condenser";
  parameter Modelica.Units.SI.Temperature TEvaLvg_nominal
    "Temperature of fluid leaving evaporator at nominal condition";
  final parameter Modelica.Units.NonSI.Temperature_degC TEvaLvg_nominal_degC=
      Modelica.Units.Conversions.to_degC(TEvaLvg_nominal)
    "Temperature of fluid leaving evaporator at nominal condition";
  Modelica.Units.NonSI.Temperature_degC TEvaLvg_degC
    "Temperature of fluid leaving evaporator";
  parameter Modelica.Units.SI.HeatFlowRate Q_flow_small=QEva_flow_nominal*1E-9
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
  Modelica.Blocks.Sources.RealExpression calCOPHea(
    final y=QCon_flow/(P - Q_flow_small)) if have_switchover
    "Compute heating COP"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
initial equation
  assert(QEva_flow_nominal < 0, "Parameter QEva_flow_nominal must be smaller than zero.");
  assert(Q_flow_small < 0, "Parameter Q_flow_small must be smaller than zero.");
  assert(PLRMinUnl >= PLRMin, "Parameter PLRMinUnl must be bigger or equal to PLRMin");
  assert(PLRMax > PLRMinUnl, "Parameter PLRMax must be bigger than PLRMinUnl");
equation
  // Condenser temperatures
  TConEnt = Medium1.temperature(Medium1.setState_phX(port_a1.p,
                                                     inStream(port_a1.h_outflow),
                                                     inStream(port_a1.Xi_outflow)));
  TConLvg = vol1.heatPort.T;
  // Evaporator temperatures
  TEvaEnt = Medium2.temperature(Medium2.setState_phX(port_a2.p, inStream(port_a2.h_outflow)));
  TEvaLvg = vol2.heatPort.T;
  TEvaLvg_degC=Modelica.Units.Conversions.to_degC(TEvaLvg);

  // Enthalpy of temperature setpoint
  hSet =if coo_internal then Medium2.specificEnthalpy_pTX(
    p=port_b2.p,
    T=TSet,
    X=cat(
      1,
      port_b2.Xi_outflow,
      {1 - sum(port_b2.Xi_outflow)})) else Medium1.specificEnthalpy_pTX(
    p=port_b1.p,
    T=TSet,
    X=cat(
      1,
      port_b1.Xi_outflow,
      {1 - sum(port_b1.Xi_outflow)}));

  if on then
    // Available cooling capacity
    QEva_flow_ava = QEva_flow_nominal*capFunT;
    // Cooling capacity required to chill water to setpoint
    QEva_flow_set = Buildings.Utilities.Math.Functions.smoothMin(
      x1=if coo_internal then m2_flow * (hSet - inStream(port_a2.h_outflow))
         else P * etaMotor - QCon_flow_set,
      x2=Q_flow_small,
      deltaX=-Q_flow_small/100);
    // Heating capacity required to heat up condenser water to setpoint
    // (Q_flow_small is a negative number.)
    QCon_flow_set = Buildings.Utilities.Math.Functions.smoothMax(
      x1=if coo_internal then QCon_flow else m1_flow * (hSet - inStream(port_a1.h_outflow)),
      x2=-Q_flow_small,
      deltaX=-Q_flow_small/100);
    // Part load ratio
    PLR1 = Buildings.Utilities.Math.Functions.smoothMin(
      x1 = QEva_flow_set/(QEva_flow_ava+Q_flow_small),
      x2 = PLRMax,
      deltaX=PLRMax/100);
    // PLR2 is the compressor part load ratio. The lower bound PLRMinUnl is
    // since for PLR1<PLRMinUnl, the chiller uses hot gas bypass, under which
    // condition the compressor power is assumed to be the same as if the chiller
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
    P = -QEva_flow_ava/COP_nominal*EIRFunT*EIRFunPLR*CR;
    // Heat flow rates into evaporator and condenser
    // Q_flow_small is a negative number.
    QEva_flow = Buildings.Utilities.Math.Functions.smoothMax(
      x1 = QEva_flow_set,
      x2 = QEva_flow_ava,
      deltaX= -Q_flow_small/10);

  //QEva_flow = max(QEva_flow_set, QEva_flow_ava);
    QCon_flow = -QEva_flow + P*etaMotor + Q_falseloading;
    // Coefficient of performance
    COP = -QEva_flow/(P-Q_flow_small);

    Q_falseloading = -QEva_flow_ava * PLR2 * CR + QEva_flow;

  else
    QEva_flow_ava = 0;
    QEva_flow_set = 0;
    QCon_flow_set = 0;
    PLR1 = 0;
    PLR2 = 0;
    CR   = 0;
    P    = 0;
    QEva_flow = 0;
    QCon_flow = 0;
    COP  = 0;
    Q_falseloading = 0;
  end if;
  connect(calCOPHea.y, COP_h);
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
  connect(coo, coo_internal)
    annotation (Line(points={{-120,0},{-80,0}}, color={255,0,255}));
  connect(tru.y, coo_internal)
    annotation (Line(points={{-42,0},{-80,0}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),
                   graphics={
        Text(extent={{62,96},{112,82}},
          textString="P",
          textColor={0,0,127}),
        Text(extent={{-104,-16},{-58,-28}},
          textString="TSet",
          textColor={0,0,127}),
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
          textColor={0,0,127},
          textString="on"),
        Text(extent={{-102,96},{-56,84}},
          textColor={0,0,127},
          visible=have_switchover,
          textString="coo")}),
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
  PLR1 =min(QEva_flow_set/QEva_flow_ava, PLRMax)
</pre>
ensures that the chiller capacity does not exceed the chiller capacity specified
by the parameter <code>PLRMax</code>.
</li>
<li>
The test <pre>
  CR = min(PLR1/per.PRLMin, 1.0)
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
  PLR2 = max(PLRMinUnl, PLR1)
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
<p>
Optionally, the model can be configured to represent heat recovery chillers with
a switchover option by setting the parameter <code>have_switchover</code> to
<code>true</code>.
In that case an additional Boolean input connector <code>coo</code> is used.
The chiller is tracking a chilled water supply temperature setpoint at the
outlet of the evaporator barrel if <code>coo</code> is <code>true</code>.
Otherwise, if <code>coo</code> is <code>false</code>, the chiller is tracking
a hot water supply temperature setpoint at the outlet of the condenser barrel.
See
<a href=\"modelica://Buildings.Fluid.Chillers.Examples.ElectricEIR_HeatRecovery\">
Buildings.Fluid.Chillers.Examples.ElectricEIR_HeatRecovery</a>
for an example with a chiller operating in heating mode.
</p>
<h4>Implementation</h4>
<p>
This implementation computes the chiller capacity and power consumption
the same way as documented in
<a href=\"https://energyplus.net/assets/nrel_custom/pdfs/pdfs_v22.1.0/EngineeringReference.pdf\">
EnergyPlus v22.1.0 Engineering Reference</a> section 14.3.9.2.
Especially see equations 14.234 and 14.240 in the referenced document.
</p>
<p>
The available chiller capacity <code>QEva_flow_ava</code> is adjusted from
its nominal capacity <code>QEva_flow_nominal</code>
by factor <code>capFunT</code> as
</p>
<pre>  QEva_flow_ava = QEva_flow_nominal*capFunT</pre>
<p>
and the compressor power consumption is computed as
</p>
<pre>  P = -QEva_flow_ava*(1/COP_nominal)*EIRFunT*EIRFunPLR*CR.</pre>
<p>
The models that extend from this base class implement the functions used above
in ways that are shown in the table below.
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<thead>
  <tr>
    <th rowspan=\"2\">Function</th>
    <th rowspan=\"2\">Description</th>
    <th colspan=\"2\">Formulation</th>
  </tr>
  <tr>
    <th><code><a href=\"Modelica://Buildings.Fluid.Chillers.ElectricEIR\">ElectricEIR</a></code></th>
    <th><code><a href=\"Modelica://Buildings.Fluid.Chillers.ElectricReformulatedEIR\">ElectricReformulatedEIR</a></code></th>
  </tr>
</thead>
<tbody>
  <tr>
    <td><code>capFunT</code></td>
    <td>Adjusts cooling capacity for current fluid temperatures</td>
    <td>Biquadratic on <code>TConEnt</code> and <code>TEvaLvg</code></td>
    <td>Biquadratic on <code>TConLvg</code> and <code>TEvaLvg</code></td>
  </tr>
  <tr>
    <td><code>EIRFunPLR</code></td>
    <td>Adjusts EIR for the current PLR</td>
    <td>Quadratic on PLR</td>
    <td>Bicubic on <code>TConLvg</code> and PLR</td>
  </tr>
  <tr>
    <td><code>EIRFunT</code></td>
    <td>Adjusts EIR for current fluid temperatures</td>
    <td>Biquadratic on <code>TConEnt</code> and <code>TEvaLvg</code></td>
    <td>Biquadratic on <code>TConLvg</code> and <code>TEvaLvg</code></td>
  </tr>
</tbody>
</table>
<p>
where
<code>TConEnt</code> is the condenser entering temperature,
<code>TEvaLvg</code> is the evaporator leaving temperature,
<code>TConLvg</code> is the condenser leaving temperatore, and
PLR is the part load ratio.
</p>
<h4>References</h4>
<ul>
<li>
<a href=\"https://energyplus.net/assets/nrel_custom/pdfs/pdfs_v22.1.0/EngineeringReference.pdf\">
EnergyPlus v22.1.0 Engineering Reference</a>
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
June 4, 2024, by Antoine Gautier:<br/>
Added load limit in heating mode.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3815\">#3815</a>.
</li>
<li>
January 11, 2023, by Antoine Gautier:<br/>
Added optional switchover mode for heat recovery chillers.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3211\">#3211</a>.
</li>
<li>
November 19, 2021, by David Blum:<br/>
Add humidity to entering condenser state calculation.<br/>
This is for issue <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2770\">2770</a>.
</li>
<li>
June 28, 2019, by Michael Wetter:<br/>
Removed <code>start</code> values and removed
<code>nominal=1</code> for performance curves.<br/>
This is for issue <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1465\">1465</a>.
</li>
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
end PartialElectric_falseloading;
