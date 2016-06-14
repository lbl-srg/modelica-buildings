within Buildings.Fluid.HeatExchangers.ActiveBeams;
model CoolingAndHeating "model of an active beam unit for heating and cooling"

  extends Buildings.Fluid.HeatExchangers.ActiveBeams.Cooling(sum(nin=2));

  replaceable parameter Buildings.Fluid.HeatExchangers.ActiveBeams.Data.Generic
    per_hea "Record with performance data" annotation (
    Dialog(group="Parameters"),
    choicesAllMatching=true,
    Placement(transformation(extent={{40,-92},{60,-72}})));

  parameter Boolean allowFlowReversal = true
    "= true to allow flow reversal, false restricts to design direction (watHea_a -> watHea_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Modelica.SIunits.MassFlowRate mWatHea_flow_nominal
    "Water nominal mass flow rate for heating"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0) = 1E-4*abs(mWatHea_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));

  // Diagnostics
  parameter Boolean show_T = false
    "= true, if actual temperature at port is computed"
    annotation(Dialog(tab="Advanced",group="Diagnostics"));

  BaseClasses.Convector conHea(
    redeclare final package Medium = Medium1,
    final m_flow_nominal=mWatCoo_flow_nominal,
    hex(Q_flow_nominal=-per_hea.Q_flow_nominal),
    mod(
      airFlo_nom(k=1/per_hea.mAir_flow_nominal),
      watFlo_nom(k=1/per_hea.mWat_flow_nominal),
      temDif_nom(k=1/per_hea.dT_nominal),
      airFlo_mod(xd=per_hea.primaryAir.r_V, yd=per_hea.primaryAir.f),
      watFlo_mod(xd=per_hea.water.r_V, yd=per_hea.water.f),
      temDif_mod(xd=per_hea.dT.Normalized_TempDiff, yd=per_hea.dT.f)))
    "Heating beam"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Modelica.Fluid.Interfaces.FluidPort_a watHea_a(
    redeclare final package Medium = Medium1,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium1.h_default))
    "Fluid connector a (positive design flow direction is from watHea_a to watHea_b)"
    annotation (Placement(transformation(extent={{-150,-10},{-130,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b watHea_b(
    redeclare final package Medium = Medium1,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium1.h_default))
    "Fluid connector b (positive design flow direction is from watHea_a to watHea_b)"
    annotation (Placement(transformation(extent={{150,-10},{130,10}})));

  Modelica.SIunits.MassFlowRate m_flow(start=0) = watHea_a.m_flow
    "Mass flow rate from watHea_a to watHea_b (m_flow > 0 is design flow direction)";
  Modelica.SIunits.PressureDifference dp(start=0, displayUnit="Pa")
    "Pressure difference between watHea_a and watHea_b";

  Medium1.ThermodynamicState sta_a=
      Medium1.setState_phX(watHea_a.p,
                          noEvent(actualStream(watHea_a.h_outflow)),
                          noEvent(actualStream(watHea_a.Xi_outflow))) if
         show_T "Medium properties in watHea_a";

  Medium1.ThermodynamicState sta_b=
      Medium1.setState_phX(watHea_b.p,
                          noEvent(actualStream(watHea_b.h_outflow)),
                          noEvent(actualStream(watHea_b.Xi_outflow))) if
          show_T "Medium properties in watHea_b";

  Sensors.MassFlowRate senFlo2(redeclare final package Medium = Medium1)
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Math.Gain gai_4(k=1/nBeams) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,30})));
equation
  dp = watHea_a.p - watHea_b.p;
         assert( conHea.mod.airFlo_mod.xd[1]<=0.000001 and conHea.mod.airFlo_mod.yd[1]<=0.00001, "performance curve has to pass through (0,0)");

        assert( conHea.mod.watFlo_mod.xd[1]<=0.000001 and conHea.mod.watFlo_mod.yd[1]<=0.00001, "performance curve has to pass through (0,0)");

       assert( conHea.mod.temDif_mod.xd[1]<=0.000001 and conHea.mod.temDif_mod.yd[1]<=0.00001, "performance curve has to pass through (0,0)");
  connect(conHea.port_b, watHea_b)
    annotation (Line(points={{10,0},{140,0}}, color={0,127,255}));
  connect(conHea.Q_flow, sum.u[2])
    annotation (Line(points={{11,7},{20,7},{20,30},{38,30}}, color={0,0,127}));
  connect(watHea_a, senFlo2.port_a)
    annotation (Line(points={{-140,0},{-120,0}}, color={0,127,255}));
  connect(senFlo2.port_b, conHea.port_a)
    annotation (Line(points={{-100,0},{-100,0},{-10,0}}, color={0,127,255}));
  connect(gai_4.y, conHea.mWat_flow) annotation (Line(points={{-59,30},{-28,30},
          {-28,9},{-12,9}}, color={0,0,127}));
  connect(conHea.mAir_flow, gai_1.y)
    annotation (Line(points={{-12,4},{-90,4},{-90,-19}}, color={0,0,127}));
  connect(senFlo2.m_flow, gai_4.u)
    annotation (Line(points={{-110,11},{-110,30},{-82,30}}, color={0,0,127}));
  connect(conHea.TRoo, senTem.T) annotation (Line(points={{-12,-6},{-26,-6},{-50,
          -6},{-50,-40},{-40,-40}}, color={0,0,127}));
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
          fillPattern=FillPattern.Solid)}),
          Documentation(info="<html>
<p>
This model is similar to <a href=\"modelica://Buildings.Fluid.HeatExchangers.ActiveBeams.Cooling\">Buildings.Fluid.HeatExchangers.ActiveBeams.Cooling</a>. An additional fluid stream is added to allow for
the heating mode.
<p>
In this model, the temperature difference <i><code>&#916;</code>T</i> used for the calculation of the modification factor <i>f<sub><code>&#916;</code>T</sub>( )</i> is:
<p align=\"center\" style=\"font-style:italic;\">
     <code>&#916;</code>T = T<sub>HW</sub>-T<sub>Z</sub>
      <p> 
      where <i>T<sub>HW</sub> </i> is the hot water temperature entering the convector in heating mode and <i>T<sub>Z</sub></i> is the zone air temperature.
   <p>

</html>"));
end CoolingAndHeating;
