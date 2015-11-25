within Buildings.Fluid.Chillers;
model Carnot_TEva
  "Chiller with prescribed evaporator leaving temperature and performance curve adjusted based on Carnot efficiency"
 extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
   m1_flow_nominal = QCon_flow_nominal/cp1_default/dTCon_nominal,
   m2_flow_nominal = QEva_flow_nominal/cp2_default/dTEva_nominal);

  parameter Buildings.Fluid.Types.EfficiencyInput effInpEva=
    Buildings.Fluid.Types.EfficiencyInput.volume
    "Temperatures of evaporator fluid used to compute Carnot efficiency"
    annotation (Dialog(tab="Advanced", group="Temperature dependence"));
  parameter Buildings.Fluid.Types.EfficiencyInput effInpCon=
    Buildings.Fluid.Types.EfficiencyInput.port_a
    "Temperatures of condenser fluid used to compute Carnot efficiency"
    annotation (Dialog(tab="Advanced", group="Temperature dependence"));
  parameter Modelica.SIunits.HeatFlowRate QEva_flow_nominal(max=0)
    "Nominal cooling heat flow rate (QEva_flow_nominal < 0)"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.SIunits.HeatFlowRate QCon_flow_nominal(min=0)=
    -QEva_flow_nominal*(1 + COP_nominal)/COP_nominal
    "Nominal heating flow rate";
  parameter Modelica.SIunits.TemperatureDifference dTEva_nominal = 10
    "Temperature difference evaporator inlet-outlet"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.TemperatureDifference dTCon_nominal = 10
    "Temperature difference condenser outlet-inlet"
    annotation (Dialog(group="Nominal condition"));

  // Efficiency
  parameter Boolean use_eta_Carnot = true
    "Set to true to use Carnot efficiency"
    annotation(Dialog(group="Efficiency"));
  parameter Real etaCar(fixed=use_eta_Carnot)
    "Carnot effectiveness (=COP/COP_Carnot)"
    annotation (Dialog(group="Efficiency", enable=use_eta_Carnot));
  parameter Real COP_nominal(fixed=not use_eta_Carnot)
    "Coefficient of performance"
    annotation (Dialog(group="Efficiency", enable=not use_eta_Carnot));
  parameter Modelica.SIunits.Temperature TCon_nominal = 303.15
    "Condenser temperature"
    annotation (Dialog(group="Efficiency", enable=not use_eta_Carnot));
  parameter Modelica.SIunits.Temperature TEva_nominal = 278.15
    "Evaporator temperature"
    annotation (Dialog(group="Efficiency", enable=not use_eta_Carnot));

  parameter Real a[:] = {1}
    "Coefficients for efficiency curve (need p(a=a, y=1)=1)"
    annotation (Dialog(group="Efficiency"));

  parameter Modelica.SIunits.HeatFlowRate QEva_flow_min(max=0)=-Modelica.Constants.inf
    "Maximum heat flow rate for cooling (negative)";

  parameter Modelica.SIunits.Pressure dp1_nominal
    "Pressure difference over condenser"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Pressure dp2_nominal
    "Pressure difference over evaporator"
    annotation (Dialog(group="Nominal condition"));

  parameter Boolean homotopyInitialization=true "= true, use homotopy method"
    annotation (Dialog(tab="Advanced"));

  parameter Boolean from_dp1=false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Dialog(tab="Flow resistance", group="Condenser"));
  parameter Boolean from_dp2=false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Dialog(tab="Flow resistance", group="Evaporator"));

  parameter Boolean linearizeFlowResistance1=false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation (Dialog(tab="Flow resistance", group="Condenser"));
  parameter Boolean linearizeFlowResistance2=false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation (Dialog(tab="Flow resistance", group="Evaporator"));

  parameter Real deltaM1=0.1
    "Fraction of nominal flow rate where flow transitions to laminar"
    annotation (Dialog(tab="Flow resistance", group="Condenser"));
  parameter Real deltaM2=0.1
    "Fraction of nominal flow rate where flow transitions to laminar"
    annotation (Dialog(tab="Flow resistance", group="Evaporator"));

  parameter Modelica.SIunits.Time tau1=10
    "Time constant at nominal flow rate (used if energyDynamics1 <> Modelica.Fluid.Types.Dynamics.SteadyState)"
    annotation (Dialog(tab="Dynamics", group="Condenser"));
  parameter Modelica.SIunits.Time tau2=10
    "Time constant at nominal flow rate (used if energyDynamics2 <> Modelica.Fluid.Types.Dynamics.SteadyState)"
    annotation (Dialog(tab="Dynamics", group="Evaporator"));

  parameter Modelica.SIunits.Temperature T1_start=Medium1.T_default
    "Initial or guess value of set point"
    annotation (Dialog(tab="Dynamics", group="Condenser"));
  parameter Modelica.SIunits.Temperature T2_start=Medium2.T_default
    "Initial or guess value of set point"
    annotation (Dialog(tab="Dynamics", group="Evaporator"));

  parameter Modelica.Fluid.Types.Dynamics energyDynamics1=Modelica.Fluid.Types.Dynamics.SteadyState
    "Formulation of energy balance"
    annotation (Dialog(tab="Dynamics", group="Condenser"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics2=Modelica.Fluid.Types.Dynamics.SteadyState
    "Formulation of energy balance"
    annotation (Dialog(tab="Dynamics", group="Evaporator"));

  Modelica.Blocks.Interfaces.RealInput TSet(unit="K")
    "Evaporator leaving water temperature"
    annotation (Placement(transformation(extent={{-140,70},{-100,110}})));

  Modelica.Blocks.Interfaces.RealOutput P(final quantity="Power", unit="W")
    "Electric power consumed by compressor"
    annotation (Placement(transformation(extent={{100,80},{120,100}}),
        iconTransformation(extent={{100,80},{120,100}})));

  Modelica.Blocks.Interfaces.RealOutput QEva_flow(final quantity="HeatFlowRate",
      unit="W") "Actual cooling heat flow rate removed from fluid 2"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}}),
        iconTransformation(extent={{100,-100},{120,-80}})));

  Real yPL = eva.Q_flow/QEva_flow_nominal "Part load ratio of evaporator";
  Real etaPL = Buildings.Utilities.Math.Functions.polynomial(a=a, x=yPL)
    "Efficiency due to part load of compressor (etaPL(y=1)=1";
  Real COP(min=0) = etaCar * COPCar * etaPL "Coefficient of performance";
  Real COPCar(min=0)=
    TEva / Buildings.Utilities.Math.Functions.smoothMax(x1=1, x2=TCon-TEva, deltaX=0.25)
    "Carnot efficiency";

  Modelica.SIunits.HeatFlowRate QCon_flow = P - QEva_flow
    "Condenser heat input";

