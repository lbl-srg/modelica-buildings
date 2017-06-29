within Buildings.Experimental.OpenBuildingControl.CDL.Logical;
block MultiAnd
  "Logical 'MultiAnd': y = u1 and u2 and u3 and ..."

  parameter Integer nu(min=0) = 0 "Number of input connections"
    annotation (Dialog(connectorSizing=true), HideResult=true);
  Interfaces.BooleanInput u[nu]
    annotation (Placement(transformation(extent={{-120,70},{-80,-70}})));
  Interfaces.BooleanOutput y
    annotation (Placement(transformation(extent={{100,-17},{134,17}})));

protected
  Boolean uTemp[nu];

equation
  if size(u, 1) > 1 then
    uTemp[1] = u[1];
    for i in 2:size(u, 1) loop
      uTemp[i] = u[i] and uTemp[i-1];
    end for;
    y = uTemp[nu];
  elseif (size(u, 1) > 0) and (size(u, 1) < 2) then
    y = u[1];
  else
    y = false;
  end if;

  annotation (
  defaultComponentName="mulAnd",
  Icon(graphics={   Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-144,150},{156,110}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{-62,52},{74,-52}},
          lineColor={0,0,0},
          textString="AND")}),
    Documentation(info="<html>
<p>
This blocks computes the Boolean output \"y\" as <code>true</true> when the 
elements of the Boolean input signal vector u are <code>true</code>, otherwise, 
the output is <code>false</code>:
</p>
<blockquote><pre>
y = AND(u[1], u[2], u[3], ......);
</pre></blockquote>

<p>
The input connector is a vector of Boolean input signals.
When a connection line is drawn, the dimension of the input
vector is enlarged by one and the connection is automatically
connected to this new free index (thanks to the
connectorSizing annotation).
</p>

<p>
The usage is demonstrated, e.g., in example
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Logical.Validation.MultiAnd\">
Buildings.Experimental.OpenBuildingControl.CDL.Logical.Validation.MultiAnd</a>.
</p>

<p>
If no connection to the input connector \"u\" is present,
the output is set to <code>false</code>: <code>y=false</code>.
</p>

</html>",
revisions="<html>
<ul>
<li>
June 28, 2017, by Jianjun Hu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/825\">issue 825</a>.
</li>
</ul>
</html>"));
end MultiAnd;
