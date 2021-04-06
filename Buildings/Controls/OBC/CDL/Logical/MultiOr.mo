within Buildings.Controls.OBC.CDL.Logical;
block MultiOr
  "Logical MultiOr, y = u[1] or u[2] or u[3] or ..."
  parameter Integer nu(
    min=0)=0
    "Number of input connections"
    annotation (Dialog(connectorSizing=true),HideResult=true);
  Interfaces.BooleanInput u[nu]
    "Connector of Boolean input signals"
    annotation (Placement(transformation(extent={{-140,70},{-100,-70}})));
  Interfaces.BooleanOutput y
    "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  Boolean uTemp[nu]
    "Temporary variable";

equation
  if size(
    u,
    1) > 1 then
    uTemp[1]=u[1];
    for i in 2:size(
      u,
      1) loop
      uTemp[i]=u[i] or uTemp[i-1];
    end for;
    y=uTemp[nu];
  elseif(size(
    u,
    1) == 1) then
    uTemp[1]=u[1];
    y=uTemp[1];
  else
    y=false;
  end if;
  annotation (
    defaultComponentName="mulOr",
    Icon(
      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=5.0,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Text(
          extent={{-144,150},{156,110}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{-80,52},{56,-52}},
          lineColor={0,0,0},
          textString="OR"),
        Ellipse(
          extent={{71,7},{85,-7}},
          lineColor=DynamicSelect({235,235,235},
            if y then
              {0,255,0}
            else
              {235,235,235}),
          fillColor=DynamicSelect({235,235,235},
            if y then
              {0,255,0}
            else
              {235,235,235}),
          fillPattern=FillPattern.Solid)}),
    Documentation(
      info="<html>
<p>
Block that outputs <code>y = true</code> if any element in the input 
vector <code>u</code> is <code>true</code>.
If no connection to the input connector <code>u</code> is present,
the output is <code>y=false</code>.
</p>
<p>
See
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.Validation.MultiOr\">
Buildings.Controls.OBC.CDL.Logical.Validation.MultiOr</a>
for an example.
</p>
</html>",
      revisions="<html>
<ul>
<li>
June 6, 2019, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end MultiOr;