protected
  final parameter Modelica.SIunits.SpecificHeatCapacity cp1_default=
    Medium1.specificHeatCapacityCp(Medium1.setState_pTX(
      Medium1.p_default,
      Medium1.T_default,
      Medium1.X_default))
    "Specific heat capacity of medium 1 at default medium state";
  final parameter Modelica.SIunits.SpecificHeatCapacity cp2_default=
    Medium2.specificHeatCapacityCp(Medium2.setState_pTX(
      Medium2.p_default,
      Medium2.T_default,
      Medium2.X_default))
    "Specific heat capacity of medium 2 at default medium state";

  Medium1.ThermodynamicState staA1 "Medium properties in port_a1";
  Medium1.ThermodynamicState staB1 "Medium properties in port_b1";
  Medium2.ThermodynamicState staA2 "Medium properties in port_a2";
  Medium2.ThermodynamicState staB2 "Medium properties in port_b2";

  Medium1.Temperature TCon "Condenser temperature used to compute efficiency";
  Medium2.Temperature TEva "Evaporator temperature used to compute efficiency";

  HeatExchangers.HeaterCooler_T eva(
    redeclare final package Medium = Medium2,
    final allowFlowReversal=allowFlowReversal2,
    final m_flow_nominal=m2_flow_nominal,
    final m_flow_small=m2_flow_small,
    final show_T=false,
    final from_dp=from_dp2,
    final dp_nominal=dp2_nominal,
    final linearizeFlowResistance=linearizeFlowResistance2,
    final deltaM=deltaM2,
    final Q_flow_maxHeat=0,
    final Q_flow_maxCool=QEva_flow_min,
    final tau=tau2,
    final T_start=T2_start,
    final energyDynamics=energyDynamics2,
    final homotopyInitialization=homotopyInitialization) "Evaporator"
    annotation (Placement(transformation(extent={{10,-70},{-10,-50}})));
  HeatExchangers.HeaterCooler_u con(
    redeclare final package Medium = Medium1,
    final allowFlowReversal=allowFlowReversal1,
    final m_flow_nominal=m1_flow_nominal,
    final m_flow_small=m1_flow_small,
    final show_T=false,
    final from_dp=from_dp1,
    final dp_nominal=dp1_nominal,
    final linearizeFlowResistance=linearizeFlowResistance1,
    final deltaM=deltaM1,
    final tau=tau1,
    final T_start=T1_start,
    final energyDynamics=energyDynamics1,
    final homotopyInitialization=homotopyInitialization,
    final Q_flow_nominal=QCon_flow_nominal) "Evaporator"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));

  Modelica.Blocks.Sources.RealExpression QCon_flow_in(y=QCon_flow/
        QCon_flow_nominal) "Condenser heat flow rate"
    annotation (Placement(transformation(extent={{-60,62},{-40,82}})));
  Modelica.Blocks.Sources.RealExpression PEle(y=-QEva_flow/COP)
    "Electrical power consumption"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
