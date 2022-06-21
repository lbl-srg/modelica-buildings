within Buildings.Fluid.HydronicConfigurations.PassiveNetworks;
model SingleMixing "Single mixing circuit"
  extends BaseClasses.SingleMixing(
    dpValve_nominal=3e3,
    final dpBal1_nominal=0);

  annotation (
    defaultComponentName="con",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Polygon(
          points={{34,34},{40,24},{46,34},{34,34}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          rotation=270,
          origin={10,40}),
        Polygon(
          points={{54,-50},{60,-60},{66,-50},{54,-50}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-20,10},{-20,-10},{0,0},{20,-10},{20,10},{0,0},{-20,10}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          rotation=180,
          visible=dpBal3_nominal > 0),
        Line(
          points={{-20,-1.83696e-15},{3.74941e-32,-6.12325e-16}},
          color={0,0,0},
          thickness=0.5,
          rotation=180,
          origin={-10,14},
          visible=dpBal3_nominal > 0),
        Line(
          points={{-14,-1.71451e-15},{3.74941e-32,-6.12325e-16}},
          color={0,0,0},
          thickness=0.5,
          rotation=270,
          visible=dpBal3_nominal > 0)}),
    Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Variable primary
</p>
    
<p>
This is a typical configuration for constant flow secondary circuits that
have a design supply temperature identical to the primary circuit.
The control valve should be sized with a pressure drop at least equal to the
maximum of <i>&Delta;p<sub>a1-b1</sub></i> and <i>3e3</i>&nbsp;Pa.
Its authority is 
<i>&beta; = &Delta;p<sub>A-AB</sub> / 
(&Delta;p<sub>A-AB</sub> + &Delta;p<sub>a1-b1</sub>)</i>.
</p>
<p>
In most cases the bypass balancing valve is not needed.
However, it may be needed to counter negative back pressure
created by other served circuits.
</p>
<h4>
Parameterization
</h4>
<p>
By default the secondary pump is parameterized with 
<code>m2_flow_nominal</code> and 
<code>dp2_nominal + dpBal2_nominal + max({val.dpValve_nominal, val.dp3Valve_nominal}) + dpBal3_nominal</code>   
at maximum speed.
</p>
</html>"));

end SingleMixing;
