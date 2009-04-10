within Buildings.Fluids.Chillers;
model Carnot
  "Chiller with performance curve adjusted based on Carnot efficiency"
 extends Interfaces.PartialDynamicFourPortTransformer(
     redeclare Buildings.Fluids.MixingVolumes.MixingVolumeDryAir vol2(redeclare
        package Medium = Medium2,
     nPorts=2, V=m2_flow_nominal*tau2/rho2_nominal,
     final use_HeatTransfer=true,
     redeclare model HeatTransfer = 
          Modelica_Fluid.Vessels.BaseClasses.HeatTransfer.IdealHeatTransfer (
             surfaceAreas={1})),
     m1_flow_nominal=P_nominal*(COP_nominal+1)/abs(dTCon_nominal)/cp1_nominal,
     m2_flow_nominal=P_nominal*COP_nominal/abs(dTEva_nominal)/cp2_nominal);

  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={
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
          extent={{-144,146},{-88,104}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="y")}), Diagram(graphics),
    Documentation(info="<html>
This is model of a chiller whose coefficient of performance (COP) changes
with temperatures in the same way as the Carnot efficiency changes.
The COP at the nominal conditions can be specified by a parameter, or
it can be computed by the model based on the Carnot effectiveness, in which
case
<pre>
  COP_nominal = etaCar * COPCar
 
                             TEva
              = etaCar * -----------,
                          TCon-TEva
</pre>
where <tt>TEva</tt> is the evaporator temperature and <tt>TCon</tt> is
the condenser temperature.
On the Advanced tab, a user can specify what temperature should
be used as the evaporator (or condenser) temperature. The options
are the temperature of the fluid volume, of <tt>port_a</tt>, of
<tt>port_b</tt>, or the average temperature of <tt>port_a</tt> and
<tt>port_b</tt>.
</p>
<p>
The chiller COP is computed as the product
<pre>
  COP = etaCar * COPCar * etaPL,
</pre>
where <tt>etaCar</tt> is the Carnot effectiveness, 
<tt>COPCar</tt> is the Carnot efficiency and
<tt>etaPL</tt> is a polynomial in the control signal <tt>y</tt>
that can be used to take into account a change in COP at part load 
conditions.
</p>
<p>
On the Assumptions tag, the model can be parametrized to compute a transient
or steady-state response.
The transient response of the boiler is computed using a first
order differential equation for the evaporator and condenser fluid volumes.
The chiller outlet temperatures are equal to the temperatures of these lumped volumes.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 3, 2009 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  parameter Buildings.Fluids.Types.EfficiencyInput effInpEva=
    Buildings.Fluids.Types.EfficiencyInput.volume
    "Temperatures of evaporator fluid used to compute Carnot efficiency" 
    annotation (Dialog(tab="Advanced", group="Temperature dependence"));
  parameter Buildings.Fluids.Types.EfficiencyInput effInpCon=
    Buildings.Fluids.Types.EfficiencyInput.port_a
    "Temperatures of condenser fluid used to compute Carnot efficiency" 
    annotation (Dialog(tab="Advanced", group="Temperature dependence"));
  parameter Modelica.SIunits.Power P_nominal
    "Nominal compressor power (at y=1)" 
    annotation (Dialog(group="Nominal condition"));
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

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaFloCon
    "Prescribed heat flow rate" 
    annotation (Placement(transformation(extent={{-39,-50},{-19,-30}})));
  Modelica.Blocks.Sources.RealExpression QCon_flow_in(y=QCon_flow)
    "Condenser heat flow rate" 
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Modelica.Blocks.Sources.RealExpression QEva_flow_in(y=QEva_flow)
    "Evaporator heat flow rate" 
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaFloEva
    "Prescribed heat flow rate" 
    annotation (Placement(transformation(extent={{-39,30},{-19,50}})));
  Modelica.Blocks.Interfaces.RealInput y(min=0, max=1) "Part load ratio" 
    annotation (Placement(transformation(extent={{-140,70},{-100,110}},
          rotation=0)));
  Real etaPL "Efficiency due to part load of compressor (etaPL(y=1)=1";
  Real COP(min=0) "Coefficient of performance";
  Real COPCar(min=0) "Carnot efficiency";
  Modelica.SIunits.HeatFlowRate QCon_flow "Condenser heat input";
  Modelica.SIunits.HeatFlowRate QEva_flow "Evaporator heat input";
  Modelica.SIunits.Power P "Compressor power";
  Modelica.SIunits.Temperature TCon
    "Condenser temperature used to compute efficiency";
  Modelica.SIunits.Temperature TEva
    "Evaporator temperature used to compute efficiency";
protected
   parameter Modelica.SIunits.SpecificHeatCapacity cp1_nominal=Medium1.specificHeatCapacityCp(sta1_nominal)
    "Specific heat capacity of fluid 1";
   parameter Modelica.SIunits.SpecificHeatCapacity cp2_nominal=Medium2.specificHeatCapacityCp(sta2_nominal)
    "Specific heat capacity of fluid 2";

initial equation
  if use_eta_Carnot then
    COP_nominal = etaCar * TEva_nominal/(TCon_nominal-TEva_nominal);
  else
    etaCar = COP_nominal / (TEva_nominal/(TCon_nominal-TEva_nominal));
  end if;
  assert(abs(Buildings.Utilities.Math.Functions.polynomial(
                                                     a=a, x=y)-1) < 0.01, "Efficiency curve is wrong. Need etaPL(y=1)=1.");
  assert(etaCar > 0.1, "Parameters lead to etaCar < 0.1. Check parameters.");
  assert(etaCar < 1,   "Parameters lead to etaCar > 1. Check parameters.");
equation
  // Set temperatures that will be used to compute Carnot efficiency
  if effInpCon == Buildings.Fluids.Types.EfficiencyInput.volume then
    TCon = vol1.heatPort.T;
  elseif effInpCon == Buildings.Fluids.Types.EfficiencyInput.port_a then
    TCon = Medium1.temperature(sta_a1);
  elseif effInpCon == Buildings.Fluids.Types.EfficiencyInput.port_b then
    TCon = Medium1.temperature(sta_b1);
  else
    TCon = 0.5 * (Medium1.temperature(sta_a1)+Medium1.temperature(sta_b1));
  end if;

  if effInpEva == Buildings.Fluids.Types.EfficiencyInput.volume then
    TEva = vol2.heatPort.T;
  elseif effInpEva == Buildings.Fluids.Types.EfficiencyInput.port_a then
    TEva = Medium2.temperature(sta_a2);
  elseif effInpEva == Buildings.Fluids.Types.EfficiencyInput.port_b then
    TEva = Medium2.temperature(sta_b2);
  else
    TEva = 0.5 * (Medium2.temperature(sta_a2)+Medium2.temperature(sta_b2));
  end if;

  etaPL  = Buildings.Utilities.Math.Functions.polynomial(
                                                   a=a, x=y);
  P = y * P_nominal;
  COPCar = TEva / max(1, abs(TCon-TEva));
  COP = etaCar * COPCar * etaPL;
  -QEva_flow = COP * P;
  0 = P + QEva_flow + QCon_flow;

  connect(QCon_flow_in.y, preHeaFloCon.Q_flow) annotation (Line(
      points={{-59,-40},{-39,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QEva_flow_in.y, preHeaFloEva.Q_flow) annotation (Line(
      points={{-59,40},{-39,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preHeaFloEva.port, vol1.heatPort) annotation (Line(
      points={{-19,40},{-10,40},{-10,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preHeaFloCon.port, vol2.heatPort) annotation (Line(
      points={{-19,-40},{30,-40},{30,-60},{12,-60}},
      color={191,0,0},
      smooth=Smooth.None));
end Carnot;