initial equation
  assert(dTEva_nominal>0, "Parameter dTEva_nominal must be positive.");
  assert(dTCon_nominal>0, "Parameter dTCon_nominal must be positive.");
  assert(QEva_flow_nominal < 0, "Parameter QEva_flow_nominal must be negative.");
  if use_eta_Carnot then
    COP_nominal = etaCar * TEva_nominal/(TCon_nominal-TEva_nominal);
  else
    etaCar = COP_nominal / (TEva_nominal/(TCon_nominal-TEva_nominal));
  end if;
  assert(abs(Buildings.Utilities.Math.Functions.polynomial(
         a=a, x=1)-1) < 0.01, "Efficiency curve is wrong. Need etaPL(y=1)=1.");
  assert(etaCar > 0.1, "Parameters lead to etaCar < 0.1. Check parameters.");
  assert(etaCar < 1,   "Parameters lead to etaCar > 1. Check parameters.");

equation
  if allowFlowReversal1 then
    if homotopyInitialization then
      staA1=Medium1.setState_phX(port_a1.p,
                          homotopy(actual=actualStream(port_a1.h_outflow),
                                   simplified=inStream(port_a1.h_outflow)),
                          homotopy(actual=actualStream(port_a1.Xi_outflow),
                                   simplified=inStream(port_a1.Xi_outflow)));
      staB1=Medium1.setState_phX(port_b1.p,
                          homotopy(actual=actualStream(port_b1.h_outflow),
                                   simplified=port_b1.h_outflow),
                          homotopy(actual=actualStream(port_b1.Xi_outflow),
                            simplified=port_b1.Xi_outflow));

    else
      staA1=Medium1.setState_phX(port_a1.p,
                          actualStream(port_a1.h_outflow),
                          actualStream(port_a1.Xi_outflow));
      staB1=Medium1.setState_phX(port_b1.p,
                          actualStream(port_b1.h_outflow),
                          actualStream(port_b1.Xi_outflow));
    end if; // homotopyInitialization
  else // reverse flow not allowed
    staA1=Medium1.setState_phX(port_a1.p,
                             inStream(port_a1.h_outflow),
                             inStream(port_a1.Xi_outflow));
    staB1=Medium1.setState_phX(port_b1.p,
                             inStream(port_b1.h_outflow),
                             inStream(port_b1.Xi_outflow));
  end if;
  if allowFlowReversal2 then
    if homotopyInitialization then
      staA2=Medium2.setState_phX(port_a2.p,
                          homotopy(actual=actualStream(port_a2.h_outflow),
                                   simplified=inStream(port_a2.h_outflow)),
                          homotopy(actual=actualStream(port_a2.Xi_outflow),
                                   simplified=inStream(port_a2.Xi_outflow)));
      staB2=Medium2.setState_phX(port_b2.p,
                          homotopy(actual=actualStream(port_b2.h_outflow),
                                   simplified=port_b2.h_outflow),
                          homotopy(actual=actualStream(port_b2.Xi_outflow),
                            simplified=port_b2.Xi_outflow));

    else
      staA2=Medium2.setState_phX(port_a2.p,
                          actualStream(port_a2.h_outflow),
                          actualStream(port_a2.Xi_outflow));
      staB2=Medium2.setState_phX(port_b2.p,
                          actualStream(port_b2.h_outflow),
                          actualStream(port_b2.Xi_outflow));
    end if; // homotopyInitialization
  else // reverse flow not allowed
    staA2=Medium2.setState_phX(port_a2.p,
                             inStream(port_a2.h_outflow),
                             inStream(port_a2.Xi_outflow));
    staB2=Medium2.setState_phX(port_b2.p,
                             inStream(port_b2.h_outflow),
                             inStream(port_b2.Xi_outflow));
  end if;

  // Set temperatures that will be used to compute Carnot efficiency
  if effInpCon == Buildings.Fluid.Types.EfficiencyInput.volume then
    TCon = con.vol.heatPort.T;
  elseif effInpCon == Buildings.Fluid.Types.EfficiencyInput.port_a then
    TCon = Medium1.temperature(staA1);
  elseif effInpCon == Buildings.Fluid.Types.EfficiencyInput.port_b then
    TCon = Medium1.temperature(staB1);
  else
    TCon = 0.5 * (Medium1.temperature(staA1)+Medium1.temperature(staB1));
  end if;

  if effInpEva == Buildings.Fluid.Types.EfficiencyInput.volume then
    TEva = Medium2.temperature( Medium2.setState_phX(
      p=  eva.port_b.p,
      h=  eva.port_b.h_outflow,
      X=  cat(1, eva.port_b.Xi_outflow, {1-sum({eva.port_b.Xi_outflow})})));
  elseif effInpEva == Buildings.Fluid.Types.EfficiencyInput.port_a then
    TEva = Medium2.temperature(staA2);
  elseif effInpEva == Buildings.Fluid.Types.EfficiencyInput.port_b then
    TEva = Medium2.temperature(staB2);
  else
    TEva = 0.5 * (Medium2.temperature(staA2)+Medium2.temperature(staB2));
  end if;

  connect(eva.port_a, port_a2) annotation (Line(points={{10,-60},{56,-60},{100,-60}},
                 color={0,127,255}));
  connect(TSet, eva.TSet) annotation (Line(points={{-120,90},{-66,90},{40,90},{40,
          -54},{12,-54}}, color={0,0,127}));
  connect(port_a1, con.port_a)
    annotation (Line(points={{-100,60},{-56,60},{-10,60}}, color={0,127,255}));
  connect(con.port_b, port_b1)
    annotation (Line(points={{10,60},{100,60}},          color={0,127,255}));
  connect(eva.port_b, port_b2) annotation (Line(points={{-10,-60},{-56,-60},{-100,
          -60}}, color={0,127,255}));
  connect(eva.Q_flow, QEva_flow) annotation (Line(points={{-11,-54},{-40,-54},{-40,
          -90},{110,-90}}, color={0,0,127}));
  connect(QCon_flow_in.y, con.u) annotation (Line(points={{-39,72},{-28,72},{-28,
          66},{-12,66}}, color={0,0,127}));
  connect(PEle.y, P) annotation (Line(points={{81,80},{92,80},{92,90},{110,90}},
        color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},
            {100,100}}),       graphics={
        Rectangle(
          extent={{-72,80},{68,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,68},{58,50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,-52},{58,-70}},
          lineColor={0,0,0},
          fillColor={255,255,255},
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
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,0},{-52,10},{-32,10},{-42,0}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,50},{-40,10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,-12},{-40,-52}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{38,50},{42,-52}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{18,22},{62,-20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,22},{22,-10},{58,-10},{40,22}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-148,156},{-92,114}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="TEva"),
        Text(extent={{64,106},{114,92}},  textString="P",
          lineColor={0,0,127}),
        Line(points={{-100,90},{-82,90},{-82,-56}}, color={0,0,255}),
        Line(points={{0,-70},{0,-90},{100,-90}}, color={0,0,255}),
        Line(points={{62,0},{80,0},{80,90},{100,90}}, color={0,0,255})}),
