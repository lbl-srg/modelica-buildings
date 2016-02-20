within Buildings.Fluid.Movers.BaseClasses;
partial model SpeedControlled
  "Partial model for fan or pump with speed (y or Nrpm) as input signal"
 extends Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine(
     final m_flow_nominal = max(_per_y.pressure.V_flow)*rho_default,
     heaDis(final delta_V_flow=1E-3*V_flow_max,
            final motorCooledByFluid = _per_y.motorCooledByFluid),
     preSou(final control_m_flow=false));

  // Normalized speed
  Modelica.Blocks.Interfaces.RealOutput y_actual(min=0,
                                                 final unit="1")
    annotation (Placement(transformation(extent={{100,40},{120,60}}),
        iconTransformation(extent={{100,40},{120,60}})));

  Modelica.SIunits.VolumeFlowRate VMachine_flow = eff.V_flow "Volume flow rate";
  Modelica.SIunits.PressureDifference dpMachine(displayUnit="Pa")=
      -dpMac.y "Pressure difference";

  Modelica.SIunits.Efficiency eta =    eff.eta "Global efficiency";
  Modelica.SIunits.Efficiency etaHyd = eff.etaHyd "Hydraulic efficiency";
  Modelica.SIunits.Efficiency etaMot = eff.etaMot "Motor efficiency";

protected
  replaceable parameter Data.SpeedControlled_y _per_y
    constrainedby Data.SpeedControlled_y "Record with performance data"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{62,70},{82,90}})));

  final parameter Integer nOri = size(_per_y.pressure.V_flow, 1)
    "Number of data points for pressure curve"
    annotation(Evaluate=true);

  final parameter Boolean haveVMax = (abs(_per_y.pressure.dp[nOri]) < Modelica.Constants.eps)
    "Flag, true if user specified data that contain V_flow_max";

  final parameter Modelica.SIunits.VolumeFlowRate V_flow_max=
    if haveVMax then
      _per_y.pressure.V_flow[nOri]
     else
      _per_y.pressure.V_flow[nOri] - (_per_y.pressure.V_flow[nOri] - _per_y.pressure.V_flow[
      nOri - 1])/((_per_y.pressure.dp[nOri] - _per_y.pressure.dp[nOri - 1]))*_per_y.pressure.dp[nOri]
    "Maximum volume flow rate, used for smoothing";
  Modelica.Blocks.Continuous.Filter filter(
     order=2,
     f_cut=5/(2*Modelica.Constants.pi*riseTime),
     final init=init,
     final y_start=y_start,
     x(each stateSelect=StateSelect.always),
     u_nominal=1,
     u(final unit="1"),
     y(final unit="1"),
     final analogFilter=Modelica.Blocks.Types.AnalogFilter.CriticalDamping,
     final filterType=Modelica.Blocks.Types.FilterType.LowPass) if
        filteredSpeed
    "Second order filter to approximate valve opening time, and to improve numerics"
    annotation (Placement(transformation(extent={{20,81},{34,95}})));

  Modelica.Blocks.Math.Gain gaiSpe(y(final unit="1")) if
       inputType == Buildings.Fluid.Types.InputType.Continuous
    "Gain to normalized speed using speed_nominal or speed_rpm_nominal"
    annotation (Placement(transformation(extent={{-4,74},{-16,86}})));

  FlowMachineInterface eff(
    redeclare final parameter Data.SpeedControlled_y per = _per_y,
    final nOri = nOri,
    final rho_default=rho_default,
    final haveVMax=haveVMax,
    final V_flow_max=V_flow_max,
    r_N(start=y_start),
    r_V(start=m_flow_nominal/rho_default)) "Flow machine"
    annotation (Placement(transformation(extent={{-30,-60},{-10,-40}})));

  Modelica.Blocks.Math.Gain dpMac(final k=-1)
    "Pressure drop of the pump or fan"
   annotation (Placement(transformation(extent={{20,20},{40,40}})));

equation
  if filteredSpeed then
    connect(filter.y, y_actual) annotation (Line(points={{34.7,88},{40.7,88},{
            40.7,50},{110,50}},       color={0,0,127}));
  else
    connect(inputSwitch.y, y_actual)
      annotation (Line(points={{1,50},{110,50}}, color={0,0,127}));
  end if;

 connect(preSou.dp_in, dpMac.y) annotation (Line(
     points={{56,8},{56,30},{41,30}},
     color={0,0,127}));
  connect(inputSwitch.y, filter.u) annotation (Line(points={{1,50},{10,50},{10,
          88},{18.6,88}}, color={0,0,127}));
  connect(y_actual, eff.y_actual) annotation (Line(points={{110,50},{72,50},{72,
          -30},{-38,-30},{-38,-44},{-32,-44}},    color={0,0,127}));
  connect(heaDis.etaHyd, eff.etaHyd) annotation (Line(points={{18,-40},{0,-40},{
          0,-42},{0,-48},{0,-55},{-9,-55}},        color={0,0,127}));
  connect(heaDis.V_flow, eff.V_flow) annotation (Line(points={{18,-46},{-4,-46},
          {-4,-42},{-9,-42},{-9,-42.2}},
                                     color={0,0,127}));
  connect(eff.PEle, heaDis.PEle) annotation (Line(points={{-9,-49},{14,-49},{14,
          -60},{18,-60}}, color={0,0,127}));
  connect(eff.WFlo, heaDis.WFlo) annotation (Line(points={{-9,-47},{-6,-47},{-6,
          -54},{18,-54}}, color={0,0,127}));
  connect(eff.dp, dpMac.u) annotation (Line(points={{-9,-44},{12,-44},{12,-20},{
          12,30},{18,30}},                        color={0,0,127}));
  connect(rho_inlet.y, eff.rho) annotation (Line(points={{-73,-50},{-73,-50},{-36,
          -50},{-32,-50}},                color={0,0,127}));
  connect(eff.m_flow, senMasFlo.m_flow) annotation (Line(points={{-32,-56},{-60,
          -56},{-60,-18},{-60,-11}},               color={0,0,127}));
  connect(eff.PEle, P) annotation (Line(points={{-9,-49},{14,-49},{14,-34},{92,-34},
          {92,80},{110,80}}, color={0,0,127}));
  connect(eff.PEle, PToMed.u2) annotation (Line(points={{-9,-49},{14,-49},{14,-76},
          {48,-76}}, color={0,0,127}));
 annotation (
   Documentation(info="<html>
<p>
Partial model for fans and pumps that take as
input a control signal in the form of the pump speed <code>Nrpm</code>
or the normalized pump speed.
</p>
</html>",
     revisions="<html>
<ul>
<li>
February 19, 2016, by Michael Wetter:<br/>
Refactored model to make implementation clearer.
This is for
<a href=\"https://github.com/iea-annex60/modelica-annex60/issues/417\">#417</a>.
</li>
<li>
November 19, 2015, by Michael Wetter:<br/>
Switched the two <code>extends</code> statements to get the
inherited graphic objects on the correct layer.
</li>      
<li>
October 8, 2013, by Michael Wetter:<br/>
Removed parameter <code>show_V_flow</code>.
</li>
<li>
May 25, 2011, by Michael Wetter:<br/>
Revised implementation of energy balance to avoid having to use conditionally removed models.
</li>
<li>
July 27, 2010, by Michael Wetter:<br/>
Redesigned model to fix bug in medium balance.
</li>
<li>March 24 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})));
end SpeedControlled;
