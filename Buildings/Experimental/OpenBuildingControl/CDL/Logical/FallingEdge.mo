within Buildings.Experimental.OpenBuildingControl.CDL.Logical;
block FallingEdge
  "Output y is true, if the input u has a falling edge (y = edge(not u))"

  parameter Boolean pre_u_start=false "Start value of pre(u) at initial time";
  extends Modelica.Blocks.Interfaces.partialBooleanSISO;

protected
  Boolean not_u=not u;
initial equation
  pre(not_u) = not pre_u_start;
equation
  y = edge(not_u);
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={Text(
          extent={{-90,40},{90,-40}},
          lineColor={0,0,0},
          textString="falling")}), Documentation(info="<html>
<p>
The output is <code>true</code> if the Boolean input has a falling edge
from <code>true</code> to <code>false</code>, otherwise
the output is <code>false</code>.
</p>
</html>"));
end FallingEdge;
