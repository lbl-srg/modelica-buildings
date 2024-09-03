within Buildings.Fluid.HeatExchangers.ActiveBeams;
model CoolingAndHeating "Active beam unit for heating and cooling"
  extends Buildings.Fluid.HeatExchangers.ActiveBeams.Cooling(sum(nin=2));

  replaceable parameter Data.Generic perHea "Performance data for heating"
    annotation (
      Dialog(group="Nominal condition"),
      choicesAllMatching=true,
      Placement(transformation(extent={{62,-98},{78,-82}})));

  // Initialization
  parameter MediumWat.AbsolutePressure pWatHea_start = pWatCoo_start
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization", group = "Heating"));

  parameter MediumWat.Temperature TWatHea_start = TWatCoo_start
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization", group = "Heating"));

  Modelica.Fluid.Interfaces.FluidPort_a watHea_a(
    redeclare final package Medium = MediumWat,
    m_flow(min=if allowFlowReversalWat then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumWat.h_default))
    "Fluid connector a (positive design flow direction is from watHea_a to watHea_b)"
    annotation (Placement(transformation(extent={{-150,-10},{-130,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b watHea_b(
    redeclare final package Medium = MediumWat,
    m_flow(max=if allowFlowReversalWat then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumWat.h_default))
    "Fluid connector b (positive design flow direction is from watHea_a to watHea_b)"
    annotation (Placement(transformation(extent={{150,-10},{130,10}})));

  MediumWat.ThermodynamicState staHea_a=
      MediumWat.setState_phX(watHea_a.p,
                          noEvent(actualStream(watHea_a.h_outflow)),
                          noEvent(actualStream(watHea_a.Xi_outflow)))
      if show_T "Medium properties in port watHea_a";

  MediumWat.ThermodynamicState staHea_b=
      MediumWat.setState_phX(watHea_b.p,
                          noEvent(actualStream(watHea_b.h_outflow)),
                          noEvent(actualStream(watHea_b.Xi_outflow)))
       if show_T "Medium properties in port watHea_b";

  Modelica.Units.SI.PressureDifference dpWatHea(displayUnit="Pa") = watHea_a.p
     - watHea_b.p "Pressure difference between watHea_a and watHea_b";

protected
  BaseClasses.Convector conHea(
    redeclare final package Medium = MediumWat,
    final per=perHea,
    final allowFlowReversal=allowFlowReversalWat,
    final m_flow_small=mWat_flow_small,
    final show_T=false,
    final homotopyInitialization=homotopyInitialization,
    final from_dp=from_dpWat,
    final linearizeFlowResistance=linearizeFlowResistanceWat,
    final deltaM=deltaMWat,
    final tau=tau,
    final energyDynamics=energyDynamics,
    final p_start=pWatHea_start,
    final T_start=TWatHea_start,
    final nBeams=nBeams) "Heating beam"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

initial equation
  assert(perHea.primaryAir.r_V[1]<=0.000001 and perHea.primaryAir.f[1]<=0.00001,
    "Performance curve perHea.primaryAir must pass through (0,0).");
  assert(perHea.water.r_V[1]<=0.000001      and perHea.water.f[1]<=0.00001,
    "Performance curve perHea.water must pass through (0,0).");
  assert(perHea.dT.r_dT[1]<=0.000001        and perHea.dT.f[1]<=0.00001,
    "Performance curve perHea.dT must pass through (0,0).");

equation
  connect(conHea.port_b, watHea_b)
    annotation (Line(points={{10,0},{140,0}}, color={0,127,255}));
  connect(conHea.Q_flow, sum.u[2])
    annotation (Line(points={{11,7},{20,7},{20,30},{38,30}}, color={0,0,127}));
  connect(conHea.TRoo, senTemRooAir.T) annotation (Line(points={{-12,-6},{-26,-6},
          {-50,-6},{-50,-40},{-41,-40}}, color={0,0,127}));
  connect(watHea_a, conHea.port_a)
    annotation (Line(points={{-140,0},{-76,0},{-10,0}}, color={0,127,255}));
  connect(conHea.mAir_flow, senFloAir.m_flow) annotation (Line(points={{-12,4},
          {-46,4},{-90,4},{-90,-49}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -120},{140,120}})), defaultComponentName="beaCooHea",Icon(
        coordinateSystem(extent={{-140,-120},{140,120}}),             graphics={
        Rectangle(
          extent={{-120,6},{-138,-6}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{138,6},{120,-6}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,-34},{0,-80}},
          fillColor={255,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{0,-34},{64,-80}},
          fillColor={0,128,255},
          fillPattern=FillPattern.VerticalCylinder,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Line(points={{-112,0},{-66,0},{-82,10}}, color={255,0,0}),
        Line(points={{-66,0},{-82,-8}}, color={255,0,0})}),
          Documentation(info="<html>
<p>
This model is identical to
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ActiveBeams.Cooling\">
Buildings.Fluid.HeatExchangers.ActiveBeams.Cooling</a>,
except that an additional water stream and convector is added to allow for heating
in addition to cooling.
</p>
<p>
For a description of the equations, see the
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ActiveBeams.UsersGuide\">
User's Guide</a>.
</p>
<p>
Performance data are available from
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ActiveBeams.Data\">
Buildings.Fluid.HeatExchangers.ActiveBeams.Data</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 14, 2016, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
May 20, 2016, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul>
</html>"));
end CoolingAndHeating;
