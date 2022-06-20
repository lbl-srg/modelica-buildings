within Buildings.Fluid.HydronicConfigurations.ActiveNetworks;
model SingleMixing "Single mixing circuit"
  extends BaseClasses.SingleMixing(
    final dpBal3_nominal=0);

  annotation (
    defaultComponentName="con",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Polygon(
          points={{-20,10},{-20,-10},{0,0},{20,-10},{20,10},{0,0},{-20,10}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={60,-60},
          rotation=90),
        Line(
          points={{-14,-1.71451e-15},{3.74941e-32,-6.12325e-16}},
          color={0,0,0},
          thickness=0.5,
          origin={46,-60},
          rotation=180),
        Line(
          points={{-20,-1.83696e-15},{3.74941e-32,-6.12325e-16}},
          color={0,0,0},
          thickness=0.5,
          origin={46,-70},
          rotation=270),
        Polygon(
          points={{34,34},{40,24},{46,34},{34,34}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          rotation=270,
          origin={-30,40}),
        Polygon(
          points={{54,-16},{60,-26},{66,-16},{54,-16}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
    Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Variable primary.
The primary pressure differential tends to decrease the bypass flow rate.
It is possible to reach zero bypass flow at partial valve opening and
a negative bypass flow for even lower opening values.
Therefore, a balancing valve in the bypass is not recommended as it 
would further reduce the bypass flow rate.
When using that model, one should keep the default setting
<code>dpBal3_nominal=0</code>&nbsp;Pa.
</p>
<p>
This is a typical configuration for constant flow secondary circuits that
have a design supply temperature identical to the primary circuit.

The control valve authority is equal to 
<i>&beta; = &Delta;p<sub>A-AB</sub> / (&Delta;p<sub>a1-b1</sub>
+ &Delta;p<sub>B-AB</sub></i>).
The valve is typically sized so that the design pressure drop in 
the direct branch <i>&Delta;p<sub>A-AB</sub></i> is close 
to the primary pressure differential <i>&Delta;p<sub>a1-b1</sub></i>,
which yields an authority close to <i>0.5</i>.
(Note that the authority does not depend on the primary balancing 
valve.)
</p>
<p>
The balancing procedure should ensure that the 
primary pressure differential is compensated for by the primary balancing valve.
Otherwise, the flow may reverse in the bypass branch and the mixing function of
the three-way valve cannot be achieved.
Valve authority <i>&beta; = Δp_V / (Δp1 + Δp_Vbyp)</i> 
(independent of the balancing valve pressure drop).
For good authority <i>Δp_V ~ Δp1</i> which must be compensated for 
by the secondary pump
in the case where the primary pressure differential is cancelled by
the primary balancing valve. 
</p>
<h4>
Parameterization
</h4>
<p>
By default the secondary pump is parameterized with 
<code>m2_flow_nominal</code> and 
<code>dp2_nominal + dpBal2_nominal + max({val.dpValve_nominal, val.dp3Valve_nominal})</code> 
at maximum speed.
The partner valve <code>bal2</code> is therefore configured with zero
pressure drop.
</p>
</html>"));
end SingleMixing;