defaultComponentName="chi",
Documentation(info="<html>
<p>
This is a model of a chiller whose coefficient of performance (COP) changes
with temperatures in the same way as the Carnot efficiency changes.
The control input is the setpoint of the evaporator leaving temperature, which
is met exactly at steady state if the chiller has sufficient capacity.
</p>
<p>
The COP at the nominal conditions can be specified by a parameter, or
it can be computed by the model based on the Carnot effectiveness, in which
case
</p>
<p align=\"center\" style=\"font-style:italic;\">
  COP<sub>0</sub> = &eta;<sub>car</sub> COP<sub>car</sub>
= &eta;<sub>car</sub> T<sub>eva</sub> &frasl; (T<sub>con</sub>-T<sub>eva</sub>),
</p>
<p>
where <i>T<sub>eva</sub></i> is the evaporator temperature
and <i>T<sub>con</sub></i> is the condenser temperature.
On the <code>Advanced</code> tab, a user can specify the temperature that
will be used as the evaporator (or condenser) temperature. The options
are the temperature of the fluid volume, of <code>port_a</code>, of
<code>port_b</code>, or the average temperature of <code>port_a</code> and
<code>port_b</code>.
</p>
<p>
The chiller COP is computed as the product
</p>
<p align=\"center\" style=\"font-style:italic;\">
  COP = &eta;<sub>car</sub> COP<sub>car</sub> &eta;<sub>PL</sub>,
</p>
<p>
where <i>&eta;<sub>car</sub></i> is the Carnot effectiveness,
<i>COP<sub>car</sub></i> is the Carnot efficiency and
<i>&eta;<sub>PL</sub></i> is a polynomial in the control signal <i>y</i>
that can be used to take into account a change in <i>COP</i> at part load
conditions.
This polynomial has the form
</p>
<p align=\"center\" style=\"font-style:italic;\">
  &eta;<sub>PL</sub> = a<sub>1</sub> + a<sub>2</sub> y + a<sub>3</sub> y<sup>2</sup> + ...
</p>
<p>
where <i>y &isin; [0, 1]</i> is the control input and the coefficients <i>a<sub>i</sub></i>
are declared by the parameter <code>a</code>.
</p>
<p>
On the <code>Dynamics</code> tag, the model can be parametrized to compute a transient
or steady-state response.
The transient response of the model is computed using a first
order differential equation for the evaporator and condenser fluid volumes.
The chiller outlet temperatures are equal to the temperatures of these lumped volumes.
</p>
<h4>Typical use and important parameters</h4>
<p>
When using this component, make sure that the condenser has sufficient mass flow rate.
Based on the evaporator mass flow rate, temperature difference and the efficiencies,
the model computes how much heat will be added to the condenser.
If the mass flow rate is too small, very high outlet temperatures can result.
</p>
<p>
The evaporator heat flow rate <code>QEva_flow_nominal</code> is used to assign
the default value for the mass flow rates, which are used for the pressure drop
calculations.
It is also used to compute the part load efficiency.
Hence, make sure that <code>QEva_flow_nominal</code> is set to a reasonable value.
</p>
<p>
The maximum cooling capacity is set by the parameter <code>QEva_flow_min</code>,
which is by default set to infinity.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 3, 2015 by Michael Wetter:<br/>
Expanded documentation.
</li>
<li>
May 6, 2015 by Michael Wetter:<br/>
Added <code>prescribedHeatFlowRate=true</code> for <code>vol2</code>.
</li>
<li>
October 9, 2013 by Michael Wetter:<br/>
Reimplemented the computation of the port states to avoid using
the conditionally removed variables <code>sta_a1</code>,
<code>sta_a2</code>, <code>sta_b1</code> and <code>sta_b2</code>.
</li>
<li>
May 10, 2013 by Michael Wetter:<br/>
Added electric power <code>P</code> as an output signal.
</li>
<li>
October 11, 2010 by Michael Wetter:<br/>
Fixed bug in energy balance.
</li>
<li>
March 3, 2009 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end Carnot_TEva;
